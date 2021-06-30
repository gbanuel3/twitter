//
//  ComposeViewController.h
//  twitter
//
//  Created by Gildardo Banuelos on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate;
@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
- (void)didTweet:(Tweet *)tweet;
@end

NS_ASSUME_NONNULL_END
