//
//  FMDBManager.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDBManager : NSObject

+ (FMDBManager *)sharedInstance;

/**
 此处需要显式传入account，因为user中的account会脱敏
 */
- (void)insertUser: (UserModel *)user ofAccount: (NSString *)account;
- (void)updateUser: (UserModel *)user ofAccount: (NSString *)account;

- (UserModel *) queryUserWith: (NSString *)account;

- (void)deleteUserData;

@end

NS_ASSUME_NONNULL_END
