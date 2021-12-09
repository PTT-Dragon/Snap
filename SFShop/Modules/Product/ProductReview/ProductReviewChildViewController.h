//
//  ProductReviewChildViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductReviewChildViewController : UIViewController
@property (nonatomic,assign) NSInteger offerId;
@property (nonatomic,copy) NSString *labelId;
@property (nonatomic,copy) NSString *evaluationType;
@property (nonatomic,strong) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
