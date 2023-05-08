//
//  PopTableListView.m
//  PopView
//
//  Created by 李林 on 2018/2/28.
//  Copyright © 2018年 李林. All rights reserved.
//

#import "PopTableListView.h"


@interface PopTableListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *titles;
@property (nonatomic ,copy) NSArray *imgNames;

@end
@implementation PopTableListView
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames
{
    CGRect frame = CGRectMake(0, 0, 120, titles.count * 44);
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.imgNames = imgNames;
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    if (self.imgNames.count>indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:self.imgNames[indexPath.row]];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate conformsToProtocol:@protocol(PopTableCellDelegate)] && [self.delegate respondsToSelector:@selector(cellOnclick:tag:)]) {
        [self.delegate cellOnclick:indexPath tag:self.viewTag];
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
