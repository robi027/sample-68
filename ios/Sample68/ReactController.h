//
//  ReactController.h
//  jenius2
//
//  Created by ROBI DWI SETIAWAN on 29/09/21.
//

#import <UIKit/UIKit.h>

#import <React/RCTBridgeModule.h>


@interface ReactController : UIViewController
typedef NS_ENUM(NSUInteger, BundleType) {
    InApp  = 0,
    NetWork
};

- (instancetype)initWithURL:(NSString *)url path:(NSString *)path type:(BundleType) type moduleName:(NSString *) name param:(NSDictionary *) param;
@end
