//
//  ProductViewController.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "ProductViewController.h"
#import "ProductDetailModel.h"
#import <iCarousel/iCarousel.h>

@interface ProductViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property(nonatomic, strong) ProductDetailModel *model;
@property (weak, nonatomic) IBOutlet iCarousel *carouselImgView;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Product Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    [self request];
    [self setupSubViews];
}

- (void)request {
    [MBProgressHUD showHudMsg:@"加载中"];
    [SFNetworkManager get: [SFNet.offer getDetailOf: self.offerId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.model = [[ProductDetailModel alloc] initWithDictionary: response error: &error];
        NSLog(@"get product detail success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get product detail failed");
    }];
}

- (void)setupSubViews {
    self.cartBtn.layer.borderWidth = 0.5;
    self.cartBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#cccccc"] CGColor];
    self.messageBtn.layer.borderWidth = 0.5;
    self.messageBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#cccccc"] CGColor];
    self.addCartBtn.layer.borderWidth = 1;
    self.addCartBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#ff1659"] CGColor];
    [self.buyBtn setBackgroundColor: [UIColor jk_colorWithHexString:@"#ff1659"]];
    
    _carouselImgView.type = iCarouselTypeLinear;
    _carouselImgView.bounces = NO;
    _carouselImgView.pagingEnabled = YES;
}

- (void)setModel:(ProductDetailModel *)model {
    _model = model;
    [self.carouselImgView reloadData];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _model.carouselImgUrls.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *iv = nil;
    if (view == nil) {
        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        iv = (UIImageView *)view;
    }
    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage([self getNonNullCarouselImageAt: index])]];
    return iv;
}

// 此处添加容错，目前数据返回较为杂乱
/**
 <ProductCarouselImgModel>
    [imgUrl]: /get/resource/1113434319518177730561438412161289424896.png
    [contentId]: 31698
    [url]: /get/resource/1113434319518177730561438412161289424896.mp4
    [bigImgUrl]: <nil>
    [contentType]: B
    [smallImgUrl]: <nil>
    [seq]: 1
 </ProductCarouselImgModel>,
 <ProductCarouselImgModel>
    [imgUrl]: <nil>
    [contentId]: 31697
    [url]: /get/resource/iphone101438412083082432512.jpg
    [bigImgUrl]: /get/resource/iphone101438412083082432512.jpg
    [contentType]: A
    [smallImgUrl]: /get/resource/iphone101438412083082432512_150x150.jpg
    [seq]: 1
 </ProductCarouselImgModel>
 */
- (NSString *)getNonNullCarouselImageAt: (NSInteger)index {
    ProductCarouselImgModel *imgModel = self.model.carouselImgUrls[index];
    if (imgModel.imgUrl) {
        return imgModel.imgUrl;
    }
    if (imgModel.bigImgUrl) {
        return imgModel.bigImgUrl;
    }
    if (imgModel.smallImgUrl) {
        return imgModel.smallImgUrl;
    }
    if (imgModel.url) {
        return imgModel.url;
    }
    return nil;
}


@end
