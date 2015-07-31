#include "tBigNumber.ch"
#include "tBigNThread.ch"

#define IPC_TIMEOUT ((3600000*24)*2)

#define GLB_SLEEP    100
#define GLB_ATTEMPTS 50
#define GLB_LOCK     .T.

static s__oGlbVars
static s__oOutMessage

/*
    class:tBigNThread
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNThread
    Sintaxe:tBigNThread():New(oProcess) -> self
    TODO: 1 - Tratamento das Mensagens de Processamento
          3 - LockByName
          4 - Arquivo de Semaforo
          5 - Exemplos com acesso ao SGBD
          6 - etc.
*/
Class tBigNThread
    
    data aThreads
    
    data cEnvSrv
    data cGlbResult

    data bOnStartJob
    data bOnFinishJob
    
    data bAfterStartJob
    
    data nThreads
    data nTimeOut

    data nOutPutMsg
    data lOutPutMsg
    
    data lProcess
    data oProcess
    
    data cMtxJob
    
    data nSleep
    data nAttempts
    
    method function New(oProcess) CONSTRUCTOR /*(/!\)*/
    
    method procedure Start(nThreads)
    
    method procedure Notify()
    method procedure Wait(nSleep)
    method procedure Join()
    method procedure Finalize()
    
    method function setEvent(nThEvent,uThEvent)

    method function getResult(nThEvent)
    method function getGlbResult(nThEvent)

    method function getAllResults(lGlbVarResult)
    
    method function  getGlbVarResult(cGlbName,lGlbLock)
    method procedure setGlbVarResult(cGlbName,xGlbRes,lGlbLock)
    
    method function setObjProcess(oProcess) 
    
EndClass

user function tBigNThread(oProcess)
    PARAMTYPE 1 VAR oProcess AS OBJECT OPTIONAL
return(tBigNThread():New(oProcess))

method function new(oProcess) class tBigNThread
    PARAMTYPE 1 VAR oProcess AS OBJECT OPTIONAL
    self:aThreads:=Array(0)
    self:cEnvSrv:=GetEnvServer()
    self:cMtxJob:=MutexCreate()
    self:cGlbResult:=(self:cMtxJob+"GLBRESULT")
    self:nThreads:=0
    self:nSleep:=100
    self:nAttempts:=10
    self:nTimeOut:=IPC_TIMEOUT
    self:nOutPutMsg:=0
    self:setObjProcess(oProcess)
return(self)

method procedure Start(nThreads) class tBigNThread
    local cMTXID   AS CHARACTER 
    local nStart   AS NUMBER
    local nSleep   AS NUMBER VALUE self:nSleep
    local nThread  AS NUMBER
    PARAMTYPE nThreads AS NUMBER DEFAULT self:nThreads
    self:lOutPutMsg:=.not.(Empty(self:nOutPutMsg))
    if ((nThreads>self:nThreads).or.(self:nThreads==0))
        if (self:nThreads==0)
            ASSIGN nStart:=1
        else
            ASSIGN nStart:=(self:nThreads+(nThreads-self:nThreads))
        endif
        if (self:lProcess)
            self:oProcess:SetRegua2(nThreads)
        endif
        while (nThreads>0)
            aAdd(self:aThreads,Array(SIZ_TH))
            ++self:nThreads
            --nThreads
            if (self:lProcess)
                self:oProcess:IncRegua2()
            endif
        end while
    else
        ASSIGN nStart:=1
    endif
    xPutGlbValue(self:cMtxJob,"1")
    nThreads:=self:nThreads    
    if (self:lProcess)
        self:oProcess:SetRegua1(((nThreads-nStart)+1))
        self:oProcess:SetRegua2(0)
    endif
    for nThread:=nStart to nThreads
        if (self:lProcess)
            self:oProcess:IncRegua2()
        endif        
        ASSIGN cMTXID:=MutexCreate()
        self:aThreads[nThread][TH_MTX]:=cMTXID
        self:aThreads[nThread][TH_EXE]:=NIL
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:="0"
        self:aThreads[nThread][TH_NUM]:=ThreadID()
        if (IPCCount(self:cMtxJob)<((self:nThreads-nThread)+1))
            StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:cMtxJob,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
            if (valType(self:bAfterStartJob)=="B")
                Eval(bAfterStartJob)
            endif
            Sleep(self:nSleep)
        endif
        xPutGlbValue(cMTXID,"1")
        xPutGlbValue(cMTXID+"TH_RES","")
        xPutGlbValue(cMTXID+"TH_END","0")
        if (self:lProcess)
            self:oProcess:IncRegua1()
        endif        
    next nThread
return

method procedure Notify() class tBigNThread
    local cMTXID   AS CHARACTER
    local nAttempt AS NUMBER
    local nThread  AS NUMBER
    if (self:lProcess)
        self:oProcess:SetRegua1(self:nThreads)
        self:oProcess:SetRegua2(0)
    endif
    for nThread:=1 to self:nThreads
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:="0"
        xPutGlbValue(cMTXID+"TH_RES","")
        xPutGlbValue(cMTXID+"TH_END","0")
        if ((xGetGlbValue(self:cMtxJob)=="1").and.(xGetGlbValue(cMTXID)=="1"))
            while .not.(IPCGo(self:cMtxJob,self:aThreads[nThread]))
                if (++nAttempt>self:nAttempts)
                    xPutGlbValue(cMTXID+"TH_RES","E_R_R_O_R_")
                    xPutGlbValue(cMTXID+"TH_END","1")
                    xGetGlbValue(cMTXID,"0")                    
                    exit
                endif
                sleep(self:nSleep)
                if (IPCCount(self:cMtxJob)<((self:nThreads-nThread)+1))
                    StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:cMtxJob,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
                    if (valType(self:bAfterStartJob)=="B")
                        Eval(bAfterStartJob)
                    endif
                    Sleep(self:nSleep)
                endif
                if (self:lProcess)
                    self:oProcess:IncRegua2()
                endif        
            end While
            ASSIGN nAttempt:=0
        endif
        if (self:lProcess)
            self:oProcess:IncRegua1()
        endif
    next nThread
return

method procedure Wait(nSleep) class tBigNThread
    local cTOut    AS CHARACTER VALUE SetTimeOut("0")
    local cMTXID   AS CHARACTER
    local nThread  AS NUMBER
    local nThreads AS NUMBER VALUE self:nThreads
    local nThCount AS NUMBER
    local xResult  AS UNDEFINED
    PARAMTYPE nSleep AS NUMBER OPTIONAL DEFAULT self:nSleep
    if (self:lProcess)
        self:oProcess:SetRegua1(0)
    endif
    while .not.(KillApp())
        if (self:lProcess)
            self:oProcess:SetRegua2(nThreads)
        endif
        for nThread:=1 to nThreads
            ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
            begin sequence                
                if .not.(xGetGlbValue(self:cMtxJob)=="1").and.(xGetGlbValue(cMTXID)=="1")
                    break
                endif
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
            recover
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
            end sequence
            if (self:lProcess)
                self:oProcess:IncRegua2()
            endif
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        ASSIGN nThCount:=0
        Sleep(nSleep)
        if (self:lProcess)
            self:oProcess:IncRegua1()
        endif
    end while
    SetTimeOut(cTOut)
return

method procedure Join() class tBigNThread
    local cMTXID  AS CHARACTER 
    local nThread AS NUMBER
    xPutGlbValue(self:cMtxJob,"0")
    if (self:lProcess)
        self:oProcess:SetRegua1(self:nThreads)
        self:oProcess:SetRegua2(0)
    endif
    for nThread:=1 to self:nThreads
        if (self:lProcess)
            self:oProcess:IncRegua2()
        endif
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        xPutGlbValue(cMTXID,"0")
        self:aThreads[nThread][TH_EXE]:="'E_X_I_T_'"
        IPCGo(self:cMtxJob,self:aThreads[nThread])
        Sleep(self:nSleep)
        if (self:lProcess)
            self:oProcess:IncRegua1()
        endif
    next nTread
    self:setGlbVarResult()
return

method procedure Finalize() class tBigNThread
    local cMTXID  AS CHARACTER
    local nThread AS NUMBER
    if xGlbLock(GLB_LOCK)
        if (self:lProcess)
            self:oProcess:SetRegua1(self:nThreads)
            self:oProcess:SetRegua2(self:nThreads)
        endif
        xClearGlbValue(self:cMtxJob,.F.)
        xClearGlbValue(self:cMtxJob+"GLBRESULT",.F.)
        for nThread:=1 to self:nThreads
            if (self:lProcess)
                self:oProcess:IncRegua2()
            endif
            ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
            xClearGlbValue(cMTXID,.F.)
            xClearGlbValue(cMTXID+"TH_NUM",.F.)
            xClearGlbValue(cMTXID+"TH_EXE",.F.)
            xClearGlbValue(cMTXID+"TH_RES",.F.)
            xClearGlbValue(cMTXID+"TH_END",.F.)
            xClearGlbValue(cMTXID+"TH_ERR",.F.)
            xClearGlbValue(cMTXID+"TH_MSG",.F.)
            xClearGlbValue(cMTXID+"TH_STK",.F.)
            xClearGlbValue(cMTXID+"TH_GLB",.F.)
            if (self:lProcess)
                self:oProcess:IncRegua1()
            endif
        next nTread
        xGlbUnLock(GLB_LOCK)
    endif
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

method function getAllResults(lGlbVarResult) class tBigNThread
    local aResults    AS ARRAY
    local aGLBResults AS ARRAY
    local nThread     AS NUMBER
    PARAMTYPE 1 VAR lGlbVarResult AS LOGICAL OPTIONAL DEFAULT .F.
    for nThread:=1 to self:nThreads
        if .not.(self:aThreads[nThread][TH_RES]==NIL)
            aAdd(aResults,self:getResult(nThread))        
        endif
        if .not.(self:aThreads[nThread][TH_GLB]==NIL)
            ASSIGN aGLBResults:=self:getGlbResult(nThread)
            aEval(aGLBResults,{|r|aAdd(aResults,r)})       
        endif
    next nResult
    if (lGlbVarResult)
        ASSIGN aGLBResults:=self:getGlbVarResult()
        aEval(aGLBResults,{|r|aAdd(aResults,r)})
    endif
return(aResults)

method function getGlbVarResult(cGlbName,lGlbLock) class tBigNThread
    PARAMTYPE 1 VAR cGlbName AS CHARACTER OPTIONAL DEFAULT self:cGlbResult
    PARAMTYPE 2 VAR lGlbLock AS LOGICAL   OPTIONAL DEFAULT GLB_LOCK
return(getGlbVarResult(cGlbName,lGlbLock))

method procedure setGlbVarResult(cGlbName,xGlbRes,lGlbLock) class tBigNThread
    local aResults AS ARRAY
    PARAMTYPE 1 VAR cGlbName AS CHARACTER OPTIONAL DEFAULT self:cGlbResult
    PARAMTYPE 2 VAR xGlbRes  AS UNDEFINED OPTIONAL
    PARAMTYPE 3 VAR lGlbLock AS LOGICAL   OPTIONAL DEFAULT GLB_LOCK
    if .not.(self:cGlbResult==NIL)
        ASSIGN aResults:=self:getAllResults()
        if .not.(xGlbRes==NIL)
            setGlbVarResult(cGlbName,xGlbRes,lGlbLock)
        else
            setGlbVarResult(cGlbName,aResults,lGlbLock)
        endif
    endif
return

method function setObjProcess(oProcess) class tBigNThread
    PARAMTYPE 1 VAR oProcess AS OBJECT OPTIONAL
    self:lProcess:=((valType(oProcess)=="O").and.(GetClassName(oProcess)$"TNEWPROCESS/MSNEWPROCESS"))
    if (self:lProcess)
        self:oProcess:=oProcess
    endif
return(self:lProcess)

user procedure bigNthRun(mtxJob,nTimeOut,bOnStartJob,bOnFinishJob)
    local cMTX  AS CHARACTER
    local cTyp  AS CHARACTER
    local cTOut AS CHARACTER VALUE SetTimeOut("0")
    local cFunN AS CHARACTER
    local xJob  AS UNDEFINED
    local xRes  AS UNDEFINED
    try exception using {|e|DefError(e,mtxJob)}
        PARAMTYPE 1 VAR mtxJob       AS CHARACTER
        PARAMTYPE 2 VAR nTimeOut     AS NUMBER OPTIONAL DEFAULT IPC_TIMEOUT
        PARAMTYPE 3 VAR bOnStartJob  AS ARRAY,BLOCK,CHARACTER OPTIONAL
        PARAMTYPE 4 VAR bOnFinishJob AS ARRAY,BLOCK,CHARACTER OPTIONAL
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
                        if .not.(Empty(xRes))
                            setGlbVarResult(cMTX+"TH_GLB",xRes)
                        endif    
                    case (cTyp=="C")
                        if (Upper(xRes)=="E_X_I_T_")
                            xPutGlbValue(cMTX,"0")
                        elseif .not.(Empty(xRes))
                            xPutGlbValue(cMTX+"TH_RES",xRes)
                        endif
                    otherwise
                        if .not.(xRes==NIL)
                            xPutGlbValue(cMTX+"TH_RES",cValToChar(xRes))
                        endif
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
    if (valType(e)=="O")
        OutPutMessage(e:Description,MSG_CONOUT)
        OutPutMessage(e:ErrorStack,MSG_CONOUT)
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
    DEFAULT s__oOutMessage:=tBigNMessage():New(nOutPut)
return(s__oOutMessage:OutPutMessage(xOutPut,nOutPut))

static function OutPutInternal(cOutInternal,nOutPut)
    DEFAULT s__oOutMessage:=tBigNMessage():New(nOutPut)
return(s__oOutMessage:ToInternal(cOutInternal))

#include "paramtypex.ch"
#include "tryexception.ch"
