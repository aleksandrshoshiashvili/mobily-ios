/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import "MobilyNS.h"
#import "MobilyCG.h"

/*--------------------------------------------------*/

#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface NSString (MobilyUI)

- (CGSize)implicitSizeWithFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)implicitSizeWithFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)implicitSizeWithFont:(UIFont*)font forSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (UIEdgeInsets)convertToEdgeInsets;
- (UIEdgeInsets)convertToEdgeInsetsSeparated:(NSString*)separated;

- (UIBezierPath*)convertToBezierPath;
- (UIBezierPath*)convertToBezierPathSeparated:(NSString*)separated;

- (UIFont*)convertToFont;
- (UIFont*)convertToFontSeparated:(NSString*)separated;
- (UIImage*)convertToImage;
- (UIImage*)convertToImageSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated;
- (NSArray*)convertToImages;
- (NSArray*)convertToImagesSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated frameSeparated:(NSString*)frameSeparated;

- (UIRemoteNotificationType)convertToRemoteNotificationType;
- (UIRemoteNotificationType)convertToRemoteNotificationTypeSeparated:(NSString*)separated;
- (UIInterfaceOrientationMask)convertToInterfaceOrientationMask;
- (UIInterfaceOrientationMask)convertToInterfaceOrientationMaskSeparated:(NSString*)separated;

- (UIStatusBarStyle)convertToStatusBarStyle;
- (UIStatusBarAnimation)convertToStatusBarAnimation;

- (UIViewAutoresizing)convertToViewAutoresizing;
- (UIViewAutoresizing)convertToViewAutoresizingSeparated:(NSString*)separated;
- (UIViewContentMode)convertToViewContentMode;
- (UIControlContentHorizontalAlignment)convertToControlContentHorizontalAlignment;
- (UIControlContentVerticalAlignment)convertToControlContentVerticalAlignment;
- (UITextAutocapitalizationType)convertToTextAutocapitalizationType;
- (UITextAutocorrectionType)convertToTextAutocorrectionType;
- (UITextSpellCheckingType)convertToTestSpellCheckingType;
- (UIKeyboardType)convertToKeyboardType;
- (UIReturnKeyType)convertToReturnKeyType;
- (UIBaselineAdjustment)convertToBaselineAdjustment;

- (UIScrollViewIndicatorStyle)convertToScrollViewIndicatorStyle;
- (UIScrollViewKeyboardDismissMode)convertToScrollViewKeyboardDismissMode;
- (UIBarStyle)convertToBarStyle;
- (UITabBarItemPositioning)convertToTabBarItemPositioning;
- (UISearchBarStyle)convertToSearchBarStyle;
- (UIProgressViewStyle)convertToProgressViewStyle;
- (UITextBorderStyle)convertToTextBorderStyle;

@end

/*--------------------------------------------------*/
/* BASE                                             */
/*--------------------------------------------------*/

#define MOBILY_COLOR_RGB(R, G, B)                   [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0f]
#define MOBILY_COLOR_RGBA(R, G, B, A)               [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A) / 255.0f]

/*--------------------------------------------------*/

typedef struct {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} MobilyColorHSB;

/*--------------------------------------------------*/

BOOL MobilyColorHSBEqualToColorHSB(MobilyColorHSB color1, MobilyColorHSB color2);

/*--------------------------------------------------*/

@interface UIColor (MobilyUI)

+ (UIColor*)colorWithString:(NSString*)string;
+ (CGFloat)colorComponentFromString:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length;

-(MobilyColorHSB)hsb;

@end

/*--------------------------------------------------*/

@interface UIImage (MobilyUI)

+ (UIImage*)imageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets;

- (UIImage*)scaleToSize:(CGSize)size;

@end

/*--------------------------------------------------*/

@interface UINib (MobilyUI)

+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class;
+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class withOwner:(id)owner;

+ (UINib*)nibWithBaseName:(NSString*)baseName bundle:(NSBundle*)bundle;
+ (UINib*)nibWithClass:(Class)class bundle:(NSBundle*)bundle;

- (id)instantiateWithClass:(Class)class owner:(id)owner options:(NSDictionary*)options;

@end

/*--------------------------------------------------*/

@interface UIResponder (MobilyUI)

+ (id)currentFirstResponder;

+ (UIResponder*)prevResponderFromView:(UIView*)view withSuperview:(UIView*)superview;
+ (UIResponder*)nextResponderFromView:(UIView*)view withSuperview:(UIView*)superview;

@end

/*--------------------------------------------------*/
/* VIEWS                                            */
/*--------------------------------------------------*/

@interface UIWindow (MobilyUI)

@property(nonatomic, readonly, strong) UIViewController* currentViewController;

#ifdef __IPHONE_7_0

@property(nonatomic, readonly, strong) UIViewController* viewControllerForStatusBarStyle;
@property(nonatomic, readonly, strong) UIViewController* viewControllerForStatusBarHidden;

#endif

@end

/*--------------------------------------------------*/

@interface UIView (MobilyUI)

@property(nonatomic, readwrite, assign) CGPoint framePosition;
@property(nonatomic, readwrite, assign) CGPoint frameCenter;
@property(nonatomic, readwrite, assign) CGSize frameSize;
@property(nonatomic, readwrite, assign) CGFloat frameSX;
@property(nonatomic, readwrite, assign) CGFloat frameCX;
@property(nonatomic, readwrite, assign) CGFloat frameEX;
@property(nonatomic, readwrite, assign) CGFloat frameSY;
@property(nonatomic, readwrite, assign) CGFloat frameCY;
@property(nonatomic, readwrite, assign) CGFloat frameEY;
@property(nonatomic, readwrite, assign) CGFloat frameWidth;
@property(nonatomic, readwrite, assign) CGFloat frameHeight;
@property(nonatomic, readwrite, assign) CGFloat frameLeft;
@property(nonatomic, readwrite, assign) CGFloat frameRight;
@property(nonatomic, readwrite, assign) CGFloat frameTop;
@property(nonatomic, readwrite, assign) CGFloat frameBottom;

@property(nonatomic, readonly, assign) CGPoint boundsPosition;
@property(nonatomic, readonly, assign) CGPoint boundsCenter;
@property(nonatomic, readonly, assign) CGSize boundsSize;
@property(nonatomic, readonly, assign) CGFloat boundsCX;
@property(nonatomic, readonly, assign) CGFloat boundsCY;
@property(nonatomic, readonly, assign) CGFloat boundsWidth;
@property(nonatomic, readonly, assign) CGFloat boundsHeight;

@property(nonatomic, readonly, assign) CGFloat cornerRadius;
@property(nonatomic, readonly, assign) CGFloat borderWidth;
@property(nonatomic, readonly, strong) UIColor* borderColor;
@property(nonatomic, readonly, strong) UIColor* shadowColor;
@property(nonatomic, readonly, assign) CGFloat shadowOpacity;
@property(nonatomic, readonly, assign) CGSize shadowOffset;
@property(nonatomic, readonly, assign) CGFloat shadowRadius;
@property(nonatomic, readonly, strong) UIBezierPath* shadowPath;

- (void)setSubviews:(NSArray*)subviews;
- (void)removeAllSubviews;

- (void)blinkBackgroundColor:(UIColor*)color duration:(NSTimeInterval)duration timeout:(NSTimeInterval)timeout;

@end

/*--------------------------------------------------*/

@interface UIScrollView (MobilyUI)

- (CGSize)contentSizeFromSubviews;

@end

/*--------------------------------------------------*/

@interface UITabBar (MobilyUI)

@property(nonatomic, readwrite, assign) NSUInteger selectedItemIndex;

@end

/*--------------------------------------------------*/

@interface UINavigationBar (MobilyUI)



@end

/*--------------------------------------------------*/

@interface UILabel (MobilyUI)

- (CGSize)implicitSize;
- (CGSize)implicitSizeForWidth:(CGFloat)width;
- (CGSize)implicitSizeForSize:(CGSize)size;

@end

/*--------------------------------------------------*/

@interface UIButton (MobilyUI)

@property(nonatomic, readwrite, strong) NSString* normalTitle;
@property(nonatomic, readwrite, strong) UIColor* normalTitleColor;
@property(nonatomic, readwrite, strong) UIColor* normalTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* normalImage;
@property(nonatomic, readwrite, strong) UIImage* normalBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* highlightedTitle;
@property(nonatomic, readwrite, strong) UIColor* highlightedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* highlightedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* highlightedImage;
@property(nonatomic, readwrite, strong) UIImage* highlightedBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* disabledTitle;
@property(nonatomic, readwrite, strong) UIColor* disabledTitleColor;
@property(nonatomic, readwrite, strong) UIColor* disabledTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* disabledImage;
@property(nonatomic, readwrite, strong) UIImage* disabledBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* selectedTitle;
@property(nonatomic, readwrite, strong) UIColor* selectedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* selectedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* selectedImage;
@property(nonatomic, readwrite, strong) UIImage* selectedBackgroundImage;

@end

/*--------------------------------------------------*/
/* CONTROLLERS                                      */
/*--------------------------------------------------*/

@interface UIViewController (MobilyUI)

@property(nonatomic, readonly, strong) UIView* topView;

- (void)loadViewIfNeed;

@end

/*--------------------------------------------------*/

@interface UINavigationController (MobilyUI)

@property(nonatomic, readwrite, assign, getter = isTranslucent) BOOL translucent NS_AVAILABLE_IOS(3_0);
@property(nonatomic, readwrite, retain) UIColor* tintColor;
@property(nonatomic, readwrite, retain) UIColor* barTintColor NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* shadowImage NS_AVAILABLE_IOS(6_0);
@property(nonatomic, readwrite, copy) NSDictionary* titleTextAttributes NS_AVAILABLE_IOS(5_0);
@property(nonatomic, readwrite, retain) UIImage* backIndicatorImage NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* backIndicatorTransitionMaskImage NS_AVAILABLE_IOS(7_0);

- (UIViewController*)rootViewController;

@end

/*--------------------------------------------------*/

@interface UINavigationItem (MobilyUI)

- (void)setLeftBarView:(UIView*)view animated:(BOOL)animated;
- (void)setRightBarView:(UIView*)view animated:(BOOL)animated;

@end

/*--------------------------------------------------*/
/* OTHER                                            */
/*--------------------------------------------------*/

@interface UIDevice (MobilyUI)

+ (CGFloat)systemVersion;

+ (BOOL)isIPhone;
+ (BOOL)isIPad;

@end

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_STRING(name) \
- (BOOL)validate##name:(inout id*)value error:(out NSError**)error { \
    return [*value isKindOfClass:[NSString class]]; \
}

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_STRING_BASED(name, resultClass, convertValue) \
- (BOOL)validate##name:(inout id*)value error:(out NSError**)error { \
    if([*value isKindOfClass:[NSString class]] == YES) { \
        *value = convertValue; \
    } \
    return [*value isKindOfClass:[resultClass class]]; \
}

#define MOBILY_DEFINE_VALIDATE_BOOL(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithBool:[*value convertToBool]])
#define MOBILY_DEFINE_VALIDATE_NUMBER(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [*value convertToNumber])
#define MOBILY_DEFINE_VALIDATE_RECT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGRect:[*value convertToRect]])
#define MOBILY_DEFINE_VALIDATE_POINT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGPoint:[*value convertToPoint]])
#define MOBILY_DEFINE_VALIDATE_SIZE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGSize:[*value convertToSize]])
#define MOBILY_DEFINE_VALIDATE_EDGE_INSETS(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithUIEdgeInsets:[*value convertToEdgeInsets]])
#define MOBILY_DEFINE_VALIDATE_COLOR(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIColor, [UIColor colorWithString:*value])
#define MOBILY_DEFINE_VALIDATE_BEZIER_PATH(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIBezierPath, [*value convertToBezierPath])
#define MOBILY_DEFINE_VALIDATE_IMAGE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIImage, [*value convertToImage])
#define MOBILY_DEFINE_VALIDATE_FONT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIFont, [*value convertToFont])
#define MOBILY_DEFINE_VALIDATE_REMOTE_NOTIFICATION_TYPE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToRemoteNotificationType]])
#define MOBILY_DEFINE_VALIDATE_INTERFACE_ORIENTATION_MASK(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToInterfaceOrientationMask]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToStatusBarStyle]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_ANIMATION(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToStatusBarAnimation]])
#define MOBILY_DEFINE_VALIDATE_AUTORESIZING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToViewAutoresizing]])
#define MOBILY_DEFINE_VALIDATE_CONTENT_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToViewContentMode]])
#define MOBILY_DEFINE_VALIDATE_TEXT_ALIGNMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTextAlignment]])
#define MOBILY_DEFINE_VALIDATE_LINE_BREAKMODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToLineBreakMode]])
#define MOBILY_DEFINE_VALIDATE_BASELINE_ADJUSTMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToBaselineAdjustment]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_INDICATOR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToScrollViewIndicatorStyle]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_KEYBOARD_DISMISS_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToScrollViewKeyboardDismissMode]])
#define MOBILY_DEFINE_VALIDATE_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToBarStyle]])
#define MOBILY_DEFINE_VALIDATE_TAB_BAR_ITEM_POSITIONING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTabBarItemPositioning]])
#define MOBILY_DEFINE_VALIDATE_SEARCH_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToSearchBarStyle]])
#define MOBILY_DEFINE_VALIDATE_PROGRESS_VIEW_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToProgressViewStyle]])
#define MOBILY_DEFINE_VALIDATE_TEXT_BORDER_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTextBorderStyle]])

/*--------------------------------------------------*/
