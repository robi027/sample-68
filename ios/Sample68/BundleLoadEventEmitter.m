//
//  BundleLoadEventEmitter.m
//  jenius2
//
//  Created by ROBI DWI SETIAWAN on 29/09/21.
//

#import <Foundation/Foundation.h>
#import "BundleLoadEventEmitter.h"

/**
 Module event emitter to be observed by JS
 */
@implementation BundleLoadEventEmitter

{
  bool hasListeners;
}

/**
 initiate emit bundle load event
 */
- (instancetype)init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bundleLoaded:)
                                                 name:@"BundleLoad"
                                               object:nil];
  }
  return self;
}

RCT_EXPORT_MODULE();

/**
 Will be called when this module's first listener is added.
 */
-(void)startObserving
{
  hasListeners = YES;
  // Set up any upstream listeners or background tasks as necessary
}

/**
 Will be called when this module's last listener is removed, or on dealloc.
 */
-(void)stopObserving
{
  hasListeners = NO;
  // Remove upstream listeners, stop unnecessary background tasks
}

/**
 Event emitter will be supported on this module
 */
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"BundleLoad"];
}

/**
 Get what bundle path has been loaded
 */
- (void)bundleLoaded:(NSNotification *)notification
{
  NSLog(@"bundleLoaded");
  NSString *bundlePath = notification.userInfo[@"path"];
  if (hasListeners) { // Only send events if anyone is listening
    [self sendEventWithName:@"BundleLoad" body:@{@"path": bundlePath}];
  }
}

@end
