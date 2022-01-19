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

@interface CouponCenterCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (nonatomic,strong) CouponModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
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
}
- (void)setContent:(CouponModel *)model
{
    _model = model;
    if ([model.discountMethod isEqualToString:@"DISC"]) {
        _discountLabel.text = [NSString stringWithFormat:@"%.0f %%",model.discountAmount/model.quantity];
    }else{
        _discountLabel.text = [[NSString stringWithFormat:@"%.0f",model.discountAmount] currency];
    }
    if (model.userCoupons.count > 0) {
        [self.getBtn setTitle:kLocalizedString(@"USE_NOW") forState:0];
    }else{
        [self.getBtn setTitle:kLocalizedString(@"GET_NOW") forState:0];
    }
    _storeNameLabel.text = model.storeName;
    _timeLabel.text = model.stateDate;
    _contentLabel.text = model.couponName;
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


- (IBAction)getAction:(UIButton *)sender {
    if (_model.userCoupons.count > 0) {
        UseCouponViewController *vc = [[UseCouponViewController alloc] init];
        vc.couponModel = _model;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    [SFNetworkManager post:SFNet.coupon.usercoupon parameters:@{@"couponId":_model.couponId} success:^(id  _Nullable response) {
        CouponAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:self options:nil].firstObject;
        view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        [[baseTool getCurrentVC].view addSubview:view];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
