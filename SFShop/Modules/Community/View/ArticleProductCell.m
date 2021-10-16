//
//  ArticleProductCell.m
//  SFShop
//
//  Created by Jacue on 2021/10/3.
//

#import "ArticleProductCell.h"

@interface ArticleProductCell()

@property (weak, nonatomic) IBOutlet UIImageView *productIV;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@end

@implementation ArticleProductCell

- (void)setModel:(ArticleProduct *)model {
    [self.productIV sd_setImageWithURL: [NSURL URLWithString: SFImage(model.imgUrl)]];
    self.productNameLabel.text = model.productName;
}

@end
