//
//  CategoryRankModel.h
//  SFShop
//
//  Created by MasterFly on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CategoryRankServiceModel;
@class CategoryRankCategoryModel;
@class CategoryRankBrandModel;
@class CategoryRankPageInfoModel;
@interface CategoryRankModel : NSObject
@property (nonatomic, readwrite, strong) NSArray<CategoryRankServiceModel *> *serviceIds;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankCategoryModel *> *catgIds;
@property (nonatomic, readwrite, strong) NSArray<CategoryRankBrandModel *> *brandIds;
@property (nonatomic, readwrite, strong) NSArray *offerAttrValues;
@property (nonatomic, readwrite, strong) CategoryRankPageInfoModel *pageInfo;
@property (nonatomic, readwrite, copy) NSString *evaluationAvgs;
@property (nonatomic, readwrite, copy) NSString *salesPrices;
@end
    /*------------------------------------------------------------------------------------*/
    //Services
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankServiceModel : NSObject
    @property (nonatomic, readwrite, assign) NSInteger num;
    @property (nonatomic, readwrite, assign) NSInteger serviceId;
    @property (nonatomic, readwrite, copy) NSString *serviceName;
    @end

    /*------------------------------------------------------------------------------------*/
    //Categorys
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankCategoryModel : NSObject
    @property (nonatomic, readwrite, assign) NSInteger num;
    @property (nonatomic, readwrite, assign) NSInteger catgId;
    @property (nonatomic, readwrite, copy) NSString *catgName;
    @end

    /*------------------------------------------------------------------------------------*/
    //Brands
    /*------------------------------------------------------------------------------------*/
    @interface CategoryRankBrandModel : NSObject
    @property (nonatomic, readwrite, assign) NSInteger num;
    @property (nonatomic, readwrite, assign) NSInteger brandId;
    @property (nonatomic, readwrite, copy) NSString *brandName;
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
        @property (nonatomic, readwrite, copy) NSString *evaluationAvg;
        @property (nonatomic, readwrite, copy) NSString *evaluationRate;
        @property (nonatomic, readwrite, copy) NSString *goodsIntroduce;
        @property (nonatomic, readwrite, copy) NSString *currencySymbol;
        @property (nonatomic, readwrite, copy) NSString *isCollection;
        @property (nonatomic, readwrite, copy) NSString *imgUrl;
        @property (nonatomic, readwrite, copy) NSString *sppType;
        @property (nonatomic, readwrite, copy) NSString *specialPrice;
        @property (nonatomic, readwrite, copy) NSString *sppProductId;
        @property (nonatomic, readwrite, copy) NSString *sppMarketPrice;
        @property (nonatomic, readwrite, copy) NSString *discountPercent;
        @property (nonatomic, readwrite, copy) NSString *promotType;
        @property (nonatomic, readwrite, strong) NSArray *labels;//怀疑是数组 null
        @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListImgModel *> *imgs;
        @property (nonatomic, readwrite, strong) NSArray<CategoryRankPageInfoListServiceModel *> *services;
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
