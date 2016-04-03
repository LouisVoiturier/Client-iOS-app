//
//  PaymentTableViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentTableViewCell.h"
#import "Common.h"
#import "AddPaymentTableViewController.h"
#import "DataManager+User_Cards.h"
#import "SectionNameView.h"
#import "ResearchPopupView.h"
#import <Stripe/Stripe.h>

@interface PaymentTableViewController () <AddPaymentTableViewControllerDelegate>

@property (nonatomic, strong) NSArray *sectionsName;
@property (nonatomic, strong) NSArray *creditCards;
@property (nonatomic, strong) BigButtonView *footerView;
@property (nonatomic, strong) UIButton *buttonValidateFilters;
@property (nonatomic, strong) UIAlertController *deleteConfirmationAlert;

@end

@implementation PaymentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Payment-Title", nil)];
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    // ===== Menu Configuration ===== //
    [self configureSWRevealViewControllerForViewController:self
                                            withMenuButton:[self menuButton]];
    
    
    // ===== Footer View ===== //
    self.footerView = [BigButtonView bigButtonViewTypeAltWithTitle:NSLocalizedString(@"Payment-Add-Button", nil) andImage:[UIImage imageNamed:@"add_icon"]];
    
    [self.footerView.button addTarget : self
                               action : @selector (handleAddCardButton:)
                     forControlEvents : UIControlEventTouchUpInside];
    
    [[self tableView] setTableFooterView:self.footerView];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    self.creditCards = [DataManager userCreditCards];
    [GAI sendScreenViewWithName:@"Credit Cards"];
}


#pragma mark - Actions handlers

-(IBAction)handleAddCardButton:(id)sender
{
    AddPaymentTableViewController *addPaymentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPayment"];
    addPaymentTableViewController.delegate = self;

    
    // Segue
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPaymentTableViewController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

//- (IBAction)handleEditModeButton:(id)sender
//{
//    if (self.tableView.editing)
//    {
//        [self.tableView setEditing:NO animated:YES];
//    }
//    else
//    {
//        [self.tableView setEditing:YES animated:YES];
//    }
//}


-(IBAction)changeName:(UIButton *)sender
{
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Payment-NameUpdateAlert-Title", @"")
                                                                            message:NSLocalizedString(@"Payment-NameUpdateAlert-Message", @"")
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
    {
        
    }];
    
    [alertController addAction:defaultAction];
    [alertController addTextFieldWithConfigurationHandler:nil];
    alertController.textFields.firstObject.text = [self getSectionNameFromSection:sender.tag];
    
    [self presentViewController:alertController animated:YES completion:^{
        [GAI sendScreenViewWithName:@"Edit Credit Card"];
    }];
}


-(IBAction)deleteCard:(UIButton *)sender
{
    self.deleteConfirmationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Payment-Delete-Alert-Title", nil)
                                                                       message:NSLocalizedString(@"Payment-Delete-Alert-Message", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:NSLocalizedString(@"Payment-Delete-Alert-Action-No", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [self.tableView setEditing:NO
                                                     animated:YES];
                               }];
    
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:NSLocalizedString(@"Payment-Delete-Alert-Action-Yes", nil)
                                                        style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self.tableView beginUpdates];
                                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag]
                                                  withRowAnimation:UITableViewRowAnimationLeft];
                                    
                                    [DataManager deleteCard:[self.creditCards objectAtIndex:sender.tag]
                                        withCompletionBlock:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
                                     {
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
                                         }
                                     }];
                                    NSMutableArray *creditCardsMutable = [self.creditCards mutableCopy];
                                    [creditCardsMutable removeObjectAtIndex:sender.tag];
                                    self.creditCards = [creditCardsMutable copy];
                                    
                                    [self.tableView endUpdates];
                                    
                                    // On attend la fin de l'animation de suppression pour des questions esthetiques
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                    {
                                        [self.tableView reloadData];
                                    });
                                }];
    
    [self.deleteConfirmationAlert addAction:actionNO];
    [self.deleteConfirmationAlert addAction:actionYES];
    
    [self presentViewController:self.deleteConfirmationAlert animated:YES completion:
     ^{
          [GAI sendScreenViewWithName:@"Delete Credit Card"];
     }];
    self.deleteConfirmationAlert = nil;
    
//    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Payment-Delete-Alert-Title", @"")
//                                                                            message:NSLocalizedString(@"Payment-Delete-Alert-Message", @"")
//                                                                     preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        [DataManager deleteCard:[self.creditCards objectAtIndex:sender.tag]
//                                            withCompletionBlock:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
//                                        {
//                                            
//                                            if (httpResponse.statusCode != 200)
//                                            {
//                                                [HTTPResponseHandler handleHTTPResponse:httpResponse
//                                                                            withMessage:@""
//                                                                          forController:self
//                                                                         withCompletion:^
//                                                 {
//                                                     nil;
//                                                 }];
//                                            }
//                                            else
//                                            {
//                                                self.creditCards = user.creditCards;
//                                                dispatch_async(dispatch_get_main_queue(), ^
//                                                               {
//                                                                   [self.tableView reloadData];
//                                                               });
//                                            }
//                                            
//                                        }];
//                                    }];
//    
//    [alertController addAction:defaultAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Segues

-(IBAction)unwindAfterValidating:(UIStoryboardSegue *)segue
{
    
}


#pragma mark - Helpers

-(NSString *)hiddenCardFormatterWithCard:(NSString *)cardNumbers
{
    return [NSString stringWithFormat:@"**** %@", cardNumbers];
}

-(NSString *)getSectionNameFromSection:(NSInteger)section
{
    if (![(STPCard *)[self.creditCards objectAtIndex:section] name])  // Si la carte n'a pas de nom : on lui donne le nom par défault
    {
        return NSLocalizedString(@"AddPayment-Default-Name", nil);
    }
    else
    {
        return [(STPCard *)[self.creditCards objectAtIndex:section] name];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.creditCards.count;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (![(STPCard *)[self.creditCards objectAtIndex:section] name])
//    {
//        return NSLocalizedString(@"AddPayment-Default-Name", @"");
//    }
//    else
//    {
//        return [(STPCard *)[self.creditCards objectAtIndex:section] name];
//    }
//    
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"displayPayment"
                                                                 forIndexPath:indexPath];
    
    // Configure the cell...
    STPCard *card = [self.creditCards objectAtIndex:indexPath.section];
    NSLog(@"CARD OBJECT : %@", card);
    
    cell.nbCardLabel.text = [self hiddenCardFormatterWithCard:card.last4];
    cell.expirationLabel.text = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)card.expMonth, (unsigned long)card.expYear];
    return cell;
}



// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}



// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    // On prend le row de l'indexPath +1 car on prend en compte le firstObject qui est dans une autre section
//    NSUInteger indexToMove = fromIndexPath.row;
//    
//    NSObject *itemToMove = self.creditCards[indexToMove];
//    NSMutableArray *mutable = [self.creditCards mutableCopy];
//    [mutable removeObjectAtIndex:indexToMove];
//    
//    [mutable insertObject:itemToMove atIndex:0];
//    self.creditCards = mutable;
//    
//    [self.tableView reloadData];
//}



// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *cardName = [self getSectionNameFromSection:section];
    
    SectionNameView *sectionView = [[SectionNameView alloc] init];
    sectionView.tag = section;  // On met le tag de la section egal a la section pour récupéré ses données lors de l'ppuis sur un bouton
    sectionView.cardNameButton.tag = section;
    sectionView.imageButton.tag = section;
    
    [sectionView.cardNameButton setTitle:cardName
                                forState:UIControlStateNormal];
    [sectionView.cardNameButton addTarget:self
                                   action:@selector(changeName:)
                         forControlEvents:UIControlEventTouchUpInside];
    [sectionView.imageButton addTarget:self
                                action:@selector(changeName:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    if (self.creditCards.count > 1)
    {
        sectionView.deleteButton.tag = section;
        [sectionView.deleteButton addTarget:self
                                     action:@selector(deleteCard:)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [sectionView hideDeleButton];
    }
    
    return sectionView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.creditCards.count - 1) // Si c'est la dernière section : on retire le footer pour que le bouton soit mieux placé
    {
        return 0.01f;
    }
    else
    {
        return 20.f;
    }
    
}


#pragma mark - Add Payment TVC delegate method

-(void)didCardAddedSuccefully
{
    [self.tableView beginUpdates];
    
    NSInteger indexToInsert;
    if (self.creditCards.count > 0)  // On le place à l'index 1 si on à plus d'une carte
    {
        indexToInsert = 1;
    }
    else  // Sinon on l'insert dans le premier emplacement
    {
        indexToInsert = 0;
    }
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexToInsert] withRowAnimation:UITableViewRowAnimationRight];
    self.creditCards = [DataManager userCreditCards];
    
    [self.tableView endUpdates];
//    [self.tableView reloadData];
}


@end
