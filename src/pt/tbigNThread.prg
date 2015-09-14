#include "tBigNumber.ch"

#define IPC_TIMEOUT ((3600000*24)*2)

/*
    class:tBigNThread
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNThread
    Sintaxe:tBigNThread():New(oProcess) -> self
*/
Class tBigNThread
    
    data aThreads
    
    data cEnvSrv
    data cGlbKey
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
    
    data oMtxJob
    
    data nSleep
    data nAttempts
    
    method function New(cMTXKey,oProcess) CONSTRUCTOR /*(/!\)*/
    
    method procedure Start(nThreads)
    
    method procedure Notify(nThEvent,lProcess)
    method function  Notified(nThEvent)

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
    
    method procedure QuitRequest()
    method procedure threadQuitRequest(nThEvent)
    
EndClass

user function tBigNThread(cMTXKey,oProcess)
return(tBigNThread():New(@cMTXKey,@oProcess))

method function New(cMTXKey,oProcess) class tBigNThread
    PARAMTYPE 1 VAR cMTXKey  AS CHARACTER OPTIONAL
    PARAMTYPE 2 VAR oProcess AS OBJECT    OPTIONAL
    self:aThreads:=Array(0)
    self:cEnvSrv:=GetEnvServer()
    self:oMtxJob:=tBigNMutex():New(NIL,cMTXKey)
    self:cGlbKey:=(self:oMtxJob:cMutex+"GLBKEY")
    xPutGlbValue(self:cGlbKey,self:oMtxJob:cMTXKey)
    self:cGlbResult:=(self:oMtxJob:cMutex+"GLBRESULT")
    self:nThreads:=0
    self:nSleep:=100
    self:nAttempts:=10
    self:nTimeOut:=IPC_TIMEOUT
    self:nOutPutMsg:=0
    self:setObjProcess(oProcess)
return(self)

method procedure Start(nThreads) class tBigNThread
    local cMTXID   AS CHARACTER
    local cIncR1   AS CHARACTER
    local cIncR2   AS CHARACTER
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
            ASSIGN cIncR1:="Processando..."
            ASSIGN cIncR2:=ProcName()
            self:oProcess:SetRegua2(nThreads)
        endif
        while (nThreads>0)
            aAdd(self:aThreads,Array(SIZ_TH))
            nThread:=Len(self:aThreads)
            ASSIGN cMTXID:=MTXCreate(self:oMtxJob:cMutex,self:oMtxJob:cMTXKey)
            self:aThreads[nThread][TH_MTX]:=cMTXID
            self:aThreads[nThread][TH_EXE]:=NIL
            self:aThreads[nThread][TH_RES]:=NIL
            self:aThreads[nThread][TH_END]:="0"
            self:aThreads[nThread][TH_NUM]:=NToS(ThreadID())
            self:aThreads[nThread][TH_ERR]:=""
            self:aThreads[nThread][TH_MSG]:=""
            self:aThreads[nThread][TH_STK]:=""
            self:aThreads[nThread][TH_GLB]:=NIL
            self:aThreads[nThread][TH_HDL]:=MTXHandle(self:oMtxJob:cMutex,self:oMtxJob:cMTXKey)
            self:aThreads[nThread][TH_KEY]:=self:oMtxJob:cMTXKey
            ++self:nThreads
            --nThreads
            if (self:lProcess)
                self:oProcess:IncRegua2(cIncR2)
            endif
        end while
    else
        ASSIGN nStart:=1
    endif
    xPutGlbValue(self:oMtxJob:cMutex,"1")
    nThreads:=self:nThreads    
    if (self:lProcess)
        self:oProcess:SetRegua1(((nThreads-nStart)+1))
        self:oProcess:SetRegua2(((nThreads-nStart)+1))
    endif
    for nThread:=nStart to nThreads
        if (self:lProcess)
            self:oProcess:IncRegua2(cIncR2)
        endif        
        if xGlbLock(GLB_LOCK)
            xPutGlbValue(cMTXID,"0",.F.)
            xPutGlbValue(cMTXID+"TH_NUM",self:aThreads[nThread][TH_NUM],.F.)
            xPutGlbValue(cMTXID+"TH_EXE","",.F.)
            xPutGlbValue(cMTXID+"TH_RES","",.F.)
            xPutGlbValue(cMTXID+"TH_END","0",.F.)
            xPutGlbValue(cMTXID+"TH_ERR","0",.F.)
            xPutGlbValue(cMTXID+"TH_MSG","",.F.)
            xPutGlbValue(cMTXID+"TH_STK","",.F.)
            xPutGlbValue(cMTXID+"TH_HDL",self:aThreads[nThread][TH_HDL],.F.)
            xPutGlbValue(cMTXID+"TH_KEY",self:aThreads[nThread][TH_KEY],.F.)
            xClearGlbValue(cMTXID+"TH_GLB",.F.)
            xGlbUnLock(GLB_LOCK)
        endif
        if (IPCCount(self:oMtxJob:cMutex)<((self:nThreads-nThread)+1))
            StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:oMtxJob:cMutex,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
            if (valType(self:bAfterStartJob)=="B")
                Eval(bAfterStartJob)
            endif
            Sleep(self:nSleep)
        endif
        if (self:lProcess)
            self:oProcess:IncRegua1(cIncR1)
        endif        
    next nThread
return

method procedure Notify(nThEvent,lProcess) class tBigNThread
    local cMTXID   AS CHARACTER
    local cIncR1   AS CHARACTER
    local cIncR2   AS CHARACTER
    local lAllThds AS LOGICAL
    local nAttempt AS NUMBER
    local nThread  AS NUMBER
    local nThreads AS NUMBER
    PARAMTYPE 1 VAR nThEvent AS NUMBER  OPTIONAL DEFAULT 0
    PARAMTYPE 2 VAR lProcess AS LOGICAL OPTIONAL DEFAULT ((nThEvent==0).and.self:lProcess)
    if (lProcess).and.(self:lProcess)
        ASSIGN cIncR1:="Processando..."
        ASSIGN cIncR2:=ProcName()
        self:oProcess:SetRegua1(self:nThreads)
        self:oProcess:SetRegua2(self:nThreads)
    endif
    ASSIGN lAllThds:=(nThEvent==0)
    ASSIGN nThEvent:=Min(Max(nThEvent,1),self:nThreads)
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        nThreads:=if(lAllThds,self:nThreads,nThEvent)
        for nThread:=nThEvent to nThreads
            if (lProcess).and.(self:lProcess)
                self:oProcess:IncRegua2(cIncR2)
            endif        
            ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
            self:aThreads[nThread][TH_RES]:=NIL
            self:aThreads[nThread][TH_END]:="0"
            self:aThreads[nThread][TH_ERR]:=""
            self:aThreads[nThread][TH_MSG]:=""
            self:aThreads[nThread][TH_STK]:=""
            self:aThreads[nThread][TH_GLB]:=NIL
            if xGlbLock(GLB_LOCK)
                xPutGlbValue(cMTXID,"0",.F.)
                xPutGlbValue(cMTXID+"TH_NUM",self:aThreads[nThread][TH_NUM],.F.)
                xPutGlbValue(cMTXID+"TH_EXE","",.F.)
                xPutGlbValue(cMTXID+"TH_RES","",.F.)
                xPutGlbValue(cMTXID+"TH_END","0",.F.)
                xPutGlbValue(cMTXID+"TH_ERR","0",.F.)
                xPutGlbValue(cMTXID+"TH_MSG","",.F.)
                xPutGlbValue(cMTXID+"TH_STK","",.F.)
                xClearGlbValue(cMTXID+"TH_GLB",.F.)
                xGlbUnLock(GLB_LOCK)
            endif
            if (xGetGlbValue(self:oMtxJob:cMutex)=="1")
                while .not.(IPCGo(self:oMtxJob:cMutex,self:aThreads[nThread]))
                    if (++nAttempt>self:nAttempts)
                        xPutGlbValue(cMTXID+"TH_RES","E_R_R_O_R_")
                        xPutGlbValue(cMTXID+"TH_END","1")
                        xPutGlbValue(cMTXID,"0")                    
                        exit
                    endif
                    sleep(self:nSleep)
                    if (IPCCount(self:oMtxJob:cMutex)<((self:nThreads-nThread)+1))
                        StartJob("u_bigNthRun",self:cEnvSrv,.F.,self:oMtxJob:cMutex,self:nTimeOut,self:bOnStartJob,self:bOnFinishJob)
                        if (valType(self:bAfterStartJob)=="B")
                            Eval(bAfterStartJob)
                        endif
                        Sleep(self:nSleep)
                    endif
                    if (lProcess).and.(self:lProcess)
                        self:oProcess:IncRegua2(cIncR2)
                    endif        
                end While
                ASSIGN nAttempt:=0
            endif
            if (lProcess).and.(self:lProcess)
                self:oProcess:IncRegua1(cIncR1)
            endif
        next nThread
    endif
return

method function Notified(nThEvent) class tBigNThread
    local cMTXID    AS CHARACTER
    local lNotified AS LOGICAL VALUE .F.
    PARAMTYPE 1 VAR nThEvent AS NUMBER OPTIONAL DEFAULT 0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        ASSIGN cMTXID:=self:aThreads[nThEvent][TH_MTX]
        lNotified:=.not.(xGetGlbValue(cMTXID)=="0")
    else
        lNotified:=.T.
    endif
return(lNotified)

method procedure Wait(nSleep) class tBigNThread
    local cTOut     AS CHARACTER VALUE SetTimeOut("0")
    local cIncR1    AS CHARACTER
    local cIncR2    AS CHARACTER
    local cMTXID    AS CHARACTER
    local nAttempt  AS NUMBER
    local nAttempts AS NUMBER VALUE 10
    local nThread   AS NUMBER
    local nThreads  AS NUMBER VALUE self:nThreads
    local nThCount  AS NUMBER
    local xResult   AS UNDEFINED
    PARAMTYPE nSleep AS NUMBER OPTIONAL DEFAULT self:nSleep
    if (self:lProcess)
        ASSIGN cIncR1:="Processando..."
        ASSIGN cIncR2:=ProcName()
        self:oProcess:SetRegua1(nAttempts)
    endif
    while .not.(self:oMtxJob:MTXKillApp())
        if (self:lProcess)
            if ((++nAttempt)>nAttempts)
                nAttempt:=0
                self:oProcess:SetRegua1(nAttempts)
            endif
            self:oProcess:SetRegua2(nThreads)
        endif
        for nThread:=1 to nThreads
            ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
            begin sequence                
                if .not.(xGetGlbValue(self:oMtxJob:cMutex)=="1").and.(self:Notified(nThread))
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
                self:oProcess:IncRegua2(cIncR2)
                if (self:oProcess:lEnd)
                    self:QuitRequest()
                endif
            endif
            Sleep(nSleep)
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        ASSIGN nThCount:=0
        Sleep(nSleep)
        if (self:lProcess)
            self:oProcess:IncRegua1(cIncR1)
        endif
    end while
    SetTimeOut(cTOut)
return

method procedure Join() class tBigNThread
    local cIncR1  AS CHARACTER
    local cIncR2  AS CHARACTER
    local cMTXID  AS CHARACTER 
    local nThread AS NUMBER
    if (self:lProcess)
        ASSIGN cIncR1:="Processando..."
        ASSIGN cIncR2:=ProcName()
        self:oProcess:SetRegua1(self:nThreads)
        self:oProcess:SetRegua2(self:nThreads)
    endif
    for nThread:=1 to self:nThreads
        if (self:lProcess)
            self:oProcess:IncRegua2(cIncR2)
        endif
        ASSIGN cMTXID:=self:aThreads[nThread][TH_MTX]
        xPutGlbValue(cMTXID,"-1")
        self:aThreads[nThread][TH_EXE]:="'_E_X_I_T_'"
        IPCGo(self:oMtxJob:cMutex,self:aThreads[nThread])
        Sleep(self:nSleep)
        if (self:lProcess)
            self:oProcess:IncRegua1(cIncR1)
        endif
    next nTread
    self:setGlbVarResult()
    xPutGlbValue(self:oMtxJob:cMutex,"-1")
return

method procedure Finalize(lGlbResult) class tBigNThread
    local cIncR1  AS CHARACTER
    local cIncR2  AS CHARACTER
    local cMTXID  AS CHARACTER
    local nThread AS NUMBER
    PARAMTYPE 1 VAR lGlbResult AS LOGICAL OPTIONAL DEFAULT .T.
    if xGlbLock(GLB_LOCK)
        if (self:lProcess)
            ASSIGN cIncR1:="Processando..."
            ASSIGN cIncR2:=ProcName()
            self:oProcess:SetRegua1(self:nThreads)
            self:oProcess:SetRegua2(self:nThreads)
        endif
        xClearGlbValue(self:oMtxJob:cMutex,.F.)
        xClearGlbValue(self:oMtxJob:cMutex+"GLBKEY",.F.)
        if (lGlbResult)
            xClearGlbValue(self:oMtxJob:cMutex+"GLBRESULT",.F.)
        endif
        self:oMtxJob:MTXSControl(self:oMtxJob:cHdlFile,.T.)
        self:oMtxJob:MTXFControl(self:oMtxJob:cHdlFile,self:oMtxJob:nHdlFile,.T.)
        for nThread:=1 to self:nThreads
            if (self:lProcess)
                self:oProcess:IncRegua2(cIncR2)
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
            xClearGlbValue(cMTXID+"TH_HDL",.F.)
            xClearGlbValue(cMTXID+"TH_KEY",.F.)
            if (self:lProcess)
                self:oProcess:IncRegua1(cIncR1)
            endif
        next nTread
        xGlbUnLock(GLB_LOCK)
    endif
    self:nThreads:=0
    aSize(self:aThreads,0)
    self:aThreads:=NIL
    self:oMtxJob:Clear()
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
    self:lProcess:=((valType(oProcess)=="O").and.(GetClassName(oProcess)$"FWGRIDPROCESS/TNEWPROCESS/MSNEWPROCESS"))
    if (self:lProcess)
        self:oProcess:=oProcess
    endif
return(self:lProcess)

method procedure QuitRequest() class tBigNThread
    local cIncR1  AS CHARACTER
    local cIncR2  AS CHARACTER
    local nThread AS NUMBER
    if (self:lProcess)
        ASSIGN cIncR1:="Processando..."
        ASSIGN cIncR2:=ProcName()
        self:oProcess:SetRegua1(self:nThreads)
        self:oProcess:SetRegua2(self:nThreads)
    endif
    for nThread:=1 to self:nThreads
        if (self:lProcess)
            self:oProcess:IncRegua2(cIncR2)
        endif
        self:threadQuitRequest(nThread)
        if (self:lProcess)
            self:oProcess:IncRegua1(cIncR1)
        endif
    next nThread
    xPutGlbValue(self:oMtxJob:cMutex,"-1")
    if File(self:oMtxJob:cHdlFile)
        fErase(self:oMtxJob:cHdlFile)
    endif
    self:oMtxJob:MTXKillApp(self:oMtxJob:cHdlFile,.T.)
return

method procedure threadQuitRequest(nThEvent) class tBigNThread
    local cMTXID    AS CHARACTER
    local cMTXHDL   AS CHARACTER
    PARAMTYPE 1 VAR nThEvent AS NUMBER
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        ASSIGN cMTXID:=self:aThreads[nThEvent][TH_MTX]
        ASSIGN cMTXHDL:=self:aThreads[nThEvent][TH_HDL]
        xPutGlbValue(cMTXID,"-1")
        if File(cMTXHDL)
            fErase(cMTXHDL)
        endif
    endif
return

user procedure bigNthRun(cMTXJob,nTimeOut,bOnStartJob,bOnFinishJob)
    local cMTX  AS CHARACTER
    local cKey  AS CHARACTER
    local cTyp  AS CHARACTER
    local cTOut AS CHARACTER VALUE SetTimeOut("0")
    local cFunN AS CHARACTER
    local oMTXJ AS OBJECT CLASS "TBIGNMUTEX"
    local xJob  AS UNDEFINED
    local xRes  AS UNDEFINED
    try exception using {|e|DefError(e,cMTXJob)}
        PARAMTYPE 1 VAR cMTXJob      AS CHARACTER
        PARAMTYPE 2 VAR nTimeOut     AS NUMBER OPTIONAL DEFAULT IPC_TIMEOUT
        PARAMTYPE 3 VAR bOnStartJob  AS ARRAY,BLOCK,CHARACTER OPTIONAL
        PARAMTYPE 4 VAR bOnFinishJob AS ARRAY,BLOCK,CHARACTER OPTIONAL
        ASSIGN cKey:=xGetGlbValue(cMTXJob+"GLBKEY")
        ASSIGN oMTXJ:=tBigNMutex():New(cMTXJob,cKey)
        ASSIGN cFunN:=ProcName()
        SetFunName(cFunN)
        OutPutInternal(cFunN)
        Private __oMTXJob:=oMTXJ
        ASSIGN cTyp:=valType(bOnStartJob)
        do case
        case (cTyp=="A")
            ExecFromArray(bOnStartJob)
        case (cTyp=="B")
            Eval(bOnStartJob)
        case (cTyp=="C")
            &(bOnStartJob)
        end case
        while .not.(oMTXJ:MTXKillApp())
            if .not.(xGetGlbValue(cMTXJob)=="1")
                exit
            endif
            if IPCWaitEx(cMTXJob,nTimeOut,@xJob)
                ASSIGN cTyp:=valType(xJob)
                do case
                case (cTyp=="A")
                    ASSIGN cMTX:=xJob[TH_MTX]
                    xPutGlbValue(cMTX,"1")
                    xPutGlbValue(cMTX+"TH_NUM",NToS(ThreadID()))
                    Private __cMTXJobThd:=cMTX
                    Private __cMTXHdlThd:=xJob[TH_HDL]
                    Private __cMTXKeyThd:=xJob[TH_KEY]
                    Private __oMTXJobThd:=MTXObj(__cMTXJobThd,__cMTXKeyThd)
                    if .not.(__oMTXJobThd:MTXSControl(@__oMTXJobThd:cHdlFile,.F.,.F.))
                        UserException("Impossivel executar Processo: ")
                    endif
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
                        if (Upper(xRes)=="_E_X_I_T_")
                            xPutGlbValue(cMTX,"-1")
                        elseif .not.(Empty(xRes))
                            xPutGlbValue(cMTX+"TH_RES",xRes)
                        endif
                    otherwise
                        if .not.(xRes==NIL)
                            xPutGlbValue(cMTX+"TH_RES",cValToChar(xRes))
                        endif
                    endcase
                    xPutGlbValue(cMTX+"TH_END","1")
                    __oMTXJobThd:MTXSControl(@__oMTXJobThd:cHdlFile,.T.)
                    if .not.(xGetGlbValue(cMTXJob)=="1")
                        exit
                    endif
                case (cTyp=="C")
                    if (Upper(xJob)=="_E_X_I_T_")
                        xPutGlbValue(cMTXJob,"-1")
                        exit
                    endif
                    xRes:=&(xJob)                    
                    if (valType(xRes)=="C")
                        if (Upper(xRes)=="_E_X_I_T_")
                            xPutGlbValue(cMTXJob,"-1")
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

static procedure DefError(e,xJOB)
    local cType:=valType(xJOB)
    local cMTXID:=if((cType=="A"),xJOB[TH_MTX],if((cType=="C"),xJOB,"__NOID__"))
    if .not.(cMTXID=="__NOID__")
        xPutGlbValue(cMTXID,"-1")
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
return(NToS(PtInternal(2,cTOut)))

#include "paramtypex.ch"
#include "tryexception.ch"
#include "tBiGNCommon.prg"
