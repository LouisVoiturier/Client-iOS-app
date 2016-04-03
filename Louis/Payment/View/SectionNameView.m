//
//  SectionNameView.m
//  Louis
//
//  Created by François Juteau on 14/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "SectionNameView.h"
#import "Common.h"

@implementation SectionNameView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /****************************/
        /***** CARD NAME BUTTON *****/
        /****************************/
        _cardNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cardNameButton setTintColor:[UIColor louisAnthracite]];
        [[_cardNameButton titleLabel] setFont:[UIFont louisSubtitleFont]];
        
        [_cardNameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_cardNameButton];
        
        
        /************************/
        /***** IMAGE BUTTON *****/
        /************************/
        _imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_imageButton setImage:[UIImage imageNamed:@"EditIcon"] forState:UIControlStateNormal];
        _imageButton.tintColor = [UIColor blackColor];
        
        [_imageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_imageButton];
        
        
        /*************************/
        /***** DELETE BUTTON *****/
        /*************************/
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteButton setTintColor:[UIColor louisAnthracite]];
        [[_deleteButton titleLabel] setFont:[UIFont louisLabelFont]];
        [_deleteButton setTitle:NSLocalizedString(@"Payment-Delete-Label", nil) forState:UIControlStateNormal];
        
        [_deleteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_deleteButton];
        
        
        /***********************/
        /***** CONSTRAINTS *****/
        /***********************/
        [self addInitialConstraints];
    }
    return self;
}


#pragma mark - Delete button layout methods

-(void)hideDeleButton
{
    [self.deleteButton removeFromSuperview];
}



#pragma mark - Constraints

-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_cardNameButton, _imageButton, _deleteButton);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cardNameButton]-[_imageButton]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_deleteButton]-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cardNameButton]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageButton]-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_deleteButton]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

@end
