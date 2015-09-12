//
//  LoadMoreTableCell.m
//  TheGame
//
//  Created by Azat Almeev on 10.12.14.
//  Copyright (c) 2014 Azat Almeev. All rights reserved.
//

#import "LoadMoreTableCell.h"

@interface LoadMoreTableCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end

@implementation LoadMoreTableCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.indicator startAnimating];
}

@end
