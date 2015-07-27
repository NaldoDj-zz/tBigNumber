#include "hbclass.ch"
#include "tBigNThread.ch"

Class tBigNThreads

    PROTECTED:
    
    data aThreads
    
    data nThreads
    data nMemMode
    
    data nMtxJob
    
    data nSleep

    EXPORTED:
    
    method New(nThreads) CONSTRUCTOR /*( /!\ )*/
    
    method Start(nThreads,nMemMode)
    
    method Notify()
    method Wait(nSleep)
    method Join()
    
    method setEvent(nThEvent,uthEvent)

    method getResult(nThEvent)
    method getAllResults()
    
    method setSleep(nSleep)
    
EndClass

method function new(nThreads) class tBigNThreads
    DEFAULT nThreads:=0
    DEFAULT self:nThreads:=nThreads
    self:aThreads:=if(self:nThreads>0,Array(self:nThreads,SIZ_TH),Array(0))
    self:nMemMode:=NIL
    self:nMtxJob:=hb_mutexCreate()
    self:setSleep()
return(self)

method procedure Start(nThreads,nMemMode) class tBigNThreads
    local nStart
    local nSleep:=self:nSleep
    local nThread
    DEFAULT nThreads:=self:nThreads
    DEFAULT nMemMode:=self:nMemMode
    self:nMemMode:=nMemMode
    if ((nThreads>self:nThreads).or.(self:nThreads==0))
        if (self:nThreads==0)
            nStart:=1
        else
            nStart:=(self:nThreads+(nThreads-self:nThreads))
        endif
        While (nThreads>0)
            aAdd(self:aThreads,Array(SIZ_TH))
            ++self:nThreads
            --nThreads
        End While
    else
        nStart:=1
    endif
    nThreads:=self:nThreads    
    for nThread:=nStart to nThreads
        self:aThreads[nThread][TH_MTX]:=hb_mutexCreate()
        self:aThreads[nThread][TH_EXE]:=NIL
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:=.F.
        if (nMemMode==NIL)
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),@self:nMtxJob,@self:aThreads,nSleep)
        else
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),@self:nMtxJob,@self:aThreads,nSleep)
        endif
        while (self:aThreads[nThread][TH_NUM]==NIL)
            if (nMemMode==NIL)
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),@self:nMtxJob,@self:aThreads,nSleep)
            else
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),@self:nMtxJob,@self:aThreads,nSleep)
            endif
        end while
    next nThread
return

method procedure Notify() class tBigNThreads
    local nThread
    for nThread:=1 to self:nThreads
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:=.F.
        hb_mutexNotify(self:nMtxJob,nThread)
    next nThread
return

method procedure Wait(nSleep) class tBigNThreads
    local pMTX
    local nThread
    local nThreads:=self:nThreads
    local nThCount:=0
    DEFAULT nSleep:=self:nSleep
    while .T.
        for nThread:=1 to nThreads
            pMTX:=self:aThreads[nThread][TH_MTX]
            if .not.(hb_MutexLock(pMTX))
                tBigNSleep(nSleep)
                loop
            endif
            if self:aThreads[nThread][TH_END]
                ++nThCount
            endif
            hb_MutexUnLock(pMTX)
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        nThCount:=0
        tBigNSleep(nSleep)
    end while
return

method procedure Join() class tBigNThreads
    local nThread
    for nThread:=1 to self:nThreads
        hb_mutexNotify(self:nMtxJob,{||break()})
        if .not.(self:aThreads[nThread][TH_NUM]==NIL)
            hb_threadQuitRequest(self:aThreads[nThread][TH_NUM])
            self:aThreads[nThread][TH_NUM]:=NIL
        endif
    next nTread
return

method function setEvent(nThEvent,uthEvent) class tBigNThreads
    local uLEvent
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uLEvent:=self:aThreads[nThEvent][TH_EXE]
        self:aThreads[nThEvent][TH_EXE]:=uthEvent
    endif
return(uLEvent)

method function getResult(nThEvent) class tBigNThreads
    local uResult
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uResult:=self:aThreads[nThEvent][TH_RES]
        self:aThreads[nThEvent][TH_RES]:=NIL
    endif
return(uResult)

method function getAllResults() class tBigNThreads
    local aResults:=Array(0)
    local nThread
    for nThread:=1 to self:nThreads
        if .not.(self:aThreads[nThread][TH_RES]==NIL)
            aAdd(aResults,self:getResult(nThread))        
        endif
    next nResult
return(aResults)

method procedure setSleep(nSleep) class tBigNThreads
    DEFAULT nSleep:=0.01
    self:nSleep:=nSleep
return

static Procedure tbigNthRun(mtxJob,aThreads,nSleep)
    local cTyp
    local nJob
    local pMTX
    local xJob
    local xRes
    begin sequence
        while .T.
            if hb_mutexSubscribe(mtxJob,NIL,@xJob)
                cTyp:=ValType(xJob)
                switch cTyp
                case "B"
                    Eval(xJob)
                    exit
                case "A"
                    hb_ExecFromArray(xJob)
                    exit
                case "N"
                    nJob:=xJob
                    pMTX:=aThreads[nJob][TH_MTX]
                    while .not.(hb_MutexLock(pMTX))
                        tBigNSleep(nSleep)
                    end while
                    xJob:=aThreads[nJob][TH_EXE]
                    cTyp:=ValType(xJob)
                    switch cTyp
                    case "A"
                        xRes:=hb_ExecFromArray(xJob)
                        exit
                    case "B"
                        xRes:=Eval(xJob)
                        exit
                    endswitch
                    aThreads[nJob][TH_RES]:=xRes
                    aThreads[nJob][TH_END]:=.T.
                    hb_MutexUnLock(pMTX)
                    exit
                endswitch
            endif
            xJob:=NIL
            xRes:=NIL
        end while
    end sequence
return
