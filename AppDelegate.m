//
//  AppDelegate.m
//  OpenInVim
//
//  Created by Reza Jelveh on 6/9/09.
//  Copyright 2009 Protonet.info. All rights reserved.
//

#import "AppDelegate.h"
#import "GetPID.h"

@implementation AppDelegate

- (void) runScript:(NSArray*) arguments
{
    NSTask *task;
    NSString *homePath = NSHomeDirectory();

    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];

    [task setEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:@":0.0",@"DISPLAY",
                          @"/opt/local/gentoo/usr/bin:/bin:/usr/bin",@"PATH",
                          homePath,@"HOME",
                          @"en_US.UTF-8",@"LC_ALL",nil]];

    [task setArguments: arguments];
    [task launch];
}

- (void) bringToForeground
{
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;

    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
        @"tell application \"X11\" to activate"];

    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
}

- (BOOL) isVimRunning
{
    // Too be on the safe side, I chose the array length to be 10.
    const int kPIDArrayLength = 10;
    pid_t myArray[kPIDArrayLength];
    unsigned int numberMatches;
    int error;

    error = GetAllPIDsForProcessName("vim",
                                     myArray,
                                     kPIDArrayLength,
                                     &numberMatches,
                                     NULL);
    if (error == 0 && numberMatches >= 1) {
        /*
         * There's already a copy of this app running
         * Quit this copy
         */
        return YES;
    }

    return NO;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    //NSString *script = @"($( ps -awx | grep -F 'bin/X' | awk '{print $(NF-2)}' | grep -e \":[0-9]\"  )); if [[ -n $disp_no ]];then DISPLAY=${disp_no}.0; else DISPLAY=:0.0; fi;env DISPLAY=$DISPLAY /opt/local/gentoo/usr/bin/vim --remote ";
    NSString *vimCommand;
    if ([self isVimRunning])
        vimCommand = @"vim --servername VIM --remote";
    else
        vimCommand = @"urxvt -e vim --servername VIM";

    NSString *vim = [NSString stringWithFormat:@"%@ %@",
        vimCommand,
        [filenames componentsJoinedByString:@" "]];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"-c",
                                                  vim, nil];

    [self runScript:array];
    [self bringToForeground];
}

@end
