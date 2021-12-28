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
//转化为千分位格式,例如 :23456789 输出：23,456,789
- (NSString *)thousandthFormat;

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


/// 计算高度
/// @param font 字体
/// @param model 分割模式
/// @param alignment NSTextAlignment
/// @param aSize 大小
- (CGFloat)calHeightWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)model alignment:(NSTextAlignment)alignment limitSize:(CGSize )aSize;

/// 计算宽度
/// @param font 字体
/// @param lineMode 分割模式
/// @param alignment NSTextAlignment
/// @param limitSize 限制大小
- (CGFloat)calWidth:(UIFont *)font lineMode:(NSLineBreakMode)lineMode alignment:(NSTextAlignment)alignment limitSize:(CGSize )limitSize;
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


#pragma mark - 字符串校验
//校验密码是否符合
- (BOOL)passwordTextCheck;
//校验手机号是否符合
- (BOOL)phoneTextCheck;
//校验邮箱是否符合
- (BOOL)emailTextCheck;


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

+ (NSDictionary *)getErrorMessage:(NSError *)error;


//字符串不同颜色
+ (NSMutableAttributedString *)difereentColorStr:(NSString *)str Color:(UIColor *)color range:(NSRange)range;
+ (NSMutableAttributedString *)difereentColorStr:(NSString *)str Color:(UIColor *)color changeText:(NSString *)changeText;
+ (NSMutableAttributedString *)difereentFontStr:(NSString *)str font:(UIFont *)font changeText:(NSString *)changeText;
+ (NSMutableAttributedString *)difereentAttr:(NSDictionary *)attrDic str:(NSString *)str changeText:(NSString *)changeText;
+(NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring color:(UIColor *)color;




@end
