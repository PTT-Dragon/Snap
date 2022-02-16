//
//  CouponCenterCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import "CouponCenterCell.h"
#import "CouponCenterCollectionViewCell.h"
#import "CouponAlertView.h"
#import "NSString+Fee.h"
#import "UseCouponViewController.h"
#import "NSString+Add.h"
#import "NSDate+Helper.h"
#import "LoginViewController.h"
#import "UIButton+EnlargeTouchArea.h"
#import "PublicAlertView.h"

@interface CouponCenterCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (nonatomic,strong) CouponModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation CouponCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_collectionView registerNib:[UINib nibWithNibName:@"CouponCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CouponCenterCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
    _getBtn.titleLabel.numberOfLines = 0;
    [_ruleBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
}
- (void)setContent:(CouponModel *)model
{
    _model = model;
    if ([model.discountMethod isEqualToString:@"DISC"]) {
        _discountLabel.text =[NSString stringWithFormat:@"%.0f%% %@",[[NSString stringWithFormat:@"%.0f",model.discountAmount] currencyFloat],kLocalizedString(@"discount")];
        _discountLabel.attributedText = [NSMutableString difereentFontStr:_discountLabel.text font:kFontBlod(13) changeText:kLocalizedString(@"discount")];
        _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocalizedString(@"VALID_RANGE"),_model.getOffsetExp,kLocalizedString(@"hari")];
    }else{
        _discountLabel.text = [NSString stringWithFormat:@"%@ %@",[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency],kLocalizedString(@"discount")];
        _discountLabel.font = CHINESE_BOLD(14);
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.effDate] dayMonthYear],[[NSDate dateFromString:model.expDate] dayMonthYear]];
    }
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.storeLogo)] placeholderImage:[UIImage imageNamed:@"toko"]];
//    NSUInteger endTimeStamp = [[NSDate dateFromString:model.expDate] utcTimeStamp];
//    NSUInteger nowTimeStamp = [[NSDate date] utcTimeStamp];
    __block BOOL hasCoupon = NO;
//    NSInteger a = [[NSDate dateFromString:model.getDate] utcTimeStamp];
//    NSInteger b = [[NSDate dateFromString:model.getDate] utcTimeStamp];
//    NSInteger a = [[NSDate dateFromString:model.getDate] utcTimeStamp];
    [model.userCoupons enumerateObjectsUsingBlock:^(userCouponsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.transOrderId && ![obj.state isEqualToString:@"W"] && (!model.getOffsetExp || ([[NSDate dateFromString:obj.getDate] utcTimeStamp] + model.getOffsetExp.integerValue*86420 > [[NSDate date] utcTimeStamp]))) {
            hasCoupon = YES;
        }
    }];
    if (hasCoupon) {
        _model.isGet = YES;
        [self.getBtn setTitle:kLocalizedString(@"USE_NOW") forState:0];
    }else{
        _model.isGet = NO;
        [self.getBtn setTitle:kLocalizedString(@"GET_NOW") forState:0];
    }
//    if ([model.isOrderTh isEqualToString:@"Y"]) {
//        _contentLabel.text = [NSString stringWithFormat:@"Min.spend %@",[[NSString stringWithFormat:@"%@f",model.thAmount] currency]];
//    }else{
//        _contentLabel.text = [NSString stringWithFormat:@"%@ Without limit",[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency]];
//    }
    _contentLabel.text = model.couponName;
    _storeNameLabel.text = model.storeName ? model.storeName: @"Platform Voucher";
    
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.targetProduct.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CouponCenterCollectionViewCell" forIndexPath:indexPath];
    [cell setContent:_model.targetProduct[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UseCouponViewController *vc = [[UseCouponViewController alloc] init];
    vc.couponId = [_model.userCoupons.firstObject userCouponId];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (IBAction)getAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:kLocalizedString(@"USE_NOW")]) {
        UserModel *userModel = [FMDBManager sharedInstance].currentUser;
        if (!userModel) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            return;
        }
        UseCouponViewController *vc = [[UseCouponViewController alloc] init];
        vc.couponId = [_model.userCoupons.firstObject userCouponId];
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    [SFNetworkManager post:SFNet.coupon.usercoupon parameters:@{@"couponId":_model.couponId} success:^(id  _Nullable response) {
        CouponAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:self options:nil].firstObject;
        view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        [[baseTool getCurrentVC].view addSubview:view];
        if (self.block) {
            self.block();
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)ruleAction:(UIButton *)sender {
    NSString *rule = ([_model.useDesc isEqualToString:@""] || !_model.useDesc) ? kLocalizedString(@"NORULE"):_model.useDesc;
    PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"COUPON_DETAIL") content:rule btnTitle:kLocalizedString(@"GOT_IT") block:^{
        
    }];
    [[baseTool getCurrentVC].view addSubview:alert];
    
}
@end
