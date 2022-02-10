//
//  MyCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponCell.h"
#import "UseCouponViewController.h"
#import "NSString+Fee.h"
#import "NSDate+Helper.h"
#import "LoginViewController.h"
#import "CouponAlertView.h"

@interface MyCouponCell ()
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (nonatomic,weak) CouponModel *model;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useCouponAction)];
    [_statuLabel addGestureRecognizer:tap];
    _label1.text = kLocalizedString(@"DISCOUNT");
    _label2.text = kLocalizedString(@"EXPIRY_DATE");
    self.bgView.layer.borderColor = RGBColorFrom16(0xe7e7e7).CGColor;
    self.bgView.layer.borderWidth = 1;
}
- (void)setContent:(CouponModel *)model
{
    _model = model;
    _nameLabel.text = model.couponName;
//    if ([model.discountMethod isEqualToString:@"DISC"]) {
//        _nameLabel.text = [NSString stringWithFormat:@"%@ %.2f%% Min.spend %.2f",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currencyFloat],[[NSString stringWithFormat:@"%@",model.thAmount] currencyFloat]];
//    }else{
//        _nameLabel.text = [NSString stringWithFormat:@"%@ %@ Without limit",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency]];
//    }
    if (model.isGet) {
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.userCouponEffDate] dayMonthYear],[[NSDate dateFromString:model.userCouponExpDate] dayMonthYear]];
    }else{
        if (model.getOffsetExp) {
            _timeLabel.text = [NSString stringWithFormat:@"Valid within %@ days",model.getOffsetExp];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.effDate] dayMonthYear],[[NSDate dateFromString:model.expDate] dayMonthYear]];
        }
    }
    if ([model.userCouponState isEqualToString:@"C"]) {
        _statuLabel.text = kLocalizedString(@"EXPIRED");
    }else if ([model.userCouponState isEqualToString:@"B"]){
        _statuLabel.text = kLocalizedString(@"USED");
    }else if ([model.userCouponState isEqualToString:@"A"]){
        if (model.isGet) {
            _statuLabel.text = kLocalizedString(@"USE_NOW");
        }else{
            if (!model.isGet) {
                _statuLabel.text = kLocalizedString(@"USE_NOW");
            }else{
                _statuLabel.text = kLocalizedString(@"GET_NOW");
            }
        }
    }else if (!model.userCouponState){
        if (model.isGet) {
            _statuLabel.text = kLocalizedString(@"USE_NOW");
        }else{
            _statuLabel.text = kLocalizedString(@"GET_NOW");
        }
    }
//    if (model.isGet) {
//        _statuLabel.text = kLocalizedString(@"USE_NOW");
//    }else{
//        _statuLabel.text = !model.userCouponState ? kLocalizedString(@"USE_NOW"): [model.userCouponState isEqualToString:@"C"] ? kLocalizedString(@"EXPIRED"): [model.userCouponState isEqualToString:@"A"] ? kLocalizedString(@"USE_NOW"): kLocalizedString(@"USED");
//    }
    
    if (model.userCouponState) {
        _statuLabel.textColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
    }else{
        _statuLabel.textColor = RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = RGBColorFrom16(0xFF1659);
    }
    
}
- (void)useCouponAction
{
    UserModel *userModel = [FMDBManager sharedInstance].currentUser;
    if (!userModel) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([_statuLabel.text isEqualToString:kLocalizedString(@"USE_NOW")]) {
        UseCouponViewController *vc = [[UseCouponViewController alloc] init];
        vc.couponModel = _model;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([_statuLabel.text isEqualToString:kLocalizedString(@"GET_NOW")]){
        MPWeakSelf(self)
        [SFNetworkManager post:SFNet.coupon.usercoupon parameters:@{@"couponId":_model.couponId} success:^(id  _Nullable response) {
            self.model.isGet = YES;
            [self setModel:weakself.model];
            CouponAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:self options:nil].firstObject;
            view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
            [[baseTool getCurrentVC].view addSubview:view];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }
}
@end
