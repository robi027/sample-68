//
//  NavigationBridge.m
//  jenius2
//
//  Created by ROBI DWI SETIAWAN on 30/09/21.
//

#import "NavigationBridge.h"
#import "AppDelegate.h"

/**
 Native Modules to handle navigation between module
 */
@implementation NavigationBridge

/**
 Register as native modules to make it can be called in javascript
 */
RCT_EXPORT_MODULE(NavigationBridge)

/**
 Navigate to another bundle
 @param param contains parse data between bundle
 */
RCT_EXPORT_METHOD(push: (NSDictionary *)param){
  NSString *to = param[@"to"];

  dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate gotoBuzWithModuleName:to bundleName:@"profile.ios.bundle" param: param];
  });
}

/**
 Goback to previous bundle and clear on stack navigation
 */
RCT_EXPORT_METHOD(pop){
  dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate back];
  });
}

@end
