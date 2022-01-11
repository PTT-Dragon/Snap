//
//  AddressViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "BaseViewController.h"
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : BaseViewController

@property (nonatomic, readwrite, copy) void(^addressBlock)(addressModel *model);

@end

NS_ASSUME_NONNULL_END
