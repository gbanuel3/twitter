//
//  ComposeViewController.m
//  twitter
//
//  Created by Gildardo Banuelos on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation ComposeViewController

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetButton:(id)sender{
    [[APIManager shared]postStatusWithText:_textField.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
