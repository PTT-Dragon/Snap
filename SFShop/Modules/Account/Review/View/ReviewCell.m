//
//  ReviewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "ReviewCell.h"
#import "StarView.h"

@interface ReviewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic,weak) OrderModel *model;

@end

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    
    _btn1.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn1.layer.borderWidth = 1;
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
}
- (void)setContent:(OrderModel *)model type:(NSInteger)type
{
    _model = model;
    _evaluationView.hidden = type == 1;
    _priceLabel.hidden = type == 1;
    if ([model.canReview isEqualToString:@"Y"]) {
        _btn2.hidden = type == 1;
        [_btn1 setTitle:type == 1 ? @"REVIEW":@"ADDITIONAL REVIEW" forState:0];
        _btn1.hidden = NO;
    }else{
        _btn1.hidden = YES;
        _btn2.hidden = YES;
    }
    orderItemsModel *itemModel = model.orderItems.firstObject;
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)]];
    _storeNameLabel.text = model.storeName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemModel.imagUrl)]];
    _nameLabel.text = itemModel.productName;
    _countLabel.text = [NSString stringWithFormat:@"X%@",itemModel.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",itemModel.unitPrice];
    NSDictionary *dic = [itemModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _dateLabel.text = [NSString stringWithFormat:@"Review Date:%@",itemModel.evaluation[@"createdDate"]];
    _commentLabel.text = itemModel.evaluation[@"evaluationComments"];
    _starView.score = [itemModel.evaluation[@"rate"] integerValue];
    
}
- (IBAction)btn1Action:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"ADDITIONAL REVIEW"]) {
        if (self.additionBlock) {
            self.additionBlock(_model);
        }
        return;
    }
    if (self.block) {
        self.block(_model);
    }
}
- (IBAction)btn2Action:(UIButton *)sender {
    if (self.block) {
        self.block(_model);
    }
}
@end
