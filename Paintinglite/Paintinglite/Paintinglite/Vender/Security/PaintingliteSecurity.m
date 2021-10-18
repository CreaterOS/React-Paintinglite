//
//  PaintingliteSecurity.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSecurity.h"
#import "PaintingliteFileManager.h"
#import "PaintingliteUUID.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteThreadManager.h"

@interface PaintingliteSecurity()

@end

@implementation PaintingliteSecurity

- (PaintingliteSecurityCodeTool *)getSecurityCode {
    return [[PaintingliteSecurityCodeTool alloc] init];
}

- (PaintingliteSecurityDecodeTool *)getSecurityDecode {
    return [[PaintingliteSecurityDecodeTool alloc] init];
}

@end
