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

@interface AddReviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImgView;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHei;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@end

@implementation AddReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Review";
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
- (IBAction)submitAction:(UIButton *)sender {
    [SFNetworkManager post:SFNet.evaluate.addEvaluate parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)anonymousAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
