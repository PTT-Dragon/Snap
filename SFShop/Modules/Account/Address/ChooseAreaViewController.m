//
//  ChooseAreaViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "ChooseAreaViewController.h"
#import "AreaCell.h"
#import "UIButton+SGImagePosition.h"

@protocol chooseAreaTopViewDelegate <NSObject>

- (void)updateData;

@end

@interface chooseAreaTopView : UIView


@property (nonatomic,strong) UIButton *provinceBtn;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UIButton *DistrictBtn;
@property (nonatomic,strong) UIView *indicationView;
@property (nonatomic,assign) id<chooseAreaTopViewDelegate>delegate;

- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel District:(AreaModel *)DistrictModel;
@property (nonatomic,strong) AreaModel *selProvinceAreaMoel;
@property (nonatomic,strong) AreaModel *selCityAreaMoel;
@property (nonatomic,strong) AreaModel *selDistrictAreaMoel;
@end

@implementation chooseAreaTopView
- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel District:(AreaModel *)DistrictModel
{
    if (self = [super init]) {
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:0];
        _provinceBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_provinceBtn setTitle:provinceModel.stdAddr forState:0];
        _provinceBtn.titleLabel.numberOfLines = 0;
//        [_provinceBtn setImage:[UIImage imageNamed:@"swipe-down"] forState:0];
        @weakify(self)
        [[_provinceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selProvinceAreaMoel) {
                self.selProvinceAreaMoel = [[AreaModel alloc]init];
                self.selCityAreaMoel = nil;
                self.selDistrictAreaMoel = nil;
                [self.delegate updateData];
            }
        }];
        [_provinceBtn SG_imagePositionStyle:SGImagePositionStyleRight spacing:5];
        [self addSubview:_provinceBtn];
        [_provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(self);
        }];
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:0];
        _cityBtn.titleLabel.font = CHINESE_SYSTEM(14);
        _cityBtn.titleLabel.numberOfLines = 0;
        [_cityBtn setTitle:cityModel.stdAddr forState:0];
        [self addSubview:_cityBtn];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.provinceBtn.mas_right).offset(10);
        }];
        _DistrictBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_DistrictBtn setTitleColor:[UIColor blackColor] forState:0];
        _DistrictBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_DistrictBtn setTitle:DistrictModel.stdAddr forState:0];
        _DistrictBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_DistrictBtn];
        [_DistrictBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.cityBtn.mas_right).offset(10);
            make.right.mas_lessThanOrEqualTo(self);
        }];
        [self addSubview:self.indicationView];
        [self.indicationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.provinceBtn);
            make.centerX.mas_equalTo(self.provinceBtn);
        }];
    }
    return self;
}
- (void)setSelProvinceAreaMoel:(AreaModel *)selProvinceAreaMoel
{
    _selProvinceAreaMoel = selProvinceAreaMoel;
    [_provinceBtn setTitle:selProvinceAreaMoel.stdAddr forState:0];
    if (selProvinceAreaMoel) {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.provinceBtn);
            make.centerX.mas_equalTo(self.provinceBtn);
        }];
        self.indicationView.hidden = NO;
    }
}
- (void)setSelCityAreaMoel:(AreaModel *)selCityAreaMoel
{
    _selCityAreaMoel = selCityAreaMoel;
    [_cityBtn setTitle:selCityAreaMoel.stdAddr forState:0];
    if (selCityAreaMoel) {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.cityBtn);
            make.centerX.mas_greaterThanOrEqualTo(self.cityBtn);
        }];
        self.indicationView.hidden = NO;
    }
}
- (void)setSelDistrictAreaMoel:(AreaModel *)selDistrictAreaMoel
{
    _selDistrictAreaMoel = selDistrictAreaMoel;
    [_DistrictBtn setTitle:selDistrictAreaMoel.stdAddr forState:0];
    if (selDistrictAreaMoel) {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.DistrictBtn);
            make.centerX.mas_greaterThanOrEqualTo(self.DistrictBtn);
        }];
        self.indicationView.hidden = NO;
    }
}

- (UIView *)indicationView
{
    if (!_indicationView) {
        _indicationView = [[UIView alloc] init];
        _indicationView.backgroundColor = [UIColor redColor];
    }
    return _indicationView;
}
@end



@interface ChooseAreaViewController ()<UITableViewDelegate,UITableViewDataSource,chooseAreaTopViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) chooseAreaTopView *topView;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Area");
    _dataSource = [NSMutableArray array];
    [self loadDatas];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    _topView = [[chooseAreaTopView alloc] initWithSelAreaModel:_selProvinceAreaMoel selCity:_selCityAreaMoel District:_selDistrictAreaMoel];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(_tableView.mas_top);
    }];
}
- (void)setSelProvinceAreaMoel:(AreaModel *)selProvinceAreaMoel
{
    _selProvinceAreaMoel = selProvinceAreaMoel;
}
- (void)setSelCityAreaMoel:(AreaModel *)selCityAreaMoel
{
    _selCityAreaMoel = selCityAreaMoel;
}
- (void)setSelDistrictAreaMoel:(AreaModel *)selDistrictAreaMoel
{
    _selDistrictAreaMoel = selDistrictAreaMoel;
}
- (void)loadDatas
{
    MPWeakSelf(self)
    if(!_selProvinceAreaMoel || !_selProvinceAreaMoel.addrLevelId){
        //都还未选
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"addrLevelId":@(2)} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }else if (!_selCityAreaMoel || !_selCityAreaMoel.addrLevelId){
        //说明有已选择的省  选择市
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selProvinceAreaMoel.stdAddrId} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }else if (!_selDistrictAreaMoel || !_selDistrictAreaMoel.addrLevelId){
        //已选择市 选择区
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selCityAreaMoel.stdAddrId} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }else{
        //已选择地区 选择街道
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selDistrictAreaMoel.stdAddrId} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }
//    if (_selProvinceAreaMoel && _selProvinceAreaMoel.addrLevelId) {
//        //说明有已选择的省  选择市
//        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selProvinceAreaMoel.addrLevelId} success:^(id  _Nullable response) {
//            [weakself.dataSource removeAllObjects];
//            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
//            [weakself.tableView reloadData];
//        } failed:^(NSError * _Nonnull error) {
//
//        }];
//    }else if (_selCityAreaMoel && _selCityAreaMoel.addrLevelId){
//        //已选择市 选择区
//        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selCityAreaMoel.addrLevelId} success:^(id  _Nullable response) {
//            [weakself.dataSource removeAllObjects];
//            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
//            [weakself.tableView reloadData];
//        } failed:^(NSError * _Nonnull error) {
//
//        }];
//    }else if(!_selProvinceAreaMoel || !_selProvinceAreaMoel.addrLevelId){
//        //都还未选
//        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"addrLevelId":@(2)} success:^(id  _Nullable response) {
//            [weakself.dataSource removeAllObjects];
//            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
//            [weakself.tableView reloadData];
//        } failed:^(NSError * _Nonnull error) {
//
//        }];
//    }else{
//        //已选择地区
//        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selDistrictAreaMoel.addrLevelId} success:^(id  _Nullable response) {
//            [weakself.dataSource removeAllObjects];
//            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
//            [weakself.tableView reloadData];
//        } failed:^(NSError * _Nonnull error) {
//
//        }];
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = self.dataSource[indexPath.row];
    if (!_selProvinceAreaMoel || !_selProvinceAreaMoel.addrLevelId) {
        _selProvinceAreaMoel = model;
        _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
    }else if (!_selCityAreaMoel || !_selCityAreaMoel.addrLevelId){
        _selCityAreaMoel = model;
        _topView.selCityAreaMoel = _selCityAreaMoel;
    }else if(!_selDistrictAreaMoel || !_selDistrictAreaMoel.addrLevelId){
        _selDistrictAreaMoel = model;
        _topView.selDistrictAreaMoel = _selDistrictAreaMoel;
        if (_type == 3) {
            //状态为3 需要全部都选择
        }else{
            [self.delegate chooseProvince:_selProvinceAreaMoel city:_selCityAreaMoel district:_selDistrictAreaMoel];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        _selStreetAreaMoel = model;
        if (_type == 3) {
            //状态为3 需要全部都选择
            [self.delegate chooseProvince:_selProvinceAreaMoel city:_selCityAreaMoel district:_selDistrictAreaMoel street:_selStreetAreaMoel];
        }else{
            [self.delegate chooseStreet:_selStreetAreaMoel];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self loadDatas];
}
#pragma mark - delegate
- (void)updateData
{
    [self loadDatas];
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
        [_tableView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
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
