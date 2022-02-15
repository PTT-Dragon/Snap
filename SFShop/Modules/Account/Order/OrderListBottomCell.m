//
//  OrderListBottomCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListBottomCell.h"
#import "CancelOrderViewController.h"
#import "PublicWebViewController.h"
#import "PDFReader.h"
#import "CartViewController.h"
#import "PublicAlertView.h"
#import "CheckoutManager.h"
#import "UIViewController+Top.h"
#import "SceneManager.h"
#import "NSString+Fee.h"
#import "LogisticsVC.h"
#import "ReviewChildViewController.h"
#import "AddReviewViewController.h"
#import "NSDate+Helper.h"
#import "AddReviewVC.h"
#import <OYCountDownManager/OYCountDownManager.h>
#import "YCMenuView.h"
#import "RefundOrReturnViewController.h"

@interface OrderListBottomCell ()
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak,nonatomic) OrderModel *model;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
//@property (nonatomic, strong) static dispatch_source_t timer;//倒计时
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreActionBtn1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1Hei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2Bottom;


@end

@implementation OrderListBottomCell

static dispatch_source_t _timer;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
    _btn1.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn1.layer.borderWidth = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    [_moreBtn setTitle:kLocalizedString(@"MORE") forState:0];
    _totalTitleLabel.text = [NSString stringWithFormat:@"%@:",kLocalizedString(@"Total")];

}
- (void)countDownNotification {
    /// 计算倒计时
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:_model.shareBuyBriefInfo.now];
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
    NSDate *expDate = [formatter dateFromString:_model.shareBuyBriefInfo.expDate];
    NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
    NSInteger timeout = expTimeInterval - timeInterval-kCountDownManager.timeInterval; // 倒计时时间
    if (timeout <= 0) {
          // 倒计时结束时回调
          
    }else{
        /// 重新赋值
        self.hourLabel.text = [NSString stringWithFormat:@"%02ld",timeout/3600];
        self.minuLabel.text = [NSString stringWithFormat:@"%02ld",(timeout/60)%60];
        self.secondLabel.text = [NSString stringWithFormat:@"%02ld",timeout%60];
    }
}
- (void)setContent:(OrderModel *)model
{
    _model = model;
    _countLabel.text = [NSString stringWithFormat:@"%ld %@",model.orderItems.count,kLocalizedString(@"ITEMS")];
    _amountLabel.text = [NSString stringWithFormat:@"%@",[model.orderPrice currency]];
    [_btn1 setTitle:[self getBtn1StrWithState:model.state] forState:0];
    [_btn2 setTitle:[self getBtn2StrWithState:model.state] forState:0];
    _btn1Hei.constant = [model.state isEqualToString:@"G"] ? 40: 24;
    _btn2Bottom.constant = [model.state isEqualToString:@"G"] ? 9: 17;
    _btn2.hidden = [model.state isEqualToString:@"B"] || [model.state isEqualToString:@"G"];
    _btn1.backgroundColor = ([model.state isEqualToString:@"A"] || [model.state isEqualToString:@"G"] || [model.state isEqualToString:@"C"] || [model.state isEqualToString:@"B"] || [model.state isEqualToString:@"E"] || [model.state isEqualToString:@"F"]) ? RGBColorFrom16(0xff1659): [UIColor whiteColor];
    [_btn1 setTitleColor:([model.state isEqualToString:@"A"] || [model.state isEqualToString:@"G"] || [model.state isEqualToString:@"C"] || [model.state isEqualToString:@"B"] || [model.state isEqualToString:@"E"] || [model.state isEqualToString:@"F"]) ? [UIColor whiteColor]: RGBColorFrom16(0xff1659) forState:0];
    _btn1.hidden = [model.state isEqualToString:@"E"];
    _btn2.hidden = [model.state isEqualToString:@"E"];
    self.moreBtn.hidden = !([_model.state isEqualToString:@"D"] || [_model.state isEqualToString:@"C"]);
    [self.moreActionBtn1 setTitle:kLocalizedString(@"REBUY") forState:0];
    _groupView.hidden = [model.state isEqualToString:@"a"] || !model.shareBuyBriefInfo || [[NSDate dateFromString:model.shareBuyBriefInfo.expDate] utcTimeStamp] < [[NSDate date] utcTimeStamp];
    if (model.shareBuyBriefInfo && !_timer && !_groupView.hidden && (model.shareBuyBriefInfo.shareByNum != model.shareBuyBriefInfo.memberQty) && ![model.state isEqualToString:@"A"]) {
        [self layoutGroupViewWithUpdateTime:YES];
    }else{
//        if (_timer) {
//            [self layoutGroupViewWithUpdateTime:NO];
//        }else{
            self.groupView.hidden = YES;
//        }
    }
}
- (void)layoutGroupViewWithUpdateTime:(BOOL)updateTime
{
    self.groupView.hidden = NO;
    self.hasCountLabel.text = [NSString stringWithFormat:@"%ld",_model.shareBuyBriefInfo.memberQty];
    self.allCountLabel.text = [NSString stringWithFormat:@"/%ld",_model.shareBuyBriefInfo.shareByNum];
    //倒计时
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *nowDate = [formatter dateFromString:_model.shareBuyBriefInfo.now];
//    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
//    NSDate *expDate = [formatter dateFromString:_model.shareBuyBriefInfo.expDate];
//    NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
//    if (updateTime) {
//        MPWeakSelf(self)
//        __block NSInteger timeout = expTimeInterval - timeInterval; // 倒计时时间
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        if (!_timer) {
//            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//        }
//        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
//        dispatch_source_set_event_handler(_timer, ^{
//            if(timeout<=0){
//
//                dispatch_source_cancel(_timer);
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                });
//            }else{
//                NSInteger days = (int)(timeout/(3600*24));
//                NSInteger hours = (int)((timeout-days*24*3600)/3600);
//                NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
//                NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakself.hourLabel.text = [NSString stringWithFormat:@"%02ld",hours+days*24];
//                    weakself.minuLabel.text = [NSString stringWithFormat:@"%02ld",minute];
//                    weakself.secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
//                });
//                timeout--;
//            }
//        });
//        dispatch_resume(_timer);
//    }
    
}
- (IBAction)btn1Action:(UIButton *)sender {
    NSString *state = _model.state;
    if ([state isEqualToString:@"A"]) {
        if (!self.model.orderId.length) {
            return;
        }
        //付款
        NSString *shareBuyOrderNbr = self.model.shareBuyBriefInfo.shareBuyOrderNbr;
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
        PublicAlertView *alert = [[PublicAlertView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"CONFIRM") content:kLocalizedString(@"ARE_YOU_SURE") btnTitle:kLocalizedString(@"YES") block:^{
            
            [SFNetworkManager post:SFNet.order.confirmOrder parametersArr:@[weakself.model.orderId] success:^(id  _Nullable response) {
                [weakself.delegate refreshDatas];
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
            }];
            
        } btn2Title:kLocalizedString(@"CANCEL") block2:^{}];
        [[baseTool getCurrentVC].view addSubview:alert];
    }else if ([state isEqualToString:@"D"]){
        [PDFReader readPDF:[SFNet.h5 getReceiptOf:_model.orderId] complete:^(NSError * _Nullable error, NSURL * _Nullable fileUrl) {
            //返回错误和本地地址
        }];
    }else if ([state isEqualToString:@"G"]){
         NSString *shareUrl = [NSString stringWithFormat:@"%@/group-detail/%@",Host,_model.shareBuyBriefInfo.shareBuyOrderNbr];
         [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
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
        RefundOrReturnViewController *VC = [[RefundOrReturnViewController alloc] init];
        VC.model = self.model;
        [[baseTool getCurrentVC].navigationController pushViewController:VC animated:YES];
    }else if ([state isEqualToString:@"D"]){
        if ([_model.canEvaluate isEqualToString:@"Y"]) {
            if (_model.orderItems.count > 1) {
                AddReviewVC *vc = [[AddReviewVC alloc] init];
                [vc setContent:_model block:^{
                    [self.delegate refreshDatas];
                }];
                [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }else{
                AddReviewViewController *vc = [[AddReviewViewController alloc] init];
                [vc setContent:_model row:0 orderItemId:[_model.orderItems.firstObject orderItemId] block:^{
                    [self.delegate refreshDatas];
                }];
                [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }
        }else{
            ReviewChildViewController *vc = [[ReviewChildViewController alloc] init];
            vc.type = 0;
            vc.showNav = NO;
            vc.orderItemId = self.model.orderNbr;
            [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        }
    }else if ([state isEqualToString:@"C"]){
        [self toLogistices];
    }
}
- (IBAction)moreAction:(UIButton *)sender {
    //YCMenuView
    @weakify(self);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:kLocalizedString(@"REBUY") image:nil handler:^(YCMenuAction *action) {
        @strongify(self);
        [self moreAction1:nil];
    }];
    YCMenuView *menu = [YCMenuView menuWithActions:@[action1] width:114 relyonView:sender];
    menu.textFont = kFontRegular(14);
    menu.cellAlignment = NSTextAlignmentCenter;
    [menu show];
}
- (IBAction)moreAction1:(UIButton *)sender {
    [self rebuy];
}

- (void)toCart
{
    CartViewController *vc = [[CartViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)rebuy
{
    //[MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    [self.model.orderItems enumerateObjectsUsingBlock:^(orderItemsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        NSDictionary *params =
        @{
            @"num": obj.offerCnt,
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
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        [self toCart];
    });
}
- (void)loadRefundCharge
{
    //TODO:这里暂时是一个商品
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.refund.charge parameters:@{@"orderId":self.model.orderId,@"orderItemId":[self.model.orderItems[0] orderItemId]} success:^(id  _Nullable response) {
        RefundChargeModel *chargeModel = [[RefundChargeModel alloc] initWithDictionary:response error:nil];
        RefundOrReturnViewController *VC = [[RefundOrReturnViewController alloc] init];
        VC.model = weakself.model;
        VC.chargeModel = chargeModel;
        [[baseTool getCurrentVC].navigationController pushViewController:VC animated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)toLogistices
{
    //[MBProgressHUD showHudMsg:@""];
    NSString *url = [NSString stringWithFormat:@"%@/%@",SFNet.order.list,_model.orderId];
    [MBProgressHUD hideFromKeyWindow];
    [SFNetworkManager get:url parameters:@{} success:^(id  _Nullable response) {
        OrderDetailModel *detailModel = [[OrderDetailModel alloc] initWithDictionary:response error:nil];
        LogisticsVC *vc = [[LogisticsVC alloc] init];
        vc.model = detailModel;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonTemp;
}
- (NSString *)getBtn1StrWithState:(NSString *)state
{
    NSString *str;
    if ([state isEqualToString:@"A"]) {
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"PAYNOW")];
    }else if ([state isEqualToString:@"B"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REBUY")];
    }else if ([state isEqualToString:@"C"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"CONFIRM")];
    }else if ([state isEqualToString:@"D"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"RECEIPT")];
    }else if ([state isEqualToString:@"E"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REBUY")];
    }else if ([state isEqualToString:@"F"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REBUY")];
    }else if ([state isEqualToString:@"G"]){
        str = [NSString stringWithFormat:@"     %@     ",kLocalizedString(@"SHAREBUY")];
    }
    return str;
}
- (NSString *)getBtn2StrWithState:(NSString *)state
{
    NSString *str;
    if ([state isEqualToString:@"A"]) {
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"CANCEL")];
    }else if ([state isEqualToString:@"B"]){
//        str = kLocalizedString(@"RECEIPT");
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REFUND")];
    }else if ([state isEqualToString:@"C"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"LOGISTICS")];
    }else if ([state isEqualToString:@"D"]){
        if ([_model.canEvaluate isEqualToString:@"Y"]) {
            str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REVIEW")];
        }else{
            str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"VIEW_REVIEW")];
        }
    }else if ([state isEqualToString:@"E"]){
        str = [NSString stringWithFormat:@"   %@   ",kLocalizedString(@"REVIEW")];
    }else if ([state isEqualToString:@"F"]){
        str = @"";
    }else if ([state isEqualToString:@"G"]){
        str = @"";
    }
    return str;
}
@end
