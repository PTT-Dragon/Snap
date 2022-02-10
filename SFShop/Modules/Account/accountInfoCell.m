//
//  accountInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import "accountInfoCell.h"
#import "MyCouponViewController.h"
#import "changeUserInfoVC.h"
#import "RecentlyViewedViewController.h"
#import "setViewController.h"
#import "FavoriteViewController.h"
#import "LoginViewController.h"
#import "ZLPhotoBrowser.h"
#import "PublicWebViewController.h"
#import "MessageViewController.h"
#import "changeUserInfoVC.h"


@interface accountInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UIView *WhishlistView;
@property (weak, nonatomic) IBOutlet UIView *RecentlyViewedView;
@property (weak, nonatomic) IBOutlet UILabel *WhishlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *RecentlyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UILabel *noReadMessageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *wishLabel;
@property (weak, nonatomic) IBOutlet UILabel *vouchersLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewTop;

@end

@implementation accountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *couponTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponAction)];
    [_couponView addGestureRecognizer:couponTap];
    UITapGestureRecognizer *userInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
    [self.imgVIew addGestureRecognizer:userInfoTap];
    UITapGestureRecognizer *recentlyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recentlyAction)];
    [_RecentlyViewedView addGestureRecognizer:recentlyTap];
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteAction)];
    [_WhishlistView addGestureRecognizer:favoriteTap];
    
    UITapGestureRecognizer *nameLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameAction)];
    [_nameLabel addGestureRecognizer:nameLabelTap];
    self.noReadMessageCountLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.noReadMessageCountLabel.layer.borderWidth = 1;
    self.recentlyLabel.text = kLocalizedString(@"RECENTLY_VIEWED");
    self.wishLabel.text = kLocalizedString(@"WISHLIST");
    self.vouchersLabel.text = kLocalizedString(@"COUPONS");
    self.imgViewTop.constant = statuBarHei+16;
}
- (void)updateData
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model || [model.accessToken isEqualToString:@""]) {
        //登出状态
        self.nameLabel.text = kLocalizedString(@"Login_Or_Register");
        self.nameLabel.userInteractionEnabled = YES;
        self.nameLabel.font = BOLDSYSTEMFONT(16);
        self.imgVIew.image = [UIImage imageNamed:@"默认头像-黑"];
        self.couponLabel.text = @"--";
        self.WhishlistLabel.text = @"--";
        self.RecentlyCountLabel.text = @"--";
        self.mobileLabel.text = @"";
    }else{
        self.nameLabel.userInteractionEnabled = YES;
        self.nameLabel.text = model.userRes.nickName;
        self.nameLabel.font = kFontRegular(16);
        [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userRes.photo)] placeholderImage:[UIImage imageNamed:@"默认头像-黑"]];
        self.mobileLabel.text = model.userRes.mobilePhone;
        self.couponLabel.text = model.userRes.couponNum;
    }
}
- (void)setFavoriteCount:(NSInteger)favoriteCount
{
    _favoriteCount = favoriteCount;
    self.WhishlistLabel.text = [NSString stringWithFormat:@"%ld",favoriteCount];
}
- (void)setNoReadMessageCount:(NSInteger)noReadMessageCount
{
    _noReadMessageCount = noReadMessageCount;
    self.noReadMessageCountLabel.text = [NSString stringWithFormat:@"%ld",noReadMessageCount];
    self.noReadMessageCountLabel.hidden = noReadMessageCount == 0;
}
- (void)setRecentCount:(NSInteger)recentCount
{
    _recentCount = recentCount;
    self.RecentlyCountLabel.text = [NSString stringWithFormat:@"%ld",recentCount];
}
- (void)userInfoAction
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model) {
        MPWeakSelf(self)
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.didLoginBlock = ^{
            [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
            [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    [self uploadAvatar];
//    changeUserInfoVC *vc = [[changeUserInfoVC alloc] init];
//    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)favoriteAction
{
    FavoriteViewController *vc = [[FavoriteViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)recentlyAction
{
    RecentlyViewedViewController *vc = [[RecentlyViewedViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)couponAction
{
    MyCouponViewController *vc = [[MyCouponViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)nameAction
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model) {
        MPWeakSelf(self)
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.didLoginBlock = ^{
            [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
            [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    changeUserInfoVC *vc = [[changeUserInfoVC alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)setTabbarSel
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
}
//打开相册
-(void)uploadAvatar{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];

    // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 1;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.useSystemCamera = YES;
    ac.configuration.allowSelectVideo = NO;

    //如调用的方法无sender参数，则该参数必传
    ac.sender = self.jk_tabBarController;//[baseTool getCurrentVC];
    MPWeakSelf(self)
    // 选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        [weakself publishImgWithImage:images.firstObject];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}
- (void)publishImgWithImage:(UIImage *)image
{
    MPWeakSelf(self)
    [SFNetworkManager postImage:SFNet.h5.publishImg image:image success:^(id  _Nullable response) {
        [weakself modifyUserInfoWithFileName:response[@"fullPath"]];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)modifyUserInfoWithFileName:(NSString *)fileName
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.modify parameters:@{@"photo":fileName} success:^(id  _Nullable response) {
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        model.userRes.photo = fileName;
        [weakself updateData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)setAction:(id)sender {
    setViewController *vc = [[setViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)msgAction:(id)sender {
    MessageViewController *vc = [[MessageViewController alloc] init];
//    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
//    vc.url = @"https://www.smartfrenshop.com/message-center";
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
