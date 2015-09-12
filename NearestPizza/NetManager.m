//
//  NetManager.m
//  NearestPizza
//
//  Created by Azat Almeev on 09.12.14.
//  Copyright (c) 2014 Azat Almeev. All rights reserved.
//

#import "NetManager.h"

NSString * const kBaseURLPath   = @"https://api.foursquare.com";
NSString * const kAppendURLPath = @"/v2/venues/";

#define CLIENT_ID @"JZJWX5RVPL12NSVXJPH5SRYRM3XIJ4VOWULJJA2KPMQBW2F4"
#define CLIENT_SECRET @"2TBI30PWPAE1E1SEJ52R1T4FGW0J12RE3HAUGUNCLHMKT5DE"

@interface NetManager ()
@end

@implementation NetManager

+ (instancetype)sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] initSingleton];
    });
    return _singleton;
}

- (id)init {
    @throw [NSException exceptionWithName:@"You could not create an instance of this class" reason:@"This class is designed under the singleton pattern" userInfo:nil];
}

- (instancetype)initSingleton {
    return [super init];
}

- (NSString *)fullPathForQuery:(NSString *)path {
    NSString *returnPath = path;
    if ([path rangeOfString:@"http://"].location == NSNotFound &&
        [path rangeOfString:@"https://"].location == NSNotFound) {
        NSURL *baseURL = [NSURL URLWithString:kBaseURLPath];
        returnPath = [[baseURL URLByAppendingPathComponent:kAppendURLPath] URLByAppendingPathComponent:path].absoluteString;
    }
    return returnPath;
}

- (void)sendRequestWithPath:(NSString *)path method:(NSString *)method parametrs:(NSDictionary *)parametrs completion:(void (^)(id, NSError *))completion {
    [self sendRequestWithPath:path method:method parametrs:parametrs hudShowView:nil completion:completion];
}

- (void)sendRequestWithPath:(NSString *)path method:(NSString *)method parametrs:(NSDictionary *)parametrs hudShowView:(UIView *)hudView completion:(void (^)(id, NSError *))completion {
    if (parametrs != nil) {
        NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parametrs];
        newParameters[@"client_id"] = CLIENT_ID;
        newParameters[@"client_secret"] = CLIENT_SECRET;
        newParameters[@"v"] = @"20130815";
        parametrs = newParameters.copy;
    }
    
    MBProgressHUD *hud = hudView ? [MBProgressHUD showHUDAddedTo:hudView animated:YES] : nil;
    method = method.uppercaseString;

    path = [self fullPathForQuery:path];    
    if ([method isEqualToString:@"GET"] && parametrs) {
        path = [self path:path getParametrs:parametrs];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (![method isEqualToString:@"GET"] && parametrs)
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (![method isEqualToString:@"GET"] && parametrs) {
        NSError *err = nil;//po [[NSString alloc] initWithData:request.HTTPBody encoding:4]
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parametrs options:0 error:&err];
        NSAssert(err == nil, @"Invalid parameters JSON");
    }
    
//    MYLog(@"%@ %@ %@\r\n%@", method, path, parametrs, [[NSString alloc] initWithData:request.HTTPBody encoding:4]);
    [self sendRequest:request repeatAfterAutoriz:YES completion:^(id JSONData, NSError *error) {
        if (error && hudView && error.code == 1) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = error.localizedDescription;
            [hud hide:YES afterDelay:3];
        }
        else
            [hud hide:YES];
        completion(JSONData, error);
    }];
}

- (void)sendRequest:(NSURLRequest *)request repeatAfterAutoriz:(BOOL)repeat completion:(void(^)(id JSONData, NSError *error))completion {
    [self sendRequest:request completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        id JSONObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // handle cookie expiration
        NSHTTPURLResponse *httpResponce = (id)response;
        if (!httpResponce)
            completion(JSONObj, NSErrorMakeString(@"Data not available"));
        else if (httpResponce.statusCode == 500)//po [[NSString alloc] initWithData:data encoding:4]
            completion(JSONObj, NSErrorMakeString(@"Internal server error"));
//        else if (httpResponce.statusCode == 401) {
//            if (!repeat)
//                completion(JSONObj, NSBadRequestError(httpResponce.statusCode, JSONObj, kUnauthorizedString));
//            else
//                [self loginWithCompletion:^(id JSONData, NSError *error) {
//                    if (error)
//                        completion(JSONObj, error);
//                    else
//                        [self sendRequest:request repeatAfterAutoriz:NO completion:completion];
//                }];
//        }
        else if (httpResponce.statusCode == 404)
            completion(JSONObj, NSErrorMakeString(@"Resource not found"));
        else if (httpResponce.statusCode < 200 || httpResponce.statusCode > 299)
            completion(JSONObj, NSBadRequestError(httpResponce.statusCode, JSONObj, @"Unrecognized Response"));
        else {
            //interpret data as JSON
            NSString *errMsg = (error.code == -1009) ? @"Internet Error" : error.localizedDescription;
            error = error ?: NSErrorMakeString(errMsg);
            completion(JSONObj, error);
        }
    }];
}

- (NSString *)path:(NSString *)path getParametrs:(NSDictionary *)parametrs
{
    // dic  =>  key=val&...
    NSString *paramStr = [[[parametrs bk_map:^id(id key, id obj) {
        if ([obj isKindOfClass:[NSArray class]])
            return [[obj bk_map:^id(id obj) {
                return [NSString stringWithFormat:@"%@=%@", key, obj];
            }] componentsJoinedByString:@"&"];
        return [NSString stringWithFormat:@"%@=%@", key, obj];
    }] allValues] componentsJoinedByString:@"&"];
    
    BOOL hasGETParams = [path rangeOfString:@"?"].length > 0;
    NSString *joinStr = hasGETParams? @"&" : @"?";
    return [NSString stringWithFormat:@"%@%@%@", path, joinStr, [paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
