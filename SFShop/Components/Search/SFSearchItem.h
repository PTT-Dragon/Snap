//
//  SFSearchItem.h
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import "SFSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchItem : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *icon;
@property (nonatomic, readwrite, copy) void(^itemActionBlock)(SFSearchModel * _Nullable model);

@end

NS_ASSUME_NONNULL_END
