//
//  ACMBeatsNetworkAPI.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock) (NSError *error, NSData *data);
@interface ACMBeatsNetworkAPI : NSObject

@property (nonatomic, strong) CompletionBlock completion;

#pragma mark -
#pragma mark API Methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)getCurrentlyPlaying;
- (void)getCurrentQueue;
- (void)addYoutubeURLToQueue:(NSURL *)youtubeURL;

#pragma mark -
#pragma mark Youtube Methods

- (void)searchForVideos:(NSString *)query;

#pragma mark -
#pragma mark Cancel Methods

- (void)cancel;

@end
