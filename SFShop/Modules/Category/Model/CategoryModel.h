//
//  CategoryModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjValueModel : JSONModel
@property (nonatomic,copy) NSString *maskValue;
@property (nonatomic, readwrite, assign) NSInteger objId;
@property (nonatomic, readwrite, strong, nullable) NSDictionary *filteredProductsRela;
@end

@interface CatgRelaModel : JSONModel
@property (nonatomic,copy) NSString *objType;//Category 、CustomizedPage (自定义)
@property (nonatomic, readwrite, strong) ObjValueModel *objValue;
@end

@interface CategoryInnerModel : NSObject
@property (nonatomic, readwrite, assign) NSInteger catgId;
@property (nonatomic, readwrite, assign) NSInteger seq;
@property (nonatomic, readwrite, assign) NSInteger parentCatgId;
@property (nonatomic, readwrite, copy) NSString *catgName;
@property (nonatomic, readwrite, copy) NSString *imgUrl;
@property (nonatomic, readwrite, strong) CatgRelaModel *catgRela;
#pragma mark - 自定义属性
@property (nonatomic, readwrite, copy) NSString *groupName;
@end

@interface CategoryModel : NSObject
@property (nonatomic, readwrite, strong) NSArray *children;
@property (nonatomic, readwrite, strong) CategoryInnerModel *inner;

//手动赋值
@property (nonatomic, readwrite, assign) BOOL isCached;//是否缓存过数据
@end

NS_ASSUME_NONNULL_END
