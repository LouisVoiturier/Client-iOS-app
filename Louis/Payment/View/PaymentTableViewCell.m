//
//  PaymentTableViewCell.m
//  Louis
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "PaymentTableViewCell.h"

@interface PaymentTableViewCell()
@end

@implementation PaymentTableViewCell

-(void)awakeFromNib
{
    self.nbCardDescriptionLabel.text = NSLocalizedString(@"Payment-Description-NbCard", @"");
    self.expirationDescriptionLabel.text = NSLocalizedString(@"Payment-Descritpion-Expiration", @"");
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
