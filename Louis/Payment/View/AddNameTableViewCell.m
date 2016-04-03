//
//  AddNameTableViewCell.m
//  Louis
//
//  Created by François Juteau on 14/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "AddNameTableViewCell.h"
#import "UIColor+Louis.h"
#import "UIFont+Louis.h"

@implementation AddNameTableViewCell

- (void)awakeFromNib
{
    /*****************************/
    /***** DESCRIPTION LABEL *****/
    /*****************************/
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont louisLabelFont];
    self.descLabel.textColor = [UIColor louisLabelColor];
    self.descLabel.text = NSLocalizedString(@"AddPayment-Description-Name", @"");
    [self.descLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.descLabel];
    
    /**********************/
    /***** NAME LABEL *****/
    /**********************/
    self.nameLabel = [[UITextField alloc] init];
    self.nameLabel.placeholder = NSLocalizedString(@"AddPayment-PlaceHolder-Name", @"");
    
    
    [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.nameLabel];
    
    /***********************/
    /***** CONSTRAINTS *****/
    /***********************/
    [self addInitialConstraints];
}


-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    NSNumber *descWidth = [NSNumber numberWithFloat:viewWidth.floatValue * 0.4];
    NSNumber *nameWidth = [NSNumber numberWithFloat:viewWidth.floatValue];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_descLabel, _nameLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, descWidth, nameWidth);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_descLabel(descWidth)][_nameLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_descLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nameLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Alignements
//    NSLayoutConstraint *hDescAlign = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
//    
//    NSLayoutConstraint *hNameAlign = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
//    
//    NSLayoutConstraint *hDescriptionAlign = [NSLayoutConstraint constraintWithItem:@"" attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
//    
//    [self addConstraints:@[hDescAlign, hNameAlign]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
