//
//  SFSearchItem.h
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchItem : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *icon;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, copy) void(^itemActionBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
