//
//  SearchView.h
//  Louis
//
//  Created by François Juteau on 05/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

-(void)searchViewdidTextFieldTouch;
-(void)searchViewdidLocalizeButtonTouch;

@end


@interface SearchView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *searchPictureView;
@property (nonatomic, strong) UIButton *localizeButton;
@property (nonatomic, weak) id<SearchViewDelegate> delegate;


#pragma mark - Button color methods

-(void)changeLocalizeButtonToUserLocationColor;
-(void)changeLocalizeButtonToOtherLocationColor;

@end
