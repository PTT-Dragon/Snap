//
//  UseCouponProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import "UseCouponProductCell.h"
#import "NSString+Fee.h"
@import TagListView;

@interface UseCouponProductCell ()
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *spCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong) CategoryRankPageInfoListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;
@property (nonatomic, readwrite, strong) TagListView *promoTypeView;

@end

@implementation UseCouponProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    self.subView.layer.borderWidth = 1;
    self.spCartBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    self.spCartBtn.layer.borderWidth = 1;
    [self.contentView addSubview:self.promoTypeView];
}
- (void)setContent:(CategoryRankPageInfoListModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.productImg.url)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [[NSString stringWithFormat:@"%ld",model.salesPrice] currency];
    _marketLabel.text = [[NSString stringWithFormat:@"%ld",model.marketPrice] currency];
    NSString *score = (model.evaluationAvg == 0 || !model.evaluationAvg) ? @"":[NSString stringWithFormat:@"%.1f",model.evaluationAvg];
    NSString *count = (model.evaluationCnt == 0 || !model.evaluationCnt) ? @"":[NSString stringWithFormat:@"(%ld)",model.evaluationCnt];
    self.starImgView.hidden = [score isEqualToString:@""];
    _scoreLabel.text = [NSString stringWithFormat:@"%@ %@",score,count];
    _offLabel.text = [NSString stringWithFormat:@" -%@%% ",model.discountPercent];
    
    NSArray *formatterTags = _model.allTags;
    if (formatterTags.count) {
        [self.promoTypeView removeAllTags];
        [self.promoTypeView addTags:formatterTags];
        self.promoTypeView.hidden = NO;
    } else {
        self.promoTypeView.hidden = YES;
    }
    
    [self.promoTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KScale(15));
        make.right.mas_equalTo(-KScale(30));
        make.left.equalTo(self.imgView.mas_right).offset(KScale(15));
        make.height.mas_equalTo(KScale(16));
    }];
    
}
- (IBAction)spCartAction:(UIButton *)sender {
    if (self.block) {
        self.block(_model);
    }
}

- (TagListView *)promoTypeView {
    if (_promoTypeView == nil) {
        _promoTypeView = [[TagListView alloc] init];
        _promoTypeView.textFont = kFontBlod(10);
        _promoTypeView.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        _promoTypeView.tagBackgroundColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        _promoTypeView.alignment = AlignmentLeft;
        _promoTypeView.limitRows = 1;
        _promoTypeView.backgroundColor = [UIColor whiteColor];
    }
    return _promoTypeView;
}

@end
