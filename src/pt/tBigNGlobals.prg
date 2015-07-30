#include "tBigNumber.ch"

Class tBigNGlobals
   
    data nSleep
    data nAttempts
    
    data lGlbLock
    
    method New() CONSTRUCTOR /*(/!\)*/
    
    method function  GetGlbValue(cGlbName,lGlbLock)
    method function  PutGlbValue(cGlbName,cGlbValue,lGlbLock)
    method function  GetGlbVars(cGlbName,lGlbLock)
    method function  PutGlbVars(cGlbName,aGlbValues,lGlbLock)
    method procedure ClearGlbValue(cGlbName,lGlbLock)

    method function getGlbVarResult(cGlbName)
    method procedure sendGlbVarResult(cGlbName,xGlbRes)

EndClass

user function tBigNGlobals()
return(tBigNGlobals():New(nThreads))

method function new() class tBigNGlobals
    self:nSleep:=1
    self:nAttempts:=10
    self:lGlbLock:=.F.
return(self)

method function GetGlbValue(cGlbName,lGlbLock) class tBigNGlobals
    local cGlbValue AS CHARACTER
    local nATT      AS NUMBER
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        while .not.(GlbLock())
            if (++nATT>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
    ASSIGN cGlbValue:=GetGlbValue(cGlbName)        
    if (lGlbLock)
        GlbUnLock()
    endif
return(cGlbValue)

method function PutGlbValue(cGlbName,cGlbValue,lGlbLock) class tBigNGlobals
    local cLGValue AS CHARACTER
    local nATT     AS NUMBER
    PARAMTYPE 1 VAR cGlbName  AS CHARACTER
    PARAMTYPE 2 VAR cGlbValue AS CHARACTER
    PARAMTYPE 3 VAR lGlbLock  AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        while .not.(GlbLock())
            if (++nATT>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
    ASSIGN cLGValue:=self:GetGlbValue(cGlbName,lGlbLock)
    PutGlbValue(cGlbName,cGlbValue)
    if (lGlbLock)
        GlbUnLock()
    endif
return(cLGValue)

method function GetGlbVars(cGlbName,lGlbLock) class tBigNGlobals
    local aGlbValues AS ARRAY
    local nATT       AS NUMBER
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        while .not.(GlbLock())
            if (++nATT>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
    GetGlbVars(cGlbName,@aGlbValues)
    if (lGlbLock)
        GlbUnLock()
    endif
return(aGlbValues)

method function PutGlbVars(cGlbName,aGlbValues,lGlbLock) class tBigNGlobals
    local aLGlbValues AS ARRAY
    local nATT        AS NUMBER
    PARAMTYPE 1 VAR cGlbName   AS CHARACTER
    PARAMTYPE 2 VAR aGlbValues AS ARRAY
    PARAMTYPE 3 VAR lGlbLock   AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        while .not.(GlbLock())
            if (++nATT>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
    ASSIGN aLGlbValues:=self:GetGlbVars(cGlbName,lGlbLock)
    PutGlbVars(cGlbName,aGlbValues)
    if (lGlbLock)
        GlbUnLock()
    endif
return(aLGlbValues)

method procedure ClearGlbValue(cGlbName,lGlbLock) class tBigNGlobals
    local nATT AS NUMBER
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        while .not.(GlbLock())
            if (++nATT>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
    ClearGlbValue(cGlbName)
    if (lGlbLock)
        GlbUnLock()
    endif
return

method function getGlbVarResult(cGlbName) class tBigNGlobals
    local aResults AS ARRAY
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    ASSIGN aResults:=self:GetGlbVars(cGlbName)
    self:ClearGlbValue(cGlbName)
return(aResults)

method procedure sendGlbVarResult(cGlbName,xGlbRes) class tBigNGlobals
    local aGlbValues AS ARRAY
    local aResults   AS ARRAY
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR xGlbRes AS UNDEFINED OPTIONAL
    if .not.(valType(xGlbRes)=="A")
        aAdd(aResults,xGlbRes)
    else
        aEval(xGlbRes,{|r|aAdd(aResults,r)})
    endif
    ASSIGN aGlbValues:=self:getGlbVarResult(cGlbName)
    aEval(aResults,{|r|aAdd(aGlbValues,r)})
    self:PutGlbVars(cGlbName,@aGlbValues)
return

#include "paramtypex.ch"
