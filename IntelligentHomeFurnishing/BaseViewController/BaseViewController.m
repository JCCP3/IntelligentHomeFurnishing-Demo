//
//  BaseViewController.m
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseViewController.h"
#import "Utility.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)adaptationHeaderView:(UIView *)_headerView withSepaLabel:(UILabel *)_sepaLabel withNavTitleLabel:(UILabel *)_navTitleLabel{
    
    [_headerView setFrame:CGRectMake(0, 0, DEVICE_AVALIABLE_WIDTH, 64)];
    [_headerView setBackgroundColor:[Utility colorWithHexString:@"#f7f7f7"]];
    [_headerView setBackgroundColor:[UIColor clearColor]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"首页背景"]]];
    
    [_sepaLabel setFrame:CGRectMake(0, 63, DEVICE_AVALIABLE_WIDTH, 1)];
    [_sepaLabel setBackgroundColor:[Utility colorWithHexString:@"#dcdcdc"]];
    
    [_navTitleLabel setFrame:CGRectMake(_navTitleLabel.frame.origin.x, _navTitleLabel.frame.origin.y, DEVICE_AVALIABLE_WIDTH, _navTitleLabel.bounds.size.height)];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_navTitleLabel setTextColor:[Utility colorWithHexString:@"#333333"]];
}


-(void)showSuccessOrFailedMessage:(NSString *)message{
    
    //    _mbProgressHUD = [MBProgressHUD HUDForView:self.view];
    //
    //    [_mbProgressHUD setMode:MBProgressHUDModeText];
    //
    //    _mbProgressHUD.labelText = message;
    //
    //    [_mbProgressHUD hide:YES afterDelay:3];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    //    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [mbProgressHUD setMode:MBProgressHUDModeText];
    [mbProgressHUD setLabelText:message];
    [mbProgressHUD hide:YES afterDelay:2];
    
}

-(void)showLoadingMessage:(NSString *)message{
    
    UIView * vi = [[UIView alloc] initWithFrame:CGRectMake((DEVICE_AVALIABLE_WIDTH-200)/2,(DEVICE_AVALIABLE_HEIGHT-200)/2, 200, 200)];
    vi.tag= 10086;
    [self.view addSubview:vi ];
    vi.backgroundColor = [UIColor clearColor];
    
    _mbProgressHUD = [MBProgressHUD showHUDAddedTo:vi animated:YES];
    
    [_mbProgressHUD setMode:MBProgressHUDModeIndeterminate];
    
    _mbProgressHUD.labelText = message;
    
}

-(void)removeLoadingMessage{
    
    UIView *view=(UIView *)[self.view viewWithTag:10086];
    [view removeFromSuperview];
    [_mbProgressHUD hide:YES];
    
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
