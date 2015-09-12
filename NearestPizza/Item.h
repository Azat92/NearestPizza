//
//  Item.h
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic) NSString * hereNow;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * formattedAddress;
@property (nonatomic) double distance;
@property (nonatomic, retain) NSData * coordinate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t checkinsCount;

@end
