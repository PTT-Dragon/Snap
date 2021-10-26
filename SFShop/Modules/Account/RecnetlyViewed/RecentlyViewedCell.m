//
//  RecentlyViewedCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import "RecentlyViewedCell.h"

@interface RecentlyViewedCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@end

@implementation RecentlyViewedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cartAction:(UIButton *)sender {
}
- (IBAction)similarAction:(UIButton *)sender {
}

- (IBAction)favoriteAction:(UIButton *)sender {
}

@end
