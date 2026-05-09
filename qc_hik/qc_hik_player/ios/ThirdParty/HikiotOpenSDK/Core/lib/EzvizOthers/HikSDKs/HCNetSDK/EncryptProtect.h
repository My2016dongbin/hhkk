#ifndef _ENCRYPT_PROTECT_H_
#define _ENCRYPT_PROTECT_H_

#if defined (__linux__) || defined(__APPLE__)
#define __stdcall
#endif

#ifdef __cplusplus
extern "C" {
#endif

/***********************************************************************
获取加密后的密钥
lpInBuffer:原始密钥串
dwInBufferSize:原始密钥串长度
lpOutBuffer:加密后的密钥串
dwOutBufferSize:加密后的密钥串长度
返回：0-成功,-1-失败
*************************************************************************/
int __stdcall	ENCRYPT_GetKey(const char* lpInBuffer, const int dwInBufferSize, char* lpOutBuffer, int dwOutBufferSize);

#ifdef __cplusplus
}
#endif
#endif
