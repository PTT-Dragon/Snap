//
//  TSVideoPlayback.m


#import "TSVideoPlayback.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "JPVideoPlayerKit.h"
#import "ArticleDetailModel.h"

//#import "SVProgressHUD.h"

@interface TSVideoPlayback ()<UIScrollViewDelegate,JPVideoPlayerDelegate>
{
    BOOL isReadToPlay;
    BOOL isEndPlay;
    BOOL isCliakVIew;
    NSInteger imgIndex;
}
//@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
//@property (strong, nonatomic)AVPlayerItem *item;//播放单元
//@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面

@property (nonatomic,strong) UILabel *indexLab;//当前播放页数
//@property (nonatomic,strong) UIButton *playBtn;//播放按钮
@property (nonatomic,strong) UIButton *videoBtn;//切换到视频
@property (nonatomic,strong) UIButton *imgBtn;//切换到图片
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIImageView *placeholderImg;//占位图img
@end

@implementation TSVideoPlayback

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialControlUnit];
    }
    return self;
}

-(void)setWithIsVideo:(TSDETAILTYPE)type andDataArray:(NSArray *)array
{
    self.dataArray = array;
    
    self.scrolView.contentSize = CGSizeMake(self.dataArray.count*self.frame.size.width, self.frame.size.height);
    self.type = type;
    if (type == TSDETAILTYPEVIDEO) {
        //        [self.playBtn setHidden:NO];
        [self.videoBtn setHidden:NO];
        [self.imgBtn setHidden:NO];
    }else{
        //        [self.playBtn setHidden:YES];
        [self.videoBtn setHidden:YES];
        [self.imgBtn setHidden:YES];
    }
    
    self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count];
    self.indexLab.hidden = NO;
    self.videoBtn.hidden = YES;
    self.imgBtn.hidden = YES;
    
    @weakify(self);
    [self.dataArray enumerateObjectsUsingBlock:^(ArticleImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([obj.type isEqual:@"C"]) {//视频
            NSURL *url = [NSURL URLWithString:SFImage(obj.url)];
            UIView * videoView = [[UIView alloc]initWithFrame:CGRectMake(idx*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [self.scrolView addSubview:videoView];
            videoView.jp_videoPlayerDelegate = self;
            [videoView jp_resumePlayWithURL:url
            bufferingIndicator:nil
                   controlView:nil
                  progressView:nil
             configuration:nil];
            
        }else {
            UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(idx*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            img.userInteractionEnabled = YES;
            [img sd_setImageWithURL:[NSURL URLWithString:SFImage(obj.url)] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
            [self.scrolView addSubview:img];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
            [img addGestureRecognizer:tap];
        }
    }];
}
- (void)changeBtnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        self.videoBtn.selected = YES;
        self.imgBtn.selected = NO;
        self.videoBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.47];
        self.imgBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.16];
        
        if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
            
            [self.scrolView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self scrollViewDidEndDecelerating:self.scrolView];
        }
    }
    else{
        if (self.dataArray.count < 2) {
            return;
        }
        self.videoBtn.selected = NO;
        self.imgBtn.selected = YES;
        
        self.videoBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.16];
        self.imgBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.47];
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
                [self.scrolView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                [self scrollViewDidEndDecelerating:self.scrolView];
            }
        }
    }
    return;
}
-(void)imgTapClick
{
    if ([self.delegate respondsToSelector:@selector(videoView:didSelectItemAtIndexPath:)]) {
        if (self.type == TSDETAILTYPEVIDEO) {
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex];
        }else{
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex+1];
        }
    }
}
#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    imgIndex = index;
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            self.indexLab.hidden = YES;
            //            [self.playBtn setHidden:NO];
            
        }
        else{
            self.indexLab.hidden = NO;
            //            [self.playBtn setHidden:YES];
            [self.scrolView jp_pause];
//            [_playerView.player seekToTime:CMTimeMake(0, 1)];
            
        }
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index,(int)self.dataArray.count - 1];
    }else{
        [self.scrolView jp_pause];
//        [_playerView.player seekToTime:CMTimeMake(0, 1)];
        self.indexLab.hidden = NO;
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)self.dataArray.count];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < self.frame.size.width/2) {
            self.videoBtn.selected = YES;
            self.imgBtn.selected = NO;
            self.videoBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.47];
            self.imgBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.16];
            //            self.playBtn.hidden = NO;
            
        } else{
            self.videoBtn.selected = NO;
            self.imgBtn.selected = YES;
            self.videoBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.16];
            self.imgBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.47];
            
        }
    }else{
        return;
    }
}
-(void)initialControlUnit
{
    isEndPlay = NO;
    _scrolView = [[UIScrollView alloc]init];
    _scrolView.pagingEnabled  = YES;
    _scrolView.delegate = self;
    _scrolView.showsVerticalScrollIndicator = NO;
    _scrolView.showsHorizontalScrollIndicator = NO;
    _scrolView.userInteractionEnabled = YES;
    [self addSubview:_scrolView];
    self.scrolView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    self.placeholderImg = [[UIImageView alloc]init];
    self.placeholderImg.image = [UIImage imageNamed:@"zhanweitu"];
    self.placeholderImg.contentMode = UIViewContentModeScaleAspectFill;
    self.placeholderImg.userInteractionEnabled = YES;
    self.placeholderImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.scrolView addSubview:self.placeholderImg];
    
    
    _indexLab = [[UILabel alloc]init];
    _indexLab.textColor = [UIColor whiteColor];
    _indexLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _indexLab.font = [UIFont systemFontOfSize:11];
    _indexLab.textAlignment = 1;
    _indexLab.layer.cornerRadius = 24/2;
    _indexLab.layer.masksToBounds = YES;
    [self.indexLab setHidden:YES];
//    [self addSubview:self.indexLab];
    self.indexLab.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 50, 50, 24);
    
    _videoBtn = [[UIButton alloc]init];
    [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_videoBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.16]];
    _videoBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _videoBtn.layer.cornerRadius = 28/2;
    _videoBtn.layer.masksToBounds = YES;
    self.videoBtn.tag = 1;
    [self addSubview:_videoBtn];
    self.videoBtn.frame = CGRectMake(App_Frame_Width - 125, self.frame.size.height - 60, 50, 28);
    
    _imgBtn = [[UIButton alloc]init];
    [_imgBtn setTitle:@"图片" forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _imgBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    _imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _imgBtn.layer.cornerRadius = 28/2;
    _imgBtn.layer.masksToBounds = YES;
    self.imgBtn.tag = 2;
    [self addSubview:_imgBtn];
    self.imgBtn.frame = CGRectMake(App_Frame_Width-65, self.frame.size.height - 60, 50, 28);
    
    
    [self.videoBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clearCache {
    [self.scrolView jp_stopPlay];
}
@end
