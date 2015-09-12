//
//  BaseNetManager.m
//  NearestPizza
//
//  Created by Azat Almeev on 10.12.14.
//  Copyright (c) 2014 Azat Almeev. All rights reserved.
//

#import "BaseNetManager.h"

@interface BaseNetManager () <NSURLSessionDelegate>
@property (nonatomic, retain, readonly) NSURLSession *session;
@end

@implementation BaseNetManager
@synthesize session = _session;

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return _session;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

- (void)sendRequest:(NSURLRequest *)request completion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion {
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data, response, error);//po [[NSString alloc] initWithData:data encoding:4]
        });
    }] resume];
}

@end
