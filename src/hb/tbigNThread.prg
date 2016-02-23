#include "hbclass.ch"
#include "hbclass.ch"
#include "tBigNThread.ch"

Class tBigNThread

    PROTECTED:
    
    data aThreads
    data aResults
    
    data nThreads
    data nMemMode
    data nThreadID
    
    data nMtxJob
    
    data nSleep

    EXPORTED:
    
    method New(nThreads) CONSTRUCTOR /*( /!\ )*/
    
    method Start(nThreads,nMemMode)
    
    method Notify()
    method Wait()
    method Join()
    
    method setEvent(nThEvent,uthEvent)

    method getResult(nThEvent)
    method getAllResults()
    
    method clearAllResults()
    
    method setSleep(nSleep)
    
EndClass

method function new(nThreads) class tBigNThread
    DEFAULT nThreads:=0
    DEFAULT self:nThreads:=nThreads
    self:aThreads:=if(self:nThreads>0,Array(self:nThreads,SIZ_TH),Array(0))
    self:aResults:=Array(0)
    self:nMemMode:=NIL
    self:nThreadID:=hb_ThreadID()
    self:nMtxJob:=hb_mutexCreate()
    self:setSleep()
return(self)

method procedure Start(nThreads,nMemMode) class tBigNThread
    local nStart
    local nThread
    local nEvents
    local nWorkers
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
        if (hb_mutexQueueInfo(self:nMtxJob,@nWorkers,@nEvents).and.((nWorkers<self:nThreads)))
            if (nMemMode==NIL)
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),@self:nMtxJob,@self:aThreads)
            else
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),@self:nMtxJob,@self:aThreads)
            endif
            if .not.(self:aThreads[nThread][TH_NUM]==NIL)
                hb_threadDetach(self:aThreads[nThread][TH_NUM])
            endif
        endif
    next nThread
return

method procedure Notify() class tBigNThread
    local aThreads:=self:aThreads
    local cTyp
    local pMTX
    local uJob
    local uRes
    local nThread
    local nEvents
    local nWorkers
    for nThread:=1 to self:nThreads
        aThreads[nThread][TH_RES]:=NIL
        aThreads[nThread][TH_END]:=.F.
        if (hb_mutexQueueInfo(self:nMtxJob,@nWorkers,@nEvents).and.(nWorkers<self:nThreads))
            pMTX:=self:aThreads[nThread][TH_MTX]
            if hb_MutexLock(pMTX)
                uJob:=aThreads[nThread][TH_EXE]
                hb_MutexUnLock(pMTX)
            endif
            cTyp:=ValType(uJob)
            switch cTyp
            case "A"
                uRes:=hb_ExecFromArray(uJob)
                exit
            case "B"
                uRes:=Eval(uJob)
                exit
            otherwise
                uRes:=NIL
            endswitch
            if hb_MutexLock(pMTX)
                aThreads[nThread][TH_RES]:=uRes
                aThreads[nThread][TH_END]:=.T.
                hb_MutexUnLock(pMTX)
            endif
            loop
        endif
        hb_mutexNotify(self:nMtxJob,nThread)
    next nThread
return

method procedure Wait() class tBigNThread
    local nThread
    local nThreads:=self:nThreads
    local nThCount:=0
    local pMTX
    while .T.
        for nThread:=1 to nThreads
            pMTX:=self:aThreads[nThread][TH_MTX]
            if hb_MutexLock(pMTX,0)
                if self:aThreads[nThread][TH_END]
                    ++nThCount
                endif
                hb_MutexUnLock(pMTX)
            endif
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        nThCount:=0
    end while
return

method procedure Join() class tBigNThread
    local nThread
    local nEvents
    local nWorkers
    for nThread:=1 to self:nThreads
        hb_mutexNotify(self:nMtxJob,{||break()})
    next nTread
    if (hb_mutexQueueInfo(self:nMtxJob,@nWorkers,@nEvents).and.(nWorkers>0))
        hb_mutexNotifyAll(self:nMtxJob,{||break()})
    endif
return

method function setEvent(nThEvent,uthEvent) class tBigNThread
    local uLEvent
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uLEvent:=self:aThreads[nThEvent][TH_EXE]
        self:aThreads[nThEvent][TH_EXE]:=uthEvent
    endif
return(uLEvent)

method function getResult(nThEvent) class tBigNThread
    local uResult
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uResult:=self:aThreads[nThEvent][TH_RES]
    endif
return(uResult)

method function getAllResults() class tBigNThread
    aEval(self:aThreads,{|aTh|if(aTh[TH_RES]==NIL,NIL,aAdd(self:aResults,aTh[TH_RES]))})
return(aClone(self:aResults))

method procedure clearAllResults() class tBigNThread
    aSize(self:aResults,0)
return

method procedure setSleep(nSleep) class tBigNThread
    DEFAULT nSleep:=0
    self:nSleep:=nSleep
return

static Procedure tbigNthRun(mtxJob,aThreads)
    local cTyp
    local xJob
    local pMTX
    local uJob
    local uRes
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
                    pMTX:=aThreads[xJob][TH_MTX]
                    if hb_MutexLock(pMTX)
                        uJob:=aThreads[xJob][TH_EXE]
                        hb_MutexUnLock(pMTX)
                    endif
                    cTyp:=ValType(uJob)
                    switch cTyp
                    case "A"
                        uRes:=hb_ExecFromArray(uJob)
                        exit
                    case "B"
                        uRes:=Eval(uJob)
                        exit
                    otherwise
                        uRes:=NIL
                    endswitch
                    if hb_MutexLock(pMTX)
                        aThreads[xJob][TH_RES]:=uRes
                        aThreads[xJob][TH_END]:=.T.
                        hb_MutexUnLock(pMTX)
                    endif
                    exit
                endswitch
            endif
        end while
    end sequence
return
