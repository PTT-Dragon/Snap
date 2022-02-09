//
//  ProductCheckoutSeccessVc.m
//  SFShop
//
//  Created by 游挺 on 2022/1/19.
//

#import "ProductCheckoutSeccessVc.h"
#import "NSString+Fee.h"
#import "OrderDetailViewController.h"
#import "SceneManager.h"
#import "OrderModel.h"
#import "NSString+Fee.h"
#import <UIButton+WebCache.h>
#import "GroupListViewController.h"
#import "NSDate+Helper.h"


@interface ProductCheckoutSeccessVc ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWidth;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (nonatomic,strong) OrderGroupModel *groupModel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeShareBuyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needMemberCountLabel;
@property (weak, nonatomic) IBOutlet UIView *showImgView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (weak, nonatomic) IBOutlet UILabel *needTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showViewWidth;
@property (nonatomic, strong) dispatch_source_t timer;//倒计时
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProductCheckoutSeccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutsubviews];
    if (_GroupBuyGroupNbr && ![_GroupBuyGroupNbr isKindOfClass:[NSNull class]]) {
        [self loadGroupInfo];
    }
}
- (void)loadGroupInfo
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.groupbuy getGroupBuyGroupNbr:_GroupBuyGroupNbr] parameters:@{} success:^(id  _Nullable response) {
        weakself.groupModel = [OrderGroupModel yy_modelWithDictionary:response];
        [weakself layoutGroupView];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)layoutGroupView
{
    [self.backBtn setTitle:kLocalizedString(@"BACK_TO_HOME") forState:0];
    self.groupView.hidden = NO;
    self.seeShareBuyBtn.hidden = NO;
    CGFloat viewWidth = 0 ;
    if (self.groupModel.groupMembers.count == self.groupModel.shareByNum) {
        //已成团
        self.addBtn.hidden = YES;
        self.needTimeLabel.text = kLocalizedString(@"GROUPED");
        viewWidth = _groupModel.groupMembers.count * 53;
    }else{
        self.inviteBtn.hidden = NO;
        self.addBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        self.addBtn.layer.borderWidth = 1;
        //倒计时
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nowDate = [formatter dateFromString:_groupModel.now];
        NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
        NSDate *expDate = [formatter dateFromString:_groupModel.expDate];
        NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
        MPWeakSelf(self)
        __block NSInteger timeout = expTimeInterval - timeInterval; // 倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                
                dispatch_source_cancel(weakself.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSInteger days = (int)(timeout/(3600*24));
                NSInteger hours = (int)((timeout-days*24*3600)/3600);
                NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.needTimeLabel.text = [NSString stringWithFormat:@"%@ %ld:%ld:%ld",kLocalizedString(@"INVITE_MORE"),hours,minute,second];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        viewWidth = (_groupModel.groupMembers.count+1) * 53;
        _addBtn.frame = CGRectMake(_groupModel.groupMembers.count * 53, 0, 48, 48);
    }
    self.seeShareBuyBtn.layer.borderWidth = 1;
    self.seeShareBuyBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.groupModel.imgUrl)]];
    self.needMemberCountLabel.text = [NSString stringWithFormat:@"%ld",self.groupModel.shareByNum];
    self.productNameLabel.text = self.groupModel.offerName;
    self.productPriceLabel.text = [self.groupModel.shareBuyPrice currency];
//    CGFloat width = 48;
//    NSInteger i = 0;
//    CGFloat right = self.groupModel.groupMembers.count>3 ? 24: 50;
//    for (ReviewUserInfoModel *memberModel in self.groupModel.groupMembers) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.showImgView.width-48-i*right, 0, width, width)];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(memberModel.photo)]];
//        imgView.clipsToBounds = YES;
//        imgView.layer.cornerRadius = 24;
//        [self.showImgView addSubview:imgView];
//        i++;
//    }
    _showViewWidth.constant = viewWidth;
    CGFloat width = 48;
    NSInteger i = 0;
//    CGFloat right = _model.groupMembers.count>3 ? 24: 50;
    for (ReviewUserInfoModel *memberModel in _groupModel.groupMembers) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*53, 0, width, width)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(memberModel.photo)]];
        [self.showImgView addSubview:imgView];
        i++;
    }
    
}
- (void)layoutsubviews
{
    self.scrollviewWidth.constant = MainScreen_width;
    self.btnWidth.constant = MainScreen_width-32;
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    NSArray *codeArr = _infoDic[@"orderNbrList"];
    NSString *orderCode = @"";
    for (NSString *str in codeArr) {
        orderCode = [orderCode stringByAppendingFormat:@"%@ ",str];
    }
    _storeNameLabel.text = @"Nuri.SHOP";
    _codeLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"ORDER_CODE"),orderCode];
    _timeLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"PAYMENT_TIME"),[[NSDate dateFromString:_infoDic[@"payTime"]] dayMonthYearHHMM]];
    _successLabel.text = kLocalizedString(@"PAYMENT_SUCCESS");
    _priceLabel.text = [[_infoDic[@"charge"] stringValue] currency];
    [_detailBtn setTitle:kLocalizedString(@"SEE_DETAIL") forState:0];
    if (self.scrollView.contentSize.height > App_Frame_Height - navBarHei) {
        self.scrollView.scrollEnabled = YES;
    }else {
        self.scrollView.scrollEnabled = NO;
    }
}
- (IBAction)addGroupAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/group-detail/%@",Host,self.groupModel.shareBuyOrderNbr];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}
- (IBAction)seeShareBuyAction:(UIButton *)sender {
    GroupListViewController *vc = [[GroupListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)inviteAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/group-detail/%@",Host,self.groupModel.shareBuyOrderNbr];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}

- (IBAction)detailAction:(UIButton *)sender {
    NSNumber *orderId = _orderArr.firstObject;
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = orderId.stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    [SceneManager transToHome];
}

@end
