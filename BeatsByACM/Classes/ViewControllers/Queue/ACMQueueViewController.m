//
//  ACMQueueViewController.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMQueueViewController.h"
#import "ACMYoutubeViewController.h"
#import "ACMBeatsNetworkAPI.h"
#import "ACMCurrentPlayCell.h"
#import "ACMUserManager.h"

@interface ACMQueueViewController()
@property (nonatomic, strong) ACMBeatsNetworkAPI *networkQueueAPI;
@property (nonatomic, strong) ACMBeatsNetworkAPI *addToQueue;
@property (nonatomic, strong) ACMBeatsNetworkAPI *loginRequest;

@property (nonatomic, strong) ACMUserManager *sharedManager;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ACMQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [ACMUserManager sharedInstance];
    self.networkQueueAPI = [[ACMBeatsNetworkAPI alloc] init];
    self.addToQueue = [[ACMBeatsNetworkAPI alloc] init];
    
    __weak ACMQueueViewController *weakSelf = self;
    self.networkQueueAPI.completion = ^(NSError *error, NSData *data) {
        [weakSelf updateQueueToData:data error:error];
    };
    
    self.addToQueue.completion = ^(NSError *error, NSData *data) {
        [weakSelf updateQueueFromAddToData:data error:error];
    };
    
    self.loginRequest = [[ACMBeatsNetworkAPI alloc] init];
    self.loginRequest.completion = ^(NSError *error, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if(dict[@"token"]) {
                weakSelf.sharedManager.session = dict[@"token"];
                weakSelf.loginButton.title = @"Logout";
            }
        });
    };
    
    if(self.sharedManager.username && ![self.sharedManager.username isEqualToString:@""]) {
        [self.loginRequest loginWithUsername:self.sharedManager.username password:self.sharedManager.password];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.networkQueueAPI getCurrentQueue];
    
    if([self.sharedManager.session isEqualToString:@""]) {
        self.loginButton.title = @"Login";
    }
    else {
        self.loginButton.title = @"Logout";
    }
}

#pragma mark -
#pragma mark Refresh Methods

- (void)refresh:(id)sender {
    [self.networkQueueAPI cancel];
    [self.networkQueueAPI getCurrentQueue];
}

#pragma mark -
#pragma mark Network Methods

- (void)updateQueueToData:(NSData *)data error:(NSError *)error {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.items = dict[@"queue"];
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
    });
}

- (void)updateQueueFromAddToData:(NSData *)data error:(NSError *)error {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
    
    [self.networkQueueAPI getCurrentQueue];
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)plusAction:(id)sender {
    [self performSegueWithIdentifier:Segue_VideoSelect sender:self];
}

- (IBAction)loginAction:(id)sender {
    if(![self.sharedManager.session isEqualToString:@""]) {
        self.sharedManager.session = @"";
    }
    
    [self performSegueWithIdentifier:Segue_Login sender:self];
}

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.items[indexPath.row];
    
    NSString *imageStr = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/default.jpg",[self youtubeIDFromURLStr:dict[@"url"]]];
    
    if(indexPath.row == 0) {
        ACMCurrentPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playingCell" forIndexPath:indexPath];
        
        [cell setTitle:dict[@"title"]];
        [cell setImageURL:[NSURL URLWithString:imageStr]];
        
        return cell;
    }
    else {
        ACMCurrentPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"queueCell" forIndexPath:indexPath];
        
        [cell setTitle:dict[@"title"]];
        [cell setImageURL:[NSURL URLWithString:imageStr]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)youtubeIDFromURLStr:(NSString *)string {
    return [string substringFromIndex:32];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 198.0;
    }
    else {
        return 65.0;
    }
}

#pragma mark -
#pragma mark Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_VideoSelect]) {
        UINavigationController *navController = segue.destinationViewController;
        ACMYoutubeViewController *youtubeVC = navController.viewControllers[0];
        
        youtubeVC.selection = ^(NSURL *url) {
            [self.addToQueue addYoutubeURLToQueue:url];
        };
    }
}

@end
