//
//  LocationArrowView.m
//  Louis
//
//  Created by François Juteau on 22/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "LocationArrowView.h"

@implementation LocationArrowView


- (void)drawRect:(CGRect)rect
{
    
    CGPoint origin = CGPointMake(2, 2);
    
    CGFloat arrowSizeDifferenciel = 8;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Upper tip
    [path moveToPoint:CGPointMake(origin.x, origin.y)];
    // Arrow head
    [path addLineToPoint:CGPointMake(origin.x + arrowSizeDifferenciel, origin.y + arrowSizeDifferenciel)];
    // Lower tip
    [path addLineToPoint:CGPointMake(origin.x, origin.y + (arrowSizeDifferenciel * 2))];
    
    [[UIColor whiteColor] set];
    // The line thickness needs to be proportional to the distance from the arrow head to the tips.  Making it half seems about right.
    [path setLineWidth:2.5];
    [path stroke];
    
}

@end
