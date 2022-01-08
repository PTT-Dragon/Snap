//
//  DeleveryViewController.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "DeleveryViewController.h"
#import "DeliveryCell.h"

#define KDeleveryCellHeight 110
#define KDeleveryCellFooter 13
#define KDeleveryTitleHeight 50

@interface DeleveryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite, strong) UIView *maskView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) UILabel *titleView;
@end

@implementation DeleveryViewController

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
    CGFloat tableHeight = self.dataArray.count * (KDeleveryCellHeight + KDeleveryCellFooter);
    if (tableHeight > MainScreen_height * 0.7) {
        tableHeight = MainScreen_height * 0.7;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(tableHeight);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.mas_equalTo(KDeleveryTitleHeight);
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
    DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCell"];
    cell.item = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KDeleveryCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KDeleveryCellFooter;
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
    [self dismissViewControllerAnimated:YES completion:^{
        OrderLogisticsItem *item = self.dataArray[indexPath.section];
        for (OrderLogisticsItem *item in self.dataArray) {
            item.isSelected = NO;
        }
        item.isSelected = YES;
        !self.selectedDeleveryBlock?:self.selectedDeleveryBlock(item.isSelected?item:nil);
    }];
}

#pragma mark - Get and Set
- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_maskView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _maskView;
}

- (UILabel *)titleView {
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.text = @"Delivery Method";
        _titleView.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = [UIFont boldSystemFontOfSize:16];
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
        [_tableView registerClass:DeliveryCell.class forCellReuseIdentifier:@"DeliveryCell"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderHeaderView"];
    }
    return _tableView;
}

- (NSMutableArray<OrderLogisticsItem *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
