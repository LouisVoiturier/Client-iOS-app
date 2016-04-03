//
//  CourseTimeLeftView.h
//  Louis
//
//  Created by François Juteau on 19/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTimeLeftView : UIView

/********************/
/***** PROPERTIES *****/
/********************/
@property (nonatomic, strong) UILabel *timeLabel;


/********************/
/***** METHODS *****/
/********************/
-(void)addInitialConstraints;

@end
