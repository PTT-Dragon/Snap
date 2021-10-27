//
//  SimilarViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "RecentlyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimilarViewController : UIViewController
@property (nonatomic,weak) RecentlyModel *model;
@property (nonatomic,copy) NSString *offerId;
@end

NS_ASSUME_NONNULL_END
