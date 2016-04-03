//
//  ProfileChangePwdTableViewController.m
//  Louis
//
//  Created by Giang Christian on 30/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfileChangePwdTableViewController.h"
#import "Common.h"
#import "ProfileChangePwdTableViewController.h"
#import "ResearchPopupView.h"
#import "ProfileChangePwdTableViewCell.h"
#import "KeychainWrapper.h"
#import "ProfileTableViewController.h"
#import "DataManager+User.h"


typedef NS_ENUM(NSInteger, TypedefEnumLoginCellType) {
    TypedefEnumProfileChangePwdCellTypeCurrentPwd,
    TypedefEnumProfileChangePwdCellTypeNewPwd,
    TypedefEnumProfileChangePwdCellTypeNewPwdConfirm
};

static BOOL currentPwdTextFieldIsFilled = NO;
static BOOL nouveauPwdTextFieldIsFilled = NO;
static BOOL nouveauPwdConfirmTextFieldIsFilled = NO;

static BOOL allNouveauPwdTextFieldCanBeEraseInOneTouch = NO;
static BOOL allNouveauPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
static BOOL allCurrentPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
static BOOL isResetPassword = NO;


@interface ProfileChangePwdTableViewController ()


// le tableau des erreurs
@property (nonatomic, strong) NSMutableArray *errorsTable;

@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;

@property (nonatomic, strong) UITextField *currentPwdTextField;
@property (nonatomic, strong) UITextField *nouveauPwdTextField;
@property (nonatomic, strong) UITextField *nouveauPwdConfirmTextField;
@property (nonatomic, strong) UILabel *currentPwdLabel;
@property (nonatomic, strong) UILabel *nouveauPwdLabel;
@property (nonatomic, strong) UILabel *nouveauPwdConfirmLabel;


@property BigButtonView *footerView;

/** Origine controller */
@property (nonatomic, strong) UIViewController *origineController;

@end


@implementation ProfileChangePwdTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // si on vient de ProfileSetupTVC, alors c'est une modif de password classique sinon c'est un reset password
    self.origineController = [self backViewController];
    if ([self.origineController isKindOfClass:[ProfileTableViewController class]])
    {
        NSLog(@"ProfileTableViewController");
    }
    else  //reset password
    {
        isResetPassword = YES;
        NSLog(@"Reset password");
    }


    [self setTitle:NSLocalizedString(@"Profile-ChangePwd-Title", nil)];
    [self.tableView setBackgroundColor:[UIColor louisBackgroundApp]];
    
    _errorsTable = [[NSMutableArray alloc]init];
    
    [self configureCells];
    
    // Le clavier disparait quand on clique sur l'écran
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // attention, la propriété ci-dessous doit absolument être positionné à "NO" sinon on ne passera jamais par le didSelectRowAtIndexPath
    tap.cancelsTouchesInView = NO;
    
    // Ajout Bar bouton Annuler à droite
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc]
                                        initWithTitle:NSLocalizedString(@"CancelButtonItem-Title", nil)
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(barButtonCancelTouch)];
    
    self.navigationItem.rightBarButtonItem = barButtonCancel;
    
}


// Détermine l'origine de l'appel.
- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}



-(IBAction)barButtonCancelTouch
{
    if (isResetPassword == YES)
    {
        [self disconnectFromApp];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}


-(void) disconnectFromApp
{
    //Initialisation d'un actionSheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Profile-Disconnect-Confirm-Title", nil)
                                                                         message:NSLocalizedString(@"Profile-Disconnect-Confirm-Msg", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"UIAlertAction-Button-YES", nil)
                                                        style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
                                {
                                    
                                    DataManager *dataManager = [DataManager sharedInstance];
                                    dataManager.user = nil;
                                    isResetPassword = NO;
                                    
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
//        [GAI sendScreenViewWithName:@"Logout"];
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



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_currentPwdTextField becomeFirstResponder];
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //suppression bouton back
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
    
    [GAI sendScreenViewWithName:@"Edit Password"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enlever le clavier
    [[self view] endEditing:YES];
    
//    // Change "back" bar button name for the next viewcontroller
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackButtonItem-Title",nil)
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:nil
//                                                                     action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
}



- (void)configureCells
{
    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
    
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileChangePwdCellTypeCurrentPwd)];
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileChangePwdCellTypeNewPwd)];
    [_cellTypesGroupedBySection addObject:@(TypedefEnumProfileChangePwdCellTypeNewPwdConfirm)];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    //Ajouter le bouton dans le footerview
    _footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"Profile-ChangePwd-Record", nil)];
    
    [[_footerView button] addTarget:self action:@selector(signUpButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [[_footerView button] setEnabled:NO];
    [[self tableView] setTableFooterView:_footerView];
}




//===============================================
#pragma mark - Table view data source
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTypesGroupedBySection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileChangePwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.profileChangePwdLabel setTextColor:[UIColor louisLabelColor]];
    [cell.profileChangePwdLabel setFont:[UIFont louisLabelFont]];
    
    [cell.profileChangePwdTextField setTextColor:[UIColor louisTitleAndTextColor]];
    [cell.profileChangePwdTextField setFont:[UIFont louisLabelFont]];
    [cell.profileChangePwdTextField setKeyboardType:UIKeyboardTypeDefault];
    [cell.profileChangePwdTextField setSecureTextEntry:YES];
    [cell.profileChangePwdTextField setReturnKeyType:UIReturnKeyNext];

    cell.profileChangePwdTextField.tag = indexPath.row ;
    cell.profileChangePwdTextField.delegate = self;
    
    if (indexPath.row == 0)
    {
        // Affecter le pointer _currentPwdLabel au label de l'currentPwd pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.profileChangePwdLabel.text = NSLocalizedString(@"Profile-ChangePwd-CurrentPwd-Label",nil);
        if (!_currentPwdLabel)
        {
            _currentPwdLabel = cell.profileChangePwdLabel;
        }
        
        // Affecter le pointer _currentPwdTextField au textField de l'currentPwd pour changer ses propriétés
        if (!_currentPwdTextField)
        {
            _currentPwdTextField = cell.profileChangePwdTextField;
            _currentPwdTextField.placeholder = NSLocalizedString(@"Profile-ChangePwd-CurrentPwd-PlaceHolder",nil);
            _currentPwdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; //minuscule
        }
        
        if (isResetPassword == YES)
        {
            [cell setHidden:YES];
        }

    }
    else if (indexPath.row == 1)
    {
        // Affecter le pointer _nouveauPwdLabel au label password pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.profileChangePwdLabel.text = NSLocalizedString(@"Profile-ChangePwd-NewPwd-Label",nil);
        if (!_nouveauPwdLabel)
        {
            _nouveauPwdLabel = cell.profileChangePwdLabel;
        }
        
        // Affecter le pointer _nouveauPwdTextField au textField password pour changer ses propriétés
        if (!_nouveauPwdTextField)
        {
            _nouveauPwdTextField = cell.profileChangePwdTextField;
            _nouveauPwdTextField.placeholder = NSLocalizedString(@"Profile-ChangePwd-NewPwd-PlaceHolder",nil);
        }
    }
    else if (indexPath.row == 2)
    {
        cell.profileChangePwdLabel.text = NSLocalizedString(@"Profile-ChangePwd-NewPwdConfirm-Label",nil);
        if (!_nouveauPwdConfirmLabel)
        {
            _nouveauPwdConfirmLabel = cell.profileChangePwdLabel ;
        }
        
        if (!_nouveauPwdConfirmTextField)
        {
            _nouveauPwdConfirmTextField = cell.profileChangePwdTextField;
            _nouveauPwdConfirmTextField.returnKeyType = UIReturnKeyGo;
            _nouveauPwdConfirmTextField.placeholder = NSLocalizedString(@"Profile-ChangePwd-NewPwdConfirm-PlaceHolder",nil);
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileChangePwdTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    [[cellSelected profileChangePwdTextField] becomeFirstResponder];
}



//===============================================
#pragma mark Validation des TextFields
//===============================================


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //cas particulier utilisé dans la methode shouldChangeCharactersInRange
    if (textField.tag == 0 && textField.text.length > 0)
    {
        allCurrentPwdConfirmTextFieldCanBeEraseInOneTouch = YES;
    }
    if (textField.tag == 1 && textField.text.length > 0)
    {
        allNouveauPwdTextFieldCanBeEraseInOneTouch = YES;
    }
    if (textField.tag == 2 && textField.text.length > 0)
    {
        allNouveauPwdConfirmTextFieldCanBeEraseInOneTouch = YES;
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    testString = [testString stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // vérifie si toutes les conditions sont remplis pour activer ou désactiver le bouton Sign Up
    // Le bouton est activé quand les 3 champs sont remplis (minimum 1 caractère par champs)
    
    //    NSLog(@"%@",[NSString stringWithFormat:@"toto%@titi", string]);
    
    if (testString.length)
    {
        //Cas particulier. La methode shouldChangeCharactersInRange traite caractère par caractère
        //Or quand on appuie sur la touche "<--", tout le mot de passe (en entier) peut etre supprimé (et pas uniquement un seul caractère). Par conséquent, le champs textField passé en paramètre à la méthode n'est pas vide (il contient uniquement un caractère en moins) alors que tout le mot de passe a été supprimé
        
        if ((textField.tag == 0) && [string isEqualToString:@""] && (allCurrentPwdConfirmTextFieldCanBeEraseInOneTouch == YES))
        {
            allCurrentPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
            currentPwdTextFieldIsFilled = NO;
            [[_footerView button] setEnabled:NO];
        }
        else if ((textField.tag == 1) && [string isEqualToString:@""] && (allNouveauPwdTextFieldCanBeEraseInOneTouch == YES))
        {
            allNouveauPwdTextFieldCanBeEraseInOneTouch = NO;
            nouveauPwdTextFieldIsFilled = NO;
            [[_footerView button] setEnabled:NO];
        }
        else if ((textField.tag == 2) && [string isEqualToString:@""] && (allNouveauPwdConfirmTextFieldCanBeEraseInOneTouch == YES))
        {
            allNouveauPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
            nouveauPwdConfirmTextFieldIsFilled = NO;
            [[_footerView button] setEnabled:NO];
        }
        else
        {
            switch (textField.tag)
            {
                case 0:
                    currentPwdTextFieldIsFilled = YES;
                    break;
                case 1:
                    nouveauPwdTextFieldIsFilled = YES;
                    break;
                case 2:
                    nouveauPwdConfirmTextFieldIsFilled = YES;
                    break;
                default:
                    break;
            }
            
            // si on fait une demande de resestPassword, il ne faut pas controller ce champs
            if (isResetPassword == YES )
            {
                currentPwdTextFieldIsFilled = YES;
            }
            
            if (currentPwdTextFieldIsFilled == YES && nouveauPwdTextFieldIsFilled == YES && nouveauPwdConfirmTextFieldIsFilled == YES)
            {
                [[_footerView button] setEnabled:YES];
            }
        }
    }
    else
    {
        switch (textField.tag)
        {
            case 0:
                currentPwdTextFieldIsFilled = NO;
                allCurrentPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
                break;
            case 1:
                nouveauPwdTextFieldIsFilled = NO;
                allNouveauPwdTextFieldCanBeEraseInOneTouch = NO;
                break;
            case 2:
                nouveauPwdConfirmTextFieldIsFilled = NO;
                allNouveauPwdConfirmTextFieldCanBeEraseInOneTouch = NO;
                break;
            default:
                break;
        }
        [[_footerView button] setEnabled:NO];
    }
    
    return YES;
    
}


// Gestion de la touche "return"
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.currentPwdTextField) {
        [self.nouveauPwdTextField becomeFirstResponder];
    }
    else if (textField == self.nouveauPwdTextField)
    {
        [self.nouveauPwdConfirmTextField becomeFirstResponder];
    }
    else if (textField == self.nouveauPwdConfirmTextField)
    {
        [textField resignFirstResponder];
        [self signUpButtonTouch];
    }
    
    return YES;
}


//===============================================
#pragma mark Vérifier les erreurs de formatage
//===============================================

-(IBAction)signUpButtonTouch
{
    [[_footerView button] setEnabled:NO];
    //    [[self navigationController] setUserInteractionEnabled:NO];
    
    
    //Vérifie les formats des currentPwd, passwords
    // si on fait une demande de resestPassword, il ne faut pas controller ce champs
    if (isResetPassword == NO )
    {
        [self checkCurrentPwdIsCorrect] ;
    }

    [self checkPasswordFormatMinDigit];
    [self checkPasswordConfirmFormat] ;
    
    // calculer le nombre d'erreur
    // _errorsTable est incrémenté à chaque erreur dans les 3 méthodes de vérification ci dessus
    NSUInteger nbError = [_errorsTable count];
    if (nbError == 0)
    {
        // Pas d'erreur de format, appel WS modif passeword
        
        // CGIA WARNING
        // CGIA WARNING le WS de modification de mot de passe n'est pas encore implémenté pour l'instance
        // CGIA WARNING
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"RAF" message:@"Le Webservice de mot de passe n'est pas encore implémenté" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];

        
    }
    else
    {
        // afficher les messages d'erreur
        [self showErreursMessages];
        
    }
    [[_footerView button] setEnabled:YES];
    
    // Réinitialise table des erreurs
    [_errorsTable removeAllObjects];
    
    //    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
}


// afficher les messages d'erreur
-(void)showErreursMessages
{
    // calculer le nombre d'erreur
    NSUInteger nbError = [_errorsTable count];
    
    // S'il y a au moins une erreur
    if (nbError >= 1)
    {
        TypedefEnumLoginCellType cellType = [[_errorsTable objectAtIndex:0] integerValue];
        
        if (nbError == 1) // une seule erreur
        {
            switch (cellType)
            {
                case TypedefEnumProfileChangePwdCellTypeCurrentPwd:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:NSLocalizedString(@"Profile-ChangePwd-CurrentPwd", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil) otherButtonTitles:nil];
                    [alert show];
                    [_currentPwdTextField becomeFirstResponder];
                    break;
                }
                    
                case TypedefEnumProfileChangePwdCellTypeNewPwd:
                {
                    //UIAlertView avec message pour password
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:NSLocalizedString(@"Profile-ChangePwd-Pwd-MinSize", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                    [_nouveauPwdTextField becomeFirstResponder];
                    break;
                }
                    
                case TypedefEnumProfileChangePwdCellTypeNewPwdConfirm:
                {
                    //UIAlertView avec message pour password confirm
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:NSLocalizedString(@"Profile-ChangePwd-NewPwd-Confirm", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                    [_nouveauPwdConfirmTextField becomeFirstResponder];
                    break;
                }
                    
                default:
                    break;
            }
            
        }
        else
        {
            // Il y a plusieurs erreurs de format
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"SignUpProfile-Check-Multiple-Error", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            
            // On place le curseur sur la 1ere erreur (index 0)
            switch (cellType) {
                case TypedefEnumProfileChangePwdCellTypeCurrentPwd:
                    [_currentPwdTextField becomeFirstResponder];
                    break;
                case TypedefEnumProfileChangePwdCellTypeNewPwd:
                    [_nouveauPwdTextField becomeFirstResponder];
                    break;
                case TypedefEnumProfileChangePwdCellTypeNewPwdConfirm:
                    [_nouveauPwdConfirmTextField becomeFirstResponder];
                    break;
                default:
                    break;
            }
            
        }
    }
    
}



// vérifie si le mot de passe est correct
-(void)checkCurrentPwdIsCorrect
{
    KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
    NSString *password = [MyKeychainWrapper myObjectForKey:(__bridge id)kSecValueData];

    _currentPwdLabel.textColor = [UIColor louisLabelColor];
    // Le mot de passe saisie doit être identique au mot de passe actuel
    if (![_currentPwdTextField.text isEqualToString:password] )
    {
        _currentPwdLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@(TypedefEnumProfileChangePwdCellTypeCurrentPwd)];
        
    }
}


// Vérifie si le mot de passe contient au moins 6 caractères
-(void)checkPasswordFormatMinDigit
{
    _nouveauPwdLabel.textColor = [UIColor louisLabelColor];
    //Le mot de passe doit faire au moins 6 caractères min
    if (_nouveauPwdTextField.text.length < 6 )
    {
        _nouveauPwdLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@(TypedefEnumProfileChangePwdCellTypeNewPwd)];
        
    }
    
}


// Vérifie si les 2 mots de passe sont identiques
-(void)checkPasswordConfirmFormat
{
    _nouveauPwdConfirmLabel.textColor = [UIColor louisLabelColor];
    if (![_nouveauPwdTextField.text isEqualToString:self.nouveauPwdConfirmTextField.text])
    {
        _nouveauPwdConfirmLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@(TypedefEnumProfileChangePwdCellTypeNewPwdConfirm)];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
