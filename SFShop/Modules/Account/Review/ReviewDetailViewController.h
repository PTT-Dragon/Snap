//
//  ReviewDetailViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewDetailViewController : BaseViewController
@property (nonatomic,copy) NSString *orderItemId;
@property (nonatomic,assign) NSInteger offerId;

@end

NS_ASSUME_NONNULL_END
