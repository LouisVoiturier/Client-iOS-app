//
//  BookInfoSection.m
//  Louis
//
//  Created by François Juteau on 12/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "BookInfoSection.h"
#import "UIColor+Louis.h"
#import "UIFont+Louis.h"

@implementation BookInfoSection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _textLabel.text = NSLocalizedString(@"Home-Bottom-Table-SectionHeader", @"");
        _textLabel.textColor = [UIColor louisWhiteColor];
        _textLabel.font = [UIFont louisMediumLabel];
        
        [self addSubview:_textLabel];
        
        [self addInitialConstraints];
        
        self.backgroundColor = [UIColor louisAnthracite];
    }
    return self;
}


-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    NSNumber *spacingLeft = [NSNumber numberWithInteger:10];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, spacingLeft);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-spacingLeft-[_textLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}
@end
