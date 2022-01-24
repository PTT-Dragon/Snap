//
//  RefundDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundDetailViewController.h"
#import "RefundProcessCell.h"
#import "refundModel.h"
#import "RefundDetailTitleCell.h"
#import "RefundDetailMethodCell.h"
#import "RefundDetailProductInfoCell.h"
#import "OrderListItemCell.h"
#import "RefundDetailImagesCell.h"

@interface RefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (nonatomic,strong) RefundDetailModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation RefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Service_Detail");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundProcessCell" bundle:nil] forCellReuseIdentifier:@"RefundProcessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailTitleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailMethodCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailMethodCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailProductInfoCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailProductInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailImagesCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailImagesCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RefundDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailTitleCell"];
            [cell setContent:self.model type:1];
            return cell;
        }else if (indexPath.row == self.model.memos.count+1){
            RefundDetailMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailMethodCell"];
            cell.model = self.model;
            return cell;
        }
        RefundProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundProcessCell"];
        [cell setContent:self.model.memos[indexPath.row-1] hideView:indexPath.row != 1];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            RefundDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailTitleCell"];
            [cell setContent:self.model type:2];
            return cell;
        }else if (indexPath.row == self.model.items.count+1){
            RefundDetailProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailProductInfoCell"];
            cell.model = self.model;
            return cell;
        }else{
            OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
            [cell setRefundContent:self.model.items[indexPath.row-1]];
            return cell;
        }
    }
    RefundDetailImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailImagesCell"];
    cell.content = self.model.contents;
    cell.canSel = YES;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.model.memos.count+2: section == 1 ? self.model.items.count+2:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hei = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            hei = 40;
        }else if(indexPath.row == self.model.memos.count+1){
            hei = [self.model.eventId isEqualToString:@"3"] ? 0: 75;
        }else{
            hei = 75;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            hei = 40;
        }else if (indexPath.row == self.model.items.count+1){
            return 255;
        }else{
            hei = 118;
        }
    }else{
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        hei = self.model.items.count < 4 ? itemHei+68: self.model.items.count < 8 ? 2*itemHei+73: 3* itemHei + 78;
    }
    return hei;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 13)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateView
{
    if ([self.model.state isEqualToString:@"A"]) {
        [self.btn setTitle:kLocalizedString(@"CANCEL") forState:0];
        self.btn.hidden = NO;
        self.btnWidth.constant = MainScreen_width-32;
        self.btn2.hidden = YES;
        self.btn.height = 46;
    }else if ([self.model.state isEqualToString:@"C"]){
        [self.btn setTitle:kLocalizedString(@"CANCEL") forState:0];
        [self.btn2 setTitle:kLocalizedString(@"Delivery") forState:0];
        self.btn.hidden = NO;
        self.btnWidth.constant = (MainScreen_width-32)/2-16;
        self.btn2.hidden = NO;
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.btn.mas_top).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.refund getDetailOf:self.orderApplyId] parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [RefundDetailModel yy_modelWithDictionary:response];
        NSArray *arr = self.model.memos;
        self.model.memos = [[arr reverseObjectEnumerator] allObjects];
        [self updateView];
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
