	//
	//  CircleRunView.m
	//  ScrollTableDemo
	//
	//  Created by ios2 on 2018/10/30.
	//  Copyright © 2018 LenSky. All rights reserved.
	//

#import "CircleRunView.h"
#import "SafeObjct.h"

@interface CircleRunView ()
<UITableViewDelegate,
UITableViewDataSource>
{
		//动态表 2
	UITableView * _table1;
		//动态表 2
	UITableView * _table2;
		//单个cell 的高度
	CGFloat _cellHeight;
	CADisplayLink *_timer;
		//运动的速度
	CGFloat _speed;
}

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,strong)NSMutableArray *cellArray;

@property (nonatomic,strong)SafeObjct *safeObj;
@end


@implementation CircleRunView

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {

		_cellHeight = 30.0f;

		_speed  = 0.35;

		UIView *containtView = [[UIView alloc]init];
		containtView.clipsToBounds = YES;
		containtView.frame = self.bounds;
		[self addSubview:containtView];

			//设置表
		UITableView *tableView1 = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
		tableView1.separatorColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
		tableView1.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
		tableView1.scrollEnabled = NO;
		tableView1.tag = 100;
		CGFloat tableY = CGRectGetMaxY(tableView1.frame);

		UITableView *tableView2 = [[UITableView alloc]initWithFrame:(CGRect){0, tableY, self.bounds.size} style:UITableViewStyleGrouped];

		tableView2.scrollEnabled = NO;
		tableView2.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
		tableView2.separatorColor = [[UIColor whiteColor]colorWithAlphaComponent:0];

		_table1 = tableView1;
		_table2 = tableView2;

		[tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
		[tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

		tableView1.delegate = self;
		tableView2.delegate = self;
		tableView1.dataSource = self;
		tableView2.dataSource = self;

		[containtView addSubview:tableView1];
		[containtView addSubview:tableView2];

		[self configerDataSource];
		self.safeObj = [[SafeObjct alloc]initWithObject:self withSelector:@selector(onTimerRun)];

		CADisplayLink *disPlayLink = [CADisplayLink displayLinkWithTarget:self.safeObj selector:@selector(safeOntimer)];

		_timer = disPlayLink;
		_timer.paused = YES;

		[disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

	}
	return self;
}
#pragma mark 运动
-(void)onTimerRun
{
	CGFloat y1 = _table1.frame.origin.y - _speed;
	CGFloat y2 = _table2.frame.origin.y - _speed;
	_table1.frame = (CGRect){
		_table1.frame.origin.x,
		y1,
		_table1.frame.size
	};

	_table2.frame = (CGRect){
		_table2.frame.origin.x,
		y2,
		_table2.frame.size
	};

	CGFloat y1Max = CGRectGetMaxY(_table1.frame);
	CGFloat y2Max = CGRectGetMaxY(_table2.frame);
	if (y1Max<= 0) {
		_table1.frame = (CGRect){
			_table1.frame.origin.x,
			y2Max,
			_table1.frame.size
		};
	}
	if (y2Max <= 0) {
		_table2.frame = (CGRect){
			_table2.frame.origin.x,
			y1Max,
			_table2.frame.size
		};
	}
	[self checkCellFrame];
}
-(void)addTitlesWithArray:(NSArray <NSString *>*)titles
{
	if (titles) {
		if (titles.count > 0) {
			[self pasueRun];
			[self.dataSource removeAllObjects];
			NSMutableArray *tmpArray = [NSMutableArray array];

			CGFloat height = 	CGRectGetHeight(self.frame);
			CGFloat baseHeight =  titles.count * _cellHeight;
			CGFloat minHeight = height * 1.5f;
			CGFloat scale = 	(minHeight - baseHeight )/minHeight;

			if (scale < 1.0 && scale >= 0) {
				NSInteger runCount = ( titles.count / (1 - scale)/1) /titles.count;
				for (int i = 0; i< runCount; i++) {
					[tmpArray addObjectsFromArray:titles];
				}
			}else{
				[tmpArray addObjectsFromArray:titles];
			}
			[self.dataSource addObjectsFromArray:tmpArray];
		}
		[self configerDataSource];
	}
}
#pragma mark 初始化数据
-(void)configerDataSource
{
		//暂停运行
	[self pasueRun];
		//配置数据
	CGFloat table1Height = self.dataSource.count * _cellHeight;
	CGFloat table2Height = self.dataSource.count * _cellHeight;

	_table1.frame = (CGRect){
		_table1.frame.origin,
		_table1.frame.size.width,
		table1Height
	};

	CGFloat tableY2 = CGRectGetMaxY(_table1.frame);

	_table2.frame = (CGRect){
		_table2.frame.origin.x,
		tableY2,
		_table2.frame.size.width,
		table2Height
	};

	[self reloadTableData];
	[self startRun];
}
	//查看位置
-(void)checkCellFrame
{
	for (int i = 0; i<self.cellArray.count; i++) {
		UITableViewCell *cell =  self.cellArray[i];
		CGRect aRect  = [self convertRect:cell.bounds fromView:cell];
		CGFloat centerY = 	CGRectGetMidY(aRect);
		CGFloat   centerY2 = 	CGRectGetMidY(self.bounds);
		CGFloat scale = 1 -	fabs((centerY2 - centerY))/CGRectGetHeight(self.frame)/2.0f;
		cell.textLabel.transform = CGAffineTransformMakeScale(scale, scale);
		cell.textLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:scale];
	}
}
	//开始运行
-(void)startRun
{
	_timer.paused = NO;
}
	//暂停运行
-(void)pasueRun
{
	[_timer setPaused:YES];
}
	//刷新两个表
-(void)reloadTableData
{
	[_table1 reloadData];
	[_table2 reloadData];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"cell";
	UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
	cell.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
	NSString *str = self.dataSource[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%d  %@",indexPath.row,str];
	cell.textLabel.font = [UIFont systemFontOfSize:16.5f];
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	cell.textLabel.textColor = [UIColor whiteColor];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	if (![self.cellArray containsObject:cell]) {
		[self.cellArray addObject:cell];
	}
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return _cellHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}

#pragma mark Getter
-(NSMutableArray *)dataSource
{
	if (!_dataSource)
	 {
		_dataSource = [[NSMutableArray alloc]init];
	 }
	return _dataSource;
}
-(NSMutableArray *)cellArray
{
	if (!_cellArray)
	 {
		_cellArray = [[NSMutableArray alloc]init];
	 }
	return _cellArray;
}


-(void)dealloc
{
	[_timer invalidate];
	_timer = nil;
}


@end
