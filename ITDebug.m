#import "ITDebug.h"

static BOOL _ITDebugMode = NO;

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