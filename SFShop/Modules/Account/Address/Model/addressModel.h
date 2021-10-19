//
//  addressModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface addressModel : JSONModel

@property(nonatomic,copy) NSString *contactAddress;
@property(nonatomic,copy) NSString *contactName;
@property(nonatomic,copy) NSString *contactNbr;
@property(nonatomic,copy) NSString *contactStdId;
@property(nonatomic,copy) NSString *country;
@property(nonatomic,copy) NSString *createdDate;
@property(nonatomic,copy) NSString *deliveryAddressId;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *isDefault;
@property(nonatomic,copy) NSString *modifyDate;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,copy) NSString *stateDate;
@property(nonatomic,copy) NSDictionary *addressLabelList;

@end

NS_ASSUME_NONNULL_END
