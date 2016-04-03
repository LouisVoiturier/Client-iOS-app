//
//  ProfilePictureViewWithButton.m
//  Louis
//
//  Created by Giang Christian on 09/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "ProfilePictureViewWithButton.h"
#import "DataManager+User.h"
#import "Common.h"
#import "ImageManager.h"

@implementation ProfilePictureViewWithButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Instantiation bouton et imageview
        _firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_firstButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
     
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
        [self addSubview:_firstButton];
        [self addSubview:_imageView];
        
        // Ajustements
        self.backgroundColor = nil;
        
        /***** CONTRAINTES *****/
        NSNumber *imageSize = [NSNumber numberWithDouble:self.frame.size.height*0.7]; // elle est ronde donc width = height
        NSNumber *imageMarginTop = [NSNumber numberWithDouble:self.frame.size.height*0.15];
        NSNumber *imageMarginLeft = [NSNumber numberWithDouble:imageSize.doubleValue*0.2];
        NSNumber *buttonsHeight = [NSNumber numberWithInt:20];
        NSNumber *firstButtonPositionY = [NSNumber numberWithDouble:(self.frame.size.height*0.5)-buttonsHeight.doubleValue];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_firstButton, _imageView);
        
        NSDictionary *metrics = NSDictionaryOfVariableBindings(imageMarginTop, imageMarginLeft, imageSize, buttonsHeight, firstButtonPositionY);
        
        // Horizontale pour l'image et le firstButton
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-imageMarginLeft-[_imageView(imageSize)]-imageMarginLeft-[_firstButton(200)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

        // Vertical pour l'image
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageMarginTop-[_imageView(imageSize)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour le button
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-firstButtonPositionY-[_firstButton(buttonsHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
    }
    return self;
}


- (instancetype)initWithFrameAndBottomButton:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Instantiation bouton et imageview
        _firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_firstButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
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
        [self addSubview:_firstButton];
        [self addSubview:_imageView];
        
        // Ajustements
        self.backgroundColor = nil;
        
        /***** CONTRAINTES *****/
        NSNumber *imageSize = [NSNumber numberWithDouble:self.frame.size.height*0.7]; // elle est ronde donc width = height
        NSNumber *imageMarginTop = [NSNumber numberWithDouble:self.frame.size.height*0.05];
        NSNumber *imageMarginLeft = [NSNumber numberWithDouble:imageSize.doubleValue*0.2];
        NSNumber *buttonsHeight = [NSNumber numberWithInt:20];
//        NSNumber *firstButtonPositionY = [NSNumber numberWithDouble:(self.frame.size.height*0.5)-buttonsHeight.doubleValue];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_firstButton, _imageView);
        
        NSDictionary *metrics = NSDictionaryOfVariableBindings(imageMarginTop, imageMarginLeft, imageSize, buttonsHeight);
        
     
        // Vertical pour l'image
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageMarginTop-[_imageView(imageSize)]-[_firstButton(buttonsHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        // Vertical pour le button
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView(imageSize)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
 
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_firstButton
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
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
