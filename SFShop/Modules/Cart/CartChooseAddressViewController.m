//
//  CartChooseAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChooseAddressViewController.h"
#import "CartChooseAddressCell.h"
#import "ChooseAreaViewController.h"

@interface CartChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseAreaViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHei;

@end

@implementation CartChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CartChooseAddressCell" bundle:nil] forCellReuseIdentifier:@"CartChooseAddressCell"];
    self.tableViewHei.constant = self.addressListArr.count * 66;
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

- (IBAction)closeAction:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)anotherAddressAction:(UIButton *)sender {
    ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
    vc.delegate = self;
    vc.type = 3;
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
    if (self.selBlock) {
        self.selBlock(model);
        [self closeAction:nil];
    }
}
@end
