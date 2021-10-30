//
//  CartViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "CartViewController.h"
#import "addressModel.h"
#import "CartChooseAddressViewController.h"

@interface CartViewController ()
@property (nonatomic,strong) NSMutableArray *addressArr;
@property (nonatomic,strong) UIButton *addressBtn;
@property (nonatomic,weak) addressModel *selAddModel;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Shoppint Cart";
    _addressArr = [NSMutableArray array];
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        NSError *error;
        [weakself.addressArr addObjectsFromArray:[addressModel arrayOfModelsFromDictionaries:response error:&error]];
        weakself.selAddModel = weakself.addressArr.firstObject;
        weakself.selAddModel.sel = YES;
        [weakself initUI];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initUI
{
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBtn.frame = CGRectMake(0, navBarHei, MainScreen_width, 20);
    _addressBtn.backgroundColor = [UIColor whiteColor];
    _addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_addressBtn jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self toAddressListVC];
    }];
    [_addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@",_selAddModel.province,_selAddModel.city,_selAddModel.district,_selAddModel.street,_selAddModel.contactAddress] forState:0];
    [_addressBtn setTitleColor:RGBColorFrom16(0x7b7b7b) forState:0];
    _addressBtn.titleLabel.font = CHINESE_SYSTEM(13);
    [self.view addSubview:_addressBtn];
}
- (void)toAddressListVC
{
    CartChooseAddressViewController *vc = [[CartChooseAddressViewController alloc] init];
    vc.addressListArr = self.addressArr;
    vc.view.frame = CGRectMake(0, 0, self.view.jk_width, self.view.jk_height);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}




@end
