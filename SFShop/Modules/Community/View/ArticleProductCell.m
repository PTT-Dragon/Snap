//
//  ArticleProductCell.m
//  SFShop
//
//  Created by Jacue on 2021/10/3.
//

#import "ArticleProductCell.h"
#import "NSString+Fee.h"

@interface ArticleProductCell()

@property (weak, nonatomic) IBOutlet UIImageView *productIV;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ArticleProductCell

- (void)setModel:(ArticleProduct *)model {
    _model = model;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBColorFrom16(0xd5d5d5).CGColor;

    [self.productIV sd_setImageWithURL: [NSURL URLWithString: SFImage(model.imgUrl)]];
    self.productNameLabel.text = model.productName;
    self.priceLabel.text = [[NSString stringWithFormat:@"%ld",model.salesPrice] currency];
    
}

- (IBAction)buyAction:(UIButton *)sender {
    if (self.buyBlock) {
        self.buyBlock(self.model);
    }
}

@end
