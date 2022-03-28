//
//  CouponsViewController.m
//  SFShop
//
//  Created by MasterFly on 2022/1/3.
//

#import "CouponsViewController.h"
#import "CouponsCell.h"

#define KCouponsCellHeight 110
#define KCouponsCellFooter 13
#define KCouponsTitleHeight 50

@interface CouponsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite, strong) UIView *maskView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) UILabel *titleView;
@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self loadSubviews];
    [self snapSubviews];
    // Do any additional setup after loading the view.
}

- (void)loadSubviews {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleView];
}

- (void)snapSubviews {
    CGFloat tableHeight = self.dataArray.count * (KCouponsCellHeight + KCouponsCellFooter);
    _tableView.scrollEnabled = YES;
    if (tableHeight > MainScreen_height * 0.7) {
        tableHeight = MainScreen_height * 0.7;
    }else if (tableHeight < 200){
        tableHeight = 200;
        _tableView.scrollEnabled = NO;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(tableHeight);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.mas_equalTo(KCouponsTitleHeight);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell"];
    cell.item = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KCouponsCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KCouponsCellFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderHeaderView"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponItem *item = self.dataArray[indexPath.section];
    BOOL isSelected = item.isSelected;
    for (CouponItem *item in self.dataArray) {
        item.isSelected = NO;
    }
    item.isSelected = !isSelected;
    !self.selectedCouponBlock?:self.selectedCouponBlock(item.isSelected?item:nil);
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - Get and Set
- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_maskView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
    return _maskView;
}

- (UILabel *)titleView {
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.text = kLocalizedString(@"COUPONS");
        _titleView.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = BOLDSYSTEMFONT(16);
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:CouponsCell.class forCellReuseIdentifier:@"CouponsCell"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderHeaderView"];
    }
    return _tableView;
}

- (NSMutableArray<CouponItem *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
