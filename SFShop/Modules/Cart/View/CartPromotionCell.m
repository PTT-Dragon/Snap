//
//  CartPromotionCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/29.
//

#import "CartPromotionCell.h"
#import "NSDate+Helper.h"

@interface CartPromotionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end

@implementation CartPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CampaignsModel *)model
{
    _model = model;
    _nameLabel.text = model.campaignName;
    _timeLabel.text = [[NSDate dateFromString:model.expDate] dayMonthYearHHMM];
    _selBtn.selected = model.sel;
}
@end
