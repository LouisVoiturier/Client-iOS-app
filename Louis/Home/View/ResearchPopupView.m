//
//  ResearchPopupView.m
//  Louis
//
//  Created by François Juteau on 15/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ResearchPopupView.h"
#import "Common.h"

@interface ResearchPopupView ()
    @property (strong, nonatomic, readonly) UIVisualEffectView *blurEffectView;
@end

@implementation ResearchPopupView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if (UIAccessibilityIsReduceTransparencyEnabled() == NO)
        {
            _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            [_blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_blurEffectView setAlpha:0.0];
            [self addSubview:_blurEffectView];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"_blurEffectView":_blurEffectView}]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"_blurEffectView":_blurEffectView}]];
        }
        
        /**********************/
        /***** POPUP VIEW *****/
        /**********************/
        _popupView = [[UIView alloc] init];
        _popupView.backgroundColor = [UIColor whiteColor];
        _popupView.layer.cornerRadius = 15.0;
        
        [_popupView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_popupView];
        
        
        /******************************/
        /***** ACTIVITY INDICATOR *****/
        /******************************/
        _activityIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading"]];
        _activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
        
        [_activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_popupView addSubview:_activityIndicator];
        
        
        /**********************/
        /***** IMAGE VIEW *****/
        /**********************/
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_popupView addSubview:_imageView];
        
        
        /*********************/
        /***** BOT LABEL *****/
        /*********************/
        _botTextLabel = [[UILabel alloc] init];
        _botTextLabel.numberOfLines = 0;
        _botTextLabel.textAlignment = NSTextAlignmentCenter;
        _botTextLabel.font = [UIFont louisLabelFont];
        
        [_botTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_popupView addSubview:_botTextLabel];
        
        
        /*********************/
        /***** TOP LABEL *****/
        /*********************/
        _topTextLabel = [[UILabel alloc] init];
        _topTextLabel.numberOfLines = 0;
        _topTextLabel.textAlignment = NSTextAlignmentCenter;
        _topTextLabel.font = [UIFont louisLabelFont];
        _topTextLabel.textColor = [UIColor louisLabelColor];
        
        [_topTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_popupView addSubview:_topTextLabel];
    
        [self addInitialConstraints];
    }
    return self;
}


#pragma mark - State changing methods

-(void)changeToSearchingStateWithMessage:(NSString *)message
{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
     if (_blurEffectView != nil)
     {
         [_blurEffectView setAlpha:1.0];
     }
     else
     {
         [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
     }
    
    self.botTextLabel.text = NSLocalizedString(@"ResearchPopup-BotText-Searching", @"");
    self.botTextLabel.textColor = [UIColor louisSubtitleColor];
    
    self.topTextLabel.hidden = YES;
    
    self.imageView.hidden = YES;
    
    [_popupView addSubview:self.activityIndicator];
    [Tools rotateLayerInfinite:_activityIndicator.layer];
    
}


-(void)changeToFoundState
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.botTextLabel.text = NSLocalizedString(@"ResearchPopup-BotText-Found", @"");
    self.botTextLabel.textColor = [UIColor louisConfirmColor];
    
    self.topTextLabel.hidden = YES;
    
    self.imageView.hidden = NO;
    
    [self.activityIndicator removeFromSuperview];
    [self.activityIndicator.layer removeAllAnimations];
}


-(void)changeToNotFoundState
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.botTextLabel.text = NSLocalizedString(@"ResearchPopup-BotText-NotFound", @"");
    self.botTextLabel.textColor = [UIColor louisSubtitleColor];
    
    self.topTextLabel.text = NSLocalizedString(@"ResearchPopup-TopText-NotFound", @"");
    self.topTextLabel.hidden = NO;
    
    self.imageView.hidden = YES;
    
    [self.activityIndicator removeFromSuperview];
    [self.activityIndicator.layer removeAllAnimations];
    
}


- (void)dismiss
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (_blurEffectView != nil)
    {
        [_blurEffectView setAlpha:0.0];
    }
    else
    {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    }

   [self removeFromSuperview];
}


#pragma mark - Constraints method

-(void)addInitialConstraints
{
//    CGSize mainFrameSize = [UIScreen mainScreen].bounds.size;
    
//    CGFloat frameWidth = mainFrameSize.width * 0.6f;
//    CGFloat frameHeight = mainFrameSize.height * 0.3f;
//    CGFloat frameX = (mainFrameSize.width - frameWidth) * 0.5f;
//    CGFloat frameY = (mainFrameSize.height - frameHeight) * 0.5f;
    
    self.frame = [UIScreen mainScreen].bounds;
    
//    _popupView.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
    
    
    NSNumber *frameWidth = [NSNumber numberWithFloat:200.F];
    NSNumber *frameHeight = [NSNumber numberWithFloat:200.F];
    
    NSNumber *xSpacing = [NSNumber numberWithFloat:20.0f];
    NSNumber *ySpacing = [NSNumber numberWithFloat:20.0f];
    
//    NSNumber *botTextHeight = [NSNumber numberWithFloat:frameHeight * 0.3];
    
    NSNumber *botTextHeight = [NSNumber numberWithFloat:50.f];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_popupView, _activityIndicator, _imageView, _botTextLabel, _topTextLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(xSpacing, ySpacing, botTextHeight, frameWidth, frameHeight);
    
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_popupView(frameWidth)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    
    // Horizontale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_activityIndicator]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_imageView]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_botTextLabel]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-xSpacing-[_topTextLabel]-xSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_popupView(frameHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_botTextLabel(botTextHeight)]-ySpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-ySpacing-[_activityIndicator]-ySpacing-[_botTextLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-ySpacing-[_topTextLabel]-ySpacing-[_botTextLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [_popupView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-ySpacing-[_imageView]-ySpacing-[_botTextLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_popupView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_popupView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.f]];
    
}
@end
