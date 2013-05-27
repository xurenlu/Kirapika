//
//  DegreeOfApproximation.m
//  v1.2 add synonyms check(update) and length check
//
//  Created by Justin Jia on 1/11/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "DegreeOfApproximation.h"
#import "NSString+Transcode.h"

@implementation DegreeOfApproximation

+ (int)extraCost:(NSMutableString *)x
{
    return (int)[x replaceOccurrencesOfString:NOSIMIWO withString:@"" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [x length])];
}

+ (double)degreeOfApproximation:(NSString *)x :(NSString *)y withExtra:(int)extra
{
    int ml = NOSIMIWO.length;
    int sl = (int)x.length/ml+1;
    int tl = (int)y.length/ml+1;
    
#warning need test
    if (sl > 10 || tl > 10) NSLog(@"sl%d,tl%d",sl,tl);
    
    if (sl==1 || tl==1) return 0;

    int length = sizeof(int)*sl*tl;
    int *buffer = malloc(length);
    int **matrix = malloc(sizeof(int*)*sl);
    memset(buffer, 0, length);
    for (int i=0; i<sl; i++) matrix[i] = buffer+(i*tl);
    
    for (int i=0; i<sl; i++) matrix[i][0]=i;
    for (int i=1; i<tl; i++) matrix[0][i]=i;
    
    for (int i=1; i<sl; i++) {
        int sc = [[x substringWithRange:NSMakeRange(i*ml-ml, ml)] intValue];
        for (int j=1; j<tl; j++) {
            int tc = [[y substringWithRange:NSMakeRange(j*ml-ml, ml)] intValue];
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
    
    if (sl > 10 || tl > 10) NSLog(@"a");
    
    NSLog(@"re%d,extra%d;x%@,y%@",re,extra,x,y);
    
    return (1-(re+extra)/fmax(sl-1, tl-1));
}

@end
