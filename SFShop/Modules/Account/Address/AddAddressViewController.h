//
//  AddAddressViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddAddressViewControllerDelegate <NSObject>

- (void)addNewAddressSuccess;

@end

@interface AddAddressViewController : UIViewController
@property (nonatomic,assign) id<AddAddressViewControllerDelegate>delegate;
@property (nonatomic,weak) addressModel *model;
@end

NS_ASSUME_NONNULL_END
