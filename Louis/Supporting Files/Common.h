//
//  Common.h
//  Louis
//
//  Created by Thibault Le Cornec on 29/09/15.
//  Copyright © 2015 Louis. All rights reserved.
//

// ===== Google Analytics ===== //
#import "GAI+Helpers.h"

// ===== Basics ===== //
#import "UIColor+Louis.h"
#import "UIFont+Louis.h"

// ===== Custom Views ===== //
#import "BigButton.h"
#import "BigButtonView.h"
#import "UIPlaceHolderTextView.h"

// ===== View Controllers ===== //
#import "UIViewController+RevealViewController.h"

// ===== Frameworks ===== //
#import "SDVersion.h"

// ===== Outils ====== //
#import "Tools.h"

// ===== HTTPResponseHandler ===== //
#import "HTTPResponseHandler.h"



#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif
