//
//  EZStreamSDK_Ext.h
//  libezstreamclient
//
//  Created by kanhaiping on 2018/3/29.
//  Copyright © 2018年 linyong. All rights reserved.
//

#ifndef EZStreamSDK_Ext_h
#define EZStreamSDK_Ext_h

#include "EZStreamTypes.h"
//#include "HPR_Types.h"
//#include "client_api.h"

void *ezplayer_getInnerMediaPtr(void*  hMedia);

//用来设置DEBUG下保存流文件的路径
int ezplayer_setStreamSaveDebugPath(void* hMedia, const string &path);


#endif /* EZStreamSDK_Ext_h */
