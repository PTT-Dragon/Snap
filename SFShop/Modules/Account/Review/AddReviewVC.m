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

@interface AddReviewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*imgArr;

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
    for (orderItemsModel *itemModel in model.orderItems) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"1"];
        [self.imgArr addObject:arr];
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
        return cell;
    }
    AddReviewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddReviewItemCell"];
    [cell setContent:_model.orderItems[indexPath.row] row:indexPath.row imgArr:self.imgArr[indexPath.row]];
    cell.block = ^(NSInteger row) {
        [self uploadAvatarWithRow:row];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
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


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
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
