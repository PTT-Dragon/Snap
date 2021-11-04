//
//  ChooseAreaViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "ChooseAreaViewController.h"
#import "AreaCell.h"
#import "UIButton+SGImagePosition.h"


@interface chooseAreaTopView : UIView
@property (nonatomic,strong) UIButton *provinceBtn;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UIButton *streetBtn;

- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel street:(AreaModel *)streetModel;
@property (nonatomic,weak) AreaModel *selProvinceAreaMoel;
@property (nonatomic,weak) AreaModel *selCityAreaMoel;
@property (nonatomic,weak) AreaModel *selStreetAreaMoel;
@end

@implementation chooseAreaTopView
- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel street:(AreaModel *)streetModel
{
    if (self = [super init]) {
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:0];
        _provinceBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_provinceBtn setTitle:provinceModel.stdAddr forState:0];
        _provinceBtn.titleLabel.numberOfLines = 0;
//        [_provinceBtn setImage:[UIImage imageNamed:@"swipe-down"] forState:0];
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
        _streetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_streetBtn setTitleColor:[UIColor blackColor] forState:0];
        _streetBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_streetBtn setTitle:streetModel.stdAddr forState:0];
        _streetBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_streetBtn];
        [_streetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.cityBtn.mas_right).offset(10);
        }];
    }
    return self;
}
- (void)setSelProvinceAreaMoel:(AreaModel *)selProvinceAreaMoel
{
    _selProvinceAreaMoel = selProvinceAreaMoel;
    [_provinceBtn setTitle:selProvinceAreaMoel.stdAddr forState:0];
}
- (void)setSelCityAreaMoel:(AreaModel *)selCityAreaMoel
{
    _selCityAreaMoel = selCityAreaMoel;
    [_cityBtn setTitle:selCityAreaMoel.stdAddr forState:0];
}
- (void)setSelStreetAreaMoel:(AreaModel *)selStreetAreaMoel
{
    _selStreetAreaMoel = selStreetAreaMoel;
    [_streetBtn setTitle:selStreetAreaMoel.stdAddr forState:0];
}
@end



@interface ChooseAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) chooseAreaTopView *topView;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Area";
    _dataSource = [NSMutableArray array];
    [self loadDatas];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(150);
    }];
    _topView = [[chooseAreaTopView alloc] initWithSelAreaModel:_selProvinceAreaMoel selCity:_selCityAreaMoel street:_selStreetAreaMoel];
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
- (void)setSelStreetAreaMoel:(AreaModel *)selStreetAreaMoel
{
    _selStreetAreaMoel = selStreetAreaMoel;
}
- (void)loadDatas
{
    MPWeakSelf(self)
    if (_selProvinceAreaMoel && _selProvinceAreaMoel.addrLevelId) {
        //说明有已选择的省
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selProvinceAreaMoel.addrLevelId} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }else if (_selCityAreaMoel && _selCityAreaMoel.addrLevelId){
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selCityAreaMoel.addrLevelId} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }else{
        [SFNetworkManager get:SFNet.address.areaData parameters:@{@"addrLevelId":@(2)} success:^(id  _Nullable response) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
            [weakself.tableView reloadData];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }
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
        _selProvinceAreaMoel.addrLevelId = model.addrLevelId;
        _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
    }else if (!_selCityAreaMoel || !_selCityAreaMoel.addrLevelId){
        _selCityAreaMoel = model;
        _topView.selCityAreaMoel = _selCityAreaMoel;
    }else{
        _selStreetAreaMoel = model;
        _topView.selStreetAreaMoel = _selStreetAreaMoel;
//        [self.delegate chooseProvince:_selProvinceAreaMoel city:_selCityAreaMoel street:_selStreetAreaMoel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
