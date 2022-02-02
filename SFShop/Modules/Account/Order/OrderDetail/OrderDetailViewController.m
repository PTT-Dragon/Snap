//
//  OrderDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "OrderDetailViewController.h"
#import "DeliveryInformationCell.h"
#import "DeliveryAddressCell.h"
#import "OrderPayInfoCell.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "OrderModel.h"
#import "OrderDetailGroupBuyCell.h"
#import "ChooseRefundViewController.h"
#import "NSString+Fee.h"
#import "CartViewController.h"
#import "LogisticsVC.h"
#import "CancelOrderViewController.h"
#import "PDFReader.h"
#import "CheckoutManager.h"
#import "UIViewController+Top.h"
#import "UIViewController+Top.h"
#import "SceneManager.h"
#import "PublicWebViewController.h"
#import "PublicAlertView.h"
#import "ReviewChildViewController.h"
#import "LogisticsVC.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import <OYCountDownManager/OYCountDownManager.h>
#import "OrderDetailTitleCell.h"
#import "ProductViewController.h"
#import "YCMenuView.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *orderInfoDataSource;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (nonatomic,strong) OrderDetailModel *model;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreActionBtn1;
@property (nonatomic,strong) OrderGroupModel *groupModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2Left;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *navMoreView;

@end

@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_navMoreView removeFromSuperview];
    _navMoreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_navMoreView];
    [_navMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"Order_details")];
    [kCountDownManager start];
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
    _dataSource = [NSMutableArray array];
    _orderInfoDataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryInformationCell" bundle:nil] forCellReuseIdentifier:@"DeliveryInformationCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:@"DeliveryAddressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderPayInfoCell" bundle:nil] forCellReuseIdentifier:@"OrderPayInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailGroupBuyCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailGroupBuyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailTitleCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DeliveryInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryInformationCell"];
        [cell setContent:self.model];
        return cell;
    }else if (indexPath.section == 1){
        DeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryAddressCell"];
        [cell setContent:self.model];
        return cell;
    }else if (indexPath.section == 2){
        OrderDetailGroupBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailGroupBuyCell"];
        cell.model = self.groupModel;
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
            [cell setOrderDetailContent:self.model];
            return cell;
        }else if (indexPath.row > self.model.orderItems.count){
            OrderPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
            [cell setContent:self.orderInfoDataSource[indexPath.row-self.model.orderItems.count-1]];
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setOrderContent:self.model.orderItems[indexPath.row-1] state:self.model.state];
        cell.block = ^{
            ChooseRefundViewController *vc = [[ChooseRefundViewController alloc] init];
            vc.row = indexPath.row-1;
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    if (indexPath.row == 0) {
        OrderDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTitleCell"];
        return cell;
    }
    OrderPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
    [cell setContent:self.dataSource[indexPath.row-1]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.model.deliverys.count == 0 ? 0: 1: section == 2 ? self.groupModel ? 1:0: section == 1 ? 1: section == 3 ? self.model.orderItems.count+1+self.orderInfoDataSource.count : self.dataSource.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 130: indexPath.section == 2 ? 156: indexPath.section == 1 ? 170: (indexPath.section == 3 && indexPath.row == 0) ? 40: (indexPath.section == 3 && indexPath.row>self.model.orderItems.count) ? 30: indexPath.section == 3 ? [self.model.state isEqualToString:@"D"] ? 170: 154:  30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width - 32, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        LogisticsVC *vc = [[LogisticsVC alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3 && indexPath.row != 0 && !(indexPath.row >= self.model.orderItems.count+1)){
        orderItemsModel *model = self.model.orderItems[indexPath.row-1];
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = model.offerId.integerValue;
        vc.productId = model.productId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)loadDatas
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",SFNet.order.list,_orderId];
    MPWeakSelf(self)
    [SFNetworkManager get:url parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [[OrderDetailModel alloc] initWithDictionary:response error:nil];
        [weakself handleDatas];
        if (weakself.model.shareBuyOrderId && ![weakself.model.state isEqualToString:@"E"]) {
            //需要加载团购信息
            [weakself loadGroupDatas];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
//团购数据
- (void)loadGroupDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.groupbuy getGroupBuyGroupNbr:_model.shareBuyOrderNbr] parameters:@{} success:^(id  _Nullable response) {
        weakself.groupModel = [OrderGroupModel yy_modelWithDictionary:response];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)handleDatas
{
    OrderDetailPaymentsModel *paymentModel = self.model.payments.firstObject;
    [_dataSource addObjectsFromArray:@[@{kLocalizedString(@"ORDER_CODE"):self.model.orderNbr},@{kLocalizedString(@"CREATION_TIME"):self.model.createdDate},@{kLocalizedString(@"PAYER_EMAIL"):self.model.billAddress.contactEmail},@{kLocalizedString(@"PAYMENT_TIME"):paymentModel ? paymentModel.paymentDate : @"--"},@{kLocalizedString(@"COMPLETION_TIME"):self.model.completionDate ? self.model.completionDate: @"--"}]];
    [_orderInfoDataSource addObjectsFromArray:@[@{kLocalizedString(@"SUBTOTAL"):[self.model.offerPrice currency]},@{kLocalizedString(@"PROMOTION"):[NSString stringWithFormat:@"%@",[self.model.storeCampaignPrice currency]]},@{kLocalizedString(@"SHIPPING_FEE"):[self.model.logisticsFee currency]},@{[NSString stringWithFormat:@"%@:%@ %@",kLocalizedString(@"Total"),self.model.offerCnt,kLocalizedString(@"ITEMS")]:[self.model.orderPrice currency]}]];
    [self.tableView reloadData];
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    self.moreBtn.hidden = !([_model.state isEqualToString:@"D"] || [_model.state isEqualToString:@"C"]);
    [self.moreActionBtn1 setTitle:kLocalizedString(@"REBUY") forState:0];
    if ([self.model.state isEqualToString:@"B"] || [self.model.state isEqualToString:@"E"]) {
        [self.btn1 setTitle:kLocalizedString(@"REBUY") forState:0];
        self.btn2.hidden = YES;
        [self.btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomView.mas_left).offset(16);
            make.right.mas_equalTo(self.bottomView.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.bottomView.mas_top).offset(11);
        }];
    }else if ([self.model.state isEqualToString:@"A"]){
        [self.btn1 setTitle:kLocalizedString(@"PAYNOW") forState:0];
        [self.btn2 setTitle:kLocalizedString(@"CANCEL") forState:0];
    }else if ([self.model.state isEqualToString:@"D"]){
        [self.btn1 setTitle:kLocalizedString(@"RECEIPT") forState:0];
        if ([_model.canEvaluate isEqualToString:@"Y"]) {
            [self.btn2 setTitle:kLocalizedString(@"REVIEW") forState:0];
        }else{
            [self.btn2 setTitle:@"VIEW_REVIEW" forState:0];
        }
        self.moreBtn.hidden = NO;
        self.btn2Left.constant = AdaptedWidth(150);
    }else if ([self.model.state isEqualToString:@"C"]){
        [self.btn1 setTitle:kLocalizedString(@"CONFIRM") forState:0];
        [self.btn2 setTitle:kLocalizedString(@"LOGISTICS") forState:0];
        self.moreBtn.hidden = NO;
        self.btn2Left.constant = AdaptedWidth(150);
    }
}
- (void)toCart
{
    CartViewController *vc = [[CartViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)rebuy
{
    [MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    [self.model.orderItems enumerateObjectsUsingBlock:^(orderItemsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        NSDictionary *params =
        @{
            @"num": @(1),
            @"offerId": self.model.orderId,
            @"productId": obj.productId,
            @"storeId": self.model.storeId,
            @"unitPrice": obj.offerId,
            @"addon":@"",
            @"isSelected":@"Y",
            @"contactChannel":@"3"
        };
        
        [SFNetworkManager post:SFNet.cart.cart parameters:params success:^(id  _Nullable response) {
            @synchronized (response) {
                
            }
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            dispatch_group_leave(group);
            [MBProgressHUD hideFromKeyWindow];
            [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        [self toCart];
    });
}
- (IBAction)moreAction:(UIButton *)sender {
    @weakify(self);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:kLocalizedString(@"REBUY") image:nil handler:^(YCMenuAction *action) {
        @strongify(self);
        [self moreAction1:nil];
    }];
    YCMenuView *menu = [YCMenuView menuWithActions:@[action1] width:114 relyonView:sender];
    menu.textFont = [UIFont systemFontOfSize:14];
    menu.cellAlignment = NSTextAlignmentCenter;
    [menu show];
}
- (IBAction)moreAction1:(UIButton *)sender {
    [self rebuy];
}
- (IBAction)btn1Action:(UIButton *)sender {
    NSString *state = _model.state;
    if ([state isEqualToString:@"A"]) {
        if (!self.model.orderId.length) {
            return;
        }
        //付款
        /**
         shareBuyOrderNbr 这里有更新  不知是否适配
         **/
        NSString *shareBuyOrderNbr = self.model.shareBuyOrderNbr;
        [CheckoutManager.shareInstance startPayWithOrderIds:@[self.model.orderId] shareBuyOrderNbr:shareBuyOrderNbr totalPrice:self.model.orderPrice complete:^(SFPayResult result, NSString * _Nonnull urlOrHtml, NSDictionary *response) {
            switch (result) {
                case SFPayResultSuccess:
                    [SceneManager transToHome];
                    break;
                case SFPayResultFailed:
                    break;
                case SFPayResultJumpToWebPay: {
                    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
                    vc.url = urlOrHtml;
                    vc.shouldBackToHome = YES;
                    [UIViewController.sf_topViewController.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
    }else if ([state isEqualToString:@"B"] || [state isEqualToString:@"E"] || [state isEqualToString:@"F"]){
        [self rebuy];
    }else if ([state isEqualToString:@"C"]){
        //确认订单收货
        MPWeakSelf(self)
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:@"Click Yes only if you have received the item" btnTitle:@"YES" block:^{
            [SFNetworkManager post:SFNet.order.confirmOrder parametersArr:@[weakself.model.orderId] success:^(id  _Nullable response) {
                [weakself.delegate refreshDatas];
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
            }];
        } btn2Title:@"Cancel" block2:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];
    }else if ([state isEqualToString:@"D"]){
        [PDFReader readPDF:[SFNet.h5 getReceiptOf:_model.orderId] complete:^(NSError * _Nullable error, NSURL * _Nullable fileUrl) {
            //返回错误和本地地址
        }];
    }
}
- (IBAction)btn2Action:(UIButton *)sender {
    NSString *state = _model.state;
    if ([state isEqualToString:@"F"] || [state isEqualToString:@"A"]) {
        //取消订单
        CancelOrderViewController *vc = [[CancelOrderViewController alloc] init];
        vc.model = _model;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([state isEqualToString:@"B"]){
        [PDFReader readPDF:[SFNet.h5 getReceiptOf:_model.orderId] complete:^(NSError * _Nullable error, NSURL * _Nullable fileUrl) {
            //返回错误和本地地址
        }];
    }else if ([state isEqualToString:@"D"]){
        ReviewChildViewController *vc = [[ReviewChildViewController alloc] init];
        vc.type = 0;
        vc.showNav = NO;
        vc.orderItemId = self.model.orderNbr;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([state isEqualToString:@"C"]){
        [self toLogistices];
    }
}
- (void)toLogistices
{
    LogisticsVC *vc = [[LogisticsVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
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
