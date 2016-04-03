//
//  InCourseBottomView.m
//  Louis
//
//  Created by François Juteau on 16/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "InCourseBottomView.h"
#import "Common.h"
#import "ImageManager.h"
#import "DataManager+User.h"

@interface InCourseBottomView ()

@property (nonatomic, strong) UIView *BGView;

/** Correspond au "est en route" */
@property (nonatomic, strong) UILabel *comingLabel;

@end


@implementation InCourseBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f] ;
        
        /*******************/
        /***** BG VIEW *****/
        /*******************/
        _BGView = [[UIView alloc] init];
        _BGView.backgroundColor = [UIColor whiteColor];
        
        [_BGView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_BGView];
        
        
        /**********************/
        /***** IMAGE VIEW *****/
        /**********************/
        _imageView = [[UIImageView alloc] init];
//        [ImageManager getImageFromUrlPath:[DataManager user].picture withCompletion:^(UIImage *image)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                _imageView.image = image;
//            });
//        }];
        
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_imageView];
        
        
        /**********************/
        /***** NAME LABEL *****/
        /**********************/
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont louisMediumLabel];
        
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_nameLabel];
        
        /************************/
        /***** COMING LABEL *****/
        /************************/
        _comingLabel = [[UILabel alloc] init];
        _comingLabel.font = [UIFont louisMediumLabel];
        
        [_comingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_comingLabel];
        
        
        /*********************************/
        /***** COURSE TIME LEFT VIEW *****/
        /*********************************/
        _courseTimeLeftView = [[CourseTimeLeftView alloc] init];
        
        [_courseTimeLeftView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_courseTimeLeftView];
        
        
        /***************************/
        /***** CALL BUTTON *****/
        /**************************/
        _callButton = [[UIButton alloc] init];
        [_callButton setTitle:@"CALL" forState:UIControlStateNormal];
        _callButton.layer.cornerRadius = 3;
        _callButton.backgroundColor = [UIColor louisMainColor];
        _callButton.tintColor = [UIColor whiteColor];
        
        [_callButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_callButton];
        
        
        /***************************/
        /***** SMS LABEL *****/
        /**************************/
        _smsButton = [[UIButton alloc] init];
        [_smsButton setTitle:@"SMS" forState:UIControlStateNormal];
        _smsButton.layer.cornerRadius = 3;
        _smsButton.backgroundColor = [UIColor louisMainColor];
        _smsButton.tintColor = [UIColor whiteColor];
        
        [_smsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_smsButton];
        
        [self addInitialConstraints];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageView.layer setCornerRadius:_imageView.frame.size.height/2];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 6;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.courseTimeLeftView addInitialConstraints];
}


#pragma mark - Setters


-(void)setNameLabelText:(NSString *)name
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@", name];
    _comingLabel.text = @"est en route";
}

-(void)showTime
{
    [self addSubview:self.courseTimeLeftView];
}

-(void)hideTime
{
    [self.courseTimeLeftView removeFromSuperview];
}

-(void)changeToToParkingState
{
    [self hideTime];
    _comingLabel.text = @"est en train de garer votre véhicule";
}


-(void)addInitialConstraints
{
    NSNumber *viewWidth = [NSNumber numberWithFloat:self.frame.size.width];
    NSNumber *viewHeight = [NSNumber numberWithFloat:self.frame.size.height];
    
    NSNumber *BGViewWidth = [NSNumber numberWithFloat:viewWidth.floatValue];
    NSNumber *BGViewHeight = [NSNumber numberWithFloat:109.0f];
    
    NSNumber *imageViewWidth = [NSNumber numberWithFloat:68.0f];
    NSNumber *imageViewHeight = [NSNumber numberWithFloat:68.0f];
    
    NSNumber *nameLabelWidth = [NSNumber numberWithFloat:viewWidth.floatValue * 0.3f];
    
    NSNumber *shortXSpacing = [NSNumber numberWithFloat:6.0f];
    NSNumber *shortYSpacing = [NSNumber numberWithFloat:6.0f];
    
    NSNumber *bigXSpacing = [NSNumber numberWithFloat:14.0f];
    NSNumber *bigYSpacing = [NSNumber numberWithFloat:14.0f];
    
    NSNumber *bigShortYSpacing = [NSNumber numberWithFloat:shortYSpacing.floatValue + bigYSpacing.floatValue];
    
    NSNumber *rightLabelsWidth = [NSNumber numberWithFloat:90.0f];
    
    NSNumber *buttonHeight = [NSNumber numberWithFloat:37.0f];
    NSNumber *buttonWidth = [NSNumber numberWithFloat:(viewWidth.floatValue - (shortXSpacing.floatValue * 3.0f)) /2];  // La moitier de la width moins les trois spacing
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_BGView, _imageView, _nameLabel, _comingLabel, _courseTimeLeftView, _callButton, _smsButton);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(viewWidth, viewHeight, BGViewWidth, BGViewHeight, imageViewWidth, imageViewHeight, nameLabelWidth, buttonHeight, shortXSpacing, shortYSpacing, bigXSpacing, bigShortYSpacing, bigYSpacing, rightLabelsWidth, buttonWidth);
    
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_BGView]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView(imageViewWidth)]-shortXSpacing-[_nameLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]-shortXSpacing-[_comingLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_courseTimeLeftView(rightLabelsWidth)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Horizontale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-shortXSpacing-[_callButton(buttonWidth)]-shortXSpacing-[_smsButton]-shortXSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_BGView(BGViewHeight)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView(imageViewWidth)][_callButton(buttonHeight)]-shortYSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nameLabel][_comingLabel]-bigShortYSpacing-[_callButton]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // Verticale
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_courseTimeLeftView]-[_smsButton(buttonHeight)]-shortYSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
}

@end
