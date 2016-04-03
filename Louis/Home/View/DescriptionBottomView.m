//
//  DescriptionBottomView.m
//  Louis
//
//  Created by François Juteau on 08/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "DescriptionBottomView.h"
#import "Common.h"

@interface DescriptionBottomView()

@property (nonatomic, strong) UIView *exceptionView;

@end

@implementation DescriptionBottomView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /**********************************/
        /***** HOUR DESCRIPTION LABEL *****/
        /**********************************/
        _hourDescLabel = [[UILabel alloc] init];
        _hourDescLabel.text = @"Horaires";
        _hourDescLabel.textAlignment = NSTextAlignmentCenter;
        _hourDescLabel.textColor = [UIColor louisLabelColor];
        _hourDescLabel.font = [UIFont louisSmallishLabel];
        
        [_hourDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_hourDescLabel];
        
        
        /***************************/
        /***** HOUR TEXT LABEL *****/
        /***************************/
        _hourTextLabel = [[UILabel alloc] init];
        _hourTextLabel.text = @"08:00 à 19:30";
        _hourTextLabel.textAlignment = NSTextAlignmentCenter;
        _hourTextLabel.textColor = [UIColor louisAnthracite];
        _hourTextLabel.font = [UIFont louisMediumLabel];
        
        [_hourTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_hourTextLabel];
        
        
        /************************************/
        /***** PRICES DESCRIPTION LABEL *****/
        /************************************/
        _pricesDescLabel = [[UILabel alloc] init];
        _pricesDescLabel.text = @"Tarifs";
        _pricesDescLabel.textAlignment = NSTextAlignmentCenter;
        _pricesDescLabel.textColor = [UIColor louisLabelColor];
        _pricesDescLabel.font = [UIFont louisSmallishLabel];
        
        [_pricesDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_pricesDescLabel];
        
        
        /*****************************/
        /***** PRICES TEXT LABEL *****/
        /*****************************/
        _pricesTextLabel = [[UILabel alloc] init];
        _pricesTextLabel.text = @"20€ la journée";
        _pricesTextLabel.textAlignment = NSTextAlignmentCenter;
        _pricesTextLabel.textColor = [UIColor louisAnthracite];
        _pricesTextLabel.font = [UIFont louisMediumLabel];
        
        [_pricesTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_pricesTextLabel];
        
        
        /**********************************/
        /***** EXCEPTION LABEL  + VIEW*****/
        /**********************************/
        _exceptionView = [[UIView alloc] init];
        _exceptionView.backgroundColor = [UIColor whiteColor];
        _exceptionView.hidden = YES;
        
        [self addSubview:_exceptionView];
        
        _exceptionLabel = [[UILabel alloc] init];
        _exceptionLabel.text = NSLocalizedString(@"Home-OffZone-Text", @"");
        _exceptionLabel.textAlignment = NSTextAlignmentCenter;
        _exceptionLabel.textColor = [UIColor louisLabelColor];
        _exceptionLabel.font = [UIFont systemFontOfSize:12];
        _exceptionLabel.numberOfLines = 0;
        
        [_exceptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_exceptionView addSubview:_exceptionLabel];
        
        

    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    /*******************************/
    /***** LIGNE DE SEPARATION *****/
    /*******************************/
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.1);
    CGPoint endPoint = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.9);
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    [[UIColor grayColor] set];
    
    [path setLineWidth:0.5];
    [path stroke];
}

-(void)layoutSubviews
{
    self.exceptionView.frame = self.frame;
}


#pragma mark - Change texts methods

-(void)changeHiddenStateForExceptionView:(BOOL)boolean
{
    self.exceptionView.hidden = boolean;
}

-(void)changeToBookTextState
{
    self.hourDescLabel.text = NSLocalizedString(@"Home-Description-Hours", @"");
    self.pricesDescLabel.text = NSLocalizedString(@"Home-Description-Prices", @"");
}

-(void)changeToParkedTextState
{
    self.hourDescLabel.text = NSLocalizedString(@"Home-Description-ClosingHour", @"");
    self.pricesDescLabel.text = NSLocalizedString(@"Home-Description-TimePast", @"");
}

#pragma mark - Constraints methods

-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    NSNumber *labelsHeight = [NSNumber numberWithFloat:viewHeight.integerValue * 0.4f];
    
    NSNumber *spacing = @(7.f);
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_hourDescLabel, _hourTextLabel, _pricesDescLabel, _pricesTextLabel, _exceptionLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, labelsHeight, spacing);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hourDescLabel(_pricesDescLabel)][_pricesDescLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hourTextLabel(_pricesTextLabel)][_pricesTextLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-spacing-[_hourDescLabel][_hourTextLabel(labelsHeight)]-spacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-spacing-[_pricesDescLabel][_pricesTextLabel(labelsHeight)]-spacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    /***************************/
    /***** EXCEPTION LABEL *****/
    /***************************/
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_exceptionLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_exceptionLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
}
@end
