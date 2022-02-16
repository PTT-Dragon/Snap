//
//  ReviewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "ReviewCell.h"
#import "StarView.h"
#import "NSString+Fee.h"
#import "NSDate+Helper.h"

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
    [_btn2 setTitle:kLocalizedString(@"EDIT") forState:0];
}
- (void)setContent:(OrderModel *)model row:(NSInteger)row type:(NSInteger)type
{
    _model = model;
    _evaluationView.hidden = type == 1;
    _priceLabel.hidden = type == 1;
//    if ([model.canEvaluate isEqualToString:@"N"]) {
//        _btn1.hidden = YES;
//        _btn2.hidden = YES;
//    }else
    
    orderItemsModel *itemModel = model.orderItems[row];
    if ([itemModel.canReview isEqualToString:@"Y"]) {
    _btn2.hidden = type == 1;
    [_btn1 setTitle:type == 1 ? kLocalizedString(@"REVIEW"):kLocalizedString(@"ADDITIONAL_REVIEW") forState:0];
    _btn1.hidden = NO;
}else{
    _btn1.hidden = YES;
    _btn2.hidden = YES;
}
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    _storeNameLabel.text = model.storeName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemModel.imagUrl)]];
    _nameLabel.text = itemModel.productName;
    _countLabel.text = [NSString stringWithFormat:@"X%@",itemModel.offerCnt];
    _priceLabel.text = [itemModel.unitPrice currency];
    NSDictionary *dic = [itemModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _dateLabel.text = [NSString stringWithFormat:@"Review Date:%@",[[NSDate dateFromString:itemModel.evaluation[@"createdDate"]] dayMonthYear]];
    _commentLabel.text = itemModel.evaluation[@"evaluationComments"];
    _starView.score = [itemModel.evaluation[@"rate"] integerValue];
    
}
- (IBAction)btn1Action:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:kLocalizedString(@"ADDITIONAL_REVIEW")]) {
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
