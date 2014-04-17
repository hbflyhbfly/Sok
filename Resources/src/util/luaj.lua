
local luaj = {}

local platform = CCApplication:sharedApplication():getTargetPlatform()
local callStaticMethodImpl = nil
if GlobalDef.TARGET_PLATFORM.kTargetAndroid == platform then
    callStaticMethodImpl = CCLuaJavaBridge.callStaticMethod
elseif GlobalDef.TARGET_PLATFORM.kTargetIphone == platform or
    GlobalDef.TARGET_PLATFORM.kTargetIpad == platform then
    callStaticMethodImpl = CCLuaObjcBridge.callStaticMethod
end

local function checkArguments(args, sig)
    if type(args) ~= "table" then args = {} end
    if sig then return args, sig end

    sig = {"("}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            sig[#sig + 1] = "I"
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end
    sig[#sig + 1] = ")V"

    return args, table.concat(sig)
end

function luaj.callStaticMethod(className, methodName, args, sig)
    local args, sig = checkArguments(args, sig)
    --print("luaj.callStaticMethod(\"%s\",\n\t\"%s\",\n\targs,\n\t\"%s\"", className, methodName, sig)
    if GlobalDef.TARGET_PLATFORM.kTargetAndroid == platform then
        return callStaticMethodImpl(className, methodName, args, sig)
    elseif GlobalDef.TARGET_PLATFORM.kTargetIphone == platform or
        GlobalDef.TARGET_PLATFORM.kTargetIpad == platform then
        return callStaticMethodImpl(className, methodName, args)
    end
    
    return nil    
end

return luaj
