//
//  CategoryRankModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/29.
//

#import <Foundation/Foundation.h>
#import "CategoryRankFilterCacheModel.h"
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
@class CategoryRankServiceModel;
@class CategoryRankCategoryModel;
@class CategoryRankBrandModel;
@class CategoryRankPageInfoModel;
@class CategoryRankEvaluationModel;
@class CategoryRankPriceModel;
@class CategoryRankAttrModel;
@interface CategoryRankModel : NSObject
@property (nonatomic, readwrite, strong) NSArray<CategoryRankServiceModel *> *serviceIds;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankCategoryModel *> *catgIds;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankBrandModel *> *brandIds;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankBrandModel *> *catgNumList;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankAttrModel *> *offerAttrValues;
@property (nonatomic, readwrite, strong) CategoryRankPageInfoModel *pageInfo;
@property (nonatomic, readwrite, copy) NSString *evaluationAvgs;
@property (nonatomic, readwrite, copy) NSString *salesPrices;

/// ⚠️:自定义
@property (nonatomic, readwrite, strong) CategoryRankPriceModel *priceModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCache;//配置缓存
@property (nonatomic, readwrite, strong) NSArray<CategoryRankEvaluationModel *> *evaluations;//评价
@end
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankFilterModel : NSObject
    @property (nonatomic, readwrite, assign) NSInteger num;
    @property (nonatomic, readwrite, copy) NSString *name;
    @property (nonatomic, readwrite, copy) NSString *idStr;
    @property (nonatomic, readwrite, assign) NSInteger goodsNum;
    @property (nonatomic, readwrite, copy) NSString *catgId;
    @property (nonatomic, readwrite, copy) NSString *catgName;

    //⚠️:自定义
    @property (nonatomic, readwrite, assign) BOOL isSupportMul;
    @property (nonatomic, readwrite, assign) BOOL isSelected;
    @property (nonatomic, readwrite, copy) NSString *groupName;
    @end

    /*------------------------------------------------------------------------------------*/
    //Services
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankServiceModel : CategoryRankFilterModel
    @end

    /*------------------------------------------------------------------------------------*/
    //Categorys
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankCategoryModel : CategoryRankFilterModel
    @end

    /*------------------------------------------------------------------------------------*/
    //Brands
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankBrandModel : CategoryRankFilterModel
    @end

    /*------------------------------------------------------------------------------------*/
    //Evaluation ⚠️:自定义评价model
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankEvaluationModel : CategoryRankFilterModel
    @end

    /*------------------------------------------------------------------------------------*/
    //Evaluation ⚠️:自定义Attrmodel
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankAttrModel : CategoryRankFilterModel
    @end

    /*------------------------------------------------------------------------------------*/
    //Price ⚠️:自定义价格model
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankPriceModel : NSObject
        @property (nonatomic, readwrite, copy) NSString *groupName;
        @property (nonatomic, readwrite, assign) NSInteger minPrice;
        @property (nonatomic, readwrite, assign) NSInteger maxPrice;
        @property (nonatomic, readwrite, copy) NSString *minPriceGinseng;//给接口入参使用
        @property (nonatomic, readwrite, copy) NSString *maxPriceGinseng;//给接口入参使用
    @end

    /*------------------------------------------------------------------------------------*/
    //pageInfo
    /*------------------------------------------------------------------------------------*/
    @class CategoryRankPageInfoListModel;
    @interface CategoryRankPageInfoModel : NSObject
    @property (nonatomic, readwrite, assign) NSInteger pageNum;
    @property (nonatomic, readwrite, assign) NSInteger pageSize;
    @property (nonatomic, readwrite, assign) NSInteger size;
    @property (nonatomic, readwrite, assign) NSInteger startRow;
    @property (nonatomic, readwrite, assign) NSInteger endRow;
    @property (nonatomic, readwrite, assign) NSInteger total;
    @property (nonatomic, readwrite, assign) NSInteger pages;
    @property (nonatomic, readwrite, assign) NSInteger prePage;
    @property (nonatomic, readwrite, assign) NSInteger nextPage;
    @property (nonatomic, readwrite, assign) BOOL isFirstPage;
    @property (nonatomic, readwrite, assign) BOOL isLastPage;
    @property (nonatomic, readwrite, assign) BOOL hasPreviousPage;
    @property (nonatomic, readwrite, assign) BOOL hasNextPage;
    @property (nonatomic, readwrite, assign) NSInteger navigatePages;
    @property (nonatomic, readwrite, assign) NSInteger navigateFirstPage;
    @property (nonatomic, readwrite, assign) NSInteger navigateLastPage;
    @property (nonatomic, readwrite, assign) NSInteger firstPage;
    @property (nonatomic, readwrite, assign) NSInteger lastPage;
    @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListModel *> *list;
    @property (nonatomic, readwrite, strong) NSArray<NSNumber *> *navigatepageNums;
    @end
        /*------------------------------------------------------------------------------------*/
        //pageInfo - list
        /*------------------------------------------------------------------------------------*/
        @class CategoryRankPageInfoListImgModel;
        @class CategoryRankPageInfoListServiceModel;
        @class CategoryRankPageInfoListProductImgModel;
        @class CategoryRankPageInfoListLabelsModel;
        @interface CategoryRankPageInfoListModel : NSObject
        @property (nonatomic, readwrite, assign) NSInteger offerId;
        @property (nonatomic, readwrite, assign) NSInteger brandId;
        @property (nonatomic, readwrite, assign) NSInteger catgId;
        @property (nonatomic, readwrite, assign) NSInteger storeId;
        @property (nonatomic, readwrite, assign) NSInteger evaluationCnt;
        @property (nonatomic, readwrite, assign) NSInteger salesCnt;
        @property (nonatomic, readwrite, assign) long marketPrice;
        @property (nonatomic, readwrite, assign) long salesPrice;
        @property (nonatomic, readwrite, copy) NSString *productId;
        @property (nonatomic, readwrite, copy) NSString *offerCode;
        @property (nonatomic, readwrite, copy) NSString *offerType;
        @property (nonatomic, readwrite, copy) NSString *offerName;
        @property (nonatomic, readwrite, copy) NSString *brandName;
        @property (nonatomic, readwrite, copy) NSString *catgName;
        @property (nonatomic, readwrite, copy) NSString *storeName;
        @property (nonatomic, readwrite, copy) NSString *storeLogoUrl;
        @property (nonatomic, readwrite, copy) NSString *subheadName;
        @property (nonatomic, readwrite, assign) double evaluationAvg;
        @property (nonatomic, readwrite, assign) long evaluationRate;
        @property (nonatomic, readwrite, copy) NSString *goodsIntroduce;
        @property (nonatomic, readwrite, copy) NSString *currencySymbol;
        @property (nonatomic, readwrite, copy) NSString *isCollection;
        @property (nonatomic, readwrite, copy) NSString *imgUrl;
        @property (nonatomic, readwrite, copy) NSString *sppType;
        @property (nonatomic, readwrite, assign) long specialPrice;
        @property (nonatomic, readwrite, copy) NSString *sppProductId;
        @property (nonatomic, readwrite, copy) NSString *sppMarketPrice;
        @property (nonatomic, readwrite, copy) NSString *discountPercent;
        @property (nonatomic, readwrite, copy) NSString *promotType;
        @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListLabelsModel *> *labels;//标签数组
        @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListImgModel *> *imgs;
        @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListServiceModel *> *services;
        @property (nonatomic, readwrite, strong) ProductCampaignsInfoModel *campaigns;
        @property (nonatomic, readwrite, strong) CategoryRankPageInfoListProductImgModel *productImg;

#pragma mark - 手动添加属性
        @property (nonatomic, readwrite, assign) CGFloat height;
        @property (nonatomic, readonly, copy, nullable) NSString *labelPictureUrl;
        @end

            /*------------------------------------------------------------------------------------*/
            //pageInfo - list - labels
            /*------------------------------------------------------------------------------------*/
            @interface CategoryRankPageInfoListLabelsModel : NSObject
            @property (nonatomic, readwrite, copy) NSString *labelId;
            @property (nonatomic, readwrite, copy) NSString *labelType;
            @property (nonatomic, readwrite, copy) NSString *labelClass;
            @property (nonatomic, readwrite, copy) NSString *labelName;
            @property (nonatomic, readwrite, copy) NSString *position;
            @property (nonatomic, readwrite, copy) NSString *labelPictureUrl;
            @property (nonatomic, readwrite, copy) NSString *labelCode;
            @property (nonatomic, readwrite, copy) NSString *effDate;
            @property (nonatomic, readwrite, copy) NSString *expDate;
            @end

            /*------------------------------------------------------------------------------------*/
            //pageInfo - list - ProductImg
            /*------------------------------------------------------------------------------------*/
            @interface CategoryRankPageInfoListProductImgModel : NSObject
            @property (nonatomic, readwrite, copy) NSString *idStr;
            @property (nonatomic, readwrite, copy) NSString *productId;
            @property (nonatomic, readwrite, copy) NSString *salesPrice;
            @property (nonatomic, readwrite, copy) NSString *marketPrice;
            @property (nonatomic, readwrite, copy) NSString *imgUrl;
            @property (nonatomic, readwrite, copy) NSString *bigImgUrl;
            @property (nonatomic, readwrite, copy) NSString *smallImgUrl;
            @property (nonatomic, readwrite, copy) NSString *type;
            @property (nonatomic, readwrite, copy) NSString *url;
            @property (nonatomic, readwrite, strong) NSArray<NSNumber *> *labelId;
            @property (nonatomic, readwrite, strong) NSArray<NSNumber *> *serviceId;
            @end
            
            /*------------------------------------------------------------------------------------*/
            //pageInfo - list - imgs
            /*------------------------------------------------------------------------------------*/
            @interface CategoryRankPageInfoListImgModel : NSObject
            @property (nonatomic, readwrite, assign) NSInteger idStr;
            @property (nonatomic, readwrite, assign) NSInteger productId;
            @property (nonatomic, readwrite, assign) NSInteger salesPrice;
            @property (nonatomic, readwrite, assign) NSInteger marketPrice;
            @property (nonatomic, readwrite, copy) NSString *imgUrl;
            @property (nonatomic, readwrite, copy) NSString *bigImgUrl;
            @property (nonatomic, readwrite, copy) NSString *smallImgUrl;
            @property (nonatomic, readwrite, copy) NSString *type;
            @property (nonatomic, readwrite, copy) NSString *url;
            @property (nonatomic, readwrite, copy) NSString *labelId;
            @property (nonatomic, readwrite, strong) NSArray<NSNumber *> *serviceId;
            @end

            /*------------------------------------------------------------------------------------*/
            //pageInfo - list - services
            /*------------------------------------------------------------------------------------*/
            @interface CategoryRankPageInfoListServiceModel : NSObject
            @property (nonatomic, readwrite, assign) NSInteger serviceId;
            @property (nonatomic, readwrite, copy) NSString *serviceName;
            @property (nonatomic, readwrite, copy) NSString *comments;
            @property (nonatomic, readwrite, copy) NSString *serviceImageUrl;
            @property (nonatomic, readwrite, copy) NSString *serviceArticle;
            @end
NS_ASSUME_NONNULL_END
