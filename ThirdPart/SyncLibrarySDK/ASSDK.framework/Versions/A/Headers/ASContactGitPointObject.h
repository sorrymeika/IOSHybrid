//
//  ContactGitPointObject.h
//  CaiYun
//  时光机接口解析类
//  Created by youming on 13-9-10.
//
//


@interface ASContactGitPointObject : NSObject
@property (nonatomic, strong) NSString *version_id; //版本ID
@property (nonatomic, strong) NSString *user_id; //用户ID
@property (nonatomic, strong) NSString *device_id; //终端ID
@property (nonatomic, strong)
    NSString *action; //触发备份的动作: 0,用户触发;1,上传;2,合并;3,下载;4,同步初始化;5,同步;8,上传预备份
//导入模式:
// m(merger)同步,默认;i(input)上传(覆盖);id(input-delta)差异数据上传;o(output)下载;od(output-delta)差异数据下载;d(delta)快同步;di(delta-init)同步初始化;b(backup)还原备份
@property (nonatomic, strong) NSString *create_time_day; //版本创建时间/天
@property (nonatomic, strong) NSString *create_time_hour; //版本创建时间/时
@property (nonatomic, strong) NSDate *create_time; //版本创建时间
@property (nonatomic, strong) NSString *item_count; //备份联系人数量
@property (nonatomic, strong) NSString *skip_count; //忽略条数
@property (nonatomic, strong) NSString *local_add_count; //本地对比上个版本新增数量
@property (nonatomic, strong) NSString *local_update_count; //本地对比上个版本编辑数量
@property (nonatomic, strong) NSString *local_delete_count; //本地对比上个版本删除数量
@property (nonatomic, strong) NSString *network_add_count; //网络对比上个版本新增数量
@property (nonatomic, strong) NSString *network_update_count; //网络对比上个版本编辑数量
@property (nonatomic, strong) NSString *network_delete_count; //网络对比上个版本删除数量
@property (nonatomic, strong) NSString *equal_count; //对比上个版本相同数量
@property (nonatomic, strong) NSString *dataFrom; //备注
@property (nonatomic, assign) BOOL restoreable; //是否可以还原：YES，可还原；NO，不可还原
@property (nonatomic, assign) BOOL is_success; //请求是否处理.同步成功：YES;同步失败：NO

+ (NSArray *)ContactGitPointWithJSONString:(NSString *)JSONString;
+ (NSArray *)ContactGitPointWithJSONObject:(NSArray *)JSONObject;

@end
