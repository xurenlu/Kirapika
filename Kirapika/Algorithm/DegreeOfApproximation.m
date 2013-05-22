//
//  DegreeOfApproximation.m
//  v1.2 add synonyms check(update) and length check
//
//  Created by Justin Jia on 1/11/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "DegreeOfApproximation.h"

@implementation DegreeOfApproximation

+ (int)extraCost:(NSMutableString *)x
{
    return [x replaceOccurrencesOfString:@"NOSIMI" withString:nil options:NSWidthInsensitiveSearch range:NSMakeRange(0, [x length])];
}

+ (double)degreeOfApproximation:(NSString *)x :(NSString *)y withExtra:(int)extra
{
    int sl = (int)x.length/6+1;
    int tl = (int)y.length/6+1;
    
    if (sl==1) return tl-1;
    if (tl==1) return sl-1;
    
    int length = sizeof(int)*sl*tl;
    int *buffer = malloc(length);
    int **matrix = malloc(sizeof(int*)*sl);
    memset(buffer, 0, length);
    for (int i=0; i<sl; i++) matrix[i] = buffer+(i*tl);
    
    for (int i=0; i<sl; i++) matrix[i][0]=i;
    for (int i=1; i<tl; i++) matrix[0][i]=i;
    
    for (int i=1; i<sl; i++) {
        int sc = [[x substringWithRange:NSMakeRange(i*6-6, 6)] intValue];
        for (int j=1; j<tl; j++) {
            int tc = [[y substringWithRange:NSMakeRange(j*6-6, 6)] intValue];
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
    
    return (1-(re+extra)/fmax(sl-1, tl-1));
}

@end
