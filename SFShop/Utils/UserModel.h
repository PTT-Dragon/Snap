//
//  UserModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface userResModel : JSONModel
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *lastSighinDate;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *recmdChannel;
@property(nonatomic, copy) NSString *recmdBy;
@property(nonatomic, copy) NSString *pageTotal;
@property(nonatomic, copy) NSString *stateDate;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *updateDate;
@property(nonatomic, copy) NSString *userCode;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *userRegSrc;
@property(nonatomic, copy) NSString *userType;

@end

@interface UserModel : JSONModel

@property(nonatomic, copy) NSString *accessToken;
//@property(nonatomic, copy) NSString *birthdayDay;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *expiresIn;
//@property(nonatomic, copy) NSString *gender;
@property(nonatomic, copy) NSString *userId;
//@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *lastSighinDate;
@property(nonatomic, copy) NSString *obtainMobilePhoneFlag;
//@property(nonatomic, copy) NSString *refreshToken;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) userResModel *userRes;

@end

NS_ASSUME_NONNULL_END
