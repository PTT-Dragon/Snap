//
//  ProductEvalationCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductEvalationCell.h"
#import "ImageCollectionViewCell.h"
#import "KSPhotoBrowser.h"
#import "StarView.h"
#import "NSDate+Helper.h"

@interface ProductEvalationCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHei;

@end

@implementation ProductEvalationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _bgView.layer.borderWidth = 1;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
}
- (void)setModel:(ProductEvalationModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userLogo)]];
    _nameLabel.text = model.userName;
    _rateLabel.text = [NSString stringWithFormat:@"%.1f", model.rate.floatValue];
    _contentLabel.text = model.evaluationComments;
    _timeLabel.text = [[NSDate dateFromString:model.createdDate] dayMonthYearHHMM];
    [_collectionView reloadData];
    CGFloat itemHei = (MainScreen_width-34-30)/4;
    self.collectionViewHei.constant = model.evaluationContents.count == 0 ? 0: model.evaluationContents.count < 4 ? itemHei+5: model.evaluationContents.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_width)];
    [self.contentView addSubview:imgView];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [self.model.evaluationContents enumerateObjectsUsingBlock:^(EvaluatesContentsModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imgView imageUrl:[NSURL URLWithString:SFImage(obj.url)]];
        [arr addObject:item];
    }];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, MainScreen_width-32, 44)];
    label.numberOfLines = 0;
    label.font = CHINESE_SYSTEM(14);
    label.textColor = [UIColor whiteColor];
    label.text = self.model.productName;
    [bottomView addSubview:label];
    StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(16, label.jk_bottom+10, 200, 14)];
    starView.canSel = NO;
    starView.score = [self.model.rate integerValue];
    [bottomView addSubview:starView];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, starView.jk_bottom+10, MainScreen_width-32, 144)];
    contentLabel.numberOfLines = 0;
    contentLabel.font = CHINESE_SYSTEM(14);
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.text = self.model.evaluationComments;
    [bottomView addSubview:contentLabel];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:indexPath.row bottomView:bottomView];
    [browser showFromViewController:[baseTool getCurrentVC]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.evaluationContents.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([_model.evaluationContents[indexPath.row] url])]];
    cell.contentView.backgroundColor = UIColor.redColor;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-34-30)/4 , (MainScreen_width-34-30)/4);
}
@end
