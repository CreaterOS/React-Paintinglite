//
//  PaintingliteDataBaseOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"
#import "PaintingliteWarningHelper.h"

@interface PaintingliteDataBaseOptions()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

@implementation PaintingliteDataBaseOptions

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

#pragma mark - 单例模式
static PaintingliteDataBaseOptions *_instance = nil;
+ (instancetype)sharePaintingliteDataBaseOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 利用SQL操作
#pragma mark - 创建表
/* SQL创建 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self execTableOptForSQL:ppDb sql:sql completeHandler:nil];
}

- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (sql == NULL || sql == (id)[NSNull null] || sql.length == 0) {
        return NO;
    }
    
    Boolean flag = [self.exec sqlite3Exec:ppDb sql:sql];

    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],flag);
    }
    
    return flag;
}

/* 表名创建 */
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:ppDb tableName:tableName content:content completeHandler:nil];
}

- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 表名称为空
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    Boolean flag = [self.exec sqlite3Exec:ppDb tableName:tableName content:content];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],flag);
    }
    
    return flag;
    
}

/* Obj创建 */
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle{
    return [self createTableForObj:ppDb obj:obj createStyle:createStyle completeHandler:nil];
}

- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 对象为空
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecCreate createStyle:createStyle];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

#pragma mark - 更新表
- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName{
    return [self alterTableForName:ppDb oldName:oldName newName:newName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 旧表名称
    if (oldName == NULL || oldName == (id)[NSNull null] || oldName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    /// 新表名称
    if (newName == NULL || newName == (id)[NSNull null] || newName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"New TableName IS NULL OR New TableName Len IS 0" time:[NSDate date] solve:@"Reset The New TableName" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:@[oldName,newName] status:PaintingliteExecAlterRename createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType{
    return [self alterTableAddColumn:ppDb tableName:tableName columnName:columnName columnType:columnType completeHandler:nil];
}

- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    if (columnName == NULL || columnName == (id)[NSNull null] || columnName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"ColumnName IS NULL OR ColumnName Len IS 0" time:[NSDate date] solve:@"Reset The ColumnName" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:@[tableName,columnName,columnType] status:PaintingliteExecAlterAddColumn createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType{
    return [self alterTableForObj:ppDb obj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj{
    return [self alterTableForObj:ppDb obj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecAlterObj createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

#pragma mark - 删除表
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    return [self dropTableForTableName:ppDb tableName:tableName completeHandler:nil];
}

- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }

    Boolean success = [self.exec sqlite3Exec:ppDb tableName:tableName];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

#pragma mark - 删除表
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj{
    return [self dropTableForObj:ppDb obj:obj completeHandler:nil];
}

- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecDrop createStyle:PaintingliteDataBaseOptionsDefault];

    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    

    return success;
}

@end
