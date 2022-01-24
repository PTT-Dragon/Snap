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
#import "CancelOrderChooseReason.h"
#import "RefundDetailImagesCell.h"
#import "RefundOrReturnExplainCell.h"
#import "RefundViewController.h"

@interface RefundOrReturnViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseReasonViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
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
- (void)layoutSubviews
{
    NSString *reasonTitle = _type == RETURNTYPE ? @"Return": _type == REFUNDTYPE ? @"Refund":@"Change";
    self.title = kLocalizedString(reasonTitle);
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CancelOrderChooseReason" bundle:nil] forCellReuseIdentifier:@"CancelOrderChooseReason"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailImagesCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailImagesCell"];
    [_tableView registerClass:[RefundOrReturnExplainCell class] forCellReuseIdentifier:@"RefundOrReturnExplainCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
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
            [cell setOrderDetailContent:_model];
            return cell;
        }else if (indexPath.row == _model.orderItems.count+1){
            CancelOrderChooseReason *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderChooseReason"];
            cell.reasonLabel.text = kLocalizedString(@"PLEASE_SELECT");//_selReasonModel ? _selReasonModel.orderReasonName : @"Cancellation Reason";
            return cell;
        }else if (indexPath.row == _model.orderItems.count + 2){
            RefundOrReturnExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundOrReturnExplainCell"];
            cell.chargeModel = self.chargeModel;
            cell.type = self.type;
            cell.block = ^(NSString * _Nonnull text) {
                self.questionDesc = text;
            };
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setContent:_model.orderItems[indexPath.row-1]];
        return cell;
    }
    
    RefundDetailImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailImagesCell"];
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
    return section == 0 ? _model.orderItems.count+3 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  indexPath.row == 0 ? 40 : indexPath.row == 1+_model.orderItems.count ? 60: indexPath.row == 2 + _model.orderItems.count ? self.type == REPLACETYPE ? 66: 92:  118;
    }
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _model.orderItems.count+1) {
        ChooseReasonViewController *vc = [[ChooseReasonViewController alloc] init];
        vc.dataSource = _reasonArr;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
                    
        }];
    }
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
        [MBProgressHUD autoDismissShowHudMsg:@"请选择原因"];
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
    [params setValue:[_model.orderItems.firstObject orderItemId] forKey:@"orderItemId"];
    [params setValue:@"1" forKey:@"refundMode"];
    [params setValue:serviceType forKey:@"serviceType"];
    [params setValue:self.chargeModel.refundCharge forKey:@"refundCharge"];
    [params setValue:self.selReasonModel.orderReasonId forKey:@"orderReasonId"];
    [params setValue:self.selReasonModel.orderReasonName forKey:@"orderReason"];
    [params setValue:self.questionDesc forKey:@"questionDesc"];
    [params setValue:self.imgUrlArr forKey:@"contents"];
    [params setValue:@"2" forKey:@"goodReturnType"];
    [params setValue:@"Y" forKey:@"receivedFlag"];
    [params setValue:@"3" forKey:@"contactChannel"];
    [params setValue:_model.offerCnt forKey:@"submitNum"];
    
    
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
