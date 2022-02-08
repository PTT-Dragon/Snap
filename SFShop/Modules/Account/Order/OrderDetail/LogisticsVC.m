//
//  LogisticsVC.m
//  SFShop
//
//  Created by 游挺 on 2022/1/18.
//

#import "LogisticsVC.h"
#import "ImageCollectionViewCell.h"
#import "UIButton+SGImagePosition.h"
#import "LogisticsCell.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"

@interface LogisticsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) OrderDetailLogisticsModel *logisticesModel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;

@end

@implementation LogisticsVC
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"LOGISTICS_DETAILS")];
    self.label.text = kLocalizedString(@"ORDER_CODE");//
    self.view.backgroundColor = RGBColorFrom16(0xf6f6f6);
    [self loadDatas];
    [self updateViews];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.collectionView reloadData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(0);
    }];
    
    self.topView.layer.masksToBounds = NO;//默认值为NO。不能设置为YES，否则阴影无法出现。
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.topView.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.topView.layer.shadowRadius = 3;//阴影圆角
    self.topView.layer.shadowOffset = CGSizeMake(0, 0);    //阴影偏移量。有值是向下向右偏移。
    self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, App_Frame_Width-32, self.topView.bounds.size.height) cornerRadius:self.topView.layer.cornerRadius].CGPath;
    
}
- (void)loadDatas
{
    MPWeakSelf(self)
    DeliveryInfoModel *deliveryModel = self.model.deliverys.firstObject;
    [SFNetworkManager get:[SFNet.order logisticsDetailWithId:[deliveryModel logisticsId] shippingNbr:[deliveryModel shippingNbr] deliveryId:[deliveryModel deliveryOrderId]] success:^(id  _Nullable response) {
        weakself.logisticesModel = [[OrderDetailLogisticsModel alloc] initWithDictionary:response error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logisticesModel.packageDetailList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageListModel *model = self.logisticesModel.packageDetailList[indexPath.row];
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    cell.label.text = [NSString stringWithFormat:@"%@%ld",kLocalizedString(@"PACKAGE"),indexPath.row+1];
    [cell.btn setTitle:[NSString stringWithFormat:@"%@ %@",model.subPkgLogisticsNbr,model.subPkgLogisticsName] forState:0];
    [cell layoutIfNeeded];
    [cell layoutSubviews];
    [cell.btn SG_imagePositionStyle:SGImagePositionStyleRight spacing:5];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:@"LogisticsCell" bundle:nil] forCellReuseIdentifier:@"LogisticsCell"];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
@end
