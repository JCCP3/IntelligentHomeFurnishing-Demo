//
//  contextualModelCollectionViewCell.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/6/8.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ContextualModelCollectionViewCell.h"

@implementation ContextualModelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"ContextualModelCollectionViewCell" owner:self options:nil] lastObject];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShow:)];
        [recognizer setMinimumPressDuration:0.8];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

-(void)loadContextualModelCollectionViewCell:(ContextualModel *)contextualModel{
    
    _currentContextualModel = contextualModel;
    
    [self layoutContextualModelCollectionView]; //适配
    
    if([contextualModel.contextualModelType isEqual:@"1"] || [contextualModel.contextualModelType isEqual:@"2"] || [contextualModel.contextualModelType isEqual:@"3"]){
        
        if(DEVICE_IS_IPHONE6){
            [_imageView setImage:[UIImage imageNamed:@"水开关ip6"]];
        }else if (DEVICE_IS_IPHONE6PLUS){
            [_imageView setImage:[UIImage imageNamed:@"水开关ip6p"]];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"水开关"]];
        }
        
    }else if ([contextualModel.contextualModelType isEqual:@"4"] || [contextualModel.contextualModelType isEqual:@"5"] || [contextualModel.contextualModelType isEqual:@"6"]){
        
        if(DEVICE_IS_IPHONE6){
            [_imageView setImage:[UIImage imageNamed:@"电开关ip6"]];
        }else if (DEVICE_IS_IPHONE6PLUS){
            [_imageView setImage:[UIImage imageNamed:@"电开关ip6p"]];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"电开关"]];
        }
        
    }else if ([contextualModel.contextualModelType isEqual:@"7"] || [contextualModel.contextualModelType isEqual:@"8"] || [contextualModel.contextualModelType isEqual:@"9"]){
        
        if(DEVICE_IS_IPHONE6){
            [_imageView setImage:[UIImage imageNamed:@"其他ip6"]];
        }else if (DEVICE_IS_IPHONE6PLUS){
            [_imageView setImage:[UIImage imageNamed:@"其他ip6p"]];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"其他"]];
        }
        
    }else{
        if(DEVICE_IS_IPHONE6){
            [_imageView setImage:[UIImage imageNamed:@"水开关ip6"]];
        }else if (DEVICE_IS_IPHONE6PLUS){
            [_imageView setImage:[UIImage imageNamed:@"水开关ip6p"]];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"水开关"]];
        }
        
    }

    
    
    /* 判定情景模式状态是开还是关 */
    
    if(contextualModel.contextualIsClosed){
        //关闭
//        _bottomLabel.text = @"关闭";
        _bottomLabel.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }else{
//        _bottomLabel.text = @"打开";
        _bottomLabel.backgroundColor = [UIColor orangeColor];
        self.layer.borderWidth = 5;
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    
    
    _bottomLabel.text = [NSString stringWithFormat:@"%@",contextualModel.contextualModelName]; //情景模式名称
    
    
    
}

-(void)layoutContextualModelCollectionView{
    
    [_imageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30.f)];
    
    [_bottomLabel setFrame:CGRectMake(0, _imageView.bounds.size.height, self.bounds.size.width, self.bounds.size.height-(_imageView.bounds.size.height))];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    [_showBtn setFrame:CGRectMake(0, _imageView.bounds.size.height, self.bounds.size.width, (self.bounds.size.height-_imageView.bounds.size.height))];
    
    
    
}

-(void)onClickShow:(UILongPressGestureRecognizer *)press{
    
    if(press.state == UIGestureRecognizerStateBegan){
        return;
    }else{
        [_delegate contextualModelCollectionViewCellOnClickShow:_currentContextualModel];
    }

}

- (IBAction)onClickShowDetail:(id)sender {
    
    [_delegate contextualModelOnClickShowDetail:_currentContextualModel];
    
}
@end
