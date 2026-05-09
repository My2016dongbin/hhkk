#ifndef _INSIDESADP_H_
#define _INSIDESADP_H_

#import "Sadp.h"

#define SADP_SET_WIFI_SSID_PASSWORD         22  //设置SSID，密码
#define SADP_CHECK_WIFI_SSID_PASSWORD       23  //校验SSID，密码
#define SADP_GET_EZVIZ_UNBIND_STATUS        24  //获取萤石账号解绑状态
#define SADP_EZVIZ_UNBIND                   25  //解绑萤石账号
#define SADP_EZVIZ_UNBIND_DEL_USER          26  //解绑萤石账号（同时删除设备内所有云端用户，当前适用于Axiom Pro主机）

//对未激活设备配置WiFi的SSID和password
CSADP_API BOOL CALLBACK SADP_WifiParamCfg(const char* sMAC, const char* sSSID, const char* sPassword);
//对未激活设备校验WiFi的SSID和password
CSADP_API BOOL CALLBACK SADP_WifiParamCheck(const char* sMAC, const char* sSSID, const char* sPassword);

//萤石账号解绑状态信息结构体
typedef struct tagSADP_EZVIZ_UNBIND_STATUS
{
    unsigned char    byResult; //结果，0-未知，1-设备当前可以解绑， 2-没有绑定萤石账号， 3-没有开启萤石云功能， 4-萤石云状态为离线
    unsigned char    byRes[127];
}SADP_EZVIZ_UNBIND_STATUS, *LPSADP_EZVIZ_UNBIND_STATUS;

//萤石账号解绑参数结构体
typedef struct tagSADP_EZVIZ_UNBIND_PARAM
{
    char            szPassword[MAX_PASS_LEN];  //密码
    unsigned char    byRes[256];
}SADP_EZVIZ_UNBIND_PARAM, *LPSADP_EZVIZ_UNBIND_PARAM;

typedef struct tagSADP_EZVIZ_UNBIND_DEL_USER_PARAM
{
    unsigned int    dwSize;
    char            szCode[MAX_ENCRYPT_CODE]; //日期转换过的特殊字符串或加密工具加密后的字符串 - byResetType 为1、3时有效
    unsigned char   byRes[512];
}SADP_EZVIZ_UNBIND_DEL_USER_PARAM, *LPSADP_EZVIZ_UNBIND_DEL_USER_PARAM;

#endif




