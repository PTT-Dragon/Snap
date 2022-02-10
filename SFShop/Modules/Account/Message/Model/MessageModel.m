//
//  MessageModel.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "MessageModel.h"

@implementation MessageUnreadModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (NSMutableAttributedString *)messageSttrStr
{
    NSString* htmlString = self.message;

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

//加载html片段
+ (NSAttributedString *)attrHtmlStringFrom:(NSString *)str {
        
    str = [NSString stringWithFormat:@"<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /> <body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:14; color:#333333; \">%@</body></html>",str];
            
    NSAttributedString *attrStr=  [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    return attrStr;
}

@end
@implementation MessageContactModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (NSMutableAttributedString *)contentSttrStr
{
    NSString* htmlString = self.content;

    if (htmlString.length != 0) {
        htmlString = [NSString stringWithFormat:@"<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /> <body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:16px;font-weight:medium; color:#000000; \">%@</body></html>",htmlString];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:kFontRegular(14)} documentAttributes:nil error:nil];
    return attrStr;
}

@end

@implementation MessageModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation MessageStoreModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation MessageProductModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation MessageOrderListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end


