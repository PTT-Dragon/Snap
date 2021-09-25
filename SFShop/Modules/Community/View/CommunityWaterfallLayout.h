//
//  CommunityWaterfallLayout.h
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommunityWaterfallLayoutProtocol;

@interface CommunityWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CommunityWaterfallLayoutProtocol> delegate;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;

@end

@protocol CommunityWaterfallLayoutProtocol <NSObject>

- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
