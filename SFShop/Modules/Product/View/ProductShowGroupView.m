//
//  ProductShowGroupView.m
//  SFShop
//
//  Created by 游挺 on 2022/1/22.
//

#import "ProductShowGroupView.h"
#import "ProductShowGroupCell.h"

@interface ProductShowGroupView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation ProductShowGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self addGes];
    }
    return self;
}
- (void)addGes
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [self addGestureRecognizer:tap];
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
    [self.bgView addGestureRecognizer:tap2];
}
- (void)remove
{
    [self removeFromSuperview];
}
- (void)nothing
{
    
}
- (void)initUI
{
    self.backgroundColor = RGBColorFrom16(0xf5f5f5);
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top).offset(42);
        make.height.mas_equalTo(self.dataSource.count * 60);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-35);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav_close"] forState:0];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self remove];
    }];
    [self.bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
        make.top.mas_equalTo(self.bgView.mas_top).offset(5);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = kLocalizedString(@"SHAREBUY");
    label.textColor = RGBColorFrom16(0x999999);
    label.font = CHINESE_SYSTEM(14);
    [self.bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(16);
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
    }];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = kLocalizedString(@"ONLY_SHOW_5_SHARE");
    label2.textColor = RGBColorFrom16(0x999999);
    label2.font = CHINESE_SYSTEM(14);
    [self.bgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(16);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-10);
    }];
}
- (void)setDataSource:(NSArray<ProductGroupListModel *> *)dataSource
{
    _dataSource = dataSource;
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top).offset(42);
        make.height.mas_equalTo(self.dataSource.count * 60);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-35);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductShowGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductShowGroupCell"];
    cell.model = self.dataSource[indexPath.row];
    cell.block = ^{
        
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ProductShowGroupCell" bundle:nil] forCellReuseIdentifier:@"ProductShowGroupCell"];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

@end
