//
//  TransactionManager.m
//  SFShop
//
//  Created by YouHui on 2022/1/25.
//

#import "TransactionManager.h"


@interface TransactionManager ()
@property (nonatomic, readwrite, strong) NSMapTable *mapTable;
@end
@implementation TransactionManager

static TransactionManager *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TransactionManager alloc] init];
    });
    return _instance;
}

/// 添加事务
/// @param item 事务
/// @return 事物id
+ (nullable NSString *)addItem:(TransactionItemBlock)item {
    if (!item) {return nil;}
    NSString *itemId = [TransactionManager.shareInstance createItemId];
    [TransactionManager.shareInstance.mapTable setObject:item forKey:itemId];
    return itemId;
}

/// 移除事务
/// @param itemId 事务id
+ (void)removeItemWithId:(NSString *)itemId {
    if (!itemId.length) {return;}
    [TransactionManager.shareInstance.mapTable setObject:nil forKey:itemId];
}

#pragma mark - 会清除队列里面的事务
/// 触发队列事务
+ (void)trigger:(id)obj {
    [self triggerWithIds:TransactionManager.shareInstance.mapTable.keyEnumerator.allObjects obj:obj];
}
/// @param itemIds 事务id 数组
+ (void)triggerWithIds:(NSArray *)itemIds obj:(nonnull id)obj {
    if (!itemIds || !itemIds.count) {return;}
    for (NSString *itemId in itemIds) {
        [self triggerWithId:itemId obj:obj];
    }
}
/// @param itemId 事务id
+ (void)triggerWithId:(NSString *)itemId obj:(nonnull id)obj {
    if (!itemId.length) {return;}
    TransactionItemBlock item = [TransactionManager.shareInstance.mapTable objectForKey:itemId];
    !item ?: item(obj);
    [TransactionManager removeItemWithId:itemId];
}


#pragma mark - 不会清除队列里面的事务
/// 触发队列事物
+ (void)triggerWithoutClear:(id)obj {
    [self triggerWithoutClearWithIds:TransactionManager.shareInstance.mapTable.keyEnumerator.allObjects obj:obj];
}

/// @param itemIds 事务id 数组
+ (void)triggerWithoutClearWithIds:(NSArray *)itemIds obj:(nonnull id)obj {
    if (!itemIds || !itemIds.count) {return;}
    for (NSString *itemId in itemIds) {
        [self triggerWithoutClearWithId:itemId obj:obj];
    }
}

/// @param itemId 事务id
+ (void)triggerWithoutClearWithId:(NSString *)itemId obj:(nonnull id)obj {
    if (!itemId.length) {return;}
    TransactionItemBlock item = [TransactionManager.shareInstance.mapTable objectForKey:itemId];
    !item ?: item(obj);
}

#pragma mark - Getter
- (NSMapTable *)mapTable {
    if (_mapTable == nil) {
        _mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return _mapTable;
}

- (NSString *)createItemId {
    static long long i = 1;
    NSString *itemIdStr = @"SFItemId";
    return [NSString stringWithFormat:@"%@_%lld",itemIdStr,i++];
}

@end
