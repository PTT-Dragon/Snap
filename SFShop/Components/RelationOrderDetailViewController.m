//
//  RelationOrderDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/4.
//

#import "RelationOrderDetailViewController.h"
#import "DistributorModel.h"

@interface RelationOrderDetailViewController ()
@property (nonatomic,strong) RelationOrderDetailModel *model;
@end

@implementation RelationOrderDetailViewController

- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDatas];
}
- (void)loadDatas
{
    [SFNetworkManager get:SFNet.distributor.orderDetail parameters:@{@"orderId":_orderId} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
