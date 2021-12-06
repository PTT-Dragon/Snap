//
//  AddAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddAddressViewController.h"
#import "ChooseAreaViewController.h"

@interface AddAddressViewController ()<UITextFieldDelegate,ChooseAreaViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *officeBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong) AreaModel *selProvinceAreaMoel;
@property (nonatomic,strong) AreaModel *selCityAreaMoel;
@property (nonatomic,strong) AreaModel *selDistrictAreaMoel;
@property (nonatomic,strong) AreaModel *selStreetAreaMoel;
@property (weak, nonatomic) IBOutlet UIButton *selAgreementBtn;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Modify Address";
    _homeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _homeBtn.layer.borderWidth = 1;
    _officeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _officeBtn.layer.borderWidth = 1;
    _schoolBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _schoolBtn.layer.borderWidth = 1;
    _moreBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _moreBtn.layer.borderWidth = 1;
    _viewWidth.constant = MainScreen_width-32;
    _areaField.delegate = self;
    _streetField.delegate = self;
    if (_model) {
        //修改地址
        self.nameField.text = _model.contactName;
        self.phoneField.text = _model.contactNbr;
        self.areaField.text = [NSString stringWithFormat:@"%@,%@,%@",_model.district,_model.city,_model.province];
        self.streetField.text = [NSString stringWithFormat:@"%@,%@",_model.street,_model.postCode];
        self.detailField.text = _model.contactAddress;
        self.defaultSwitch.on = [_model.isDefault isEqualToString:@"Y"];
        self.selAgreementBtn.selected = YES;
    }else{
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _areaField) {
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
        vc.selProvinceAreaMoel = _selProvinceAreaMoel;
        vc.selCityAreaMoel = _selCityAreaMoel;
        vc.selDistrictAreaMoel = _selDistrictAreaMoel;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        return NO;
    }else if (textField == _streetField){
        if (!_selDistrictAreaMoel) {
            [MBProgressHUD autoDismissShowHudMsg:@"Please select the province first"];
            return NO;
        }
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
        vc.selProvinceAreaMoel = _selProvinceAreaMoel;
        vc.selCityAreaMoel = _selCityAreaMoel;
        vc.selDistrictAreaMoel = _selDistrictAreaMoel;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
                
        }];
        return NO;
    }
    return YES;
}

#pragma mark - delegate
- (void)chooseProvince:(AreaModel *)provinceModel city:(AreaModel *)cityModel district:(AreaModel *)districtModel
{
    _selProvinceAreaMoel = provinceModel;
    _selCityAreaMoel = cityModel;
    _selDistrictAreaMoel = districtModel;
    self.areaField.text = [NSString stringWithFormat:@"%@,%@,%@",districtModel.stdAddr,cityModel.stdAddr,provinceModel.stdAddr];
}
- (void)chooseStreet:(AreaModel *)streetModel
{
    _selStreetAreaMoel = streetModel;
    self.streetField.text = streetModel.stdAddr;
}
- (IBAction)selAgreementAction:(UIButton *)sender {
}

- (IBAction)saveAction:(UIButton *)sender {
    if (!_selAgreementBtn.selected) {
        [MBProgressHUD autoDismissShowHudMsg:@"Sel Agreement First"];
        return;
    }
    if (_model) {
        //修改地址
        [self modifyAction];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_phoneField.text forKey:@"contactNbr"];
    [params setValue:_nameField.text forKey:@"contactName"];
    [params setValue:_defaultSwitch.isOn ? @"Y":@"N"  forKey:@"isDefault"];
    [params setValue:_detailField.text forKey:@"contactAddress"];
    [params setValue:_selStreetAreaMoel.stdAddrId forKey:@"contactStdId"];
    [params setValue:_selStreetAreaMoel.zipcode forKey:@"postCode"];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.address.addressList parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
        [weakself.delegate addNewAddressSuccess];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)modifyAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_phoneField.text forKey:@"contactNbr"];
    [params setValue:_nameField.text forKey:@"contactName"];
    [params setValue:_defaultSwitch.isOn ? @"Y":@"N"  forKey:@"isDefault"];
    [params setValue:_detailField.text forKey:@"contactAddress"];
    [params setValue:_selStreetAreaMoel ? _selStreetAreaMoel.stdAddrId : _model.contactStdId forKey:@"contactStdId"];
    [params setValue:_selStreetAreaMoel ? _selStreetAreaMoel.zipcode : _model.postCode forKey:@"postCode"];
    [params setValue:_model.deliveryAddressId forKey:@"deliveryAddressId"];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.address setAddressModifyOfdeliveryAddressId:_model.deliveryAddressId] parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"MODIFY SUCCESS"];
        [weakself.delegate addNewAddressSuccess];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
