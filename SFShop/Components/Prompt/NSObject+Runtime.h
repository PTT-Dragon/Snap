//
//  NSObject+Runtime.h
//  SFShop
//
//  Created by YouHui on 2022/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)

/// 返回当前类的所有属性
- (NSArray *)lz_getProperties;

/// 返回属性的类型数组
- (NSArray *)lz_getPropertieClasses;

/// 初始化所有属性（new 对象）
- (void)lz_initProperties;

/// 初始化所有属性
- (void)lz_copyModel:(id)model;
@end

NS_ASSUME_NONNULL_END
