//
//  SFNetworkLoginModule.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkLoginModule : NSObject

@property (nonatomic, readwrite, strong) NSString *login;
@property (nonatomic, readwrite, strong) NSString *check;
@property (nonatomic, readwrite, strong) NSString *getCode;
@property (nonatomic, readwrite, strong) NSString *codeCheck;
@end

NS_ASSUME_NONNULL_END
