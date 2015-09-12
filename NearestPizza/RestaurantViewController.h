//
//  RestaurantViewController.h
//  NearestPizza
//
//  Created by Azat Almeev on 13.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface RestaurantViewController : UIViewController
@property (nonatomic, strong) Item *restaurant;
@end
