//
//  ACMYoutubeViewController.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 8/31/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMYoutubeViewController.h"
#import "ACMBeatsNetworkAPI.h"
#import "ACMCurrentPlayCell.h"

@interface ACMYoutubeViewController() <UISearchBarDelegate>
@property (nonatomic, strong) ACMBeatsNetworkAPI *networkAPI;
@property (nonatomic, strong) NSArray *items;
@end

@implementation ACMYoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.networkAPI = [[ACMBeatsNetworkAPI alloc] init];
    
    __weak ACMYoutubeViewController *weakSelf = self;
    self.networkAPI.completion = ^(NSError *error, NSData *data) {
        [weakSelf updateToData:data error:error];
    };
}

#pragma mark -
#pragma mark Search Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    
    [self.networkAPI cancel];
    [self.networkAPI searchForVideos:searchBar.text];
}

#pragma mark -
#pragma mark Parse Methods

- (void)updateToData:(NSData *)data error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *items = dict[@"items"];
        
        self.items = items;
        [self.tableView reloadData];
    });
}

#pragma mark -
#pragma mark Parse Methods

- (IBAction)cancelButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACMCurrentPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.items[indexPath.row];
    
    [cell setTitle:dict[@"snippet"][@"title"]];

    NSString *urlString = dict[@"snippet"][@"thumbnails"][@"default"][@"url"];
    [cell setImageURL:[NSURL URLWithString:urlString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.items[indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_YoutubeWatch,dict[@"id"][@"videoId"]]];
    self.selection(url);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
