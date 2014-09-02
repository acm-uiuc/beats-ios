//
//  ACMBeatsNetworkAPI.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMBeatsNetworkAPI.h"
#import "ACMUserManager.h"

@interface ACMBeatsNetworkAPI()
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) ACMUserManager *sharedUser;
@end

@implementation ACMBeatsNetworkAPI

#pragma mark -
#pragma mark API Methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    NSURL *url = [NSURL URLWithString:URL_APILogin];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *data = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self downloadForURLRequest:request];
}

- (void)getCurrentlyPlaying {
    NSURL *url = [NSURL URLWithString:URL_APICurrentlyPlaying];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self downloadForURLRequest:request];
}

- (void)getCurrentQueue {
    NSURL *url = [NSURL URLWithString:URL_APIQueue];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self downloadForURLRequest:request];
}

- (void)addYoutubeURLToQueue:(NSURL *)youtubeURL {
    NSURL *url = [NSURL URLWithString:URL_APIQueueAdd];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    ACMUserManager *sharedManager = [ACMUserManager sharedInstance];
    NSString *data = [NSString stringWithFormat:@"url=%@&token=%@",youtubeURL.absoluteString,sharedManager.session];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self downloadForURLRequest:request];
}

#pragma mark -
#pragma mark Youtube Methods

- (void)searchForVideos:(NSString *)query {
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpString = [NSString stringWithFormat:URL_YoutubeQuery,query,Key_Youtube];
    NSURL *url = [NSURL URLWithString:httpString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self downloadForURLRequest:request];
}

#pragma mark -
#pragma mark Download Methods

- (void)downloadForURLRequest:(NSURLRequest *)request {
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    self.dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.completion(error,data);
    }];
    
    [self.dataTask resume];
    
}

#pragma mark -
#pragma mark Cancel Methods

- (void)cancel {
    [self.dataTask cancel];
}

@end
