//
//  SearchView.m
//  Louis
//
//  Created by François Juteau on 05/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "SearchView.h"
#import "Common.h"


@interface SearchView() <UITextFieldDelegate>
@end

@implementation SearchView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.cornerRadius = 3.f;
        
        // Initialisation
        _title = [[UILabel alloc] init];
        [_title setTranslatesAutoresizingMaskIntoConstraints:NO];
        _textField = [[UITextField alloc] init];
        [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        _searchPictureView = [[UIImageView alloc] init];
        [_searchPictureView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _localizeButton = [[UIButton alloc] init];
        [_localizeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        // Ajout à la vue
        [self addSubview:_title];
        [self addSubview:_textField];
        [self addSubview:_searchPictureView];
        [self addSubview:_localizeButton];
        
        
        // Ajout d'une ombre
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.25;
        
        
        /***** CONTRAINTES *****/
        NSInteger selfWidth = self.frame.size.width;
        NSInteger selfHeight = self.frame.size.height;
        
        NSNumber *hSpacing = [NSNumber numberWithFloat:8.f];
        NSNumber *vSpacing = [NSNumber numberWithFloat:8.f];
        
        NSNumber *titleWidth = [NSNumber numberWithFloat:selfWidth*0.90];
        NSNumber *titleHeight = [NSNumber numberWithFloat:selfHeight*0.30];
        
        NSNumber *textFieldWidth = [NSNumber numberWithFloat:selfWidth*0.80];
        NSNumber *textFieldHeight = [NSNumber numberWithFloat:selfHeight*0.55];
        
        NSNumber *searchPictureWidth = [NSNumber numberWithFloat:13];
        NSNumber *searchPictureHeight = [NSNumber numberWithFloat:13];
        
        NSNumber *localizeButtonWidth = [NSNumber numberWithFloat:20];
        NSNumber *localizeButtonHeight = [NSNumber numberWithFloat:20];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_title, _textField, _searchPictureView, _localizeButton);
        
        NSDictionary *metrics = NSDictionaryOfVariableBindings(hSpacing, vSpacing, titleWidth, titleHeight, textFieldWidth, textFieldHeight, searchPictureWidth, searchPictureHeight, localizeButtonWidth, localizeButtonHeight);
        
        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_title]"
//                                                                     options:0
//                                                                     metrics:metrics
//                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacing-[_searchPictureView(searchPictureWidth)]-hSpacing-[_textField]-hSpacing-[_localizeButton(localizeButtonWidth)]-hSpacing-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vSpacing-[_title(titleHeight)][_textField]-vSpacing-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchPictureView(searchPictureHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_localizeButton(localizeButtonHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        
        
        NSLayoutConstraint *hTitleAlign = [NSLayoutConstraint constraintWithItem:_title
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0
                                                                        constant:0.0];
        
        NSLayoutConstraint *hTextfieldAlign = [NSLayoutConstraint constraintWithItem:_textField
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_title
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0.0];
        
        NSLayoutConstraint *vPictureAlign = [NSLayoutConstraint constraintWithItem:_searchPictureView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_textField
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
        
        NSLayoutConstraint *vLocalizeAlign = [NSLayoutConstraint constraintWithItem:_localizeButton
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_textField
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                           constant:2.f];
        
        [self addConstraints:@[hTitleAlign, hTextfieldAlign, vPictureAlign, vLocalizeAlign]];
        
    }
    return self;
}


-(void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    _title.text = NSLocalizedString(@"SearchView-Title", @"");
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:10];
    _title.textColor = [UIColor louisMainColor];
    
    _textField.placeholder = NSLocalizedString(@"SearchView-PlaceHolder", @"");
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.delegate = self;
    
    _searchPictureView.image = [UIImage imageNamed:@"SearchIcon"];
    
    
    
    [self changeLocalizeButtonToOtherLocationColor];
    [ _localizeButton addTarget:self
                        action:@selector(handleButtonPress:)
              forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Button color methods

-(void)changeLocalizeButtonToOtherLocationColor
{
    UIImage *image = [[UIImage imageNamed:@"LocalizeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_localizeButton setImage:image forState:UIControlStateNormal];
    _localizeButton.tintColor = [UIColor blackColor];
}


-(void)changeLocalizeButtonToUserLocationColor
{
    UIImage *image = [[UIImage imageNamed:@"UserPositionIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_localizeButton setImage:image forState:UIControlStateNormal];
    _localizeButton.tintColor = [self tintColor];
}


#pragma mark - Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.delegate searchViewdidTextFieldTouch];
}


#pragma mark - Action handlers

-(IBAction)handleButtonPress:(UIButton *)sender
{
    [self.delegate searchViewdidLocalizeButtonTouch];
}


@end
