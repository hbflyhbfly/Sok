//
//  CCParallaxNodeExtras.h
//  Sok
//
//  Created by zhoufei on 14-4-22.
//
//

#ifndef Cocos2DxFirstIosSample_CCParallaxNodeExtras_h 
#define Cocos2DxFirstIosSample_CCParallaxNodeExtras_h
#include "cocos2d.h"
USING_NS_CC;
class CCParallaxNodeExtras : public CCParallaxNode

{ public :
    CCParallaxNodeExtras();
    static CCParallaxNodeExtras * node() ;
    void incrementOffset(CCPoint offset,CCNode* node);
} ;
#endif