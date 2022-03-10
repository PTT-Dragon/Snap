//
//  SysParamsModel.h
//  SFShop
//
//  Created by 游挺 on 2022/1/11.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface SysParamsItemModel : JSONModel

singleton_interface(SysParamsItemModel)

@property (nonatomic,copy) NSString <Optional>*PHONE_REGULAR_RULE;
@property (nonatomic,copy) NSString <Optional>*EMAIL_REGULAR_RULE;
@property (nonatomic,copy) NSString <Optional>*PASSWORD_REGULAR_RULE;
@property (nonatomic,copy) NSString <Optional>*CURRENCY_DISPLAY;
@property (nonatomic,copy) NSString <Optional>*CURRENCY_PRECISION;
@property (nonatomic,copy) NSString <Optional>*CODE_TTL;
@property (nonatomic,copy) NSString <Optional>*MINIMUM_DAILY_WITHDRAWAL;
@property (nonatomic,copy) NSString <Optional>*MAXIMUM_DAILY_WITHDRAWAL;


@end

@interface SysParamsModel : JSONModel

@end

NS_ASSUME_NONNULL_END
