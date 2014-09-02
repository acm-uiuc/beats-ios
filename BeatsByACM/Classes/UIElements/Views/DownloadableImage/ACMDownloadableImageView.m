//
//  ACMDownloadableImageView.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMDownloadableImageView.h"

@interface ACMDownloadableImageView()
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSCache *cache;
@end

@implementation ACMDownloadableImageView

#pragma mark -
#pragma mark Getters

- (NSCache *)cache {
    static dispatch_once_t pred;
    static NSCache *shared = nil;
    shared.countLimit = 20;
    
    dispatch_once(&pred, ^{
        shared = [[NSCache alloc] init];
    });
    return shared;
}

#pragma mark -
#pragma mark Setters

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    NSCache *cache = self.cache;
    if(_imageURL) {
        if([cache objectForKey:imageURL]) {
            self.image = [cache objectForKey:imageURL];
        }
        else {
            NSURLSession *sharedSession = [NSURLSession sharedSession];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            
            __weak ACMDownloadableImageView *weakSelf = self;
            self.dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(error) {
                        [UIView animateWithDuration:0.3 animations:^{
                            weakSelf.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            weakSelf.image = nil;
                            weakSelf.alpha = 1.0;
                        }];
                    }
                    else {
                        [UIView animateWithDuration:0.3 animations:^{
                            weakSelf.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            weakSelf.image = [UIImage imageWithData:data];
                            if(weakSelf.image) {
                                [weakSelf.cache setObject:weakSelf.image forKey:imageURL];
                            }
                            [UIView animateWithDuration:0.3 animations:^{
                                weakSelf.alpha = 1.0;
                            }];
                        }];
                    }
                });
            }];
            
            [self.dataTask resume];
        }
    }
}

#pragma mark -
#pragma mark Reset

- (void)reset {
    [self.dataTask cancel];
    self.image = nil;
}

@end
