//
//  CouponCenterCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import "CouponCenterCell.h"
#import "CouponCenterCollectionViewCell.h"
#import "CouponAlertView.h"

@interface CouponCenterCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CouponCenterCollectionViewCell" forIndexPath:indexPath];
    return cell;
}


- (IBAction)getAction:(id)sender {
    CouponAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    [[baseTool getCurrentVC].view addSubview:view];
}
@end
