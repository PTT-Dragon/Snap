//
//  TextCountView.h
//  SFShop
//
//  Created by Lufer on 2022/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextCountView : UIView

- (void)configDataWithTotalCount:(NSInteger)totalCount
                    currentCount:(NSInteger)currentCount;

@end

NS_ASSUME_NONNULL_END
