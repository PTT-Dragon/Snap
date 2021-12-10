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
@end
@implementation MessageContactModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
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


