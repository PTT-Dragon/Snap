//
//  DistributeProductListChildVC.h
//  SFShop
//
//  Created by 游挺 on 2022/3/9.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributeProductListChildVC : UIViewController
@property (nonatomic,copy) NSString *searchText;
@property (nonatomic,copy) NSString *isHistory;
@property (nonatomic,strong) DistributorModel *centerModel;
@end

NS_ASSUME_NONNULL_END
