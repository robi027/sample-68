//
//  ScriptLoadUtil.h
//  bundle_splitter
//
//  Created by ROBI DWI SETIAWAN on 29/09/21.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge+Private.h>

@interface ScriptLoadUtil : NSObject
+(void)init:(RCTBridge*) bridge;
+(RCTBridge*)getBridge;
+(BOOL)isDebugable;
+(BOOL)isScriptLoaded:(NSString*) moduleName;
+(NSString*) getDownloadedScriptPath:(NSString*)path moduleName:(NSString*) moduleName;
+(NSString*) getDownloadedScriptDirWithModuleName:(NSString*) moduleName;
+(void)loadScriptWithBridge:(RCTBridge*) bridge path:(NSString*) path moduleName:(NSString*) moduleName mainBundle:(BOOL) inMain;
@end
