//
//  ProductChoosePromotionCell.m
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import "ProductChoosePromotionCell.h"
#import "NSDate+Helper.h"

@interface ProductChoosePromotionCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ProductChoosePromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setModel:(cmpBuygetnsModel *)model
{
    _model = model;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"TILL"),[[NSDate dateFromString:model.expDate] dayMonthYearHHMM]];
    PromotionRuleModel *ruleModel = model.rules.firstObject;
    NSString *launage = UserDefaultObjectForKey(@"Language");
    if ([launage isEqualToString:@"id"]) {
            self.contentLabel.text = [NSString stringWithFormat:@"Beli %@ , Diskon %@ ",[ruleModel.thAmount currency],[ruleModel.promotAmount currency]];
    }else{
        if ([ruleModel.promotMethod isEqualToString:@"AMT"]) {
            self.contentLabel.text = [NSString stringWithFormat:@"Spend %@ to get %@ discount",[ruleModel.thAmount currency],[ruleModel.promotAmount currency]];
        }else{
            self.contentLabel.text = [NSString stringWithFormat:@"Spend %@ to get %.0f%% discount",[ruleModel.thAmount currency],[ruleModel.promotAmount currencyFloat]];
        }
    }
    
}
@end
