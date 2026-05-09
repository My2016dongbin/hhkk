/********************************************************************* 
 * Copyright (C), 2014-2015, Digital Technology Co., Ltd.
 * 文件名   : EZStreamStatistics.h
 * 功能描述 : EZStreamStatistics实现文件
 * 作者     ：tanyongfeng
 * 创建日期 ：2016-5-17
 * 修改历史 ：初始版本(2016-5-17)
 *
 * 
**********************************************************************/ 

#ifndef _EZ_STATISTICS_H_
#define _EZ_STATISTICS_H_

#include <string>
using namespace std;


class BaseStatistics
{
public:
	BaseStatistics();
	virtual ~BaseStatistics();
	virtual string toJson() = 0;
	virtual void clear() = 0;

	string systemName;

};

class StreamStatistics : public BaseStatistics
{
public:
    StreamStatistics();
    virtual ~StreamStatistics();
    int64_t _startTime;
    int64_t _endTime;
    int r;//播放结果（0为成功，失败为具体错误码）
    int via;
};

class PreviewStatistics : public StreamStatistics
{
public:
	PreviewStatistics();
	virtual ~PreviewStatistics();
	int clienttype;//客户端类类型
	int64_t inSubPreview_t;//进入子表预览函数
	int64_t apiStart_t;//调用取流接口时间
	int64_t apiBack_t;//取流接口反馈时间
    int64_t clnreqst;//预览发生的时间戳

};
class DirectPreviewStatistics : public PreviewStatistics
{
public:
	DirectPreviewStatistics();
	virtual ~DirectPreviewStatistics();
	//string uuid;//uuid，用于关联公共数据 [MainStatistics传入]
//    int via;//连接方式，0表示内网直连，1表示公网直连
	string deviceIP;//当via为0时，表示设备内网IP;当via为1时，表示设备公网IP
	int devicePort;//当via为0时，表示设备内网Port;当via为1时，表示设备公网Port
	string casIP;//cas 的IP地址，原来为域名，解析为IP
	int casPort;//cas端口
	int t1;//请求播放接口 耗时，时间格式为毫秒数，如1700，不带小数点 [start]
	int r1;//请求播放接口 返回结果（0为成功，失败为具体错误码 [start]
	int t3;//请求操作码接口耗时，时间格式为毫秒数，如1700，不带小数点
	int r3;//请求操作码接口返回结果（0为成功，失败为具体错误码）
//    int flow;//本次流量总数，以字节单位 [先不做]
//	int decd;//断流错误码 [msg过来，getlasterror]
	string toJson();
	void clear();
};

class PrivateStreamPreviewStatistics : public PreviewStatistics
{
public:
	PrivateStreamPreviewStatistics();
	virtual ~PrivateStreamPreviewStatistics();
//    int via;//连接方式，2表示私有视频流媒体私有化播放，4表示广场视频流媒体私有化播放（工作室不存在广场视频）[应用层传入,库不考虑]
	string vtmIP;//VTM IP
	int vtmPort;//VTM Port
    int t2;//VTM域名解析耗时，时间格式为毫秒数，如1700，不带小数点
    int r2;//VTM域名解析结果（0为成功，失败为具体错误码）
	int t3;//获取VTDU信息接口 耗时（GETVTDUINFO），时间格式为毫秒数，如1700，不带小数点（这个是客户端到VTM上拿VTDU的时间） [stream库取]
	int r3;//获取VTDU信息接口 返回结果（0为成功，失败为具体错误码）[stream库取]
	string vtduIP;//VTDU IP
    string pid; //streamKey
	int vtduPort;//VTDU端口
	int t4;//VTDU域名解析耗时，时间格式为毫秒数，如1700，不带小数点 [stream库取]
	int r4;//VTDU域名解析结果（0为成功，失败为具体错误码）[stream库取,getlasterror]
	int t5;//开始取流接口耗时，时间格式为毫秒数，如1700，不带小数点 [stream库取]
	int r5;//开始取流接口返回结果（0为成功，失败为具体错误码）[stream库取,getlasterror]
	int type;//1.直播设备 2.分享设备 3.强制转发设备 4.预操作未完成设备 5.预操作直连失败设备 6.直连失败转流媒体 7. 无法直连设备 [456处理]
//    int flow;//本次流量总数，以kB为单位
//	int decd;//断流错误码
	int rp;//走蚁兵代理取流错误码，用于分析在gvp=1 && np=1时，代理不工作的不同情况占比
	int p2pstatus;//0 排队打洞（如果有效预连接超过限制，则不会再打洞），1 不支持打洞，2 正在打洞中，3 打洞成功， 4 打洞失败
	int directstatus;//int32型变量，分4个byte（从低位到高位分别为d0,d1,d2,d3）,d0字段用于内网直连，d1用于外网直连，d2用于反向直连，d3暂时保留。每种直连的状态分别为：0未做过，1直连成功,2直连失败,3 不支持
    int directTime;//取流时直连检测时间
    int connectvtdutime;//连接vtdu或者连接代理的耗时（connect）耗时 单位毫秒
    int vtdusignaltime;//向vtdu或代理发送play消息并且等到响应结果的耗时 单位毫秒
    int connectproxytime;//连接代理的耗时（connect）耗时 单位毫秒
    int proxysignaltime;//向代理发送play消息并且等到响应结果的耗时 单位毫秒
    int connectvtmtime;//连接vtm 耗时 单位毫秒 （-1默认值）
    int proxyTime;//尝试蚁兵的总耗时 单位毫秒（-1默认值，表示未走过蚁兵）
	int vtduCache;//是否使用过缓存的vtdu (1-使用过 0-默认值，未使用)
	int firstR;//使用缓存vtdu取流时，首次取流的错误码
    
    int udpFlag;
    int firstTransDelay;
    int lagTimes; //lag > 100ms
    int maxDelay;
    int freqDelay;
    int maxLossPacketRate;
    int freqLossPacketRate;
    float lag_slight;
    float lag_middle;
    float lag_serious;
	float delay;
	float rtt;
	float lost_rate;

    string toJson();
	void clear();
};

class P2PPreviewStatistics : public PreviewStatistics
{
public:
	P2PPreviewStatistics();
	virtual ~P2PPreviewStatistics();
//    int via;//连接方式，7表示1.7+新设备p2p播放
	string tid;//预连接时产生的业务id,d 4.1.6表里有说明
	string casIP;//cas 的IP地址
	int casPort;//cas 的端口
	int t1;//p2p-play信令耗时 [cas库取]
	int r1;//p2p-play信令错误码 [cas库取]
//    int flow;//本次流量总数，以kB为单位
//	int decd;//断流错误码
    int transmode;//信令发送成功的传输通道，0-udp 1-server
	string des;//错误发生时的一些更具体的信息 [cas库取新加函数]
    int udtConnect;//1-udp connected  0-udp unconnected
	string toJson();
	void clear();
};



class P2PPlaybackStatistics : public PreviewStatistics
{
public:
    P2PPlaybackStatistics();
    virtual ~P2PPlaybackStatistics();
//    int via;//连接方式，17p2p回放
    string tid;//预连接时产生的业务id,d 4.1.6表里有说明
    string casIP;//cas 的IP地址
    int casPort;//cas 的端口
    int t1;//p2p-play信令耗时 [cas库取]
    int r1;//p2p-play信令错误码 [cas库取]
//    int flow;//本次流量总数，以kB为单位
    string des;//错误发生时的一些更具体的信息 [cas库取新加函数]
//    int decd;//断流错误码
    int transmode;//信令发送成功的传输通道，0-udp 1-server
    int udtConnect;//1-udp connected  0-udp unconnected
    string toJson();
    void clear();
};

class P2PPreConnectStatistics : public BaseStatistics
{
public:
	P2PPreConnectStatistics();
	virtual ~P2PPreConnectStatistics();
    string systemName;
	string tid;//是P2P的业务id，用于识别一个P2P连接或操作，这个id会跟着信令传给设备，通过这个id可以找出些P2P连接的由生到死以及通过它传输的任何协议,(V3.2.3上报设备序列号)  [cas库取新加函数]
	string devSerial;//设备序列号
	int clientType;//标识客户端类型，1-iOS，3-Android，9-工作室
	string casIP;//cas 的IP地址
	int casPort;//cas 的端口
	string stunIP;//查外地址用的stun 的IP
	int stunPort;//stun的Port
	string deviceIP;//设备外网IP
	int devicePort;//设备外网Port
	string devinnerIP;//设备内网IP
	int devinnerPort;//设备内网Port
	string upnpIP;//设备所属路由的wan IP [cas库取新加函数]
	int upnpPort;//设备在所属路由上映射的port [cas库取新加函数]
	int punchType;//1:通过局域网地址打洞 2:通过UPNP地址打洞 3.通过设备的外网地址打洞 [cas库取新加函数]
	int t1;//p2p查询本机外网ip耗时 [cas库取]
	int r1;//p2p查询本机外网ip错误码 [cas库取]
	int t2;// p2p-setup信令耗时 [cas库取]
	int r2;//p2p-setup信令错误码 [cas库取]
	int t3;// 等待打洞成功耗时 [cas库取]
	int r3;//打洞时的错误码 [cas库取]
	int r;//本次p2p过程的错误码 [函数返回]
	string des;//描述错误发生时的一些更具体的信息[cas库取新加函数]
	int dnt;//设备NAT类型,如果ver=0，设备的NAT类型从数据库里拿,如果ver>0，设备的NAT类型从setup交互里拿
	int ver;//表明这条穿透记录使用的穿透策略,0：不依赖NAT类型且3-4不能穿透 1：支持3-4穿透策略
	int retryCount;//重试次数;
	int firsttryres; //第一次尝试P2P打洞的结果，默认-1;
	int punchswitch; //打洞切换 0-没有切换（默认），1-P2P V3切V2，2-P2P V2切V3
	int sps;//打洞场景
	string toJson();
	void clear();
};



class DirectPlaybackStatistics : public PreviewStatistics
{
public:
	DirectPlaybackStatistics();
	virtual ~DirectPlaybackStatistics();
//    int via;//连接方式，10表示内网直连，11表示公网直连
	string casIP;//cas 的IP地址
	int casPort;//cas端口
	string deviceIP;//当via为10时，表示设备内网IP;当via为11时，表示设备公网IP
	int devicePort;//当via为10时，表示设备内网Port;当via为11时，表示设备公网Port
	string toJson();
	void clear();

};

class CloudPlaybackStatistics : public StreamStatistics
{
public:
	CloudPlaybackStatistics();
	virtual ~CloudPlaybackStatistics();
//    int via;//14-云存储
	string cloudIP;//cloud ip
	int cloudPort;//cloud port
    int playbackSpeed;
    int op;//EZ_PLAYBACK_OP
    int rs;////是否重新取流. 0 否，1 是
    int64_t _startTime;
    int64_t _endTime;
	string toJson();
	void clear();
};

class PrivateStreamPlaybackStatistics : public StreamStatistics
{
public:
	PrivateStreamPlaybackStatistics();
	virtual ~PrivateStreamPlaybackStatistics();
//    int via;//连接方式，2表示私有视频流媒体私有化播放，4表示广场视频流媒体私有化播放（工作室不存在广场视频）[应用层传入,库不考虑]
	string vtmIP;//VTM IP
	int vtmPort;//VTM Port
	int t2;//VTM域名解析耗时，时间格式为毫秒数，如1700，不带小数点
	int r2;//VTM域名解析结果（0为成功，失败为具体错误码）
	int t3;//获取VTDU信息接口 耗时（GETVTDUINFO），时间格式为毫秒数，如1700，不带小数点（这个是客户端到VTM上拿VTDU的时间） [stream库取]
	int r3;//获取VTDU信息接口 返回结果（0为成功，失败为具体错误码）[stream库取]
	string vtduIP;//VTDU IP
	int vtduPort;//VTDU端口
	int t4;//VTDU域名解析耗时，时间格式为毫秒数，如1700，不带小数点 [stream库取]
	int r4;//VTDU域名解析结果（0为成功，失败为具体错误码）[stream库取,getlasterror]
	int t5;//开始取流接口耗时，时间格式为毫秒数，如1700，不带小数点 [stream库取]
	int r5;//开始取流接口返回结果（0为成功，失败为具体错误码）[stream库取,getlasterror]
//    int flow;//本次流量总数，以kB为单位
//	int decd;//断流错误码
	int connectvtdutime;//连接vtdu或者连接代理的耗时（connect）耗时 单位毫秒
	int vtdusignaltime;//向vtdu或代理发送play消息并且等到响应结果的耗时 单位毫秒
	int connectproxytime;//连接代理的耗时（connect）耗时 单位毫秒
	int proxysignaltime;//向代理发送play消息并且等到响应结果的耗时 单位毫秒
	int connectvtmtime;//连接vtm 耗时 单位毫秒 （-1默认值）
	int proxyTime;//尝试蚁兵的总耗时 单位毫秒（-1默认值，表示未走过蚁兵）
	string toJson();
	void clear();
};

class TTSVoiceTalkStatistics : public BaseStatistics
{
public:
	TTSVoiceTalkStatistics();
	virtual ~TTSVoiceTalkStatistics();
	int ver;//0 老版本，1 新版本
	string url;//对讲url
	string serverIp;
	int r;//返回值（0为成功，失败为具体错误码）
	int decd;//断流错误码（0为成功，失败为具体错误码）
	int t1;//信令耗时
	int protocol;  //1-tcp, 2-udp，对讲协议，ver=1时有效
	int maxRtt;  //语音对讲会话过程中统计的最大本端RTCP的rtt值，protocol=2的时候有效
	int minRtt;  //语音对讲会话过程中统计的最小本端RTCP的rtt值，protocol=2的时候有效
	int maxJitter;  //语音对讲会话过程中统计的最大正向抖动，protocol=2的时候有效
	int maxRJitter;  //语音对讲会话过程中统计的最大反向抖动，protocol=2的时候有效
	int levelExcellentJC;  //语音对讲会话过程中统计的最大反向抖动，protocol=2的时候有效
	int levelGoodJC;  //语音对讲会话过程中统计的抖动区间（10ms,40ms]的次数，protocol=2的时候有效
	int levelPassJC;  //语音对讲会话过程中统计的抖动区间（40ms,80ms]的次数，protocol=2的时候有效
	int levelFailJC;  //语音对讲会话过程中统计的抖动区间（40ms,80ms]的次数，protocol=2的时候有效
	int actualRcvC;  //语音对讲会话过程中统计的实际接收报，protocol=2的时候有效
	int idealRcvC;  //语音对讲会话过程中统计的理论接收报文数，protocol=2的时候有效
	int succReadC;  //语音对讲会话过程中统计的理论接收报文数，protocol=2的时候有效
	int failReadC;  //语音对讲会话过程中统计的数据缺失失败播放次数，protocol=2的时候有效
	long long lst = -1;
	string lslid = "";
	int lsctype = -1;
	string toJson();
	void clear();
};

class DirectVoiceTalkStatistics : public BaseStatistics
{
public:
	DirectVoiceTalkStatistics();
	virtual ~DirectVoiceTalkStatistics();
	int type;//0 内网直连对讲，1 外网直连对讲
//	string sn;//设备序列号
//	int cn;//通道号
	string deviceIP;//当type为0时，表示设备内网IP;当type为1时，表示设备公网IP
	int devicePort;//当type为0时，表示设备内网Port ;当type为1时，表示设备公网Port
	int r;//返回值（0为成功，失败为具体错误码）
	int t1;//信令耗时
	string toJson();
	void clear();
};


class P2PVoiceTalkStatistics : public BaseStatistics
{
public:
    P2PVoiceTalkStatistics();
    virtual ~P2PVoiceTalkStatistics();
    
    string tid;//预连接时产生的业务id,d 4.1.6表里有说明
    string casIP;//cas 的IP地址
    int casPort;//cas 的端口
    int t1;//p2p-play信令耗时 [cas库取]
    int r1;//p2p-play信令错误码 [cas库取]
    int r;//本次p2p取流信令的错误码 [playwith返回]
    int decd;//断流错误码
    int transmode;//信令发送成功的传输通道，0-udp 1-server
    
    string toJson();
    void clear();
};

class NetSDKPreviewStatistics : public PreviewStatistics
{
public:
    NetSDKPreviewStatistics();
    virtual ~NetSDKPreviewStatistics();
//    int via;//连接方式，2表示私有视频流媒体私有化播放，4表示广场视频流媒体私有化播放（工作室不存在广场视频）[应用层传入,库不考虑]
    int userID;//连接vtm 耗时 单位毫秒 （-1默认值）
    string toJson();
    void clear();
};

class NetSDKPlaybackStatistics : public StreamStatistics
{
public:
    NetSDKPlaybackStatistics();
    virtual ~NetSDKPlaybackStatistics();
//    int via;//连接方式，2表示私有视频流媒体私有化播放，4表示广场视频流媒体私有化播放（工作室不存在广场视频）[应用层传入,库不考虑]
    int userID;//连接vtm 耗时 单位毫秒 （-1默认值）
    string toJson();
    void clear();
};
class DirectPreConnectStatistics : public BaseStatistics
{
public:
    DirectPreConnectStatistics();
    virtual ~DirectPreConnectStatistics();
    string devSerial;//设备序列号
    int clientType;//标识客户端类型，1-iOS，3-Android，9-工作室
    string deviceIP;//设备外网IP
    int deviceCmdPort;//设备外网命令Port
    string devinnerIP;//设备内网IP
    int devinnerCmdPort;//设备内网命令Port
    int type;//CLIENT_TYPES,2:内网直连,3:外网直连
    int t1;//获取操作码时间
    int t;//直连检测时间
    int r;//返回值
    string systemName;//


    string toJson();
    void clear();
};

/**
 * 表定义来源于http://nvwa.hikvision.com.cn/pages/viewpage.action?pageId=14868317（启动反向直连服务数据上报）
 */
class ReverseDirectUpnpStatistics : public BaseStatistics
{
public:
	ReverseDirectUpnpStatistics();
	virtual ~ReverseDirectUpnpStatistics();

	string systemName;//表名
	int r;//启动反向直连服务状态（详情见表定义的网页地址）
	int cost;//服务器启动耗时情况
	int retrycount;//upnp重试次数
	int type;//服务启动类型（详情见表定义的网页地址）
	string mapIP;//服务对外 ip, 如果upnp = 1, 则是端口映射的地址, 如果cltNat = 1, 则是NatIP
	int mapPort;//服务对外 port, 如果upnp = 1, 则是端口映射的端口, 如果cltNat = 1, 则是InterPort
	int clntype;//客户端类型
	string natIP;//外网IP地址
	string ver;//Libcasclient 的版本信息
	int upnpstat;//端口映射的状态, 下列是按照端口的映射操作顺序依次进行的（详情见表定义的网页地址）
	int upnpr;//端口映射错误码, 错误码第4位区分哪个接口报错, 后面三位标识具体错误码（详情见表定义的网页地址）

	string toJson();
	void clear();
};

class QosTalkStatistics : public BaseStatistics
{
public:
	QosTalkStatistics();
	virtual ~QosTalkStatistics();

	string systemName;//表名,"app_video_talkback_qos"
	int r;//返回值（0为成功，失败为具体错误码）
	int decd;//断流错误码（0为成功，失败为具体错误码）
	int t1;//信令耗时
	int seq;
	int lastR; //上一次失败错误码(0表示第一次就成功了)；

	//rtt
    
    //新增ezrtc字段
    int rtt;
    int rtt_0_10;
    int rtt_10_20;
    int rtt_20_50;
    int rtt_50_100;
    
    
	int rtt_0_250;//0-250ms的样本数
	int rtt_250_500;//250-500的样本数
	int rtt_500_1000;//500-100的样本数
	int rtt_1000;//1000以上的样本数
	int rtt_max;//最大rtt

	//realrtt
	int realRtt_0_250;//0-250ms的样本数
	int realRtt_250_500;//250-500的样本数
	int realRtt_500_1000;//500-100的样本数
	int realRtt_1000;//1000以上的样本数
	int realRtt_max;//最大rtt

	//丢包率
	int plp_0_10;//丢包率0-10%的样本数
	int plp_10_20;//丢包率10-20%的样本数
	int plp_20_30;//丢包率20-30%的样本数
	int plp_30;//丢包率30%以上的样本数
	int plp_max;//最大丢包率
    int plp_average;//平均

    //卡顿比
    int frozenRate;
    
    //总样本数
	int total;

	string hardwareCode; //手机硬件特征码
	int64_t timestap; //开始对讲时刻

	string serverIP; //转发服务IP
	int serverPort; //转发服务端口
	int roomID; //需要加入房间号
    int nType; //1:NPQ 2:YS QOS(EzRtc)

	string toJson();
	void clear();

};

class DownloadStatistics : public BaseStatistics
{
public:
	DownloadStatistics();
	virtual ~DownloadStatistics();

	int via; //下载方式 50-内直 51-外直 52-流媒体 57-P2P
	int r; //下载结果
	int64_t flow; //本次流量总数，单位KB

	int64_t start_t; //开始下载时间
	int64_t data_t; //流到达时间
	int64_t stop_t; //停止下载时间
	string rd_begin; //下载的录像片段的起始时间
	string rd_end;   //下载的录像片段的结束时间

	string toJson();
	void clear();
};

#endif /* _EZ_STATISTICS_H_ */

