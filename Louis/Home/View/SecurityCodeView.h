//
//  SecurityCodeView.h
//  Louis
//
//  Created by François Juteau on 20/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecurityCodeViewDelegate <NSObject>

-(void)displaySecurityCodePopup;

@end


@interface SecurityCodeView : UIView

@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) id<SecurityCodeViewDelegate> delegate;

@end
