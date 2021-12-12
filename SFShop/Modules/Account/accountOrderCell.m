//
//  accountOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import "accountOrderCell.h"
#import "OrderViewController.h"
#import "UIButton+SGImagePosition.h"
#import "RefundViewController.h"

@interface accountOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *toShipCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *RatingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *toReceiveCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *toPayCountLabel;

@end

@implementation accountOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (UIView *subView in _bgView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView SG_imagePositionStyle:SGImagePositionStyleTop spacing:5];
        }
    }
    _toShipCountLabel.layer.borderWidth = 1;
    _toShipCountLabel.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    [self drawShadow];
}
- (void)setNumModel:(OrderNumModel *)numModel
{
    _numModel = numModel;
    _toShipCountLabel.text = numModel.toDeliveryNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",(long)numModel.toDeliveryNum];
    _toPayCountLabel.text = numModel.toDeliveryNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",(long)numModel.toPayNum];
    _toReceiveCountLabel.text = numModel.toDeliveryNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",(long)numModel.toReceiveNum];
    _RatingCountLabel.text = numModel.toDeliveryNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",(long)numModel.toRatingNum];
    _returnCountLabel.text = numModel.toDeliveryNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",(long)numModel.returnsNum];
}
- (void)drawShadow
{
    _bgView.layer.masksToBounds = NO;//默认值为NO。不能设置为YES，否则阴影无法出现。
    _bgView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 4;//阴影圆角
    _bgView.layer.shadowOffset = CGSizeMake(5, 0);    //阴影偏移量。有值是向下向右偏移。
    
    
    /*
     * 默认值：(0,-3)向上偏移。
     原因：阴影最先在mac平台实现，默认是向下偏移3。但由于iOS和macOS的Y轴相反，所以，iOS是向上偏移3.
     
     设置为：(0,0)，四周都有阴影。
     */
    //阴影路径
    _bgView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds cornerRadius:_bgView.layer.cornerRadius].CGPath;
}
- (IBAction)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            OrderViewController *vc = [[OrderViewController alloc] init];
            vc.selType = OrderListType_All;
            [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1006:
        {
            RefundViewController *vc = [[RefundViewController alloc] init];
            [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
