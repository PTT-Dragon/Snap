//
//  LastSelAddressModel.h
//  SFShop
//
//  Created by 游挺 on 2022/2/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LastSelAddressModel : JSONModel
singleton_interface(LastSelAddressModel);

@property(nonatomic,copy) NSString <Optional>*contactAddress;
@property(nonatomic,assign) BOOL sel;
@property(nonatomic,assign) BOOL isNoAdd;
@property(nonatomic,copy) NSString <Optional>*city;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString <Optional>*province;
@property(nonatomic,copy) NSString *provinceId;
@property(nonatomic,copy) NSString <Optional>*district;
@property(nonatomic,copy) NSString *districtId;
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
@property(nonatomic,copy) NSString *streetId;
@property(nonatomic,copy) NSString <Optional>*addrPath;
@property(nonatomic,copy) NSDictionary *addressLabelList;

/// 自定义拼接字符串
@property(nonatomic, readwrite, strong) NSString *customAddress;

@end

NS_ASSUME_NONNULL_END
