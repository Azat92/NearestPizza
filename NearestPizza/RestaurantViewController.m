//
//  RestaurantViewController.m
//  NearestPizza
//
//  Created by Azat Almeev on 13.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "RestaurantViewController.h"
#import "Item.h"

@interface RestaurantViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *hereNowLabel;
@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.restaurant.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ (%.2f m)", self.restaurant.formattedAddress, self.restaurant.distance];
    self.hereNowLabel.text = [NSString stringWithFormat:@"%@ (total checkins: %d)", self.restaurant.hereNow, self.restaurant.checkinsCount];
}

@end
