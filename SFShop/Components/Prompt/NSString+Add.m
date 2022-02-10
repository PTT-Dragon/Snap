//
//  NSString+Add.m
//  bookclub
//
//  Created by MasterFly on 2017/5/27.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "NSString+Add.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking.h>

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


- (CGFloat)calHeightWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)model alignment:(NSTextAlignment)alignment limitSize:(CGSize )aSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = model;
    paragraphStyle.alignment = alignment;
    CGFloat height = [self boundingRectWithSize:aSize
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font,
                                        NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil].size.height;
    return height + 5;//需要额外添加5
}

- (CGFloat)calWidth:(UIFont *)font lineMode:(NSLineBreakMode)lineMode alignment:(NSTextAlignment)alignment limitSize:(CGSize )limitSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineMode;
    paragraphStyle.alignment = alignment;
    CGFloat width = [self boundingRectWithSize:limitSize
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font,
                                        NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil].size.width;
    return width + 5;//需要额外添加5
}

+ (CGFloat)jk_heightTextContent:(NSString *)textContent withSizeFont:(CGFloat)textfont withMaxSize:(CGSize)maxSize {
    UIFont *font = kFontRegular(textfont);
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [textContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSLineBreakByCharWrapping attributes:attrs context:nil].size.height;
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

#define IsStrEmpty(_ref)(( [(_ref) isKindOfClass:[NSNull class]]||(_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]) || ([(_ref) isEqualToString:@""]) )
//转化为千分位格式,例如 :23456789 输出：23,456,789
- (NSString *)thousandthFormat:(NSInteger)decimal {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:self];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;//千分位分割
    formatter.roundingMode = NSNumberFormatterRoundFloor;//保留小数
    formatter.maximumFractionDigits = decimal;//小数保留位
    formatter.minimumFractionDigits = decimal;//小数保留位
    NSString *string = [formatter stringFromNumber:number];
    NSLog(@"numberFormatter == %@",string);
    if(IsStrEmpty(string)) {
        return self;
    }
    return string;
}



#pragma mark - 字符串校验
//校验密码是否符合
- (BOOL)passwordTextCheck
{
    NSInteger alength = [self length];

    BOOL hasUppercase = false;
    BOOL hasLowercas = false;
    BOOL hasNumber = false;
    BOOL hasIllegal = false;
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        if((commitChar>64)&&(commitChar<91)){
            hasUppercase = YES;
            NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
            hasLowercas = YES;
            NSLog(@"字符串中含有小写英文字母");
        }else if((commitChar>47)&&(commitChar<58)){
            hasNumber = YES;
            NSLog(@"字符串中含有数字");
        }else{
            hasIllegal = YES;
            NSLog(@"字符串中含有非法字符");
        }
    }
    return (hasUppercase && hasLowercas && hasNumber && hasIllegal);
}
//校验手机号是否符合
- (BOOL)phoneTextCheck;
{
        if (self.length != 11)
        {
            return NO;
        }
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
         * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
         * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
         * 电信号段: 133,149,153,170,173,177,180,181,189
         */
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
         */
        NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
        /**
         * 中国联通：China Unicom
         * 130,131,132,145,155,156,170,171,175,176,185,186
         */
        NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
        /**
         * 中国电信：China Telecom
         * 133,149,153,170,173,177,180,181,189
         */
        NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
        
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:self] == YES)
            || ([regextestcm evaluateWithObject:self] == YES)
            || ([regextestct evaluateWithObject:self] == YES)
            || ([regextestcu evaluateWithObject:self] == YES))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    return NO;
}
- (BOOL)emailTextCheck
{
    NSString*emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSPredicate*emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return[emailTest evaluateWithObject:self];
}
@end

@implementation NSMutableString (Add)

+ (NSDictionary *)getErrorMessage:(NSError *)error;
{
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString * receive = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    //字符串再生成NSData
    NSData *data = [receive dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dict;
}

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

+ (NSMutableAttributedString *)difereentColorStr:(NSString *)str Color:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    return string;
}
+ (NSMutableAttributedString *)difereentColorStr:(NSString *)str Color:(UIColor *)color changeText:(NSString *)changeText
{
    changeText = changeText ? changeText: @"";
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[[hintString string]rangeOfString:changeText];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    return hintString;
}
+ (NSMutableAttributedString *)difereentFontStr:(NSString *)str font:(UIFont *)font changeText:(NSString *)changeText
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[[hintString string]rangeOfString:changeText];
    [hintString addAttribute:NSFontAttributeName value:font range:range1];
    return hintString;
}
+ (NSMutableAttributedString *)difereentAttr:(NSDictionary *)attrDic str:(NSString *)str changeText:(NSString *)changeText
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[[hintString string]rangeOfString:changeText];
    [hintString addAttributes:attrDic range:range1];
    return hintString;
}
+(NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring color:(UIColor *)color{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSString * copyTotalString = totalString;
    NSMutableString * replaceString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < substring.length; i ++) {
        [replaceString appendString:@" "];
    }
    while ([copyTotalString rangeOfString:substring].location != NSNotFound) {
        NSRange range = [copyTotalString rangeOfString:substring];
        //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
    }
    return attributedString;
}





@end
