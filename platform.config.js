/**
 * Basic module configuraion
 */

const pathSep = require('path').sep;
const fs = require('fs');
const moduleMapDir = 'multibundler';
const getModuleId = require('./multibundler/getModuleId').getModuleId;
const useIndex = require('./multibundler/getModuleId').useIndex;
let entry = 'platformDep.js';

/**
 * Create module id
 * @return {string} module name
 */
function createModuleIdFactory() {
  const projectRootPath = __dirname;
  return (path) => {
    let name = getModuleId(projectRootPath, path, entry, false);
    if (useIndex !== true) {
      const platfromNameArray = require('./multibundler/platformNameMap.json');
      if (!platfromNameArray.includes(name)) {
        platfromNameArray.push(name);
        const platformMapDir = __dirname + pathSep + moduleMapDir;
        const platformMapPath =
          platformMapDir + pathSep + 'platformNameMap.json';
        fs.writeFileSync(platformMapPath, JSON.stringify(platfromNameArray));
      }
    }
    return name;
  };
}

module.exports = {
  serializer: {
    createModuleIdFactory
  }
};
