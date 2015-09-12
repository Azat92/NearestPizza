//
//  MyHelpers.h
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"

@interface UIView (ShowErrorView)
- (void)showError:(NSString *)message;
@end

@interface UIViewController (ShowErrorView)
- (void)showError:(NSString *)message;
- (NetManager *)netManager;
@end
