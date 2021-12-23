//
//  AddressViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : UIViewController

@property (nonatomic, readwrite, copy) void(^addressBlock)(addressModel *model);

@end

NS_ASSUME_NONNULL_END
