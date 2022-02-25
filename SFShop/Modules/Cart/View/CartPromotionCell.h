//
//  CartPromotionCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/29.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartPromotionCellBlock)(NSInteger row);

@interface CartPromotionCell : UITableViewCell
@property (nonatomic,copy) CartPromotionCellBlock block;
@property (nonatomic,strong) CampaignsModel *model;
@property (nonatomic,assign) NSInteger row;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
- (IBAction)selAction:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
