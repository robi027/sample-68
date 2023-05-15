//
//  RCTBridge.h
//  Sample68
//
//  Created by ROBI DWI SETIAWAN on 27/03/23.
//

#import <React/RCTBridge.h>

@interface RCTBridge (RnLoadJS)

- (void)executeSourceCode:(NSData *)sourceCode sync:(BOOL)sync;

@end
 
