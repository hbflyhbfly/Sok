#include "AppDelegate.h"

static cocos2d::CCSize designResolutionSize = cocos2d::CCSizeMake(1024, 768);

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    CCEGLView* pEGLView = CCEGLView::sharedOpenGLView();
    pDirector->setOpenGLView(pEGLView);
    pEGLView->setDesignResolutionSize(designResolutionSize.width, designResolutionSize.height, kResolutionFixedHeight);
    // turn on display FPS
    //pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);
     // register lua engine
    pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
    

    CCLuaStack *pStack = pEngine->getLuaStack();
    lua_State *tolua_s = pStack->getLuaState();
    tolua_extensions_ccb_open(tolua_s);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    pStack = pEngine->getLuaStack();
    tolua_s = pStack->getLuaState();
    tolua_web_socket_open(tolua_s);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
    CCFileUtils::sharedFileUtils()->addSearchPath("script");
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	CCLuaJavaBridge::luaopen_luaj(tolua_s);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CCLuaObjcBridge::luaopen_luaoc(tolua_s);
#endif

    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("src/main.lua");
    pEngine->executeScriptFile(path.c_str());

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
    //暂停时保存数据
    if (pEngine) {
        std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("src/logic/InterruptBack.lua");
        pEngine->executeScriptFile(path.c_str());
    }
    
    //save data
    
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
//    CCDirector::sharedDirector()->startAnimation();
//
//    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
//    
//    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
    //取得暂停前保存的数据
    if (pEngine) {
        std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("src/logic/InterruptContinue.lua");
        pEngine->executeScriptFile(path.c_str());

    }
    

    CCScene* pRuningScene  = CCDirector::sharedDirector()->getRunningScene();
    CCNode* pNode = pRuningScene->getChildByTag(1);//TODO:模式1
    if (pNode) {
        //弹出暂停界面
        
    }
    
    pNode = pRuningScene->getChildByTag(2);       //TODO:模式2
    if (pNode) {
        //弹出暂停界面
    
    }
}
