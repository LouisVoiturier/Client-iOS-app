//
//  SignUpTableViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "Common.h"
#import "SignUpTableViewCell.h"
#import "SignUpProfileTableViewController.h"
#import "DataManager+User.h"
#import "ResearchPopupView.h"

typedef NS_ENUM(NSInteger, TypedefEnumLoginCellType) {
    TypedefEnumLoginCellTypeEmail,
    TypedefEnumLoginCellTypePassword,
    TypedefEnumLoginCellTypePasswordConfirm
};

static BOOL emailTextFieldIsFilled = NO;
static BOOL passwordTextFieldIsFilled = NO;
static BOOL passwordConfirmTextFieldIsFilled = NO;

static BOOL allPasswordTextFieldCanBeEraseInOneTouch = NO;
static BOOL allPasswordConfirmTextFieldCanBeEraseInOneTouch = NO;


@interface SignUpTableViewController ()

// le tableau des erreurs
@property (nonatomic, strong) NSMutableArray *errorsTable;
@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordConfirmTextField;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UILabel *passwordConfirmLabel;
@property BigButtonView *footerView;

@end


@implementation SignUpTableViewController

//Bouton à enlever
//bouton de raccouri pour faire les tests de développement
- (IBAction)boutonDeRaccourciPourTest:(UIBarButtonItem *)sender
{
    [self gotoSignUpProfileTableViewController];
}


-(void) gotoSignUpProfileTableViewController
{
    SignUpProfileTableViewController *signUpProfileTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpProfileTVC"];
    
    [[self navigationController] pushViewController:signUpProfileTVC animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Sign-Up-Title", nil)];
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


-(IBAction)barButtonCancelTouch
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_emailTextField becomeFirstResponder];
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
    
    [GAI sendScreenViewWithName:@"Subscription Step 1"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enlever le clavier
    [[self view] endEditing:YES];
    
    // Change "back" bar button name for the next viewcontroller
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackButtonItem-Title",nil)
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}


- (void)configureCells
{
    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc]init];
    [firstSection addObject:@(TypedefEnumLoginCellTypeEmail)];
    [firstSection addObject:@(TypedefEnumLoginCellTypePassword)];
    [firstSection addObject:@(TypedefEnumLoginCellTypePasswordConfirm)];
    
    [self.cellTypesGroupedBySection addObject:firstSection];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
    
    //Ajouter le bouton dans le footerview
    _footerView = [BigButtonView bigButtonViewTypeMainWithTitle:NSLocalizedString(@"SignUp-Button-Record", nil)];
    
    [[_footerView button] addTarget:self action:@selector(signUpButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [[_footerView button] setEnabled:NO];
    [[self tableView] setTableFooterView:_footerView];
}




//===============================================
#pragma mark - Table view data source
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.cellTypesGroupedBySection count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *rows = [self.cellTypesGroupedBySection objectAtIndex:section];
    return [rows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.signUpLabel setTextColor:[UIColor louisLabelColor]];
    [cell.signUpLabel setFont:[UIFont louisLabelFont]];
    
    [cell.signUpTextField setTextColor:[UIColor louisTitleAndTextColor]];
    [cell.signUpTextField setFont:[UIFont louisLabelFont]];
    cell.signUpTextField.tag = indexPath.row ;
    cell.signUpTextField.delegate = self;
    
    if (indexPath.row == 0)
    {
        // Affecter le pointer _emailLabel au label de l'email pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.signUpLabel.text = NSLocalizedString(@"Sign-Email-Label",nil);
        if (!_emailLabel)
        {
            _emailLabel = cell.signUpLabel;
        }
        
        // Affecter le pointer _emailTextField au textField de l'email pour changer ses propriétés
        if (!_emailTextField)
        {
            _emailTextField = cell.signUpTextField;
            _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
            _emailTextField.returnKeyType = UIReturnKeyNext;
            _emailTextField.placeholder = NSLocalizedString(@"Sign-Email-TextField",nil);
            _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; //minuscule
        }
    }
    else if (indexPath.row == 1)
    {
        // Affecter le pointer _passwordLabel au label password pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.signUpLabel.text = NSLocalizedString(@"Sign-Pwd-Label",nil);
        if (!_passwordLabel)
        {
            _passwordLabel = cell.signUpLabel;
        }
        
        // Affecter le pointer _passwordTextField au textField password pour changer ses propriétés
        if (!_passwordTextField)
        {
            _passwordTextField = cell.signUpTextField;
            _passwordTextField.keyboardType = UIKeyboardTypeDefault;
            _passwordTextField.returnKeyType = UIReturnKeyNext;
            _passwordTextField.secureTextEntry = YES;
            _passwordTextField.placeholder = NSLocalizedString(@"Sign-Pwd-TextField",nil);
        }
    }
    else if (indexPath.row == 2)
    {
        cell.signUpLabel.text = NSLocalizedString(@"Sign-PwdConfirm-Label",nil);
        if (!_passwordConfirmLabel)
        {
            _passwordConfirmLabel = cell.signUpLabel ;
        }
        
        if (!_passwordConfirmTextField)
        {
            _passwordConfirmTextField = cell.signUpTextField;
            _passwordConfirmTextField.keyboardType = UIKeyboardTypeDefault;
            _passwordConfirmTextField.returnKeyType = UIReturnKeyGo;
            _passwordConfirmTextField.secureTextEntry = YES;
            _passwordConfirmTextField.placeholder = NSLocalizedString(@"Sign-PwdConfirm-TextField",nil);
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignUpTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    [[cellSelected signUpTextField] becomeFirstResponder];
}




//===============================================
#pragma mark Validation des TextFields
//===============================================


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //cas particulier utilisé dans la methode shouldChangeCharactersInRange
    if (textField.tag == 1 && textField.text.length > 0)
    {
        allPasswordTextFieldCanBeEraseInOneTouch = YES;
    }
    if (textField.tag == 2 && textField.text.length > 0)
    {
        allPasswordConfirmTextFieldCanBeEraseInOneTouch = YES;
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
        if ((textField.tag == 1) && [string isEqualToString:@""] && (allPasswordTextFieldCanBeEraseInOneTouch == YES))
        {
            allPasswordTextFieldCanBeEraseInOneTouch = NO;
            passwordTextFieldIsFilled = NO;
            [[_footerView button] setEnabled:NO];
        }
        else if ((textField.tag == 2) && [string isEqualToString:@""] && (allPasswordConfirmTextFieldCanBeEraseInOneTouch == YES))
        {
            allPasswordConfirmTextFieldCanBeEraseInOneTouch = NO;
            passwordConfirmTextFieldIsFilled = NO;
            [[_footerView button] setEnabled:NO];
        }
        else
        {
            switch (textField.tag)
            {
                case 0:
                    emailTextFieldIsFilled = YES;
                    break;
                case 1:
                    passwordTextFieldIsFilled = YES;
                    break;
                case 2:
                    passwordConfirmTextFieldIsFilled = YES;
                    break;
                default:
                    break;
            }

            
            if (emailTextFieldIsFilled == YES && passwordTextFieldIsFilled == YES && passwordConfirmTextFieldIsFilled == YES)
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
                emailTextFieldIsFilled = NO;
                break;
            case 1:
                passwordTextFieldIsFilled = NO;
                allPasswordTextFieldCanBeEraseInOneTouch = NO;
                break;
            case 2:
                passwordConfirmTextFieldIsFilled = NO;
                allPasswordConfirmTextFieldCanBeEraseInOneTouch = NO;
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
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self.passwordConfirmTextField becomeFirstResponder];
    }
    else if (textField == self.passwordConfirmTextField)
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
    
    //Vérifie les formats des email, passwords
    [self checkEmailFormat] ;
    [self checkPasswordFormatMinDigit];
    [self checkPasswordConfirmFormat] ;
    
    // calculer le nombre d'erreur
    // _errorsTable est incrémenté à chaque erreur dans les 3 méthodes de vérification ci dessus
    NSUInteger nbError = [_errorsTable count];
    if (nbError == 0)
    {
        // Pas d'erreur de format, accès à la fenetre suivante
         SignUpProfileTableViewController *signUpProfileTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpProfileTVC"];
         
         // passage de email et password au SignUpProfileTableViewController
         signUpProfileTVC.email = _emailTextField.text;
         signUpProfileTVC.password = _passwordTextField.text;
        
         [[self navigationController] pushViewController:signUpProfileTVC animated:YES];
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
                case TypedefEnumLoginCellTypeEmail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check-Email", nil)
                                                                    message:NSLocalizedString(@"SignUp-Check-Email-Format", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil) otherButtonTitles:nil];
                    [alert show];
                    [_emailTextField becomeFirstResponder];
                    break;
                }
                case TypedefEnumLoginCellTypePassword:
                {
                    //UIAlertView avec message pour password
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check-Pwd", nil)
                                                                    message:NSLocalizedString(@"SignUp-Check-Pwd-MinSize", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                    [_passwordTextField becomeFirstResponder];
                    break;
                }
                    
                case TypedefEnumLoginCellTypePasswordConfirm:
                {
                    //UIAlertView avec message pour password confirm
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check-Pwd", nil)
                                                                    message:NSLocalizedString(@"SignUp-Check-Pwd-ReEntry", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                    [_passwordConfirmTextField becomeFirstResponder];
                    break;
                }
                    
                default: break;
            }
        }
        else
        {
            // Il y a plusieurs erreurs de format
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check", nil)
                                                            message:NSLocalizedString(@"SignUp-Check-Multiple-Error", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            
            // On place le curseur sur la 1ere erreur (index 0)
            switch (cellType) {
                case TypedefEnumLoginCellTypeEmail:
                    [_emailTextField becomeFirstResponder];
                    break;
                case TypedefEnumLoginCellTypePassword:
                    [_passwordTextField becomeFirstResponder];
                    break;
                case TypedefEnumLoginCellTypePasswordConfirm:
                    [_passwordConfirmTextField becomeFirstResponder];
                    break;
                default:
                    break;
            }
        }
    }
}


// vérifie si le format de l'adresse mail est correct
-(void)checkEmailFormat
{
    NSString *emailString = self.emailTextField.text;
    
    // Expression régulière pour vérifier le format de l'email  "abc@example.com" ou "abc@example.com.fr".
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    _emailLabel.textColor = [UIColor louisLabelColor];
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        _emailLabel.textColor = [UIColor redColor];
        // Ajoute l'erreur dans le tableau des erreurs
        [_errorsTable addObject:@(TypedefEnumLoginCellTypeEmail)];
    }
}


// Vérifie si le mot de passe contient au moins 6 caractères
-(void)checkPasswordFormatMinDigit
{
    _passwordLabel.textColor = [UIColor louisLabelColor];
    //Le mot de passe doit faire au moins 6 caractères min
    if (_passwordTextField.text.length < 6 )
    {
        _passwordLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@(TypedefEnumLoginCellTypePassword)];
    }
}


// Vérifie si les 2 mots de passe sont identiques
-(void)checkPasswordConfirmFormat
{
    _passwordConfirmLabel.textColor = [UIColor louisLabelColor];
    if (![_passwordTextField.text isEqualToString:self.passwordConfirmTextField.text])
    {
        _passwordConfirmLabel.textColor = [UIColor redColor];
        [_errorsTable addObject:@(TypedefEnumLoginCellTypePasswordConfirm)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
