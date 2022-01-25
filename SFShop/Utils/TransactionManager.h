//
//  TransactionManager.h
//  SFShop
//
//  Created by YouHui on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TransactionItemBlock)(id obj);

@interface TransactionManager : NSObject

/// 添加事务
/// @param item 事务
/// @return 事物id
+ (nullable NSString *)addItem:(TransactionItemBlock)item;

/// 移除事务
/// @param itemId 事务id
+ (void)removeItemWithId:(NSString *)itemId;

/// 触发队列事务
/// @param obj 触发事务的参数，会传递给事务
+ (void)trigger:(id)obj;
/// @param itemId 事务id
+ (void)triggerWithId:(NSString *)itemId obj:(id)obj;
/// @param itemIds 事务id 数组
+ (void)triggerWithIds:(NSArray *)itemIds obj:(id)obj;

/// 触发队列事物（不会清除队列里面的事务）
/// @param obj 触发事务的参数，会传递给事务
+ (void)triggerWithoutClear:(id)obj;
/// @param itemId 事务id
+ (void)triggerWithoutClearWithId:(NSString *)itemId obj:(id)obj;
/// @param itemIds 事务id 数组
+ (void)triggerWithoutClearWithIds:(NSArray *)itemIds obj:(id)obj;

@end

NS_ASSUME_NONNULL_END
