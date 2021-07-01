//
//  DetailViewController.h
//  twitter
//
//  Created by Gildardo Banuelos on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetCellTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (weak, nonatomic) Tweet *tweet;
@property (nonatomic, strong) TweetCellTableViewCell *tweetCell;
@end

NS_ASSUME_NONNULL_END
