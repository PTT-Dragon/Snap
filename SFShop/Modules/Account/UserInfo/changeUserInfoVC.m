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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic,copy) NSString *gender;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (nonatomic, strong) NSString *selectDateStr;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation changeUserInfoVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Personal_information");
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    _selectDateStr = model.userRes.birthdayDayStr;
    _gender = model.userRes.gender;
    _genderBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _genderBtn.layer.borderWidth = 1;
    _birthBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _birthBtn.layer.borderWidth = 1;
    [_birthBtn setTitle:[NSString stringWithFormat:@"  %@",_selectDateStr?_selectDateStr:@""] forState:0];
//    [_genderBtn setTitle:[NSString stringWithFormat:@"  %@",model.userRes.genderStr] forState:0];
    [self chooseGender:_gender];
    _nameField.text = model.userRes.nickName;
    _nameField.layer.borderWidth = 1;
    _explainLabel1.text = kLocalizedString(@"INCORRECT_NAME");
    _tipLabel1.text = kLocalizedString(@"NICKNAME");
    _nameField.placeholder = kLocalizedString(@"NICKNAME");
    self.nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    _tipLabel2.text = kLocalizedString(@"GENDER");
    _tipLabel3.text = kLocalizedString(@"DATEOFBIRTH");
    [_saveBtn setTitle:kLocalizedString(@"SAVEPROFILE") forState:0];
    _titleLabel.text = kLocalizedString(@"CONTACT_INFORMATION");
    _birthLabel.text = kLocalizedString(@"DATEOFBIRTH");
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
    genderView.generStr = _gender;
    [self.view addSubview:genderView];
}
- (IBAction)saveAction:(id)sender {
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_selectDateStr) {
        [params setValue:_selectDateStr forKey:@"birthdayDay"];
    }
    if (_gender) {
        [params setValue:_gender forKey:@"gender"];
    }
    if (self.nameField.text.length < 4 || self.nameField.text.length > 20) {
        _nameField.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        _tipLabel1.textColor = RGBColorFrom16(0xff1659);
        _explainLabel1.hidden = NO;
        _explainLabel1.textColor = RGBColorFrom16(0xff1659);
        return;
    }
    _explainLabel1.hidden = YES;
    _nameField.layer.borderColor = [UIColor blackColor].CGColor;
    _tipLabel1.textColor = RGBColorFrom16(0x7b7b7b);
    [params setValue:_nameField.text forKey:@"nickName"];
    [SFNetworkManager post:SFNet.account.modify parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Set Successful"];
        [weakself loadUserInfo];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
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
    [_genderBtn setTitle:[gender isEqualToString:@"M"] ? @"  Pria":[gender isEqualToString:@"F"] ? @"  Wanita":@"  Memilih untuk tidak menjawab" forState:0];
}

@end
