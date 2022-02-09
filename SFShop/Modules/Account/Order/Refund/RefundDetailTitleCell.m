//
//  RefundDetailTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailTitleCell.h"
#import "PublicWebViewController.h"
#import "LogisticsProcessViewController.h"

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
    _imgView.image = [UIImage imageNamed:(type == 1 || type == 3) ? @"data" : @"checkout_product"];
    [_btn setImage:[UIImage imageNamed:type == 1 ? @"right-scroll": type == 3 ? @"": @"call-centre"] forState:0];
    _btn.hidden = type == 10 ? YES: NO;
    _label.text = (type == 1 || type == 3) ? [model.eventId isEqualToString:@"2"] ? kLocalizedString(@"RETURN"):[model.eventId isEqualToString:@"3"] ? kLocalizedString(@"Refund"):kLocalizedString(@"EXCHANGE"): model.storeName;
}
- (IBAction)btnAction:(UIButton *)sender {
    if (_type == 1) {
        LogisticsProcessViewController *vc = [[LogisticsProcessViewController alloc] init];
        vc.model = _model;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"http://47.243.193.90:8064/chat/A1test@A1.com"];
    vc.sysAccount = _model.uccAccount;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
