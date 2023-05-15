//
//  NYSCourseDetailVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCourseDetailVC.h"
#import "NYSCourseDetailHeader.h"
#import "NYSLessonPlayCell.h"
#import "NYSCoursePurchaseVC.h"
#import "NYSCourseExchangeVC.h"
#import "NYSCatalogViewController.h"

#define BottomBtnHeight 50

@interface NYSCourseDetailVC ()
{
    NSInteger _pageNo;
}
@property (strong, nonatomic) NYSHomeCourseModel *detailModel;
@property (strong, nonatomic) NYSCourseDetailHeader *headerView;
@end

@implementation NYSCourseDetailVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
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
    self.tableView.emptyDataSetSource = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NYSTools addRoundedCorners:self.tableView corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight - BottomBtnHeight));
    }];
    
    // 表头
    self.headerView = [[NYSCourseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    self.tableView.tableHeaderView = self.headerView;
    
    // 购买兑换
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - BottomBtnHeight, kScreenWidth/2, BottomBtnHeight)];
    leftBtn.tag = 11;
    [leftBtn addTarget:self action:@selector(bottomBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"兑换激活" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFB433"]];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight - BottomBtnHeight, kScreenWidth/2, BottomBtnHeight)];
    rightBtn.tag = 22;
    [rightBtn addTarget:self action:@selector(bottomBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor colorWithHexString:@"#FE6A48"]];
    [self.view addSubview:rightBtn];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
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
            self.tableView.tableHeaderView.height = 300 + attSize.height;
            
            self.dataSourceArr = self.detailModel.chapter.mutableCopy;
            [self.tableView reloadData];
        });
    } failed:^(NSError * _Nullable error) {


    }];
}

- (void)bottomBtnOnclicked:(UIButton *)sender {
    if (sender.tag == 11) {
        NYSCourseExchangeVC *vc = NYSCourseExchangeVC.new;
        vc.detailModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        NYSCoursePurchaseVC *vc = NYSCoursePurchaseVC.new;
        vc.detailModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return NScreenHeight * 0.4;
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
    return 60;
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
 
    NYSChapter *model = self.dataSourceArr[indexPath.row];
    
    NYSCatalogViewController *vc = NYSCatalogViewController.new;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
