//
//  CommunityDetailController.m
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "CommunityDetailController.h"
#import "ArticleDetailModel.h"
#import "ArticleEvaluateModel.h"
#import <iCarousel/iCarousel.h>
#import "ArticleProductCell.h"

@interface CommunityDetailController () <iCarouselDelegate, iCarouselDataSource>

@property(nonatomic, strong) ArticleDetailModel *model;
@property(nonatomic, strong) NSMutableArray<ArticleEvaluateModel *> *evaluateArray;
@property(nonatomic, strong) UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet iCarousel *articlePictures;
@property (weak, nonatomic) IBOutlet UILabel *viewCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *usefulCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCntLabel;
@property (weak, nonatomic) IBOutlet UIView *productContainer;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;

@end

@implementation CommunityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpSubViews];
    [self request];
}

- (void)setUpSubViews {
    _articlePictures.type = iCarouselTypeLinear;
    _articlePictures.bounces = NO;
    _articlePictures.pagingEnabled = YES;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"share"] style: UIBarButtonItemStylePlain target: nil action: nil];
    _headIV = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 32, 32)];
    UIBarButtonItem *headItem = [[UIBarButtonItem alloc] initWithCustomView: _headIV];
    self.navigationItem.rightBarButtonItems = @[shareItem, headItem];
}

- (void)request {
    [MBProgressHUD showHudMsg:@"加载中"];
    [self requestArticleDetail];
    [self requestArticleEvaluate];
}

/// 文章详情接口
- (void)requestArticleDetail {
    [SFNetworkManager get: [SFNet.article getDetailOf: _articleId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.model = [[ArticleDetailModel alloc] initWithDictionary: response error: &error];
        NSLog(@"get article detail success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get article detail failed");
    }];
}

/// 评论列表接口
- (void)requestArticleEvaluate {
    [SFNetworkManager get: [SFNet.article getEvaluateOf: _articleId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.evaluateArray = [ArticleEvaluateModel arrayOfModelsFromDictionaries:response error:&error];
        NSLog(@"get article evaluate success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get article evaluate failed");
    }];
}

- (void)setModel:(ArticleDetailModel *)model {
    _model = model;
    self.title = self.model.publisherName;
    [_headIV sd_setImageWithURL: [NSURL URLWithString: SFImage(self.model.profilePicture)]];
    NSString *detailStr = self.model.articleDetail;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData: [detailStr dataUsingEncoding: NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
    self.detailLabel.attributedText = attrStr;
    self.viewCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.viewCnt];
    self.usefulCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.usefulCnt];
    self.replyCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.replyCnt];
    self.createDateLabel.text = self.model.createdDate;
    if (self.model.products.count > 0) {
        [self.productContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.productContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(135 * self.model.products.count);
        }];
        [self.model.products enumerateObjectsUsingBlock:^(ArticleProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ArticleProductCell *productCell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleProductCell" owner:nil options:nil] lastObject];
            [productCell setModel: obj];
            [self.productContainer addSubview: productCell];
            [productCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(130);
                make.top.equalTo(self.productContainer).offset(135 * idx);
                make.left.right.equalTo(self.productContainer);
            }];
            
        }];
    }
    [self.articlePictures reloadData];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _model.articlePictures.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *iv = nil;
    if (view == nil) {
        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        iv = (UIImageView *)view;
    }
    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage(self.model.articlePictures[index])]];
    return iv;
}

@end
