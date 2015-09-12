//
//  ReusableTableViewCell.m
//  TheGame
//
//  Created by Azat Almeev on 11.06.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "ReusableTableViewCell.h"

@implementation ReusableTableViewCell

+ (NSString *)selfName {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:self.selfName bundle:nil];
}

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", self.selfName];
}

+ (instancetype)cellFromNib {
    UINib *myNib = self.nib;
    return [myNib instantiateWithOwner:self options:nil][0];
}

- (void)setModel:(id)model {
    _model = model;
}

@end
