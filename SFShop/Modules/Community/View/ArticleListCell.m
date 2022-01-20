//
//  ArticleListCell.m
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "ArticleListCell.h"
#import <SDWebImage/SDWebImage.h>

@interface ArticleListCell()
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UIImageView *articlePictures;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *publisherName;
@property (weak, nonatomic) IBOutlet UILabel *viewCnt;

@end

@implementation ArticleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.whiteColor;
}

- (void)setModel:(ArticleModel *)model {
    _model = model;
    
    [self.profilePicture sd_setImageWithURL: [NSURL URLWithString: SFImage(model.profilePicture)] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    [self.articlePictures sd_setImageWithURL: [NSURL URLWithString: SFImage(model.articlePictures)] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    [self.contentTitle setText: model.contentTitle];
    [self.viewCnt setText: [NSString stringWithFormat:@"%ld", (long)model.viewCnt]];
    self.publisherName.text = model.publisherName;
}

@end
