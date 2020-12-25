//
//  GTXViewController.m
//  XLaunch
//
//  Created by 翼王 on 12/11/2020.
//  Copyright (c) 2020 翼王. All rights reserved.
//

#import "GTXViewController.h"

#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <mach-o/getsect.h>
#include <mach-o/ldsyms.h>
#include <mach-o/loader.h>
#import <objc/message.h>
#import <objc/runtime.h>


#ifdef __LP64__
typedef struct section_64 resober_Section;
typedef uint64_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader_64
#else
typedef struct section resober_Section;
typedef uint32_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader
#endif


NSArray<NSString*>* gtxNames(const char* sectionName)
{
    NSMutableArray* configs = [NSMutableArray array];

    Dl_info info;
    dladdr(gtxNames, &info);

#ifndef __LP64__
    const struct mach_header* mhp = (struct mach_header*)info.dli_fbase;
    unsigned long size = 0;
    uint32_t* memory = (uint32_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else /* defined(__LP64__) */
    const struct mach_header_64* mhp = (struct mach_header_64*)info.dli_fbase;
    unsigned long size = 0;
    uint64_t* memory = (uint64_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#endif /* defined(__LP64__) */

    unsigned long counter = size / sizeof(void*);
    for (int idx = 0; idx < counter; ++idx) {
        char* string = (char*)memory[idx];
        @autoreleasepool {
            NSString *configName = [NSString stringWithUTF8String:string];
            if (configName) {
                [configs addObject:configName];
            }
        }
    }

    return configs;
}

@interface GTXViewController ()

@end

@implementation GTXViewController

- (void)viewDidLoad
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 150, [UIScreen mainScreen].bounds.size.width-60, 44);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    btn.center = CGPointMake(200, 200);
    [btn addTarget:self action:@selector(goOfflineH5) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    
    
    [self.view addSubview:btn];
}


const char* kSecRZ = "RZLauncher";
-(void)goOfflineH5{
    
    NSArray<NSString*> * rznames = gtxNames(kSecRZ);
    NSLog(@"getrznames :%@",rznames);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (void)initialize {
    // 在这里准备读取
    _dyld_register_func_for_add_image(load_image);
}

void load_image(const struct mach_header *mh, intptr_t vm_slide) {
    Dl_info info;
    if (dladdr(mh, &info) == 0) {
        return ;
    }
    NSMutableArray* configs = [NSMutableArray array];
#ifndef __LP64__
    const struct mach_header* mhp = (struct mach_header*)info.dli_fbase;
    unsigned long size = 0;
    uint32_t* memory = (uint32_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else /* defined(__LP64__) */
    const struct mach_header_64* mhp = (struct mach_header_64*)info.dli_fbase;
    unsigned long size = 0;
    uint64_t* memory = (uint64_t*)getsectiondata(mhp, SEG_DATA, kSecRZ, &size);
#endif /* defined(__LP64__) */

    unsigned long counter = size / sizeof(void*);
    for (int idx = 0; idx < counter; ++idx) {
        char* string = (char*)memory[idx];
        @autoreleasepool {
            NSString *configName = [NSString stringWithUTF8String:string];
            if (configName) {
                NSLog(@"detect name:%@",configName);
                [configs addObject:configName];
            }
        }
    }

   
}

@end
