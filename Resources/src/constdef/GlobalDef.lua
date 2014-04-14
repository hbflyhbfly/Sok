local M = {}

M.BASE_SRC_NAME = 
{
    --场景资源前缀 scene_id_layersequence
    PRE_SCENE = "scene_",
    --动画资源前缀 ani_id_actiontype_index
    PRE_ANI = "ani_",
    --帧动画粒子前缀 apl_id_index
    PRE_FRAME_PARTICAL = "apl_",
    --点粒子前缀 apt_id
    PRE_POINT_PARTICAL = "plt_",
    --UI元素资源前缀 ui_id_name_index
    PRE_UI = "ui_",

    SUFFIX_PNG = "_png",
    SUFFIX_PVER = "_pvr",
    SUFFIX_PLIST = "_plist" 
}


M.ACTION_TYPE = 
{
    STAND = 0,                          --站立
    JUMP = 1,                           --跳跃
    FLY = 8,                            --飞行
    ATTACK = 16,                        --攻击
    MOUNT = 32,                         --坐骑
    SPECIAL_EFFECT1 = 64,               --可能是降龙十八掌等特效动画
    SPECIAL_EFFECT2 = 128
}


M.OS_TYPE = 
{
    UNKNOWN = 0,        --未知
    IOS = 1,
    ANDROID = 2,
    WP = 3,
    SYMBIAN = 4,
    WINDOWS = 5,        --windows phone
    OSX = 6,
    LINUX = 7
}

M.NETWORK_TYPE = 
{
    UNKNOWN = 0,        --未知
    WIFI = 1,
    N3G = 2,            --3G
    GPRS = 3,
    LTE = 4,
}


M.CONST_DEF = 
{
    DEVICE_CODE_LEN = 128,              --机器码最大长度
    DEVICE_TYPE_LEN = 64,               --机器类型最大长度
    DEVICE_OS_INFO = 64,                --机器os信息
    DEVICE_TOKEN_LEN = 32,
    DEVICE_DETIAL_INFO_LEN = 512,       --机器信息最大长度
    USER_EXT_DESC_LEN = 128,            --扩展信息描述长度

    --用户信息
    URL_LEN = 256,                      --url  
    MD5_LEN = 32,                       --md5值
    PASSPORT_NAME_LEN = 50,             --帐号名
    PASSPORT_PWD_LEN = 32,              --帐号md5密码
    VERSION_LEN = 10,                   --版本信息最大长度
    EXT_VERSION_LEN = 16,               --版本信息最大长度
    MIN_VERSION_LEN = 7,                --版本信息最小长度
    MAJOR_VERSION_LEN = 2,              --主版本长度
    MINOR_VERSION_LEN = 2,              --副版本长度
    MINI_VERSION_LEN = 3,               --子版本长度长度
    MAC_ADDR_STR_LEN = 17,              --MAC地址长度
    IP_ADDR_STR_LEN = 24,               --IP地址长度
    USER_NICK_NAME_LEN = 32,            --玩家昵称
    NICK_NAME_LEN_ALLOW_INPUT = 16,     --允许玩家输入的昵称长度
    PERSONAL_DESC_LEN = 50,             --个人描述
    TEXT_LEN = 256,                     --文本长度
    WEIBO_TOKEN_LEN = 32,               --weibotoken长度
    CITY_LEN = 64,                      --城市长度

    SECOND_IN_DAY = 24 * 60 * 60,       --一天的秒数
    SECOND_IN_HOUR = 60 * 60,           --一小时的秒数
    SECOND_IN_MINUTE = 60,              --一天的秒数
}

M.ERR_CODE_DEF =
{
    --D描述：系统错误偏移
    RET_ERRSYSTEM_BASE  =   0x10000000,
    --ID描述：服务器错误偏移
    RET_ERRLOGIC_BASE  =   0x10000001,
    --D描述：条件错误偏移
    RET_ERRCONDITION_BASE  =   0x10000002,
    --ID描述：系统逻辑错误
    RET_SYSTEM_ERROR_BASE  =   0x100000c8,
    --ID描述：数据库错误
    RET_DB_ERROR_BASE  =   0x10000190,
    --ID描述：odbc错误
    RET_ODBC_ERROR_BASE  =   0x10000258,
    --ID描述：网络错误
    RET_NET_ERROR_BASE  =   0x10000320,
    --ID描述  个人信息错
    RET_USER_INFO_BASE = 0x1300000,
    --名字错误 没办法用 RET_USER_INFO_BASE ＋ 0 之后想办法
    RET_ERR_USER_INFO_NICKNAME = 0x1300000 + 0,
}

local modename = "GlobalDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("GlobalDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy