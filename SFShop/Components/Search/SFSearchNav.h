//
//  SFSearchNav.h
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "SFSearchItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SFSearchType) {
    SFSearchTypeImmersion,     //沉浸模式 (默认)
    SFSearchTypeNoneInterface, //无界面模式
    SFSearchTypeFake,          //假搜索条模式
};

@interface SFSearchNav : UIView

/// 初始化
/// @param frame frame
/// @param bitem 返回item
/// @param rItem 右上角item
/// @param searchBlock 点击具体内容回调
- (instancetype)initWithFrame:(CGRect)frame backItme:(SFSearchItem *)bitem rightItem:(SFSearchItem *)rItem searchBlock:(void(^)(NSString *qs))searchBlock;

/// 搜索模式
@property (nonatomic, readwrite, assign) SFSearchType searchType;

/// 假搜索条模式, 点击搜索
@property (nonatomic, readwrite, copy) void(^fakeTouchBock)(void);

/// 添加搜索数据组
/// @param sectionData 搜索数据
- (void)addSearchSection:(NSMutableArray<SFSearchModel *> *)sectionData;

/// 是否聚焦搜索
@property (nonatomic, readwrite, assign, getter=isActiveSearch) BOOL activeSearch;

@end

NS_ASSUME_NONNULL_END
