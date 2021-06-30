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
    }else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    
    [self refreshData];
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    
}
- (IBAction)didTapRetweet:(id)sender{
    if(self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }

    [self refreshData];
}

- (void) refreshData{
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCountLabel.text =  [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
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
