//
//  PaintingliteCache.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteCache
 * 数据库快照一级缓存
 * 快照数据库表名
 * 快照数据库表的结构
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteCache : NSCache
@property (nonatomic,assign)NSUInteger tableCount; //表的个数
@property (nonatomic,assign)NSUInteger optCount; //操作个数
@property (nonatomic,assign)NSUInteger limitedCacheCount; //支持缓存最大条数
@property (nonatomic,assign)NSUInteger baseReleaseLine; //释放基准线


/// 单例模式
+ (instancetype)sharePaintingliteCache;

/// 表名称缓存
/// @param tableName 表名称
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName;

/// 表结构缓存
/// @param infoArray 信息数组
/// @param tableName 表名
- (void)addSnapTableInfoNameCache:(NSArray *__nonnull)infoArray tableName:(NSString *__nonnull)tableName;


/// 操作缓存
/// @param optStr 操作字符串
- (void)addDatabaseOptionsCache:(NSString *__nonnull)optStr;


/// 写入缓存文件
- (void)pushCacheToLogFile;

@end

NS_ASSUME_NONNULL_END
