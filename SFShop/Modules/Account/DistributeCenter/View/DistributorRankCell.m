//
//  DistributorRankCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorRankCell.h"
#import "NSString+Fee.h"

@interface DistributorRankCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLeading;

@end

@implementation DistributorRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.shareBtn setTitle:[NSString stringWithFormat:@"  %@  ",kLocalizedString(@"Share_to")] forState:0];
}
- (void)setModel:(DistributorRankProductModel *)model
{
    _model = model;
    _nameLabel.text = model.offerName;
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    NSString *precisionStr = [NSString stringWithFormat:@"%%.%ldf", precision];//精度
    NSString *thousandthStr = [NSString stringWithFormat:precisionStr,[model.commissionRate currencyFloat]];
    _priceLabel.text = [NSString stringWithFormat:@"%@%% %@",thousandthStr,[model.commission currency]];
    _skuLabel.text = [NSString stringWithFormat:@"%@",[model.salesPrice currency]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    
}
- (void)setRank:(NSInteger)rank
{
    _rank = rank;
    if (rank == 10000) {
        _rankLabel.hidden = YES;
        _imgViewLeading.constant = 16;
    }else{
        _rankLabel.text = [NSString stringWithFormat:@"%ld",rank];
    }
}
- (IBAction)shareAction:(UIButton *)sender {
    [SFNetworkManager get:SFNet.distributor.material parameters:@{@"distriSpuLibId":self.model.distriSpuLibId} success:^(id  _Nullable response) {
        PosterModel *posterModel = [[PosterModel alloc] initWithDictionary:response error:nil];
        NSString *shareUrl = [NSString stringWithFormat:@"%@/product/detail/%@?campaignId=%@&cmpType=%@&distributorId=%@",Host,self.model.offerId,self.centerModel.sysKolCampaignId,@"8",self.centerModel.distributionSettlementDto.distributorId];
        [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl posterModel:posterModel.posters.firstObject];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    
}
@end
