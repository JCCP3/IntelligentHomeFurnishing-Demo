//
//  UserCenterInfoViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/24.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "UserCenterInfoViewController.h"

@interface UserCenterInfoViewController ()

@end

@implementation UserCenterInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableViewDelegate & UITabelViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-40,10, 40, 20)];

            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x+10, 0, btn.frame.origin.x-5-(cell.textLabel.frame.origin.x+10), 44.f)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.tag = 2000;
            textField.enabled = NO;
            textField.text = [APPDELEGATE user].userName;
            [cell addSubview:btn
             ];
            [cell addSubview:textField];
        }
        
        cell.textLabel.text = @"用户名";
        
//        cell.detailTextLabel.text = [APPDELEGATE user].userName;
//        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-40,10, 40, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClickShow:) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x+10, 0, btn.frame.origin.x-5-(cell.textLabel.frame.origin.x+10), 44.f)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.tag = 1000;
            textField.secureTextEntry = YES;
            textField.enabled = NO;
            textField.text = [APPDELEGATE user].userPwd;
            [cell addSubview:btn
             ];
            
            [cell addSubview:textField];
        }
        
        cell.textLabel.text = @"密码";
        
        return cell;

    }
    return nil;
}

-(void)onClickShow:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    UITextField *textField = (UITextField *)[cell viewWithTag:1000];
    
    if(btn.selected){
        
        // 显示明文
        textField.secureTextEntry = NO;
    }else{
        textField.secureTextEntry = YES;
        
    }
    
}


- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
