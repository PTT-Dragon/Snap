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

@interface accountInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UIView *WhishlistView;
@property (weak, nonatomic) IBOutlet UIView *RecentlyViewedView;
@property (weak, nonatomic) IBOutlet UILabel *WhishlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *RecentlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

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
}
- (void)updateData
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model || [model.accessToken isEqualToString:@""]) {
        //登出状态
        self.nameLabel.text = @"Login Or Register";
        self.nameLabel.userInteractionEnabled = YES;
    }else{
        self.nameLabel.userInteractionEnabled = NO;
        self.nameLabel.text = model.userName;
        [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userRes.photo)]];
    }
}
- (void)setCouponCount:(NSInteger)couponCount
{
    _couponCount = couponCount;
    self.couponLabel.text = [NSString stringWithFormat:@"%ld",couponCount];
}
- (void)setFavoriteCount:(NSInteger)favoriteCount
{
    _favoriteCount = favoriteCount;
    self.WhishlistLabel.text = [NSString stringWithFormat:@"%ld",favoriteCount];
}
- (void)setRecentCount:(NSInteger)recentCount
{
    _recentCount = recentCount;
    self.RecentlyLabel.text = [NSString stringWithFormat:@"%ld",recentCount];
}
- (void)userInfoAction
{
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
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.didLoginBlock = ^{
        [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
    };
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
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
    ac.sender = [baseTool getCurrentVC];
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
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    vc.url = @"https://www.smartfrenshop.com/message-center";
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
