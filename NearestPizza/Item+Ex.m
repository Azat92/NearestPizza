//
//  Item+Ex.m
//  NearestPizza
//
//  Created by Azat Almeev on 12.09.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

#import "Item+Ex.h"
@import CoreLocation;

@implementation Item (Ex)
- (void)fillDataFromJSON:(id)JSON {
    self.hereNow = [JSON valueForKeyPath:@"hereNow.summary"];
    self.uid = [JSON valueForKeyPath:@"id"];
    self.formattedAddress = [[JSON valueForKeyPath:@"location.formattedAddress"] firstObject];
    self.distance = [[JSON valueForKeyPath:@"location.distance"] doubleValue];
    double lat = [[JSON valueForKeyPath:@"location.lat"] doubleValue];
    double lon = [[JSON valueForKeyPath:@"location.lon"] doubleValue];
    self.coordinate = [NSKeyedArchiver archivedDataWithRootObject:[CLLocation.alloc initWithLatitude:lat longitude:lon]];
    self.name = [JSON valueForKeyPath:@"name"];
    self.checkinsCount = [[JSON valueForKeyPath:@"stats.checkinsCount"] intValue];
}
@end
