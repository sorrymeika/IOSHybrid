//
//  JavaScriptAlert.h
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "UIHybridView.h"

@protocol HybridActionDelegate

@optional

- (void)callback;
@end


@interface HybridAction:NSObject {
    UIHybridView *_hybridView;
}

-(instancetype)initWithHybridView:(UIHybridView *)hybridView;

-(void)execute:(NSDictionary *)command;


@property (nonatomic, assign) id<HybridActionDelegate> delegate;

@end

