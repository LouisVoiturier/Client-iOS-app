//
//  UIColor+Louis.h
//  Louis
//
//  Created by Thibault Le Cornec on 14/09/2015.
//  Copyright (c) 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Louis)

// ===== Global ===== //
/** white (#FFFFFF) **/
+ (instancetype)louisHeaderColor;
/** white (#FFFFFF) **/
+ (instancetype)louisWhiteColor;
/** Light gray (#F3F3F3) **/
+ (instancetype)louisBackgroundApp;
/** Purple (#7E1046) **/
+ (instancetype)louisMainColor;
/** Black **/
+ (instancetype)louisTitleAndTextColor;
/** Dark Gray (#4A4A4A) **/
+ (instancetype)louisSubtitleColor;
/** Dark Gray (#7A7A7A) **/
+ (instancetype)louisLabelColor;
/** Light Gray (#BFBFBF) **/
+ (instancetype)louisPlaceholderColor;
/** Green (#02880f) **/
+ (instancetype)louisConfirmColor;
/** Anthracite **/
+ (instancetype)louisAnthracite;


// ===== Buttons Colors ===== //
// ----- Main
/** Purple (#AD889A) **/
+ (instancetype)buttonMainDisabledBackgroundColor;
/** Purple **/
+ (instancetype)buttonMainEnabledBackgroundColor;
/** Purple (#640534) **/
+ (instancetype)buttonMainSelectedBackgroundColor;
/** White **/
+ (instancetype)buttonMainTintColor;
// ----- Alt
/** Dark Gray **/
+ (instancetype)buttonAltBackgroundColor;
/** White **/
+ (instancetype)buttonAltBorderColor;
/** Light Gray (#CFCFCF) **/
+ (instancetype)buttonAltTintColor;


@end
