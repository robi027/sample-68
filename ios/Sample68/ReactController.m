//
//  ReactController.m
//  jenius2
//
//  Created by ROBI DWI SETIAWAN on 29/09/21.
//

#import <Foundation/Foundation.h>
#import "ReactController.h"
#import <React/RCTRootView.h>
#import "ScriptLoadUtil.h"

@interface ReactController()
@property (nonatomic, strong) UIView *rctView;
@property (nonatomic, readonly) RCTBridge *rctBridge;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) BundleType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *param;
@end

/**
 React controller is UIViewController as container to load the module
 */
@implementation ReactController

/**
 Initiate module instance
 */
- (instancetype)initWithURL:(NSString *)url path:(NSString *)path type:(BundleType) type moduleName:(NSString *) name param:(NSDictionary*) param{
  NSLog(@"initWithURL============");
  if (self = [super init]) {
    self.url = url;
    self.path = path;
    self.type = type;
    self.name = name;
    self.param = param;
  }
  return self;
}

/**
 ViewDidLoad will be called when after the view has been loaded
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  if([ScriptLoadUtil isDebugable]!=YES){
    NSLog(@"loadScript============");
    [self loadScript];

  }
  if(self.type==InApp||[ScriptLoadUtil isScriptLoaded:self.name]){
    NSLog(@"initView============");
    [self initView];
  }
}

/**
 Load script module
 */
-(void)loadScript{
  NSLog(@"loadScript============");
  RCTBridge* bridge = [ScriptLoadUtil getBridge];
  NSString* mainBundlePath = [NSBundle mainBundle].bundlePath;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"BundleLoad" object:nil userInfo:@{@"path":[@"file://" stringByAppendingString:[mainBundlePath stringByAppendingString:@"/"]]}]; // notify rn to replace the path
  [ScriptLoadUtil loadScriptWithBridge:bridge path:self.path moduleName:self.name mainBundle:true];
}

/**
 Initiate native view while loading the module
 */
-(void)initView{
  RCTBridge* bridge = [ScriptLoadUtil getBridge];
  RCTRootView* view = [[RCTRootView alloc] initWithBridge:bridge moduleName:self.name initialProperties:self.param];
  view.frame = self.view.bounds;
  view.backgroundColor = [UIColor colorNamed: @"background"];
  [self setView:view];
}
@end
