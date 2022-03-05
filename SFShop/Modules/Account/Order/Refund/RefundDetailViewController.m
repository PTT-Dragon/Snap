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
#import "DeliveryAddressCell.h"
#import "ReplaceDeliveryViewController.h"
#import "PublicAlertView.h"
#import "RefundBankViewController.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"

@interface RefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (nonatomic,strong) RefundDetailModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHei;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;
@end

@implementation RefundDetailViewController
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
    [_navView configDataWithTitle:kLocalizedString(@"Service_Detail")];
    self.btn2.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
    self.btn2.layer.borderWidth = 1;
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundProcessCell" bundle:nil] forCellReuseIdentifier:@"RefundProcessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailTitleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailMethodCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailMethodCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailProductInfoCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailProductInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailImagesCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailImagesCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:@"DeliveryAddressCell"];
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
        }else if (indexPath.row == self.model.showMemos.count+1){
            RefundDetailMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailMethodCell"];
            cell.model = self.model;
            return cell;
        }
        RefundProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundProcessCell"];
        [cell setContent:self.model.showMemos[indexPath.row-1] hideView:indexPath.row != 1 isLast:indexPath.row == self.model.showMemos.count];
        return cell;
    }else if (indexPath.section == 1){
        DeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryAddressCell"];
        [cell setRefundContent:self.model];
        return cell;
    }else if (indexPath.section == 2){
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
//            cell
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
    return self.model.contents.count > 0 ? 4: 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL hasDelivery = (([self.model.eventId isEqualToString:@"4"] || [self.model.eventId isEqualToString:@"2"]) && ([self.model.state isEqualToString:@"D"] || [self.model.state isEqualToString:@"C"] || [self.model.state isEqualToString:@"F"] || [self.model.state isEqualToString:@"E"] || [self.model.state isEqualToString:@"H"] || [self.model.state isEqualToString:@"G"])) ? YES: NO;
    return section == 0 ? self.model.showMemos.count+2: section == 1 ? hasDelivery ? 1 : 0: section == 2 ? self.model.items.count+2:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hei = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            hei = 40;
        }else if(indexPath.row == self.model.showMemos.count+1){
            hei = (![self.model.eventId isEqualToString:@"4"] && self.model.refund) ? 75 : 0;
        }else{
            hei = 75;
        }
    }else if (indexPath.section == 1){
        hei = 130;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            hei = 40;
        }else if (indexPath.row == self.model.items.count+1){
            return 235;
        }else{
            hei = 118;
        }
    }else{
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        hei = self.model.contents.count < 4 ? itemHei+68: self.model.contents.count < 8 ? 2*itemHei+73: 3* itemHei + 78;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
        [self.btn setTitle:kLocalizedString(@"DELIVERY") forState:0];
        [self.btn2 setTitle:kLocalizedString(@"CANCEL") forState:0];
        self.btn.hidden = NO;
        self.btnWidth.constant = (MainScreen_width-32)/2-8;
        self.btn2.hidden = NO;
    }else if ([self.model.state isEqualToString:@"X"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"D"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"E"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"F"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"B"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"I"]) {
        [self.btn setTitle:kLocalizedString(@"REFUND_BANK_ACCOUNT") forState:0];
        self.btn.hidden = NO;
        self.btnWidth.constant = MainScreen_width-32;
        self.btn2.hidden = YES;
        self.btn.height = 46;
    }else if ([self.model.state isEqualToString:@"G"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else if ([self.model.state isEqualToString:@"H"]){
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
    }else{
        self.btn.hidden = YES;
        self.btn2.hidden = YES;
        self.btnHei.constant = 0;
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
- (IBAction)btnAction:(UIButton *)sender {
    if ([_model.state isEqualToString:@"C"]) {
        ReplaceDeliveryViewController *vc = [[ReplaceDeliveryViewController alloc] init];
        vc.model = _model;
        vc.block = ^{
            [self loadDatas];
            if (self.block) {
                self.block();
            }
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([_model.state isEqualToString:@"A"]){
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"SURE_CANCEL") btnTitle:kLocalizedString(@"CONFIRM") block:^{
            [self cancelAction];
        } btn2Title:kLocalizedString(@"CANCEL") block2:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];
    }else if ([_model.state isEqualToString:@"I"]){
        RefundBankViewController *vc = [[RefundBankViewController alloc] init];
        vc.orderApplyId = _model.orderApplyId;
        vc.refundOrderId = _model.orderId;
        vc.block = ^{
            [self loadDatas];
            if (self.block) {
                self.block();
            }
        };
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)btn2Action:(UIButton *)sender {
    if ([_model.state isEqualToString:@"C"]){
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"SURE_CANCEL") btnTitle:kLocalizedString(@"CONFIRM") block:^{
            [self cancelAction];
        } btn2Title:kLocalizedString(@"CANCEL") block2:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];
    }
}
- (void)cancelAction
{
    [SFNetworkManager post:SFNet.refund.cancel parameters:@{@"orderApplyId":_model.orderApplyId} success:^(id  _Nullable response) {
        if (self.block) {
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
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
