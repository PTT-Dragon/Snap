//
//  SFSearchItem.h
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import "SFSearchModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFSearchState) {
    SFSearchStateInUnActive,    //在未激活状态
    SFSearchStateInFocuActive,  //外部主动激活状态（⚠️：用户主动激活搜索条，不属于该状态）
    SFSearchStateInHistory,     //在搜索历史界面
    SFSearchStateInSearching,   //在搜索中页面
};

@interface SFSearchItem : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *icon;
@property (nonatomic, readwrite, strong) NSString *selectedIcon;
@property (nonatomic, readwrite, copy) void(^itemActionBlock)(SFSearchState state ,SFSearchModel * _Nullable model,BOOL isSelected);

@end

NS_ASSUME_NONNULL_END
