//
//  BookInfoTableViewCell.m
//  Louis
//
//  Created by François Juteau on 12/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "BookInfoTableViewCell.h"
#import "UIColor+Louis.h"
#import "UIFont+Louis.h"


@implementation BookInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _descLabel.textColor = [UIColor louisLabelColor];
        _descLabel.font = [UIFont louisLabelFont];
        
        [self addSubview:_descLabel];
        
        _valueLabel = [[UILabel alloc] init];
        [_valueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _valueLabel.font = [UIFont louisLabelFont];
    
        [self addSubview:_valueLabel];
    
        
        /*********************************/
        /***** ARROW DOWN IMAGE VIEW *****/
        /*********************************/
        _arrowDownImageView = [[UIImageView alloc] init];
        _arrowDownImageView.image = [UIImage imageNamed:@"ArrowDown"];
        _arrowDownImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_arrowDownImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_arrowDownImageView];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addInitialConstraints];
        
    }
    return self;
}

-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    NSNumber *imageSize = [NSNumber numberWithFloat:26.f];
    
    NSNumber *descWidth = [NSNumber numberWithFloat:viewWidth.integerValue * 0.3];
    NSNumber *valueWidth = [NSNumber numberWithFloat:(viewWidth.integerValue * 0.7) - imageSize.floatValue];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_descLabel, _valueLabel, _arrowDownImageView);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, descWidth, valueWidth, imageSize);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_descLabel(descWidth)][_valueLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_arrowDownImageView(imageSize)]-10-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_descLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_valueLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_arrowDownImageView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
}



@end
