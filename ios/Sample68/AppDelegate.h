#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate>

@property (nonatomic, strong) UIWindow *window;

- (void)gotoBuzWithModuleName: (NSString*)moduleName bundleName: (NSString*)bundleName param:(NSDictionary*) param;

- (void)back;

@end
