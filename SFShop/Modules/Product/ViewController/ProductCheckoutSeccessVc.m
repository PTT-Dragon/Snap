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


@interface ProductCheckoutSeccessVc ()
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
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *needTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (nonatomic, strong) dispatch_source_t timer;//倒计时

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
    self.groupView.hidden = NO;
    self.seeShareBuyBtn.hidden = NO;
    self.addBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    self.addBtn.layer.borderWidth = 1;
    self.seeShareBuyBtn.layer.borderWidth = 1;
    self.seeShareBuyBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.groupModel.imgUrl)]];
    self.productNameLabel.text = self.groupModel.offerName;
    self.priceLabel.text = [self.groupModel.shareBuyOrderNbr currency];
    ReviewUserInfoModel *userModel = self.groupModel.groupMembers.firstObject;
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(userModel.photo)]];
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
                weakself.needTimeLabel.text = [NSString stringWithFormat:@"%@ %ld:%ld:%ld",kLocalizedString(@"INVITE_ONE"),hours,minute,second];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)layoutsubviews
{
    
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    _storeNameLabel.text = dic[@"storeName"];
    _codeLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"ORDER_CODE"),dic[@"orderNbr"]];
    _timeLabel.text = kLocalizedString(@"PAYMENT_TIME");
    _successLabel.text = kLocalizedString(@"PAYMENT_SUCCESS");
    _priceLabel.text = [[_infoDic[@"totalPrice"] stringValue] currency];
    [_detailBtn setTitle:kLocalizedString(@"SEE_DETAIL") forState:0];
}
- (IBAction)addGroupAction:(UIButton *)sender {
}
- (IBAction)seeShareBuyAction:(UIButton *)sender {
}

- (IBAction)detailAction:(UIButton *)sender {
    NSArray *arr = _infoDic[@"orders"];
    NSDictionary *dic = arr.firstObject;
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = dic[@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    [SceneManager transToHome];
}

@end
