#include "tBigNumber.ch"

/*
    class:tBigNGlobals
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNGlobals
    Sintaxe:tBigNGlobals():New() -> self
*/
Class tBigNGlobals
   
    data nSleep
    data nAttempts
    
    data lGlbLock
    
    method New() CONSTRUCTOR /*(/!\)*/
    
    method function  GlbLock(lGlbLock)
    method function  GlbUnLock(lGlbLock)
    
    method function  GetGlbValue(cGlbName,lGlbLock)
    method function  PutGlbValue(cGlbName,cGlbValue,lGlbLock)
    method function  GetGlbVars(cGlbName,lGlbLock)
    method function  PutGlbVars(cGlbName,aGlbValues,lGlbLock)
    method procedure ClearGlbValue(cGlbName,lGlbLock)

    method function  getGlbVarResult(cGlbName,lGlbLock)
    method procedure setGlbVarResult(cGlbName,xGlbRes,lGlbLock)

EndClass

user function tBigNGlobals()
return(tBigNGlobals():New())

method function New() class tBigNGlobals
    self:nSleep:=0
    self:nAttempts:=0
    self:lGlbLock:=.F.
return(self)

method function GlbLock(lGlbLock) class tBigNGlobals
    local lLock     AS LOGICAL VALUE .T.
    local nAttempt  AS NUMBER
    PARAMTYPE 1 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        while .not.(lLock:=GlbLock())
            if (++nAttempt>self:nAttempts)
                UserException("["+ProcName()+"][UNABLE TO GLOBAL LOCK]")
            endif
            if (KillApp())
                UserException("["+ProcName()+"][RECEIVED][KILLAPP]")
            endif
            Sleep(self:nSleep)
        end while
    endif
return(lLock)

method function GlbUnLock(lGlbLock) class tBigNGlobals
    local lUnLock AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        lUnLock:=GlbUnLock()
    endif
return(lUnLock)

method function GetGlbValue(cGlbName,lGlbLock) class tBigNGlobals
    local cGlbValue AS CHARACTER
    local lLock     AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN cGlbName:=("__GLB__"+cGlbName)
        ASSIGN cGlbValue:=GetGlbValue(cGlbName)        
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return(cGlbValue)

method function PutGlbValue(cGlbName,cGlbValue,lGlbLock) class tBigNGlobals
    local cLGValue AS CHARACTER
    local lLock    AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR cGlbName  AS CHARACTER
    PARAMTYPE 2 VAR cGlbValue AS CHARACTER
    PARAMTYPE 3 VAR lGlbLock  AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN cGlbName:=("__GLB__"+cGlbName)
        ASSIGN cLGValue:=self:GetGlbValue(cGlbName,lGlbLock)
        PutGlbValue(cGlbName,cGlbValue)
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return(cLGValue)

method function GetGlbVars(cGlbName,lGlbLock) class tBigNGlobals
    local aGlbValues AS ARRAY
    local lLock      AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN cGlbName:=("__GLB__"+cGlbName)    
        GetGlbVars(cGlbName,@aGlbValues)
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return(aGlbValues)

method function PutGlbVars(cGlbName,aGlbValues,lGlbLock) class tBigNGlobals
    local aLGlbValues AS ARRAY
    local lLock       AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR cGlbName   AS CHARACTER
    PARAMTYPE 2 VAR aGlbValues AS ARRAY
    PARAMTYPE 3 VAR lGlbLock   AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN cGlbName:=("__GLB__"+cGlbName)    
        ASSIGN aLGlbValues:=self:GetGlbVars(cGlbName,lGlbLock)
        PutGlbVars(cGlbName,aGlbValues)
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return(aLGlbValues)

method procedure ClearGlbValue(cGlbName,lGlbLock) class tBigNGlobals
    local lLock AS LOGICAL VALUE .T.
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock    
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN cGlbName:=("__GLB__"+cGlbName)    
        ClearGlbValue(cGlbName)
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return

method function getGlbVarResult(cGlbName,lGlbLock) class tBigNGlobals
    local aResults AS ARRAY
    local lLock    AS LOGICAL VALUE .T.
    local nResult  AS NUMBER
    local nResults AS NUMBER
    PARAMTYPE 1 VAR cGlbName AS CHARACTER
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL OPTIONAL DEFAULT self:lGlbLock
    if (lGlbLock)
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN aResults:=self:GetGlbVars(cGlbName,.F.)
        self:ClearGlbValue(cGlbName,.F.)
        ASSIGN nResults:=Len(aResults)
        while ((nResult:=aScan(aResults,{|r|(valType(r)=="C")},++nResult))>0)
            if Empty(aResults[nResult])
                aSize(aDel(aResults,nResult--),--nResults)
            endif
        end while
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return(aResults)

method procedure setGlbVarResult(cGlbName,xGlbRes,lGlbLock) class tBigNGlobals
    local aResults   AS ARRAY
    local aGlbValues AS ARRAY
    local cType      AS CHARACTER VALUE valType(xGlbRes)
    local lLock      AS LOGICAL VALUE .T.
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
        lLock:=self:GlbLock(lGlbLock)
    endif
    if (lLock)
        ASSIGN aGlbValues:=self:getGlbVarResult(cGlbName,.F.)
        aEval(aResults,{|r|aAdd(aGlbValues,r)})
        self:PutGlbVars(cGlbName,@aGlbValues,.F.)
        if (lGlbLock)
            self:GlbUnLock(lGlbLock)
        endif
    endif
return

#include "paramtypex.ch"
