//
//  AddReviewViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "AddReviewViewController.h"
#import "StarView.h"
#import "IQTextView.h"
#import "ReviewAddNewPhotoCell.h"
#import "ZLPhotoBrowser.h"
#import "ImageCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "ReviewSuccessViewController.h"

@interface AddReviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImgView;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet StarView *starView1;
@property (weak, nonatomic) IBOutlet StarView *starView2;
@property (weak, nonatomic) IBOutlet StarView *starView3;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (nonatomic,strong) NSMutableArray *imgUrlArr;//存放图片url数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHei;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (nonatomic,strong) ReviewDetailModel *detailModel;
@end

@implementation AddReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Review");
    _imgUrlArr = [NSMutableArray array];
    _imgArr = [NSMutableArray array];
    [_imgArr addObject:@"1"];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"ReviewAddNewPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewAddNewPhotoCell"];
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    _viewWidth.constant = MainScreen_width;
    _starView.canSel = YES;
    _starView.score = 5;
    _starView1.canSel = YES;
    _starView1.score = 5;
    _starView2.canSel = YES;
    _starView2.score = 5;
    _starView3.canSel = YES;
    _starView3.score = 5;
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    _textView.layer.borderColor = RGBColorFrom16(0xc4c4c4).CGColor;
    _textView.layer.borderWidth = 1;
    orderItemsModel *itemModel = _model.orderItems.firstObject;
    NSDictionary *dic = [itemModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _nameLabel.text = itemModel.productName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemModel.imagUrl)]];
    _storeNameLabel.text = _model.storeName;
    [_storeLogoImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.storeLogoUrl)]];
    if (self.orderItemId) {
        [self loadDatas];
    }
}
- (void)updateDatas
{
    EvaluatesModel *evaModel = self.detailModel.evaluates.firstObject;
    self.textView.text = evaModel.evaluationComments;
    self.starView.score = evaModel.rate.integerValue;
    self.bottomView.hidden = YES;
    self.anonymousBtn.hidden = YES;
    self.anonymousLabel.hidden = YES;
    for (EvaluatesContentsModel *contentModel in evaModel.contents) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:SFImage(contentModel.url)] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [self.imgArr addObject:image];
            }
            [self.photoCollectionView reloadData];
        }];
    }
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.evaluate.detail parameters:@{@"orderItemId":_orderItemId} success:^(id  _Nullable response) {
        weakself.detailModel = [ReviewDetailModel yy_modelWithDictionary:response];
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
        weakself.photoCollectionViewHei.constant = images.count < 4 ? itemHei+5: images.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
        [weakself.photoCollectionView reloadData];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}
/**
 {"evaluateItems":[{"orderItemId":50004,"ratingComments":"Ffff ","rate":3,"labelIds":[],"contents":[{"catgType":"B","url":"/get/resource/A3840564-1B7D-4A26-B801-9140CC071E811467785989878583296.jpeg","imgUrl":"","seq":0,"name":"A3840564-1B7D-4A26-B801-9140CC071E81.jpeg"},{"catgType":"B","url":"/get/resource/B8ED63AB-8F24-4AB3-A86F-3FAEEFDE031F1467786024691306496.png","imgUrl":"","seq":1,"name":"B8ED63AB-8F24-4AB3-A86F-3FAEEFDE031F.png"}],"isAnonymous":"Y"}],"store":{"rate":4,"rate1":3,"rate2":5,"storeId":11,"orderId":50004,"isAnonymous":"Y"}}
 **/
- (IBAction)submitAction:(UIButton *)sender {
    [self publishImage];
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
- (void)publishReview
{
    /**
     {"evaluateItems":[{"orderItemId":24008,"ratingComments":"他旅途","rate":2,"labelIds":[],"contents":[{"catgType":"B","url":"/get/resource/ecs/20220118/picture/C2590792-F45A-4578-840D-E4AEB2C60C561483413639839563776.png","imgUrl":"","seq":0,"name":"C2590792-F45A-4578-840D-E4AEB2C60C56.png"},{"catgType":"B","url":"/get/resource/ecs/20220118/picture/802E16EF-95A1-4ED2-B417-28691F7AEAC61483413639579516928.png","imgUrl":"","seq":1,"name":"802E16EF-95A1-4ED2-B417-28691F7AEAC6.png"},{"catgType":"B","url":"/get/resource/ecs/20220118/picture/B0394A62-F015-469A-9809-D5D66A727D381483413639097171968.png","imgUrl":"","seq":2,"name":"B0394A62-F015-469A-9809-D5D66A727D38.png"}],"isAnonymous":"Y"}],"store":{"rate":2,"rate1":4,"rate2":4,"storeId":5,"orderId":25008,"isAnonymous":"Y"}}
     **/
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *evaluateItems = [NSMutableArray array];
    for (NSInteger i = 0; i<_model.orderItems.count; i++) {
        orderItemsModel *itemModel = _model.orderItems[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:itemModel.orderItemId forKey:@"orderItemId"];
        [dic setValue:_textView.text forKey:@"ratingComments"];
        [dic setValue:@(_starView.score) forKey:@"rate"];
        [dic setValue:self.imgUrlArr forKey:@"contents"];
        [dic setValue:_anonymousBtn.selected ? @"Y": @"N" forKey:@"isAnonymous"];
        [evaluateItems addObject:dic];
    }
    [params setValue:evaluateItems forKey:@"evaluateItems"];
    [params setValue:@{@"rate":@(_starView1.score),@"rate1":@(_starView2.score),@"rate2":@(_starView3.score),@"storeId":self.model.storeId,@"orderId":self.model.orderId,@"isAnonymous":_anonymousBtn.selected ? @"Y": @"N"} forKey:@"store"];
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.evaluate.modify parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        if (weakself.block) {
            weakself.block();
        }
        ReviewSuccessViewController *vc = [[ReviewSuccessViewController alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
        [baseTool removeVCFromNavigation:self];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)anonymousAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
