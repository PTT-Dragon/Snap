//
//  changeUserInfoVC.m
//  SFShop
//
//  Created by 游挺 on 2021/10/18.
//

#import "changeUserInfoVC.h"
#import "userInfoGenderView.h"
#import "SWCenterDatePickerView.h"


@interface changeUserInfoVC ()<userInfoGenderViewDelegate,SWCenterDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic, strong) NSString *selectDateStr;
@end

@implementation changeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Personal_information");
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    _selectDateStr = model.userRes.birthdayDayStr;
    _gender = model.userRes.genderStr;
    _genderBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _genderBtn.layer.borderWidth = 1;
    _birthBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _birthBtn.layer.borderWidth = 1;
    [_birthBtn setTitle:[NSString stringWithFormat:@"  %@",_selectDateStr] forState:0];
    [_genderBtn setTitle:[NSString stringWithFormat:@"  %@",_gender] forState:0];
    _nameField.text = model.userRes.nickName;
}
- (void)selectWithSelectTime:(NSString *)selectTime withYear:(NSString *)year withMonth:(NSString *)month{
    self.selectDateStr = selectTime;
}

- (void)selectWithSelectTime:(NSString *)selectTime withYear:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day{
    self.selectDateStr = selectTime;
    [self.birthBtn setTitle:[NSString stringWithFormat:@"  %@",_selectDateStr] forState:0];
    
}
- (IBAction)birthAction:(id)sender {
    SWCenterDatePickerView *view = [[SWCenterDatePickerView alloc] initDatePickerViewWithType:DatePickerViewType_YMD Delegate:self];
    view.currentTime = self.selectDateStr;
    [view showDatePickerView];
}
- (IBAction)genderAction:(UIButton *)sender {
    userInfoGenderView *genderView = [[NSBundle mainBundle] loadNibNamed:@"userInfoGenderView" owner:self options:nil].firstObject;
    genderView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    genderView.delegate = self;
    [self.view addSubview:genderView];
}
- (IBAction)saveAction:(id)sender {
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_selectDateStr) {
        [params setValue:_selectDateStr forKey:@"birthdayDay"];
    }
    if (_gender) {
        [params setValue:_selectDateStr forKey:@"birthdayDay"];
    }
    [params setValue:_nameField.text forKey:@"nickName"];
    [SFNetworkManager post:SFNet.account.modify parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Set Successful"];
        [weakself loadUserInfo];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)loadUserInfo
{
    [SFNetworkManager get:SFNet.account.userInfo success:^(id  _Nullable response) {
        NSError *error;
        userResModel *resModel = [[userResModel alloc] initWithDictionary:response error:&error];
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        model.userRes = resModel;
        [[FMDBManager sharedInstance] updateUser:model ofAccount:model.account];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)chooseGender:(NSString *)gender
{
    _gender = gender;
    [_genderBtn setTitle:[gender isEqualToString:@"M"] ? @"  Male":[gender isEqualToString:@"F"] ? @"  Female":@"  Secrecy" forState:0];
}

@end
