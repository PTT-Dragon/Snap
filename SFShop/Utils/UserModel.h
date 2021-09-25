//
//  UserModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : JSONModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *pwd;

@end

NS_ASSUME_NONNULL_END
