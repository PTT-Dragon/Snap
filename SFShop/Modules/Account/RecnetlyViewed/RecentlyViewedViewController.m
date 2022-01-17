//
//  RecentlyViewedViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/18.
//

#import "RecentlyViewedViewController.h"
#import <JTCalendar/JTCalendar.h>
#import "RecentlyViewedCell.h"
#import "RecentlyModel.h"
#import "EmptyView.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductViewController.h"

@interface RecentlyViewedViewController ()<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
    NSDate *_todayDate;
    BOOL _selectionMode;
}
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (nonatomic,strong) NSDate *dateSelected;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHei;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataListSource;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation RecentlyViewedViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Recently_Viewed");
    _dataSource = [NSMutableArray array];
    _dataListSource = [NSMutableArray array];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [self createRandomEvents];
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _dateSelected = [NSDate date];
    _selectionMode = NO;
    [self initUI];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self loadDatas];
    [self changeModeAction:self.clickBtn];
}
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(_calendarContentView.mas_bottom).offset(20);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecentlyViewedCell" bundle:nil] forCellReuseIdentifier:@"RecentlyViewedCell"];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (void)loadDatas
{
    self.pageIndex = 1;
    MPWeakSelf(self)
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *selDay = [formatter1 stringFromDate:_dateSelected];
    NSDate *startDate = [_calendarManager.dateHelper addToDate:_dateSelected months:-1];
    [SFNetworkManager get:SFNet.recent.list parameters:@{@"startDate":startDate,@"endDate":selDay,@"pageIndex":@(self.pageIndex),@"pageSize":@(1000)} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        [weakself.dataSource removeAllObjects];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[RecentlyModel alloc] initWithDictionary:dic error:nil]];
            }
        }
        [weakself handleDatas];
        [weakself.tableView reloadData];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself showEmptyView];
    }];
}
- (void)loadMoreDatas
{
    self.pageIndex ++;
    MPWeakSelf(self)
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *selDay = [formatter1 stringFromDate:_dateSelected];
    NSDate *startDate = [_calendarManager.dateHelper addToDate:_dateSelected months:-1];
    [SFNetworkManager get:SFNet.recent.list parameters:@{@"startDate":startDate,@"endDate":selDay,@"pageIndex":@(self.pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.tableView.mj_footer endRefreshing];
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[RecentlyModel alloc] initWithDictionary:dic error:nil]];
            }
        }
        [weakself handleDatas];
        [weakself.tableView reloadData];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself showEmptyView];
    }];
}
- (void)handleDatas
{
    [_dataListSource removeAllObjects];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
    for (NSInteger i = 0; i<array.count; i++) {
        RecentlyModel *obj1 = array[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:obj1];
        for (NSInteger j = i+1; j<array.count; j++) {
            RecentlyModel *obj2 = array[j];
            if ([_calendarManager.dateHelper date:obj1.date isTheSameDayThan:obj2.date]) {
                [tempArray addObject:obj2];
                [array removeObjectAtIndex:j];
                j-=1;
            }
        }
        if (tempArray.count != 0) {
            [_dataListSource addObject:tempArray];
        }
    }
}

- (void)showEmptyView {
    if (self.dataSource.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

#pragma mark - tableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataListSource[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataListSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = _dataListSource[indexPath.section];
    RecentlyViewedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyViewedCell"];
    [cell setContent:arr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arr = _dataListSource[section];
    RecentlyModel *model = arr.firstObject;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 50)];
    if (model) {
        label.text = model.createdDateNoH;
    }
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = _dataListSource[indexPath.section];
    RecentlyModel *model = arr[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self deleteCellWithRow:indexPath.row];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
 
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLocalizedString(@"Delete");
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    NSDate *date1 = [_calendarManager.dateHelper addToDate:[NSDate date] months:-1];
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor redColor];
        dayView.textLabel.text = kLocalizedString(@"Today");
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.hidden = NO;
        dayView.textLabel.textColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor redColor];
    }else if ([_calendarManager.dateHelper date:dayView.date isEqualOrAfter:date1 andEqualOrBefore:[NSDate date]]){
        dayView.circleView.hidden = YES;
        dayView.dotView.hidden = NO;
        if ([self hasDataWithDay:dayView.date]) {
            dayView.dotView.backgroundColor = [UIColor lightGrayColor];
        }else{
            dayView.dotView.backgroundColor = [UIColor whiteColor];
        }
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    // Other month
//    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor lightGrayColor];
//    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if ([dayView.date compare:_todayDate] == NSOrderedDescending) {
        return;
    }
    NSTimeInterval timeInterval = [_todayDate timeIntervalSinceDate:dayView.date];
    if (timeInterval/86400 > 30) {
        return;
    }
    _dateSelected = dayView.date;
    [self loadDatas];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}
#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}
- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-1];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
}
- (BOOL)hasDataWithDay:(NSDate *)date
{
    __block BOOL hasData = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(RecentlyModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_calendarManager.dateHelper date:date isTheSameDayThan:obj.date]) {
            hasData = YES;
        }
    }];
    return hasData;
}
#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    return YES;
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//
//    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

- (IBAction)changeModeAction:(UIButton *)sender {
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    sender.selected = !sender.selected;
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    self.viewHei.constant = newHeight;
    [self.view layoutIfNeeded];
}
- (void)deleteCellWithRow:(NSInteger)row
{
    RecentlyModel *model = self.dataSource[row];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.recent.delete parameters:@{@"offerId":model.offerId} success:^(id  _Nullable response) {
        [weakself.dataSource removeObjectAtIndex:row];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
//    addressModel *model = self.dataSource[row];
//    MPWeakSelf(self)
//    [SFNetworkManager post:[SFNet.address setAddressDeleteOfdeliveryAddressId:model.deliveryAddressId] parameters:@{} success:^(id  _Nullable response) {
//        [weakself.dataSource removeObjectAtIndex:row];
//        [weakself.tableView reloadData];
//    } failed:^(NSError * _Nonnull error) {
//
//    }];
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoReviewType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
