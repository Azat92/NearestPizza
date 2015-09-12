//
//  ItemViewCell.m
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "ItemViewCell.h"
#import "Item+Ex.h"

@implementation ItemViewCell

- (void)setModel:(Item *)model {
    [super setModel:model];
    self.textLabel.text = model.name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f m", model.distance];
}

@end
