/**
 * Business module configation
 */

const pathSep = require('path').sep;
const plaformModules = require('./multibundler/platformNameMap.json');
const getModuleId = require('./multibundler/getModuleId').getModuleId;
const useIndex = require('./multibundler/getModuleId').useIndex;

/**
 * @type {string}
 * Entry file business module
 */
let entry;

/**
 * Filtering module
 * @param {string} module - module source
 * @return {bool} - module will be filterred
 */
function postProcessModulesFilter(module) {
  const projectRootPath = __dirname;
  if (plaformModules == null || plaformModules.length === 0) {
    process.exit(1);
    return false;
  }
  const path = module['path'];
  if (
    path.indexOf('__prelude__') >= 0 ||
    path.indexOf('/node_modules/react-native/Libraries/polyfills') >= 0 ||
    path.indexOf('source-map') >= 0 ||
    path.indexOf('/node_modules/metro/src/lib/polyfills/') >= 0
  ) {
    return false;
  }
  if (module['path'].indexOf(pathSep + 'node_modules' + pathSep) > 0) {
    if (
      'js' + pathSep + 'script' + pathSep + 'virtual' ==
      module['output'][0]['type']
    ) {
      return true;
    }
    const name = getModuleId(projectRootPath, path);
    if (useIndex && name < 100000) {
      return false;
    } else if (useIndex !== true && plaformModules.includes(name)) {
      return false;
    }
  }
  return true;
}

/**
 * Create module id
 * @return {string} module name
 */
function createModuleIdFactory() {
  const projectRootPath = __dirname;
  return (path) => {
    const name = getModuleId(projectRootPath, path, entry, true);
    return name;
  };
}

/**
 * Get entry file path
 * @param {string} entryFilePath - entry file path
 * @return {[]}
 */
function getModulesRunBeforeMainModule(entryFilePath) {
  entry = entryFilePath;
  return [];
}

module.exports = {
  serializer: {
    createModuleIdFactory,
    processModuleFilter: postProcessModulesFilter,
    getModulesRunBeforeMainModule
  }
};
