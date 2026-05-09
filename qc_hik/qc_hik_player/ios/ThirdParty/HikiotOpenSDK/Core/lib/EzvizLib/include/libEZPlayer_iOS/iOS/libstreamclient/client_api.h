#ifndef CLIENT_API_H
#define CLIENT_API_H
#include <string>

#ifdef WIN32
#   ifdef  libstreamclient_EXPORTS
#       define STREAM_CLIENT_API _declspec(dllexport)
#   else
#       ifdef STREAMCLIENT_STATIC
#           define STREAM_CLIENT_API 
#       else
#           define STREAM_CLIENT_API _declspec(dllimport)
#       endif // STREAMCLIENT_STATIC
#   endif
#else
#   define STREAM_CLIENT_API
#endif

class ClientApiImpl;
class STREAM_CLIENT_API ClientApi
{
public:
    static const int OK                         = 0;
    static const int ILLEGAL_STREAM_URL         = 1;     //vtmvtdu或蚁兵url非法,或未携带vtmkey
    static const int ILLEGAL_INPUT_PARAM        = 3;     //用户输入参数非法
    static const int MSG_PARSE_FAIL             = 4;     //信令消息解析失败
    static const int ILLEGAL_DEVICE_SERIAL      = 7;     //设备序列号长度非法(超过128位)
    static const int URL_TOO_LONG               = 8;     //URL长度非法
    static const int ILLEGAL_VTM_KEY            = 9;     //vtm_key超过长度(超过32),或为0
    static const int STREAM_HEAD_TOO_LONG       = 10;    //流头超过长度(超过64)
    static const int NO_CALLBACK_FUNC           = 14;    //回调函数未注册
    static const int NO_STREAM_KEY              = 15;    //未得到流标识
    static const int NO_STREAM_HEAD             = 16;    //未得到流头
    static const int NO_TOKEN                   = 17;    //没有token
    static const int PEER_DISCONNECT            = 27;    //对端连接断开
    static const int VTM_RSP_TIMEOUT            = 34;    //VTM响应超时
    static const int PROXY_RSP_TIMEOUT          = 35;    //蚁兵返回超时
    static const int PROXY_KEEPALIVE_TIMEOUT    = 36;    //蚁兵保活超时
    static const int VTDU_RSP_TIMEOUT           = 37;    //vtdu返回超时
    static const int VTDU_KEEPALIVE_TIMEOUT     = 38;    //vtdu保活超时

    static const int VTM_DOMAIN_RESOLVE         = 1001;  //VTM域名解析失败
    static const int VTM_ILLEGAL_ADDR           = 1002;  //VTM地址非法
    static const int VTM_CONNECT_FAIL           = 1009;  //VTM连接失败
    static const int VTM_DISCONNECT             = 1010;  //VTM断开连接
    static const int PROXY_OK                   = 1100;  //蚁兵成功
    static const int PROXY_DOMAIN_RESOLVE       = 1101;  //蚁兵域名解析失败
    static const int PROXY_ILLEGAL_ADDR         = 1102;  //蚁兵地址非法
    static const int PROXY_CONNECT_FAIL         = 1109;  //蚁兵连接失败
    static const int PROXY_DISCONNECT           = 1110;  //蚁兵断开连接
    static const int VTDU_OK                    = 1200;  //VTDU成功
    static const int VTDU_DOMAIN_RESOLVE        = 1201;  //VTDU域名解析失败
    static const int VTDU_ILLEGAL_ADDR          = 1202;  //VTDU地址非法
    static const int VTDU_CONNECT_FAIL          = 1209;  //VTDU连接失败
    static const int VTDU_DISCONNECT            = 1210;  //VTDU断开连接
    
    class ProxyRet
    {
    public:
        static const int NO_PROXY                   = 84;    //没有获得蚁兵
        static const int PROXY_CONNECT_FAILED       = 85;    //蚁兵连接失败
        static const int PROXY_DISCONNECT           = 86;    //蚁兵断开连接
        static const int PROXY_SWTICH_TO_VTDU       = 87;    //proxy失败,转VTDU
        static const int PROXY_CONN_EXCEPTION       = 88;    //蚁兵连接异常
        static const int PROXY_KEEPALIVE_TIMEOUT    = 89;    //代理和心跳保活超时
        static const int PROXY_TIMEOUT              = 90;    //代理端处理取流信令超时
    };

    ClientApi();
    ~ClientApi();

    //config

    // log_level:
    // 0 - none
    // 1 - error
    // 2 - warn
    // 3 - info
    // 4 - debug
    // 5 - trace
    typedef void (*log_callback)(const char* str);
    static void config_log(int log_level,log_callback func);
    static void config_self_key(const char*self_public_key,int self_public_key_ken,const char* self_private_key,int self_private_key_len);
    static void config_self_key(); // for test,generate key automatically
    static void enable_vtm_etp(bool enable);    // default false
    static void enable_vtdu_etp(bool enable);   // default false
    static void enable_proxy_etp(bool enable);  // default false
    static void enable_cmd_ecdh(bool enable);   // default false
    static void version(char v[32]);


    static void config_vtm_conn_delay(int ms);    //default: android 3000,others 5000
    static void config_vtdu_conn_delay(int ms);   //default: android 3000,others 5000
    static void config_proxy_conn_delay(int ms);  //default: 600

    static void config_vtm_rsp_delay(int ms);     //default: 10 * 1000
    static void config_vtdu_rsp_delay(int ms);    //default: 10 * 1000
    static void config_proxy_rsp_delay(int ms);   //default: 4000

    static void config(const char* c,int len);

    ClientApi& vtm_addr(const char* addr,unsigned short port);
    ClientApi& vtdu_addr(const char* addr, unsigned short port);
    ClientApi& dev_serial(const char* serial);
    ClientApi& playback_serial(const char* serial);
    ClientApi& channel(unsigned int value); 
    ClientApi& channel(const char* value);
    ClientApi& stream_type(unsigned int value);
    ClientApi& duration(const char* start_time, const char* end_time);
	ClientApi& download(const char* start_time, const char* end_time);
    ClientApi& client_type(unsigned int value);
    ClientApi& client_isp_type(unsigned int value);
    ClientApi& auth_type(unsigned int value);
    ClientApi& weak_stream(bool value);
    ClientApi& retry(bool value);
    ClientApi& lid(const char* value);
    ClientApi& stream_tag(const char* value);
    ClientApi& timestamp(const char* value);
    ClientApi& recordtype(int value);
    ClientApi& frameinterval(unsigned int value);

/** 
*  \brief      设置回放seek操作的唯一ID（具备support_seek_v2能力集的设备）
*  \param[in]  value 本次操作的唯一ID，最长64字节
*/
    ClientApi& seekuuid(const char* value);

    ClientApi& pds_str(const char* value);
    ClientApi& extension(const char* value);
    ClientApi& force_proxy();
    ClientApi& proxy_count(int proxy_count);
    ClientApi& enable_encrypt(const char* public_key, int key_len, int key_version, int devecdh);
    ClientApi& e2ee(int et2ee);
    ClientApi& udpecdh(int value);
    ClientApi& time_lapse(const char* task_id);
    typedef bool(*FetchTokenCallback)(char* token,int max_len,void* user_data);
    ClientApi& set_fetch_token_callback(FetchTokenCallback cb,void* user_data);
    int start();
    int start(const char* url);
    void stop();

    int playback_pause();
    int playback_resume();

     /*
        speed数字和速度对应关系
        1: 正常速度
        2：2倍
        3：1/2倍
        4：4倍
        5：1/4倍
        6：8倍
        7：1/8倍
        8：16倍
        9：1/16倍
    */
    int playback_set_speed(int speed);

    int playback_seek();
    int playback_continue();

    enum DataType
    {
        CLN_STREAM_TYPE_HEADER      = 1,     /* 流头 */
        CLN_STREAM_TYPE_DATA        = 2,     /* 数据 */
        CLN_STREAM_TYPE_END         = 3,     /* 回放结束标记 */
        CLN_STREAM_TYPE_STREAMKEY   = 6,     /* 码流唯一标记，在流头之前返回 */
        CLN_STREAM_TYPE_UDP_HEADER 	= 11,    /* udp码流流头，方便调整播放库的缓冲区大小PlayM4_SetDisplayBuf(m_playPort, 1); */
        CLN_STREAM_TYPE_SEEKUUID    = 21,    /* 回放seek操作时，设备返回的seekuuid */
    };
    typedef void(*StreamCallback)(const char*, size_t,unsigned int data_type,void* user_data);
    ClientApi& set_stream_callback(StreamCallback cb,void* user_data);

    struct StreamReport 
    {
        const char* stream_key;

        /*result*/
        int result;
        int proxy_result;

        int check_ip_version;

        const char* vtm_ip;
        unsigned short vtm_port;

        const char* vtdu_ip;
        unsigned short vtdu_port;

        const char* proxy_ip;
        unsigned short  proxy_port;

        /*duration cost in milliseconds*/
        int vtm_domain_cost;
        int vtm_connect_cost;
        int vtm_rsp_cost;
        long long vtm_timestamp;
        int vtm_ret;

        int vtdu_domain_cost;
        int vtdu_connect_cost;
        int vtdu_rsp_cost;
        long long vtdu_timestamp;
        int vtdu_ret;

        int proxy_domain_cost;
        int proxy_connect_cost;
        int proxy_rsp_cost;
        long long proxy_timestamp;
        int proxy_ret;

        int  transfer_type;
        float lost_rate; 
        float rtt;          /*milliseconds*/
        float jitter;
        float bandwidth;
        float bitrate;     /*kbps*/
        float framerate;   /*fps*/
        float delay;       /*average*/
        float lag_slight_rate;
        float lag_middle_rate;    
        float lag_serious_rate;
    };
    StreamReport* get_report();

    /*
    -1: NONE
    0: VTM
    1: VTDU
    2: PROXY
    */
    int get_stream_server_type();

private:
    ClientApiImpl* client_api_impl_;
    StreamReport report_;
};


#endif // CLIENT_API_H

