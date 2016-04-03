//
//  ProfileTableViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "Common.h"
#import "KeychainWrapper.h"
#import "ProfilePictureViewWithButton.h"
#import "ProfileTableViewCell.h"
#import "ProfilePwdTableViewCell.h"
#import "DataManager+User.h"

#define kPictureCellHeight 100
#define KDefautCellHeight 44
#define kProfileCell "ProfileCell"
#define kProfilePwdCell "ProfilePwdCell"
#define kProfileDisconnectCell "ProfileDisconnectCell"


@interface ProfileTableViewController () 
@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;
@property BigButtonView *footerView;
@property (nonatomic,strong) ProfilePictureViewWithButton *profilePicture;
@property (nonatomic, strong) DataManager *dataManager;

@end

@implementation ProfileTableViewController
static UIImage *myPicture;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor louisBackgroundApp]];
    [self setTitle:NSLocalizedString(@"Profile-Title", nil)];
    [[[self navigationController] navigationBar] setTintColor:[UIColor louisMainColor]];
    
    _dataManager = [DataManager sharedInstance];
    
    
    // Configure cellule de la tableview
    [self configureCells];
    
    // Le clavier disparait quand on clique sur l'écran
    [self dismissKeyboardOnTapGesture];
    
    [self addProfilePicture];
    
//    [self addButtonDisconnect];
    
    // ===== Menu Configuration ===== //
    [self configureSWRevealViewControllerForViewController:self
                                            withMenuButton:[self menuButton]];
    
    
}

-(void)dismissKeyboardOnTapGesture
{
    // Le clavier disparait quand on clique sur l'écran
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // attention, la propriété ci-dessous doit absolument être positionné à "NO" sinon on ne passera jamais par le didSelectRowAtIndexPath
    tap.cancelsTouchesInView = NO;
    
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
//    if (_dataManager.user.pictureImage)
    if ([DataManager user].pictureImage)
    {
        [_profilePicture imageView].image = _dataManager.user.pictureImage;
    }
     [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [GAI sendScreenViewWithName:@"Profile"];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enlever le clavier
    [[self view] endEditing:YES];
    
    
    // Change "back" bar button name for the next viewcontroller
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CancelButtonItem-Title",nil)
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:nil
//                                                                     action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
}


- (void)configureCells {
    
    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc]init];
    [firstSection addObject:@(TypedefEnumSignUpProfileCellTypeFirstName)];
    [firstSection addObject:@(TypedefEnumSignUpProfileCellTypeLastName)];
    [firstSection addObject:@(TypedefEnumSignUpProfileCellTypePhoneNumber)];
    [firstSection addObject:@(TypedefEnumSignUpProfileCellTypeEmail)];
    
    NSMutableArray *secondSection = [[NSMutableArray alloc]init];
    [secondSection addObject:@(TypedefEnumSignUpProfileCellTypePassword)];

    NSMutableArray *thirdSection = [[NSMutableArray alloc]init];
    [thirdSection addObject:@(TypedefEnumSignUpProfileCellTypeDisconnectButton)];
    
    [self.cellTypesGroupedBySection addObject:firstSection];
    [self.cellTypesGroupedBySection addObject:secondSection];
    [self.cellTypesGroupedBySection addObject:thirdSection];

    
}


-(void) addProfilePicture
{
    
    /***** Header *****/
    //Ajouter photo sans rien
    _profilePicture = [[ProfilePictureViewWithButton alloc] initWithFrameAndBottomButton:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.25)];
    [[_profilePicture firstButton] setHidden:YES];
   
    [self.tableView setTableHeaderView:self.profilePicture];
    
    [_profilePicture imageView].userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapTouch)];
    [[_profilePicture imageView] addGestureRecognizer:tap];

}

-(IBAction)pictureTapTouch
{
    [self performSegueWithIdentifier:@"ProfileToProfileSetup" sender:self];

}

//
//-(void) addButtonDisconnect
//{
//    //Ajouter le bouton dans le footerview
//    _footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"Profile-Disconnect-Button", nil)];
//    
//    [[_footerView button] addTarget:self action:@selector(toDisconnectButtonTouch) forControlEvents:UIControlEventTouchUpInside];
//    [[_footerView button] setEnabled:YES];
//    [[self tableView] setTableFooterView:_footerView];
//}


// ne pas supprimer.
- (IBAction)barButtonModifyTouch:(UIBarButtonItem *)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.cellTypesGroupedBySection count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *rows = [self.cellTypesGroupedBySection objectAtIndex:section];
    return [rows count];
    
}
    

-(void) configureProfileCell:(ProfileTableViewCell *)cell withCellType:(TypedefEnumSignUpProfileCellType)cellType
{
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.profileLabel setTextColor:[UIColor louisLabelColor]];
    [cell.profileLabel setFont:[UIFont louisLabelFont]];
    [cell.profileTextField setTextColor:[UIColor louisTitleAndTextColor]];
    [cell.profileTextField setFont:[UIFont louisLabelFont]];
    
    switch (cellType)
    {
        case TypedefEnumSignUpProfileCellTypeFirstName:
        {
            cell.profileLabel.text     = NSLocalizedString(@"Profile-FirstName-Label", nil);
            cell.profileTextField.text = _dataManager.user.firstName;
            break;
        }
        case TypedefEnumSignUpProfileCellTypeLastName:
        {
            cell.profileLabel.text     = NSLocalizedString(@"Profile-LastName-Label", nil);
            cell.profileTextField.text = _dataManager.user.lastName;
            break;
        }
        case TypedefEnumSignUpProfileCellTypePhoneNumber:
        {
            cell.profileLabel.text     = NSLocalizedString(@"Profile-PhoneNumber-Label", nil);
            cell.profileTextField.text = _dataManager.user.cellPhone;
            break;
        }
        case TypedefEnumSignUpProfileCellTypeEmail:
        {
            cell.profileLabel.text     = NSLocalizedString(@"Sign-Email-Label", nil);
            cell.profileTextField.text = _dataManager.user.email;
            break;
        }
        default:
            break;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DataManager *dataManager = [DataManager sharedInstance];
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0 :
        {
            ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@kProfileCell forIndexPath:indexPath];
            
            TypedefEnumSignUpProfileCellType cellType = [[[self.cellTypesGroupedBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];

            [self configureProfileCell:profileCell withCellType:cellType];
            cell = profileCell;
            break;
        }
        case 1 :
        {
            ProfilePwdTableViewCell *profilePwdCell = [tableView dequeueReusableCellWithIdentifier:@kProfilePwdCell forIndexPath:indexPath];
            
            profilePwdCell.profilePwdLabel.text = NSLocalizedString(@"Sign-Pwd-Label", nil);
            [profilePwdCell.profilePwdLabel setTextColor:[UIColor louisLabelColor]];
            [profilePwdCell.profilePwdLabel setFont:[UIFont louisLabelFont]];
            
            [_dataManager.user setPassword:[[_dataManager userCredentials] valueForKey:@"password"]];
            profilePwdCell.profilePwdTextField.text = _dataManager.user.password;
            profilePwdCell.profilePwdTextField.secureTextEntry = YES;
            [profilePwdCell.profilePwdTextField setUserInteractionEnabled:NO];
            
            [profilePwdCell.modifyButtonOutlet setTitle:NSLocalizedString(@"Profile-Button-Modify", nil) forState:UIControlStateNormal];
            [profilePwdCell.modifyButtonOutlet setTintColor:[UIColor louisMainColor]];
            
            cell = profilePwdCell;
            break;
        }
        case 2 :
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@kProfileDisconnectCell forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Profile-Disconnect-Button", nil);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            [cell.textLabel setFont:[UIFont louisLabelFont]];
            
        }

    }
    return cell;
    
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"ProfileToChangePwd" sender:self];
    }
    if (indexPath.section == 2)
    {
        [self toDisconnect];
    }
}




//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0f;

    if (section == 1)
    {
        headerHeight = 11.0f ;
    }
    if (section == 2)
    {
        headerHeight = 22.0f ;
    }

    return headerHeight;
}


// se déconnecter de l'application

//-(IBAction)toDisconnectButtonTouch
//{
//}


-(void) resetUserPwdInKeyChain
{
    NSLog(@"NSUserDefaults : mettre la clé hasLoginKey=false");
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLoginKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"RAZ user=""/pwd="" dans keychain.");
    
    KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
    
    [MyKeychainWrapper mySetObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [MyKeychainWrapper mySetObject:@"" forKey:(__bridge id)kSecValueData];
    [MyKeychainWrapper writeToKeychain];
}

-(void) toDisconnect
{
    //Initialisation d'un actionSheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Profile-Disconnect-Confirm-Title", nil)
                                                                         message:NSLocalizedString(@"Profile-Disconnect-Confirm-Msg", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-YES", nil)
                                                 style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
                         {

                             [self resetUserPwdInKeyChain];
                             DataManager *dataManager = [DataManager sharedInstance];
                             dataManager.user = nil;
                             if (iOSVersionGreaterThan(@"9")) {
                                 [[UIApplication sharedApplication] setShortcutItems:nil];
                             }
                            [self gotoWelcomeViewController];
                         }];
    
    [actionSheet addAction:yesButton];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-NO", nil)
                                                 style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                         {
                             // Ne rien faire
                         }];
    
    [actionSheet addAction:noButton];
    
    [self presentViewController:actionSheet animated:true completion:^{
        [GAI sendScreenViewWithName:@"Logout"];
    }];
    
}


-(void) gotoWelcomeViewController
{
    // on accède au storyboard défini dans le Main.storyboard (ie : accès à WelcomeViewController).
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *swrevealViewController = [sb instantiateViewControllerWithIdentifier:@"SWRevealVC"];
    
    [UIView transitionWithView:[[[UIApplication sharedApplication] delegate] window]
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [[[[UIApplication sharedApplication] delegate] window] setRootViewController :swrevealViewController];
                                }
                    completion:nil];
}

//
//// A coder :
//- (IBAction)modifyPwdButtonTouch:(UIButton *)sender
//{
//    
//}


@end
