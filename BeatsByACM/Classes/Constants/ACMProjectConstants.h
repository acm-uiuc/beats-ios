//
//  ACMProjectConstants.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//


// URL
#define URL_VideoSelect @"http://www.YouTube.com"
#define URL_YouTubeWatch @"https://www.YouTube.com/watch?v=%@"
#define URL_YouTubeQuery @"https://www.googleapis.com/YouTube/v3/search?part=snippet&maxResults=20&q=%@&key=%@"

#define URL_APILogin @"http://siebl-1104-04.acm.illinois.edu:5000//v1/session"
#define URL_APIQueue @"http://siebl-1104-04.acm.illinois.edu:5000//v1/queue"
#define URL_APIQueueAdd @"http://siebl-1104-04.acm.illinois.edu:5000//v1/queue/add"
#define URL_APICurrentlyPlaying @"http://siebl-1104-04.acm.illinois.edu:5000//v1/now_playing"

// Segues
#define Segue_Login @"toLoginView"
#define Segue_VideoSelect @"toVideoSelectView"

// Keys
#define Key_YouTube @"AIzaSyB2-cLCsgRZbS38vdoLrYr3PYMqKR98cUk"