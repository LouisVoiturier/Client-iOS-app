//
//  DescriptionBottomView.h
//  Louis
//
//  Created by François Juteau on 08/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionBottomView : UIView

@property (nonatomic, strong) UILabel *hourDescLabel;
@property (nonatomic, strong) UILabel *hourTextLabel;

@property (nonatomic, strong) UILabel *pricesDescLabel;
@property (nonatomic, strong) UILabel *pricesTextLabel;

@property (nonatomic, strong) UILabel *exceptionLabel;


#pragma mark - Change texts methods

-(void)changeHiddenStateForExceptionView:(BOOL)boolean;

-(void)changeToBookTextState;

-(void)changeToParkedTextState;


#pragma mark - Constraints methods

-(void)addInitialConstraints;

@end
