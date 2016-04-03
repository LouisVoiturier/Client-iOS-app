//
//  CreditCardTableViewCell.m
//  Louis
//
//  Created by François Juteau on 30/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "CreditCardTableViewCell.h"

@interface CreditCardTableViewCell ()<STPPaymentCardTextFieldDelegate>

//@property (nonatomic) UIView *view;
@property (nonatomic) STPPaymentCardTextField *paymentTextField;

@end


@implementation CreditCardTableViewCell

- (void)awakeFromNib
{
    self.card = [[STPCard alloc] init];
    
    // Initialisation du STPPaymentCardTextField
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 50, CGRectGetHeight(self.frame) - 10)];;
    
    self.paymentTextField.borderWidth = 0;

    self.paymentTextField.delegate = self;
    [self addSubview:self.paymentTextField];

    /***** CONTRAINTES *****/
    [self.paymentTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *vAlign = [NSLayoutConstraint constraintWithItem:self.paymentTextField
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0.0];
    
    NSLayoutConstraint *hAlign = [NSLayoutConstraint constraintWithItem:self.paymentTextField
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0];
    
    [self addConstraints:@[vAlign, hAlign]];
    
    // Empeche la selection de la cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField
{
    if (textField.isValid)
    {
        self.card.number = textField.cardNumber;
        self.card.expMonth = textField.expirationMonth;
        self.card.expYear = textField.expirationYear;
        self.card.cvc = textField.cvc;
        NSLog(@"everithing worked well");
    }
}

@end
