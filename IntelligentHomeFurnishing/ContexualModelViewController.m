//
//  ContexualModelViewController.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/8.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ContexualModelViewController.h"
#import "ContextualModelEditViewController.h"

@interface ContexualModelViewController ()

@end

@implementation ContexualModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //适配
    [self adaptationHeaderView:_headerView withSepaLabel:nil withNavTitleLabel:_navTitleLabel];
    
    /* 创建UICollectionView */
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.f, DEVICE_AVALIABLE_WIDTH, DEVICE_AVALIABLE_HEIGHT-64.f-52.f) collectionViewLayout:flowLayout];
    
    [_collectionView registerClass:[ContextualModelCollectionViewCell class] forCellWithReuseIdentifier:@"ContextualModelCollectionViewCell"]; //注册Cell类
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_addBtn setFrame:CGRectMake(DEVICE_AVALIABLE_WIDTH-10-_addBtn.bounds.size.width, _addBtn.frame.origin.y, _addBtn.bounds.size.width, _addBtn.bounds.size.height)];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    num = 0;
    
    UILabel *label = (UILabel *)[_tabBarView viewWithTag:202];
    [label setTextColor:[UIColor orangeColor]];
    
    UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:302];
    [imageView setImage:[UIImage imageNamed:@"报警选中"]];
    
    //加载情景模式列表
    [self loadIntelligentContextualModelList];
}

//210:332iphone4、iphone5、iphone5s @1x 93 * 147 @2x  186 * 295
//
//                         iphone6 @1x 111 * 176 @2x  223 * 353
//
//                    iphone6 plus @1x 124 *  197  @3x 373 * 590

-(void)loadIntelligentContextualModelList{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[APPDELEGATE user].userHomeID forKey:@"homeId"];
    
    [[RequestService defaultRequestService] asyncGetDataWithURL:GetContextualModelList paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
        
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        
        if([[responseDic objectForKey:@"status"] intValue] == 1){
            
            if([responseDic objectForKey:@"data"] && ![[responseDic objectForKey:@"data"] isEqual:@""] && ![[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]]){
                
                NSMutableArray *tempArray = [responseDic objectForKey:@"data"];
                
                for (int i=0; i<[tempArray count]; i++) {
                    
                    NSMutableDictionary *tempDic = [tempArray objectAtIndex:i];
                    
                    ContextualModel *model = [[ContextualModel alloc] init];
                    //默认关闭
                    model.contextualIsClosed = YES; 
                    [model setContextualModelWithDataDic:tempDic];
                    [currentTempArray addObject:model];
                    
                }
                
                _aryData = currentTempArray;
                
//                [_aryData addObjectsFromArray:_aryData];
                
                [_collectionView reloadData];
                
            }
            
        }
        
        [self removeLoadingMessage];
        
    } errorBlock:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self removeLoadingMessage];
    }];
    
    
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

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_aryData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ContextualModelCollectionViewCell";
    
    ContextualModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    [cell loadContextualModelCollectionViewCell:[_aryData objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //选中某个场景 表示开启场景 关闭表示关闭场景
    ContextualModel *model = [_aryData objectAtIndex:indexPath.row];
    
    model.contextualIsClosed = !model.contextualIsClosed;
    
    if(model.contextualIsClosed){
        
        //当前是关闭
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:model.contextualModelID forKey:@"modelId"];
        [paramDic setObject:@"0" forKey:@"flag"];
        [[RequestService defaultRequestService] asyncPostDataWithURL:DoContextualModel paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                //关成功了
                model.contextualIsClosed = @"1";
                
//                for (int i=0; i<[_aryData count]; i++) {
//                    
//                    ContextualModel *currentModel = [_aryData objectAtIndex:i];
//                    
//                    if(!model.contextualIsClosed){
//                        
//                        // 当前打开 把其他所有的都不为开
//                        if(![currentModel isEqual:model]){
//                            
//                            currentModel.contextualIsClosed = YES;
//                        }
//                        
//                    }
//                    
//                }
                
                [_collectionView reloadData];
                
            }else{
                [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
                
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];

        
        
    }else{
        
        //当前开启
        //得到对应的对象 开
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:model.contextualModelID forKey:@"modelId"];
        [paramDic setObject:@"1" forKey:@"flag"];
        [[RequestService defaultRequestService] asyncPostDataWithURL:DoContextualModel paramDic:paramDic responseDicBlock:^(NSMutableDictionary *responseDic) {
            
            if([[responseDic objectForKey:@"status"] intValue] == 1){
                
                model.contextualIsClosed = @"0"; //开着的
               
//                for (int i=0; i<[_aryData count]; i++) {
//                    
//                    ContextualModel *currentModel = [_aryData objectAtIndex:i];
//                    
//                    if(!model.contextualIsClosed){
//                        
//                        // 当前打开 把其他所有的都不为开
//                        if(![currentModel isEqual:model]){
//                            
//                            currentModel.contextualIsClosed = YES;
//                        }
//                        
//                    }
//                    
//                }
                
                [_collectionView reloadData];
                
            }else{
                [self showSuccessOrFailedMessage:[responseDic objectForKey:@"error"]];
            }
            
        } errorBlock:^(NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
        
    }
    
    
    
}

//返回CollectionView每个Cell的Size大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DEVICE_AVALIABLE_WIDTH-40)/3, (((DEVICE_AVALIABLE_WIDTH-40)/3)*332)/210);
    
}

//定义每个CollectionView的margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //返回上左下右的内边距
    return UIEdgeInsetsMake(10, 10, 0, 10);
    
}

#pragma mark ContextualModelCollectionViewCellDelegate
-(void)contextualModelCollectionViewCellOnClickShow:(ContextualModel *)model{
    
    num++;
    
    if(num == 1){
        
        //得到对应详情界面
        ContextualModelEditViewController *viewController = [[ContextualModelEditViewController alloc] init];
        
        viewController.contextualModel = model;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
    
}

-(void)contextualModelOnClickShowDetail:(ContextualModel *)model{
    
    ContextualModelDetailViewController *viewController = [[ContextualModelDetailViewController alloc] init];
    
    viewController.currentModelID = model.contextualModelID;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (IBAction)onClickAddContextualModel:(id)sender {
    
    ContextualModelEditViewController *viewController = [[ContextualModelEditViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)onClickShow:(id)sender {
    
    IntelligentIntegratedDevicesViewController *viewController = [APPDELEGATE integratedDeviceViewController];
    
    if(!viewController){
        viewController = [[IntelligentIntegratedDevicesViewController alloc] init];
        [APPDELEGATE setIntegratedDeviceViewController:viewController];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [APPDELEGATE window].rootViewController = navController;
    
}
@end
