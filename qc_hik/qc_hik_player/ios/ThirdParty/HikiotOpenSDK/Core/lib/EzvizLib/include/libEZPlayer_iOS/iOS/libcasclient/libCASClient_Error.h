#ifndef __LIBCASCLIENT_ERROR_H__
#define __LIBCASCLIENT_ERROR_H__



/**
 * @defgroup libCASClinet_Error libCASClinet库错误码定义
 * 调用CASClient_GetLastError获取的错误码
 * @{
 */

#define ERROR_MSG_NO_ERROR		0	///< 无错误	
#define ERROR_MSG_UNKNOW_ERROR	1	///< 未知错误	
#define ERROR_MSG_PARAMS_ERROR	2	///<报文参数错误	
#define ERROR_MSG_PARSE_FAILED	3	///<报文解析错误	
#define ERROR_MSG_SYSTEM_ERROR  4   ///<系统内部错误(比如设备系统调用出错)

#define ERROR_MSG_COMMAND_UNKNOW				6	///<非法命令	
#define ERROR_MSG_COMMAND_NO_LONGER_SUPPORTED	7	///<过时命令	
#define ERROR_MSG_COMMAND_NOT_SUITABLE			8	///<错误命令	


#define ERROR_MSG_CHECKSUM_ERROR	11	///<校验码错误	


#define ERROR_MSG_VERSION_UNKNOW				16	///<协议版本错误	
#define ERROR_MSG_VERSION_NO_LONGER_SUPPORTED	17	///<协议版本过低	
#define ERROR_MSG_VERSION_FORBIDDEN				18	///<协议版本被禁止	


#define ERROR_MSG_SERIAL_NOT_FOR_CIVIL			21	///<序列号解析失败	
#define ERROR_MSG_SERIAL_FORBIDDEN				22	///<序列号被禁止	
#define ERROR_MSG_SERIAL_DUPLICATE				23	///<序列号重复	
#define ERROR_MSG_SERIAL_FLUSHED_IN_A_SECOND		24	///<相同序列号短时间内大量重复请求	
#define ERROR_MSG_SERIAL_NO_LONGER_SUPPORTED		25	///<序列号不再支持	


#define ERROR_MSG_LOCAL_SERVER_BUSY		31	///<本地无法响应	
#define ERROR_MSG_LOCAL_SERVER_REFUSED	32	///<本地主动拒绝	
#define ERROR_REG_CANNOT_AFFORD_PU			33	///<无法接受请求	
#define ERROR_REG_CRYPTO_UNMATCHED			34	///<设备加密算法不匹配	

#define ERROR_MSG_DEV_TYPE_INVAILED				36	///<设备类型错误	
#define ERROR_MSG_DEV_TYPE_NO_LONGGER_SUPPORTED	37	///<设备类型不再支持	


#define ERROR_MSG_PU_BUSY				41	///<设备无法响应	
#define ERROR_MSG_OPERATION_FAILED		42	///<操作码错误	
#define ERROR_PU_NO_CRYPTO_FOUND				43	///<设备或平台未找到对应的加密算法	
#define ERROR_MSG_PU_REFUSED				44	///<拒绝	
#define ERROR_MSG_PU_NO_RESOURCE			45	///<没有可用资源	
#define ERROR_MSG_PU_CHANNEL_ERROR		46	///<通道错	
#define ERROR_SYSTEM_COMMAND_PU_COMMAND_UNSUPPORTED		47	///<不支持的命令	
#define ERROR_SYSTEM_COMMAND_PU_NO_RIGHTS_TO_DO_COMMAND	48	///<没有权限	
#define ERROR_MSG_NO_SESSION_FOUND		49	///<没有找到会话

#define ERROR_PREVIEW_CHANNEL_BUSY			51	///<该通道已在发流	
#define ERROR_PREVIEW_CLIENT_BUSY			52 ///<取流地址重复	
#define ERROR_PREVIEW_STREAM_UNSUPPORTED		53	///<不支持的码流类型	
#define ERROR_PREVIEW_TRANSPORT_UNSUPPORTED	54	///<不支持的传输方式	
#define ERROR_PREVIEW_CONNECT_SERVER_FAIL	55	///<连接预览流媒体服务器失败 +
#define ERROR_PREVIEW_QUERY_WLAN_INFO_FAIL	56	///<查询设备公网出口地址失败
#define ERROR_PREVIEW_UNKNOW_ERROR          57	///<渠道nvr产生的未知错误
#define ERROR_PREVIEW_P2P_NOT_FOUND         60  ///<P2P取流通道不存在

#define ERROR_RECORD_SEARCH_START_TIME_ERROR	61	///<查找录像开始时间错	
#define ERROR_RECORD_SEARCH_STOP_TIME_ERROR	    62	///<查找录像结束时间错	
#define ERROR_RECORD_SEARCH_FAIL			    63	///<查找录像失败	+
#define ERROR_RECORD_SEARCH_LIST_ERROR	        64	///<录像播放列表数量错误(0或者过大)

#define ERROR_PLAYBACK_TYPE_UNSUPPORTED		66	///<不支持的回放类型	
#define ERROR_PLAYBACK_NO_FILE_MATCHED		67	///<没有找到文件	
#define ERROR_PLAYBACK_START_TIME_ERROR		68	///<开始时间错误	
#define ERROR_PLAYBACK_STOP_TIME_ERROR		69	///<错误的结束时间	
#define ERROR_PLAYBACK_NO_FILE_FOUND			70	///<该时间段内没有录像	
#define ERROR_PLAYBACK_CONNECT_SERVER_FAIL	71	///<连接回放服务器端失败

#define ERROR_TALK_ENCODE_TYPE_UNSUPPORTED	76	///<不支持的语音编码类型	
#define ERROR_TALK_CHANNEL_BUSY				77	///<该通道已在对讲	
#define ERROR_TALK_CLIENT_BUSY				78	///<和目的地址已有链接	
#define ERROR_TALK_UNSUPPORTED				79	///<not support talk
#define ERROR_TALK_CHANNO_ERROR				80	///<通道号错误
#define ERROR_TALK_CONNECT_SERVER_FAILED	81	///<连接语音服务器失败
#define ERROR_TALK_CONNECT_REFUSED			82	///<设备拒绝
#define ERROR_TALK_CONNECT_CAPACITY_LIMITED	83	///<设备资源受限


#define ERROR_FORMAT_NO_LOCAL_STORAGE	86	///<没有本地存储	
#define ERROR_FORMAT_FORMATING			87	///<正在格式化中	
#define ERROR_FORMAT_FAILED				88	///<尝试格式化失败	


#define ERROR_UPGRADE_PU_REQUEST_REFUSED				91	///<服务器拒绝设备升级请求	
#define ERROR_UPGRADE_PU_REQUEST_VERSION_NOT_FOUND	92	///<没有找到请求版本	
#define ERROR_UPGRADE_PU_REQUEST_UNNEEDED			93	///<不需要升级	
#define ERROR_UPGRADE_PU_REQUEST_NO_SERVER_ONLINE	94	///<没有升级服务器在线	
#define ERROR_UPGRADE_PU_REQUEST_ALL_SERVER_BUSY		95	///<所有升级服务器都达到最大负载	

#define ERROR_UPGRADE_PU_UPGRADING					101 ///<正在软件升级	
#define ERROR_UPGRADE_PU_UPGRAD_FAILED				102 ///<升级失败（包含未知错误）
#define ERROR_UPGRADE_PU_UPGRAD_WRITE_FLASH_FAILED	103 ///<升级写Flash失败
#define ERROR_UPGRADE_PU_UPGRAD_LANGUAGE_DISMATCH	104 ///<升级语言不匹配

#define ERROR_PU_PASSWORD_UPDATE_NO_USER_MATHCED					106	///<密码更新失败，没有对应用户	
#define ERROR_PU_PASSWORD_UPDATE_ORIGINAL_PASSWORD_ERROR			107	///<密码跟新失败，原始密码错误	
#define ERROR_PU_PASSWORD_UPDATE_NEW_PASSWORD_DECRYPTE_FAILED    108	///<密码更新失败，新密码解密失败	
#define ERROR_PU_PASSWORD_UPDATE_NEW_PASSWORD_CHECK_FAILED		109	///<密码更新失败，新密码不符合规则	
#define ERROR_PU_PASSWORD_UPDATE_WRITE_FLASH_FAILED				110	///<更新密码失败，写flash失败	
#define ERROR_PU_PASSWORD_UPDATE_OTHER_FALIURE					111	///<更新密码失败，其他原因	

#define ERROR_PU_PASSWORD_VERIFY_PASSWORD_ FAILED				116	///<验证密码失败	

#define ERROR_PLATFORM_CLIENT_REQUEST_NO_PU_FOUNDED			121	///<请求的设备不在线	
#define ERROR_PLATFORM_CLIENT_REQUEST_REFUSED_TO_PROTECT_PU	122	///<为了保护设备，拒绝请求	
#define ERROR_PLATFORM_CLIENT_REQUEST_PU_LIMIT_REACHED		123	///<设备达到链接的客户端上限	
#define ERROR_PLATFORM_CLIENT_TEARDOWN_PU_CONNECTION			124	///<要求客户端断开与设备连接	
#define ERROR_PU_REFUSE_CLIENT_CONNECTION					125	///<设备拒绝平台发送的客户端连接请求	
#define ERROR_PLATFORM_CLIENT_VERIFY_AUTH_ERROR				126  ///<CAS向验证中心验证用户权限失败
#define ERROR_PLATFORM_CLIENT_REQUEST_PU_OPEN_PRIVACY		127 ///<设备开启隐私保护
#define ERROR_PLATFORM_CLIENT_NO_SIGN_RELEATED		128  ///<没有关联特征码


#define ERROR_DEFENCE_TYPE_UNSUPPORTED				131	///<不支持的布撤防类型	
#define	ERROR_DEFENCE_TYPE_FAILED					132 ///<布撤防失败
#define ERROR_DEFENCE_TYPE_FORCE_FAILED				133 ///<强制布撤防失败
#define ERROR_DEFENCE_TYPE_NEED_FORCE				134 ///<需要强制布撤防


//云存储
#define  ERROR_CLOUD_NOT_FOUND				141 ///<没有找到云存储服务器
#define  ERROR_CLOUD_NO_USER				142 ///<用户未开通云存储
#define  ERROR_CLOUD_FILE_TAIL_REACHED		145 ///<文件已到结尾
#define  ERROR_CLOUD_INVALID_SESSION		146 ///<无效的session
#define  ERROR_CLOUD_INVALID_HANDLE			147 ///<无效的文件
#define  ERROR_CLOUD_UNKNOWN_CLOUD			148 ///<未知的云存储类型
#define  ERROR_CLOUD_UNSUPPORT_FILETYPE		149 ///<不支持的文件类型
#define  ERROR_CLOUD_INVALID_FILE			150 ///<无效的文件
#define  ERROR_CLOUD_QUOTA_IS_FULL			151 ///<配额已满
#define  ERROR_CLOUD_FILE_IS_FULL			152 ///<文件已满

#define ERROR_UPGRADE_PU_UPGRADE_PU_PLAN_STATE		154 ///<布防状态，不允许升级
#define ERROR_UPGRADE_PU_UPGRAD_PLATFORM_DISMATCH	155	///<软件升级平台不匹配
#define ERROR_UPGRADE_PU_UPGRAD_SPACE_DISMATCH		156	///<软件升级空间不匹配
#define ERROR_UPGRADE_PU_UPGRAD_MEM_DISMATCH		157	///<软件升级内存不匹配
#define ERROR_UPGRADE_PU_UPGRAD_MAJORTYPE_DISMATCH	158	///<软件升级主类型不匹配
#define ERROR_UPGRADE_PU_UPGRAD_MINORTYPE_DISMATCH	159	///<软件升级次类型不匹配
#define ERROR_UPGRADE_PU_UPGRAD_FILE_NUMS_INVALID	160	///<文件个数值无效
#define ERROR_UPGRADE_PU_UPGRAD_PACK_LEN_INVALID	161	///<升级包长度值无效
#define ERROR_UPGRADE_PU_UPGRAD_CHECKSUM_ERR		162	///<软件升级校验和错误
#define ERROR_UPGRADE_PU_UPGRADE_FRONT_FAIL			163	///<升级前端数据摄像机失败
#define ERROR_UPGRADE_PU_NO_RESOURCE				164	///<没有资源
#define ERROR_UPGRADE_PU_OPER_NOPERMIT				165	///<没有权限
#define ERROR_UPGRADE_PU_REBOOTING					166	///<正在重启
#define ERROR_UPGRADE_PU_NO_MEMORY					167	///<没有内存
#define ERROR_UPGRADE_PU_PARAM_ERR					168	///<参数错误
#define ERROR_UPGRADE_PU_HEAD_DATA_ERR				169	///<升级包头部数据错误

#define ERROR_UPGRADE_PU_DOWNLOAD_FAILED					170	///<下载失败	
#define ERROR_UPGRADE_PU_DOWNLOAD_PATH_ERR					171	///<路径或文件名错误	
#define ERROR_UPGRADE_PU_DOWNLOAD_PARAM_ERR					172	///<下载参数错误	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_ESTCMD_ERR			173	///<ftp建立命令出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_CMD_FAILED			174	///<ftp执行命令失败	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_CONNINIT_FAILED		175	///<ftp连接初始化失败	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_TRANS_ABORT			176	///<ftp异常中断	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_SELECT_ERR			177	///<ftp select出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_GET_DATA_SOCK_ERR		178	///<ftp获取数据套接字出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_RECV_ERR				179	///<ftp接收数据出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_BUFF_ERR				180	///<ftp缓冲区出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FILE_CHECK_ERR			181	///<下载文件校验失败	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_CONN_ERR				182	///<ftp 连接出错	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_LOGIN_FAILED			183	///<ftp 登陆失败	
#define ERROR_UPGRADE_PU_DOWNLOAD_FTP_GET_FILEINFO_FAILED	184	///<ftp 获取文件信息失败	


#define  ERROR_CAPTURE_PIC_LOCAL_FAILED				186 ///<设备本地抓图失败
#define  ERROR_CAPTURE_PIC_APPLY_CACHE_FAILED		187 ///<图片缓存申请失败
#define  ERROR_CAPTURE_PIC_PARSE_PMS_DOMAIN_FAILED	188 ///<PMS域名解析错误
#define  ERROR_CAPTURE_PIC_CONNECT_PMS_FAILED		189 ///<PMS连接失败
#define  ERROR_CAPTURE_PIC_CREATE_PMS_PACKET_FAILED	190 ///<创建PMS报文错误
#define  ERROR_CAPTURE_PIC_SEND_PMS_FAILED			191 ///<PMS发送数据错误
#define  ERROR_CAPTURE_PIC_RECV_PMS_FAILED			192 ///<PMS接收数据错误
#define  ERROR_CAPTURE_PIC_PARSE_PMS_RESPONSE_FAILED 193 ///<PMS应答报文解析错误
#define  ERROR_CAPTURE_PIC_GET_URL_FAILED			194 ///<获取URL失败


#define CLIENT_ERROR_BASE				200  ///<客户端错误号
#define CLIENT_ERROR_PARAMETER			201  ///<参数错误
#define CLIENT_ERROR_ALLOC_RESOURCE		202  ///<分配资源失败
#define CLIENT_ERROR_SEND_FAILED		203  ///<发送错误
#define CLIENT_ERROR_RECV_FAILED		204  ///<接收错误, 对方断开连接所致
#define CLIENT_ERROR_PARSE_XML			205  ///<解析报文错误
#define CLIENT_ERROR_CREATE_XML			206  ///<生成报文错误
#define CLIENT_ERROR_INIT_SOCKET		207  ///<初始化socket失败
#define CLIENT_ERROR_CREATE_SOCKET		208  ///<创建socket失败
#define CLIENT_ERROR_CONNECT_FAILED		209  ///<连接服务器或设备失败，可能的原因：网络不通、IP或端口错误
#define CLIENT_ERROR_NO_INIT			210  ///<libCASClient.dll没有初始化
#define CLIENT_ERROR_OVER_MAX_SESSION	211  ///<超过CASCLIENT库支持的最大数
#define CLIENT_ERROR_SENDTIMEOUT		212  ///<信令发送超时
#define CLIENT_ERROR_RECV_TIMEOUT		213  ///<信令接收超时，超时时间内信令没有回应
#define CLIENT_ERROR_CREATE_PACKET		214  ///<生成数据包错误
#define CLIENT_ERROR_PARSE_PACKET		215  ///<解析数据包错误
#define CLIENT_ERROR_FORCE_STOP			216	 ///<用户中途强行退出
#define CLIENT_ERROR_GETPORT_FAILED		217	 ///<获取本地端口错误
#define CLIENT_ERROR_BASE64_ENCODE		218	 ///<base64编码出错
#define CLIENT_ERROR_BASE64_DECODE		219  ///<base64解码出错
#define CLIENT_ERROR_RECV_DATAERROR		220  ///<接收数据错误
#define CLIENT_ERROR_AES_ENCRYPT_FAILED	221  ///<AES加密出错
#define CLIENT_ERROR_AES_DECRYPT_FAILED	222  ///<AES解密出错
#define CLIENT_ERROR_OPERATION_UNSUPPORTED		223  ///<不支持的操作
#define CLIENT_ERROR_P2P_FAILED			224  ///<p2p打洞失败
#define CLIENT_ERROR_SEND_KEEPLIVE_FAILED		225 ///<发送打洞包失败
#define CLIENT_ERROR_USER_FORCED_ABORT	226  ///<用户强制中止取流过程
#define CLIENT_ERROR_BUF_OVER			227  ///<缓冲区满
#define CLIENT_ERROR_INIT_SSL			228  ///<初始化ssl失败
#define CLIENT_ERROR_CONNECT_SSL        229  ///<ssl连接失败
#define CLIENT_ERROR_NOSUPPORT_DIRECT2DEV      230  ///<不支持直连设备命令


#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_OTHER_ERROR				249	///<认证的其他错误			
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_DB_ERROR				250	///<认证的数据库错误
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_PARAMS_ERROR			251	///<认证的参数错误
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_EXEC_ERROR				252	///<认证的执行异常
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_SESSION_ERROR			253	///<认证的session不正常
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_CACHE_ERROR				254	///<认证的缓存异常
#define CLIENT_ERROR_PLATFORM_CLIENT_VERIFY_AUTH_NONE				255	///<认证的无权限

#define CLIENT_ERROR_ASSOCIATE_ADD_IPC_NOT_IN_LAN_FAILED		    260 ///<添加的摄像机和设备不在同一局域网 
#define CLIENT_ERROR_ASSOCIATE_ADD_IPC_ASSOCIATED_OR_TIMEOUT_FAILED 261 ///<添加的摄像机被其他设备关联或超时 
#define CLIENT_ERROR_ASSOCIATE_ADD_IPC_KEY_FAILED					262 ///<添加摄像机的密码错误 
#define CLIENT_ERROR_ASSOCIATE_DEL_IPC_FAILED						263 ///<删除摄像机失败 
#define CLIENT_ERROR_ASSOCIATE_ADD_IPC_OVER_MAXNUM					264 ///<设备添加的摄像机已满

#define CLIENT_ERROR_DETECTOR_TYPE_NOT_SUPPORT						271 ///<不支持的探测器类型

#define CLIENT_ERROR_GENERAL_PU_NO_VALID_PRELINK                    290  ///<没有可用的P2P预链接资源 （需求来源：和设备实际达到4路连接的错误码混淆， 要区分开来）
#define CLIENT_ERROR_GENERAL_PU_NO_INNER_RESOURCE                   291  ///<没有可用的直连或P2P资源（需求来源：直连和P2P限制在三路， 保证一路留给萤石云流媒体， 第四路直连上来时的错误码提示）
#define CLIENT_ERROR_GENERAL_PU_NO_P2P_RESOURCE                     292  ///<没有可用的P2P资源（需求来源：海思设备，只能支持一路P2P，但是支持3路直连， 如果一路P2P后，无法再进行P2P，但是支持2路直连）
#define CLIENT_ERROR_GENERAL_PU_NO_UESR                             293  ///<设备未绑定用户
#define CLIENT_ERROR_GENERAL_TICKET_EXPIRED                         294  ///<访问凭证过期
#define CLIENT_ERROR_GENERAL_TICKET_INVALID                         295  ///<访问凭证无效
#define CLIENT_ERROR_GENERAL_NO_P2PSERVER_RESOURCE                  296  ///<无可用P2P服务
#define CLIENT_ERROR_GENERAL_PU_NOT_FOUND                           297  ///<未找到设备或设备在P2PServer上已下线
#define CLIENT_ERROR_GENERAL_DECRYPT_FAILED                         298  ///<P2P Server信令解密失败
#define CLIENT_ERROR_GENERAL_CREATE_KEY_FAILED                      299  ///<P2P Server生成秘钥失败
#define CLIENT_ERROR_GENERAL_SESSION_FREED                          306  ///<会话已释放

#define CLIENT_ERROR_CLIENT_ERROR_STOP_FAILED							333  ///< 未开始play或者dll未加载，stop失败
#define CLIENT_ERROR_CLIENT_ERROR_TRANS_METHOD						    334  ///< 传输方式错误
#define CLIENT_ERROR_CLIENT_ERROR_SENDMSG_QUIT						    335  ///< SendMsg m_quit is true
#define CLIENT_ERROR_CLIENT_ERROR_GET_RTPPORT_FAILED					336  ///< 获得视频传输端口号失败
#define CLIENT_ERROR_CLIENT_ERROR_START_HEART_THREAD_FAILED			    337  ///< 开始心跳线程失败
#define CLIENT_ERROR_CLIENT_ERROR_CREATE_STREAM_RECV_THREAD_FAILED	    338  ///< 创建码流接收线程失败
#define CLIENT_ERROR_CLIENT_ERROR_CREATE_STREAM_CHECK_THREAD_FAILED  	339  ///< 创建码流检测线程失败
#define CLIENT_ERROR_CLIENT_ERROR_WAIT_KEEPLIVE_TIMEOUT                 340  ///< 等待打洞成功超时
#define CLIENT_ERROR_CLIENT_ERROR_CREATE_UDT_SOCKET                     341  ///< 创建UDT套接字失败
#define CLIENT_ERROR_PREVIEW_P2P_NO_STREAM                              342  ///< P2P取流时发送play信令后没有收到设备流
#define CLIENT_ERROR_PREVIEW_P2P_INTERRUPT_STREAM                       343  ///< P2P取流过程中断流
#define CLIENT_ERROR_PREVIEW_REJECT_P2P_VIAUDP                          344  ///< 手机端尝试通过UDP取流时直接返回错误
#define CLIENT_ERROR_CLIENT_ERROR_CREATE_PORTMAPPING_THREAD_FAILED      345  ///< 端口映射失败
#define CLIENT_ERROR_SDK_QUERYLOCALIP_FAILED                            346  ///< 查询本地ip错误
#define CLIENT_ERROR_SDK_DEVICEMAP_ERROR                                347  ///< device map中查不到指定数据
#define CLIENT_ERROR_SDK_DATA_ERROR                                     348  ///< 数据异常
#define CLIENT_ERROR_SDK_STARTTHREAD_FAILED                             349  ///< 启动线程失败
#define CLIENT_ERROR_SDK_DEVICEADD_ERROR                                350  ///< device map中添加数据失败
#define CLIENT_ERROR_SDK_P2PCONN_NOLONGER_AVAIL                         351  ///< 客户端与设备之间的预链接已断开
#define CLIENT_ERROR_SDK_P2PV3_PROTOCOL_CREATE_FAILED                   352  ///< 生成P2PV3协议是失败
#define CLIENT_ERROR_SDK_P2PV3_SEND_SERVER_FAILED                       353  ///< 发送p2p server失败
#define CLIENT_ERROR_SDK_P2PV3_INVALID_PACKET                           354  ///< 报文信息不合法, 比方identify或者seq
#define CLIENT_ERROR_SDK_SOCKET_ERROR                                   355  ///< socket 错误
#define CLIENT_ERROR_SDK_RECV_ERROR                                     356  ///< socket 接收错误,设备主动close socket
#define CLIENT_ERROR_SDK_SEND_ERROR                                     357  ///< socket 发送错误
#define CLIENT_ERROR_SDK_TOOMANY_SYMMETRIC_PORTRESTRICT                 358  ///< 超过43打洞路数限制

#define CLIENT_ERROR_PU_KEY_VER_NOT_EQUAL                               364  ///< P2P链路的秘钥版本不一致
#define CLIENT_ERROR_PU_CMD_NOT_ENCRYPT                                 365  ///< P2P信令信息体未加密
#define CLIENT_ERROR_SDK_SERVER_SESSION_INVALID                         366  ///< 设备端交互的认证服务返回session会话无效
#define CLIENT_ERROR_SDK_SERVER_NO_AUTHORITY                            367  ///< 用户无权限访问设备
#define CLIENT_ERROR_SDK_SERVER_TOKEN_INVALID                           368  ///< Token无效或者过期
#define CLIENT_ERROR_SDK_SERVER_SHARE_INVALID                           369  ///< 分享无效或者过期
#define CLIENT_ERROR_SDK_SERVER_SHARE_LOCKED                            370  ///< 分享通道被锁定
#define CLIENT_ERROR_SDK_SERVER_SHARE_NO_AUTHORITY                      371  ///< 分享通道无此权限
#define CLIENT_ERROR_SDK_P2PSERVER_KEY_INVALID                          372  ///< P2PServer Key不合法
#define CLIENT_ERROR_SDK_P2PLINK_KEY_INVALID                            373  ///< P2PLink Key不合法
#define CLIENT_ERROR_SDK_P2PSERVER_PROTOC_HEADER_INVALID                374  ///< P2PServer协议头不合法
#define CLIENT_ERROR_SDK_P2PSERVER_PARSER_FAILED                        375  ///< P2PServer协议体解析失败
#define CLIENT_ERROR_SDK_P2PSERVER_DECRYPT_FAILED	                    376  ///< P2PServer AES解密出错
#define CLIENT_ERROR_SDK_P2PLINK_DECRYPT_FAILED	                        377  ///< P2PLink AES解密出错
#define CLIENT_ERROR_SDK_P2PSERVER_PROTOC_LEN_INVALID                   378  ///< P2PServer协议长度不合法
#define CLIENT_ERROR_SDK_P2PSERVER_PROTOC_CHECKCODE_FAILED              379  ///< P2PServer协议校验不通过
#define CLIENT_ERROR_SDK_PU_CMD_DECRYPT_FAILED                          380  ///< 设备解密信令失败
#define CLIENT_ERROR_SDK_DEVP2P_PLAY_NO_RESOURCE                        381  ///< devp2p返回没有可用资源
#define CLIENT_ERROR_SDK_SESSION_KEY_CREATE_FAILED                      382  ///< 生成sessionkey失败
#define CLIENT_ERROR_SDK_ECDH_ENCYPT_FAILED                             383  ///< ecdh加密失败
#define CLIENT_ERROR_SDK_ECDH_WAIT_TIMEOUT                              384  ///< 等待ECDH Req超时


#define CLIENT_ERROR_PREVIEW_NOW_IN_PRESTREAM_FAILED                    391 ///<设备已经在预取流，不再支持预取流
#define CLIENT_ERROR_PREVIEW_BREAKOFF_PRESTREAM_FAILED                  392 ///<设备触发另一路取流，断开前一路的预取流
#define CLIENT_ERROR_PREVIEW_P2P_NOT_FOUND   				            393 ///<P2P取流通道不存在
#define CLIENT_ERROR_CHANNEL_NO_MATCH                                   397 ///<通道未关联
#define CLIENT_ERROR_CHANNEL_MATCH_NOT_ONLINE                           398 ///<通道关联设备不在线

		
// 增加的云存储错误码
#define  ERROR_CLOUD_DBA_IS_DEAD                                        413 ///<dba或数据库连接错误
#define  ERROR_CLOUD_LMFILE_IS_FULL                                     414 ///<留言文件已满
#define  ERROR_CLOUD_LMFILE_IS_EXIST                                    415 ///<留言文件已存在
#define  ERROR_CLOUD_LMFILE_FILE_NAME_ERROR                             416 ///<文件名格式错误
#define  ERROR_CLOUD_LMFILE_NO_PERM                                     417 ///<无权限访问该文件
#define  ERROR_CLOUD_GET_SEGMENT_FAIL                                   418 ///<获取文件失败
#define  ERROR_CLOUD_SEGMENT_NO_EXIST                                   419 ///<文件不存在
#define  ERROR_CLOUD_DOWNLOAD_FAIL                                      420 ///<下载文件失败
#define  ERROR_CLOUD_NO_RESPONSE                                        421 ///<未收到Manager回应
#define  ERROR_CLOUD_INVALID_TICKET                                     422 ///<ticket失效
#define  ERROR_CLOUD_PAUSE_TIMEOUT                                      423 ///<暂停超时
#define  ERROR_CLOUD_CLIENT_PARAMS_ERROR                                424 ///<客户端参数错误（比如storage_version、video_type）
#define  ERROR_CLOUD_METADATA_NO_EXIST                                  425 ///<云存储元数据不存在



#define ERROR_PTZ_CONTROL_CALLING_PRESERT_FAILED                450	//0x00140000//正在调用预置点，键控动作无效;
#define ERROR_PTZ_CONTROL_TIMEOUT_SOUND_LACALIZATION_FAILED     451	//0x00140001//键控动作超时(当前正在声源定位)
#define ERROR_PTZ_CONTROL_TIMEOUT_CRUISE_TRACK_FAILED           452	//0x00140002//键控动作超时(当前正在轨迹巡航)
#define ERROR_PTZ_PRESET_INVALID_POSITION_FAILED                453	//0x00140003//当前预置点信息无效
#define ERROR_PTZ_PRESET_CURRENT_POSITION_FAILED                454	//0x00140004//该预置点已是当前位置
#define ERROR_PTZ_PRESET_SOUND_LOCALIZATION_FAILED              455	//0x00140005//开启声源定位，不允许调用预置点
#define ERROR_PTZ_PRESET_PRESETING_FAILED                       456	//0x00140006//当前正在调用预置点
#define ERROR_PTZ_OPENING_PRIVACY_FAILED                        457	//0x00140007//当前正在开启隐私遮蔽
#define ERROR_PTZ_CLOSING_PRIVACY_FAILED                        458	//0x00140008//当前正在关闭隐私遮蔽
#define ERROR_PTZ_FAILED                                        459	//0x00140009//云台当前操作失败
#define ERROR_PTZ_PRESET_EXCEED_MAXNUM_FAILED                   460	//0x0014000A//当前预置点超过最大个数
#define ERROR_PTZ_PRESET_PRIVACYING_FAILED                      461	//0x0014000B//设备处于隐私遮蔽状态（关闭了镜头，再去操作云台相关）
#define ERROR_PTZ_PRESET_MIRRORING_FAILED                       462	//0x0014000C//设备正在镜像操作（设备镜像要几秒钟，防止频繁镜像操作
#define ERROR_PTZ_PRESET_CONTROLING_FAILED                      463	//0x0014000D//设备正在键控动作（上下左右）
#define ERROR_PTZ_PRESET_TTSING_FAILED                          464	//0x0014000E//设备处于语音对讲状态(区别以前的语音对讲错误码，云台单独列一个）
#define ERROR_PTZ_ROTATION_UP_LIMIT_FAILED                      515 //0X0014000F //设备云台旋转到达上限位
#define ERROR_PTZ_ROTATION_DOWN_LIMIT_FAILED                    516 //0X00140010 //设备云台旋转到达下限位
#define ERROR_PTZ_ROTATION_LEFT_LIMIT_FAILED                    517 //0X00140011 //设备云台旋转到达左限位
#define ERROR_PTZ_ROTATION_RIGHT_LIMIT_FAILED                   518 //0X00140012 //设备云台旋转到达右限位

#define ERROR_PREVIEW_CHANNEL_NOT_EXIST                         566 //0XD3100024 请求通道号不在NVR的有效范围内
#define ERROR_PREVIEW_CHANNEL_NOT_RELATED                       567 //0XD3100025 当前通道未关联前端设备
#define ERROR_PREVIEW_CHANNEL_NOT_ONLINE                        568 //0XD3100026 当前通道未关联前端设备不在线
#define ERROR_PREVIEW_STREAM_INDEX_NOT_SUPPORT                  569 //0XD3100027 当前请求的码流类型不支持
#define ERROR_P2P_SERVER_NEED_REDIRECTION                       576 //0X0000012E //P2P SERVER需要重定向

#define CLIENT_ERROR_RELAY_PARAMS_INVALID                       648 ///< Relay服务器返回的参数不合法
#define CLIENT_ERROR_RELAY_SERVER_PROTO                         649 ///< Relay服务器返回协议格式不对
#define CLIENT_ERROR_RELAY_SERVER_REDIRECT                      650 ///< Relay服务器返回重定向
#define CLIENT_ERROR_RELAY_SERVER_NO_PERMISSION                 651 ///< Relay服务器返回无权限
#define CLIENT_ERROR_RELAY_SERVER_PARSE_PROTOCOL_FAIL           652 ///< Relay服务器协议解析失败
#define CLIENT_ERROR_RELAY_SERVER_DISCONNECT                    653 ///< Relay服务器返回链路异常断开
#define CLIENT_ERROR_RELAY_SERVER_STREAMID_REPEAT               654 ///< Relay服务器返回链路错误
#define CLIENT_ERROR_RELAY_SERVER_CLIENT_DISCONNECT             655 ///< Relay服务器返回客户端已经断开
#define CLIENT_ERROR_RELAY_TRANSFER_INSTANCE_CREATE_FAILRD      656 ///< Relay服务器返回透传对象SpgwAuthTransfer构造失败
#define CLIENT_ERROR_RELAY_ERR_DEV_NOT_ONLINE                   657 ///< 设备不在线             
#define CLIENT_ERROR_RELAY_ERR_CAS_TIME_OUT                     658 ///< 流媒体向设备发送或接受信令超时/cas响应超时
#define CLIENT_ERROR_RELAY_ERR_CAS_FORMAT_ERROR                 659 ///< cas信令返回格式错误
#define CLIENT_ERROR_RELAY_ERR_SPGW_TIME_OUT                    660 ///< SPGW请求Cas、Status透传超时
#define CLIENT_ERROR_RELAY_ERR_DEV_PARAMS_ERROR                 661 ///< 设备返回参数错误
#define CLIENT_ERROR_RELAY_ERR_DEV_PARSE_FAILED                 662 ///< 设备返回报文解析失败
#define CLIENT_ERROR_RELAY_ERR_DEV_SYSTEM_ERROR                 663 ///< 设备返回系统内部错误
#define CLIENT_ERROR_RELAY_ERR_DEV_TICKET_INVALID_FAIL          664 ///< 设备端Ticket失效
#define CLIENT_ERROR_RELAY_ERR_DEV_TICKET_BASE64DECODE_FAILRD   665 ///< 设备端Ticket base64解密失败
#define CLIENT_ERROR_RELAY_ERR_RPC_NO_RESOURCE                  666 ///< RPC 无可用资源 网络/内存等 对应RPC返回错误码6001-6011 6020-6025
#define CLIENT_ERROR_RELAY_ERR_RPC_ZOOKEEPER_ERROR              667 ///< RPC Zookeeper错误 对应RPC返回错误码6012-6018
#define CLIENT_ERROR_RELAY_ERR_RPC_NO_AVAILABLE_INSTANCE        668 ///< RPC 没有可用的服务实例 对应RPC返回错误码6019
#define CLIENT_ERROR_RELAY_ERR_RPC_NET_CREAT_SSL_ERROR          669 ///< RPC 创建SSL证书上下文失败 对应RPC返回错误码6026   
#define CLIENT_ERROR_RELAY_HEARTBEAT_TIMEOUT                    670 ///< Relay心跳超时

#define CLIENT_ERROR_PREVIEW_P2P_LARGER_MAX_UDP_PACK_LEN		960  //P2P取流时，接收到的包大于1600字节（大于1600的包会被扔掉，ConvertErrorId中该错误码不需转换）

#define CLIENT_ERROR_UNKNOW				999  ///<未知错误

/** @} */ //libCASClinet_Error end

/**
 * @defgroup libCASClinet库子错误码定义
 * 调用CASClient_GetLastDetailError获取的细子错误码
 * @{
 */
#define CREATESOCKET_ERROR				1	///<创建socket出错
#define INITSOCKET_ERROR				2	///<初始化socket错误
#define BINDSOCKET_ERROR				3	///<bind socket 错误
#define CONNECTWITHTIMEOUT_ERROR		4	///<连接出错
#define SEND_ERROR                      5   ///<发送出错
#define RECV_ERROR                      6	///<接收出错
#define RECV_WITH_TIMEOUT_ERROR			7   ///<接收超时
#define SELECT_ERROR 					8	///<Select出错
#define FDISSET_ERROR 					9	///<FDISSET出错

#define SSL_CTX_NEW_ERROR				51	///<ssl_ctx创建出错
#define SSL_NEW_ERROR					52	///<ssl创建出错
#define SSL_SET_FD_ERROR				53	///<ssl关联socket出错
#define SSL_CONNECT_ERROR				54	///<ssl连接出错
#define SSL_WRITE_ERROR					55	///<ssl发送出错
#define SSL_READ_ERROR					56	///<ssl接收出错

#define SYS_ALLOC_RESOURCE_ERROR		20  //new对象失败
#define SYS_CREATE_FILE_ERROR			21 	//创建文件失败
#define SYS_DLL_NOT_INIT_ERROR          22  //dll没有初始化
/** @} */ //libCASClinet_Error end

#define UDT_CREATE_ERROR 30
#define UDT_BIND_ERROR   31
#define UDT_LISTEN_ERROR 32
#define UDT_ACCPET_ERROR 33
#define UDT_RECV_ERROR   34

#endif ///< __LIBCASCLIENT_ERROR_H__
