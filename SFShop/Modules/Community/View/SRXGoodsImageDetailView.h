//
//  SRXGoodsImageDetailView.h
//  ShiRongXinMarketMallProject
//
//  Created by 薛静鹏 on 2020/3/17.
//  Copyright © 2020 Alucardulad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSVideoPlayback.h"
NS_ASSUME_NONNULL_BEGIN

@interface SRXGoodsImageDetailView : UIView
/** 轮播数组 */
@property (nonatomic, strong) NSMutableArray *shufflingArray;
/** 是否有视频 */
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,strong) TSVideoPlayback *video;

-(void)updateView;
@end

NS_ASSUME_NONNULL_END
