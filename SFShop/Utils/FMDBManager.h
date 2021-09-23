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

- (void)insertUser: (UserModel *)user;

- (void)updateUser: (UserModel *)user;

- (UserModel *) queryUserWith: (NSString *)account;

- (void)deleteUserData;

@end

NS_ASSUME_NONNULL_END
