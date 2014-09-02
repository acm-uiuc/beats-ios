//
//  ACMCurrentPlayCell.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACMCurrentPlayCell : UITableViewCell

#pragma mark -
#pragma mark Setters

- (void)setImageURL:(NSURL *)url;
- (void)setTitle:(NSString *)title;

@end
