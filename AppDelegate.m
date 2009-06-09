//
//  AppDelegate.m
//  OpenInVim
//
//  Created by Reza Jelveh on 6/9/09.
//  Copyright 2009 Protonet.info. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void) runScript:(NSArray*) arguments
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];

    [task setEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:@":0.0",@"DISPLAY",nil]];

    [task setArguments: arguments];
    [task launch];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    //NSString *script = @"($( ps -awx | grep -F 'bin/X' | awk '{print $(NF-2)}' | grep -e \":[0-9]\"  )); if [[ -n $disp_no ]];then DISPLAY=${disp_no}.0; else DISPLAY=:0.0; fi;env DISPLAY=$DISPLAY /opt/local/gentoo/usr/bin/vim --remote ";

    NSString *vim = [NSString stringWithFormat:@"%@ %@",
        @"/opt/local/gentoo/usr/bin/vim --servername VIM --remote",
        [filenames componentsJoinedByString:@" "]];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"-c",
                                                  vim, nil];

    [self runScript:array];
}

@end
