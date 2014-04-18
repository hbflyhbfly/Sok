//
//  CCLuaHttpRequest.h
//  Sok
//
//  Created by zhoufei on 14-4-18.
//
//

#ifndef __Sok__CCLuaHttpRequest__
#define __Sok__CCLuaHttpRequest__

#include "network/HttpClient.h"
USING_NS_CC;
USING_NS_CC_EXT;

class CCLuaHttpRequest:public CCHttpRequest {
public:
    CCLuaHttpRequest();
    virtual ~CCLuaHttpRequest();
public:
    static CCLuaHttpRequest* create();
    static bool mkdirs(std::string aDir);
    void setResponseScriptCallback(unsigned int aHandler);
private:
    void responseScriptCallback(CCHttpClient* apClient,CCHttpResponse* apResponse);
private:
    unsigned int mHandler;
};
#endif /* defined(__Sok__CCLuaHttpRequest__) */
