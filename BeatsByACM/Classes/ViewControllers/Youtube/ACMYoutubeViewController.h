//
//  ACMYouTubeViewController.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectionBlock) (NSURL *selectedURL);

@interface ACMYouTubeViewController : UITableViewController
@property (nonatomic, strong) SelectionBlock selection;

@end
