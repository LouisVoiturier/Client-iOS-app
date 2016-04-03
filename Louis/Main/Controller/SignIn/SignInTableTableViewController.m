//
//  SignInTableTableViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//



#import "SignInTableTableViewController.h"
#import "HomeViewController.h"
#import "Common.h"
#import "SigneInTableViewCell.h"
#import "BigButtonView.h"
#import "DataManager+User.h"
#import "KeychainWrapper.h"
#import "GeolocForbiddenViewController.h"
#import "ResearchPopupView.h"
#import "ImageManager.h"


typedef NS_ENUM(NSInteger, PTLoginCellType) {
    PTLoginCellTypeEmail,
    PTLoginCellTypePassword,
};

static BOOL emailTextFieldIsFilled = NO;
static BOOL passwordTextFieldIsFilled = NO;
static BOOL allPasswordTextFieldCanBeEraseInOneTouch = NO;

@interface SignInTableTableViewController ()
// variables privées
@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *passwordLabel;

@property UIView *footerView;
@property (nonatomic, strong) BigButton *signInButton;
@property (nonatomic, strong) UIButton *forgottenPasswordButton;
@property (nonatomic, strong) UIBarButtonItem *nouvelBackButton;
@property (nonatomic, strong) ResearchPopupView *RPV;

@end

@implementation SignInTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Sign-In-Title", nil)];
    [self.tableView setBackgroundColor:[UIColor louisBackgroundApp]];
    
    // Change "back" bar button name
    _nouvelBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackButtonItem-Title",nil)
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:_nouvelBackButton];
    
        // Ajout Bar bouton Annuler à droite
        UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc]
                                               initWithTitle:NSLocalizedString(@"CancelButtonItem-Title", nil)
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(barButtonCancelTouch)];
    
        self.navigationItem.rightBarButtonItem = barButtonCancel;
    
    //Ajouter les boutons "mot de passe oublié" et "se connecter"  dans le footerview
    _footerView = [[UIView alloc]init];
    [self addTwoButtonInFooterView:_footerView];
    
    [[self tableView] setTableFooterView:_footerView];
    
    _cellTypesGroupedBySection = [[NSMutableArray alloc]init];
    [self configureCells];
    
    // dismiss keyboard on tap gesture
    // Le clavier disparait quand on clique sur l'écran
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // attention, la propriété ci-dessous doit absolument être positionné à "NO" sinon on ne passera jamais par le didSelectRowAtIndexPath
    tap.cancelsTouchesInView = NO;
//        [self.navigationItem.backBarButtonItem setEnabled:NO];
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


-(void)viewWillAppear:(BOOL)animated
{
    [GAI sendScreenViewWithName:@"Login"];
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    //suppression bouton back
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


- (void)configureCells {
    
    NSMutableArray *firstSection = [[NSMutableArray alloc]init];
    [firstSection addObject:@(PTLoginCellTypeEmail)];
    [firstSection addObject:@(PTLoginCellTypePassword)];
    
    [self.cellTypesGroupedBySection addObject:firstSection];
    
    [[self tableView] setBackgroundColor:[UIColor louisBackgroundApp]];
}


-(void)addTwoButtonInFooterView:(UIView *)myView
{
    // ----- Forgotten Password Button ----- //
    _forgottenPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    // Souligner le text du bouton.
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SignIn-ForgottenPwd-Button",nil)];
    
    [titleString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[titleString length])];
    
    [_forgottenPasswordButton setAttributedTitle: titleString forState:UIControlStateNormal];
    
    [[_forgottenPasswordButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
    [_forgottenPasswordButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    _forgottenPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgottenPasswordButton addTarget:self action:@selector(forgottenPasswordButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [myView addSubview:_forgottenPasswordButton];
    
    
    // ----- SignIn Button ----- //
    _signInButton = [BigButton bigButtonTypeMainWithTitle:NSLocalizedString(@"SignIn-Button-Title", nil)];
    [_signInButton addTarget:self action:@selector(loginButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_signInButton setEnabled:NO];
    [myView addSubview:_signInButton];
    

    // ----- Constraints ----- //
    NSNumber *footerWidth = [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];
    NSNumber *buttonWidth = [NSNumber numberWithFloat:[footerWidth floatValue]*0.84];
    NSNumber *buttonHeight = @45;
    NSNumber *frameHeight = @85;

    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_signInButton,_forgottenPasswordButton);
    NSDictionary *metricsDict = NSDictionaryOfVariableBindings(buttonWidth, buttonHeight);

    //  [self setFrame:CGRectMake(0, 0, [footerWidth floatValue], ([buttonHeight intValue]))];
    [myView setFrame:CGRectMake(0, 0, [footerWidth floatValue], ([frameHeight intValue]))];

    // Placement vertical du bouton _forgottenPasswordButton
    [myView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_forgottenPasswordButton(==20)]"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];

    // Placement vertical : bouton _forgottenPasswordButton au dessus de _signInButton
    [myView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_forgottenPasswordButton]-15-[_signInButton(==buttonHeight)]"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];

    // Placement Horizontal _signInButton
    [myView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_signInButton(==buttonWidth)]"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];
    
    // Placement Horizontal _forgottenPasswordButton
    [myView addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_forgottenPasswordButton(==140)]-10-|"
                                                                  options:0
                                                                  metrics:metricsDict
                                                                    views:viewsDict]];
    
    // centrer le _signInButton sur la view myView
    [myView addConstraint:[NSLayoutConstraint constraintWithItem:_signInButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:myView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
}



-(IBAction)forgottenPasswordButtonTouch
{
    NSLog(@"forgottenPasswordButtonTouch");
    [GAI sendScreenViewWithName:@"Password Forgotten"];
}


// Enregistre l'email et le mot de passe dans keychain pour l'auto login
-(void) saveEmailPwdIntoKeyChain:(NSString *)email andPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLoginKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    KeychainWrapper *MyKeychainWrapper =[[KeychainWrapper alloc]init];
    
    [MyKeychainWrapper mySetObject:email    forKey:(__bridge id)kSecAttrAccount];
    [MyKeychainWrapper mySetObject:password forKey:(__bridge id)kSecValueData];
    [MyKeychainWrapper writeToKeychain];
}


-(void) startActivityIndicator
{
    _RPV = [[ResearchPopupView alloc] init];
    [_RPV changeToSearchingStateWithMessage:@"Connexion en cours"];
}


-(void) stopActivityIndicator
{
    [_RPV dismiss];
}


-(void) goToGeolocForbiddenViewController
{
    NSLog(@"sign in geolocforbidden");
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GeolocForbiddenViewController *geolocForbiddenVC  = [sb instantiateViewControllerWithIdentifier:@"GeolocForbiddenVC"];
    
    [self.navigationController pushViewController:geolocForbiddenVC animated:YES];
}


-(void) goToHomeViewController
{
    NSLog(@"sign in gotoHome");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    HomeViewController* homeController = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self.navigationController pushViewController:homeController animated:YES];
}


-(IBAction)loginButtonTouch
{
    [self startActivityIndicator];
    
    //Vérifie si les formats des email, password
    if (([self validEmailFormat] == true) && ([self validPasswordFormatMinDigit] == true))
    {
       [DataManager signInWithUsername:[self.emailTextField.text lowercaseString]
                            andPassword:self.passwordTextField.text
                             completion:^(User *user, NSHTTPURLResponse *httpResponse, NSError *error)
             {
                 if (httpResponse.statusCode != 200)
                 {
                     [self stopActivityIndicator];
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
                     // ---------------------------------------------
                     // CGIA_WARNING
                     // tests temporaire en attendant que le WS nous renvoie des vrais codes error
                     // ---------------------------------------------
                     NSLog(@"user.email : %@",user.email);
                     // si le username n'est pas null
                     if (user.email)
                     {
                         [self saveEmailPwdIntoKeyChain:self.emailTextField.text andPassword:self.passwordTextField.text];
                         
                         [DataManager user].password = self.passwordTextField.text;
                         
                         NSLog(@"LOGIN SUCCES : %@", user.description);
                         
                         // Ajout QuickAction
                         if (iOSVersionGreaterThan(@"9")) {
                             UIApplicationShortcutItem *quickAction = [[UIApplicationShortcutItem alloc] initWithType:@"com.louis.louis.request-valet" localizedTitle:NSLocalizedString(@"UIApplicationShortcutItemTitle-RequestValet", nil) localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMarkLocation] userInfo:nil];
                             [[UIApplication sharedApplication] setShortcutItems:@[quickAction]];
                         }
                         if ([DataManager user].picture)
                         {
                             [ImageManager getImageFromUrlPath:[DataManager user].picture withCompletion:^(UIImage *image)
                              {
                                  [DataManager user].pictureImage = image;
                                  NSLog(@"[DataManager user].pictureImage : %@",[DataManager user].pictureImage );
                              }];
                         }

                         dispatch_async(dispatch_get_main_queue(),^
                                        {
                                            [self stopActivityIndicator];
                                            switch ([CLLocationManager authorizationStatus])
                                            {
                                                case kCLAuthorizationStatusNotDetermined:
                                                case kCLAuthorizationStatusDenied:
                                                case kCLAuthorizationStatusRestricted:
                                                {
                                                    [self goToGeolocForbiddenViewController];
                                                    break;
                                                }
                                                    
                                                case kCLAuthorizationStatusAuthorizedWhenInUse:
                                                case kCLAuthorizationStatusAuthorizedAlways:
                                                {
                                                    [self goToHomeViewController];
                                                    break;
                                                }
                                            }
                                        });
                     }
                     else
                     {
                         NSLog(@"error returned : %@", error);
                         NSLog(@"LOGIN FAILED user.email : %@", user.email);
                         
                         [self stopActivityIndicator];
                     }
                 }
             }]; // fin instruction du [DataManager ....
    }
    else
    {
        [self stopActivityIndicator];
    }
}


// vérifie si le format de l'adresse mail est correct
-(BOOL)validEmailFormat
{
    NSString *emailString = self.emailTextField.text;
    
    // Expression régulière pour vérifier le format de l'email  "abc@example.com" ou "abc@example.com.fr".
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    _emailLabel.textColor = [UIColor blackColor];
    if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
    {
        _emailLabel.textColor = [UIColor redColor];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check-Email", nil)
                                                        message:NSLocalizedString(@"SignUp-Check-Email-Format", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [_emailTextField becomeFirstResponder];
        return false;
    }
    
    return true;
}



// Vérifie si le mot de passe contient au moins 6 caractères
-(BOOL)validPasswordFormatMinDigit
{
    _passwordLabel.textColor = [UIColor blackColor];
    //Le mot de passe doit faire au moins 6 caractères min
    if (self.passwordTextField.text.length < 6 )
    {
        _passwordLabel.textColor = [UIColor redColor];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUp-Check-Pwd", nil)
                                                        message:NSLocalizedString(@"SignUp-Check-Pwd-MinSize", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"UIAlertAction-Button-OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [_passwordTextField becomeFirstResponder];
        return false;
    }
    
    return true;
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    // Mettre le curseur sur le 1er textfield
//    SigneInTableViewCell *signInFirstCell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [[signInFirstCell signInTextField] becomeFirstResponder];
//}


//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // on voit encore la vue
//    [[self view] endEditing:YES];
//}



//===============================================
#pragma mark - Table view data source
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.cellTypesGroupedBySection count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *rows = [self.cellTypesGroupedBySection objectAtIndex:section];
    return [rows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SigneInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.signInLabel setTextColor:[UIColor louisLabelColor]];
    [cell.signInLabel setFont:[UIFont louisLabelFont]];
    
    [cell.signInTextField setTextColor:[UIColor louisTitleAndTextColor]];
    [cell.signInTextField setFont:[UIFont louisLabelFont]];
    
    if (indexPath.row == 0)
    {
        // Affecter le pointer _emailLabel au label de l'email pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.signInLabel.text = NSLocalizedString(@"Sign-Email-Label",nil);
        if (!_emailLabel)
        {
            _emailLabel = cell.signInLabel;
        }
        
        // Affecter le pointer _emailTextField au textField de l'email pour changer ses propriétés
        if (!_emailTextField)
        {
            _emailTextField = cell.signInTextField;
            _emailTextField.tag = indexPath.row ;
            _emailTextField.delegate = self;
            _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
            _emailTextField.returnKeyType = UIReturnKeyNext;
            _emailTextField.placeholder = NSLocalizedString(@"Sign-Email-TextField",nil);
            _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; //minuscule
        }
    }
    else if (indexPath.row == 1)
    {
        // Affecter le pointer _passwordLabel au label password pour pouvoir le manipuler (ex: mettre la couleur en rouge).
        cell.signInLabel.text = NSLocalizedString(@"Sign-Pwd-Label",nil);
        if (!_passwordLabel)
        {
            _passwordLabel = cell.signInLabel;
        }
        
        // Affecter le pointer _passwordTextField au textField password pour changer ses propriétés
        if (!_passwordTextField)
        {
            _passwordTextField = cell.signInTextField;
            _passwordTextField.tag = indexPath.row ;
            _passwordTextField.delegate = self;
            _passwordTextField.keyboardType = UIKeyboardTypeDefault;
            _passwordTextField.returnKeyType = UIReturnKeyGo;
            _passwordTextField.secureTextEntry = YES;
            _passwordTextField.placeholder = NSLocalizedString(@"Sign-Pwd-TextField",nil);
        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SigneInTableViewCell  *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    [[cellSelected signInTextField] becomeFirstResponder];
}


//===============================================
#pragma mark Validation des Text Fields
//===============================================


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //cas particulier utilisé dans la methode shouldChangeCharactersInRange
    if (textField.tag == 1 && textField.text.length > 0)
    {
        allPasswordTextFieldCanBeEraseInOneTouch = YES;
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    testString = [testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (testString.length)
    {
        //Cas particulier. La methode shouldChangeCharactersInRange traite caractère par caractère
        //Or quand on appuie sur la touche "<--", tout le mot de passe (en entier) peut etre supprimé (et pas uniquement un seul caractère). Par conséquent, le champs textField passé en paramètre à la méthode n'est pas vide (il contient uniquement un caractère en moins) alors que tout le mot de passe a été supprimé
        if ((textField.tag == 1) && [string isEqualToString:@""] && (allPasswordTextFieldCanBeEraseInOneTouch == YES))
        {
            allPasswordTextFieldCanBeEraseInOneTouch = NO;
            passwordTextFieldIsFilled = NO;
            [_signInButton setEnabled:NO];
        }
        else
        {
            if (textField.tag == 0)
            {
                emailTextFieldIsFilled = YES;
            }
            if (textField.tag == 1)
            {
                passwordTextFieldIsFilled = YES;
            }
            
            if (emailTextFieldIsFilled == YES && passwordTextFieldIsFilled == YES)
            {
                [_signInButton setEnabled:YES];
            }
        }
    }
    else
    {
        if (textField.tag == 0)
        {
            emailTextFieldIsFilled = NO;
        }
        if (textField.tag == 1)
        {
            passwordTextFieldIsFilled = NO;
        }
        [_signInButton setEnabled:NO];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
        [self loginButtonTouch];
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
