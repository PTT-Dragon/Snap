//
//  EmptyModel.m
//  SFShop
//
//  Created by Lufer on 2021/12/27.
//

#import "EmptyModel.h"

@implementation EmptyModel

+ (EmptyModel *)getEmptyModelWithType:(EmptyViewType)type {
    EmptyModel *model = [[EmptyModel alloc] init];
    NSString *imageName = @"";
    NSString *tip = @"";
    switch (type) {
        case EmptyViewNoPageType: {
            imageName = @"ic_empty_page";
            tip = kLocalizedString(@"Empty_Tip_NoPage");
            break;
        }
        case EmptyViewNoNetworkType: {
            imageName = @"ic_empty_network";
            tip = kLocalizedString(@"Empty_Tip_NoNetWork");
            break;
        }
        case EmptyViewNoShoppingCarType: {
            imageName = @"ic_empty_shoppingCar";
            tip = kLocalizedString(@"Empty_Tip_NoShoppingCar");
            break;
        }
        case EmptyViewNoProductType: {
            imageName = @"ic_empty_product";
            tip = kLocalizedString(@"Empty_Tip_NoProduct");
            break;
        }
        case EmptyViewNoDiscountType: {
            imageName = @"ic_empty_discount";
            tip = kLocalizedString(@"Empty_Tip_NoDiscount");
            break;
        }
        case EmptyViewNoOrderType: {
            imageName = @"ic_empty_order";
            tip = kLocalizedString(@"Empty_Tip_NoOrder");
            break;
        }
        case EmptyViewNofavoriteType: {
            imageName = @"ic_empty_favorite";
            tip = kLocalizedString(@"Empty_Tip_No favorite");
            break;
        }
        case EmptyViewNoReviewType: {
            imageName = @"ic_empty_review";
            tip = kLocalizedString(@"Empty_Tip_NoReview");
            break;
        }
        case EmptyViewNoAddressType: {
            imageName = @"ic_empty_address";
            tip = kLocalizedString(@"Empty_Tip_NoAddress");
            break;
        }
        case EmptyViewNoPurchaseType: {
            imageName = @"ic_empty_purchase";
            tip = kLocalizedString(@"Empty_Tip_NoPurchase");
            break;
        }
        case EmptyViewNoMessageType: {
            imageName = @"ic_empty_message";
            tip = kLocalizedString(@"Empty_Tip_NoMessage");
            break;
        }
        case EmptyViewNoEventType: {
            imageName = @"ic_empty_event";
            tip = kLocalizedString(@"Empty_Tip_NoEvent");
            break;
        }
        case EmptyViewNoPrizeType: {
            imageName = @"ic_empty_prize";
            tip = kLocalizedString(@"Empty_Tip_NoPrize");
            break;
        }
        case EmptyViewNoCouponType: {
            imageName = @"ic_empty_discount";
            tip = kLocalizedString(@"Empty_Tip_NoCoupon");
            break;
        }
        default:
            break;
    }
    model.imageName = imageName;
    model.tip = tip;
    return model;
}

@end
