//
//  refundModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "JSONModel.h"

@protocol refundItemsModel <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@interface refundItemsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*createdDate;
@property (nonatomic,copy) NSString <Optional>*imagUrl;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*orderApplyItemId;
@property (nonatomic,copy) NSString <Optional>*productCode;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*productName;
@property (nonatomic,copy) NSString <Optional>*productRemark;
@property (nonatomic,copy) NSString <Optional>*receiveCnt;
@property (nonatomic,copy) NSString <Optional>*refundCharge;
@property (nonatomic,copy) NSString <Optional>*submitNum;
@property (nonatomic,copy) NSString <Optional>*unitPrice;
/**
 items =             (
                  {
      approvalCharge = "<null>";
      brandId = "<null>";
      brandName = "<null>";
      catgId = "<null>";
      catgName = "<null>";
      createdDate = "2021-05-14 11:54:06";
      imagUrl = "/get/resource/White1369572403830722560.jpg";
      offerId = 80;
      orderApplyItemId = 4010;
      productCode = 16153794963425123;
      productId = 111;
      productName = "HOCO Headset Wireless ES21 Putih ";
      productRemark = "{\"Color\":\"Putih \"}";
      receiveCnt = "<null>";
      refundCharge = 239000;
      submitNum = 1;
      unitPrice = 239000;
  }
 )
 **/
@end

@interface refundModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*createdDate;
@property (nonatomic,copy) NSString <Optional>*eventId;
@property (nonatomic,copy) NSString <Optional>*isValetOrder;
@property (nonatomic,copy) NSString <Optional>*orderApplyCode;
@property (nonatomic,copy) NSString <Optional>*orderApplyId;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,copy) NSString <Optional>*orderReason;
@property (nonatomic,copy) NSString <Optional>*phoneNumber;
@property (nonatomic,copy) NSString <Optional>*refundCharge;
@property (nonatomic,copy) NSString <Optional>*relaOrderNbr;
@property (nonatomic,copy) NSString <Optional>*state;
@property (nonatomic,copy) NSString <Optional>*storeId;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,copy) NSString <Optional>*supplierDesc;
@property (nonatomic,copy) NSString <Optional>*userId;
@property (nonatomic,copy) NSString <Optional>*userName;
@property (nonatomic,strong) NSArray <refundItemsModel>*items;
/**
 {
approvalCharge = "<null>";
auditRemarks = "<null>";
autoRefund = "<null>";
createdDate = "2021-05-14 11:54:06";
eventId = 3;
isValetOrder = Y;
;
orderApplyCode = O202105141154051726;
orderApplyId = 4010;
orderId = 8026;
orderNbr = O202105131038296104;
orderReason = "<null>";
phoneNumber = "<null>";
refundCharge = 239000;
relaOrderNbr = "<null>";
state = E;
storeId = 15;
storeName = NeuKoo;
supplierDesc = "Self Support";
userId = 1197;
userName = "hxf01@qq.com";
}
 **/
@end

NS_ASSUME_NONNULL_END
