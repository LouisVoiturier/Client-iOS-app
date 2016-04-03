//
//  FeedBackView.h
//  Louis
//
//  Created by Thibault Le Cornec on 19/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Valet.h"



@protocol FeedBackDelegate <NSObject>

- (void)userRateValet:(NSString *)valetName with:(int)rate;
- (void)userValidatedFeedBack;

@end


@interface FeedBackView : UIView

@property (strong, nonatomic) id<FeedBackDelegate, UITextViewDelegate> delegate;

//TODO: A mettre en private :
@property (strong, nonatomic, readonly) UIVisualEffectView *blurEffectView;
@property (strong, nonatomic, readonly) UIView *feedBackPopUpView;
// =====

@property (strong, nonatomic) UIImageView *firstValetImage;
@property (strong, nonatomic) UIImageView *secondValetImage;


- (instancetype)initWithDate:(NSString *)date
                    andPrice:(NSString *)price
                 andCardName:(NSString *)cardName
                   andCredit:(NSString *)credit
               andFirstValet:(NSString *)firstValetName
              andSecondValet:(NSString *)secondValetName
                 andDelegate:(id<FeedBackDelegate, UITextViewDelegate>)delegate;

- (void)show;
- (void)dismiss;

@end

