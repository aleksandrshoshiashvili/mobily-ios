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

#import <MobilyCore/MobilyApiManager.h>

/*--------------------------------------------------*/

@class MobilyApiRequest;
@class MobilyApiResponse;

/*--------------------------------------------------*/

typedef void (^MobilyApiProviderCompleteBlock)(id request, id response);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyApiProvider : NSObject < MobilyObject >

@property(nonatomic, readwrite, weak) MobilyApiManager* manager;
@property(nonatomic, readwrite, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, strong) MobilyCache* cache;

@property(nonatomic, readonly, strong) NSString* name;
@property(nonatomic, readonly, strong) NSURL* url;
@property(nonatomic, readonly, strong) NSDictionary* headers;

- (instancetype)initWithName:(NSString*)name url:(NSURL*)url;
- (instancetype)initWithName:(NSString*)name url:(NSURL*)url headers:(NSDictionary*)headers;

- (void)setup NS_REQUIRES_SUPER;

- (void)sendRequest:(MobilyApiRequest*)request byTarget:(id)target completeSelector:(SEL)completeSelector;
- (void)sendRequest:(MobilyApiRequest*)request byTarget:(id)target completeBlock:(MobilyApiProviderCompleteBlock)completeBlock;
- (void)cancelByRequest:(MobilyApiRequest*)request;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/
