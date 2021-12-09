//
//  OrderListBottomCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListBottomCell.h"
#import "CancelOrderViewController.h"
#import "PublicWebViewController.h"
#import "PDFReader.h"

@interface OrderListBottomCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak,nonatomic) OrderModel *model;

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
    _model = model;
    _countLabel.text = [NSString stringWithFormat:@"%ld products",model.orderItems.count];
    _amountLabel.text = [NSString stringWithFormat:@"RP %@",model.orderPrice];
    [_btn1 setTitle:[self getBtn1StrWithState:model.state] forState:0];
    [_btn2 setTitle:[self getBtn2StrWithState:model.state] forState:0];
}
- (IBAction)btn1Action:(UIButton *)sender {
    NSString *str = sender.titleLabel.text;
    if ([str isEqualToString:@"CONFIRM"]) {
        //确认订单收货
        MPWeakSelf(self)
        NSString *a = [self arrayToJSONString:@[_model.orderId]];
        [SFNetworkManager post:SFNet.order.confirmOrder parameters:@{@"orderIds":a} success:^(id  _Nullable response) {
            [weakself.delegate refreshDatas];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (IBAction)btn2Action:(UIButton *)sender {
    NSString *str = sender.titleLabel.text;
    if ([str isEqualToString:@"CANCEL"]) {
        //取消订单
        CancelOrderViewController *vc = [[CancelOrderViewController alloc] init];
        vc.model = _model;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:@"RECEIPT"]){
        [PDFReader readPDF:[SFNet.h5 getReceiptOf:_model.orderId] complete:^(NSError * _Nullable error, NSURL * _Nullable fileUrl) {
            //返回错误和本地地址
        }];
//
//        PublicWebViewController *vc = [[PublicWebViewController alloc] init];
//        vc.url = [SFNet.h5 getReceiptOf:_model.orderId];
//        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonTemp;
}
- (NSString *)getBtn1StrWithState:(NSString *)state
{
    NSString *str;
    if ([state isEqualToString:@"A"]) {
        str = @"PAY NOW";
    }else if ([state isEqualToString:@"B"]){
        str = @"RE-BUY";
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
        str = @"RECEIPT";
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
