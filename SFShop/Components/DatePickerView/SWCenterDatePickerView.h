//
//  SWCenterDatePickerView.h
//  SWDatePickerDemo
//
//  Created by hn on 2020/9/11.
//  Copyright © 2020 SW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DatePickerViewType_YM,   // 年月
    DatePickerViewType_YMD,  // 年月日
} DatePickerViewType;

@protocol SWCenterDatePickerViewDelegate <NSObject>

@optional

- (void)selectWithSelectTime:(NSString *)selectTime withYear:(NSString *)year withMonth:(NSString *)month;

- (void)selectWithSelectTime:(NSString *)selectTime withYear:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day;

@end

@interface SWCenterDatePickerView : UIView

@property (nonatomic, strong) NSString *currentTime;

@property (nonatomic, assign) id<SWCenterDatePickerViewDelegate> delegate;

- (id)initDatePickerViewWithType:(DatePickerViewType)type Delegate:(id)delegate;

- (void)showDatePickerView;

@end

NS_ASSUME_NONNULL_END
