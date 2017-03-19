//
//  ASSyncResult.h
//  ASSyncLibraryProject
//
//  Created by Apple on 08/04/13.
//
//

#import "ASSyncNetworkEngine.h"

@interface ASSyncResult : NSObject
@property (nonatomic,assign)SyncAction syntype;
@property (nonatomic,strong)NSString * synId;
@property (nonatomic,assign)NSInteger errorcode;
@property (nonatomic,strong)NSString *errormsg;

@property (nonatomic,assign)NSInteger serverbefore;
@property (nonatomic,assign)NSInteger serverafter;
@property (nonatomic,assign)NSInteger serverskip;
@property (nonatomic,assign)NSInteger serverequal;
@property (nonatomic,assign)NSInteger serverseccess;
@property (nonatomic,assign)NSInteger serverfail;
@property (nonatomic,assign)NSInteger serverAddIds;     //服务器实际新增的条数 服务器有改动，但是数据库需维护旧包的数据库，所以命名不能改，serverAddIds 对应serverAdd
@property (nonatomic,assign)NSInteger serverUpdateIds;  //服务器实际修改的条数 serverUpdateIds对应serverReplace
@property (nonatomic,assign)NSInteger serverDeleteIds;  //服务器实际删除的条数 serverDeleteIds对应serverDelete
@property (nonatomic,assign)NSInteger addlocal; // 客户端需要新增联系人条数
@property (nonatomic,assign)NSInteger replacelocal; // 客户端需要更新联系人条数
@property (nonatomic,assign)NSInteger deletelocal; // 客户端需要删除的联系人条数

@property (nonatomic,strong)NSDate *date;

- (void)parse:(id)resultJson syncAction:(SyncAction)syncAction;
- (BOOL)saveToCache;
+ (ASSyncResult*)getFromCache;
+ (void)clearCache;
@end
