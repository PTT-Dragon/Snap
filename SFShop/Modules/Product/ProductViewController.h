//
//  ProductViewController.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductViewController : UIViewController

// 当前产品的大id
@property (nonatomic, assign) NSInteger offerId;

/// 当前选中的产品id (如默认红色还是黄色)
@property (nonatomic, assign) NSInteger productId;

@end

NS_ASSUME_NONNULL_END
