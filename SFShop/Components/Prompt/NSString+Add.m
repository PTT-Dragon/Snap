//
//  NSString+Add.m
//  bookclub
//
//  Created by MasterFly on 2017/5/27.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "NSString+Add.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Add)

/**
 本身的字符数（中英文通用）

 @return 数量
 */
- (int)charNumber{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] ;i++) {
        if (*p) {
            if(*p == '\xe4' || *p == '\xe5' || *p == '\xe6' || *p == '\xe7' || *p == '\xe8' || *p == '\xe9')
            {
                strlength--;
            }
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

/**
 计算字符串出现的次数

 @param occursStr 出现的字符串
 @return 出现的次数
 */
- (NSUInteger)countOfOccursStr:(NSString *)occursStr{
    
    NSInteger strCount = [self length] - [[self stringByReplacingOccurrencesOfString:occursStr withString:@""] length];
    return strCount / [occursStr length];
}

/**
 计算label 的高度（通用 宽默认屏幕-20）
 @param aLabel label
 @return 高度
 */
- (CGFloat)calHeightWithLabel:(UILabel *)aLabel {
    return [self calHeightOrWidth:YES andLabel:aLabel andLimitSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 20, 20000)];
}

/**
 计算label 的宽度（通用 高默认20）
 @param aLabel label
 @return 宽度
 */
- (CGFloat)calWidthWithLabel:(UILabel *)aLabel {
    return [self calHeightOrWidth:NO andLabel:aLabel andLimitSize:CGSizeMake(20000, 20)];
}

/**
 计算label 的高度/宽度（通用 ，带限制size）
 @param aLabel label
 @param aSize 限制size
 @param heightOrWidth YES: height ;NO : Width
 @return 高度
 */
- (CGFloat)calHeightOrWidth:(BOOL)heightOrWidth andLabel:(UILabel *)aLabel andLimitSize:(CGSize )aSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = aLabel.lineBreakMode;
    paragraphStyle.alignment = aLabel.textAlignment;
    
    CGFloat height = [aLabel.text boundingRectWithSize:aSize
                                               options:NSStringDrawingUsesLineFragmentOrigin|
                                                       NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:aLabel.font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
    CGFloat width = [aLabel.text boundingRectWithSize:aSize
                                               options:NSStringDrawingUsesLineFragmentOrigin|
                                                       NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:aLabel.font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.width;
    return  heightOrWidth?height + 5:width + 5;//需要额外添加5
}

/**
 md5加密

 @return NSString
 */
- (NSString *)md5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 遍历一个字符串，返回含有给定标签内的字符串的 所有范围
 
 @param leftStr 左边的标签
 @param rightStr 右边的标签
 @return NSArray<NSRange>
 */
- (NSArray<NSValue *> *)rangeArrWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    NSMutableArray *array = [NSMutableArray array];
    NSRange range = NSMakeRange(0, 0);
    NSInteger i = 0;
    do {
        range = [self rangeWithLeftStr:leftStr rightStr:rightStr beginLoction:range.location apperTimes:i];
        if (range.location <= self.length) {
            [array addObject:[NSValue valueWithRange:range]];
        }
        i ++;
        range.location = range.location + range.length + i * 2;
    } while (range.location < self.length);
    return array;
}

/**
 计算出标签中字符在去掉标签后的位置
 
 @param leftStr 左边的标签
 @param rightStr 右边的标签
 @param location 校验的开始位置
 @param apperTimes 累计出现的次数
 @return 范围 NSRange
 */
- (NSRange)rangeWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr beginLoction:(NSUInteger)location apperTimes:(NSInteger)apperTimes{
    NSRange rangeLeft = [self rangeOfString:leftStr options:NSCaseInsensitiveSearch range:NSMakeRange(location, self.length - location)];
    NSRange rangeRight = [self rangeOfString:rightStr options:NSCaseInsensitiveSearch range:NSMakeRange(location, self.length - location)];
    NSInteger begin = rangeLeft.location - apperTimes * 2;
    NSInteger length = rangeRight.location - rangeLeft.location - 1;
    return NSMakeRange(begin, length);
}

@end

@implementation NSMutableString (Add)

- (NSArray<NSValue *> *)rangeArrWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr removeLabel:(BOOL)isRemoveLabel{
    NSMutableArray *array = [NSMutableArray array];
    NSRange range = NSMakeRange(0, 0);
    NSInteger i = 0;
    do {
        range = [self rangeWithLeftStr:leftStr rightStr:rightStr beginLoction:range.location apperTimes:i];
        if (range.location <= self.length) {
            [array addObject:[NSValue valueWithRange:range]];
        }
        i ++;
        range.location = range.location + range.length + i * 2;
    } while (range.location < self.length);
    if (isRemoveLabel) {
        [self replaceOccurrencesOfString:leftStr withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
        [self replaceOccurrencesOfString:rightStr withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    }
    return array;
}

@end
