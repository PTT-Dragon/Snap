//
//  CartViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "CartViewController.h"
#import "addressModel.h"

@interface CartViewController ()
@property (nonatomic,strong) NSMutableArray *addressArr;
@property (nonatomic,strong) UIButton *addressBtn;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Shoppint Cart";
    _addressArr = [NSMutableArray array];
    [self initUI];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        [weakself.addressArr addObjectsFromArray:[addressModel arrayOfModelsFromDictionaries:response error:nil]];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initUI
{
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBtn.frame = CGRectMake(0, 0, MainScreen_width, 20);
    _addressBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addressBtn];
    
}


@end
