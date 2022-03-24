//
//  UserReceiveCouponView.m
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import "UserReceiveCouponView.h"
#import "UserReceiveCouponCell.h"


@interface UserReceiveCouponView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation UserReceiveCouponView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [_bgView addGestureRecognizer:tap];
    _label1.text = kLocalizedString(@"LOGIN_SUCCESS");
    _label2.text = kLocalizedString(@"REGISTRATION_COUPON_HINT");
    [_collectionView registerNib:[UINib nibWithNibName:@"UserReceiveCouponCell" bundle:nil] forCellWithReuseIdentifier:@"UserReceiveCouponCell"];
    _collectionView.delegate = self;_collectionView.dataSource = self;
    [_collectionView reloadData];
}
- (void)removeSelf
{
    [self removeFromSuperview];
}
- (void)setDataSource:(NSArray<CouponModel *> *)dataSource
{
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (IBAction)btnAction:(id)sender {
    [self removeFromSuperview];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserReceiveCouponCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserReceiveCouponCell" forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    return cell;
}


@end
