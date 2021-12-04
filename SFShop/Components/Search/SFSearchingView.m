//
//  SFSearchingView.m
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import "SFSearchingView.h"
#import "SFSearchingCell.h"
#import "SFSearchingModel.h"

@interface SFSearchingView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@end

@implementation SFSearchingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadsubviews];
        [self composesubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self addSubview:self.tableView];
}

- (void)composesubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

#pragma mark - Request
- (void)requestAssociate:(NSString *)q {
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager get:SFNet.offer.suggest parameters:@{@"q":q} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in response) {
            SFSearchingModel *model = [SFSearchingModel yy_modelWithDictionary:dict];
            model.qStr = q;
            [self.dataArray addObject:model];
        }
        self.hidden = self.dataArray.count ? NO:YES;
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
    }];
}

- (void)reset {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.hidden = YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFSearchingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFSearchingCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFSearchingModel *model = self.dataArray[indexPath.row];
    if (self.selectedBlock) {
//        [self reset];
        self.selectedBlock(model.text);
    }
}

#pragma mark - Get and Set
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:SFSearchingCell.class forCellReuseIdentifier:@"SFSearchingCell"];
    }
    return _tableView;
}

@end
