//
//  AddReviewItemCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "AddReviewItemCell.h"
#import "StarView.h"
#import "ImageCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "ReviewAddNewPhotoCell.h"
#import <IQTextView.h>
#import "TextCountView.h"

@interface AddReviewItemCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (nonatomic,strong) NSMutableArray *imgUrlArr;//存放图片url数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHei;
@property (nonatomic,strong) orderItemsModel *orderModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHei;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) TextCountView *countView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *labelsVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsViewHei;

@end

@implementation AddReviewItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgUrlArr = [NSMutableArray array];
    [_imgArr addObject:@"1"];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"ReviewAddNewPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"ReviewAddNewPhotoCell"];
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    _textView.layer.borderColor = RGBColorFrom16(0xc4c4c4).CGColor;
    _textView.layer.borderWidth = 1;
    _starView.block = ^(NSInteger score) {
        self.rateBlock([NSString stringWithFormat:@"%ld",score], self.row);
    };
    _textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    [self.contentView addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textView.mas_bottom).offset(-30);
        make.right.mas_equalTo(self.textView.mas_right).offset(-40);
    }];
    _textView.placeholder = kLocalizedString(@"TYPE_REVIEW");
    _label1.text = kLocalizedString(@"UPLOAD_PHOTO");
    _label2.text = kLocalizedString(@"RATING");
    _label3.text = kLocalizedString(@"HOW_RATE_PRODUCT");
    
}
- (void)layoutSubviews
{
//    _starView.score = 5;
    _starView.canSel = YES;
}
- (void)setContent:(orderItemsModel *)orderModel row:(NSInteger)row imgArr:(NSMutableArray *)imgArr text:(NSString *)text rate:(NSString *)rate evaModel:(EvaluatesModel *)evaModel
{
    _orderModel = orderModel;
    _row = row;
    _imgArr = imgArr;
    NSDictionary *dic = [orderModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _nameLabel.text = orderModel.productName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(orderModel.imagUrl)]];
    [_photoCollectionView reloadData];
    _starView.score = rate.integerValue;
    _textView.text = text;
    CGFloat itemHei = (MainScreen_width-32-60)/4;
    self.photoCollectionViewHei.constant = imgArr.count < 4 ? itemHei+5: imgArr.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
    [self.photoCollectionView reloadData];
    CGFloat lastRight = 16;
    CGFloat btnY = 16;
    for (UIView *subView in self.labelsVIew.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    for (EvaLabelsModel *labesModel in evaModel.labels) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:labesModel.labelName forState:0];
        btn.backgroundColor = RGBColorFrom16(0xefefef);
        [btn setTitleColor:RGBColorFrom16(0x333333) forState:0];
        btn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        btn.tag = labesModel.labelId.integerValue;
        btn.selected = labesModel.sel;
        if (btn.selected) {
            btn.backgroundColor = btn.selected ? RGBColorFrom16(0xFFE5EB): RGBColorFrom16(0xefefef);
            btn.layer.borderWidth = btn.selected ? 1: 0;
            [btn setTitleColor:btn.selected ? RGBColorFrom16(0xFF1659):RGBColorFrom16(0x333333)  forState:0];
        }
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            btn.selected = !btn.selected;
            btn.backgroundColor = btn.selected ? RGBColorFrom16(0xFFE5EB): RGBColorFrom16(0xefefef);
            btn.layer.borderWidth = btn.selected ? 1: 0;
            [btn setTitleColor:btn.selected ? RGBColorFrom16(0xFF1659):RGBColorFrom16(0x333333)  forState:0];
            labesModel.sel = btn.selected;
            if (self.tagBlock) {
                self.tagBlock(evaModel, self.row);
            }
        }];
        for (NSNumber *selId in evaModel.selLabelIds) {
            if ([labesModel.labelId isEqualToString:selId.stringValue]) {
                btn.selected = YES;
                btn.backgroundColor = btn.selected ? RGBColorFrom16(0xFFE5EB): RGBColorFrom16(0xefefef);
                btn.layer.borderWidth = btn.selected ? 1: 0;
                [btn setTitleColor:btn.selected ? RGBColorFrom16(0xFF1659):RGBColorFrom16(0x333333)  forState:0];
            }
        }
        btn.titleLabel.font = kFontLight(12);
        CGFloat btnWidth = [btn.titleLabel.text calWidthWithLabel:btn.titleLabel] +20;
        btn.frame = CGRectMake(lastRight, btnY,btnWidth, 33);
        [self.labelsVIew addSubview:btn];
        btnY = lastRight + btnWidth > MainScreen_width-32 ? btnY+43: btnY;
        lastRight = lastRight + btnWidth > MainScreen_width-32 ? 16: lastRight + btnWidth + 10;
    }
    self.labelsViewHei.constant = btnY+33;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textBlock(textView.text, _row);
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
    cell.index = indexPath.row;
    cell.canDel = YES;
    MPWeakSelf(self)
    cell.block = ^(NSInteger index) {//删除
        [weakself.imgArr removeObjectAtIndex:index];
        __block BOOL a = NO;
        [weakself.imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                a = YES;
            }
        }];
        if (weakself.imgArr.count < 9 && !a) {
            [weakself.imgArr insertObject:@"1" atIndex:weakself.imgArr.count];
        }
        CGFloat itemHei = (MainScreen_width-32-60)/4;
        weakself.photoCollectionViewHei.constant = ceil(weakself.imgArr.count/4.0)*(itemHei+10)+15;
        [weakself.photoCollectionView reloadData];
        
        if (weakself.deleteImageBlock) {
            weakself.deleteImageBlock(index);
        }
        
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-60)/4 , (MainScreen_width-32-60)/4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.imgArr[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        self.block(_row);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 500) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 500)];
    }
    [_countView configDataWithTotalCount:500 currentCount:textView.text.length];
}

- (TextCountView *)countView {
    if (!_countView) {
        _countView = [[TextCountView alloc] init];
        [_countView configDataWithTotalCount:500 currentCount:0];
    }
    return _countView;
}


@end
