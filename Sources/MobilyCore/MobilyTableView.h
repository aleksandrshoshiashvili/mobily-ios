/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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

#import <MobilyCore/MobilyBuilder.h>

/*--------------------------------------------------*/

@class MobilyTableSwipeCell;

/*--------------------------------------------------*/

@interface MobilyTableView : UITableView< MobilyBuilderObject >

@property(nonatomic, readwrite, weak) MobilyTableSwipeCell* currentSwipeCell;

- (void)setup NS_REQUIRES_SUPER;

- (void)setCurrentSwipeCell:(MobilyTableSwipeCell*)currentSwipeCell animated:(BOOL)animated;

- (void)registerCellClass:(Class)cellClass;
- (void)registerHeaderFooterClass:(Class)headerFooterClass;

- (id)dequeueReusableCellWithClass:(Class)cellClass;
- (id)dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
- (id)dequeueReusableHeaderFooterViewWithClass:(Class)headerFooterClass NS_AVAILABLE_IOS(6_0);

@end

/*--------------------------------------------------*/

@interface MobilyTableCell : UITableViewCell< MobilyObject >

@property(nonatomic, readwrite, weak) MobilyTableView* tableView;
@property(nonatomic, readwrite, strong) IBOutlet UIView* rootView;
@property(nonatomic, readwrite, weak) id model;

- (void)setup NS_REQUIRES_SUPER;

- (void)didLoadFromNib;

+ (CGFloat)heightForModel:(id)model tableView:(UITableView*)tableView;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyTableSwipeCellStyle) {
    MobilyTableSwipeCellStyleStands,
    MobilyTableSwipeCellStyleLeaves,
    MobilyTableSwipeCellStylePushes
};

/*--------------------------------------------------*/

@interface MobilyTableSwipeCell : MobilyTableCell

@property(nonatomic, readwrite, assign) IBInspectable MobilyTableSwipeCellStyle swipeStyle;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeThreshold;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeVelocity;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeSpeed;
@property(nonatomic, readwrite, assign, getter=isShowedLeftSwipeView) IBInspectable BOOL showedLeftSwipeView;
@property(nonatomic, readwrite, assign, getter=isShowedRightSwipeView) IBInspectable BOOL showedRightSwipeView;
@property(nonatomic, readwrite, strong) IBOutlet UIView* leftSwipeView;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat leftSwipeViewWidth;
@property(nonatomic, readwrite, strong) IBOutlet UIView* rightSwipeView;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat rightSwipeViewWidth;
@property(nonatomic, readonly, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readonly, getter=isSwipeDecelerating) BOOL swipeDecelerating;

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated;
- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated;
- (void)setHiddenAnySwipeViewAnimated:(BOOL)animated;

- (void)willBeganSwipe;
- (void)didBeganSwipe;
- (void)movingSwipe:(CGFloat)progress;
- (void)willEndedSwipe;
- (void)didEndedSwipe;

@end

/*--------------------------------------------------*/
