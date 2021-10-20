//
//  InitializationUIMethod.m
//  SWDatePickerDemo
//
//  Created by hn on 2020/9/11.
//  Copyright © 2020 SW. All rights reserved.
//

#import "InitializationUIMethod.h"

@implementation InitializationUIMethod

#pragma mark - UILabel

UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor)
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:cRect];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textAlignment = align;
    tempLabel.textColor = textColor;
    tempLabel.font = textFont;
    tempLabel.text = contentStr;
    [tempLabel setNumberOfLines:1];
    
    if (superView)
    {
        [superView addSubview:tempLabel];
    }
    
    return tempLabel;
}


#pragma mark - UIButton

UIButton *InsertTitleButton(id superView, CGRect rc, int tag, NSString *title, UIFont *font, UIColor *color, UIColor *colorH, id target, SEL action)
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rc;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tag];
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (nil != colorH)
    {
        [btn setTitleColor:colorH forState:UIControlStateHighlighted];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    if (superView)
    {
        [superView addSubview:btn];
    }
    
    return btn;
}


#pragma mark - UIView

UIView *InsertView(id superView, CGRect rect, UIColor *backColor)
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if (backColor) {
        
        view.backgroundColor = backColor;
    }
    
    if (superView)
    {
        [superView addSubview:view];
    }
    
    return view;
}

@end
