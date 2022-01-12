//
//  RefundOrReturnViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "RefundOrReturnViewController.h"
#import "ChooseReasonViewController.h"

@interface RefundOrReturnViewController ()
@property (nonatomic,strong) CancelOrderReasonModel *selReasonModel;
@end

@implementation RefundOrReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *reasonTitle = _type == RETURNTYPE ? @"Return": _type == REFUNDTYPE ? @"Refund":@"Change";
    self.title = kLocalizedString(reasonTitle);
    [self loadDatas];
}
- (void)loadDatas
{
    NSString *reasonId = _type == REFUNDTYPE ? @"3": _type == RETURNTYPE ? @"2":@"4";
    [SFNetworkManager get:[SFNet.order getReasonlOf:reasonId] parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
