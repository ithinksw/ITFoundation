/*
 *	ITFoundation
 *	ITSQLite3Database.h
 *
 *	Copyright (c) 2008 iThink Software
 *
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern int sqlite3_bind_objc_object(sqlite3_stmt *statement, int index, id object);
extern id sqlite3_column_objc_object(sqlite3_stmt *statement, int columnIndex);

@interface ITSQLite3Database : NSObject {
	NSString *dbPath;
	sqlite3 *db;
	NSRecursiveLock *dbLock;
}

- (id)initWithPath:(NSString *)path;

- (BOOL)begin;
- (BOOL)beginTransaction;
- (BOOL)commit;
- (BOOL)commitTransaction;
- (BOOL)rollback;
- (BOOL)rollbackTransaction;

- (BOOL)executeQuery:(NSString *)query, ...;

// returns a dictionary with column names as keys, or nil
- (NSDictionary *)fetchRow:(NSString *)query, ...;

// returns an array of dictionaries with column names as keys, or an empty array
- (NSArray *)fetchTable:(NSString *)query, ...;

// returns a single column value, or nil
- (id)fetchRowColumn:(NSString *)query, ...;

// returns an array of single column values, or an empty array
- (NSArray *)fetchTableColumn:(NSString *)query, ...;

@end
