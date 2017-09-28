//
//  MyTableViewController.m
//  下拉刷新
//
//  Created by 尹键溶 on 2017/7/8.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "MyTableViewController.h"
#import "PullDownToRefreshView.h"
@interface MyTableViewController ()
@property(nonatomic,strong)NSArray *cities;
@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据
    self.cities = [self LoadData];
    PullDownToRefreshView *PullDowNormalView = [[PullDownToRefreshView alloc]initWithFrame:CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60)];
    PullDowNormalView.backgroundColor = [UIColor brownColor];
    //添加入subview
    [self.tableView addSubview:PullDowNormalView];
    //对于block进行编写
    PullDowNormalView.RefreshBlock = ^(){
        //一定时间后 将以下操作加入队列
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //找到一组新数据
            NSArray *newData = [self LoadData];
            //把新数据加入cities这个数组
            //先用一个临时数组
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_cities];
            //再把newdata加入
            [temp addObjectsFromArray:newData];
            //接下来把temp赋给cities
            self.cities = temp;
            //然后控制器重新读取数据
            [self.tableView reloadData];
            //结束刷新
            [PullDowNormalView endAnimation];
        });
    };
    
}
//加载数据
- (NSArray *)LoadData{
    //找到合适的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
    //加载这个路径的东西并放到以cities为名的array里面
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    //现在要开始展现cities里面的东西了
    return array;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//行只有一行

//列的话就是cities里面的数量了
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

//这个方法是具体调用里面cell的表现

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myoc" forIndexPath:indexPath];
    //然后显示cell里的内容
    cell.textLabel.text = self.cities[indexPath.row];
    // Configure the cell...
    
    return cell;
}

@end
