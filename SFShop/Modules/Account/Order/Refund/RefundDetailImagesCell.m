//
//  RefundDetailImagesCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailImagesCell.h"
#import "ImageCollectionViewCell.h"
#import "ReviewAddNewPhotoCell.h"
#import "ZLPhotoBrowser.h"
#import <SDWebImage/SDWebImage.h>

@interface RefundDetailImagesCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (nonatomic, strong) NSMutableArray *selectAssets;

@end

@implementation RefundDetailImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgArr = [NSMutableArray array];
    [_imgArr addObject:@"1"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ReviewAddNewPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewAddNewPhotoCell"];
    
    self.theTitle.text = self.canSel ? [NSString stringWithFormat:@"%@ (%@3)",kLocalizedString(@"UPLOAD_PICTURE"),kLocalizedString(@"UP_TO")] : kLocalizedString(@"IMAGES");
}
- (void)setCanSel:(BOOL)canSel
{
    _canSel = canSel;
    self.theTitle.text = !_canSel ? [NSString stringWithFormat:@"%@ (%@3)",kLocalizedString(@"UPLOAD_PICTURE"),kLocalizedString(@"UP_TO")] : kLocalizedString(@"IMAGES");
}
- (void)setContent:(NSArray<EvaluatesContentsModel *> *)content
{
    _content = content;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canSel) {
        return;
    }
    id item = self.imgArr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        [self uploadAvatar];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _content ? _content.count : _imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_content) {
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([_content[indexPath.row] url])]];
        return cell;
    }
    id item = self.imgArr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        ReviewAddNewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewAddNewPhotoCell" forIndexPath:indexPath];
        return cell;
    }
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.imgView.image = (UIImage *)item;
    cell.index = indexPath.row;
    cell.canDel = YES;
    MPWeakSelf(self)
    cell.block = ^(NSInteger index) {
        [weakself.imgArr removeObjectAtIndex:index];
        __block BOOL a = NO;
        [weakself.imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                a = YES;
            }
        }];
        if (weakself.imgArr.count < 3 && !a) {
            [weakself.imgArr insertObject:@"1" atIndex:weakself.imgArr.count];
        }
        [weakself.collectionView reloadData];
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-30-20)/4 , (MainScreen_width-32-30-20)/4);
}


//打开相册
-(void)uploadAvatar{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];

    // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 3;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.useSystemCamera = YES;
    ac.configuration.allowSelectVideo = NO;
    ac.arrSelectedAssets = self.selectAssets;

    //如调用的方法无sender参数，则该参数必传
    ac.sender = [baseTool getCurrentVC];
    MPWeakSelf(self)
    // 选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        [weakself.imgArr removeAllObjects];
        [weakself.imgArr addObjectsFromArray:images];
        [weakself.selectAssets removeAllObjects];
        [self.selectAssets addObjectsFromArray:assets];
        if (images.count != 3) {
            [weakself.imgArr addObject:@"1"];
        }
        if (weakself.block) {
            weakself.block(weakself.imgArr);
        }
        [weakself.collectionView reloadData];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}


-(NSMutableArray *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [[NSMutableArray alloc] init];
    }
    return _selectAssets;
}



@end
