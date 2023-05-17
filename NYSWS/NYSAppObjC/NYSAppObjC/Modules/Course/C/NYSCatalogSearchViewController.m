//
//  NYSCatalogViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCatalogSearchViewController.h"
#import "NYSWordCell.h"
#import "NYSStatementCell.h"

@interface NYSCatalogSearchViewController ()
<
UITextFieldDelegate
>
{
    NSInteger _pageNo;
}
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation NYSCatalogSearchViewController
static NSString *NYSWordCellID = @"NYSWordCell";
static NSString *NYSStatementCellID = @"NYSStatementCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wr_setNavBarBackgroundAlpha:0];
    
    // 搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, 40)];
    ViewRadius(searchView, 40/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, 40/4, 40/2, 40/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, 40)];
    self.searchTF.delegate = self;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"搜索词";
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    self.navigationItem.titleView = searchView;
    
    
    _tableviewStyle = UITableViewStylePlain;
    [self.contentV addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.bounces = NO;
    ViewBorderRadius(self.tableView, 0, 1, UIColor.whiteColor)
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NYSWordCellID bundle:nil] forCellReuseIdentifier:NYSWordCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NYSStatementCellID bundle:nil] forCellReuseIdentifier:NYSStatementCellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentV.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentV.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.contentV.mas_left).offset(10);
        make.right.mas_equalTo(self.contentV.mas_right).offset(-10);
    }];
    
    ViewRadius(_contentV, 20);
    self.contentV.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.dataSourceArr removeAllObjects];
    [self getDetailData:@"1"];
    
    return YES;
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    
    [self getDetailData:@"1"];
}

- (void)getDetailData:(NSString *)page {
    self.currentPage = page.integerValue;
    
    NSDictionary *argument = @{
        @"page": page,
        @"chapter_id": @([self.chapterArray[self.index] ID]),
        @"keyword": self.searchTF.text,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Course/select_content"
                                       argument:argument
                                         remark:@"关键词搜索"
                                        success:^(id response) {
        @strongify(self)
        NSArray *wordArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"word_list"]];
        NSArray *statementArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"statement_list"]];
        
        [self.dataSourceArr removeAllObjects];
        if ((wordArray.count + statementArray.count) > 0) {
            [self.dataSourceArr addObject:wordArray];
            [self.dataSourceArr addObject:statementArray];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NetErr") reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        CGFloat labelH0 = [model.content heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        CGFloat labelH1 = [model.translate heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        
        return 20 + labelH0 + labelH1;
    } else {
        
        CGFloat labelH0 = [model.content heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        CGFloat labelH1 = [model.translate heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        
        return 20 + labelH0 + labelH1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        NYSWordCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NYSWordCellID];
        cell.model = model;
        return cell;
        
    } else {
        NYSStatementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NYSStatementCellID];
        cell.model = model;
        return cell;
    }
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
    
    
    NSURL *url = [NSURL URLWithString:model.url];
    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    [player play];
}

@end
