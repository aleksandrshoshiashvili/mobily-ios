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

#import "MobilyViewController.h"
#import "MobilyBuilder.h"

/*--------------------------------------------------*/

@interface MobilyViewController ()

@property(nonatomic, readwrite, assign, getter = isNeedUpdate) BOOL needUpdate;
@property(nonatomic, readwrite, strong) NSString* mobilyName;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewController

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_INTERFACE_ORIENTATION_MASK(Orientation)
MOBILY_DEFINE_VALIDATE_STRING(MobilyName)

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.automaticallyHideKeyboard = YES;
    self.needUpdate = YES;
}

- (void)dealloc {
    self.mobilyName = nil;
}

#pragma mark MobilyLoaderObject

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    id< MobilyBuilderObject > result = [MobilyBuilderForm object:self forName:name];
    if(result == nil) {
        if(self.isViewLoaded == YES) {
            UIView< MobilyBuilderObject >* view = (UIView< MobilyBuilderObject >*)self.view;
            if([view respondsToSelector:@selector(objectForName:)] == YES) {
                result = [view objectForName:name];
            }
        }
    }
    return result;
}

#pragma mark UIViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return _orientation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return ((_orientation & orientation) != 0);
}

- (void)loadView {
    if(_mobilyName.length > 0) {
        UIView* view = [MobilyBuilderForm objectFromFilename:_mobilyName owner:self];
        if([view isKindOfClass:UIView.class] == YES) {
            self.view = view;
        } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
            NSLog(@"Failure load view mobily '%@' object '%@'", _mobilyName, NSStringFromClass(view.class));
#endif
            [super loadView];
        }
    } else {
        UINib* nib = nil;
        NSString* nibName = self.nibName;
        if(nibName.length > 0) {
            nib = [UINib nibWithBaseName:nibName bundle:self.nibBundle];
        } else {
            nib = [UINib nibWithClass:self.class bundle:self.nibBundle];
        }
        if(nib != nil) {
            [nib instantiateWithOwner:self options:nil];
        } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
            NSLog(@"Failure load view nib '%@'", NSStringFromClass(self.class));
#endif
            [super loadView];
        }
    }
}

- (void)viewDidUnload {
    [self setNeedUpdate];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self isNeedUpdate] == YES) {
        self.needUpdate = NO;
        [self update];
    }
}

#pragma mark Public

- (void)setNeedUpdate {
    if((self.isViewLoaded == YES) && ([self isAppeared] == YES)) {
        [self update];
    } else {
        self.needUpdate = YES;
    }
}

- (void)update {
}

- (void)clear {
    [self setNeedUpdate];
}

@end

/*--------------------------------------------------*/
