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

#import "MobilyDataItem.h"
#import "MobilyDataView+Private.h"
#import "MobilyDataContainer+Private.h"
#import "MobilyDataCell+Private.h"

/*--------------------------------------------------*/

@interface MobilyDataItem () {
@protected
    __weak MobilyDataView* _view;
    __weak MobilyDataContainer* _parent;
    NSString* _identifier;
    id _data;
    MobilyDataCell* _cell;
    CGRect _originFrame;
    CGRect _updateFrame;
    CGRect _displayFrame;
    CGRect _frame;
    CGFloat _zOrder;
    BOOL _allowsSelection;
    BOOL _allowsHighlighting;
    BOOL _allowsEditing;
    BOOL _selected;
    BOOL _highlighted;
    BOOL _editing;
}

@property(nonatomic, readwrite, weak) MobilyDataView* view;
@property(nonatomic, readwrite, weak) MobilyDataContainer* parent;
@property(nonatomic, readwrite, strong) NSString* identifier;
@property(nonatomic, readwrite, strong) id data;
@property(nonatomic, readwrite, strong) MobilyDataCell* cell;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarMonth  () {
@protected
    __weak NSCalendar* _calendar;
    NSDate* _beginDate;
    NSDate* _endDate;
}

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate data:(id)data;

- (instancetype)initWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate data:(id)data;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarWeekday () {
@protected
    __weak NSCalendar* _calendar;
    NSDate* _date;
}

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data;

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarDay () {
@protected
    __weak NSCalendar* _calendar;
    NSDate* _date;
}

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data;

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data;

@end

/*--------------------------------------------------*/