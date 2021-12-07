//
//  refundModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "JSONModel.h"
#import "OrderModel.h"

@protocol refundItemsModel <NSObject>

@end
@protocol RefundAfterSalesProcessModel <NSObject>

@end
@protocol RefundDetailItemsModel <NSObject>

@end
@protocol RefundDetailMemosModel <NSObject>

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



@interface RefundAfterSalesProcessModel : JSONModel
@property (nonatomic,copy) NSString *operName;
@end
@interface RefundDetailItemsModel : JSONModel
@property (nonatomic,copy) NSString *brandId;
@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSString *catgId;
@property (nonatomic,copy) NSString *catgName;
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *imagUrl;
@property (nonatomic,copy) NSString *offerId;
@property (nonatomic,copy) NSString *orderApplyItemId;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productRemark;
@property (nonatomic,copy) NSString *refundCharge;
@property (nonatomic,copy) NSString *submitNum;
@property (nonatomic,copy) NSString *unitPrice;
@end

@interface RefundDetailMemosModel : JSONModel
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *memoEventId;
@property (nonatomic,copy) NSString *memoEventName;
@property (nonatomic,copy) NSString *orderApplyId;
@property (nonatomic,copy) NSString *orderApplyMemoId;
@property (nonatomic,copy) NSString *partyType;
@property (nonatomic,copy) NSString *userName;
@end

@interface RefundInfoModel : JSONModel
@property (nonatomic,copy) NSString *paymentMethodName;
@property (nonatomic,copy) NSString *paycPaymentSn;
@property (nonatomic,copy) NSString *charge;
@property (nonatomic,copy) NSString *refundOrderId;
@property (nonatomic,copy) NSString *refundSn;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *stateDate;
@property (nonatomic,copy) NSString *paymentMode;


@end

@interface RefundDetailModel : JSONModel
@property (nonatomic,strong) NSArray <RefundAfterSalesProcessModel>*afterSalesProcess;
@property (nonatomic,strong) NSArray <EvaluatesContentsModel>*contents;
@property (nonatomic,strong) NSArray <RefundDetailItemsModel>*items;
@property (nonatomic,strong) NSArray <RefundDetailMemosModel>*memos;
@property (nonatomic,strong) RefundInfoModel *refund;
@property (nonatomic,copy) NSString *auditStateDate;
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *eventId;
@property (nonatomic,copy) NSString *goodReturnType;
@property (nonatomic,copy) NSString *orderApplyCode;
@property (nonatomic,copy) NSString *orderApplyId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderNbr;
@property (nonatomic,copy) NSString *orderReason;
@property (nonatomic,copy) NSString *questionDesc;
@property (nonatomic,copy) NSString *receivedFlag;
@property (nonatomic,copy) NSString *refundCharge;
@property (nonatomic,copy) NSString *relaOrderNbr;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeLogoUrl;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *uccAccount;
@property (nonatomic,copy) NSString *submitNum;

/**
 {
     approvalCharge = "<null>";
     auditRemarks = "<null>";
     auditStateDate = "2021-11-10 20:00:00";
     createdDate = "2021-11-10 10:58:23";
     deliverys =     (
     );
     eventId = 3;
     goodReturnType = "<null>";
     items =     (
                 
     );
     memos =     (
     );
     orderApplyCode = O202111101058228858;
     orderApplyId = 43001;
     orderId = 115008;
     orderNbr = O202111081659433869;
     orderReason = "7\U2013Day No Reason Return";
     questionDesc = "Fake masks";
     receivedFlag = N;
     refund = "<null>";
     refundCharge = 30000;
     relaOrderNbr = "<null>";
     returnAddress =     {
         contactAddress = "<null>";
         contactName = "<null>";
         contactNbr = "<null>";
         fullAddress = "<null>";
         returnAddrName = "<null>";
         stdAddrId = "<null>";
     };
     state = E;
     storeId = 15;
     storeLogoUrl = "<null>";
     storeName = NeuKoo;
     submitNum = 1;
     uccAccount = NeuKoo;
 }

 **/

@end

NS_ASSUME_NONNULL_END
