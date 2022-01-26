//
//  LogisticsCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

NS_ASSUME_NONNULL_END
