// I *could* use OWStringScanner, but I don't want to. Shut up, sabi :)

#import "ITStringScanner.h"

@implementation ITStringScanner

- (id)init
{
    if ( ( self = [super init] ) )
    {
        _cString = NULL;
        _string = nil;
        _currentPosition = 0;
        _size = 0;
    }
    return self;
}

- (id)initWithString:(NSString*)string
{
    if ( ( self = [super init] ) )
    {
        _cString = (char *)[string cString];
        _string = [string retain];
        _currentPosition = 0;
        _size = [string length];
    }
    return self;
}

- (NSString *)scanUpToCharacter:(char)character
{
    size_t i=_currentPosition,j=0;

    if (_cString[i] == character)
    {
        i++;
        return @"";
    }
    else
    {
        NSRange r = {i,0};
        NSString *tmpStr = nil;
        const size_t tmp = _size;
        unsigned char foundIt = NO;

        do
        {
            i++,j++;

            if (_cString[i] == character)
            {
                foundIt = YES;
                r.length = j;
            }

        }
        while ((!foundIt) && (i<tmp));

        if (foundIt)
        {
            tmpStr = [_string substringWithRange:r];
            _currentPosition = i;
        }
        return tmpStr;
    }
}

- (NSString *)scanUpToString:(NSString*)string
{
    size_t i=_currentPosition,j=0, len = [string length];
    const char *str2cstr = [string cString];


    if (len <= 1)
    {
        if (len)
            return [self scanUpToCharacter:str2cstr[0]];
        else
            return @"";
    }
    else
    {
        NSRange r = {i,0};
        NSString *tmpStr = nil;
        const size_t tmp = _size;
        unsigned char foundIt = NO;

        do
        {
            i++,j++;

            if (0)
            {//now we check for the rest of the string
                foundIt = YES;
                r.length = j;
            }

        }
        while ((!foundIt) && (i<tmp));

        if (foundIt)
        {
            tmpStr = [_string substringWithRange:r];
            _currentPosition = i;
        }
        return tmpStr;
    }

}
@end
