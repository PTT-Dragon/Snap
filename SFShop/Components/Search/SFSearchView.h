//
//  SFSearchView.h
//  SFShop
//
//  Created by MasterFly on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import "SFSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchView : UIView

@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFSearchModel *> *> *dataArray;
@property (nonatomic, readwrite, copy) void(^searchBlock)(NSString *qs);
@property (nonatomic, readwrite, copy) void(^cleanHistoryBlock)(void);

- (void)reload;

@end

NS_ASSUME_NONNULL_END
