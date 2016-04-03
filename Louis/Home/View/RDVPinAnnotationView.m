//
//  RDVPinAnnotationView.m
//  Louis
//
//  Created by François Juteau on 22/10/2015.
//  Copyright © 2015 Louis. All rights reserved.
//

#import "RDVPinAnnotationView.h"
#import "Common.h"

@interface RDVPinAnnotationView()

@property (nonatomic, strong) UIView *pannelView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation RDVPinAnnotationView


-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
        
        /**********************/
        /***** TEXT LABEL *****/
        /**********************/
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont louisHeaderFont];
        _textLabel.textAlignment= NSTextAlignmentCenter;
        _textLabel.text = @"Lieu de RDV";
        
        
        
        // On set la taille de la vue par rapport à la taille du text
        CGFloat dynamicTextWidth = [_textLabel.text boundingRectWithSize:_textLabel.frame.size
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{ NSFontAttributeName:_textLabel.font }
                                                                 context:nil].size.width;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, dynamicTextWidth, 61.f);
        
        
        /***********************/
        /***** PANNEL VIEW *****/
        /***********************/
        _pannelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dynamicTextWidth + 14, 37.f)];
        _pannelView.layer.cornerRadius = 3.f;
        _pannelView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_pannelView];
        
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pannelView addSubview:_textLabel];  // On ajoute le text label après avoir créé la pannelView mais on doit calculer sa taille avant
        
        [self addInitialConstraints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    /**********************/
    /***** BOTTOM BAR *****/
    /**********************/
    UIBezierPath *barPath = [UIBezierPath bezierPath];
    
    [barPath moveToPoint:CGPointMake(self.frame.size.width * 0.5, 37)];
    [barPath addLineToPoint:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height)];
    
    
    [barPath setLineWidth:2];
    
    [[UIColor blackColor] set];
    
    [barPath stroke];
}

-(void)addInitialConstraints
{
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textLabel);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(@"");
    
    // Horizontale
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    // Verticale
    [_pannelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

@end
