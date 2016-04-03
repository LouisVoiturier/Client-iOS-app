//
//  ProfilePictureView.m
//  Louis
//
//  Created by François Juteau on 01/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfilePictureView.h"
#import "DataManager+User.h"
#import "ImageManager.h"
#import "Common.h"

@implementation ProfilePictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Instantiation des outlets
        _firstnameLabel = [[UILabel alloc] init];
        [_firstnameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _lastnameLabel = [[UILabel alloc] init];
        [_lastnameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Affectation des properties
        _firstnameLabel.textColor = [UIColor louisLabelColor];
        _firstnameLabel.text = [DataManager user].firstName;
        
        _lastnameLabel.textColor = [UIColor louisLabelColor];
        _lastnameLabel.text = [DataManager user].lastName;
        _lastnameLabel.text = [_lastnameLabel.text uppercaseString];
        
        if (!([DataManager user].picture))
        {
            _imageView.image = [UIImage imageNamed:@"NoPhoto"];
        }
        
        // La photo est chargé lors du signIn et de l'auto login.
        // si pictureImage est renseigné, cela signifie qu'on a changé la photo dans Profile. Il faut donc la remplacer
        if ([DataManager user].pictureImage)
        {
                 _imageView.image = [DataManager user].pictureImage;
        }
//        else if ([DataManager user].picture)
//        {
//            [ImageManager getImageFromUrlPath:[DataManager user].picture withCompletion:^(UIImage *image)
//             {
//                 [DataManager user].pictureImage = image;
//                 _imageView.image = image;
//                 
//             }];
////            UIImage *myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DataManager user].picture]]];
////            NSLog(@"UIImage from picture : %@", myImage);
////            _imageView.image = myImage;
//        }

        
        // Ajout à la vue
        [self addSubview:_firstnameLabel];
        [self addSubview:_lastnameLabel];
        [self addSubview:_imageView];
        
        // Ajustements
        self.backgroundColor = nil;
        
        
        /***** CONTRAINTES *****/
        NSNumber *imageSize = [NSNumber numberWithDouble:self.frame.size.height*0.7]; // elle est ronde donc width = height
        NSNumber *imageMarginTop = [NSNumber numberWithDouble:self.frame.size.height*0.30];
        NSNumber *imageMarginLeft = [NSNumber numberWithDouble:imageSize.doubleValue*0.2];
        NSNumber *labelsHeight = [NSNumber numberWithInt:20];
        NSNumber *firstnamePositionY = [NSNumber numberWithDouble:(self.frame.size.height*0.65)-labelsHeight.doubleValue];
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_firstnameLabel, _lastnameLabel, _imageView);
        
        NSDictionary *metrics = NSDictionaryOfVariableBindings(imageMarginTop, imageMarginLeft, imageSize, labelsHeight, firstnamePositionY);
        
        // Horizontale pour l'image et le firstname
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-imageMarginLeft-[_imageView(imageSize)]-imageMarginLeft-[_firstnameLabel(200)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Horizontale pour l'image et le lastname
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-imageMarginLeft-[_lastnameLabel(200)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour l'image
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageMarginTop-[_imageView(imageSize)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour les labels
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-firstnamePositionY-[_firstnameLabel(labelsHeight)][_lastnameLabel(labelsHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
    }
    return self;
}


- (instancetype)initWithFrameAndLabelsOnTheLeftAndBottom:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Instantiation des outlets
        _wellcomeMsgLabel = [[UILabel alloc] init];
        [_wellcomeMsgLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
       
        _lastnameLabel = [[UILabel alloc] init];
        [_lastnameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _addCardTitleLabel = [[UILabel alloc] init];
        [_addCardTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _addCardMsgLabel = [[UILabel alloc] init];
        [_addCardMsgLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
   
      
        // Affectation des properties
        _wellcomeMsgLabel.text = NSLocalizedString(@"SignUp-AddPayment-WelcomeMsg", nil);
        _wellcomeMsgLabel.textColor = [UIColor louisLabelColor];
        
        _lastnameLabel.text = [DataManager user].firstName;
        _lastnameLabel.textColor = [UIColor blackColor];
        _lastnameLabel.text = [_lastnameLabel.text uppercaseString];
        
        _addCardTitleLabel.text = NSLocalizedString(@"SignUp-AddCard-Warning-Title", nil);
        [_addCardTitleLabel setFont:[UIFont systemFontOfSize:13.f weight:UIFontWeightBold]];
        
        _addCardMsgLabel.text = NSLocalizedString(@"SignUp-AddCard-Warning-Msg", nil);
        [_addCardMsgLabel setFont:[UIFont systemFontOfSize:12.f weight:UIFontWeightRegular]];
        [_addCardMsgLabel setNumberOfLines:0];
        [_addCardMsgLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [_addCardMsgLabel setAdjustsFontSizeToFitWidth:YES];
       
 
        if (!([DataManager user].picture))
        {
            _imageView.image = [UIImage imageNamed:@"NoPhoto"];
        }
        
        // La photo est chargé lors du signIn et de l'auto login.
        // si pictureImage est renseigné, cela signifie qu'on a changé la photo dans Profile. Il faut donc la remplacer
        if ([DataManager user].pictureImage)
        {
            _imageView.image = [DataManager user].pictureImage;
        }
        
        // Ajout à la vue
        [self addSubview:_wellcomeMsgLabel];
        [self addSubview:_lastnameLabel];
        [self addSubview:_imageView];
        [self addSubview:_addCardTitleLabel];
        [self addSubview:_addCardMsgLabel];
        
        // Ajustements
        self.backgroundColor = nil;
        
        
        /***** CONTRAINTES *****/
        NSNumber *imageSize = [NSNumber numberWithDouble:self.frame.size.height*0.5]; // elle est ronde donc width = height
        NSNumber *imageMarginTop = [NSNumber numberWithDouble:self.frame.size.height*0.05];
        NSNumber *imageMarginLeft = [NSNumber numberWithDouble:imageSize.doubleValue*0.2];
        NSNumber *labelsHeight = [NSNumber numberWithInt:20];
        NSNumber *wellcomeMsgLabelPositionY = [NSNumber numberWithDouble:(self.frame.size.height*0.35)-labelsHeight.doubleValue];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_wellcomeMsgLabel, _lastnameLabel, _imageView, _addCardTitleLabel, _addCardMsgLabel);
        
        NSDictionary *metrics = NSDictionaryOfVariableBindings(imageMarginTop, imageMarginLeft, imageSize, labelsHeight, wellcomeMsgLabelPositionY);
        
        // Horizontale pour l'image et le _wellcomeMsgLabel
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-imageMarginLeft-[_imageView(imageSize)]-imageMarginLeft-[_wellcomeMsgLabel(200)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Horizontale pour l'image et le lastname
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-imageMarginLeft-[_lastnameLabel(200)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Horizontale pour addCardTitleLabel
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_addCardTitleLabel(250)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Horizontale pour addCardTitleMsg
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_addCardMsgLabel(300)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour l'image et les 2 labels du bas
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageMarginTop-[_imageView(imageSize)]-[_addCardTitleLabel(==labelsHeight)]-0-[_addCardMsgLabel]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour les labels et les 2 labels à gauche
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-wellcomeMsgLabelPositionY-[_wellcomeMsgLabel(labelsHeight)][_lastnameLabel(labelsHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_imageView.layer setCornerRadius:_imageView.frame.size.height/2];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderWidth = 6;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
