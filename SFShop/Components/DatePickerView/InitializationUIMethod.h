//
//  InitializationUIMethod.h
//  SWDatePickerDemo
//
//  Created by hn on 2020/9/11.
//  Copyright © 2020 SW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InitializationUIMethod : NSObject

/// 实例化UILabel
UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor);


/// 实例化UIbutton
UIButton *InsertTitleButton(id superView, CGRect rc, int tag, NSString *title, UIFont *font, UIColor *color, UIColor *colorH, id target, SEL action);


/// 实例化UIView
UIView *InsertView(id superView, CGRect rect, UIColor *backColor);

@end

