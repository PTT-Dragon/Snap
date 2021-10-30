//
//  SFSearchModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import "SFSearchModel.h"

@implementation SFSearchModel

+ (instancetype)historyModelWithName:(NSString *)name {
    SFSearchModel *model = [[SFSearchModel alloc] init];
    model.name = name;
    model.sectionTitle = @"Search Discovery";
    model.sectionIcon = @"search_clear";
    model.type = SFSearchHeadTypeDelete;
    model.width = 0;
    return model;
}

@end
