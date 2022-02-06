//
//  RefundCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundCell.h"
#import "NSString+Fee.h"
#import "ReplaceDeliveryViewController.h"
#import "PublicAlertView.h"
#import "RefundBankViewController.h"

@interface RefundCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHei;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic,strong) refundModel *model;

@end

@implementation RefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btn.layer.borderWidth = 1;
    _btn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
}
- (void)setContent:(refundModel *)model
{
    _model = model;
    refundItemsModel *itemsModel = model.items.firstObject;
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeId)] placeholderImage:[UIImage imageNamed:@"toko"]];
    _storeNameLabel.text = model.storeName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemsModel.imagUrl)]];
    _nameLabel.text = itemsModel.productName;
    NSDictionary *dic = [itemsModel.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@ ",dic[key]];
    }
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",sku];
    _countLabel.text = [NSString stringWithFormat:@"X%@",itemsModel.submitNum];
    _priceLabel.text = [itemsModel.unitPrice currency];
    NSString *eventType = @"";
    if ([model.eventId isEqualToString:@"2"]) {
        _stateLabel.text = kLocalizedString(@"Return");
        eventType = kLocalizedString(@"Return");
    }else if ([model.eventId isEqualToString:@"3"]){
        _stateLabel.text = kLocalizedString(@"Refund");
        eventType = kLocalizedString(@"Refund");
    }else if ([model.eventId isEqualToString:@"4"]){
        _stateLabel.text = kLocalizedString(@"EXCHANGE");
        eventType = kLocalizedString(@"EXCHANGE");
    }
    if ([model.state isEqualToString:@"B"]) {
        //拒绝
        _statuLabel.text = kLocalizedString(@"Rejection");
        _contentLabel.text = kLocalizedString(@"REFUND_REJECTED_CONTENT");//kLocalizedString(@"return_tip");
        _viewHei.constant = 52;
        _btn.hidden = YES;
    }else if ([model.state isEqualToString:@"A"]){
        //待审核
        _statuLabel.text = kLocalizedString(@"Pending_Review");
        _contentLabel.text = @"Please wait patiently for review";
        _viewHei.constant = 52;
        _btn.hidden = NO;
        [_btn setTitle:kLocalizedString(@"CANCEL") forState:0];
    }else if ([model.state isEqualToString:@"E"]){
        //待退款
        _statuLabel.text = kLocalizedString(@"waitReturn_tip");
        _contentLabel.text = [NSString stringWithFormat:@"Wait for %@",eventType];//[NSString stringWithFormat:@"%@",model.orderApplyCode];
        _viewHei.constant = 52;
        _btn.hidden = YES;
    }else if ([model.state isEqualToString:@"X"]){
        //取消 作废
        _statuLabel.text = kLocalizedString(@"CANCELLED");
        _contentLabel.text = @"Service has been canceled";
        _viewHei.constant = 52;
        _btn.hidden = YES;
    }else if ([model.state isEqualToString:@"G"]){
        //成功
        _statuLabel.text = @"Successful";
        _contentLabel.text = [NSString stringWithFormat:@"Refund :%@",model.refundCharge];
        _viewHei.constant = 0;
        _btn.hidden = YES;
    }else if ([model.state isEqualToString:@"D"]){
        _statuLabel.text = @"In transit";
        _contentLabel.text = @"waiting for the merchant to receive the Package";
        _btn.hidden = YES;
        _btn2.hidden = YES;
    }else if ([model.state isEqualToString:@"F"]){
        _statuLabel.text = @"Refund in progress";
        _contentLabel.text = @"About 1 to 3 working days";
        _btn.hidden = YES;_btn2.hidden = YES;
    }else if ([model.state isEqualToString:@"C"]){
        //待填写物流信息
        _statuLabel.text = [NSString stringWithFormat:@"Wait for %@",eventType];
        _contentLabel.text = @"Please enter delivery informtion";
        _btn.hidden = NO;_btn2.hidden = NO;
        [_btn setTitle:kLocalizedString(@"Delivery") forState:0];
        [_btn2 setTitle:kLocalizedString(@"CANCEL") forState:0];
        _viewHei.constant = 52;
    }else if ([model.state isEqualToString:@"I"]){
        //待填写银行卡
        _statuLabel.text = @"Provide bank account";
        _contentLabel.text = @"refund bank account to be confirmed";
        _btn.hidden = NO;_btn2.hidden = YES;
        [_btn setTitle:kLocalizedString(@"REFUND_BANK_ACCOUNT") forState:0];
        _viewHei.constant = 52;
    }
}
- (void)cancelAction
{
    [SFNetworkManager post:SFNet.refund.cancel parameters:@{@"orderApplyId":_model.orderApplyId} success:^(id  _Nullable response) {
        if (self.block) {
            self.block();
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)btnAction:(UIButton *)sender {
    if ([_model.state isEqualToString:@"C"]) {
        ReplaceDeliveryViewController *vc = [[ReplaceDeliveryViewController alloc] init];
        vc.model = _model;
        vc.block = ^{
            if (self.block) {
                self.block();
            }
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([_model.state isEqualToString:@"A"]){
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"SURE_CANCEL") btnTitle:kLocalizedString(@"CONFIRM") block:^{
            [self cancelAction];
        } btn2Title:kLocalizedString(@"CANCEL") block2:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];
    }else if ([_model.state isEqualToString:@"I"]){
        RefundBankViewController *vc = [[RefundBankViewController alloc] init];
        vc.orderApplyId = _model.orderApplyId;
        vc.refundOrderId = _model.orderId;
        vc.block = ^{
            if (self.block) {
                self.block();
            }
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)btn2Action:(id)sender {
    if ([_model.state isEqualToString:@"C"]) {
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"SURE_CANCEL") btnTitle:kLocalizedString(@"CONFIRM") block:^{
            [self cancelAction];
        } btn2Title:kLocalizedString(@"CANCEL") block2:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];
    }
}
@end
