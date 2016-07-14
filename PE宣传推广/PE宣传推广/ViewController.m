//
//  ViewController.m
//  PE宣传推广
//
//  Created by 陈自奎 on 16/4/13.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "ViewController.h"
#import "EPPromotioPopularizeTableViewController.h"


@interface ViewController ()
- (IBAction)pushToTable:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToTable:(UIButton *)sender {
    EPPromotioPopularizeTableViewController *vc=[[EPPromotioPopularizeTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
