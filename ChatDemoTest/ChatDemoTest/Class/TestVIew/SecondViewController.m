//
//  SecondViewController.m
//  TabbedApplicationWithSwipe
//
//  Created by 管恺森 on 16/3/29.
//  Copyright © 2016年 管恺森. All rights reserved.
//

#import "SecondViewController.h"

#define time 0.3f

@interface SecondViewController (){
    UIImageView *_imageviewLeft;
    UIImageView *_imageviewRight;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor greenColor];
    //添加左右滑动手势pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    /********用于创建pan********/       //将左右的tab页面绘制出来，并把UIView添加到当前的self.view中
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    UIViewController* v1 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex-1];
    UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
    _imageviewLeft = [[UIImageView alloc] initWithImage:image1];
    _imageviewLeft.frame = CGRectMake(_imageviewLeft.frame.origin.x - [UIScreen mainScreen].bounds.size.width, _imageviewLeft.frame.origin.y , _imageviewLeft.frame.size.width, _imageviewLeft.frame.size.height);
    [self.view addSubview:_imageviewLeft];
    
    UIViewController* v2 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex+1];
    UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
    _imageviewRight = [[UIImageView alloc] initWithImage:image2];
    _imageviewRight.frame = CGRectMake(_imageviewRight.frame.origin.x + [UIScreen mainScreen].bounds.size.width, 0, _imageviewRight.frame.size.width, _imageviewRight.frame.size.height);
    [self.view addSubview:_imageviewRight];
    /********用于创建pan********/
}

- (void)viewDidDisappear:(BOOL)animated{
    /********用于移除pan时的左右两边的view********/
    [_imageviewLeft removeFromSuperview];
    [_imageviewRight removeFromSuperview];
    /********用于移除pan时的左右两边的view********/
}

#pragma mark 绘制图片
//与pan结合使用 截图方法，图片用来做动画
-(UIImage*)imageByCropping:(UIView*)imageToCrop toRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale*rect.size.width, scale*rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext,-1*rect.origin.x,-1*rect.origin.y-64);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}

#pragma mark Pan手势
- (void) handlePan:(UIPanGestureRecognizer*)recongizer{
    NSLog(@"UIPanGestureRecognizer");
    
    NSUInteger index = [self.tabBarController selectedIndex];
    
    CGPoint point = [recongizer translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    
    recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x < [UIScreen mainScreen].bounds.size.width && recongizer.view.center.x > 0 ) {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,recongizer.view.center.y);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2 ,recongizer.view.center.y);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index+1];
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,recongizer.view.center.y);
            }];
        } else {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width*1.5 ,recongizer.view.center.y);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index-1];
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,recongizer.view.center.y);
            }];
        }
    }
}





@end
