//
//  FeedBackView.m
//  Louis
//
//  Created by Thibault Le Cornec on 19/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "FeedBackView.h"
#import "Common.h"


static UIImage *defaultValetImage;
static UIImage *starEmpty;
static UIImage *starFull;


@interface FeedBackView ()
{
//  =========================
//  FeedBackPopUpView Parts :
        UIView *headerPart;
        UIView *pricePart;
        UIView *valetsPart;
        UIView *commentPart;
        UIView *footerPart;
//  =========================
    
//  ==============================
//  Properties for view's content
//    NSArray *showOnConstraints;
//    NSArray *showOffConstraints;
    NSLayoutConstraint *topMarginPopUpView;
    NSLayoutConstraint *centerYPopUpView;
    
    // ----- PopUp View External Margin ----- //
    NSNumber *verticalMargin;
    NSNumber *topVerticalMarginOffScreen;
    NSNumber *horizontalMargin;
    
    // ----- PopUpView Internal Margin (Padding) ----- //
    NSNumber *horizontalPadding;
    NSNumber *topPadding;
    NSNumber *bottomPadding;
//  ==============================
    
//  ==============================
//  Properties for view's content
    UILabel *dateLabel;
    UILabel *priceLabel;
    UILabel *cardNameLabel;
    UILabel *creditLabel;
    UILabel *firstValetNameLabel;
    UILabel *secondValetNameLabel;
//  ==============================
}
@end



@implementation FeedBackView


- (instancetype)initWithDate:(NSString *)date
                    andPrice:(NSString *)price
                 andCardName:(NSString *)cardName
                   andCredit:(NSString *)credit
               andFirstValet:(NSString *)firstValetName
              andSecondValet:(NSString *)secondValetName
                 andDelegate:(id<FeedBackDelegate, UITextViewDelegate>)delegate;
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self)
    {
        // To be notified when the statusBar frame changed, an observer is added on the notification.
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameChanged:) name:@"UIApplicationDidChangeStatusBarFrameNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameChange:) name:
         @"UIApplicationWillChangeStatusBarFrameNotification" object:nil];
        
        _delegate = delegate;
        
        
        #pragma mark - General Variables
        // *************************************** //
        // ---------- General Variables ---------- //
        // *************************************** //

        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        
        // For iPhone 4s
        if ([SDVersion deviceSize] == Screen3Dot5inch)
        {
            verticalMargin = @20;
            topPadding = verticalMargin;
            bottomPadding = @10;
        }
        else // For iPhone 5, 5c, 5s, 6, 6 Plus, 6s, 6s Plus
        {
            verticalMargin = @35;
            topPadding = @25;
            bottomPadding = @15;
        }
        
        topVerticalMarginOffScreen = @(mainScreenFrame.size.height);
        horizontalMargin = @12;
        horizontalPadding = @10;
        
        NSDictionary *metrics;
        NSDictionary *views;
        
        
        #pragma mark - Blur Effect / Alpha Background
        // **************************************************** //
        // ---------- Blur Effect / Alpha Background ---------- //
        // **************************************************** //
        
        if (UIAccessibilityIsReduceTransparencyEnabled() == NO)
        {
            _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            [_blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_blurEffectView setAlpha:0.0];
            [self addSubview:_blurEffectView];
            
            views = NSDictionaryOfVariableBindings(_blurEffectView);
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
            views = nil;
        }
        else
        {
            [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        }
    
    
        #pragma mark - PopUp View
        // ******************************** //
        // ---------- PopUp View ---------- //
        // ******************************** //
        
        _feedBackPopUpView = [[UIView alloc] init];
        [_feedBackPopUpView setBackgroundColor:[UIColor louisWhiteColor]];
        [[_feedBackPopUpView layer] setCornerRadius:8.0];
        [_feedBackPopUpView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
        NSNumber *popUpViewHeigh = @(mainScreenFrame.size.height - ([verticalMargin integerValue] *2));
        NSNumber *popUpViewWidth = @(mainScreenFrame.size.width - ([horizontalMargin integerValue]*2));
        
//        views   = NSDictionaryOfVariableBindings(_feedBackPopUpView);
//        metrics = NSDictionaryOfVariableBindings(popUpViewWidth, popUpViewHeigh);
        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_feedBackPopUpView(==popUpViewHeigh)]"
//                                                                     options:0
//                                                                     metrics:metrics
//                                                                       views:views]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackPopUpView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:[popUpViewWidth integerValue]]];
        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_feedBackPopUpView(==popUpViewWidth)]"
//                                                                     options:0
//                                                                     metrics:metrics
//                                                                       views:views]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackPopUpView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:[popUpViewHeigh integerValue]]];
        
        // Horizontal Center
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackPopUpView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        topMarginPopUpView = [NSLayoutConstraint constraintWithItem:_feedBackPopUpView
                                                          attribute:NSLayoutAttributeTopMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:1.0
                                                           constant:[topVerticalMarginOffScreen integerValue]];
        [self addConstraint:topMarginPopUpView];
        
        centerYPopUpView = [NSLayoutConstraint constraintWithItem:_feedBackPopUpView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0];
        
        [self addSubview:_feedBackPopUpView];
        
        metrics = nil;
        
        
        #pragma mark - Parts
        // *************************** //
        // ---------- Parts ---------- //
        // *************************** //
        
        headerPart = [[UIView alloc] init];
        [headerPart setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedBackPopUpView addSubview:headerPart];
//        [headerPart setBackgroundColor:[UIColor darkGrayColor]];

        pricePart = [[UIView alloc] init];
        [pricePart setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedBackPopUpView addSubview:pricePart];
        [pricePart setBackgroundColor:[UIColor louisBackgroundApp]];
        
        valetsPart = [[UIView alloc] init];
        [valetsPart setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedBackPopUpView addSubview:valetsPart];
//        [valetsPart setBackgroundColor:[UIColor darkGrayColor]];
        
        commentPart = [[UIView alloc] init];
        [commentPart setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedBackPopUpView addSubview:commentPart];
//        [commentPart setBackgroundColor:[UIColor lightGrayColor]];
        
        footerPart = [[UIView alloc] init];
        [footerPart setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedBackPopUpView addSubview:footerPart];
//        [footerPart setBackgroundColor:[UIColor darkGrayColor]];
    
        metrics = NSDictionaryOfVariableBindings(topPadding, horizontalPadding, bottomPadding);
        views = NSDictionaryOfVariableBindings(headerPart, pricePart, valetsPart, commentPart, footerPart);
        
        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalPadding-[headerPart]-horizontalPadding-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pricePart]|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalPadding-[valetsPart]-horizontalPadding-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalPadding-[commentPart]-horizontalPadding-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalPadding-[footerPart]-horizontalPadding-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

        [_feedBackPopUpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[headerPart]-16-[pricePart]-8-[valetsPart][commentPart][footerPart]-bottomPadding-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

        
        #pragma mark - Header Part
        // ********************************* //
        // ---------- Header Part ---------- //
        // ********************************* //
        
        UILabel *titleLabelHeader = [[UILabel alloc] init];
        [titleLabelHeader setText:[NSLocalizedString(@"FeedBackView-Header-Title", nil) uppercaseString]];
        [titleLabelHeader setTextColor:[UIColor louisTitleAndTextColor]];
        [titleLabelHeader setFont:[UIFont louisHeaderFont]];
        [titleLabelHeader setTextAlignment:NSTextAlignmentCenter];
        [titleLabelHeader setTranslatesAutoresizingMaskIntoConstraints:NO];

        dateLabel = [[UILabel alloc] init];
        [dateLabel setText:date];
        [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dateLabel setTextColor:[UIColor louisLabelColor]];
        [dateLabel setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [headerPart addSubview:titleLabelHeader];
        [headerPart addSubview:dateLabel];
        
        views = NSDictionaryOfVariableBindings(titleLabelHeader, dateLabel);
        
        [headerPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabelHeader]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views]];
        
        [headerPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dateLabel]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views]];

        [headerPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabelHeader][dateLabel]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views]];
        
        #pragma mark - Price Part
        // ******************************** //
        // ---------- Price Part ---------- //
        // ******************************** //
        
        priceLabel = [[UILabel alloc] init];
        [priceLabel setText:price];
        [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [priceLabel setText:NSLocalizedString(@"FeedBackView-Price-Title", nil)];
        [priceLabel setTextColor:[UIColor louisTitleAndTextColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:24.0 weight:UIFontWeightRegular]];
        [priceLabel setTextAlignment:NSTextAlignmentCenter];
        
        cardNameLabel = [[UILabel alloc] init];
        [cardNameLabel setText:cardName];
        [cardNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cardNameLabel setTextColor:[UIColor louisSubtitleColor]];
        [cardNameLabel setFont:[UIFont systemFontOfSize:10.0]];
        [cardNameLabel setTextAlignment:NSTextAlignmentCenter];
        
//        creditLabel
        
        [pricePart addSubview:priceLabel];
        [pricePart addSubview:cardNameLabel];
        
//        NSNumber *labelHeight = @
        
//        metrics = NSDictionaryOfVariableBindings(padding);
        views   = NSDictionaryOfVariableBindings(priceLabel, cardNameLabel);
        
        [pricePart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[priceLabel]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        [pricePart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cardNameLabel]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        [pricePart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[priceLabel][cardNameLabel]-5-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        
        #pragma mark - Valets Part
        // ********************************* //
        // ---------- Valets Part ---------- //
        // ********************************* //
        
        // ----- Title ----- //
        UILabel *titleLabelValets = [[UILabel alloc] init];
        [titleLabelValets setText:NSLocalizedString(@"FeedBackView-Valets-Title", nil)];
        [titleLabelValets setTextColor:[UIColor louisSubtitleColor]];
        [titleLabelValets setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]];
        [titleLabelValets setTextAlignment:NSTextAlignmentLeft];
        [titleLabelValets setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // ----- First Valet  ----- //
        if (defaultValetImage == nil)
        {
            defaultValetImage = [UIImage imageNamed:@"NoPhoto"]; // Instanciate just once to optimize memory.
        }
        
        _firstValetImage = [[UIImageView alloc] initWithImage:defaultValetImage];
        [[_firstValetImage layer] setCornerRadius:55/2];
        
        firstValetNameLabel = [[UILabel alloc] init];
        [firstValetNameLabel setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"FeedBackView-Valets-FirstValet-Prefix", nil), firstValetName]];
        [firstValetNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//                [firstValetNameLabel setBackgroundColor:[UIColor blueColor]];
        
        if (starEmpty == nil)
        {
            starEmpty = [UIImage imageNamed:@"star-empty"];
        }
        
        if (starFull == nil)
        {
            starFull = [UIImage imageNamed:@"star-full"];
        }
        
        NSMutableArray *firstValetStars;
        for (int i = 1; i <= 5; i++)
        {
            UIButton *tempStarButton = nil;
            tempStarButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tempStarButton setImage:starEmpty forState:UIControlStateNormal];
            [tempStarButton setImage:starFull forState:UIControlStateSelected];
            [tempStarButton setTag:i]; // Tag will be used as rate
            [firstValetStars addObject:tempStarButton];
        }
        
        [valetsPart addSubview:titleLabelValets];
        [valetsPart addSubview:firstValetNameLabel];
        
        
        // ----- Optionnal Second Valet ----- //
        if (secondValetName != nil)
        {
            _secondValetImage = [[UIImageView alloc] initWithImage:defaultValetImage];
            [[_secondValetImage layer] setCornerRadius:55/2];
            
            secondValetNameLabel = [[UILabel alloc] init];
            [secondValetNameLabel setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"FeedBackView-Valets-SecondValet-Prefix", nil), secondValetName]];
            [secondValetNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    //        [secondValetNameLabel setBackgroundColor:[UIColor purpleColor]];
                
            [valetsPart addSubview:secondValetNameLabel];
        }
        

        views   = NSDictionaryOfVariableBindings(titleLabelValets, firstValetNameLabel, secondValetNameLabel);
        
        [valetsPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabelValets]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        [valetsPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[firstValetNameLabel]|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];

        [valetsPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[secondValetNameLabel]|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
        
        [valetsPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabelValets]-20-[firstValetNameLabel]-100-[secondValetNameLabel]-50-|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
        
        
        #pragma mark - Comment Part
        // ********************************** //
        // ---------- Comment Part ---------- //
        // ********************************** //
        
        PlaceholderTextView *commentTextView = [[PlaceholderTextView alloc] init];
        [commentTextView setPlaceholder:NSLocalizedString(@"FeedBackView-Comment-Placeholder", nil)];
        [commentTextView setPlaceholderColor:[UIColor louisPlaceholderColor]];
        [commentTextView setDelegate:_delegate];
        [commentTextView setTextColor:[UIColor louisLabelColor]];
        [commentTextView setFont:[UIFont louisLabelFont]];
        [[commentTextView layer] setFrame:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, 1.0f)];
        [[commentTextView layer] setBackgroundColor:[[UIColor blackColor] CGColor]];
        [commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [commentPart addSubview:commentTextView];
        
        views   = NSDictionaryOfVariableBindings(commentTextView);
        
        [commentPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentTextView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        [commentPart addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[commentTextView(25)]-5-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
        
        
        #pragma mark - Footer Part
        // ********************************* //
        // ---------- Footer Part ---------- //
        // ********************************* //
        BigButton *buttonValidate = [BigButton bigButtonTypeMainWithTitle:NSLocalizedString(@"FeedBackView-Button-Title", nil)];
        [buttonValidate addTarget:self action:@selector(saveFeedBack) forControlEvents:UIControlEventTouchUpInside];
        [footerPart addSubview:buttonValidate];
        
        NSNumber *footerWidth   = [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width-([horizontalMargin intValue]*2)];
        NSNumber *padding       = [NSNumber numberWithInt:[buttonValidate heightPoints]];
        NSNumber *buttonWidth   = [NSNumber numberWithFloat:[footerWidth floatValue] * [buttonValidate widthRate]];
        NSNumber *buttonHeight  = [NSNumber numberWithFloat:[buttonValidate heightPoints]];
        
        views   = NSDictionaryOfVariableBindings(buttonValidate);
        metrics = NSDictionaryOfVariableBindings(padding, buttonWidth, buttonHeight);
        
        [footerPart addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buttonValidate(==buttonHeight)]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [footerPart addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buttonValidate(==buttonWidth)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        
        [footerPart addConstraint:[NSLayoutConstraint constraintWithItem:buttonValidate
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:footerPart
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
    
    return self;
}



- (void)showWithStatusBarHeight:(CGFloat)height
{
    if (height == 20)
    {
        [topMarginPopUpView setConstant:[verticalMargin integerValue]];
        [self addConstraint:centerYPopUpView];
    }
    else if (height == 40)
    {
        [topMarginPopUpView setConstant:([verticalMargin integerValue]+20)];
        [self removeConstraint:centerYPopUpView];
    }
    
    // Layout update with animation
    [UIView animateWithDuration:0.3 animations:
     ^{
         if (_blurEffectView != nil && [_blurEffectView alpha] != 1.0)
         {
             [_blurEffectView setAlpha:1.0];
         }
         
         [self layoutIfNeeded];
     }];
}



- (void)show
{
    [GAI sendScreenViewWithName:@"Ride - Feedback"];

    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

    [self layoutIfNeeded];
    // Modification of the top contstraint constant and add new constraint to center view vertically.
    [self showWithStatusBarHeight:[[UIApplication sharedApplication] statusBarFrame].size.height];
}



- (void)dismiss
{
    [self layoutIfNeeded];
    
    // Modification of the top contstraint constant and remove the contraint on the vertically center.
    [topMarginPopUpView setConstant:[topVerticalMarginOffScreen integerValue]];
    [self removeConstraint:centerYPopUpView];
    
    [UIView animateWithDuration:0.3 animations:
     ^{
         if (_blurEffectView != nil)
         {
             [_blurEffectView setAlpha:0.0];
         }

        [ self layoutIfNeeded];
     }];
    
    // Once the animation is finished, the view is below the screen so we remove it from its container.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),
    ^{
        [self removeFromSuperview];
    });
}



- (void)statusBarFrameChange:(NSNotification *)notification
{
    NSDictionary *userInfos = [notification userInfo];
    NSValue *value = [userInfos valueForKey:@"UIApplicationStatusBarFrameUserInfoKey"];
    CGFloat height = [value CGRectValue].size.height;
    
    [self showWithStatusBarHeight:height];
}



- (void)saveFeedBack
{
    [self dismiss];
    
    if ([_delegate respondsToSelector:@selector(userValidatedFeedBack)])
    {
        [_delegate userValidatedFeedBack];
    }
}

@end
