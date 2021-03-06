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

#import <MobilyCore/MobilyTaskManager.h>

/*--------------------------------------------------*/

@interface MobilyTaskManager () {
    NSOperationQueue* _queueManager;
    UIBackgroundTaskIdentifier _backgroundTaskId;
    NSUInteger _updateCount;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@class MobilyTaskOperation;

/*--------------------------------------------------*/

@interface MobilyTask () {
    __weak MobilyTaskManager* _taskManager;
    __weak MobilyTaskOperation* _taskOperation;
    BOOL _needRework;
}

@property(nonatomic, readwrite, weak) MobilyTaskOperation* taskOperation;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyTaskOperation : NSOperation {
    __weak MobilyTaskManager* _taskManager;
    MobilyTask* _task;
}

@property(nonatomic, readonly, strong) MobilyTask* task;

- (instancetype)initWithTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskManager

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _queueManager = [NSOperationQueue new];
        _backgroundTaskId = UIBackgroundTaskInvalid;
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Public

- (void)setMaxConcurrentTask:(NSUInteger)maxConcurrentTask {
    [self updating];
    _queueManager.maxConcurrentOperationCount = maxConcurrentTask;
    [self updated];
}

- (NSUInteger)maxConcurrentTask {
    return [_queueManager maxConcurrentOperationCount];
}

- (void)addTask:(MobilyTask*)task {
    [self addTask:task priority:MobilyTaskPriorityNormal];
}

- (void)addTask:(MobilyTask*)task priority:(MobilyTaskPriority)priority {
    [self updating];
    MobilyTaskOperation* operation = [[MobilyTaskOperation alloc] initWithTaskManager:self task:task];
    if(operation != nil) {
        operation.queuePriority = (NSOperationQueuePriority)priority;
        [_queueManager addOperation:operation];
    }
    [self updated];
}

- (void)cancelTask:(MobilyTask*)task {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger index __unused, BOOL* stop) {
        if([task isEqual:operation.task] == YES) {
            [operation cancel];
            *stop = YES;
        }
    }];
    [self updated];
}

- (void)cancelAllTasks {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger index __unused, BOOL* stop __unused) {
        [operation cancel];
    }];
    [self updated];
}

- (void)enumirateTasksUsingBlock:(MobilyTaskManagerEnumBlock)block {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger index __unused, BOOL* stop) {
        block(operation.task, stop);
    }];
    [self updated];
}

- (NSArray*)tasks {
    NSMutableArray* result = NSMutableArray.array;
    if(result != nil) {
        [self updating];
        [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger index __unused, BOOL* stop __unused) {
            [result addObject:operation.task];
        }];
        [self updated];
    }
    return [result copy];
}

- (NSUInteger)countTasks {
    [self updating];
    NSUInteger result = _queueManager.operationCount;
    [self updated];
    return result;
}

- (void)updating {
    if(_updateCount == 0) {
        _queueManager.suspended = YES;
    }
    _updateCount++;
}

- (void)updated {
    if(_updateCount == 1) {
        _queueManager.suspended = NO;
    }
    _updateCount--;
}

- (void)wait {
    [_queueManager waitUntilAllOperationsAreFinished];
}

- (void)startBackgroundSession {
    if(_backgroundTaskId == UIBackgroundTaskInvalid) {
        _backgroundTaskId = [UIApplication.sharedApplication beginBackgroundTaskWithExpirationHandler:^{
            [self cancelAllTasks];
            [self stopBackgroundSession];
        }];
    }
}

- (void)stopBackgroundSession {
    if(_backgroundTaskId != UIBackgroundTaskInvalid) {
        [UIApplication.sharedApplication endBackgroundTask:_backgroundTaskId];
        _backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTask

#pragma mark Synthesize

@synthesize taskOperation = _taskOperation;
@synthesize needRework = _needRework;

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

#pragma mark Public

- (BOOL)isCanceled {
    return [_taskOperation isCancelled];
}

- (void)setNeedRework {
    _needRework = YES;
}

- (BOOL)willStart {
    return YES;
}

- (void)working {
    _needRework = NO;
}

- (void)didComplete {
}

- (void)didCancel {
}

- (void)cancel {
    if(_taskOperation != nil) {
        [_taskOperation cancel];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskOperation

#pragma mark Synthesize

@synthesize task = _task;

#pragma mark Init / Free

- (instancetype)initWithTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task {
    self = [super init];
    if(self != nil) {
        _taskManager = taskManager;
        _task = task;
        
        _task.taskOperation = self;
        
        self.completionBlock = ^{
            if([task isCanceled] == YES) {
                @autoreleasepool {
                    [task didCancel];
                }
            } else {
                @autoreleasepool {
                    [task didComplete];
                }
            }
            task.taskOperation = nil;
        };
    }
    return self;
}

#pragma mark NSOperation

- (void)main {
    if(_task != nil) {
        if([_task willStart] == NO) {
            [self cancel];
            return;
        }
        while([self isCancelled] == NO) {
            @autoreleasepool {
                [_task working];
            }
            if([_task isNeedRework] == YES) {
                [NSThread sleepForTimeInterval:0.01];
            } else {
                break;
            }
        }
    }
}

- (void)cancel {
    [super cancel];
    
    _task.taskOperation = nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskHttpQuery

#pragma mark MobilyTask

@synthesize httpQuery = _httpQuery;

#pragma mark MobilyTask

- (BOOL)willStart {
    if([super willStart] == YES) {
        return (_httpQuery != nil);
    }
    return NO;
}

- (void)working {
    [super working];
    [_httpQuery start];
}

- (void)cancel {
    [_httpQuery cancel];
    [super cancel];
}

@end

/*--------------------------------------------------*/
