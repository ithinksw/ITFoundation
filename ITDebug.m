#import "ITDebug.h"

NSString *ITDebugErrorPrefixForObject(id object) {
	return [NSString stringWithFormat:@"[ERROR] %@(0x%x):", NSStringFromClass([object class]), object];
}

static BOOL _ITDebugMode = NO;

BOOL ITDebugMode() {
	return _ITDebugMode;
}

void SetITDebugMode(BOOL mode) {
	_ITDebugMode = mode;
}

void ITDebugLog(NSString *format, ...) {
	if ( ( _ITDebugMode == YES ) ) {
		va_list ap;
		va_start (ap, format);
		NSLogv (format, ap);
		va_end (ap);
	}
}