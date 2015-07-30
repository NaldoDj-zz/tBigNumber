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

    method function  getGlbVarResult(cGlbName)
    method procedure setGlbVarResult(cGlbName,xGlbRes)

EndClass

user function tBigNGlobals()
return(tBigNGlobals():New(nThreads))

method function new() class tBigNGlobals
    self:nSleep:=0
    self:nAttempts:=0
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

method function getGlbVarResult(cGlbName,lGlbLock) class tBigNGlobals
    local aResults AS ARRAY
    local nResult  AS NUMBER
    local nResults AS NUMBER
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
    ASSIGN aResults:=self:GetGlbVars(cGlbName,.F.)
    self:ClearGlbValue(cGlbName,.F.)
    ASSIGN nResults:=Len(aResults)
    while ((nResult:=aScan(aResults,{|r|(valType(r)=="C")},++nResult))>0)
        if Empty(aResults[nResult])
            aSize(aDel(aResults,nResult--),--nResults)
        endif
    end while
    if (lGlbLock)
        GlbUnLock()
    endif
return(aResults)

method procedure setGlbVarResult(cGlbName,xGlbRes,lGlbLock) class tBigNGlobals
    local cType      AS CHARACTER VALUE valType(xGlbRes)
    local aGlbValues AS ARRAY
    local aResults   AS ARRAY
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR xGlbRes  AS UNDEFINED OPTIONAL
    PARAMTYPE 3 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if .not.(cType=="A")
        if .not.(cType=="U")
            if .not.(cType=="C").or.(.not.(Empty(xGlbRes)))
                aAdd(aResults,xGlbRes)
            endif
        endif
    else
        aEval(xGlbRes,{|r|;
                            cType:=valType(r),;
                            if(.not.(cType=="U"),;
                                if(.not.(cType=="C").or.(.not.(Empty(cType))),aAdd(aResults,r),NIL),;
                                NIL;
                            );
                       };
         )
    endif
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
    ASSIGN aGlbValues:=self:getGlbVarResult(cGlbName,.F.)
    aEval(aResults,{|r|aAdd(aGlbValues,r)})
    self:PutGlbVars(cGlbName,@aGlbValues,.F.)
    if (lGlbLock)
        GlbUnLock()
    endif
return

#include "paramtypex.ch"
