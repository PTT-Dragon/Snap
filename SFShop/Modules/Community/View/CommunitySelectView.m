//
//  CommunitySelectView.m
//  SFShop
//
//  Created by Lufer on 2022/1/23.
//

#import "CommunitySelectView.h"
#import "CommunitySelectTableViewCell.h"

@interface CommunitySelectView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation CommunitySelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
    [self initLayout];
}


#pragma mark - init

- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.tableView];
    [self addSubview:self.maskView];
}

- (void)initLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(300);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleModel.recCatgs.count+self.titleModel.collectCatgs.count;
    }
    return self.titleModel.unCollectCatgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunitySelectTableViewCell *cell = [CommunitySelectTableViewCell selectCellWithTableView:tableView cellId:@"CommunitySelectTableViewCell"];
    if (indexPath.section == 0) {
        ArticleTitleItemModel *itemModel;
        if (indexPath.row >= self.titleModel.recCatgs.count) {
            itemModel = self.titleModel.collectCatgs[indexPath.row-self.titleModel.recCatgs.count];
        }else{
            itemModel = self.titleModel.recCatgs[indexPath.row];
        }
        [cell configDataWithTitle:itemModel.articleCatgName isFavoriteType:YES isRecommend:indexPath.row < self.titleModel.recCatgs.count];
    }else{
        ArticleTitleItemModel *itemModel = self.titleModel.unCollectCatgs[indexPath.row];
        [cell configDataWithTitle:itemModel.articleCatgName isFavoriteType:NO isRecommend:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 取消喜欢
//        xxxmodel
        if (indexPath.row < self.titleModel.recCatgs.count) {
            return;
        }
        ArticleTitleItemModel *itemModel = self.titleModel.collectCatgs[indexPath.row-self.titleModel.recCatgs.count];
        NSMutableArray *unArr = [NSMutableArray arrayWithArray:self.titleModel.unCollectCatgs];
        [unArr addObject:itemModel];
        self.titleModel.unCollectCatgs = unArr;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titleModel.collectCatgs];
        [arr removeObjectAtIndex:indexPath.row-self.titleModel.recCatgs.count];
        self.titleModel.collectCatgs = arr;
        if (self.block) {
            self.block(self.titleModel);
        }
    } else {
        ArticleTitleItemModel *itemModel = self.titleModel.unCollectCatgs[indexPath.row];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titleModel.collectCatgs];
        [arr addObject:itemModel];
        NSMutableArray *unArr = [NSMutableArray arrayWithArray:self.titleModel.unCollectCatgs];
        [unArr removeObject:itemModel];
        self.titleModel.unCollectCatgs = unArr;
        self.titleModel.collectCatgs = arr;
        if (self.block) {
            self.block(self.titleModel);
        }
    }
    [self.tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    headerView.backgroundColor = UIColor.whiteColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 30)];
    titleLabel.textColor = UIColor.blackColor;
    [headerView addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text = @"My Favorite";
    } else {
        titleLabel.text = @"Categories";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tapAction {
    self.hidden = YES;
}


#pragma mark - setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor jk_colorWithHexString:@"000000"] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
