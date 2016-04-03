//
//  LocationPinView.h
//  Louis
//
//  Created by François Juteau on 07/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationPinViewDelegate <NSObject>

-(void)replacepinToCenterZone;

@end

@interface LocationPinView : UIView

// Affichage du temps de trajet
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) id<LocationPinViewDelegate> delegate;

#pragma mark - Setters

-(void)setDescriptionLabelText:(NSString *)text;

-(void)changeToOffZoneContent;

-(void)changeToInZoneContent;



@end

