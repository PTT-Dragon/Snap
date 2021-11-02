//
//  UserModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface userResModel : JSONModel <NSCoding>
@property(nonatomic, copy) NSString <Optional>*email;
@property(nonatomic, copy) NSString <Optional>*lastSighinDate;
@property(nonatomic, copy) NSString <Optional>*nickName;
@property(nonatomic, copy) NSString <Optional>*photo;
@property(nonatomic, copy) NSString <Optional>*recmdChannel;
@property(nonatomic, copy) NSString <Optional>*recmdBy;
@property(nonatomic, copy) NSString <Optional>*pageTotal;
@property(nonatomic, copy) NSString <Optional>*stateDate;
@property(nonatomic, copy) NSString <Optional>*state;
@property(nonatomic, copy) NSString <Optional>*updateDate;
@property(nonatomic, copy) NSString <Optional>*userCode;
@property(nonatomic, copy) NSString <Optional>*userId;
@property(nonatomic, copy) NSString <Optional>*userName;
@property(nonatomic, copy) NSString <Optional>*userRegSrc;
@property(nonatomic, copy) NSString <Optional>*userType;
@property(nonatomic, copy) NSString <Optional>*mobilePhone;
@property(nonatomic, copy) NSString <Optional>*birthdayDay;
@property(nonatomic, copy) NSString <Optional>*gender;
@property(nonatomic, copy) NSDictionary <Optional>*distributorDto;


@end

@interface UserModel : JSONModel <NSCoding>


@property(nonatomic, copy) NSString <Optional>*accessToken;
@property(nonatomic, copy) NSString <Optional>*birthdayDay;
@property(nonatomic, copy) NSString <Optional>*account;
@property(nonatomic, copy) NSString <Optional>*expiresIn;
@property(nonatomic, copy) NSString <Optional>*gender;
@property(nonatomic, copy) NSString <Optional>*userId;
@property(nonatomic, copy) NSString <Optional>*title;
@property(nonatomic, copy) NSString <Optional>*lastSighinDate;
@property(nonatomic, copy) NSString <Optional>*obtainMobilePhoneFlag;
@property(nonatomic, copy) NSString <Optional>*refreshToken;
@property(nonatomic, copy) NSString <Optional>*userName;
@property(nonatomic, strong) userResModel *userRes;

@end

NS_ASSUME_NONNULL_END
