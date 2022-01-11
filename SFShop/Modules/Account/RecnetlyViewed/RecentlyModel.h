//
//  RecentlyModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentlyImgUrlContentModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*bigImgUrl;
@property (nonatomic,copy) NSString <Optional>*catgType;
@property (nonatomic,assign) NSString <Optional>*content;
@property (nonatomic,copy) NSString <Optional>*defLangId;
@property (nonatomic,copy) NSString <Optional>*deviceType;
@property (nonatomic,copy) NSString <Optional>*imgUrl;
@property (nonatomic,copy) NSString <Optional>*name;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*seq;
@property (nonatomic,copy) NSString <Optional>*smallImgUrl;
@property (nonatomic,copy) NSString <Optional>*type;
@property (nonatomic,copy) NSString <Optional>*uid;
@property (nonatomic,copy) NSString <Optional>*url;
@end

@interface RecentlyModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*createdDate;
@property (nonatomic,copy) NSString *createdDateNoH;
@property (nonatomic,copy) NSDate <Optional>*date;
@property (nonatomic,copy) NSString <Optional>*imgUrl;
@property (nonatomic,assign) BOOL isCollection;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*offerName;
@property (nonatomic,copy) NSString <Optional>*offerType;
@property (nonatomic,copy) NSString <Optional>*offerViewLogId;
@property (nonatomic,copy) NSString <Optional>*salesPrice;
@property (nonatomic,copy) NSString <Optional>*storeId;
@end

NS_ASSUME_NONNULL_END
