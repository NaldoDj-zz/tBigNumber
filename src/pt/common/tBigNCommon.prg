#ifndef _pt_tBigNCommon_CH

    #define _pt_tBigNCommon_CH
    
    #include "tbignumber.ch"
    
    #define GLB_SLEEP    150
    #define GLB_ATTEMPTS 100
    #define GLB_LOCK     .T.

    static s__oMutex
    static s__oGlbVars
    static s__oOutMessage
    static s__oExecFromArray

    static function MTXObj(cMutex,cMTXKey)
        DEFAULT cMTXKey:=MTX_KEY
        DEFAULT s__oMutex:=tBigNMutex():New(@cMutex,@cMTXKey)
        if .not.(Empty(cMutex))
            s__oMutex:cMutex:=cMutex    
        endif
        if .not.(Empty(cMTXKey))
            s__oMutex:cMTXKey:=cMTXKey
        endif
    return(s__oMutex)
    
    static function MTXCreate(cMutex,cMTXKey)
        DEFAULT cMTXKey:=MTX_KEY
        DEFAULT s__oMutex:=tBigNMutex():New(@cMutex,@cMTXKey)
        if .not.(Empty(cMutex))
            s__oMutex:cMutex:=cMutex    
        endif
        if .not.(Empty(cMTXKey))
            s__oMutex:cMTXKey:=cMTXKey
        endif
    return(s__oMutex:MTXCreate(@cMTXKey))

    static function MTXHandle(cMutex,cMTXKey)
        DEFAULT cMTXKey:=MTX_KEY
        DEFAULT s__oMutex:=tBigNMutex():New(@cMutex,@cMTXKey)
        if .not.(Empty(cMutex))
            s__oMutex:cMutex:=cMutex    
        endif
        if .not.(Empty(cMTXKey))
            s__oMutex:cMTXKey:=cMTXKey
        endif
    return(s__oMutex:cHdlFile)
    
    static function xGlbLock()
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:GlbLock())

    static function xGlbUnLock()
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:GlbUnLock())

    static function xGetGlbValue(cGlbName,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:GetGlbValue(@cGlbName,@lGlbLock))

    static function xPutGlbValue(cGlbName,cGlbValue,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:PutGlbValue(@cGlbName,@cGlbValue,@lGlbLock))    

    static function xGetGbVars(cGlbName,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:GetGlbVars(@cGlbName,@lGlbLock))

    static function xPutGbVars(cGlbName,aGlbValues,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:PutGlbVars(@cGlbName,@aGlbValues,@lGlbLock))

    static function xClearGlbValue(cGlbName,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:ClearGlbValue(@cGlbName,@lGlbLock))

    static function getGlbVarResult(cGlbName,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:getGlbVarResult(@cGlbName,lGlbLock))

    static function setGlbVarResult(cGlbName,xGlbRes,lGlbLock)
        DEFAULT s__oGlbVars:=tBigNGlobals():New()
        s__oGlbVars:nSleep:=GLB_SLEEP
        s__oGlbVars:nAttempts:=GLB_ATTEMPTS
        s__oGlbVars:lGlbLock:=GLB_LOCK
    return(s__oGlbVars:setGlbVarResult(@cGlbName,@xGlbRes,lGlbLock))

    static function OutPutMessage(xOutPut,nOutPut)
        DEFAULT s__oOutMessage:=tBigNMessage():New(@nOutPut)
        if .not.(Empty(nOutPut))
            s__oOutMessage:nOutPut:=nOutPut
        endif
    return(s__oOutMessage:OutPutMessage(xOutPut,nOutPut))

    static function OutPutInternal(cOutInternal,nOutPut)
        DEFAULT s__oOutMessage:=tBigNMessage():New(nOutPut)
        if .not.(Empty(nOutPut))
            s__oOutMessage:nOutPut:=nOutPut
        endif
    return(s__oOutMessage:ToInternal(cOutInternal))

    static function ExecFromArray(aExec)
        DEFAULT s__oExecFromArray:=tBigNExecFromArray():New()
    return(s__oExecFromArray:ExecFromArray(@aExec))    

#endif
