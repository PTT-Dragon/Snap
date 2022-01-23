//
//  CartViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/12/2.
//

#import "BaseViewController.h"
#import <VTMagic/VTMagic.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartViewControllerBlock)(void);

@interface CartViewController : BaseViewController
@property (nonatomic,copy) CartViewControllerBlock block;
@property (strong, nonatomic) UIView *bottomView;

@end

NS_ASSUME_NONNULL_END
