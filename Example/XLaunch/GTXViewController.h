//
//  GTXViewController.h
//  XLaunch
//
//  Created by 翼王 on 12/11/2020.
//  Copyright (c) 2020 翼王. All rights reserved.
//

@import UIKit;

#ifdef __LP64__
typedef struct section_64 resober_Section;
typedef uint64_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader_64
#else
typedef struct section resober_Section;
typedef uint32_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader
#endif

@interface GTXViewController : UIViewController

@end
