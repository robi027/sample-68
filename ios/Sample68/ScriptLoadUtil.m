//
//  ScriptLoadUtil.m
//  bundle_splitter
//
//  Created by ROBI DWI SETIAWAN on 29/09/21.
//

#import <Foundation/Foundation.h>
#import "ScriptLoadUtil.h"
#import "RCTBridge.h"
#import <React/RCTBridge+Private.h>
#import "objc/runtime.h"

/**
 Status debug/release when running the bundle
 */
static const BOOL MULTI_DEBUG = NO;
/**
 List module loaded
 */
static NSMutableArray* loadedScripts = nil;

/**
 Async bridge to communication module javascript
 */
static RCTBridge *rctBridge = nil;

@implementation ScriptLoadUtil

/**
 initiate async bridge instance
 */
+(void)init:(RCTBridge*) bridge{
  rctBridge = bridge;
}

/**
 Get async bridge instance
 */
+(RCTBridge*)getBridge{
  return rctBridge;
}

/**
 Get build type debug/release
 */
+(BOOL)isDebugable{
  return MULTI_DEBUG;
}

/**
 Get state module has been loaded or not
 */
+(BOOL)isScriptLoaded:(NSString*) moduleName{
  if(loadedScripts==nil){
    return NO;
  }
  return [loadedScripts indexOfObject:moduleName]!=NSNotFound;
}

/**
 Get path of the downloaded module
 */
+(NSString*) getDownloadedScriptPath:(NSString*)path moduleName:(NSString*) moduleName{
  NSString* subScriptDir = [@"Bundles" stringByAppendingPathComponent:moduleName];
  NSString * bundlePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:subScriptDir];
  NSString* scriptPath = [bundlePath stringByAppendingPathComponent:path];
  NSLog(@"scriptPath======", scriptPath);
  return scriptPath;
}

/**
 Get directory and module name if the downloaded module
 */
+(NSString*) getDownloadedScriptDirWithModuleName:(NSString*) moduleName{
  NSString* subScriptDir = [@"Bundles" stringByAppendingPathComponent:moduleName];
  NSString * bundlePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:subScriptDir];
  return bundlePath;
}

/**
 Load and execute source module
 */
+(void)loadScriptWithBridge:(RCTBridge*)bridge path:(NSString*)path moduleName:(NSString*) moduleName mainBundle:(BOOL)inMain{
  if(loadedScripts==nil){
    loadedScripts = [NSMutableArray array];
  }
  if([loadedScripts indexOfObject:moduleName]==NSNotFound){
    [loadedScripts addObject:moduleName];
    NSString *jsCodeLocationBuz = nil;
    if(inMain==YES){
      jsCodeLocationBuz = [[NSBundle mainBundle] URLForResource:path withExtension:@""].path;
    }else{
      NSString* scriptPath = [self getDownloadedScriptPath:path moduleName:moduleName];
      jsCodeLocationBuz = scriptPath;
    }
    NSError *error = nil;
    NSData *sourceBuz = [NSData dataWithContentsOfFile:jsCodeLocationBuz
                                           options:NSDataReadingMappedIfSafe
                                             error:&error];
    [bridge.batchedBridge executeSourceCode:sourceBuz sync:NO];
  }
  return;
}

@end
