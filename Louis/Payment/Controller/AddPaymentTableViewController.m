//
//  AddPaymentTableViewController.m
//  Louis
//
//  Created by François Juteau on 29/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "AddPaymentTableViewController.h"
#import "AddNameTableViewCell.h"
#import "CreditCardTableViewCell.h"
#import "ProfilePictureView.h"
#import "DataManager+User_Cards.h"
#import <Stripe/Stripe.h>
#import "Common.h"
#import "SignUpProfileTableViewController.h"
#import "HomeViewController.h"
#import "PaymentTableViewController.h"
#import "ResearchPopupView.h"


#define NB_SECTIONS 1
#define NB_ROWS 2


@interface AddPaymentTableViewController () <UITextFieldDelegate>


// Data tables
@property (nonatomic, strong) NSArray *labelsCell;
@property (nonatomic, strong) NSString *sectionTitle;

// Footer button
@property (nonatomic, strong) BigButtonView *footerView;
@property (nonatomic, strong) ProfilePictureView *profilePicture;

/** Origine controller */
@property (nonatomic, strong) UIViewController *origineController;


@end

@implementation AddPaymentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    // si on vient de SignUpProfileTVC, on continue l'inscription
    self.origineController = [self backViewController];
    if ([self.origineController isKindOfClass:[SignUpProfileTableViewController class]])
    {
        [self configureForSignUp];
    }
    else  // On a la même présentation si on vient de HomeViewController ou PaymentTableViewController
    {
        [self configureForAddPayment];
    }
    
    /***** Register *****/
    [self.tableView registerClass:[CreditCardTableViewCell class] forCellReuseIdentifier:@"credit"];
    [self.tableView registerClass:[AddNameTableViewCell class] forCellReuseIdentifier:@"name"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AddNameTableViewCell *addNameCell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [[addNameCell nameLabel] becomeFirstResponder];
}


-(void) configureForAddPayment
{
    [GAI sendScreenViewWithName:@"Add Credit Card"];
    
    
    // ===== Init data tables ===== //
    [self setTitle:NSLocalizedString(@"AddPayment-Title", @"")];

    
    /** Ajout du bouton d'annulation sur la navbar */
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(handleCancelButton)];
    cancelButton.tintColor = [UIColor louisMainColor];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    
    /***** Header *****/  // A revoir : il y a un espace quand on vient de payment mais pas home
    UIView *headerVoid = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
    [self.tableView setTableHeaderView:headerVoid];
    
    
    /***** Footer *****/
    self.footerView = [BigButtonView bigButtonViewTypeMainWithTitle:@"Enregistrer"];
    
    [self.footerView.button addTarget:self
                               action:@selector(save:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTableFooterView:self.footerView];
}


-(void) configureForSignUp
{
    [GAI sendScreenViewWithName:@"Subscription Step 3"];
    
    [self setTitle:NSLocalizedString(@"Sign-Up-Title", nil)];
    
    // Ajout Bar bouton de raccourci à droite pour test dev uniquement
    UIBarButtonItem *barBoutonLater = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SignUp-AddPayment-Later", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goToGoelocForbiddenTouch)];
    barBoutonLater.tintColor = [UIColor louisMainColor];
    
    self.navigationItem.rightBarButtonItem = barBoutonLater;

    self.navigationItem.hidesBackButton = YES;
    
    /***** Header *****/
    self.profilePicture = [[ProfilePictureView alloc] initWithFrameAndLabelsOnTheLeftAndBottom:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.25)];
    
    [self.tableView setTableHeaderView:self.profilePicture];
    
    /***** Footer *****/
    self.footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"SignUp-Button-Record", nil)];
    
    [self.footerView.button addTarget:self
                               action:@selector(save:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTableFooterView:self.footerView];
}


-(IBAction) goToGoelocForbiddenTouch
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *geolocForbiddenVC = [sb instantiateViewControllerWithIdentifier:@"GeolocForbiddenVC"];
    [[self navigationController] pushViewController:geolocForbiddenVC animated:YES];

}


// Détermine l'origine de l'appel. On vient du SignUpProfileTVC ou bien du PaymentTVC
- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}


#pragma mark - Outlet handlers

- (IBAction)save:(id)sender
{
    AddNameTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CreditCardTableViewCell *stripeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([nameCell.nameLabel.text isEqual:@""])
    {
        stripeCell.card.name = NSLocalizedString(@"AddPayment-Default-Name", @"");
    }
    else
    {
        stripeCell.card.name = nameCell.nameLabel.text;
    }
    
    NSLog(@"STPAPIClient sharedClient");
    
    [[STPAPIClient sharedClient] createTokenWithCard:stripeCell.card
                                          completion:^(STPToken *token, NSError *error)
    {
          if (error)
          {
              NSLog(@"TOKEN ERROR *************************");
//            [self handleError:error];
          }
          else
          {
//              ResearchPopupView *RPV = [[ResearchPopupView alloc] init];
//              [RPV changeToSearchingStateWithMessage:NSLocalizedString(@"ResearchPopup-BotText-Searching", @"")];
              
              [DataManager addCreditCard:token withCompletionBlock:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
//                                     [RPV dismiss];
                                 });
                  if (httpResponse.statusCode != 200)
                  {
                      [HTTPResponseHandler handleHTTPResponse:httpResponse
                                                  withMessage:@""
                                                forController:self
                                               withCompletion:^
                       {
                           nil;
                       }];
                  }
                  else
                  {
                      if (!error)
                      {
                          NSLog(@"Avant DataManager addCreditCard %@", user.description);
                          
                          //                      NSLog(@"COMPLETE : %@", user.description);
                          dispatch_async(dispatch_get_main_queue(), ^
                                         {
//                                             [RPV dismiss];
                                             if ([self.origineController isKindOfClass:[SignUpProfileTableViewController class]])
                                             {
                                                 [self goToGoelocForbiddenTouch];
                                             }
                                             else
                                             {
                                                 [self.delegate didCardAddedSuccefully];
                                             }
                                         });
                      }
                      else
                      {
                          NSLog(@"SAVE ERROR **************************");
                      }
                  }
              }];
              
              [[self navigationController] dismissViewControllerAnimated:YES completion:^{}];
          }
    }];
}


-(void)handleCancelButton
{
    if ([self.delegate respondsToSelector:@selector(didCancelAdding)])
    {
        [self.delegate didCancelAdding];
    }
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NB_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NB_ROWS;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AddNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
        [cell awakeFromNib];
        return cell;
    }
    else
    {
        CreditCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"credit" forIndexPath:indexPath];
        [cell awakeFromNib];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}



@end
