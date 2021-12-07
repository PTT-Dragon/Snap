//
//  RefundDetailTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailTitleCell.h"

@interface RefundDetailTitleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) RefundDetailModel *model;

@end

@implementation RefundDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(RefundDetailModel *)model type:(NSInteger)type
{
    _model = model;
    _type = type;
    _imgView.image = [UIImage imageNamed:type == 1 ? @"data" : @"checkout_product"];
    [_btn setImage:[UIImage imageNamed:type == 1 ? @"right-scroll": @"call-centre"] forState:0];
    _label.text = [model.eventId isEqualToString:@"2"] ? @"Return":[model.eventId isEqualToString:@"3"] ? @"Refund":@"Exchange";
}
- (IBAction)btnAction:(UIButton *)sender {
}

@end
