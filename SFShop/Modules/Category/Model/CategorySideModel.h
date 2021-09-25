//
//  CategorySideModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategorySideInnerModel : NSObject

@property (nonatomic, readwrite, assign) NSInteger catgId;
@property (nonatomic, readwrite, assign) NSInteger seq;
@property (nonatomic, readwrite, assign) NSInteger parentCatgId;
@property (nonatomic, readwrite, copy) NSString *catgName;
@property (nonatomic, readwrite, copy) NSString *catgRela;
@property (nonatomic, readwrite, copy) NSString *imgUrl;

@end


@interface CategorySideModel : NSObject

@property (nonatomic, readwrite, copy) NSString *children;
@property (nonatomic, readwrite, strong) CategorySideInnerModel *model;

@end


NS_ASSUME_NONNULL_END
