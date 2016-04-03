//
//  UIFont+Louis.h
//  Louis
//
//  Created by Thibault Le Cornec on 09/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Louis)
/** System:17 / Regular **/
+ (instancetype)louisHeaderFont;
/** System:16 / Regular **/
+ (instancetype)louisLabelFont;
/** System:16 / SemiBold **/
+ (instancetype)louisSubtitleFont;
/** System:20 / SemiBold **/
+ (instancetype)buttonMainFont;
/** System:16 / Medium **/
+ (instancetype)buttonAltFont;
/** System:7 / Regular **/
+ (instancetype)louisSmallestLabel;
/** System:9 / Regular **/
+ (instancetype)louisSmallLabel;
/** System:10 / Regular **/
+ (instancetype)louisSmallishLabel;
/** System:12 / Regular **/
+ (instancetype)louisMediumLabel;
/** System:24 / Regular **/
+ (instancetype)louisBigLabel;

@end
