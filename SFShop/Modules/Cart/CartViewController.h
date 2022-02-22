//
//  CartViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/12/2.
//

#import "BaseViewController.h"
#import <VTMagic/VTMagic.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartViewControllerBlock)(void);

@interface CartViewController : BaseViewController
@property (nonatomic,copy) CartViewControllerBlock block;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,assign) BOOL isTab;
@property (nonatomic,assign) BOOL showAddSuccess;//展示加入购物车成功提示
@property (nonatomic,weak) addressModel *selAddModel;

@end

NS_ASSUME_NONNULL_END
