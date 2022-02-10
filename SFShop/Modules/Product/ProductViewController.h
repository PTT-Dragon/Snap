//
//  ProductViewController.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProductViewControllerBlock)(void);

@interface ProductViewController : UIViewController
@property (nonatomic,copy) ProductViewControllerBlock block;
@property (nonatomic, assign) NSInteger offerId;
@property (nonatomic, assign) NSInteger productId;

@end

NS_ASSUME_NONNULL_END
