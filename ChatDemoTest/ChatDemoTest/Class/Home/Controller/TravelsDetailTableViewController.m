//
//  TravelsDetailTableViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/22.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "TravelsDetailTableViewController.h"
#import "HZPhotoBrowserView.h"
#import "MySimplePhotoBrowser.h"
#import "HZPhotoBrowser.h"

@interface TravelsDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell3;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;
- (IBAction)attentionBtnClidk:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *attentionIMg;

@end

@implementation TravelsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self cellHeight];
}


-(void)cellHeight{

    CGSize computeSize=CGSizeMake(ScreenW-30, MAXFLOAT);
    CGSize size=[self.model.text boundingRectWithSize:computeSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    self.contentLabelHeight.constant=size.height+15;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentfier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    
    if (indexPath.row==0) {
        [self.userImg sd_setImageWithURL:[NSURL URLWithString:self.model.userHeadImg] placeholderImage:PlaceholderImage];
        self.userName.text=self.model.userName;
        self.likeCount.text=self.model.likeCount;
        self.viewCount.text=self.model.viewCount;
        self.time.text=self.model.startTime;
        return self.cell1;
    }else if(indexPath.row==1){
        self.contentLabel.text=self.model.text;
        self.titleLabel.text=self.model.title;
        return self.cell2;
    }else{
//        [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.model.headImage] placeholderImage:PlaceholderImage];
//        self.headImg.contentMode=UIViewContentModeScaleAspectFit;
        MySimplePhotoBrowser *pothView = [[MySimplePhotoBrowser alloc]init];
        pothView.photoItemArray=@[self.model.headImage];
        [self.cell3 addSubview:pothView];
        return self.cell3;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height;
    if (indexPath.row==0) {
        
        height=100;
    }else if(indexPath.row==1){
        height=self.contentLabelHeight.constant+45;
    }else{
        height=200;
    }
    return height;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)attentionBtnClidk:(UIButton *)sender {
    
    self.attentionIMg.image=[UIImage imageNamed:@"model_btn_like_red"];
    self.likeCount.text=[NSString stringWithFormat:@"%d",[self.model.likeCount intValue]+1];
    sender.enabled=NO;
    
}
@end
