//
//  addressModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface addressModel : JSONModel

@property(nonatomic,copy) NSString <Optional>*contactAddress;
@property(nonatomic,assign) BOOL sel;
@property(nonatomic,copy) NSString <Optional>*city;
@property(nonatomic,copy) NSString <Optional>*province;
@property(nonatomic,copy) NSString <Optional>*district;
@property(nonatomic,copy) NSString <Optional>*postCode;
@property(nonatomic,copy) NSString <Optional>*contactName;
@property(nonatomic,copy) NSString <Optional>*contactNbr;
@property(nonatomic,copy) NSString <Optional>*contactStdId;
@property(nonatomic,copy) NSString <Optional>*country;
@property(nonatomic,copy) NSString <Optional>*createdDate;
@property(nonatomic,copy) NSString <Optional>*deliveryAddressId;
@property(nonatomic,copy) NSString <Optional>*email;
@property(nonatomic,copy) NSString <Optional>*isDefault;
@property(nonatomic,copy) NSString <Optional>*modifyDate;
@property(nonatomic,copy) NSString <Optional>*state;
@property(nonatomic,copy) NSString <Optional>*stateDate;
@property(nonatomic,copy) NSString <Optional>*street;
@property(nonatomic,copy) NSDictionary *addressLabelList;

@end

@interface AreaModel : JSONModel
@property(nonatomic,copy) NSString <Optional>*stdAddrId;
@property(nonatomic,copy) NSString <Optional>*stdAddr;
@property(nonatomic,copy) NSString <Optional>*addrLevelId;
@property(nonatomic,copy) NSString <Optional>*parentId;
@property(nonatomic,copy) NSString <Optional>*isLeaf;
@property(nonatomic,copy) NSString <Optional>*zipcode;
@property(nonatomic,assign) BOOL sel;
/**
 "stdAddrId": 1,
     "stdAddr": "Bali",
     "addrLevelId": 2,
     "parentId": 0,
     "isLeaf": false,
     "zipcode": null
 **/

@end

NS_ASSUME_NONNULL_END
