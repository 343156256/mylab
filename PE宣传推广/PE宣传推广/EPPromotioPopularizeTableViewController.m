//
//  EPPromotioPpopularizeTableViewController.m
//  PE宣传推广
//
//  Created by 陈自奎 on 16/4/13.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "EPPromotioPopularizeTableViewController.h"
#import "EPPromotionPopularizeTableViewCellOne.h"
#import "EPPromotionPopularizeTableViewCellTwo.h"

@interface EPPromotioPopularizeTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EPPromotioPopularizeTableViewController

#pragma mark - 懒加载


#pragma mark - 共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewDelegete];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - 私有方法
-(void)loadViewDelegete{

    //添加cell代理
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //去除多余cell
    self.tableView.tableFooterView=[[UIView alloc]init];
}

//第一种cell类型
-(EPPromotionPopularizeTableViewCellOne *)loadCellOne:(UITableView *)tableview{
    EPPromotionPopularizeTableViewCellOne *cellOne=[tableview dequeueReusableCellWithIdentifier:@"cellone"];
    if (cellOne==nil) {
        cellOne=[EPPromotionPopularizeTableViewCellOne setupEPPromotionPopularizeTableViewCellOne];
    }
    return cellOne;
}

//第二种cell类型
-(EPPromotionPopularizeTableViewCellTwo *)loadCellTwo:(UITableView *)tableview{
    EPPromotionPopularizeTableViewCellTwo *cellTwo=[tableview dequeueReusableCellWithIdentifier:@"cellone"];
    if (cellTwo==nil) {
        cellTwo=[EPPromotionPopularizeTableViewCellTwo setupEPPromotionPopularizeTableViewCellTwo];
    }
    return cellTwo;
}

#pragma mark - 代理方法
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"0");
            EPPromotionPopularizeTableViewCellOne *cellOne=[self loadCellOne:tableView];
            return cellOne;
        }
            break;
        case 1:
        {
            NSLog(@"1");
            EPPromotionPopularizeTableViewCellTwo *cellTwo=[self loadCellTwo:tableView];
            return cellTwo;
        }
            break;
            
        default:
            break;
    }
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
