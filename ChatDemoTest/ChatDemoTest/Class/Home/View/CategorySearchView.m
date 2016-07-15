//
//  CategorySearchView.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/17.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "CategorySearchView.h"

#define defaultWH 50

@implementation CategorySearchView

+(instancetype)setupCategorySearchView:(CGRect)frame{

    return [[self alloc]initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        [self setupView:(CGRect)frame];
    }
    return self;
}

-(void)setupView:(CGRect)frame{

    [self addButtonToView:4];
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
}

-(void)addButtonToView:(int)count{

    CGFloat LH=20; //label高度
    
    CGFloat W=defaultWH;
    CGFloat H=defaultWH;
    CGFloat PaddingW=(ScreenW-count*W)/(count+1);
    CGFloat Y=(self.frame.size.height-H-LH)/2;
    
    NSArray *btns=@[@{@"icon":@"home_searchBtn",@"title":@"景点搜索"},@{@"icon":@"home_trainBtn",@"title":@"车票查询"},@{@"icon":@"home_weatherBtn",@"title":@"天气"},@{@"icon":@"home_moreBtn",@"title":@"更多"}];
    for (int i=0; i<count; i++) {
        NSDictionary *dic=btns[i];
        UIButton *btn=[[UIButton alloc]init];
        CGFloat X=PaddingW+(W+PaddingW)*i;
        btn.frame=CGRectMake(X, Y, W, H);
        btn.tag=i;
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=W*0.5;
        [btn addTarget:self action:@selector(viewBttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor blueColor];
        [self addSubview:btn];
        
        UILabel *textlabel=[[UILabel alloc]init];
        textlabel.frame=CGRectMake(X, Y+W+3, W, LH);
        textlabel.text=dic[@"title"];
        textlabel.font=[UIFont systemFontOfSize:12];
        textlabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:textlabel];
        
    }
    
}

-(void)viewBttonClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(CategorySearchViewItemDidClick:)]) {
        [self.delegate CategorySearchViewItemDidClick:sender.tag];
    }
}


@end
