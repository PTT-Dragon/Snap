//
//  LogisticsVC.m
//  SFShop
//
//  Created by 游挺 on 2022/1/18.
//

#import "LogisticsVC.h"
#import "ImageCollectionViewCell.h"
#import "UIButton+SGImagePosition.h"

@interface LogisticsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) OrderDetailLogisticsModel *logisticesModel;

@end

@implementation LogisticsVC
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"LOGISTICS_DETAILS");
    self.view.backgroundColor = RGBColorFrom16(0xf6f6f6);
    [self loadDatas];
    [self updateViews];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView reloadData];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    DeliveryInfoModel *deliveryModel = self.model.deliverys.firstObject;
    [SFNetworkManager get:[SFNet.order logisticsDetailWithId:[deliveryModel logisticsId] shippingNbr:[deliveryModel shippingNbr] deliveryId:[deliveryModel deliveryOrderId]] success:^(id  _Nullable response) {
        weakself.logisticesModel = [[OrderDetailLogisticsModel alloc] initWithDictionary:response error:nil];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateViews
{
    [self.btn setTitle:self.model.orderNbr forState:0];
    [self.btn SG_imagePositionStyle:SGImagePositionStyleRight spacing:5];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.orderItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([_model.orderItems[indexPath.row] imagUrl])]];
    return cell;
}
- (IBAction)btnAction:(UIButton *)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = sender.titleLabel.text;
    [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"COPY_SUCCESS")];
}


@end
