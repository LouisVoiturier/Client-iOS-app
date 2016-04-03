//
//  PaymentTableViewCell.h
//  Louis
//
//  Created by François Juteau on 28/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nbCardDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nbCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;

@end
