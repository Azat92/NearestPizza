//
//  ReusableTableViewCell.h
//  TheGame
//
//  Created by Azat Almeev on 11.06.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReusableTableViewCell : UITableViewCell
@property (nonatomic, retain) id model;
+ (UINib *)nib;
+ (NSString *)cellIdentifier;
+ (instancetype)cellFromNib;
@end
