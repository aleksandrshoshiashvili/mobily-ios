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

#import "MobilyApplication.h"
#import "MobilyWindow.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyApplication ()

@property(nonatomic, readwrite, strong) NSData* deviceToken;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApplication

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIWindow.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIWindow.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Public

- (BOOL)launchingWithOptions:(NSDictionary* __unused)options {
    MobilyWindow* window = nil;
    if(_remoteNotificationType != UIRemoteNotificationTypeNone) {
        [UIApplication.sharedApplication registerForRemoteNotificationTypes:_remoteNotificationType];
    }
    if(_objectChilds.count < 1) {
        window = [MobilyWindow new];
        if(window != nil) {
            window.objectParent = self;
        }
    } else {
        window = _objectChilds.firstObject;
    }
    if(window != nil) {
        [window makeKeyAndVisible];
    }
    return (window != nil);
}

- (void)terminate {
}

- (void)receiveMemoryWarning {
}

- (void)becomeActive {
}

- (void)resignActive {
}

- (void)enterForeground {
}

- (void)enterBackground {
}

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    self.deviceToken = deviceToken;
}

- (void)failToRegisterForRemoteNotificationsWithError:(NSError* __unused)error {
}

- (void)receiveRemoteNotification:(NSDictionary* __unused)notification {
}

- (void)receiveLocalNotification:(UILocalNotification* __unused)notification {
}

- (BOOL)openURL:(NSURL* __unused)url sourceApplication:(NSString* __unused)sourceApplication annotation:(id __unused)annotation {
    return NO;
}

#pragma mark Property

- (UIApplicationState)applicationState {
    return UIApplication.sharedApplication.applicationState;
}

@end

/*--------------------------------------------------*/
