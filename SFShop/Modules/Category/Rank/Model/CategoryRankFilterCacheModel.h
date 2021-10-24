//
//  CategoryRankFilterCacheModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankFilterCacheModel : NSObject

@property (nonatomic, readwrite, assign) NSInteger minPrice;//负责存储
@property (nonatomic, readwrite, assign) NSInteger maxPrice;//负责存储
@property (nonatomic, readwrite, copy) NSString *server;
@property (nonatomic, readwrite, copy) NSString *category;
@property (nonatomic, readwrite, copy) NSString *brand;
@property (nonatomic, readwrite, copy) NSString *evaluation;

@end

NS_ASSUME_NONNULL_END
