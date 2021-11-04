//
//  ProductCheckoutModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutModel.h"

@implementation ProductCheckoutSubItemModel

@end

@implementation ProductCheckoutModel

- (float)totalPrice {
    float price = 0;
    for (ProductCheckoutSubItemModel *item in self.productList) {
        price += (item.productPrice * item.productNum);
    }
    price -= self.promoReduce;
    price -= self.vouchersReduce;
    if (price < 0) {
        price = 0;
    }
    return price;
}

@end
