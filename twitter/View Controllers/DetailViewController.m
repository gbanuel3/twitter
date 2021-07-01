//
//  DetailViewController.m
//  twitter
//
//  Created by Gildardo Banuelos on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "Tweet.h"
#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCellTableViewCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweetInfo;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetAuthorLabel;


@end

@implementation DetailViewController

- (IBAction)onClickRetweet:(id)sender{
    if(self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", self.tweet.text);
            }
        }];
        
    }else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", self.tweet.text);
            }
        }];
    }
    [self reloadImages];
}
- (IBAction)onClickFavorite:(id)sender {
    if(self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
            }
        }];
        
    }else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", self.tweet.text);
            }
        }];
    }

    [self reloadImages];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetInfo.text = self.tweet.text;
    self.tweetAuthorLabel.text = self.tweet.user.name;
    [self reloadImages];
}
-(void) reloadImages{
    UIImage *favImageYES = [UIImage imageNamed:@"favor-icon-red.png"];
    UIImage *favImageNO = [UIImage imageNamed:@"favor-icon.png"];
    UIImage *retweetImageYES = [UIImage imageNamed:@"retweet-icon-green.png"];
    UIImage *retweetImageNO = [UIImage imageNamed:@"retweet-icon.png"];
    if(self.tweet.favorited == YES){
        [self.favoriteButton setImage:favImageYES forState:UIControlStateNormal];
        [self.tweetCell.favoriteButton setImage:favImageYES forState:UIControlStateNormal];
    }else{
        [self.favoriteButton setImage:favImageNO forState:UIControlStateNormal];
        [self.tweetCell.favoriteButton setImage:favImageNO forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted == YES){
        [self.retweetButton setImage:retweetImageYES forState:UIControlStateNormal];
        [self.tweetCell.retweetButton setImage:retweetImageYES forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:retweetImageNO forState:UIControlStateNormal];
        [self.tweetCell.retweetButton setImage:retweetImageNO forState:UIControlStateNormal];
        }
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
