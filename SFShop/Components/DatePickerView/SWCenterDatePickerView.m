//
//  SWCenterDatePickerView.m
//  SWDatePickerDemo
//
//  Created by hn on 2020/9/11.
//  Copyright © 2020 SW. All rights reserved.
//

#import "SWCenterDatePickerView.h"
#import "InitializationUIMethod.h"

static const unsigned componentFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
NSInteger MINYEAR = 1970;

@interface SWCenterDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    // 日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    
    //记录日期位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    
    // 记录选择日期
    NSString *_dateStr;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, retain) NSDate *scrollToDate;    // 滚到指定日期

@property (nonatomic, assign) DatePickerViewType viewType;

@end

@implementation SWCenterDatePickerView

- (id)initDatePickerViewWithType:(DatePickerViewType)type Delegate:(id)delegate{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.viewType = type;
        self.delegate = delegate;
        
        [self defaultConfig];
        [self createDatePickerView];
        
        NSDate *datenow = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:type == DatePickerViewType_YM ? @"yyyy-MM" : @"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate: datenow];
        
        _dateStr = currentDateStr;
        
        [self getNowDate:[NSDate date] animated:YES];
    }
    return self;
}

#pragma mark - privateMethod

- (void)showDatePickerView{
    
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowscene in [UIApplication sharedApplication].connectedScenes) {
            if (windowscene.activationState == UISceneActivationStateForegroundActive) {
                window = windowscene.windows.firstObject;
                window.hidden = NO;
                break;
            }
        }
    }
    else{
        window = [UIApplication sharedApplication].windows[0];
    }
    [window addSubview:self];

    [self exChangeOut:_bgView dur:0.5];
}

- (void)sureBtnClick{
    
    if (self.viewType == DatePickerViewType_YM) {
        _dateStr = [NSString stringWithFormat:@"%@-%@",_yearArray[yearIndex],_monthArray[monthIndex]];
        
        if ([self.delegate respondsToSelector:@selector(selectWithSelectTime:withYear:withMonth:)]) {
            [self.delegate selectWithSelectTime:_dateStr withYear:_yearArray[yearIndex] withMonth:_monthArray[monthIndex]];
        }
    }
    else{
        _dateStr = [NSString stringWithFormat:@"%@-%@-%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex]];
        
        if ([self.delegate respondsToSelector:@selector(selectWithSelectTime:withYear:withMonth:withDay:)]) {
            [self.delegate selectWithSelectTime:_dateStr withYear:_yearArray[yearIndex] withMonth:_monthArray[monthIndex] withDay:_dayArray[dayIndex]];
        }
    }
    
    [self removeFromSuperview];
}
- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
         [self removeFromSuperview];
    }
   
}

- (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
}

#pragma mark - 日期处理

- (void)defaultConfig{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *d = [cal components:componentFlags fromDate:date];
    NSInteger MAXYEAR = [d year];
    
    _yearArray = [NSMutableArray array];
    _monthArray = [NSMutableArray array];
    _dayArray = [NSMutableArray array];
    
    for (int i=1; i<13; i++){
       NSString *num = [NSString stringWithFormat:@"%02d",i];
       [_monthArray addObject:num];
    }
    
    for (NSInteger i = MINYEAR; i <= MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    for (int i = 1; i <= 31; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_dayArray addObject:num];
    }
}

- (void)configDayArrayWithDaysNumber:(NSInteger)numer{
    
    [_dayArray removeAllObjects];
    
    for (NSInteger i = 1; i <= numer; i ++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_dayArray addObject:num];
    }
    
}

- (void)setCurrentTime:(NSString *)currentTime{
    _currentTime = currentTime;
    
    if (currentTime.length == 0) {
        return;
    }
    
    _dateStr = currentTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.viewType == DatePickerViewType_YM ? @"yyyy-MM" : @"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:currentTime];
    
    [self getNowDate:date animated:YES];
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    //date 日期为空 显示当前日期
    if (!date) {
        date = [NSDate date];
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:componentFlags fromDate:date];
    
    yearIndex = components.year - MINYEAR;
    monthIndex = components.month - 1;
    dayIndex = components.day - 1;
    
    NSArray *indexArray;
    
    if (self.viewType == DatePickerViewType_YM) {
        indexArray = @[@(yearIndex),@(monthIndex)];
    }
    else{
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    }
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
    }
}

// 通过年月求天数
- (void)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month{
    
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0 ? (num_year%400==0?YES:NO) : YES) : NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            [self configDayArrayWithDaysNumber:31];
        }
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:{
            [self configDayArrayWithDaysNumber:30];
        }
            break;
            
        case 2:{
            if (isrunNian) {
                [self configDayArrayWithDaysNumber:29];
            }
            else{
                [self configDayArrayWithDaysNumber:28];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.viewType == DatePickerViewType_YM ? 2 : 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _yearArray.count;
    }
    else if(component == 1){
        return _monthArray.count;
    }
    else{
        return _dayArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    if (pickerView.subviews.count > 2) {
        ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    }
   
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel)
    {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        customLabel.textColor = [UIColor blackColor];
        [customLabel setFont:CHINESE_SYSTEM(14)];
       
        UIView *line = InsertView(customLabel, CGRectZero, RGBColorFrom16(0xA7B0C2));
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(customLabel);
            make.size.mas_equalTo(CGSizeMake(40, 1));
            make.bottom.mas_equalTo(customLabel.mas_bottom);
        }];
    }
    
    NSString *title;
    switch (component)
    {
        case 0:
            title = _yearArray[row];
            break;
            
        case 1:
            title = _monthArray[row];
            break;
            
        case 2:
            title = _dayArray[row];
            break;
    
        default:
            break;
    }

    //赋值
    customLabel.text = title;
    customLabel.textColor = [UIColor blackColor];
    
    return customLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (self.viewType == DatePickerViewType_YM) {
        return 90;
    }
    else{
        return 60;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {

        [self DaysfromYear:[_yearArray[row] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        yearIndex = row;
    }
    else if (component == 1) {
       
        [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[row] integerValue]];
        monthIndex = row;
        
        if (dayIndex == _dayArray.count || dayIndex > _dayArray.count) {
            dayIndex = _dayArray.count - 1;
        }
        
    }
    else if (component == 2){
        dayIndex = row;
    }
    
    [pickerView reloadAllComponents];
}

#pragma mark - setUI

-(void)createDatePickerView{
     self.backgroundColor = UIColorFromHEXA(0x333333, 0.3);
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.datePicker];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.sureBtn];
    [self.bgView addSubview:self.cancelBtn];

    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(310, 245));
        make.center.mas_equalTo(self);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_offset(180);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView.mas_centerX);
        make.height.mas_offset(45);
    }];

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView.mas_centerX);
        make.height.mas_offset(45);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
        make.height.mas_offset(0.5);
    }];
}

#pragma mark - getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = InsertView(nil, CGRectZero, [UIColor whiteColor]);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (UIView *)line{
    if (!_line) {
        _line = InsertView(nil, CGRectZero, [UIColor blackColor]);
    }
    return _line;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = InsertTitleButton(nil, CGRectZero, 88, @"SELECT", CHINESE_SYSTEM(15), RGBColorFrom16(0xFF1659), nil, self, @selector(sureBtnClick));
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = InsertTitleButton(nil, CGRectZero, 88, @"CANCEL", CHINESE_SYSTEM(15), RGBColorFrom16(0x999999), nil, self, @selector(cancelBtnClick));
    }
    return _cancelBtn;
}

@end
