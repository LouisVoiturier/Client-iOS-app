//
//  SectionNameView.h
//  Louis
//
//  Created by François Juteau on 14/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionNameView : UIView

@property (nonatomic, strong) UIButton *cardNameButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *deleteButton;

#pragma mark - Delete button layout methods

-(void)hideDeleButton;

@end
