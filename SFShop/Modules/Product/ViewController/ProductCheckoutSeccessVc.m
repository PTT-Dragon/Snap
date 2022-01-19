//
//  ProductCheckoutSeccessVc.m
//  SFShop
//
//  Created by 游挺 on 2022/1/19.
//

#import "ProductCheckoutSeccessVc.h"
#import "NSString+Fee.h"
#import "OrderDetailViewController.h"

@interface ProductCheckoutSeccessVc ()
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end

@implementation ProductCheckoutSeccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)layoutsubviews
{
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    _storeNameLabel.text = dic[@"storeName"];
    _codeLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"ORDER_CODE"),dic[@"orderNbr"]];
    _timeLabel.text = @"";
    _successLabel.text = kLocalizedString(@"PAYMENT_SUCCESS");
    _priceLabel.text = [_infoDic[@"orderPrice"] currency];
}

- (IBAction)detailAction:(UIButton *)sender {
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = dic[@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    
}

@end
