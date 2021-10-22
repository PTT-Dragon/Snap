//
//  OrderModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol orderItemsModel <NSObject>


@end

@interface orderItemsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReturn;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSDictionary <Optional>*evaluation;
@property (nonatomic,copy) NSString <Optional>*imagUrl;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*offerName;
@property (nonatomic,copy) NSString <Optional>*offerType;
@property (nonatomic,copy) NSString <Optional>*orderItemId;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*productName;
@property (nonatomic,copy) NSString <Optional>*productRemark;
@property (nonatomic,copy) NSString <Optional>*serviceTypes;
@property (nonatomic,copy) NSString <Optional>*unitPrice;

@end

@interface OrderModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSString <Optional>*deliveryState;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*paymentState;
@property (nonatomic,copy) NSDictionary <Optional>*shareBuyBriefInfo;
@property (nonatomic,copy) NSString <Optional>*state;
@property (nonatomic,copy) NSString <Optional>*storeId;
@property (nonatomic,copy) NSString <Optional>*storeLogoUrl;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,strong) NSArray <orderItemsModel>*orderItems;

/**
 {
canEvaluate = N;
canReview = Y;
deliveryState = C;
offerCnt = 1;
orderId = 31001;
orderItems =             (
                 {
     canEvaluate = N;
     canReturn = N;
     canReview = Y;
     evaluation =                     {
         createdDate = "2021-08-03 01:00:00";
         evaluationComments = "Positive review given by system default";
         rate = 5;
     };
     imagUrl = "/get/resource/5a6f1b7da492a4cf904df186694e3d1813170270762593198081381447867742425088.webp";
     offerCnt = 1;
     offerId = 1029;
     offerName = "iPhone 11";
     offerType = P;
     orderItemId = 31001;
     orderPrice = 5791112;
     productId = 1724;
     productName = "iPhone 11 256,White";
     productRemark = "{\"Capacity\":\"256\",\"Color\":\"White\"}";
     serviceTypes = "2,3,4";
     unitPrice = 5800000;
 }
);
orderNbr = O202107211536208465;
orderPrice = 5871112;
paymentState = S;
shareBuyBriefInfo = "<null>";
state = D;
storeId = 11;
storeLogoUrl = "<null>";
storeName = "Apple Store";
thirdPartyCodeList =             (
);
}
 **/

@end

NS_ASSUME_NONNULL_END
