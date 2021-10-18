//
//  NSString+Add.h
//  bookclub
//
//  Created by MasterFly on 2017/5/27.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Add)

/**
 计算字符出现的次数
 
 @param occursStr 出现的字符
 @return 出现的次数
 */
- (NSUInteger )countOfOccursStr:(NSString *)occursStr;


/**
 本身的字符数（中英文通用）
 
 @return 数量
 */
- (int)charNumber;


/**
 计算label 的高度（通用 宽默认屏幕-20）
 @param aLabel label
 @return 高度
 */
- (CGFloat)calHeightWithLabel:(UILabel *)aLabel;


/**
 计算label 的宽度（通用 高默认20）
 @param aLabel label
 @return 宽度
 */
- (CGFloat)calWidthWithLabel:(UILabel *)aLabel;


/**
 计算label 的高度/宽度（通用 ，带限制size）
 @param aLabel label
 @param aSize 限制size
 @param heightOrWidth YES: height ;NO : Width
 @return 高度
 */
- (CGFloat)calHeightOrWidth:(BOOL)heightOrWidth andLabel:(UILabel *)aLabel andLimitSize:(CGSize )aSize;


/**
 获取md5加密字符串

 @return NSString
 */
- (NSString *)md5String;


/**
 遍历一个字符串，返回含有给定标签内的字符串的 所有范围
 
 @param leftStr 左边的标签
 @param rightStr 右边的标签
 @return NSArray<NSRange>
 */
- (NSArray<NSValue *> *)rangeArrWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr;
@end

@interface NSMutableString (Add)
/**
 遍历一个字符串，返回含有给定标签内的字符串的 所有范围 (会自动删除传入的标签)
 
 @param leftStr 左边的标签
 @param rightStr 右边的标签
 @param isRemoveLabel 是否删除左右两边的标签
 @return NSArray<NSRange>
 */
- (NSArray<NSValue *> *)rangeArrWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr removeLabel:(BOOL)isRemoveLabel;
@end