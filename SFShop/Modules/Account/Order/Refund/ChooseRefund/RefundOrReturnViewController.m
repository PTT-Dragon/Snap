//
//  RefundOrReturnViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "RefundOrReturnViewController.h"
#import "ChooseReasonViewController.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "RefundOrReturnReasonCell.h"
#import "RefundDetailImagesCell.h"
#import "RefundOrReturnExplainCell.h"
#import "RefundViewController.h"
#import "BaseMoreView.h"
#import "BaseNavView.h"

@interface RefundOrReturnViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseReasonViewControllerDelegate,BaseNavViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BaseMoreView *navMoreView;
@property (nonatomic,strong) BaseNavView *navView;

@property (nonatomic,strong) CancelOrderReasonModel *selReasonModel;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (nonatomic,strong) NSMutableArray *imgUrlArr;//存放图片url数组
@property (nonatomic,copy) NSString *questionDesc;
@property (nonatomic,strong) NSMutableArray *reasonArr;
@end

@implementation RefundOrReturnViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutSubviews];
    [self loadReasonDatas];
}

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

- (void)layoutSubviews
{
    NSString *reasonTitle = _type == RETURNTYPE ? @"Return": _type == REFUNDTYPE ? @"Refund":@"EXCHANGE";
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(reasonTitle)];
    [self.btn setTitle:kLocalizedString(@"SUBMIT") forState:0];
    
    //self.title = kLocalizedString(reasonTitle);
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundOrReturnReasonCell" bundle:nil] forCellReuseIdentifier:@"RefundOrReturnReasonCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailImagesCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailImagesCell"];
    [_tableView registerClass:[RefundOrReturnExplainCell class] forCellReuseIdentifier:@"RefundOrReturnExplainCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
    self.reasonArr = [NSMutableArray array];
    self.imgArr = [NSMutableArray array];
    self.imgUrlArr = [NSMutableArray array];
}
- (void)setModel:(OrderDetailModel *)model
{
    _model = model;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
            [cell setRelationOrderDetailContent:_model];
            return cell;
        }else if (indexPath.row == 2){
            RefundOrReturnReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundOrReturnReasonCell"];
            [cell.selBtn setTitle:_selReasonModel ? _selReasonModel.orderReasonName:kLocalizedString(@"PLEASE_SELECT") forState:0];//_selReasonModel ? _selReasonModel.orderReasonName : @"Cancellation Reason";
            return cell;
        }else if (indexPath.row == 3){
            RefundOrReturnExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundOrReturnExplainCell"];
            cell.chargeModel = self.chargeModel;
            cell.type = self.type;
            cell.block = ^(NSString * _Nonnull text) {
                self.questionDesc = text;
            };
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setRefund2Content:_model.orderItems[_row]];
        return cell;
    }
    
    RefundDetailImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailImagesCell"];
    cell.canSel = NO;
    cell.block = ^(NSArray * _Nonnull imgArr) {
        self.imgArr = imgArr;
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  indexPath.row == 0 ? 40 : indexPath.row == 2 ? 60: indexPath.row == 3 ? self.type == REPLACETYPE ? 66: 92:  118;
    }
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        ChooseReasonViewController *vc = [[ChooseReasonViewController alloc] init];
        vc.dataSource = _reasonArr;
        vc.delegate = self;
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        vc.view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (void)loadReasonDatas
{
    NSString *reasonId = _type == REFUNDTYPE ? @"3": _type == RETURNTYPE ? @"2":@"4";
    [MBProgressHUD showHudMsg:kLocalizedString(@"loading")];
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.order getReasonlOf:reasonId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.reasonArr addObjectsFromArray:[CancelOrderReasonModel arrayOfModelsFromDictionaries:response error:nil]];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)chooseReason:(CancelOrderReasonModel *)model
{
    _selReasonModel = model;
    [self.tableView reloadData];
}

- (IBAction)submitAction:(UIButton *)sender {
    if (!_selReasonModel) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"REASON_TITLE")];
        return;
    }
    [self publishImg];
}
- (void)publishImg
{
    //先上传图片
    [self.imgUrlArr removeAllObjects];
    [MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    MPWeakSelf(self)
    __block NSInteger i = 0;
    for (id item in _imgArr) {
        if ([item isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            [SFNetworkManager postImage:SFNet.h5.publishImg image:item success:^(id  _Nullable response) {
                @synchronized (response) {
                    [weakself.imgUrlArr addObject:@{@"catgType":@"B",@"url":response[@"fullPath"],@"imgUrl":@"",@"seq":@(i),@"name":response[@"fileName"]}];
                    i++;
                }
                dispatch_group_leave(group);
            } failed:^(NSError * _Nonnull error) {
                dispatch_group_leave(group);
            }];
            
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        [self publishRefund];
    });
}
- (void)publishRefund
{
    NSString *serviceType = _type == RETURNTYPE ? @"2": _type == REPLACETYPE ? @"4": @"3";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.orderId forKey:@"orderId"];
    [params setValue:[_model.orderItems[_row] orderItemId] forKey:@"orderItemId"];
    [params setValue:@"1" forKey:@"refundMode"];
    [params setValue:serviceType forKey:@"serviceType"];
    if (_type != REPLACETYPE) {
        [params setValue:self.chargeModel.refundCharge forKey:@"refundCharge"];
    }else{
        [params setValue:@(0) forKey:@"refundCharge"];
    }
    [params setValue:self.selReasonModel.orderReasonId forKey:@"orderReasonId"];
    [params setValue:self.selReasonModel.orderReasonName forKey:@"orderReason"];
    [params setValue:self.questionDesc forKey:@"questionDesc"];
    [params setValue:self.imgUrlArr forKey:@"contents"];
    [params setValue:@"2" forKey:@"goodReturnType"];
    [params setValue:@"Y" forKey:@"receivedFlag"];
    [params setValue:@"3" forKey:@"contactChannel"];
    [params setValue:[_model.orderItems[_row] offerCnt] forKey:@"submitNum"];
    
    
    //{"orderId":25010,"orderItemId":24010,"refundMode":1,"serviceType":3,"refundCharge":80000,"submitNum":1,"orderReasonId":2,"orderReason":"尺码过大","questionDesc":"距离健健康康","goodReturnType":2,"contactChannel":3,"contents":[{"id":null,"catgType":"B","url":"/get/resource/ecs/20220119/picture/4CFF7CD0-1436-4963-9E93-F47AC677500C1483630588477521920.png","seq":1}],"receivedFlag":"Y"}
    /**
     {
         contactChannel = 3;
         contents =     ;
         goodReturnType = 2;
         orderId = 26009;
         orderItemId = 25009;
         orderReason = "\U5c3a\U7801\U8fc7\U5927";
         orderReasonId = 2;
         questionDesc = "\U63a5\U53e3";
         receivedFlag = Y;
         refundCharge = 100000;
         refundMode = 1;
         serviceType = 3;
     }

     **/
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.refund.refund parameters:params success:^(id  _Nullable response) {
        RefundViewController *vc = [[RefundViewController alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
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
