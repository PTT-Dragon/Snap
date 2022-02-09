//
//  CartModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "CartModel.h"

@implementation ProdSpcAttrsModel

@end

@implementation CartItemModel
- (NSString *)cutRateStr
{
    if ([_cutRate rangeOfString:@"-"].location != NSNotFound) {
        _cutRate = [_cutRate stringByReplacingOccurrencesOfString:@"" withString:@""];
    }
    return _cutRate;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CartListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CampaignsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CartCampaignsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CartModel
-(id)copyWithZone:(NSZone *)zone{
           id objCopy = [[[self class] allocWithZone:zone] init];
            unsigned int count = 0;
            objc_property_t *properties = class_copyPropertyList([self class], &count);
            for (int i = 0; i<count; i++) {
                 objc_property_t property = properties[i];
                 const char *name = property_getName(property);
                 NSString *propertyName = [NSString stringWithUTF8String:name];
                 id value = [self valueForKey:propertyName];
                 if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
                       id valueCopy  = [[NSArray alloc]initWithArray:value copyItems:YES];
                        [objCopy setValue:valueCopy forKey:propertyName];
                  }else if (value) {
                          [objCopy setValue:[value copy] forKey:propertyName];
                  }
             }
             free(properties);
            return objCopy;
         }

         -(id)mutableCopyWithZone:(NSZone *)zone{
               id objCopy = [[[self class] allocWithZone:zone] init];
              unsigned int count = 0;
              objc_property_t *properties = class_copyPropertyList([self class], &count);
              for (int i = 0; i<count; i++) {
                    objc_property_t property = properties[i];
                    const char *name = property_getName(property);
                     NSString *propertyName = [NSString stringWithUTF8String:name];
                     id value = [self valueForKey:propertyName];
                    if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
                        id valueCopy  = [[NSMutableArray alloc]initWithArray:value copyItems:YES];
                        [objCopy setValue:valueCopy forKey:propertyName];
                     }else if(value){
                           [objCopy setValue:[value copy] forKey:propertyName];
                    }
               }
                     free(properties);
                 return objCopy;
      }
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation LocalCartModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation CartNumModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

