//
//  SecurityCodeView.m
//  Louis
//
//  Created by François Juteau on 20/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "SecurityCodeView.h"
#import "Common.h"

@interface SecurityCodeView()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *descView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation SecurityCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 3.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        /****************************/
        /***** DESCRIPTION VIEW *****/
        /****************************/
        _descView = [[UIView alloc] init];
        _descView.backgroundColor = [UIColor blackColor];
        
        // Permet d'avoir les coin du haut arrondis comme la vue principale
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                     cornerRadii:CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius)].CGPath;
        
        _descView.layer.mask = maskLayer;
        
        [_descView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_descView];
        
        
        /*****************************/
        /***** DESCRIPTION LABEL *****/
        /*****************************/
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont louisSmallestLabel];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.text = NSLocalizedString(@"SecurityCode-Description", nil);
        
        [_descLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_descLabel];
        
        
        /**********************/
        /***** CODE LABEL *****/
        /**********************/
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = [UIFont louisBigLabel];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        
        [_codeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_codeLabel];
        
        
        /**********************************/
        /***** TAP GESTURE RECOGNIZER *****/
        /**********************************/
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
        
        [self addGestureRecognizer:_tapRecognizer];
        
        
        [self addInitialConstraints];
    }
    return self;
}


#pragma mark - Tap gesture handlers


-(void)handleTapGesture
{
    [self.delegate displaySecurityCodePopup];
}


#pragma mark - Constraints method

-(void)addInitialConstraints
{
    NSNumber *xSpacing = [NSNumber numberWithFloat:2.0f];
    NSNumber *ySpacing = [NSNumber numberWithFloat:2.0f];
    
    NSNumber *codeLabelHeight = [NSNumber numberWithFloat:28.0f];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_descView, _descLabel, _codeLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(xSpacing, ySpacing, codeLabelHeight);
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_descLabel]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_codeLabel]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-ySpacing-[_descLabel][_codeLabel(codeLabelHeight)]-ySpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_descView][_codeLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}


@end
