//
//  CategoryModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryInnerModel : NSObject
@property (nonatomic, readwrite, assign) NSInteger catgId;
@property (nonatomic, readwrite, assign) NSInteger seq;
@property (nonatomic, readwrite, assign) NSInteger parentCatgId;
@property (nonatomic, readwrite, copy) NSString *catgName;
@property (nonatomic, readwrite, copy) NSString *catgRela;
@property (nonatomic, readwrite, copy) NSString *imgUrl;
@end

@interface CategoryModel : NSObject
@property (nonatomic, readwrite, strong) NSArray *children;
@property (nonatomic, readwrite, strong) CategoryInnerModel *inner;
@end

NS_ASSUME_NONNULL_END