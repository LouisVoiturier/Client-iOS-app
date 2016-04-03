//
//  CourseTimeLeftView.m
//  Louis
//
//  Created by François Juteau on 19/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "CourseTimeLeftView.h"
#import "Common.h"

@interface CourseTimeLeftView ()

@property (nonatomic, strong) UILabel *preTimeLabel;

@end
@implementation CourseTimeLeftView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.0f];
        
        /***************************/
        /***** PRETIME LABEL *****/
        /**************************/
        _preTimeLabel = [[UILabel alloc] init];
        _preTimeLabel.font = [UIFont louisSmallLabel];
        _preTimeLabel.textColor = [UIColor louisLabelColor];
        _preTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        _preTimeLabel.text = @"Arrivée dans";
        
        [_preTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_preTimeLabel];
        
        
        /***************************/
        /***** TIME LABEL *****/
        /**************************/
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont louisBigLabel];
        _timeLabel.textColor = [UIColor louisLabelColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"10min";
        
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_timeLabel];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    /*******************************/
    /***** LIGNE DE SEPARATION *****/
    /*******************************/
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(1, self.frame.size.height * 0.1);
    CGPoint endPoint = CGPointMake(1, self.frame.size.height * 0.9);
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    [[UIColor grayColor] set];
    
    [path setLineWidth:0.5];
    [path stroke];
}


-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    NSNumber *labelXSpacing = [NSNumber numberWithFloat:viewWidth.floatValue * 0.1f];
    NSNumber *labelHeight = [NSNumber numberWithFloat:viewHeight.floatValue * 0.5f];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_preTimeLabel, _timeLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(labelXSpacing, labelHeight);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-labelXSpacing-[_preTimeLabel]-labelXSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-labelXSpacing-[_timeLabel]-labelXSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_preTimeLabel][_timeLabel(labelHeight)]-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

@end
