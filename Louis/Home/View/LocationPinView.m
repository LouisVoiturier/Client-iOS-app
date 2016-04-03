//
//  LocationPinView.m
//  Louis
//
//  Created by François Juteau on 07/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "LocationPinView.h"
#import "Common.h"
#import "LocationArrowView.h"

static CGFloat spacing = 7.f;

@interface LocationPinView()

@property (nonatomic, strong) UIView *pannelView;

@property (nonatomic, strong) UILabel *minutesLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *outsideDescLabel;

@property (nonatomic, strong) LocationArrowView *locationArrowView;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end


@implementation LocationPinView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
        
        
        /***********************/
        /***** PANNEL VIEW *****/
        /***********************/
        _pannelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 37.f)];
        _pannelView.layer.cornerRadius = 3.f;
        _pannelView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_pannelView];
        
        
        /**********************/
        /***** TIME LABEL *****/
        /**********************/
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont louisLabelFont];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_timeLabel];
        
        
        /*************************/
        /***** MINUTES LABEL *****/
        /*************************/
        _minutesLabel = [[UILabel alloc] init];
        _minutesLabel.font = [UIFont louisSmallishLabel];
        _minutesLabel.textColor = [UIColor whiteColor];
        _minutesLabel.textAlignment = NSTextAlignmentCenter;
        _minutesLabel.text = @"min";
        
        [_minutesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_minutesLabel];
        
        
        /*****************************/
        /***** DESCRIPTION LABEL *****/
        /*****************************/
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont louisHeaderFont];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        
        [_descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_descriptionLabel];
        
        
        /*************************************/
        /***** OUTSIDE DESCRIPTION LABEL *****/
        /*************************************/
        _outsideDescLabel = [[UILabel alloc] init];
        _outsideDescLabel.font = [UIFont louisHeaderFont];
        _outsideDescLabel.textColor = [UIColor whiteColor];
        _outsideDescLabel.textAlignment = NSTextAlignmentCenter;
        _outsideDescLabel.text = NSLocalizedString(@"Home-LocationPin-Outzone", @"");
        _outsideDescLabel.hidden = YES;
        
        [_outsideDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_outsideDescLabel];
        
        
        /*******************************/
        /***** LOCATION ARROW VIEW *****/
        /*******************************/
        _locationArrowView = [[LocationArrowView alloc] init];
        _locationArrowView.hidden = YES;
        
        [_locationArrowView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_locationArrowView];
        
        
        /**********************************/
        /***** TAP GESTURE RECOGNIZER *****/
        /**********************************/
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOffZone:)];
        
        
        [self addInitialConstraints];
        
        
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    [[UIColor blackColor] set];
    
    UIBezierPath *barPath = [UIBezierPath bezierPath];
    
    [barPath moveToPoint:CGPointMake(selfWidth * 0.5, selfHeight * 0.5)];
    [barPath addLineToPoint:CGPointMake(selfWidth * 0.5, selfHeight)];
    
    [barPath setLineWidth:2];
    
    [barPath stroke];
    
}


#pragma mark - Setters

-(void)setDescriptionLabelText:(NSString *)text
{
    self.descriptionLabel.text = text;
}

-(void)changeToOffZoneContent
{
    self.timeLabel.hidden = YES;
    self.minutesLabel.hidden = YES;
    self.descriptionLabel.hidden = YES;
    
    self.outsideDescLabel.hidden = NO;
    self.locationArrowView.hidden = NO;
   
    
    // On set la taille de la vue par rapport à la taille du text
    CGFloat dynamicTextWidth = [self.outsideDescLabel.text boundingRectWithSize:self.superview.frame.size
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{ NSFontAttributeName:self.outsideDescLabel.font }
                                                                        context:nil].size.width;
    
    CGFloat dynamicGlobalWidth = dynamicTextWidth + (spacing * 3) + self.locationArrowView.frame.size.width;
    
    [self resizePannelFromWidth:dynamicGlobalWidth];
    
    
    [self.pannelView addGestureRecognizer:self.tapRecognizer];
}

-(void)changeToInZoneContent
{
    self.timeLabel.hidden = NO;
    self.minutesLabel.hidden = NO;
    self.descriptionLabel.hidden = NO;
    
    self.outsideDescLabel.hidden = YES;
    self.locationArrowView.hidden = YES;
    
    [self setDescriptionLabelText:NSLocalizedString(@"Home-PinLabel-RDV", @"")];
    
    // On set la taille de la vue par rapport à la taille du text
    CGFloat dynamicTextWidth = [self.descriptionLabel.text boundingRectWithSize:self.superview.frame.size
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{ NSFontAttributeName:self.descriptionLabel.font }
                                                                        context:nil].size.width;
    
    CGFloat dynamicGlobalWidth = dynamicTextWidth + (spacing * 2) + self.timeLabel.frame.size.width;
    
    [self resizePannelFromWidth:dynamicGlobalWidth];
    
    [self.pannelView removeGestureRecognizer:self.tapRecognizer];
    
}


#pragma mark - Selectors


-(void)handleTapOffZone:(UITapGestureRecognizer *)sender
{
    [self.delegate replacepinToCenterZone];
}


#pragma mark - Helpers


-(void)resizePannelFromWidth:(CGFloat)width
{
    CGFloat offset = (self.frame.size.width - width) / 2; // On ajoute la moitier de la différence qu'on vient d'effectuer pour que le pin reste au milieu
    
    self.frame = CGRectMake(self.frame.origin.x + offset,
                            self.frame.origin.y,
                            width,
                            self.frame.size.height);
    
    
    self.pannelView.frame = CGRectMake(self.pannelView.frame.origin.x,
                                       self.pannelView.frame.origin.y,
                                       width + 1,  // On ajoute 1 car la taille récupéré est trop juste, donc le label ne s'affiche pas en entier
                                       self.pannelView.frame.size.height);
}



#pragma mark - Constraints method

-(void)addInitialConstraints
{
    
    NSNumber *timeWidth = [NSNumber numberWithFloat:30.f];
    NSNumber *timeHeight = [NSNumber numberWithFloat:15.f];
    NSNumber *labelSpacing = [NSNumber numberWithFloat:spacing];
    
    NSNumber *arrowWidth = [NSNumber numberWithFloat:15.f];
    NSNumber *arrowHeight = [NSNumber numberWithFloat:20.f];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_timeLabel, _minutesLabel, _descriptionLabel, _outsideDescLabel, _locationArrowView);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(timeWidth, timeHeight, labelSpacing, arrowWidth, arrowHeight);
    
    
    /***********************/
    /***** INSIDE ZONE *****/
    /***********************/
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_timeLabel(timeWidth)][_descriptionLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_minutesLabel][_descriptionLabel]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelSpacing-[_timeLabel(timeHeight)][_minutesLabel]-labelSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelSpacing-[_descriptionLabel]-labelSpacing-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    
    /************************/
    /***** OUTSIDE ZONE *****/
    /************************/
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-labelSpacing-[_outsideDescLabel]-labelSpacing-[_locationArrowView(arrowWidth)]-labelSpacing-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelSpacing-[_outsideDescLabel]-labelSpacing-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_locationArrowView(arrowHeight)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    
    [_pannelView addConstraint:[NSLayoutConstraint constraintWithItem:_locationArrowView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_pannelView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
    
    
}

@end
