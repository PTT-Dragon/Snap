//
//  OrderListBottomCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListBottomCell.h"

@interface OrderListBottomCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation OrderListBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
}
- (void)setContent:(OrderModel *)model
{
    _countLabel.text = [NSString stringWithFormat:@"%ld products",model.orderItems.count];
    _amountLabel.text = [NSString stringWithFormat:@"RP %@",model.orderPrice];
    [_btn1 setTitle:[self getBtn1StrWithState:model.state] forState:0];
    [_btn2 setTitle:[self getBtn2StrWithState:model.state] forState:0];
}

- (NSString *)getBtn1StrWithState:(NSString *)state
{
    NSString *str;
    if ([state isEqualToString:@"A"]) {
        str = @"PAY NOW";
    }else if ([state isEqualToString:@"B"]){
        str = @"CONFIRM";
    }else if ([state isEqualToString:@"C"]){
        str = @"CONFIRM";
    }else if ([state isEqualToString:@"D"]){
        str = @"BUY AGAIN";
    }else if ([state isEqualToString:@"E"]){
        str = @"BUY AGAIN";
    }else if ([state isEqualToString:@"F"]){
        str = @"BUY NOW";
    }
    return str;
}
- (NSString *)getBtn2StrWithState:(NSString *)state
{
    NSString *str;
    if ([state isEqualToString:@"A"]) {
        str = @"CANCEL";
    }else if ([state isEqualToString:@"B"]){
        str = @"REVIEW";
    }else if ([state isEqualToString:@"C"]){
        str = @"REVIEW";
    }else if ([state isEqualToString:@"D"]){
        str = @"REVIEW";
    }else if ([state isEqualToString:@"E"]){
        str = @"REVIEW";
    }else if ([state isEqualToString:@"F"]){
        str = @"CANCEL";
    }
    return str;
}
@end
