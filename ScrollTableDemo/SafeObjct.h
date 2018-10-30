//
//  SafeObjct.h
//  kt
//
//  Created by ios2 on 2018/6/28.
//  Copyright © 2018年 考题. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeObjct : NSObject

- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;

-(void)safeOntimer;

@end
