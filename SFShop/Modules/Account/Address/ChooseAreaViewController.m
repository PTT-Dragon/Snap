//
//  ChooseAreaViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "ChooseAreaViewController.h"
#import "AreaCell.h"
#import "UIButton+SGImagePosition.h"

typedef enum :NSUInteger{
    selProvinceType,
    selCityType,
    selDistrictType,
    selStreetType,
}selType;

@protocol chooseAreaTopViewDelegate <NSObject>

- (void)updateDataWithSelType:(selType)type;

@end

@interface chooseAreaTopView : UIView


@property (nonatomic,strong) UIButton *provinceBtn;
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UIButton *DistrictBtn;
@property (nonatomic,strong) UIButton *streetBtn;
@property (nonatomic,strong) UIView *indicationView;
@property (nonatomic,assign) id<chooseAreaTopViewDelegate>delegate;

- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel District:(AreaModel *)DistrictModel;
@property (nonatomic,strong) AreaModel *selProvinceAreaMoel;
@property (nonatomic,strong) AreaModel *selCityAreaMoel;
@property (nonatomic,strong) AreaModel *selDistrictAreaMoel;
@property (nonatomic,strong) AreaModel *selStreetAreaMoel;
@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation chooseAreaTopView
- (instancetype)initWithSelStreeModel:(AreaModel *)streeModel
{
    if (self = [super init]) {
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:0];
        _provinceBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_provinceBtn setTitle:streeModel.stdAddr  forState:0];
        _provinceBtn.titleLabel.numberOfLines = 0;
        [_provinceBtn setTitle:streeModel ? streeModel.stdAddr:@"Street"  forState:0];
        [self addSubview:_provinceBtn];
        [_provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(self);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
    }
    return self;
}
- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel District:(AreaModel *)DistrictModel street:(AreaModel *)streetModel
{
    if (self = [super init]) {
        _selProvinceAreaMoel = provinceModel;
        _selCityAreaMoel = cityModel;
        _selDistrictAreaMoel = DistrictModel;
        _selStreetAreaMoel = streetModel;
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:0];
        _provinceBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_provinceBtn setTitle:provinceModel ? provinceModel.stdAddr:@"Province"  forState:0];
        _provinceBtn.titleLabel.numberOfLines = 0;
        @weakify(self)
        [[_provinceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selProvinceAreaMoel) {
                [self.delegate updateDataWithSelType:selProvinceType];
            }
        }];
        [self addSubview:_provinceBtn];
        [_provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(self);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:0];
        _cityBtn.titleLabel.font = CHINESE_SYSTEM(14);
        _cityBtn.titleLabel.numberOfLines = 0;
        [_cityBtn setTitle:cityModel.stdAddr forState:0];
        [self addSubview:_cityBtn];
        [[_cityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selCityAreaMoel) {
                [self.delegate updateDataWithSelType:selCityType];
            }
        }];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.provinceBtn.mas_right).offset(10);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        _DistrictBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_DistrictBtn setTitleColor:[UIColor blackColor] forState:0];
        _DistrictBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_DistrictBtn setTitle:DistrictModel.stdAddr forState:0];
        _DistrictBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_DistrictBtn];
        [[_DistrictBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selDistrictAreaMoel) {
                [self.delegate updateDataWithSelType:selDistrictType];
            }
        }];
        [_DistrictBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.cityBtn.mas_right).offset(10);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        _streetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_streetBtn setTitleColor:[UIColor blackColor] forState:0];
        _streetBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_streetBtn setTitle:streetModel.stdAddr forState:0];
        _streetBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_streetBtn];
        [_streetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.DistrictBtn.mas_right).offset(10);
            make.right.mas_lessThanOrEqualTo(self);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        [self addSubview:self.indicationView];
        [self.indicationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.provinceBtn);
            make.centerX.mas_equalTo(self.selStreetAreaMoel ? self.streetBtn: self.selDistrictAreaMoel ? self.DistrictBtn: self.selCityAreaMoel ? self.cityBtn: self.provinceBtn);
        }];
    }
    return self;
}
- (instancetype)initWithSelAreaModel:(AreaModel *)provinceModel selCity:(AreaModel *)cityModel District:(AreaModel *)DistrictModel
{
    if (self = [super init]) {
        _selProvinceAreaMoel = provinceModel;
        _selCityAreaMoel = cityModel;
        _selDistrictAreaMoel = DistrictModel;
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_provinceBtn setTitleColor:[UIColor blackColor] forState:0];
        _provinceBtn.titleLabel.font = CHINESE_SYSTEM(14);
        [_provinceBtn setTitle:provinceModel ? provinceModel.stdAddr:@"Province"  forState:0];
        _provinceBtn.titleLabel.numberOfLines = 0;
        @weakify(self)
        [[_provinceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selProvinceAreaMoel) {
                [self.delegate updateDataWithSelType:selProvinceType];
            }
        }];
//        [_provinceBtn SG_imagePositionStyle:SGImagePositionStyleRight spacing:5];
        [self addSubview:_provinceBtn];
        [_provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(self);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:0];
        _cityBtn.titleLabel.font = CHINESE_SYSTEM(14);
        _cityBtn.titleLabel.numberOfLines = 0;
        [_cityBtn setTitle:cityModel.stdAddr forState:0];
        [self addSubview:_cityBtn];
        [[_cityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.selCityAreaMoel) {
                [self.delegate updateDataWithSelType:selCityType];
            }
        }];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.left.mas_equalTo(self.provinceBtn.mas_right).offset(10);
            make.width.mas_greaterThanOrEqualTo(80);
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
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        [self addSubview:self.indicationView];
        [self.indicationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.provinceBtn);
            make.centerX.mas_equalTo(self.selDistrictAreaMoel ? self.DistrictBtn: self.selCityAreaMoel ? self.cityBtn: self.provinceBtn);
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
            make.width.mas_equalTo(self.cityBtn);
            make.centerX.mas_equalTo((!self.selStreetAreaMoel && !self.selCityAreaMoel && !self.selDistrictAreaMoel) ? self.provinceBtn: (!self.selDistrictAreaMoel && !self.selStreetAreaMoel) ? self.cityBtn: !self.selStreetAreaMoel ? self.DistrictBtn: self.streetBtn);
        }];
        self.indicationView.hidden = NO;
    }
    if (!_selCityAreaMoel) {
        [_cityBtn setTitle:@"" forState:0];
    }else if (!_selDistrictAreaMoel) {
        [_DistrictBtn setTitle:@"" forState:0];
    }else if (!_selStreetAreaMoel) {
        [_streetBtn setTitle:@"" forState:0];
    }
}
- (void)setSelCityAreaMoel:(AreaModel *)selCityAreaMoel
{
    _selCityAreaMoel = selCityAreaMoel;
    [_cityBtn setTitle:selCityAreaMoel.stdAddr forState:0];
    if (selCityAreaMoel) {
//        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(1);
//            make.top.mas_equalTo(self.cityBtn.mas_bottom);
//            make.width.mas_equalTo(self.DistrictBtn);
//            make.centerX.mas_greaterThanOrEqualTo(self.DistrictBtn);
//        }];
        self.indicationView.hidden = NO;
    }
}
- (void)setSelDistrictAreaMoel:(AreaModel *)selDistrictAreaMoel
{
    _selDistrictAreaMoel = selDistrictAreaMoel;
    [_DistrictBtn setTitle:selDistrictAreaMoel.stdAddr forState:0];
    if (selDistrictAreaMoel) {
//        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(1);
//            make.top.mas_equalTo(self.cityBtn.mas_bottom);
//            make.width.mas_equalTo(self.DistrictBtn);
//            make.centerX.mas_greaterThanOrEqualTo(self.DistrictBtn);
//        }];
        self.indicationView.hidden = NO;
    }
}

-(void)setCurIndex:(NSInteger)curIndex {
    _curIndex = curIndex;
    
    if (curIndex == 1) {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.cityBtn);
            make.centerX.mas_equalTo(self.cityBtn);
        }];
//        [self.DistrictBtn setTitle:@"" forState:0];
    }else if (curIndex == 2) {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.cityBtn);
            make.centerX.mas_equalTo(self.DistrictBtn);
        }];
    }else {
        [_indicationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.cityBtn.mas_bottom);
            make.width.mas_equalTo(self.cityBtn);
            make.centerX.mas_equalTo(self.provinceBtn);
        }];
//        [self.cityBtn setTitle:@"" forState:0];
//        [self.DistrictBtn setTitle:@"" forState:0];
    }
    
    if (!_selCityAreaMoel) {
        [_cityBtn setTitle:@"City" forState:0];
    }else if (!_selDistrictAreaMoel) {
        [_DistrictBtn setTitle:@"District" forState:0];
    }else if (!_selStreetAreaMoel) {
        [_streetBtn setTitle:@"Street" forState:0];
    }
}

- (UIView *)indicationView
{
    if (!_indicationView) {
        _indicationView = [[UIView alloc] init];
        _indicationView.backgroundColor = [UIColor blackColor];
    }
    return _indicationView;
}
@end

typedef enum :NSUInteger{
    loadProvinceType,
    loadCityType,
    loadDistrictType,
    loadStreeType,
}loadDataType;

@interface ChooseAreaViewController ()<UITableViewDelegate,UITableViewDataSource,chooseAreaTopViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) chooseAreaTopView *topView;
@property (nonatomic,assign) loadDataType dataType;
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ChooseAreaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Area");
    self.theTitle.text = kLocalizedString(@"Area");
    _dataSource = [NSMutableArray array];
   
    _tableView.showsVerticalScrollIndicator = NO;
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
    
    self.view.backgroundColor = [UIColor clearColor];

    if (self.type == 2 || self.type == 5) {
        //只展示街道
        _topView = [[chooseAreaTopView alloc] initWithSelStreeModel:_selStreetAreaMoel];
    }else if(self.type == 6){
        _topView = [[chooseAreaTopView alloc] initWithSelAreaModel:_selProvinceAreaMoel selCity:_selCityAreaMoel District:_selDistrictAreaMoel street:_selStreetAreaMoel];
    }else{
        _topView = [[chooseAreaTopView alloc] initWithSelAreaModel:_selProvinceAreaMoel selCity:_selCityAreaMoel District:_selDistrictAreaMoel];
    }
    _topView.delegate = self;
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_tableView.mas_top);
        make.height.mas_equalTo(50);
    }];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self loadDatasWithType:_dataType];
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
- (void)setSelStreetAreaMoel:(AreaModel *)selStreetAreaMoel
{
    _selStreetAreaMoel = selStreetAreaMoel;
}
-(void)setCurIndex:(NSInteger)curIndex {
    _curIndex = curIndex;
}
- (void)setType:(NSInteger)type
{
    _type = type;
    _dataType = type == 1 ? loadProvinceType: type == 2 ? loadStreeType: type == 3 ? loadProvinceType: type == 4 ? loadDistrictType: loadStreeType;
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)loadDatasWithType:(loadDataType)type
{
    MPWeakSelf(self)
    switch (type) {
        case loadProvinceType:
        {
            [SFNetworkManager get:SFNet.address.areaData parameters:@{@"addrLevelId":@(2)} success:^(id  _Nullable response) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
                [weakself.dataSource enumerateObjectsUsingBlock:^(AreaModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.stdAddr isEqualToString: weakself.selProvinceAreaMoel.stdAddr]) {
                        obj.sel = YES;
                    }
                }];
                [weakself.tableView reloadData];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
        case loadCityType:{
            [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selProvinceAreaMoel.stdAddrId} success:^(id  _Nullable response) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
                [weakself.dataSource enumerateObjectsUsingBlock:^(AreaModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.stdAddr isEqualToString: weakself.selCityAreaMoel.stdAddr]) {
                        obj.sel = YES;
                    }
                }];
                [weakself.tableView reloadData];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
        case loadDistrictType:{
            [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selCityAreaMoel.stdAddrId} success:^(id  _Nullable response) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
                [weakself.dataSource enumerateObjectsUsingBlock:^(AreaModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.stdAddr isEqualToString: weakself.selDistrictAreaMoel.stdAddr]) {
                        obj.sel = YES;
                    }
                }];
                [weakself.tableView reloadData];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
        case loadStreeType:
        {
            //已选择地区 选择街道
            [SFNetworkManager get:SFNet.address.areaData parameters:@{@"parentId":_selDistrictAreaMoel.stdAddrId} success:^(id  _Nullable response) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AreaModel arrayOfModelsFromDictionaries:response error:nil]];
                [weakself.dataSource enumerateObjectsUsingBlock:^(AreaModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.stdAddr isEqualToString: weakself.selStreetAreaMoel.stdAddr]) {
                        obj.sel = YES;
                    }
                }];
                [weakself.tableView reloadData];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
            break;
        default:
            break;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AreaModel *model = self.dataSource[indexPath.row];
    switch (_dataType) {
        case loadProvinceType:
            _dataType = loadCityType;
            _selProvinceAreaMoel = model;
            _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
            [self loadDatasWithType:_dataType];
            _topView.curIndex = 1;
            break;
        case loadCityType:
            _dataType = loadDistrictType;
            _selCityAreaMoel = model;
            _topView.selCityAreaMoel = _selCityAreaMoel;
            _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
            [self loadDatasWithType:_dataType];
            _topView.curIndex = 2;
            break;
        case loadDistrictType:
            _dataType = loadStreeType;
            _selDistrictAreaMoel = model;
            _topView.selDistrictAreaMoel = _selDistrictAreaMoel;
            _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
            if (self.type == 3 || self.type == 6) {
                //还需要选择街道
                [self loadDatasWithType:_dataType];
            }else{
                [self.delegate chooseProvince:_selProvinceAreaMoel city:_selCityAreaMoel district:_selDistrictAreaMoel];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            _topView.curIndex = 2;
            break;
        case loadStreeType:
            _dataType = loadStreeType;
            _selStreetAreaMoel = model;
            _topView.selProvinceAreaMoel = _selProvinceAreaMoel;
            if (self.type == 3 || self.type == 6) {
                //把所有的数据都回调回去
                [self.delegate chooseProvince:_selProvinceAreaMoel city:_selCityAreaMoel district:_selDistrictAreaMoel street:_selStreetAreaMoel];
            }else{
                [self.delegate chooseStreet:_selStreetAreaMoel];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}
#pragma mark - delegate
- (void)updateDataWithSelType:(selType)type
{
    if (type == selProvinceType) {
        self.selCityAreaMoel = nil;
        self.selDistrictAreaMoel = nil;
        self.selStreetAreaMoel = nil;
        _dataType = loadProvinceType;
    }else if (type == selCityType){
        self.selDistrictAreaMoel = nil;
        self.selStreetAreaMoel = nil;
        _dataType = loadCityType;
    }else if (type == selDistrictType){
        self.selStreetAreaMoel = nil;
        _dataType = loadDistrictType;
    }else if (type == selStreetType){
        self.selStreetAreaMoel = nil;
        _dataType = loadStreeType;
    }
    _topView.selDistrictAreaMoel = self.selDistrictAreaMoel;
    _topView.selCityAreaMoel = self.selCityAreaMoel;
    _topView.selStreetAreaMoel = self.selStreetAreaMoel;
    _topView.selProvinceAreaMoel = self.selProvinceAreaMoel;
    [self loadDatasWithType:_dataType];
}


@end
