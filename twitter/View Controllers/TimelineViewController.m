//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCellTableViewCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (IBAction)onClickButton:(id)sender {
    [self logOut];
}

- (void) logOut{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void) loadTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:@"20" completion:^(NSArray *tweets, NSError *error){
        if (tweets){
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet{
    [self loadTweets];
    [self dismissViewControllerAnimated:true completion:nil];
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadTweets];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return count of tweets;
    return self.arrayOfTweets.count;
}
- (void) loadMoreData:(NSString *)count{
    [[APIManager shared] getHomeTimelineWithCompletion:count completion:^(NSArray *tweets, NSError *error){
        if (tweets){
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfTweets count]){
        [self loadMoreData:[NSString stringWithFormat:@"%lu",[self.arrayOfTweets count]+20]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCellTableViewCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.nameLabel.text = tweet.user.name;
    cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.dateLabel.text = tweet.timeAgo;
    cell.tweetLabel.text = tweet.text;
    cell.tweet = tweet;
    
    UIImage *favImageYES = [UIImage imageNamed:@"favor-icon-red.png"];
    UIImage *favImageNO = [UIImage imageNamed:@"favor-icon.png"];
    UIImage *retweetImageYES = [UIImage imageNamed:@"retweet-icon-green.png"];
    UIImage *retweetImageNO = [UIImage imageNamed:@"retweet-icon.png"];
  
    if(cell.tweet.favorited == YES){
        [cell.favoriteButton setImage:favImageYES forState:UIControlStateNormal];
    }else{
        [cell.favoriteButton setImage:favImageNO forState:UIControlStateNormal];
    }
    if(cell.tweet.retweeted == YES){
        [cell.retweetButton setImage:retweetImageYES forState:UIControlStateNormal];
    }else{
        [cell.retweetButton setImage:retweetImageNO forState:UIControlStateNormal];
    }
    
    NSURL *posterImageURL = [NSURL URLWithString:tweet.user.profilePicture];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterImageURL];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"cellSelectedSegue"]){
        TweetCellTableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.tweet = tweet;
        return;
    }
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
}



@end
