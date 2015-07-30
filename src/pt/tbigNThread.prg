#include "tBigNumber.ch"
#include "tBigNThread.ch"

#define IPC_TIMEOUT ((3600000*24)*2)

static s__oGlbVars
static s__oOutMessage

Class tBigNThread
    
    data aThreads
    
    data cEnvSrv
    data cGlbResult

    data bOnStartJob
    data bOnFinishJob
    
    data bAfterJobStart
    
    data nThreads
    data nTimeOut

    data nOutPutMsg
    data lOutPutMsg
    
    data cMtxJob
    
    data nSleep
    
    method function New() CONSTRUCTOR /*(/!\)*/
    
    method procedure Start(nThreads)
    
    method procedure Notify()
    method procedure Wait(nSleep)
    method procedure Join()
    method procedure Finalize()
    
    method function setEvent(nThEvent,uThEvent)

    method function getResult(nThEvent)
    method function getGlbResult(nThEvent)
    method function getAllResults()
    
    method procedure sendGlbVarResult()
    
EndClass

user function tBigNThread()
return(tBigNThread():New())

method function new() class tBigNThread
    self:aThreads:=Array(0)
    self:cEnvSrv:=GetEnvServer()
    self:cMtxJob:=MutexCreate()
    self:nThreads:=0
    self:nSleep:=10
    self:nTimeOut:=IPC_TIMEOUT
    self:nOutPutMsg:=0
return(self)

method procedure Start(nThreads) class tBigNThread
    local cMTXID  AS CHARACTER 
    local nStart  AS NUMBER
    local nSleep  AS NUMBER    VALUE self:nSleep
    local nThread AS NUMBER
    PARAMTYPE nThreads AS NUMBER DEFAULT self:nThreads
    self:lOutPutMsg:=.not.(Empty(self:nOutPutMsg))
    if ((nThreads>self:nThreads).or.(self:nThreads==0))
        if (self:nThreads==0)
            ASSIGN nStart:=1
        else
            ASSIGN nStart:=(self:nThreads+(nThreads-self:nThreads))
        endif
        while (nThreads>0)
            aAdd(self:aThreads,Array(SIZ_TH))
            ++self:nThreads
            --nThreads
        end while
    else
        ASSIGN nStart:=1
    endif
    xPutGlbValue(self:cMtxJob,"1")
    nThreads:=self:nThreads    
    for nThread:=nStart to nThreads
        ASSIGN cMTXID:=MutexCreate()
        self:aThreads[nThread][TH_MTX]:=cMTXID
        self:aThreads[nThread][TH_EXE]:=NIL
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:="0"
        self:aThreads[nThread][TH_NUM]:=ThreadID()
        if (IPCCount(self:cMtxJob)<((self:nThreads-nThread)+1))
            StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:cMtxJob,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
            if (valType(self:bAfterJobStart)=="B")
                Eval(bAfterJobStart)
            endif
            Sleep(self:nSleep)
        endif
        xPutGlbValue(cMTXID,"1")
        xPutGlbValue(cMTXID+"TH_RES","")
        xPutGlbValue(cMTXID+"TH_END","0")
    next nThread
return

method procedure Notify() class tBigNThread
    local cMTXID  AS CHARACTER
    local nATT    AS NUMBER
    local nThread AS NUMBER
    for nThread:=1 to self:nThreads
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:="0"
        xPutGlbValue(cMTXID+"TH_RES","")
        xPutGlbValue(cMTXID+"TH_END","0")
        nATT:=0
        if ((xGetGlbValue(self:cMtxJob)=="1").and.(xGetGlbValue(cMTXID)=="1"))
            nATT:=0
            while .not.(IPCGo(self:cMtxJob,self:aThreads[nThread]))
                if (++nATT>10)
                    xPutGlbValue(cMTXID+"TH_RES","E_R_R_O_R_")
                    xPutGlbValue(cMTXID+"TH_END","1")
                    xGetGlbValue(cMTXID,"0")                    
                    exit
                endif
                sleep(self:nSleep)
                if (IPCCount(self:cMtxJob)<((self:nThreads-nThread)+1))
                    StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:cMtxJob,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
                    if (valType(self:bAfterJobStart)=="B")
                        Eval(bAfterJobStart)
                    endif
                    Sleep(self:nSleep)
                endif
            end While
        endif
    next nThread
return

method procedure Wait(nSleep) class tBigNThread
    local cMTXID   AS CHARACTER
    local cTOut AS CHARACTER VALUE SetTimeOut("0")
    local nThread  AS NUMBER
    local nThreads AS NUMBER VALUE self:nThreads
    local nThCount AS NUMBER
    local xResult  AS UNDEFINED
    PARAMTYPE nSleep AS NUMBER OPTIONAL DEFAULT self:nSleep
    while .not.(KillApp())
        for nThread:=1 to nThreads
            ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
            if (xGetGlbValue(self:cMtxJob)=="1").and.(xGetGlbValue(cMTXID)=="1")
                if (self:aThreads[nThread][TH_END]=="1")
                    if (self:aThreads[nThread][TH_RES]==NIL)
                        xResult:=xGetGlbValue(cMTXID+"TH_RES")
                        if (valType(xResult)=="C")
                            if (xResult=="E_R_R_O_R_")
                                self:aThreads[nThread][TH_ERR]:="1"
                                xResult:=NIL
                            endif
                        endif
                        self:aThreads[nThread][TH_RES]:=xResult
                    endif
                    if (self:aThreads[nThread][TH_GLB]==NIL)
                        xResult:=getGlbVarResult(cMTXID+"TH_GLB")
                        self:aThreads[nThread][TH_GLB]:=xResult
                    endif
                    ++nThCount
                else
                    self:aThreads[nThread][TH_END]:=xGetGlbValue(cMTXID+"TH_END")
                endif
            else
                xPutGlbValue(cMTXID+"TH_END","1")
                self:aThreads[nThread][TH_END]:="1"
                if (self:aThreads[nThread][TH_RES]==NIL)
                    if .not.(self:aThreads[nThread][TH_ERR]=="1")
                        xResult:=xGetGlbValue(cMTXID+"TH_RES")
                        if (valType(xResult)=="C")
                            if (xResult=="E_R_R_O_R_")
                                self:aThreads[nThread][TH_ERR]:="1"
                                xResult:=NIL
                            endif
                        endif
                        self:aThreads[nThread][TH_RES]:=xResult
                    endif
                endif
                if (self:aThreads[nThread][TH_GLB]==NIL)
                    if .not.(self:aThreads[nThread][TH_ERR]=="1")
                        xResult:=getGlbVarResult(cMTXID+"TH_GLB")
                        self:aThreads[nThread][TH_GLB]:=xResult
                    endif
                endif
                xPutGlbValue(cMTXID+"TH_END","1")
                ++nThCount
            endif
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        ASSIGN nThCount:=0
        Sleep(nSleep)
    end while
    SetTimeOut(cTOut)
return

method procedure Join() class tBigNThread
    local cMTXID  AS CHARACTER 
    local nThread AS NUMBER
    xPutGlbValue(self:cMtxJob,"0")
    for nThread:=1 to self:nThreads
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        xPutGlbValue(cMTXID,"0")
        self:aThreads[nThread][TH_EXE]:="'E_X_I_T_'"
        IPCGo(self:cMtxJob,self:aThreads[nThread])
        Sleep(self:nSleep)
    next nTread
    self:sendGlbVarResult()
return

method procedure Finalize() class tBigNThread
    local cMTXID  AS CHARACTER
    local nThread AS NUMBER
    xClearGlbValue(self:cMtxJob)
    for nThread:=1 to self:nThreads
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        xClearGlbValue(cMTXID)
        xClearGlbValue(cMTXID+"TH_NUM")
        xClearGlbValue(cMTXID+"TH_EXE")
        xClearGlbValue(cMTXID+"TH_RES")
        xClearGlbValue(cMTXID+"TH_END")
        xClearGlbValue(cMTXID+"TH_ERR")
        xClearGlbValue(cMTXID+"TH_MSG")
        xClearGlbValue(cMTXID+"TH_STK")
        xClearGlbValue(cMTXID+"TH_GLB")
    next nTread
    self:nThreads:=0
    aSize(self:aThreads,0)
    self:aThreads:=NIL
    self:=FreeObj(self)
return

method function setEvent(nThEvent,uThEvent) class tBigNThread
    local uLEvent AS UNDEFINED
    PARAMTYPE 1 VAR nThEvent AS NUMBER
    PARAMTYPE 2 VAR uThEvent AS UNDEFINED
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        ASSIGN uLEvent:=self:aThreads[nThEvent][TH_EXE]
        self:aThreads[nThEvent][TH_EXE]:=uThEvent
    endif
return(uLEvent)

method function getResult(nThEvent) class tBigNThread
    local uResult AS UNDEFINED
    PARAMTYPE 1 VAR nThEvent AS NUMBER
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        ASSIGN uResult:=self:aThreads[nThEvent][TH_RES]
        self:aThreads[nThEvent][TH_RES]:=NIL
    endif
return(uResult)

method function getGlbResult(nThEvent) class tBigNThread
    local uResult AS UNDEFINED
    PARAMTYPE 1 VAR nThEvent AS NUMBER
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        ASSIGN uResult:=self:aThreads[nThEvent][TH_GLB]
        self:aThreads[nThEvent][TH_GLB]:=NIL
    endif
return(uResult)

method function getAllResults() class tBigNThread
    local aResults   AS ARRAY
    local aGLBReults AS ARRAY
    local nThread
    for nThread:=1 to self:nThreads
        if .not.(self:aThreads[nThread][TH_RES]==NIL)
            aAdd(aResults,self:getResult(nThread))        
        endif
        if .not.(self:aThreads[nThread][TH_GLB]==NIL)
            aGLBReults:=self:getGlbResult(nThread)
            aEval(aGLBReults,{|r|aAdd(aResults,r)})       
        endif
    next nResult
return(aResults)

method procedure sendGlbVarResult() class tBigNThread
    local aResults AS ARRAY
    if .not.(self:cGlbResult==NIL)
        ASSIGN aResults:=self:getAllResults()
        sendGlbVarResult(self:cGlbResult,aResults)
    endif
return

user procedure bigNthRun(mtxJob,nTimeOut,bOnStartJob,bOnFinishJob)
    local cMTX  AS CHARACTER
    local cTyp  AS CHARACTER
    local cTOut AS CHARACTER VALUE SetTimeOut("0")
    local cFunN AS CHARACTER
    local xJob  AS UNDEFINED
    local xRes  AS UNDEFINED
    try exception using {|e|DefError(e,mtxJob)}
        PARAMTYPE 1 VAR mtxJob    AS CHARACTER
        PARAMTYPE 2 VAR nTimeOut  AS NUMBER OPTIONAL DEFAULT IPC_TIMEOUT
        PARAMTYPE 3 VAR bOnStartJob  AS UNDEFINED OPTIONAL
        PARAMTYPE 4 VAR bOnFinishJob AS UNDEFINED OPTIONAL
        ASSIGN cFunN:=ProcName()
        SetFunName(cFunN)
        OutPutInternal(cFunN)
        ASSIGN cTyp:=valType(bOnStartJob)
        do case
        case (cTyp=="A")
            ExecFromArray(bOnStartJob)
        case (cTyp=="B")
            Eval(bOnStartJob)
        case (cTyp=="C")
            &(bOnStartJob)
        end case
        while .not.(KillApp())
            if .not.(xGetGlbValue(mtxJob)=="1")
                exit
            endif
            if IPCWaitEx(mtxJob,nTimeOut,@xJob)
                ASSIGN cTyp:=valType(xJob)
                do case
                case (cTyp=="A")
                    ASSIGN cMTX:=xJob[TH_MTX]
                    ASSIGN cTyp:=valType(xJob[TH_EXE])
                    do case
                    case (cTyp=="C")
                        try exception using {|e|DefError(e,xJob)}
                            ASSIGN xRes:=&(xJob[TH_EXE])
                        end exception
                    case (cTyp=="A")
                        try exception using {|e|DefError(e,xJob)}
                            ASSIGN xRes:=ExecFromArray(xJob[TH_EXE])
                        end exception
                    otherwise
                        ASSIGN xRes:=NIL
                    end case
                    ASSIGN cTyp:=valType(xRes)
                    do case
                    case (cTyp=="A")
                        sendGlbVarResult(cMTX+"TH_GLB",{xRes})
                    case (cTyp=="C")
                        if (Upper(xRes)=="E_X_I_T_")
                            xPutGlbValue(cMTX,"0")
                        else
                            xPutGlbValue(cMTX+"TH_RES",xRes)
                        endif
                    otherwise
                        xPutGlbValue(cMTX+"TH_RES",cValToChar(xRes))
                    endcase
                    xPutGlbValue(cMTX+"TH_END","1")
                    if .not.(xGetGlbValue(mtxJob)=="1")
                        exit
                    endif
                case (cTyp=="C")
                    if (Upper(xJob)=="E_X_I_T_")
                        xPutGlbValue(mtxJob,"0")
                        exit
                    endif
                    xRes:=&(xJob)                    
                    if (valType(xRes)=="C")
                        if (Upper(xRes)=="E_X_I_T_")
                            xPutGlbValue(mtxJob,"0")
                            exit
                        endif
                    endif
                end case
            endif
        end while
        ASSIGN cTyp:=valType(bOnFinishJob)
        do case
        case (cTyp=="A")
            ExecFromArray(bOnFinishJob)
        case (cTyp=="B")
            Eval(bOnFinishJob)
        case (cTyp=="C")
            &(bOnFinishJob)
        end case
    end exception
return

static function MutexCreate()
    static s__oMutex
    DEFAULT s__oMutex:=tBigNMutex():New()
return(s__oMutex:MutexCreate())

static procedure DefError(e,xJOB)
    local cType:=valType(xJOB)
    local cMTXID:=if((cType=="A"),xJOB[TH_MTX],if((cType=="C"),xJOB,"__NOID__"))
    if .not.(cMTXID=="__NOID__")
        xPutGlbValue(cMTXID,"0")
        if (cType=="A")
            xPutGlbValue(cMTXID+"TH_RES","E_R_R_O_R_")
            xPutGlbValue(cMTXID+"TH_END","1")   
            xPutGlbValue(cMTXID+"TH_ERR","1")
            if (valType(e)=="O")
                xPutGlbValue(cMTXID+"TH_MSG",e:Description)
                xPutGlbValue(cMTXID+"TH_STK",e:ErrorStack)
            endif
        endif
    endif
    break
return

static function ExecFromArray(aExec)
    static s__oExecFromArray
    DEFAULT s__oExecFromArray:=tBigNExecFromArray():New()
return(s__oExecFromArray:ExecFromArray(@aExec))    

static function SetTimeOut(xSet)
    local cTOut
    local cType
    cType:=valType(xSet)
    IF .not.(cType$"CN")
        cTOut:=NToS(PtInternal(2,"0"))
        PtInternal(2,cTOut)
    ElseIF (cType=="N")
        cTOut:=NToS(xSet)
    Else
        cTOut:=xSet
    EndIF
Return(NToS(PtInternal(2,cTOut)))

static function xGetGlbValue(cGlbName,lGlbLock)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:GetGlbValue(@cGlbName,@lGlbLock))

static function xPutGlbValue(cGlbName,cGlbValue,lGlbLock)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:PutGlbValue(@cGlbName,@cGlbValue,@lGlbLock))    

static function xGetGbVars(cGlbName,lGlbLock)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:GetGlbVars(@cGlbName,@lGlbLock))

static function xPutGbVars(cGlbName,aGlbValues,lGlbLock)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:PutGlbVars(@cGlbName,@aGlbValues,@lGlbLock))

static function xClearGlbValue(cGlbName,lGlbLck)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:ClearGlbValue(@cGlbName,@lGlbLck))

static function getGlbVarResult(cGlbName)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:getGlbVarResult(@cGlbName))

static function sendGlbVarResult(cGlbName,xGbRes)
    DEFAULT s__oGlbVars:=tBigNGlobals():New()
return(s__oGlbVars:sendGlbVarResult(@cGlbName,@xGbRes))

static function OutPutMessage(xOutPut,nOutPut)
    DEFAULT s__oOutMessage:=tBigNMessage():New(nOutPut)
return(s__oOutMessage:OutPutMessage(xOutPut,nOutPut))

static function OutPutInternal(cOutInternal,nOutPut)
    DEFAULT s__oOutMessage:=tBigNMessage():New(nOutPut)
return(s__oOutMessage:ToInternal(cOutInternal))


#include "paramtypex.ch"
#include "tryexception.ch"
