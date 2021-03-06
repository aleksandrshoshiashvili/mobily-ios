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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilySocial/MobilySocialManager.h>
#import <MobilySocial/MobilySocialProvider.h>

/*--------------------------------------------------*/

@interface MobilySocialManager ()


@property(nonatomic, readwrite, strong) NSMutableArray* mutableProviders;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_API_MANAGER_MAX_CONCURRENT_TASK      5

/*--------------------------------------------------*/

@implementation MobilySocialManager

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [self new];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.mutableProviders = NSMutableArray.array;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.mutableProviders = nil;
}

#pragma mark Property

- (NSArray*)providers {
    return [_mutableProviders copy];
}

#pragma mark Public

- (void)registerProvider:(MobilySocialProvider*)provider {
    if([_mutableProviders containsObject:provider] == NO) {
        [_mutableProviders addObject:provider];
        provider.manager = self;
    }
}

- (void)unregisterProvider:(MobilySocialProvider*)provider {
    if([_mutableProviders containsObject:provider] == YES) {
        [_mutableProviders removeObject:provider];
        provider.manager = nil;
    }
}

- (BOOL)didLaunchingWithOptions:(NSDictionary*)launchOptions {
    for(MobilySocialProvider* provider in _mutableProviders) {
        if([provider didLaunchingWithOptions:launchOptions] == NO) {
            return NO;
        }
    }
    return YES;
}

- (void)didBecomeActive {
    for(MobilySocialProvider* provider in _mutableProviders) {
        [provider didBecomeActive];
    }
}

- (void)willResignActive {
    for(MobilySocialProvider* provider in _mutableProviders) {
        [provider willResignActive];
    }
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    for(MobilySocialProvider* provider in _mutableProviders) {
        if([provider openURL:url sourceApplication:sourceApplication annotation:annotation] == YES) {
            return YES;
        }
    }
    return NO;
}

@end

/*--------------------------------------------------*/
