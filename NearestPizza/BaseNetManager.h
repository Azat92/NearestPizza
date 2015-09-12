//
//  BaseNetManager.h
//  NearestPizza
//
//  Created by Azat Almeev on 10.12.14.
//  Copyright (c) 2014 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject
- (void)sendRequest:(NSURLRequest *)request completion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion;

@end
