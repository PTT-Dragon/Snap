//
//  DistribitorRankTopCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistribitorRankTopCell.h"

@interface DistribitorRankTopCell ()
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *mySaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UIView *indicationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toSaleCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toMySaleCenter;

@end

@implementation DistribitorRankTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _listBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _listBtn.layer.borderWidth = 1;
}
- (IBAction)saleAction:(UIButton *)sender {
    _toSaleCenter.priority = 750;
    _toMySaleCenter.priority = 250;
    sender.selected = YES;
    _mySaleBtn.selected = NO;
    [self.delegate selProductListType:1];
}
- (IBAction)mySaleAction:(UIButton *)sender {
    _toSaleCenter.priority = 250;
    _toMySaleCenter.priority = 750;
    sender.selected = YES;
    _saleBtn.selected = NO;
    [self.delegate selProductListType:2];
}
- (IBAction)listAction:(UIButton *)sender {
}

@end
