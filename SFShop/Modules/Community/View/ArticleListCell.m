//
//  ArticleListCell.m
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "ArticleListCell.h"
#import <SDWebImage/SDWebImage.h>
#import "SFNetworkMacro.h"

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
    
    NSString *profilePictureUrlString = [NSString stringWithFormat:@"%@%@", Host, model.profilePicture];
    NSString *articlePicturesUrlString = [NSString stringWithFormat:@"%@%@", Host, model.articlePictures];
    [self.profilePicture sd_setImageWithURL: [NSURL URLWithString: profilePictureUrlString]];
    [self.articlePictures sd_setImageWithURL: [NSURL URLWithString: articlePicturesUrlString]];
    [self.contentTitle setText: model.contentTitle];
    [self.viewCnt setText: [NSString stringWithFormat:@"%ld", (long)model.viewCnt]];
}

@end
