//
//  RefundCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundCell.h"

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

@end

@implementation RefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btn.layer.borderWidth = 1;
    _btn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
}
- (void)setContent:(refundModel *)model
{
    refundItemsModel *itemsModel = model.items.firstObject;
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeId)]];
    _storeNameLabel.text = model.storeName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemsModel.imagUrl)]];
    _nameLabel.text = itemsModel.productName;
    NSDictionary *dic = [itemsModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allKeys.firstObject];
    _countLabel.text = [NSString stringWithFormat:@"X%@",itemsModel.submitNum];
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",itemsModel.unitPrice];
    if ([model.state isEqualToString:@"B"]) {
        //拒绝
        _statuLabel.text = @"Rejection";
        _contentLabel.text = @"Refund is not supported for damaged goods";
        _viewHei.constant = 52;
        _btn.hidden = NO;
        _stateLabel.text = @"Refund";
    }else if ([model.state isEqualToString:@"A"]){
        //待审核
        _statuLabel.text = @"Pending Review";
        _contentLabel.text = @"";
        _viewHei.constant = 30;
        _btn.hidden = NO;
        _stateLabel.text = @"Refund";
    }else if ([model.state isEqualToString:@"A"]){
        //待填写物流信息
        _statuLabel.text = @"Waiting For Return";
        _contentLabel.text = @"";
        _viewHei.constant = 30;
        _btn.hidden = NO;
        _stateLabel.text = @"Refund";
    }else if ([model.state isEqualToString:@"E"]){
        //待退款
        _statuLabel.text = @"Waiting For Return";
        _contentLabel.text = [NSString stringWithFormat:@"%@",model.orderApplyCode];
        _viewHei.constant = 52;
        _btn.hidden = NO;
        _stateLabel.text = @"Refund";
    }else if ([model.state isEqualToString:@"X"]){
        //取消 作废
        _statuLabel.text = @"";
        _contentLabel.text = @"";
        _viewHei.constant = 0;
        _btn.hidden = YES;
        _stateLabel.text = @"Cancel";
    }else if ([model.state isEqualToString:@"G"]){
        //成功
        _statuLabel.text = @"Successful";
        _contentLabel.text = [NSString stringWithFormat:@"Refund :%@",model.refundCharge];
        _viewHei.constant = 0;
        _btn.hidden = YES;
        _stateLabel.text = @"Refund";
    }
}
@end
