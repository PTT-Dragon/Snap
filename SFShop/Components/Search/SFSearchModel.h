//
//  SFSearchModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SFSearchHeadType) {
    SFSearchHeadTypeNormal, //正常
    SFSearchHeadTypeDelete, //删除按钮
};

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchModel : NSObject

@property (nonatomic, readwrite, strong) NSString *sectionIcon;
@property (nonatomic, readwrite, strong) NSString *sectionTitle;
@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, assign) SFSearchHeadType type;
@property (nonatomic, readwrite, assign) CGFloat width;

/// 初始化搜素历史model
/// @param name 搜索内容
+ (instancetype)historyModelWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
