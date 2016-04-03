//
//  UIColor+Louis.m
//  Louis
//
//  Created by Thibault Le Cornec on 14/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import "UIColor+Louis.h"

@implementation UIColor (Louis)


// ===== Global ===== //

+ (instancetype)louisHeaderColor // white
{
    return [UIColor louisWhiteColor];
}


+ (instancetype)louisWhiteColor // white (#FFFFFF)
{
    return [UIColor whiteColor];
}


+ (instancetype)louisBackgroundApp // Light gray (#F3F3F3)
{
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
}


+ (instancetype)louisMainColor // Purple (#7E1046)
{
    return [UIColor colorWithRed:0.58 green:0.13 blue:0.35 alpha:1];
}


+ (instancetype)louisTitleAndTextColor // Black
{
    return [UIColor blackColor];
}


+ (instancetype)louisSubtitleColor // Dark Gray (#4A4A4A)
{
    return [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
}


+ (instancetype)louisLabelColor // Dark Gray (#7A7A7A)
{
    return [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1];
}


+ (instancetype)louisPlaceholderColor // Light Gray (#BFBFBF)
{
    return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
}

+ (instancetype)louisConfirmColor // Green (#02880f)
{
    return [UIColor colorWithRed:2.0f/255.0f green:136.0f/255.0f blue:15.0f/255.0f alpha:1.0f];
}

+ (instancetype)louisAnthracite // Anthracite
{
    return [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
}


// ===== Buttons Colors ===== //

// ----- Main ----- //
+ (instancetype)buttonMainDisabledBackgroundColor // Purple (#AD889A)
{
    return [UIColor colorWithRed:0.74 green:0.61 blue:0.67 alpha:1];
}


+ (instancetype)buttonMainEnabledBackgroundColor // Purple
{
    return [UIColor louisMainColor];
}


+ (instancetype)buttonMainSelectedBackgroundColor // Purple (#640534)
{
    return [UIColor colorWithRed:0.47 green:0.07 blue:0.27 alpha:1];
}


+ (instancetype)buttonMainTintColor // White
{
    return [UIColor louisWhiteColor];
}


// ----- Alt ----- //
+ (instancetype)buttonAltTintColor // Dark Gray
{
    return [UIColor louisSubtitleColor];
}


+ (instancetype)buttonAltBackgroundColor // White
{
    return [UIColor louisWhiteColor];
}


+ (instancetype)buttonAltBorderColor // Light Gray (#CFCFCF)
{
    return [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
}



@end
