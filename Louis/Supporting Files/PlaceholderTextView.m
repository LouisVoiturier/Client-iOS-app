//
//  PlaceholderTextView.m
//  Louis
//
//  Created by Thibault Le Cornec on 27/06/16.
//  Copyright © 2016 Louis. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()
@property(nonatomic, retain) UILabel *labelPlaceholder;
@end



@implementation PlaceholderTextView

static char kvoContextIsConnected;
static NSArray *observingKeys;

+ (void)initialize
{
    [super initialize];
    if (self == PlaceholderTextView.class) {
        observingKeys = @[@"attributedText",
                          @"bounds",
                          @"font",
                          @"frame",
                          @"text",
                          @"textAlignment",
                          @"textContainerInset"];
    }
}

/* ************************
   MARK: - Object Lifecycle
   ************************ */

- (void)commonInit
{
    _labelPlaceholder = [UILabel new];
    _labelPlaceholder.userInteractionEnabled = NO;
    _labelPlaceholder.lineBreakMode = NSLineBreakByWordWrapping;
    _labelPlaceholder.numberOfLines = 0;
    _labelPlaceholder.backgroundColor = UIColor.clearColor;
    _labelPlaceholder.textColor = [self.class defaultPlaceholderColor];
    [self insertSubview:_labelPlaceholder atIndex:0];
    self.scrollEnabled = YES;
    
    /* Notif & KVO */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaceholderLabel:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    for (NSString *key in observingKeys) {
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:&kvoContextIsConnected];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]) != nil) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
    if (_labelPlaceholder) {
        for (NSString *key in observingKeys) {
            [self removeObserver:self forKeyPath:key context:&kvoContextIsConnected];
        }
    }
}


/* *****************
   MARK: - Accessors
   ***************** */

- (NSString *)placeholder
{
    return self.labelPlaceholder.text;
}

- (void)setPlaceholder:(NSString *)placeholderString
{
    self.labelPlaceholder.text = placeholderString;
    [self updatePlaceholderLabel:nil];
}

- (UIColor *)placeholderColor
{
    return self.labelPlaceholder.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.labelPlaceholder.textColor = placeholderColor;
}


/* *************************
   MARK: - KVO Notifications
   ************************* */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
#pragma unused(keyPath, object, change, context)
    if (context == &kvoContextIsConnected) {
        [self updatePlaceholderLabel:nil];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updatePlaceholderLabel:(NSNotification *)notif
{
#pragma unused(notif)
    self.labelPlaceholder.hidden = (self.text.length > 0);
    
    self.labelPlaceholder.font = self.font;
    self.labelPlaceholder.textAlignment = self.textAlignment;
    
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;
    lineFragmentPadding = self.textContainer.lineFragmentPadding;
    textContainerInset  = self.textContainerInset;
    
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.labelPlaceholder sizeThatFits:CGSizeMake(width, 0)].height;
    self.labelPlaceholder.frame = CGRectMake(x, y, width, height);
}

/* ***************
   MARK: - Private
   *************** */

+ (UIColor *)defaultPlaceholderColor
{
    return [UIColor colorWithRed:0 green:0 blue:25.0/255.0 alpha:0.22];
}

@end
