//
//  CommentView.m
//  Louis
//
//  Created by Thibault Le Cornec on 26/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
        [self addSubview:navigationBar];
        
        UITextView *commentTextView = [[UITextView alloc] init];
        [self addSubview:commentTextView];
        
        UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Comment"];
        [navigationBar pushNavigationItem:item animated:YES];
    }
    
    return self;
}


@end
