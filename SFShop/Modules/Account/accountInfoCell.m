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


@interface accountInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UIView *WhishlistView;
@property (weak, nonatomic) IBOutlet UIView *RecentlyViewedView;
@property (weak, nonatomic) IBOutlet UILabel *WhishlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *RecentlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

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
    [self updateData];
}
- (void)updateData
{
    UserModel *model = [[FMDBManager sharedInstance] queryUserWith:@"hxf01@qq.com"];
    @weakify(self)
    [RACObserve(model, userName) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.nameLabel.text = model.userName;
    }];
    [RACObserve(model, userRes) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Host,model.userRes.photo]]];
    }];
}
- (void)userInfoAction
{
    changeUserInfoVC *vc = [[changeUserInfoVC alloc] init];
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
@end
