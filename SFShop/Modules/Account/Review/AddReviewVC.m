//
//  AddReviewVC.m
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "AddReviewVC.h"
#import "AddReviewItemCell.h"
#import "AddReviewStoreItemCell.h"
#import "ZLPhotoBrowser.h"
#import "ReviewSuccessViewController.h"



@interface AddReviewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*imgArr;
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*imgUrlArr;
@property (nonatomic,strong) NSMutableArray *textArr;
@property (nonatomic,strong) NSMutableArray *rateArr;
@property (nonatomic,copy) NSString *score1;
@property (nonatomic,copy) NSString *score2;
@property (nonatomic,copy) NSString *score3;
@property (nonatomic,copy) NSString *Anonymous;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation AddReviewVC
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Review");
    self.score1 = @"5";
    self.score2 = @"5";
    self.score3 = @"5";
    self.Anonymous = @"N";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
    }];
}
- (void)setContent:(OrderModel *)model block:(AddReviewVCBlock)block
{
    _model = model;
    _block = block;
    self.imgArr = [NSMutableArray arrayWithCapacity:model.orderItems.count];
    self.textArr = [NSMutableArray array];
    self.rateArr = [NSMutableArray array];
    for (orderItemsModel *itemModel in model.orderItems) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"1"];
        [self.imgArr addObject:arr];
        [self.textArr addObject:@""];
        [self.rateArr addObject:@"5"];
    }
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.orderItems.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _model.orderItems.count) {
        AddReviewStoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddReviewStoreItemCell"];
        cell.model = self.model;
        cell.block = ^(NSString * _Nonnull score1, NSString * _Nonnull score2, NSString * _Nonnull score3) {
            self.score1 = score1;
            self.score2 = score1;
            self.score3 = score1;
        };
        return cell;
    }
    AddReviewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddReviewItemCell"];
    [cell setContent:_model.orderItems[indexPath.row] row:indexPath.row imgArr:self.imgArr[indexPath.row]];
    cell.block = ^(NSInteger row) {
        [self uploadAvatarWithRow:row];
    };
    cell.textBlock = ^(NSString * _Nonnull text, NSInteger row) {
        [self.textArr replaceObjectAtIndex:row withObject:text];
    };
    cell.rateBlock = ^(NSString * _Nonnull score, NSInteger row) {
        [self.rateArr replaceObjectAtIndex:row withObject:score];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHei = (MainScreen_width-32-60)/4;
    CGFloat hei = _imgArr[indexPath.row].count < 4 ? itemHei+5: _imgArr[indexPath.row].count < 8 ? 2*itemHei+10: 3* itemHei + 15;
    return indexPath.row == self.model.orderItems.count ? 300: hei+438;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//打开相册
-(void)uploadAvatarWithRow:(NSInteger)row{
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
        NSMutableArray *imgArr = weakself.imgArr[row];
        [imgArr removeAllObjects];
        [imgArr addObjectsFromArray:images];
        if (images.count != 9) {
            [imgArr addObject:@"1"];
        }
        [weakself.tableView reloadData];
//        CGFloat itemHei = (MainScreen_width-32-30)/4;
//        weakself.photoCollectionViewHei.constant = images.count < 4 ? itemHei+5: images.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
//        [weakself.photoCollectionView reloadData];
    }];
    // 调用相册
    [ac showPreviewAnimated:YES];
}
- (IBAction)submitAction:(UIButton *)sender {
    BOOL hasComment = YES;
    for (NSString *str in self.textArr) {
        if ([str isEqualToString:@""]) {
            hasComment = NO;
        }
    }
    if (!hasComment) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"PLEASE_FILL_IN_COMMENTS")];
        return;
    }
    [self publishImage];
}

- (void)publishImage
{
    //先上传图片
    [MBProgressHUD showHudMsg:@""];
    dispatch_group_t group = dispatch_group_create();
    MPWeakSelf(self)
    __block NSInteger count = 0;
    NSInteger allCount = 0;
    for (NSArray *arr in self.imgArr) {
        for (id item in arr) {
            if ([item isKindOfClass:[UIImage class]]) {
                allCount +=1;
            }
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int index = 0; index < self.imgArr.count; index ++) {
        NSArray *arr = self.imgArr[index];
        __block NSMutableArray *itemArr = [NSMutableArray array];
        __block NSInteger i = 0;
        for (id item in arr) {
            if ([item isKindOfClass:[UIImage class]]) {
                dispatch_group_enter(group);
                [SFNetworkManager postImage:SFNet.h5.publishImg image:item success:^(id  _Nullable response) {
                    @synchronized (response) {
                        [itemArr addObject:@{@"catgType":@"B",@"url":response[@"fullPath"],@"imgUrl":@"",@"seq":@(i),@"name":response[@"fileName"]}];
                        [dict setObject:itemArr forKey:[NSString stringWithFormat:@"%ld",(long)index]];
                        i++;
                        count++;
                        dispatch_group_leave(group);
                    }
                } failed:^(NSError * _Nonnull error) {
                    dispatch_group_leave(group);
                }];
            }
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        if (count == allCount) {
            [self publishReview:dict];
        }
    });
}
- (void)publishReview:(NSDictionary *)imgUrlDict
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *evaluateItems = [NSMutableArray array];
    for (NSInteger i = 0; i<_model.orderItems.count; i++) {
        orderItemsModel *itemModel = _model.orderItems[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:itemModel.orderItemId forKey:@"orderItemId"];
        [dic setValue:self.textArr[i] forKey:@"ratingComments"];
        [dic setValue:self.rateArr[i] forKey:@"rate"];
        [dic setValue:[imgUrlDict objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] forKey:@"contents"];
        [dic setValue:_Anonymous forKey:@"isAnonymous"];
        [evaluateItems addObject:dic];
    }
    [params setValue:evaluateItems forKey:@"evaluateItems"];
    [params setValue:@{@"rate":_score1,@"rate1":_score2,@"rate2":_score3,@"storeId":self.model.storeId,@"orderId":self.model.orderId,@"isAnonymous":_Anonymous} forKey:@"store"];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.evaluate.addEvaluate parameters:params success:^(id  _Nullable response) {
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"AddReviewStoreItemCell" bundle:nil] forCellReuseIdentifier:@"AddReviewStoreItemCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddReviewItemCell" bundle:nil] forCellReuseIdentifier:@"AddReviewItemCell"];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
@end
