//
//  refundModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "refundModel.h"

@implementation refundItemsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation refundModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation RefundAfterSalesProcessModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation RefundDetailItemsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation RefundDetailMemosModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation RefundInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation RefundDetailModel
- (NSArray <RefundDetailMemosModel>*)showMemos
{
    return (_memos.count > 3 ? [_memos subarrayWithRange:NSMakeRange(0, 3)]: _memos);
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
