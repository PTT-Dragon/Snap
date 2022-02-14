//
//  CartChoosePromotion.h
//  SFShop
//
//  Created by 游挺 on 2021/12/26.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartChoosePromotionBlock)(CartItemModel *itemModel);


@interface CartChoosePromotion : UIView
@property (nonatomic,copy) CartChoosePromotionBlock block;
@property (nonatomic,strong) CartItemModel *model;
//@property (nonatomic,strong) CartCampaignsModel *campaignsModel;

@end

NS_ASSUME_NONNULL_END
