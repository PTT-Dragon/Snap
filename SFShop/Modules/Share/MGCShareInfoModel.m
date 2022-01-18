//
//  MGCShareInfoModel.m
//  MiguDMShare
//
//  Created by 陆锋 on 2021/5/7.
//

#import "MGCShareInfoModel.h"

@implementation MGCShareInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cyOpenInfo" : [MGCShareCyOpenInfoModel class],@"cardInfo" : [MGCCardInfo class]};
}

@end

@implementation MGCCardInfo

@end

@implementation MGCShareCyOpenInfoModel


@end

