//
//  ViewController.m
//  ScrollTableDemo
//
//  Created by mc on 2018/10/30.
//  Copyright © 2018 LenSky. All rights reserved.
//

#import "ViewController.h"
#import "CircleRunView.h"

@implementation ViewController{
	CircleRunView * _circleView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor purpleColor];

	UILabel *textLable = [UILabel new];
	textLable.text = @"点击屏幕更改数据";
	textLable.textColor = [UIColor whiteColor];
	[self.view addSubview:textLable];

	textLable.textAlignment = NSTextAlignmentCenter;

	textLable.frame = (CGRect){
		0,
		100.0f,
		self.view.frame.size.width,
		30.0f
	};

	CircleRunView *circleView = [[CircleRunView alloc]initWithFrame:CGRectMake(0, 0, 250, 193)];
	_circleView = circleView;
	circleView.center = self.view.center;
	[self.view addSubview:circleView];


	UIImageView *runImgV = [UIImageView new];
	runImgV.image = [UIImage imageNamed:@"runBg"];
	[self.view addSubview:runImgV];
	runImgV.bounds = CGRectMake(0, 0, 300, 234.5f);
	runImgV.center = (CGPoint){circleView.center.x,circleView.center.y -15.0f};

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[_circleView addTitlesWithArray:@[
									  @"恭喜二牛 xxx 获得10元奖励",@"恭喜二牛 xxx 获得10元奖励",@"恭喜二牛 xxx 获得10元奖励",@"恭喜二牛 xxx 获得10元奖励",@"恭喜二牛 xxx 获得10元奖励"]];
}



@end
