//
//  ACMDownloadableImageView.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACMDownloadableImageView : UIImageView
@property (nonatomic, strong) NSURL *imageURL;

#pragma mark -
#pragma mark Reset

- (void)reset;

@end
