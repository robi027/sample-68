#import "AppDelegate.h"
#import "RCTBridge.h"
#import "ScriptLoadUtil.h"
#import "ReactController.h"
#import "NavigationBridge.h"

#import <React/RCTBundleURLProvider.h>

#import <React/RCTAppSetupUtils.h>

@interface AppDelegate()
{
  RCTBridge *bridge;
  UINavigationController *rootViewController;
  UIViewController *mainViewController;
  BOOL isBuzLoaded;
}
@end

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>

#import <react/config/ReactNativeConfig.h>

@interface AppDelegate () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate> {
  RCTTurboModuleManager *_turboModuleManager;
  RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  BOOL debugable = [ScriptLoadUtil isDebugable];
  
  /**
    Start to load basic module first
   */
  NSURL *jsCodeLocation;

  if(debugable){
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.multi"];
  }else{
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"platform.ios" withExtension:@"bundle"];
  }
  
  bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                 moduleProvider:nil
                                  launchOptions:launchOptions];
  
  /**
    Initiate bridge to communication with javascript code
   */
  [ScriptLoadUtil init:bridge];
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  mainViewController = [UIViewController new];
//  mainViewController.view = [[NSBundle mainBundle] loadNibNamed:@"JeniusLaunchScreen" owner:self options:nil].lastObject;
  rootViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
  mainViewController.edgesForExtendedLayout = UIRectEdgeNone;
  mainViewController.navigationController.navigationBarHidden = YES;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  /**
   Trigger to redirect and load business bundle immediately when launching the app
   */
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBuzBundle) name:@"RCTJavaScriptDidLoadNotification" object:nil];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (void)back{
  [mainViewController.navigationController popViewControllerAnimated:true];
}

- (void)gotoBuzWithModuleName:(NSString*)moduleName bundleName:(NSString*)bundleName param:(NSDictionary*) param{
  BundleType type = InApp;
  NSString* bundleUrl = @"";
  UIViewController *controller = [[ReactController alloc] initWithURL:bundleUrl path:bundleName type:type moduleName:moduleName param:param];
  [mainViewController.navigationController pushViewController:controller animated:true];
}

- (void)loadBuzBundle{
  if(isBuzLoaded){
    return;
  }
  NSURL *jsCodeLocationBuz = [[NSBundle mainBundle] URLForResource:@"index.ios" withExtension:@"bundle"];
  NSError *error = nil;
  NSData *sourceBuz = [NSData dataWithContentsOfFile:jsCodeLocationBuz.path
                                             options:NSDataReadingMappedIfSafe
                                               error:&error];
  [bridge.batchedBridge executeSourceCode:sourceBuz sync:NO];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:@"Sample68" initialProperties:nil];
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//  rootView.loadingView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].lastObject;
  mainViewController = [UIViewController new];
  mainViewController.view = rootView;
  rootViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
  [rootViewController setNavigationBarHidden:YES];
  self.window.rootViewController = rootViewController;
  self.window.insetsLayoutMarginsFromSafeArea = false;
  [self.window makeKeyAndVisible];
  isBuzLoaded = YES;
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                             delegate:self
                                                            jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, _turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

@end
