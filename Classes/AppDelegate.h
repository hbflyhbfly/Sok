#ifndef __APP_DELEGATE_H__
#define __APP_DELEGATE_H__

#include "cocos2d.h"
#include "cocos2d.h"
#include "CCEGLView.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "CCLuaJavaBridge.h"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CCLuaObjcBridge.h"
#endif

using namespace CocosDenshion;

USING_NS_CC;

/**
@brief    The cocos2d Application.

The reason for implement as private inheritance is to hide some interface call by CCDirector.
*/
class  AppDelegate : private cocos2d::CCApplication
{
public:
    AppDelegate();
    virtual ~AppDelegate();

    /**
    @brief    Implement CCDirector and CCScene init code here.
    @return true    Initialize success, app continue.
    @return false   Initialize failed, app terminate.
    */
    virtual bool applicationDidFinishLaunching();

    /**
    @brief  The function be called when the application enter background
    @param  the pointer of the application
    */
    virtual void applicationDidEnterBackground();

    /**
    @brief  The function be called when the application enter foreground
    @param  the pointer of the application
    */
    virtual void applicationWillEnterForeground();
private:
    CCLuaEngine* pEngine;
};

#endif  // __APP_DELEGATE_H__

