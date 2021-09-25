//
//  HomePageModel.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "HomePageModel.h"
@implementation HomePageModel

@end

@implementation LayoutModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"childNodes" : [ChildNode class]};
}

//黑名单
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"test1", @"test2"];
//}

//白名单
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"name"];
//}

@end

@implementation ChildNode
@end


