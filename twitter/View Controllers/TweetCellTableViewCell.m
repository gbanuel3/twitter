//
//  TweetCellTableViewCell.m
//  twitter
//
//  Created by Gildardo Banuelos on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCellTableViewCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender{
    if(self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
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
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    [self refreshData];


    
}
- (IBAction)didTapRetweet:(id)sender{
    if(self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
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
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }

    [self refreshData];
}

- (void) refreshData{
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCountLabel.text =  [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    NSLog(@"%@",self.tweet.timeAgo);
    self.dateLabel.text = self.tweet.timeAgo;
    UIImage *favImageYES = [UIImage imageNamed:@"favor-icon-red.png"];
    UIImage *favImageNO = [UIImage imageNamed:@"favor-icon.png"];
    UIImage *retweetImageYES = [UIImage imageNamed:@"retweet-icon-green.png"];
    UIImage *retweetImageNO = [UIImage imageNamed:@"retweet-icon.png"];
  
    if(self.tweet.favorited == YES){
        [self.favoriteButton setImage:favImageYES forState:UIControlStateNormal];
    }else{
        [self.favoriteButton setImage:favImageNO forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted == YES){
        [self.retweetButton setImage:retweetImageYES forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:retweetImageNO forState:UIControlStateNormal];
    }
    
    
}

@end
