//
//  SafeObjct.m
//  kt
//
//  Created by ios2 on 2018/6/28.
//  Copyright © 2018年 考题. All rights reserved.
//

#import "SafeObjct.h"
@implementation SafeObjct {
	__weak id _object;
	SEL _sel;
}
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector
{
	self = [super init];
	if (self) {
		_object = object;
		_sel = selector;
	}
	return self;
}
-(void)safeOntimer
{
	if (_object&&[_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		 [_object performSelector:_sel withObject:nil];
#pragma clang diagnostic pop
	}
}



@end
