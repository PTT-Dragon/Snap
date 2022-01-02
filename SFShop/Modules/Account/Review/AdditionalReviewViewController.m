//
//  AdditionalReviewViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/8.
//

#import "AdditionalReviewViewController.h"
#import "IQTextView.h"
#import "ReviewAddNewPhotoCell.h"
#import "ZLPhotoBrowser.h"
#import "ImageCollectionViewCell.h"
#import "ProductDetailModel.h"
#import "ReviewSuccessViewController.h"

@interface AdditionalReviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHei;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (nonatomic,strong) NSMutableArray *imgUrlArr;//存放图片数组
@property (nonatomic,strong) ReviewDetailModel *model;

@end

@implementation AdditionalReviewViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Additional_review");
    _viewWidth.constant = MainScreen_width;
    _imgArr = [NSMutableArray array];
    _imgUrlArr = [NSMutableArray array];
    [_imgArr addObject:@""];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ReviewAddNewPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewAddNewPhotoCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    _textView.layer.borderColor = RGBColorFrom16(0xc4c4c4).CGColor;
    _textView.layer.borderWidth = 1;
    [self loadDatas];
}
- (void)updateDatas
{
    ProductItemModel *productModel = [self.model.evaluates.firstObject product];
    NSDictionary *dic = [productModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _nameLabel.text = productModel.productName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(productModel.imgUrl)]];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.evaluate.detail parameters:@{@"orderItemId":_orderItemId} success:^(id  _Nullable response) {
        weakself.model = [ReviewDetailModel yy_modelWithDictionary:response];
        [weakself updateDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.imgArr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        ReviewAddNewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewAddNewPhotoCell" forIndexPath:indexPath];
        return cell;
    }
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.imgView.image = (UIImage *)item;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-30)/4 , (MainScreen_width-32-30)/4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.imgArr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        [self uploadAvatar];
    }
}
//打开相册
-(void)uploadAvatar{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];

    // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 9;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.useSystemCamera = YES;
    ac.configuration.allowSelectVideo = NO;

    //如调用的方法无sender参数，则该参数必传
    ac.sender = [baseTool getCurrentVC];
    MPWeakSelf(self)
    // 选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        [weakself.imgArr removeAllObjects];
        [weakself.imgArr addObjectsFromArray:images];
        if (images.count != 9) {
            [weakself.imgArr addObject:@"1"];
        }
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        weakself.collectionViewHei.constant = images.count < 4 ? itemHei+5: images.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
        [weakself.collectionView reloadData];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}
- (void)publishImage
{
    //先上传图片
    [MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    MPWeakSelf(self)
    __block NSInteger i = 0;
    for (id item in _imgArr) {
        if ([item isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            [SFNetworkManager postImage:SFNet.h5.publishImg image:item success:^(id  _Nullable response) {
                @synchronized (response) {
                    [weakself.imgUrlArr addObject:@{@"catgType":@"B",@"url":response[@"fullPath"],@"imgUrl":@"",@"seq":@(i),@"name":response[@"fileName"]}];
                    i++;
                }
                dispatch_group_leave(group);
            } failed:^(NSError * _Nonnull error) {
                dispatch_group_leave(group);
            }];
            
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        [self publishReview];
    });
}
/**
 {"offerEvaluationId":53001,"reviewComments":"可口可乐了","contents":[{"catgType":"B","url":"/get/resource/CE37A15C-12B9-44EE-AA21-4F678482594E1468413606470225920.jpeg","imgUrl":"","seq":0,"name":"CE37A15C-12B9-44EE-AA21-4F678482594E.jpeg"},{"catgType":"B","url":"/get/resource/AF63FA28-115E-473E-B11D-D375EF9A35991468413640922238976.png","imgUrl":"","seq":1,"name":"AF63FA28-115E-473E-B11D-D375EF9A3599.png"}]}
 **/
/**
 {
     contents =     (
                 {
             catgType = B;
             imgUrl = "";
             name = "0CR9CC45-72EC-4522-9D8E-RB8491192E01.jpeg";
             seq = "";
             url = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011468419742653091840.jpeg";
         },
                 {
             catgType = B;
             imgUrl = "";
             name = "0CR9CC45-72EC-4522-9D8E-RB8491192E01.jpeg";
             seq = "";
             url = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011468419744301453312.jpeg";
         }
     );
     offerEvaluationId = 46026;
     reviewComments = "\U4eff\U4f5bvvv\U5206";
 
 {"offerEvaluationId":46026,"reviewComments":"可口可乐了","contents":[{"catgType":"B","url":"/get/resource/59DF2549-D94E-4817-9D24-8831F5D005541468420188398555136.jpeg","imgUrl":"","seq":0,"name":"59DF2549-D94E-4817-9D24-8831F5D00554.jpeg"},{"catgType":"B","url":"/get/resource/2ED0B0A0-E568-44D1-B569-237861AD13931468420220203962368.png","imgUrl":"","seq":1,"name":"2ED0B0A0-E568-44D1-B569-237861AD1393.png"}]}
 }

 **/
- (void)publishReview
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<_model.evaluates.count; i++) {
        EvaluatesModel *evaModel = _model.evaluates[i];
        [params setValue:evaModel.offerEvaluationId forKey:@"offerEvaluationId"];
        [params setValue:_textView.text forKey:@"reviewComments"];
        [params setValue:_imgUrlArr forKey:@"contents"];
    }
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.evaluate.addEvaluate parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Review Success"];
        ReviewSuccessViewController *vc = [[ReviewSuccessViewController alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
        [baseTool removeVCFromNavigation:self];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)submitAction:(id)sender {
    [self publishImage];
}
@end
