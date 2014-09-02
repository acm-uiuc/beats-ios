//
//  ACMCurrentPlayCell.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMCurrentPlayCell.h"
#import "ACMDownloadableImageView.h"

@interface ACMCurrentPlayCell()
@property (nonatomic, weak) IBOutlet ACMDownloadableImageView *downloadableImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation ACMCurrentPlayCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.downloadableImageView.image = nil;
}

#pragma mark -
#pragma mark Setters

- (void)setImageURL:(NSURL *)url {
    self.downloadableImageView.imageURL = url;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
