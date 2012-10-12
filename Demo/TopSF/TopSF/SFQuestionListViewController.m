//
//  SFQuestionListViewController.m
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListViewController.h"

#import "SFHttpRequest.h"
#import "SFWebViewController.h"

@interface SFQuestionListViewController ()

// 私有方法，请求数据成功的回调
- (void)getTopListSuccess:(NSDictionary *)response;

// 私有属性
// UITableView
@property (nonatomic, strong) UITableView       *listView;
// 存放数据的数组，10个热门问题
@property (nonatomic, strong) NSArray           *dataList;
// 载入中的状态标志
@property (nonatomic, assign) BOOL              loading;

@end

@implementation SFQuestionListViewController

@synthesize listView        = _listView;
@synthesize dataList        = _dataList;

- (void)getTopListSuccess:(NSDictionary *)response
{
    self.dataList = [[response objectForKey:@"data"] objectForKey:@"items"];
    // 回调后，刷新UITableView
    [self.listView reloadData];
    self.loading = NO;
}

#pragma mark - UITableViewDelegate

// UITableViewDelegate方法，响应用户点击某行的操作，通过indexPath传递点击位置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SFWebViewController *webViewController = [[SFWebViewController alloc] init];
    webViewController.url = [[self.dataList objectAtIndex:indexPath.row] objectForKey:@"url"];
    [self presentViewController:webViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

// UITableViewDataSource方法，返回UITableView的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

// UITableViewDataSource方法，返回各行的View（称为Cell），用于拼装视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableView会复用每一行的Cell，使用indentifier标示后放入池
    static NSString *CellIdentifier = @"SF_QUESTION_LIST_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // 每次使用前，清空数据
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.imageView.image = nil;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"";
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    // 写入新数据
    cell.textLabel.text = [[self.dataList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Life Circle

// 该方法在整个视图完成载入后，系统自动调用
// 一般初始化子视图，第一次载入数据，都在此进行
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化UITableView
    self.listView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    
    // 把TableView的视图加入到控制器视图中
    [self.view addSubview:self.listView];
    
    [self refresh];
}

- (void)refresh
{
    if (! self.loading) { // 防止重复刷新
        self.loading = YES;
        [SFHttpRequest invoke:@"http://joyqi.segmentfault.net/segmentfault/node/api/index.php/question/newest"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"dc8cfe97c4b40f8619b2193e2c5d5233", @"sign",
                               @"1110000000024951", @"app",
                               nil]
                     userInfo:nil
                     delegate:self
                    onSuccess:@selector(getTopListSuccess:)
                    onFailure:nil
                   onComplete:nil];
    }
}

@end
