// I *could* use OWStringScanner, but I don't want to. Shut up, sabi :)

#import "ITStringScanner.h"

static NSString *AString(void)
{
    return [NSString string];
}

@implementation ITStringScanner
-(id)init
{
    if (self = [super init])
    {
        strCStr = NULL;
        str = nil;
        curPos = size = 0;
    }
    return self;
}

-(id)initWithString:(NSString*)str2
{
    if (self = [super init])
    {
        strCStr = (char *)[str2 cString];
        str = [str2 retain];
        curPos = 0;
        size = [str2 length];
    }
    return self;
}

-(NSString *)scanUpToCharacter:(char)c
{
    size_t i=curPos,j=0;

    if (strCStr[i] == c)
    {
        i++;
        return AString();
    }
    else
    {
        NSRange r = {i,0};
        NSString *tmpStr = nil;
        const size_t tmp = size;
        unsigned char foundIt = NO;

        do
        {
            i++,j++;

            if (strCStr[i] == c)
            {
                foundIt = YES;
                r.length = j;
            }

        }
        while ((!foundIt) && (i<tmp));

        if (foundIt)
        {
            tmpStr = [str substringWithRange:r];
            curPos = i;
        }
        return tmpStr;
    }
}

-(NSString *)scanUpToString:(NSString*)str2
{
    size_t i=curPos,j=0, len = [str2 length];
    const char *str2cstr = [str2 cString];


    if (len <= 1)
    {
        if (len)
            return [self scanUpToCharacter:str2cstr[0]];
        else
            return AString();
    }
    else
    {
        NSRange r = {i,0};
        NSString *tmpStr = nil;
        const size_t tmp = size;
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
            tmpStr = [str substringWithRange:r];
            curPos = i;
        }
        return tmpStr;
    }

}
@end
