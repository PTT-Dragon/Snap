//
//  FAQChildViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "FAQListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FAQChildViewControllerBlock)(BOOL show,NSString *qs);

@interface FAQChildViewController : UIViewController
@property (nonatomic,copy) FAQChildViewControllerBlock block;
@property (nonatomic,weak) FAQListModel *model;
@property (nonatomic,copy) NSString *searchText;
@end

NS_ASSUME_NONNULL_END
