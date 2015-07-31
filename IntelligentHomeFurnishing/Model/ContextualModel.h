//
//  ContextualModel.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/25.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContextualModel : NSObject

@property (nonatomic ,strong)NSString *contextualModelID;
@property (nonatomic ,strong)NSString *contextualModelImage; //对应情景模式的照片
@property (nonatomic ,strong)NSString *contextualModelType; //情景模式对应的类型 （一共九种类型）
@property (nonatomic ,strong)NSString *contextualModelDesc; //描述
@property (nonatomic ,strong)NSString *contextualModelHomeID;
@property (nonatomic ,strong)NSString *contextualModelName;
@property (nonatomic ,strong)NSString *contextualOpenCommand;
@property (nonatomic ,strong)NSString *contextualCloseCommand;
@property (nonatomic ,assign)BOOL contextualIsClosed; //情景模式是否打开

-(void)setContextualModelWithDataDic:(NSMutableDictionary *)dataDic;

@end
