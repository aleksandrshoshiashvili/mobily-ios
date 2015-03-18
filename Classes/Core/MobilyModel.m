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

#import "MobilyModel.h"
#import "MobilyModelJson.h"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModel ()

@property(nonatomic, readwrite, weak) NSArray* compareMap;
@property(nonatomic, readwrite, weak) NSArray* serializeMap;
@property(nonatomic, readwrite, weak) NSDictionary* jsonMap;

+ (NSArray*)arrayMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector;
+ (NSDictionary*)dictionaryMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector;
+ (NSArray*)buildCompareMap;
+ (NSArray*)buildSerializeMap;
+ (NSDictionary*)buildJsonMap;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelCollection ()

@property(nonatomic, readwrite, strong) NSString* filePath;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeModels;
@property(nonatomic, readwrite, assign) BOOL flagLoad;

- (void)loadIsNeed;
- (void)load;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelQuery () {
    NSMutableArray* _unsafeModels;
}

@property(nonatomic, readwrite, weak) MobilyModelCollection* collection;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeModels;
@property(nonatomic, readwrite, assign) BOOL flagReload;
@property(nonatomic, readwrite, assign) BOOL flagResort;

- (void)reload;
- (void)resort;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModel

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        for(NSString* field in self.serializeMap) {
            id value = [coder decodeObjectForKey:field];
            if(value != nil) {
                [self setValue:value forKey:field];
            }
        }
        [self setup];
    }
    return self;
}

- (instancetype)initWithJson:(id)json {
    self = [super init];
    if(self != nil) {
        [self fromJson:json];
        [self setup];
    }
    return self;
}

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        self.userDefaultsKey = userDefaultsKey;
        [self load];
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.userDefaultsKey = nil;
    self.serializeMap = nil;
    self.jsonMap = nil;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    BOOL result = NO;
    if(([object isKindOfClass:self.class] == YES) && (self.serializeMap.count > 0)) {
        result = YES;
        for(NSString* field in self.serializeMap) {
            id value1 = [self valueForKey:field];
            id value2 = [object valueForKey:field];
            if(value1 != value2) {
                if([value1 isEqual:value2] == NO) {
                    result = NO;
                    break;
                }
            }
        }
    } else {
        result = [super isEqual:object];
    }
    return result;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)coder {
    for(NSString* field in self.serializeMap) {
        id value = [self valueForKey:field];
        if(value != nil) {
            [coder encodeObject:value forKey:field];
        }
    }
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    MobilyModel* result = [[self.class allocWithZone:zone] init];
    if(result != nil) {
        result.serializeMap = self.serializeMap;
        result.jsonMap = self.jsonMap;
        result.userDefaultsKey = self.userDefaultsKey;
        
        for(NSString* field in self.serializeMap) {
            [result setValue:[[self valueForKey:field] copyWithZone:zone] forKey:field];
        }
    }
    return result;
}

#pragma mark Debug

- (NSString*)description {
    NSMutableArray* result = NSMutableArray.array;
    for(NSString* field in self.serializeMap) {
        [result addObject:[NSString stringWithFormat:@"%@ = %@", field, [self valueForKey:field]]];
    }
    return [result componentsJoinedByString:@"; "];
}

#pragma mark Property

- (NSArray*)compareMap {
    if(_compareMap == nil) {
        self.compareMap = [self.class buildCompareMap];
    }
    return _compareMap;
}

- (NSArray*)serializeMap {
    if(_serializeMap == nil) {
        self.serializeMap = [self.class buildSerializeMap];
    }
    return _serializeMap;
}

- (NSDictionary*)jsonMap {
    if(_jsonMap == nil) {
        self.jsonMap = [self.class buildJsonMap];
    }
    return _jsonMap;
}

#pragma mark Public

+ (NSArray*)compareMap {
    return nil;
}

+ (NSArray*)serializeMap {
    return nil;
}

+ (NSDictionary*)jsonMap {
    return nil;
}

- (void)fromJson:(id)json {
    [self.jsonMap enumerateKeysAndObjectsUsingBlock:^(NSString* field, MobilyModelJson* converter, BOOL* stop __unused) {
        id value = [converter parseJson:json];
        if(value != nil) {
            [self setValue:value forKey:field];
        }
    }];
}

- (void)clear {
    for(NSString* field in self.serializeMap) {
        @try {
            [self setValue:nil forKey:field];
        }
        @catch(NSException *exception) {
        }
    }
}

- (void)clearComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self clear];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

- (BOOL)save {
    @try {
        NSMutableDictionary* dict = NSMutableDictionary.dictionary;
        if(dict != nil) {
            for(NSString* field in self.serializeMap) {
                @try {
                    id value = [self valueForKey:field];
                    if(value != nil) {
                        NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:value];
                        if(archive != nil) {
                            dict[field] = archive;
                        }
                    }
                }
                @catch (NSException* exception) {
                    NSLog(@"MobilyModel::saveItem:%@ Exception = %@ Field=%@", _userDefaultsKey, exception, field);
                }
            }
            [NSUserDefaults.standardUserDefaults setObject:dict forKey:_userDefaultsKey];
            return [NSUserDefaults.standardUserDefaults synchronize];
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyModel::saveItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
    return NO;
}

- (void)saveSuccess:(MobilyModelBlock)success failure:(MobilyModelBlock)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if([self save] == YES) {
            if(success != nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    success();
                });
            }
        } else {
            if(failure != nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure();
                });
            }
        }
    });
}

- (void)load {
    @try {
        NSDictionary* dict = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
        if(dict != nil) {
            for(NSString* field in self.serializeMap) {
                id value = dict[field];
                if(value != nil) {
                    if([value isKindOfClass:NSData.class] == YES) {
                        id unarchive = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                        if(unarchive != nil) {
                            @try {
                                [self setValue:unarchive forKey:field];
                            }
                            @catch(NSException *exception) {
                            }
                        }
                    }
                }
            }
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyModel::loadItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
}

- (void)loadComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self load];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

- (void)erase {
    NSDictionary* dict = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
    if(dict != nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:_userDefaultsKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

- (void)eraseComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self erase];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

#pragma mark Private

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (NSArray*)arrayMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector {
    NSString* className = NSStringFromClass(class);
    NSMutableArray* map = cache[className];
    if(map == nil) {
        map = NSMutableArray.array;
        while(class != nil) {
            if([class respondsToSelector:selector] == YES) {
                NSArray* mapPart = [class performSelector:selector];
                if([mapPart isKindOfClass:NSArray.class] == YES) {
                    [map addObjectsFromArray:mapPart];
                }
            }
            class = [class superclass];
        }
        cache[className] = map;
    }
    return map;
}

+ (NSDictionary*)dictionaryMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector {
    NSString* className = NSStringFromClass(class);
    NSMutableDictionary* map = cache[className];
    if(map == nil) {
        map = NSMutableDictionary.dictionary;
        while(class != nil) {
            if([class respondsToSelector:selector] == YES) {
                NSDictionary* mapPart = [class performSelector:selector];
                if([mapPart isKindOfClass:NSDictionary.class] == YES) {
                    [map addEntriesFromDictionary:mapPart];
                }
            }
            class = [class superclass];
        }
        cache[className] = map;
    }
    return map;
}

#pragma clang diagnostic pop

+ (NSArray*)buildCompareMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self arrayMap:cache class:self.class selector:@selector(compareMap)];
}

+ (NSArray*)buildSerializeMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self arrayMap:cache class:self.class selector:@selector(serializeMap)];
}

+ (NSDictionary*)buildJsonMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self dictionaryMap:cache class:self.class selector:@selector(jsonMap)];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_STORAGE_COLLECTION_EXTENSION         @"collection"

/*--------------------------------------------------*/

@implementation MobilyModelCollection

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.unsafeModels = NSMutableArray.array;
        self.flagLoad = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        id items = [coder decodeObjectForKey:@"items"];
        if(items != nil) {
            self.unsafeModels = items;
        } else {
            self.unsafeModels = NSMutableArray.array;
        }
        self.flagLoad = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        self.userDefaultsKey = userDefaultsKey;
        self.unsafeModels = NSMutableArray.array;
        self.flagLoad = YES;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString*)fileName {
    self = [super init];
    if(self != nil) {
        NSString* fileGroup = MobilyStorage.fileSystemDirectory;
        if(fileGroup != nil) {
            NSString* filePath = [fileGroup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, MOBILY_STORAGE_COLLECTION_EXTENSION]];
            if(filePath != nil) {
                self.fileName = fileName;
                self.filePath = filePath;
                self.unsafeModels = NSMutableArray.array;
                self.flagLoad = YES;
                [self setup];
            } else {
                self = nil;
            }
        } else {
            self = nil;
        }
    }
    return self;
}

- (instancetype)initWithJson:(id)json storageItemClass:(Class)storageItemClass {
    self = [super init];
    if(self != nil) {
        self.unsafeModels = NSMutableArray.array;
        self.flagLoad = NO;
        [self fromJson:json modelClass:storageItemClass];
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.fileName = nil;
    self.userDefaultsKey = nil;
    self.filePath = nil;
    self.unsafeModels = nil;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)coder {
    [self loadIsNeed];
    [coder encodeObject:_unsafeModels forKey:@"items"];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    MobilyModelCollection* result = [[self.class allocWithZone:zone] init];
    if(result != nil) {
        result.filePath = self.filePath;
        result.userDefaultsKey = self.userDefaultsKey;
        result.unsafeModels = [self.unsafeModels copyWithZone:zone];
        result.flagLoad = self.flagLoad;
    }
    return result;
}

#pragma mark Property

- (void)setFileName:(NSString*)fileName {
    if(_fileName != fileName) {
        _fileName = fileName;
        if(_fileName != nil) {
            self.filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_STORAGE_COLLECTION_EXTENSION]];
        } else {
            self.filePath = nil;
        }
    }
}

- (void)setUserDefaultsKey:(NSString*)userDefaultsKey {
    if(_userDefaultsKey != userDefaultsKey) {
        _userDefaultsKey = userDefaultsKey;
    }
}

- (void)setModels:(NSArray*)items {
    self.flagLoad = NO;
    _unsafeModels.array = items;
}

- (NSArray*)models {
    [self loadIsNeed];
    return [_unsafeModels copy];
}

#pragma mark Public

- (void)fromJson:(id)json modelClass:(Class)storageItemClass {
    [_unsafeModels removeAllObjects];
    if([storageItemClass isSubclassOfClass:MobilyModel.class] == YES) {
        if([json isKindOfClass:NSArray.class] == YES) {
            for(id jsonItem in json) {
                id item = [[storageItemClass alloc] initWithJson:jsonItem];
                if(item != nil) {
                    [_unsafeModels addObject:item];
                }
            }
        }
    }
}

- (NSUInteger)count {
    [self loadIsNeed];
    return _unsafeModels.count;
}

- (id)modelAtIndex:(NSUInteger)index {
    [self loadIsNeed];
    return _unsafeModels[index];
}

- (id)firstModel {
    [self loadIsNeed];
    if(_unsafeModels.count > 0) {
        return _unsafeModels[0];
    }
    return nil;
}

- (id)lastModel {
    return [_unsafeModels lastObject];
}

- (void)prependModel:(MobilyModel*)item {
    [self loadIsNeed];
    [_unsafeModels insertObject:item atIndex:0];
}

- (void)prependModelsFromArray:(NSArray*)items {
    [self loadIsNeed];
    [_unsafeModels insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)]];
}

- (void)appendModel:(MobilyModel*)item {
    [self loadIsNeed];
    [_unsafeModels addObject:item];
}

- (void)appendModelsFromArray:(NSArray*)items {
    [self loadIsNeed];
    [_unsafeModels addObjectsFromArray:items];
}

- (void)insertModel:(MobilyModel*)item atIndex:(NSUInteger)index {
    [self loadIsNeed];
    [_unsafeModels insertObject:item atIndex:index];
}

- (void)insertModelsFromArray:(NSArray*)items atIndex:(NSUInteger)index {
    [self loadIsNeed];
    [_unsafeModels insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, items.count)]];
}

- (void)removeModel:(MobilyModel*)item {
    [self loadIsNeed];
    [_unsafeModels removeObject:item];
}

- (void)removeModelsInArray:(NSArray*)items {
    [self loadIsNeed];
    [_unsafeModels removeObjectsInArray:items];
}

- (void)removeAllModels {
    [self loadIsNeed];
    [_unsafeModels removeAllObjects];
}

- (void)enumirateModelsUsingBlock:(MobilyModelCollectionEnumBlock)block {
    [self loadIsNeed];
    [_unsafeModels enumerateObjectsUsingBlock:^(id item, NSUInteger index __unused, BOOL* stop) {
        block(item, stop);
    }];
}

- (BOOL)save {
    @try {
        if(_flagLoad == NO) {
            if(_userDefaultsKey.length > 0) {
                NSData* data = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
                if([data isKindOfClass:NSData.class] == YES) {
                    id items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if([items isKindOfClass:NSArray.class] == YES) {
                        _unsafeModels.array = items;
                    } else {
                        [_unsafeModels removeAllObjects];
                    }
                }
            } else if(_filePath.length > 0) {
                return [NSKeyedArchiver archiveRootObject:_unsafeModels toFile:_filePath];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"ERROR: [%@:%@]: Exception = %@", self.class, NSStringFromSelector(_cmd), exception);
#endif
    }
    return NO;
}

#pragma mark Private

- (NSMutableArray*)safeItems {
    [self loadIsNeed];
    return _unsafeModels;
}

- (void)loadIsNeed {
    if(_flagLoad == YES) {
        [self load];
        _flagLoad = NO;
    }
}

- (void)load {
    @try {
        if(_userDefaultsKey.length > 0) {
            NSData* data = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
            if([data isKindOfClass:NSData.class] == YES) {
                id items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if([items isKindOfClass:NSArray.class] == YES) {
                    _unsafeModels.array = items;
                } else {
                    [_unsafeModels removeAllObjects];
                }
            }
        } else if(_filePath.length > 0) {
            id items = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if([items isKindOfClass:NSArray.class] == YES) {
                _unsafeModels.array = items;
            } else {
                [_unsafeModels removeAllObjects];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"ERROR: [%@:%@]: Exception = %@", self.class, NSStringFromSelector(_cmd), exception);
#endif
        [_unsafeModels removeAllObjects];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelQuery : NSObject

#pragma mark Init / Free

- (instancetype)initWithCollection:(MobilyModelCollection*)collection {
    self = [super init];
    if(self != nil) {
        self.collection = collection;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.unsafeModels = NSMutableArray.array;
    self.flagReload = YES;
    self.flagResort = YES;
}

- (void)dealloc {
    self.collection = nil;
    self.unsafeModels = nil;
    self.reloadBlock = nil;
    self.resortBlock = nil;
}

#pragma mark Public

- (void)setNeedReload {
    _flagReload = YES;
    _flagResort = YES;
}

- (void)setNeedResort {
    _flagReload = YES;
}

- (NSUInteger)count {
    return [[self models] count];
}

- (id)modelAtIndex:(NSUInteger)index {
    return [self models][index];
}

- (NSArray*)models {
    if(_flagReload == YES) {
        [self reload];
        _flagReload = NO;
    }
    if(_flagResort == YES) {
        [self resort];
        _flagResort = NO;
    }
    return _unsafeModels;
}

#pragma mark Property

- (void)setReloadBlock:(MobilyModelQueryReloadBlock)reloadBlock {
    if(_reloadBlock != reloadBlock) {
        _reloadBlock = [reloadBlock copy];
        _flagReload = YES;
        _flagResort = YES;
    }
}

- (void)setResortBlock:(MobilyModelQueryResortBlock)resortBlock {
    if(_resortBlock != resortBlock) {
        _resortBlock = [resortBlock copy];
        _flagResort = YES;
    }
}

- (void)setResortInvert:(BOOL)resortInvert {
    if(_resortInvert != resortInvert) {
        _resortInvert = resortInvert;
        _flagResort = YES;
    }
}

#pragma mark Private

- (void)reload {
    if([_delegate respondsToSelector:@selector(modelQuery:reloadItem:)] == YES) {
        [_unsafeModels removeAllObjects];
        for(id item in _collection.safeItems) {
            if([_delegate modelQuery:self reloadItem:item] == YES) {
                [_unsafeModels addObject:item];
            }
        }
    } else if(_reloadBlock != nil) {
        [_unsafeModels removeAllObjects];
        for(id item in _collection.safeItems) {
            if(_reloadBlock(item) == YES) {
                [_unsafeModels addObject:item];
            }
        }
    } else {
        _unsafeModels.array = _collection.safeItems;
    }
}

- (void)resort {
    if(_resortInvert == YES) {
        if([_delegate respondsToSelector:@selector(modelQuery:resortItem1:item2:)] == YES) {
            [_unsafeModels sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch(_resortBlock(item1, item2)) {
                    case MobilyModelQuerySortResultMore: return NSOrderedDescending;
                    case MobilyModelQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        } else if(_resortBlock != nil) {
            [_unsafeModels sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch([_delegate modelQuery:self resortItem1:item1 item2:item2]) {
                    case MobilyModelQuerySortResultMore: return NSOrderedDescending;
                    case MobilyModelQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        }
    } else {
        if([_delegate respondsToSelector:@selector(modelQuery:resortItem1:item2:)] == YES) {
            [_unsafeModels sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)_resortBlock(item1, item2);
            }];
        } else if(_resortBlock != nil) {
            [_unsafeModels sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)[_delegate modelQuery:self resortItem1:item1 item2:item2];
            }];
        }
    }
}

@end

/*--------------------------------------------------*/
