/**
 * Contains methods to generate id each module
 */ 

const fs = require('fs');
const pathSep = require('path').sep;
/**
 * @type {boolean}
 * Swicher to set kind of module id
 * true: increment number
 * ex: {"id":100000,"path":"index.android.js"}
 * false: pathname
 * ex: 
 */
const useIndex = true;
/**
 * @type {number}
 * Initial basic module id 
 */
let curModuleId = -100;
/**
 * @type {number}
 * Initial business module id
 */
let curBuzModuleId = -100;
/**
 * @type {Object[]}
 * Initial basic module mapping value
 */
let baseModuleIdMap = [];
/**
 * @type {Object[]}
 * Initial business module mapping value
 */
let buzModuleIdMap = [];
/**
 * @type {string}
 * Path of basic module mapping id
 */
let baseMappingPath;
/**
 * @type {string}
 * Path of business module mapping id
 */
let buzMappingPath;

/**
 * Get module id by index
 * @param {string} projectRootPath - root project rn
 * @param {string} path - module path
 * @param {string} entry - entry file path, ex: index.android.js
 * @param {boolean} isBuz - is it a business module or no
 * @return {string} module id
 * */
function getModuleIdByIndex(projectRootPath, path, entry, isBuz) {
  const moduleIdConfig = require('./ModuleIdConfig.json');
  if (curModuleId === -100) {
    curModuleId = -1; // basic module will be started from 0
  }
  if (baseMappingPath == null) {
    baseMappingPath = __dirname + pathSep + 'platformMap.json';
  }
  if (baseModuleIdMap.length === 0) {
    if (fs.existsSync(baseMappingPath)) {
      baseModuleIdMap = require(baseMappingPath);
      if (baseModuleIdMap.length !== 0) {
        curModuleId = baseModuleIdMap[baseModuleIdMap.length - 1].id;
      }
    }
  }
  if (isBuz) {
    if (buzMappingPath == null) {
      buzMappingPath =
        __dirname + pathSep + entry.replace('.js', '') + 'Map.json';
    }
    if (buzModuleIdMap.length === 0) {
      if (fs.existsSync(buzMappingPath)) {
        buzModuleIdMap = require(buzMappingPath);
        curBuzModuleId = buzModuleIdMap[buzModuleIdMap.length - 1].id;
      } else if (curBuzModuleId === -100) {
        curBuzModuleId = moduleIdConfig[entry] - 1; //get initial module id based on configation of businesss module id
      }
    }
  }
  let pathRelative = null;
  if (path.indexOf(projectRootPath) === 0) {
    pathRelative = path.substr(projectRootPath.length + 1);
  }
  const findPlatformItem = baseModuleIdMap.find((value) => {
    return value.path === pathRelative;
  });
  const findBuzItem = buzModuleIdMap.find((value) => {
    return value.path === pathRelative;
  });
  if (findPlatformItem) {
    return findPlatformItem.id;
  } else if (findBuzItem) {
    return findBuzItem.id;
  } else {
    if (!isBuz) {
      curModuleId = ++curModuleId;
      baseModuleIdMap.push({ id: curModuleId, path: pathRelative });
      fs.writeFileSync(baseMappingPath, JSON.stringify(baseModuleIdMap));
      return curModuleId;
    } else {
      curBuzModuleId = ++curBuzModuleId;
      buzModuleIdMap.push({ id: curBuzModuleId, path: pathRelative });
      fs.writeFileSync(buzMappingPath, JSON.stringify(buzModuleIdMap));
      return curBuzModuleId;
    }
  }
}

/**
 * Get module id by name 
 * @param {string} projectRootPath - root project rn
 * @param {path} path - module path
 * @return {string} module id, ex: platfromDep
 */
function getModuleIdByName(projectRootPath, path) {
  let name = '';
  if (
    path.indexOf(
      'node_modules' +
        pathSep +
        'react-native' +
        pathSep +
        'Libraries' +
        pathSep
    ) > 0
  ) {
    name = path.substr(path.lastIndexOf(pathSep) + 1);
  } else if (path.indexOf(projectRootPath) === 0) {
    name = path.substr(projectRootPath.length + 1);
  }
  name = name.replace('.js', '');
  name = name.replace('.png', '');
  let regExp =
    pathSep === '\\' ? new RegExp('\\\\', 'gm') : new RegExp(pathSep, 'gm');
  name = name.replace(regExp, '_'); // replace '/' with underscode
  return name;
}

/**
 * Get module id by [useIndex] selected
 * @param {string} projectRootPath - root project rn
 * @param {string} path - module path
 * @param {string} entry - entry file path, ex: index.android.js
 * @param {boolean} isBuz - is it a business module or no
 * @return {string} module id, ex: 
 */
function getModuleId(projectRootPath, path, entry, isBuz) {
  if (useIndex) {
    return getModuleIdByIndex(projectRootPath, path, entry, isBuz);
  }
  return getModuleIdByName(projectRootPath, path);
}

module.exports = { getModuleId, useIndex };
