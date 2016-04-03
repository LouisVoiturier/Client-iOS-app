//
//  HomeViewController+FeedBackView.h
//  Louis
//
//  Created by Thibault Le Cornec on 21/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedBackView.h"


@interface HomeViewController (FeedBackView) <FeedBackDelegate, UITextViewDelegate>

- (void)showFeedBackView;

@end
