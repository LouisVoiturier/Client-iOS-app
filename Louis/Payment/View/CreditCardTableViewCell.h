//
//  CreditCardTableViewCell.h
//  Louis
//
//  Created by François Juteau on 30/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>

@interface CreditCardTableViewCell : UITableViewCell

@property (nonatomic, strong) STPCard *card;

@end
