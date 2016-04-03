//
//  AddPaymentTableViewController.h
//  Louis
//
//  Created by François Juteau on 29/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPaymentTableViewControllerDelegate <NSObject>
-(void)didCardAddedSuccefully;

@optional
-(void)didCancelAdding;

@end


@interface AddPaymentTableViewController : UITableViewController

@property (nonatomic, strong) id <AddPaymentTableViewControllerDelegate> delegate;

@end
