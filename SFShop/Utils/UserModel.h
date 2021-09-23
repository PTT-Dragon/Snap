//
//  UserModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
