//
//  NetManager.h
//  NearestPizza
//
//  Created by Azat Almeev on 09.12.14.
//  Copyright (c) 2014 Azat Almeev. All rights reserved.
//

#import "BaseNetManager.h"

@interface NetManager : BaseNetManager

+ (instancetype)sharedInstance;
- (void)sendRequestWithPath:(NSString *)path
                     method:(NSString *)method
                  parametrs:(NSDictionary *)parametrs
                 completion:(void(^)(id JSONData, NSError *error))completion;
- (void)sendRequestWithPath:(NSString *)path
                     method:(NSString *)method
                  parametrs:(NSDictionary *)parametrs
                hudShowView:(UIView *)hudView
                 completion:(void(^)(id JSONData, NSError *error))completion;
- (NSString *)fullPathForQuery:(NSString *)path;
@end
