//
//  CartChooseAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChooseAddressViewController.h"
#import "CartChooseAddressCell.h"
#import "ChooseAreaViewController.h"
#import "LastSelAddressModel.h"

@interface CartChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseAreaViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHei;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CartChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = kLocalizedString(@"SHIP_TO");
    [self.btn setTitle:kLocalizedString(@"CHOOSE_ANOTHER_ADDRESS") forState:0];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CartChooseAddressCell" bundle:nil] forCellReuseIdentifier:@"CartChooseAddressCell"];
    self.tableViewHei.constant = self.addressListArr.count * 66;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self.view addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
    [self.bgView addGestureRecognizer:tap2];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    addressModel *model = self.addressListArr[indexPath.row];
    if (self.selBlock) {
        self.selBlock(model);
        [self closeAction:nil];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartChooseAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartChooseAddressCell"];
    [cell setContent:self.addressListArr[indexPath.row]];
    MPWeakSelf(self)
    cell.selBlock = ^(addressModel *model) {
        if (weakself.selBlock) {
            weakself.selBlock(model);
            [weakself closeAction:nil];
        }
    };
    return cell;
}
- (void)removeSelf
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)nothing
{
    
}

- (IBAction)closeAction:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)anotherAddressAction:(UIButton *)sender {
    
    ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
    vc.delegate = self;
    LastSelAddressModel *lastModel = [LastSelAddressModel sharedLastSelAddressModel];
    if (lastModel.addrPath && ![lastModel.addrPath isEqualToString:@""]) {
        //先看是否有缓存的上一次选择地址单例
        AreaModel *provinceModel = [[AreaModel alloc] init];
        provinceModel.stdAddrId = lastModel.provinceId;
        provinceModel.stdAddr = lastModel.province;
        AreaModel *cityModel = [[AreaModel alloc] init];
        cityModel.stdAddrId = lastModel.cityId;
        cityModel.stdAddr = lastModel.city;
        AreaModel *districtModel = [[AreaModel alloc] init];
        districtModel.stdAddrId = lastModel.districtId;
        districtModel.stdAddr = lastModel.district;
        AreaModel *streetModel = [[AreaModel alloc] init];
        streetModel.stdAddrId = lastModel.streetId;
        streetModel.stdAddr = lastModel.street;
        vc.selProvinceAreaMoel = provinceModel;
        vc.selCityAreaMoel = cityModel;
        vc.selDistrictAreaMoel = districtModel;
        vc.selStreetAreaMoel = streetModel;
        vc.type = 6;
    }else{
        __block addressModel *selAddModel;
        [self.addressListArr enumerateObjectsUsingBlock:^(addressModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.sel == YES) {
                selAddModel = obj;
            }
        }];
        if (selAddModel) {
            AreaModel *provinceModel = [[AreaModel alloc] init];
            provinceModel.stdAddrId = selAddModel.provinceId;
            provinceModel.stdAddr = selAddModel.province;
            AreaModel *cityModel = [[AreaModel alloc] init];
            cityModel.stdAddrId = selAddModel.cityId;
            cityModel.stdAddr = selAddModel.city;
            AreaModel *districtModel = [[AreaModel alloc] init];
            districtModel.stdAddrId = selAddModel.districtId;
            districtModel.stdAddr = selAddModel.district;
            AreaModel *streetModel = [[AreaModel alloc] init];
            streetModel.stdAddrId = selAddModel.streetId;
            streetModel.stdAddr = selAddModel.street;
            vc.selProvinceAreaMoel = provinceModel;
            vc.selCityAreaMoel = cityModel;
            vc.selDistrictAreaMoel = districtModel;
            vc.selStreetAreaMoel = streetModel;
            vc.type = 6;
        }else{
            vc.type =  3;
        }
    }
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - delegate
- (void)chooseProvince:(AreaModel *_Nullable)provinceModel city:(AreaModel *_Nullable)cityModel district:(AreaModel *_Nullable)districtModel street:(AreaModel * _Nullable)streetModel
{
    addressModel *model = [[addressModel alloc] init];
    model.province = provinceModel.stdAddr;
    model.city = cityModel.stdAddr;
    model.district = districtModel.stdAddr;
    model.street = streetModel.stdAddr;
    model.postCode = streetModel.zipcode;
    model.contactStdId = streetModel.stdAddrId;
    model.isNoAdd = YES;
    if (self.selBlock) {
        self.selBlock(model);
        [self closeAction:nil];
    }
}
@end
