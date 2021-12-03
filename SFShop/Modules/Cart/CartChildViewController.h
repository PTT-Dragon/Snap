//
//  CartChildViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CartChildViewControllerDelegate <NSObject>
- (void)calculateAmount:(CartModel *)model;


@end

@interface CartChildViewController : UIViewController
@property (nonatomic,assign) id<CartChildViewControllerDelegate>delegate;
@property (nonatomic,assign) BOOL reduceFlag;//是否是降价
@property (nonatomic,weak) addressModel *addModel;//是否是降价
@end

NS_ASSUME_NONNULL_END
