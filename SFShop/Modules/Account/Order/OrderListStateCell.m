//
//  OrderListStateCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListStateCell.h"
#import "PublicWebViewController.h"
#import "UIButton+EnlargeTouchArea.h"

@interface OrderListStateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeIconImgview;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (nonatomic,strong) OrderDetailModel *orderDetailModel;
@end

@implementation OrderListStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_chatBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
}
- (void)setContent:(OrderModel *)model
{
    _storeNameLabel.text = model.storeName;
    [_storeIconImgview sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    _statuLabel.text = [model getStateStr];
}
- (void)setOrderDetailContent:(OrderDetailModel *)model
{
    _orderDetailModel = model;
    _storeNameLabel.text = model.storeName;
    _storeIconImgview.image = [UIImage imageNamed:@"toko"];
    _statuLabel.text = @"";
    _chatBtn.hidden = NO;
}
- (void)setRelationOrderDetailContent:(OrderDetailModel *)model
{
    _storeNameLabel.text = model.storeName;
    _storeIconImgview.image = [UIImage imageNamed:@"toko"];
    _statuLabel.text = @"";
}
- (IBAction)chatAction:(UIButton *)sender {
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"%@/chat/%@",Host,self.orderDetailModel.uccAccount];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.orderDetailModel yy_modelToJSONObject]];
    [dic setValue:@"101" forKey:@"cardType"];
    [dic addEntriesFromDictionary:[self.orderDetailModel.orderItems.firstObject toDictionary]];
    NSMutableArray *arr = [NSMutableArray array];
    for (orderItemsModel *itemModEl in self.orderDetailModel.orderItems) {
        NSDictionary *dic = [itemModEl toDictionary];
        [arr addObject:dic];
    }
    [dic setValue:@[] forKey:@"orderItems"];
    NSMutableArray *arr2 = [NSMutableArray array];
    for (OrderDetailPaymentsModel *itemModel in self.orderDetailModel.payments) {
        NSDictionary *dic = [itemModel toDictionary];
        [arr2 addObject:dic];
    }
    [dic setValue:arr2 forKey:@"payments"];
    [dic setValue:@"1" forKey:@"isService"];
    vc.productDic = dic;
    vc.sysAccount = _orderDetailModel.uccAccount;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    });
}
@end
