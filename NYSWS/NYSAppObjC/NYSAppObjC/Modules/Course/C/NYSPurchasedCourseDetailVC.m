//
//  NYSPurchasedCourseDetailVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSPurchasedCourseDetailVC.h"
#import "NYSPurchasedDetailHeader.h"
#import "NYSLessonPlayCell.h"
#import "NYSCoursePurchaseVC.h"
#import "NYSCourseExchangeVC.h"
#import "NYSCatalogViewController.h"

@interface NYSPurchasedCourseDetailVC ()
{
    NSInteger _pageNo;
}
@property (strong, nonatomic) NYSHomeCourseModel *detailModel;
@property (strong, nonatomic) NYSPurchasedDetailHeader *headerView;
@end

@implementation NYSPurchasedCourseDetailVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"Detail");
    
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = NAppThemeColor;
    
    [self setupUI];
    [self getDetailData];
}

- (void)setupUI {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NYSTools addRoundedCorners:self.tableView corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    // 表头
    self.headerView = [[NYSPurchasedDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.tableView.tableHeaderView = self.headerView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {

    return NScreenHeight*0.2;
}

#pragma mark - 加载详情数据
- (void)getDetailData {
    NSMutableDictionary *params = @{
        @"course_id": @(self.model.ID),
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Course/info"
                                      argument:params
                                             remark:@"课程详情"
                                            success:^(id response) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailModel = [NYSHomeCourseModel modelWithDictionary:response];
            self.headerView.model = self.detailModel;
            
            // 计算富文本的高度
            NSDictionary *optoins = @{
                NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                NSFontAttributeName:[UIFont systemFontOfSize:20]
            };
            NSString *contentStr = self.detailModel.details;
            NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
            NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
            NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
            CGSize attSize = [attributeString boundingRectWithSize:CGSizeMake(NScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            self.tableView.tableHeaderView.height = 200 + attSize.height;
            
            self.dataSourceArr = self.detailModel.chapter.mutableCopy;
            [self.tableView reloadData];
        });
    } failed:^(NSError * _Nullable error) {


    }];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
    };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@""
                                       argument:argument
                                         remark:@"课程章节列表"
                                        success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSMovementModel class] json:response];
        if (array.count > 0) {
            [weakSelf.dataSourceArr addObjectsFromArray:array];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
            }
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NetErr") reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _pageNo = 1;
    [self footerRereshing];
    
    return YES;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSChapter *model = self.dataSourceArr[indexPath.row];
    CGFloat h = [model.subtitle heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 170];
    return 50 + h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSLessonPlayCell";
    NYSLessonPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NYSCatalogViewController *vc = NYSCatalogViewController.new;
    vc.index = indexPath.row;
    vc.chapterArray = self.dataSourceArr;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
