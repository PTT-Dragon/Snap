//
//  CategoryRankFilterCacheModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankFilterCacheModel : NSObject

//1、多个分组都支持保存选中状态
//2、数据回传,开始加载
//1、品牌动态显示,如果被选中,那么只显示选中的品牌
//2、点击直接请求
@property (nonatomic, readwrite, assign) NSInteger minPrice;//负责存储
@property (nonatomic, readwrite, assign) NSInteger maxPrice;//负责存储
@property (nonatomic, readwrite, copy) NSString *serverId;
@property (nonatomic, readwrite, copy) NSString *categoryId;
@property (nonatomic, readwrite, copy) NSString *brandId;
@property (nonatomic, readwrite, copy) NSString *evaluationId;

- (NSDictionary *)filterParam;

@end

NS_ASSUME_NONNULL_END
