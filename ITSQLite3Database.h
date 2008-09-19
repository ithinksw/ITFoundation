/*
 *	ITFoundation
 *	ITSQLite3Database.h
 *
 *	Copyright (c) 2008 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern int sqlite3_bind_objc_object(sqlite3_stmt *statement, int index, id object);
extern id sqlite3_column_objc_object(sqlite3_stmt *statement, int columnIndex);

@interface ITSQLite3Database : NSObject {
	NSString *dbPath;
	sqlite3 *db;
}

- (id)initWithPath:(NSString *)path;

- (BOOL)begin;
- (BOOL)beginTransaction;
- (BOOL)commit;
- (BOOL)commitTransaction;
- (BOOL)rollback;
- (BOOL)rollbackTransaction;

- (BOOL)executeQuery:(NSString *)query va_args:(va_list)args;
- (BOOL)executeQuery:(NSString *)query, ...;

- (NSDictionary *)fetchRow:(NSString *)query va_args:(va_list)args;
- (NSDictionary *)fetchRow:(NSString *)query, ...;

- (NSArray *)fetchTable:(NSString *)query va_args:(va_list)args;
- (NSArray *)fetchTable:(NSString *)query, ...;

@end
