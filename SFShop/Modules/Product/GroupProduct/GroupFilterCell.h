//
//  GroupFilterCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupFilterCell : UITableViewCell
typedef NS_ENUM(NSUInteger, CategoryRankType) {
    CategoryRankTypeSales = 1,          //销售维度
    CategoryRankTypePopularity = 2,     //欢迎维度
    CategoryRankTypePriceAscending = 3, //价格升序纬度
    CategoryRankTypePriceDescending = 4,//价格降序维度
    CategoryRankTypeDetail = 9,         //排序详情
};


/// 点击内部排序或者排序详情按钮
@property (nonatomic, readwrite, copy) void(^clickFilterBlock)(CategoryRankType type);

/// 初始化
/// @param frame frame
/// @param type 状态
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CategoryRankType)type;

@end

NS_ASSUME_NONNULL_END
