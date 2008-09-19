#import "ITSQLite3Database.h"

int sqlite3_bind_objc_object(sqlite3_stmt *statement, int index, id object) {
	int retval;
	
	if ([object isKindOfClass:[NSData class]]) {
		retval = sqlite3_bind_blob(statement, index, [object bytes], [object length], SQLITE_TRANSIENT);
	} else if ([object isKindOfClass:[NSDate class]]) {
		retval = sqlite3_bind_double(statement, index, [object timeIntervalSince1970]);
	} else if ([object isKindOfClass:[NSNull class]]) {
		retval = sqlite3_bind_null(statement, index);
	} else if ([object isKindOfClass:[NSNumber class]]) {
		if (strcmp([object objCType], @encode(BOOL)) == 0) {
			retval = sqlite3_bind_int(statement, index, ([object boolValue] ? 1 : 0));
		} else if (strcmp([object objCType], @encode(int)) == 0) {
			retval = sqlite3_bind_int64(statement, index, [object longValue]);
		} else if (strcmp([object objCType], @encode(long)) == 0) {
			retval = sqlite3_bind_int64(statement, index, [object longValue]);
		} else if (strcmp([object objCType], @encode(float)) == 0) {
			retval = sqlite3_bind_double(statement, index, [object floatValue]);
		} else if (strcmp([object objCType], @encode(double)) == 0) {
			retval = sqlite3_bind_double(statement, index, [object doubleValue]);
		}
	}
	
	if (!retval) {
		retval = sqlite3_bind_text(statement, index, [[object description] UTF8String], -1, SQLITE_TRANSIENT);
	}
	
	return retval;
}

id sqlite3_column_objc_object(sqlite3_stmt *statement, int columnIndex) {
	id retval;
	
	switch (sqlite3_column_type(statement, columnIndex)) {
		case SQLITE_INTEGER:
			retval = [NSNumber numberWithLongLong:sqlite3_column_int64(statement, columnIndex)];
			break;
		case SQLITE_FLOAT:
			retval = [NSNumber numberWithDouble:sqlite3_column_double(statement, columnIndex)];
			break;
		case SQLITE_TEXT:
			retval = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, columnIndex)];
			break;
		case SQLITE_BLOB:
			retval = [NSData dataWithBytes:sqlite3_column_blob(statement, columnIndex) length:sqlite3_column_bytes(statement, columnIndex)];
			break;
		case SQLITE_NULL:
		default:
			retval = [NSNull null];
			break;
	}
	
	return retval;
}

@implementation ITSQLite3Database

- (id)initWithPath:(NSString *)path {
	if (self = [super init]) {
		dbPath = [path copy];
		if (sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK) {
			ITDebugLog(@"%@ sqlite3_open(\"%@\"): %@", ITDebugErrorPrefixForObject(self), dbPath, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
			[self release];
			return nil;
		}
	}
	return self;
}

- (void)dealloc {
	if (sqlite3_close(db) != SQLITE_OK) {
		ITDebugLog(@"%@ sqlite3_close(0x%x): %@", ITDebugErrorPrefixForObject(self), db, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
	}
	[dbPath release];
	[super dealloc];
}

- (BOOL)begin {
	return [self beginTransaction];
}

- (BOOL)beginTransaction {
	return [self executeQuery:@"BEGIN TRANSACTION;"];
}

- (BOOL)commit {
	return [self commitTransaction];
}

- (BOOL)commitTransaction {
	return [self executeQuery:@"COMMIT TRANSACTION;"];
}

- (BOOL)rollback {
	return [self rollbackTransaction];
}

- (BOOL)rollbackTransaction {
	return [self executeQuery:@"ROLLBACK TRANSACTION;"];
}

- (BOOL)executeQuery:(NSString *)query va_args:(va_list)args {
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare(db, [query UTF8String], -1, &statement, 0) != SQLITE_OK) {
		ITDebugLog(@"%@ sqlite3_prepare(0x%x, \"%@\", -1, 0x%x, 0): %@", ITDebugErrorPrefixForObject(self), db, query, statement, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
		return NO;
	}
	
	int argi, argc = sqlite3_bind_parameter_count(statement);
	for (argi = 0; argi < argc; argi++) {
		id arg = va_arg(args, id);
		
		if (!arg) {
			[NSException raise:NSInvalidArgumentException format:@"ITSQLite3Database: -executeQuery expected %i arguments, received %i.", argc, argi];
			sqlite3_finalize(statement);
			return NO;
		}
		
		sqlite3_bind_objc_object(statement, argi+1, arg);
	}
	
	int stepret = sqlite3_step(statement);
	int finalizeret = sqlite3_finalize(statement);
	if (!(stepret == SQLITE_DONE || stepret == SQLITE_ROW)) {
		ITDebugLog(@"%@ sqlite3_step(0x%x): %@", ITDebugErrorPrefixForObject(self), statement, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
		return NO;
	}
	
	return YES;
}

- (BOOL)executeQuery:(NSString *)query, ... {
	va_list args;
	va_start(args, query);
	
	BOOL result = [self executeQuery:query va_args:args];
	
	va_end(args);
	return result;
}

- (NSDictionary *)fetchRow:(NSString *)query va_args:(va_list)args {
	NSArray *table = [self fetchTable:query va_args:args];
	if ([table count] >= 1) {
		return [table objectAtIndex:0];
	}
	return nil;
}

- (NSDictionary *)fetchRow:(NSString *)query, ... {
	va_list args;
	va_start(args, query);
	
	id result = [self fetchRow:query va_args:args];
	
	va_end(args);
	return result;
}

- (NSArray *)fetchTable:(NSString *)query va_args:(va_list)args {
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare(db, [query UTF8String], -1, &statement, 0) != SQLITE_OK) {
		ITDebugLog(@"%@ sqlite3_prepare(0x%x, \"%@\", -1, 0x%x, 0): %@", ITDebugErrorPrefixForObject(self), db, query, statement, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
		return NO;
	}
	
	int argi, argc = sqlite3_bind_parameter_count(statement);
	for (argi = 0; argi < argc; argi++) {
		id arg = va_arg(args, id);
		
		if (!arg) {
			[NSException raise:NSInvalidArgumentException format:@"ITSQLite3Database: -executeQuery expected %i arguments, received %i.", argc, argi];
			sqlite3_finalize(statement);
			return NO;
		}
		
		sqlite3_bind_objc_object(statement, argi+1, arg);
	}
	
	NSMutableArray *rowArray = [[NSMutableArray alloc] init];
	
	int stepret;
	while ((stepret = sqlite3_step(statement)) == SQLITE_ROW) {
		NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
		int coli, cols = sqlite3_column_count(statement);
		for (coli = 0; coli < cols; coli++) {
			[row setObject:sqlite3_column_objc_object(statement, coli) forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement, coli)]];
		}
		[rowArray addObject:[row autorelease]];
	}
	
	int finalizeret = sqlite3_finalize(statement);
	if (stepret != SQLITE_DONE) {
		ITDebugLog(@"%@ sqlite3_step(0x%x): %@", ITDebugErrorPrefixForObject(self), statement, [NSString stringWithUTF8String:sqlite3_errmsg(db)]);
		return NO;
	}
	
	return [rowArray autorelease];
}

- (NSArray *)fetchTable:(NSString *)query, ... {
	va_list args;
	va_start(args, query);
	
	id result = [self fetchTable:query va_args:args];
	
	va_end(args);
	return result;
}

@end
