//
//  NSString+Transcode.m
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "NSString+Transcode.h"
#import "NSString+Tokenize.h"

@implementation NSString (Transcode)

- (NSString *)transcode
{
    return self;
}

@end

/*
 //
 //  DegreeOfApproximation.m
 //  v1.2 add synonyms check(update) and length check
 //
 //  Created by Justin Jia on 1/11/13.
 //  Copyright (c) 2013 Justin Jia. All rights reserved.
 //
 
 #import "DegreeOfApproximation.h"
 #import "NSString+Tokenize.h"
 
 #define DELETE 1
 #define SUBSTITUTION 1
 #define INSERT 1
 #define MAX_LENGTH 5
 
 @interface DegreeOfApproximation()
 @property (nonatomic) BOOL isPrepared;
 @property (nonatomic) BOOL isSaved;
 @property (nonatomic) long int identifier;
 @property (nonatomic, strong) NSMutableArray *synoymsPool;
 @property (nonatomic, strong) NSCharacterSet *separationSet;
 @property (nonatomic, strong) NSArray *savedXArray;
 - (NSString *)checkSynoymsFromString:(NSString *)strOrg;
 - (double)degreeOfApproximationWithArray:(NSMutableArray *)xArray andArray:(NSMutableArray *)yArray;
 - (double)levenshteinDitstanceFromS:(NSString *)source toT:(NSString *)target;
 @end
 
 @implementation DegreeOfApproximation
 
 - (void)prepare
 {
 NSString *synoymsPoolStr = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Synonyms" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
 self.synoymsPool = [[NSMutableArray alloc]initWithArray:[synoymsPoolStr componentsSeparatedByString:@";;\n"]];
 for (int i=0; i<self.synoymsPool.count; i++) {
 NSString *str = [self.synoymsPool objectAtIndex:i];
 NSArray *array = [str componentsSeparatedByString:@"::"];
 [self.synoymsPool replaceObjectAtIndex:i withObject:array];
 }
 self.separationSet = [NSCharacterSet characterSetWithCharactersInString:@"，,。.[～→/ "];
 self.isPrepared = YES;
 }
 
 - (void)saveOneString:(NSString *)x
 {
 x = [self checkSynoymsFromString:x];
 self.savedXArray = [[NSArray alloc]initWithArray:x.arrayWithWordTokenize];
 self.isSaved = YES;
 }
 
 - (double)degreeOfApproximationWithStringIncludeLengthCheck:(NSString *)x andString:(NSString *)y
 {
 if (!self.isPrepared) [self prepare];
 
 NSMutableArray *xArray, *yArray;
 if (!self.isSaved) {
 x = [self checkSynoymsFromString:x];
 xArray = x.arrayWithWordTokenize;
 } else {
 xArray = [self.savedXArray mutableCopy];
 }
 
 y = [self checkSynoymsFromString:y];
 yArray = y.arrayWithWordTokenize;
 
 if ((xArray.count < MAX_LENGTH || yArray.count < MAX_LENGTH) && xArray.count < 7 && yArray.count < 7) {
 return [self degreeOfApproximationWithArray:xArray andArray:yArray];
 } else {
 double percentage = 0;
 int count = 0;
 for (NSString *yElement in [y componentsSeparatedByCharactersInSet:self.separationSet]) {
 if (yElement.length > 0) {
 double singlePercentage = 0;
 for (NSString *xElement in [x componentsSeparatedByCharactersInSet:self.separationSet]) {
 if (xElement.length > 0) {
 xArray = [[xElement substringToIndex:fmin(MAX_LENGTH, xElement.length)] arrayWithWordTokenize];
 yArray = [[yElement substringToIndex:fmin(MAX_LENGTH, yElement.length)] arrayWithWordTokenize];
 singlePercentage = fmax(singlePercentage, [self degreeOfApproximationWithArray:xArray andArray:yArray]);
 }
 }
 percentage = percentage + singlePercentage;
 count++;
 }
 }
 return percentage/count;
 }
 }
 
 - (double)degreeOfApproximationWithString:(NSString *)x andString:(NSString *)y
 {
 if (!self.isPrepared) [self prepare];
 
 NSMutableArray *xArray, *yArray;
 if (!self.isSaved) {
 x = [self checkSynoymsFromString:x];
 xArray = x.arrayWithWordTokenize;
 } else {
 xArray = [self.savedXArray mutableCopy];
 }
 
 y = [self checkSynoymsFromString:y];
 yArray = y.arrayWithWordTokenize;
 
 return [self degreeOfApproximationWithArray:xArray andArray:yArray];
 }
 
 - (NSString *)checkSynoymsFromString:(NSMutableString *)strOrg
 {
 NSMutableString *str = [[NSMutableString alloc]initWithString:strOrg];
 for (int i=0; i<self.synoymsPool.count; i++) {
 for (NSString *syns in [self.synoymsPool objectAtIndex:i]) {
 [str replaceOccurrencesOfString:syns withString:[NSString stringWithFormat:@"%d", 10000 + i] options:nil range:NSMakeRange(0, [str length])];
 }
 }
 return str;
 }
 
 - (double)degreeOfApproximationWithArray:(NSMutableArray *)xArray andArray:(NSMutableArray *)yArray;
 {
 [xArray removeObject:@":"];
 [yArray removeObject:@":"];
 
 NSString *xStr = nil, *yStr = nil, *xReplaced = nil, *yReplaced = nil;
 for (int i=0; i<fmax(xArray.count, yArray.count); i++) {
 if (i<xArray.count) {
 xStr = [xArray objectAtIndex:i];
 xReplaced = [NSString stringWithFormat:@"%ld",self.identifier];
 }
 
 if (i<yArray.count) {
 yStr = [yArray objectAtIndex:i];
 if (yStr != xStr && yStr != nil) yReplaced = [NSString stringWithFormat:@"%ld",self.identifier];
 }
 
 for (int f=0; f<fmax(xArray.count, yArray.count); f++) {
 if (f<xArray.count) {
 NSString *xElement = [xArray objectAtIndex:f];
 if (xElement.intValue<100000 || (xElement.intValue > 999999 || xElement.length > 6)) {
 if ([xElement isEqualToString:xStr]) [xArray replaceObjectAtIndex:i withObject:xReplaced];
 if ([xElement isEqualToString:yStr]) [xArray replaceObjectAtIndex:i withObject:yReplaced];
 }
 }
 if (f<yArray.count) {
 NSString *yElement = [yArray objectAtIndex:f];
 if (yElement.intValue<100000|| (yElement.intValue > 999999 || yElement.length > 6)) {
 if ([yElement isEqualToString:xStr]) [yArray replaceObjectAtIndex:i withObject:xReplaced];
 if ([yElement isEqualToString:yStr]) [yArray replaceObjectAtIndex:i withObject:yReplaced];
 }
 }
 }
 }
 
 return (1 - ([self levenshteinDitstanceFromS:[xArray componentsJoinedByString:nil] toT:[yArray componentsJoinedByString:nil]])/fmax(yArray.count, xArray.count));
 }
 
 - (double)levenshteinDitstanceFromS:(NSString *)source toT:(NSString *)target
 {
 int sl = (int)[source length]/6+1;
 int tl = (int)[target length]/6+1;
 
 if (sl==1) {
 return tl - 1;
 }
 if (tl==1) {
 return sl - 1;
 }
 
 int length = sizeof(int)*sl*tl;
 int *buffer = malloc(length);
 int **matrix = malloc(sizeof(int*)*sl);
 memset(buffer, 0, length);
 for (int i = 0; i<sl; i++) {
 matrix[i] = buffer+(i*tl);
 }
 
 for (int i=0; i<sl; i++) {
 matrix[i][0]=i;
 }
 for (int i=1; i<tl; i++) {
 matrix[0][i]=i;
 }
 
 for (int i=1; i<sl; i++) {
 int sc = [[source substringWithRange:NSMakeRange(i*6-6, 6)] intValue];
 for (int j=1; j<tl; j++) {
 int tc = [[target substringWithRange:NSMakeRange(j*6-6, 6)] intValue];
 int cost = (sc == tc)?0:1;
 int above = matrix[i-1][j]+1;
 int left = matrix[i][j-1]+1;
 int diag = matrix[i-1][j-1]+cost;
 int value = MIN(above,MIN(left,diag));
 matrix[i][j]=value;
 }
 }
 int re = matrix[sl-1][tl-1];
 free(buffer);
 free(matrix);
 
 return re;
 }
 
 - (long)identifier
 {
 if (_identifier < 100000 || _identifier >= 999999) _identifier = 100000;
 _identifier = _identifier + 1;
 return _identifier;
 }
 
 - (void)dealloc
 {
 [self setIsPrepared:NO];
 [self setIsSaved:NO];
 [self setSynoymsPool:nil];
 [self setSeparationSet:nil];
 }
 
 @end
*/