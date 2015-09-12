//
//  MyHelpers.m
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "MyHelpers.h"

@implementation UIView (ShowErrorView)
- (void)showError:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:2];
}
@end

@implementation UIViewController (ShowErrorView)
- (void)showError:(NSString *)message {
    [self.view.window showError:message];
}
- (NetManager *)netManager {
    return [NetManager sharedInstance];
}
@end
