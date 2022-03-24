//
//  LoginViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "forgotPasswordView.h"
#import "LoginViaOTP.h"
#import "UITextField+expand.h"
#import "NSString+Fee.h"
#import <MJRefresh/MJRefresh.h>
#import "CartModel.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "NSString+Add.h"

@interface LoginViewController ()<UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIView *emailIndicationView;
@property (weak, nonatomic) IBOutlet UIView *phoneIndicationView;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic,assign) NSInteger type;//登录方式   1.手机登录  2.邮箱登录
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UIButton *OTPButton;
@property (nonatomic,strong) UIView *lfView;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;

@end

@implementation LoginViewController
static BOOL _accountSuccess = NO;
static BOOL _passwordSuccess = NO;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"LOGIN");
    [self layoutSubviews];
}

- (IBAction)facebookLogin:(id)sender {
    
//    if (@available(iOS 13.0, *)) {
//        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
//        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
//        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
//        ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
//        auth.delegate = self;
//        auth.presentationContextProvider = self;
//        [auth performRequests];
//    }
    FBSDKAccessToken *cur_asscessToken = [FBSDKAccessToken currentAccessToken];
    if(cur_asscessToken){//已经登录了
        NSLog(@"facebookLogin cur_asscessToken=%@",cur_asscessToken.userID);
        [SFNetworkManager post:SFNet.account.faceBookLogin parameters:@{@"accessToken":cur_asscessToken.tokenString} success:^(id  _Nullable response) {

        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
        [self getUserInfoWithResult:cur_asscessToken.userID];
    }else{//拉起facebook 授权
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        NSArray<NSString*> *permissions = @[@"public_profile"];
        [loginManager logInWithReadPermissions:permissions
                            fromViewController:self
                                       handler:^(FBSDKLoginManagerLoginResult *result,
                                                 NSError *error) {
            if (error) {
                NSLog(@"loginManager error=%@",error);
            } else if (result.isCancelled) {
                NSLog(@"loginManager 1 result=%@",result);
            } else {
                NSLog(@"loginManager 2 result=%@",result.token.userID);
                //result.token.userID
                [SFNetworkManager post:SFNet.account.faceBookLogin parameters:@{@"accessToken":result.token} success:^(id  _Nullable response) {

                } failed:^(NSError * _Nonnull error) {

                }];
                [self getUserInfoWithResult:result.token.userID];
            }
        }];
}
}

///代理主要用于展示在哪里
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.view;
}


-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        ASAuthorizationAppleIDCredential *apple = authorization.credential;
        ///将返回得到的user 存储起来
        NSString *userIdentifier = apple.user;
        NSPersonNameComponents *fullName = apple.fullName;
        NSString *email = apple.email;
        //用于后台像苹果服务器验证身份信息
        NSData *identityToken = apple.identityToken;
        
        
        NSLog(@"%@%@%@%@",userIdentifier,fullName,email,identityToken);
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        
        //// Sign in using an existing iCloud Keychain credential.
        ASPasswordCredential *pass = authorization.credential;
        NSString *username = pass.user;
        NSString *passw = pass.password;
        
    }
    
}

///回调失败
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"%@",error);
}


- (void)getUserInfoWithResult:(NSString *)userId {
    NSDictionary*params= @{@"fields":@"id,name,picture"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:userId
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"FBSDKGraphRequest = %@",result);
        NSDictionary *resultDict = (NSDictionary *)result;
        NSString *userName = resultDict[@"name"];
        NSString *url = resultDict[@"picture"][@"data"][@"url"];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:userId forKey:@"facebook_id"];
        [dictionary setValue:userName forKey:@"facebook_name"];
        [dictionary setValue:url forKey:@"facebook_photo"];
        
    }];
}

- (void)layoutSubviews
{
    _type = 1;
    self.facebookBtn.layer.borderWidth = 1;
    self.facebookBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.loginBtn.userInteractionEnabled = NO;
    self.passwordField.layer.borderWidth = 1;
    self.accountField.layer.borderWidth = 1;
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.label2.text = kLocalizedString(@"PASSWORD");
    self.passwordField.placeholder = kLocalizedString(@"PASSWORD");
    [self.forgetBtn setTitle:kLocalizedString(@"FORGOT_PWD") forState:0];
    [self.loginBtn setTitle:kLocalizedString(@"Login") forState:0];
//    [self.signUpBtn setTitle:[NSString stringWithFormat:@"%@%@",kLocalizedString(@"DONT_HAVE_ACCOUNT"),kLocalizedString(@"Sign_Up")] forState:0];
    NSMutableAttributedString *str = [NSMutableString difereentFontStr:[NSString stringWithFormat:@"%@ %@",kLocalizedString(@"DONT_HAVE_ACCOUNT"),kLocalizedString(@"Sign_Up")] font:kFontRegular(12) changeText:kLocalizedString(@"DONT_HAVE_ACCOUNT")];
    [self.signUpBtn setAttributedTitle:str forState:0];
    [self.OTPButton setTitle:kLocalizedString(@"LOGIN_VIA_OPT") forState:0];
    [self.phoneBtn setTitle:kLocalizedString(@"PHONE") forState:0];
    _label1.text = kLocalizedString(@"PHONE_NUMBER");
    _accountField.placeholder = kLocalizedString(@"PHONE_NUMBER");
    UIImage *im = [UIImage imageNamed:@"WX20220203-135232"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    _lfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    iv.center = _lfView.center;
    [_lfView addSubview:iv];
    _accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField.leftView = _lfView;
    self.passwordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _accountField) {
        _label1.hidden = [textField.text isEqualToString:@""];
        if (_type == 1) {
            _accountSuccess = ![textField.text isEqualToString:@""];//[textField textFieldState:CHECKPHONETYPE editType:EIDTTYPE labels:@[_label1]];
        }else{
            _accountSuccess = ![textField.text isEqualToString:@""];//[textField textFieldState:CHECKEMAILTYPE editType:EIDTTYPE labels:@[_label1]];
        }
    }else{
        _label2.hidden = [textField.text isEqualToString:@""];
        _passwordSuccess = ![textField.text isEqualToString:@""];//[textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label2]];
    }
    if (_accountSuccess && _passwordSuccess) {
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.loginBtn.userInteractionEnabled = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _accountField) {
        _label1.hidden = [textField.text isEqualToString:@""];
    }else{
        _label2.hidden = [textField.text isEqualToString:@""];
    }
//    if (textField == _accountField) {
//        if (_type == 1) {
//            _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:BEGINEDITTYPE labels:@[_label1]];
//        }else{
//            _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:BEGINEDITTYPE labels:@[_label1]];
//        }
//    }else if (textField == _passwordField){
//        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:BEGINEDITTYPE labels:@[_label2]];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _accountField) {
        _label1.hidden = [textField.text isEqualToString:@""];
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }else{
        _label2.hidden = [textField.text isEqualToString:@""];
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
//    if (textField == _accountField) {
//        if (_type == 1) {
//            _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:ENDEDITTYPE labels:@[_label1]];
//        }else{
//            _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:ENDEDITTYPE labels:@[_label1]];
//        }
//    }else if (textField == _passwordField){
//        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:ENDEDITTYPE labels:@[_label2]];
//    }
}
- (IBAction)phoneAction:(UIButton *)sender {
    _type = 1;
    sender.selected = YES;
    _tipLabel1.text = kLocalizedString(@"INCORRECT_PHONE");
    _accountField.text = @"";
    _passwordField.text = @"";
    _emailBtn.selected = NO;
    _phoneIndicationView.backgroundColor = [UIColor blackColor];
    _emailIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _label1.text = kLocalizedString(@"PHONE_NUMBER");
    _accountField.placeholder = kLocalizedString(@"PHONE_NUMBER");
    _accountField.leftView = _lfView;
}
- (IBAction)emailAction:(UIButton *)sender {
    _type = 2;
    _tipLabel1.text = kLocalizedString(@"PLEASE_INPUT_THE_CORRECT_EMAIL");
    _accountField.text = @"";
    _passwordField.text = @"";
    sender.selected = YES;
    _phoneBtn.selected = NO;
    _phoneIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _emailIndicationView.backgroundColor = [UIColor blackColor];
    _label1.text = kLocalizedString(@"Email");
    _accountField.placeholder = kLocalizedString(@"Email");
    _accountField.leftView = nil;
    self.accountField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
}
- (IBAction)loginAction:(id)sender {
    //wcttest1@qq.com/smart123  17366287044 Abc@1234  rx_dadoubi@sina.com/Abc@12345    A1customer@A1.com/Abc@1234  18861484865/Abc@1234  14700003515
    //在登录时候只校验是手机号还是邮箱
    if (_type == 1) {
        if (![self.accountField.text validatePhoneNumber]) {
            [MBProgressHUD showTopErrotMessage:kLocalizedString(@"INCORRECT_PHONE")];
            return;
        }
    }else{
        if (![self.accountField.text validateEmail]) {
            [MBProgressHUD showTopErrotMessage:kLocalizedString(@"INCORRECT_EMAIL")];
            return;
        }
    }
    MPWeakSelf(self)
    NSDictionary *param = @{@"account":_accountField.text,@"pwd":login_aes_128_cbc_encrypt(_passwordField.text)};
    [SFNetworkManager post:SFNet.account.login parameters:param success:^(id  _Nullable response) {
        NSError *error = nil;
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.accountField.text];
        if (model.userRes.defLangCode) {
            MJRefreshConfig.defaultConfig.languageCode = model.userRes.defLangCode ? model.userRes.defLangCode: @"id";
            if ([model.userRes.defLangCode isEqualToString:@"zh"]) {
                UserDefaultSetObjectForKey(kLanguageChinese, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageChinese];
            } else {
                UserDefaultSetObjectForKey(model.userRes.defLangCode, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:model.userRes.defLangCode];
            }
        }else{
            MJRefreshConfig.defaultConfig.languageCode = @"id";
            UserDefaultSetObjectForKey(@"id", @"Language");
            [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:@"id"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowUserReceiveCoupon" object:0];
        
        if (weakself.didLoginBlock)  {
            weakself.didLoginBlock();
        }
        [weakself addProductToCart];
    } failed:^(NSError * _Nonnull error) {
        weakself.loginBtn.userInteractionEnabled = NO;
        weakself.loginBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)signUpAction:(id)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgotAction:(id)sender {
    forgotPasswordView *view = [[NSBundle mainBundle] loadNibNamed:@"forgotPasswordView" owner:self options:nil].firstObject;
    view.type = resetType;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    [self.view addSubview:view];
}
- (IBAction)otpAction:(id)sender {
    LoginViaOTP *vc = [[LoginViaOTP alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)secureAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordField.secureTextEntry = sender.selected;
}

- (void)addProductToCart
{
    NSDictionary *aaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrayKey"];
    CartModel *cartModel = [[CartModel alloc] initWithDictionary:aaaaa error:nil];
    NSDictionary *dic;
    for (CartListModel *listModel in cartModel.validCarts) {
        for (CartItemModel *itemModel in listModel.shoppingCarts) {
            NSDictionary *params =
            @{
                @"num": itemModel.num,
                @"offerId": itemModel.offerId,
                @"productId": itemModel.productId,
                @"storeId": listModel.storeId,
                @"unitPrice": @(itemModel.salesPrice),
                @"contactChannel":@"3",
                @"addon":itemModel.addon,
                @"isSelected":@"N"
            };
            dic = [NSDictionary dictionaryWithDictionary:params];
            [SFNetworkManager post:SFNet.cart.cart parameters:dic success:^(id  _Nullable response) {
                [baseTool updateCartNum];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"arrayKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
