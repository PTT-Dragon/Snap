//
//  ProductCheckoutSeccessVc.m
//  SFShop
//
//  Created by 游挺 on 2022/1/19.
//

#import "ProductCheckoutSeccessVc.h"
#import "NSString+Fee.h"
#import "OrderDetailViewController.h"
#import "SceneManager.h"
#import "OrderModel.h"
#import "NSString+Fee.h"


@interface ProductCheckoutSeccessVc ()
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (nonatomic,strong) OrderGroupModel *groupModel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeShareBuyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needMemberCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *needTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *groupView;

@end

@implementation ProductCheckoutSeccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutsubviews];
    if (_GroupBuyGroupNbr) {
        [self loadGroupInfo];
    }
}
- (void)loadGroupInfo
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.groupbuy getGroupBuyGroupNbr:_GroupBuyGroupNbr] parameters:@{} success:^(id  _Nullable response) {
        weakself.groupModel = [OrderGroupModel yy_modelWithDictionary:response];
        [weakself layoutGroupView];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)layoutGroupView
{
    self.groupView.hidden = NO;
    self.addBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    self.addBtn.layer.borderWidth = 1;
    self.seeShareBuyBtn.layer.borderWidth = 1;
    self.seeShareBuyBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.groupModel.imgUrl)]];
    self.productNameLabel.text = self.groupModel.offerName;
    self.priceLabel.text = [self.groupModel.shareBuyOrderNbr currency];
}
- (void)layoutsubviews
{
    
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    _storeNameLabel.text = dic[@"storeName"];
    _codeLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"ORDER_CODE"),dic[@"orderNbr"]];
    _timeLabel.text = kLocalizedString(@"PAYMENT_TIME");
    _successLabel.text = kLocalizedString(@"PAYMENT_SUCCESS");
    _priceLabel.text = [[_infoDic[@"totalPrice"] stringValue] currency];
    [_detailBtn setTitle:kLocalizedString(@"SEE_DETAIL") forState:0];
}
- (IBAction)addGroupAction:(UIButton *)sender {
}
- (IBAction)seeShareBuyAction:(UIButton *)sender {
}

- (IBAction)detailAction:(UIButton *)sender {
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = dic[@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    [SceneManager transToHome];
}

@end
