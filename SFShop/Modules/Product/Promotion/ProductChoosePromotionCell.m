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
@property (nonatomic,strong) cmpBuygetnsModel *model;

@end

@implementation ProductChoosePromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setModel:(cmpBuygetnsModel *)model ruleModel:(PromotionRuleModel *)ruleModel
{
    _model = model;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"TILL"),[[NSDate dateFromString:model.expDate] dayMonthYearHHMM]];
    NSString *launage = UserDefaultObjectForKey(@"Language");
    if ([launage isEqualToString:@"id"]) {
        if ([ruleModel.promotMethod isEqualToString:@"AMT"]) {
            self.contentLabel.text = [NSString stringWithFormat:@"Beli %@ , Diskon %@ ",[ruleModel.thAmount currency],ruleModel.promotAmount ?[ruleModel.promotAmount currency]:[@"0" currency]];
        }else{
            self.contentLabel.text = [NSString stringWithFormat:@"Beli %@ , Diskon %@%% ",[ruleModel.thAmount currency],ruleModel.promotAmount ?[ruleModel.promotAmount currency]:@"0"];
        }
        
    }else{
        if ([ruleModel.promotMethod isEqualToString:@"AMT"]) {
            self.contentLabel.text = [NSString stringWithFormat:@"Spend %@ to get %@ discount",[ruleModel.thAmount currency],ruleModel.promotAmount ? [ruleModel.promotAmount currency] : [@"0" currency]];
        }else{
            self.contentLabel.text = [NSString stringWithFormat:@"Spend %@ to get %.0f%% discount",[ruleModel.thAmount currency],ruleModel.promotAmount ? [ruleModel.promotAmount currencyFloat] : 0];
        }
    }
    
}
@end
