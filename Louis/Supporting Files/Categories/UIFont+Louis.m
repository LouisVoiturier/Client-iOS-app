//
//  UIFont+Louis.m
//  Louis
//
//  Created by Thibault Le Cornec on 09/10/15.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "UIFont+Louis.h"

@implementation UIFont (Louis)

/** System:17 / Regular **/
+ (instancetype)louisHeaderFont
{
    return [UIFont systemFontOfSize:17.f weight:UIFontWeightRegular];
}

/** System:16 / Regular **/
+ (instancetype)louisLabelFont
{
    return [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
}

/** System:16 / Bold **/
+ (instancetype)louisSubtitleFont
{
    return [UIFont systemFontOfSize:16.f weight:UIFontWeightSemibold];
}

/** System:20 / SemiBold **/
+ (instancetype)buttonMainFont
{
    return [UIFont systemFontOfSize:20.f weight:UIFontWeightSemibold];
}

/** System:16 / Medium **/
+ (instancetype)buttonAltFont
{
    return [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
}

/** System:7 / Regular **/
+ (instancetype)louisSmallestLabel
{
    return [UIFont systemFontOfSize:7.f weight:UIFontWeightRegular];
}

/** System:9 / Regular **/
+ (instancetype)louisSmallLabel
{
    return [UIFont systemFontOfSize:9.f weight:UIFontWeightRegular];
}

/** System:10 / Regular **/
+ (instancetype)louisSmallishLabel
{
    return [UIFont systemFontOfSize:10.f weight:UIFontWeightRegular];
}

/** System:12 / Regular **/
+ (instancetype)louisMediumLabel
{
    return [UIFont systemFontOfSize:12.f weight:UIFontWeightRegular];
}

/** System:24 / Regular **/
+ (instancetype)louisBigLabel
{
    return [UIFont systemFontOfSize:24.f weight:UIFontWeightRegular];
}


@end
