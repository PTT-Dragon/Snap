//
//  ProductCheckoutBuyView.h
//  SFShop
//
//  Created by MasterFly on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "ProductCheckoutModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

@interface ProductCheckoutBuyView : UIView

@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, copy) Block buyBlock;

@end

NS_ASSUME_NONNULL_END
