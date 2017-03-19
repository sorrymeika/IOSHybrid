//
//  ASSyncInfo.h
//  CaiYun
//
//  Created by kewenya on 12-6-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//  同步联系人数据实体

#import <Foundation/Foundation.h>

typedef enum {
    ESyncInfoDefault=0,
	ESyncAdd,
	ESyncUpdate,
	ESyncDelete,
    ESyncEqual,
    EServerAdd,
    EServerReplace,
	EServerDelete,
    EServerEqual
} ESyncInfoType;

#define kInvalidSourseID @"0"

@interface ASSyncInfo : NSObject

@property (nonatomic,assign) ESyncInfoType type;
@property (nonatomic,copy) NSString *localID;
@property (nonatomic,copy) NSString *sourseID;
@property (nonatomic,copy) NSDate *date;
@property (nonatomic,copy) NSString *isSync;
@property (nonatomic,copy) NSDictionary *vcardItems;

- (id) initWithID:(NSString *)localId sid:(NSString *)sourseId date:(NSDate*)contactDate type:(ESyncInfoType)contactType isSync:(NSString*)syncState;
- (id) initWithID:(NSString *)localId sid:(NSString *)sourseId vcardItems:(NSDictionary*)items type:(ESyncInfoType)contactType;
@end
