//
//  CategorySideTableView.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "CategorySideTableView.h"
#import "CategorySideCell.h"

@implementation CategorySideTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.estimatedRowHeight = 78;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[CategorySideCell class] forCellReuseIdentifier:@"CategorySideCell"];
    }
    return self;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategorySideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategorySideCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSMutableArray<CategoryModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
