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
#import "TextCountView.h"
#import "NSString+Add.h"

@interface AddReviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImgView;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet StarView *starView1;
@property (weak, nonatomic) IBOutlet StarView *starView2;
@property (weak, nonatomic) IBOutlet StarView *starView3;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHei;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (nonatomic,strong) ReviewDetailModel *detailModel;
@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,copy) NSString *orderItemId;
@property (nonatomic,strong) TextCountView *countView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (nonatomic,strong) NSMutableArray *selectAssets;
@property (weak, nonatomic) IBOutlet UIScrollView *labelsVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsViewHei;

@end

@implementation AddReviewViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Review");
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
    _textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    [self.bgScrollView addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textView.mas_bottom).offset(-30);
        make.right.mas_equalTo(self.textView.mas_right).offset(-40);
    }];
    orderItemsModel *itemModel = _model.orderItems[_row];
    NSDictionary *dic = [itemModel.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _nameLabel.text = itemModel.productName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemModel.imagUrl)]];
    _storeNameLabel.text = _model.storeName;
    if (![_model isKindOfClass:[OrderDetailModel class]]) {
        [_storeLogoImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    }else{
        _storeLogoImgView.image = [UIImage imageNamed:@"toko"];
    }
    _label1.text = kLocalizedString(@"RATING");
    _label4.text = kLocalizedString(@"UPLOAD_PHOTO");
    _label2.text = kLocalizedString(@"HOW_RATE_PRODUCT");
    _anonymousLabel.text = kLocalizedString(@"KEEP_ANONYMOUS");
    _textView.placeholder = kLocalizedString(@"TYPE_REVIEW");
    _label6.text = kLocalizedString(@"SERVICE_ATTITUDE");
    _label5.text = kLocalizedString(@"QUALITY_OF_GOODS");
    _label7.text = kLocalizedString(@"LOGISTICS_SERVICE");
}
- (void)setContent:(OrderModel *)model row:(NSInteger)row orderItemId:(NSString *)orderItemId block:(AddReviewViewControllerBlock)block
{
    _model = model;
    _row = row;
    _orderItemId = orderItemId;
    _block = block;
    if (self.orderItemId) {
        [self loadDatas];
    }
}
- (void)updateDatas
{
    EvaluatesModel *evaModel = self.detailModel.evaluates.firstObject;
    if (evaModel && evaModel.offerEvaluationId) {
        self.textView.text = evaModel.evaluationComments;
        self.starView.score = evaModel.rate.integerValue;
        self.bottomView.hidden = YES;
        self.anonymousBtn.hidden = YES;
        self.anonymousLabel.hidden = YES;
        [_submitBtn setTitle:kLocalizedString(@"SUBMIT_REVIEW") forState:0];
    }else{
        self.bottomView.hidden = NO;
        self.anonymousBtn.hidden = NO;
        self.anonymousLabel.hidden = NO;
        [_submitBtn setTitle:kLocalizedString(@"SUBMIT_REVIEW") forState:0];
    }
    
    [_countView configDataWithTotalCount:500 currentCount:_textView.text.length];
    CGFloat lastRight = 16;
    CGFloat btnY = 16;
    for (EvaLabelsModel *labesModel in evaModel.labels) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:labesModel.labelName forState:0];
        btn.backgroundColor = RGBColorFrom16(0xefefef);
        [btn setTitleColor:RGBColorFrom16(0x333333) forState:0];
        btn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        btn.tag = labesModel.labelId.integerValue;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            btn.selected = !btn.selected;
            btn.backgroundColor = btn.selected ? RGBColorFrom16(0xFFE5EB): RGBColorFrom16(0xefefef);
            btn.layer.borderWidth = btn.selected ? 1: 0;
            [btn setTitleColor:btn.selected ? RGBColorFrom16(0xFF1659):RGBColorFrom16(0x333333)  forState:0];
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
        btnY = (lastRight + btnWidth + 26) > MainScreen_width*2 ? btnY+43: btnY;
        lastRight = (lastRight + btnWidth + 26) > MainScreen_width*2 ? 16: lastRight + btnWidth + 10;
    }
    self.labelsViewHei.constant = btnY+33;
    self.labelsVIew.contentSize = CGSizeMake(MainScreen_width*2, btnY+33);
    [self.imgArr removeAllObjects];
    
   
    dispatch_group_t group = dispatch_group_create();

    @weakify(self);
    for (EvaluatesContentsModel *contentModel in evaModel.contents) {
        dispatch_group_enter(group);
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:SFImage(contentModel.url)] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            @strongify(self);
            if (image) {
                [self.imgArr addObject:image];
            }
            CGFloat itemHei = (MainScreen_width-32-30)/4;
            self.photoCollectionViewHei.constant = ceil(self.imgArr.count/4.0)*(itemHei+10)+15;
            [self.photoCollectionView reloadData];
            dispatch_group_leave(group);
        }];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.imgArr addObject:@"1"];
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        CGFloat theHeight = ceil(self.imgArr.count/4.0)*(itemHei+10)+15;
        self.photoCollectionViewHei.constant = theHeight;
        [self.photoCollectionView reloadData];
    });
    
    
   
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.evaluate.detail parameters:@{@"orderItemId":_orderItemId} success:^(id  _Nullable response) {
        weakself.detailModel = [ReviewDetailModel yy_modelWithDictionary:response];
        if (weakself.detailModel.evaluates.count == 0 || !weakself.detailModel.evaluates) {
            [weakself loadEvaInfoModel];
        }else{
            [weakself updateDatas];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadEvaInfoModel
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.evaluate.storeorder parameters:@{@"orderId":_model.orderId} success:^(id  _Nullable response) {
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
        if (weakself.imgArr.count < 9 && !a) {
            [weakself.imgArr insertObject:@"1" atIndex:weakself.imgArr.count];
        }
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        weakself.photoCollectionViewHei.constant = ceil(weakself.imgArr.count/4.0)*(itemHei+10)+15;
        [weakself.photoCollectionView reloadData];
        
        if (weakself.selectAssets.count > index) {
            [weakself.selectAssets removeObjectAtIndex:index];
        }
        [collectionView reloadData];
    };
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
        [weakself.selectAssets addObjectsFromArray:assets];
        if (images.count != 9) {
            [weakself.imgArr addObject:@"1"];
        }
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        weakself.photoCollectionViewHei.constant = ceil(weakself.imgArr.count/4.0)*(itemHei+10)+15;
        [weakself.photoCollectionView reloadData];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}
/**
 {"evaluateItems":[{"orderItemId":50004,"ratingComments":"Ffff ","rate":3,"labelIds":[],"contents":[{"catgType":"B","url":"/get/resource/A3840564-1B7D-4A26-B801-9140CC071E811467785989878583296.jpeg","imgUrl":"","seq":0,"name":"A3840564-1B7D-4A26-B801-9140CC071E81.jpeg"},{"catgType":"B","url":"/get/resource/B8ED63AB-8F24-4AB3-A86F-3FAEEFDE031F1467786024691306496.png","imgUrl":"","seq":1,"name":"B8ED63AB-8F24-4AB3-A86F-3FAEEFDE031F.png"}],"isAnonymous":"Y"}],"store":{"rate":4,"rate1":3,"rate2":5,"storeId":11,"orderId":50004,"isAnonymous":"Y"}}
 **/
- (IBAction)submitAction:(UIButton *)sender {
    if ([_textView.text isEqualToString:@""]) {
        [MBProgressHUD showTopErrotMessage:kLocalizedString(@"PLEASE_FILL_IN_COMMENTS")];
        return;
    }
    [self publishImage];
}
- (void)publishImage
{
    //先上传图片
    //[MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    MPWeakSelf(self)
    __block NSInteger i = 0;
    __block NSMutableArray *imgUrlArr = [NSMutableArray array];
    for (id item in _imgArr) {
        if ([item isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            [SFNetworkManager postImage:SFNet.h5.publishImg image:item success:^(id  _Nullable response) {
                @synchronized (response) {
                    [imgUrlArr addObject:@{@"catgType":@"B",@"url":response[@"fullPath"],@"imgUrl":@"",@"seq":@(i),@"name":response[@"fileName"]}];
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
        [self publishReview:imgUrlArr];
    });
}
- (void)publishReview:(NSArray *)imgUrlArr
{
    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    if (self.detailModel.evaluates.count > 0 && [self.detailModel.evaluates.firstObject offerEvaluationId]) {
        //修改
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableArray *evaluateItems = [NSMutableArray array];
//        for (NSInteger i = 0; i<_model.orderItems.count; i++) {
            orderItemsModel *itemModel = _model.orderItems[_row];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:itemModel.orderItemId forKey:@"orderItemId"];
            [dic setValue:_textView.text forKey:@"ratingComments"];
            [dic setValue:@(_starView.score) forKey:@"rate"];
            [dic setValue:imgUrlArr forKey:@"contents"];
            NSMutableArray *labelsArr = [NSMutableArray array];
            for (UIView *subView in self.labelsVIew.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    if ([(UIButton *)subView isSelected]) {
                        [labelsArr addObject:@(subView.tag)];
                    }
                }
            }
            [dic setValue:labelsArr forKey:@"labelIds"];
            [evaluateItems addObject:dic];
//        }
        [params setValue:evaluateItems forKey:@"evaluateItems"];
        [params setValue:@{} forKey:@"store"];
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
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableArray *evaluateItems = [NSMutableArray array];
        for (NSInteger i = 0; i<_model.orderItems.count; i++) {
            orderItemsModel *itemModel = _model.orderItems[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:itemModel.orderItemId forKey:@"orderItemId"];
            [dic setValue:_textView.text forKey:@"ratingComments"];
            [dic setValue:@(_starView.score) forKey:@"rate"];
            [dic setValue:imgUrlArr forKey:@"contents"];
            [dic setValue:_anonymousBtn.selected ? @"Y": @"N" forKey:@"isAnonymous"];
            NSMutableArray *labelsArr = [NSMutableArray array];
            for (UIView *subView in self.labelsVIew.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    if ([(UIButton *)subView isSelected]) {
                        [labelsArr addObject:@(subView.tag)];
                    }
                }
            }
            [dic setValue:labelsArr forKey:@"labelIds"];
            [evaluateItems addObject:dic];
        }
        [params setValue:evaluateItems forKey:@"evaluateItems"];
        [params setValue:@{@"rate":@(_starView1.score),@"rate1":@(_starView2.score),@"rate2":@(_starView3.score),@"storeId":self.model.storeId,@"orderId":self.model.orderId,@"isAnonymous":_anonymousBtn.selected ? @"Y": @"N"} forKey:@"store"];
        [SFNetworkManager post:SFNet.evaluate.addEvaluate parameters:params success:^(id  _Nullable response) {
            [MBProgressHUD hideFromKeyWindow];
            if (weakself.block) {
                weakself.block();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KOrderEvaluateRefresh" object:nil];
            ReviewSuccessViewController *vc = [[ReviewSuccessViewController alloc] init];
            [weakself.navigationController pushViewController:vc animated:YES];
            [baseTool removeVCFromNavigation:self];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD hideFromKeyWindow];
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }
}
- (IBAction)anonymousAction:(UIButton *)sender {
    sender.selected = !sender.selected;
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

-(NSMutableArray *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [[NSMutableArray alloc] init];
    }
    return _selectAssets;
}

@end
