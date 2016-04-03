//
//  WelcomeViewController.m
//  Louis
//
//  Created by Giang Christian on 25/09/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "Common.h"
#import "SignInTableTableViewController.h"
#import "SignUpTableViewController.h"


@interface WelcomeViewController ()
@property (strong, nonatomic)  UIImageView *backgroundImageView;
@property (strong,nonatomic) BigButton *signUpButton;
@property (strong,nonatomic) BigButton *signInButton;

@end

@implementation WelcomeViewController

// Ajout d'un bouton raccourci temporaire pour que les autres puissent tester sans passer par SignUp
- (IBAction)accesAHome:(id)sender {
    
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        HomeViewController* homeController = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeController animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor louisMainColor]];
    [self configureImageAndButtons];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [_signInButton setBackgroundColor:[UIColor clearColor]];
    
    [GAI sendScreenViewWithName:@"Welcome"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationItem.hidesBackButton = YES;
}


-(void) configureImageAndButtons
{
    //------ Background Image ------
    //
    [self showBackgroundImage];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = [[UIScreen mainScreen] bounds].size.height;
    _backgroundImageView.frame = CGRectMake( 0.0f, 0.0f, imageWidth, imageHeight);
    
    [self.view addSubview:_backgroundImageView];
    
    //------ Button Sign Up ------
    //
    _signUpButton = [BigButton bigButtonTypeMainWithTitle:NSLocalizedString(@"Welcome-SignUp-Button-Title", nil)];
    [_signUpButton addTarget:self action:@selector(signUpButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpButton];
    
    //------ Button Sign In ------
    //
    _signInButton = [BigButton bigButtonTypeMainWithTitle:@""];
    [_signInButton setBackgroundColor:[UIColor clearColor]];
    [[_signInButton titleLabel] setFont:[UIFont louisLabelFont]];
    [[_signInButton layer] setBorderColor:[[UIColor clearColor] CGColor]];
    [_signInButton addTarget:self action:@selector(signInButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    // Souligner le text du bouton Sign In.
    [_signInButton addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_signInButton addTarget:self action:@selector(buttonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *signInButtonTitlePart1 = NSLocalizedString(@"Welcome-SignIn-TitlePart1",nil);
    NSString *signInButtonTitlePart2Underline = NSLocalizedString(@"Welcome-SignIn-TitlePart2Underline",nil);
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",signInButtonTitlePart1,signInButtonTitlePart2Underline]];
    
    //    [titleString setAttributes:@{NSForegroundColorAttributeName:[UIColor louisMainColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange([signInButtonTitlePart1 length]+1,[signInButtonTitlePart2Underline length])];
    
    [titleString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange([signInButtonTitlePart1 length]+1,[signInButtonTitlePart2Underline length])];
    
    [_signInButton setAttributedTitle: titleString forState:UIControlStateNormal];
    
    [self.view addSubview:_signInButton];
    
    // ----- Constraints ----- //
    //
    NSNumber *screenWidth = [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];
    NSNumber *buttonWidth = [NSNumber numberWithFloat:[screenWidth floatValue]*0.84];
    NSNumber *buttonHeight = @45;
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_signUpButton,_signInButton,self.view);
    NSDictionary *metricsDict = NSDictionaryOfVariableBindings(buttonHeight,buttonWidth);
    
    // Placement vertical du _signInButton par rapport au bas de la view
    [self.view addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signInButton(==buttonHeight)]-50-|"
                                                                       options:0
                                                                       metrics:metricsDict
                                                                         views:viewsDict]];
    
    // Placement vertical : _signUpButton
    [self.view addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signUpButton(==buttonHeight)]-[_signInButton(==buttonHeight)]"
                                                                       options:0
                                                                       metrics:metricsDict
                                                                         views:viewsDict]];
    
    // Placement Horizontal _signInButton
    [self.view addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_signInButton(==buttonWidth)]"
                                                                       options:0
                                                                       metrics:metricsDict
                                                                         views:viewsDict]];
    // Placement Horizontal _signUpButton
    [self.view addConstraints :[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_signUpButton(==buttonWidth)]"
                                                                       options:0
                                                                       metrics:metricsDict
                                                                         views:viewsDict]];
    
   // centrer le _signInButton sur la view myView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_signInButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];

    // centrer le _signUpButton sur la view myView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_signUpButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
}


- (void)buttonTouchDown
{
    [_signInButton setBackgroundColor:[UIColor clearColor]];
}


- (void)buttonTouchUpInside
{
    [_signInButton setBackgroundColor:[UIColor clearColor]];
}


// Charge l'image de fond en fonction du iDevice
-(void)showBackgroundImage
{
    _backgroundImageView = [[UIImageView alloc]init];
    
    // 3,5 pouce. iPhone 4
    if ([SDVersion deviceSize] == Screen3Dot5inch)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"WelcomeIphone4s"];
    }
    
    // 4 pouce. iPhone 5
    if ([SDVersion deviceSize] == Screen4inch)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"WelcomeIphone5"];
    }
    
    // 4,7 pouce. iPhone 6
    if ([SDVersion deviceSize] == Screen4Dot7inch)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"WelcomeIphone6"];
    }
    
    // 5,5 pouce. iPhone 6 plus
    if ([SDVersion deviceSize] == Screen5Dot5inch)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"WelcomeIphone6plus"];
    }
}


// On fait un push vers SignUpTableViewController
-(IBAction)signUpButtonTouch:(id)sender
{
    SignUpTableViewController *signUpTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpTVC"];
    [self.navigationController pushViewController:signUpTVC animated:YES];
}


// On fait un push vers SignInTableViewController
-(IBAction)signInButtonTouch:(id)sender
{
    SignInTableTableViewController *signUpTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInTVC"];
    [self.navigationController pushViewController:signUpTVC animated:YES];
}


// Ne pas effacer cette methode qui est vide mais utilisé par le storyboard
- (IBAction)cancelSignInSignUp:(UIStoryboardSegue *)segue
{
    // unwind
    // Connecté dans le Storyboard, elle permet de fermer les fenetres Sign In et Sign Up quand on appuie sur le bar button Annuler
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
