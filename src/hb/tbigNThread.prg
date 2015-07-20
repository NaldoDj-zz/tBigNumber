#include "hbclass.ch"
#include "hbclass.ch"
#include "tBigNThread.ch"

Class tBigNThreads

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
    method ReStart(nThreads,nMemMode)
    
    method Notify()
    method Wait(nSleep)
    method Join()
    
    method addEvent(uthEvent)
    method setEvent(nThEvent,uthEvent)

    method getResult(nThEvent)
    method getAllResults()
    
    method clearAllResults()
    
    method setSleep(nSleep)
    
EndClass

method function new(nThreads) class tBigNThreads
    DEFAULT nThreads:=0
    DEFAULT self:nThreads:=nThreads
    self:aThreads:=if(self:nThreads>0,Array(self:nThreads,SIZ_TH),Array(0))
    self:aResults:=Array(0)
    self:nMemMode:=NIL
    self:nThreadID:=hb_ThreadID()
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
            tBigNSleep(nSleep)
        end while
    next nThread
return

method procedure ReStart(nThreads,nMemMode) class tBigNThreads
    self:Join()
    self:clearAllResults()
    self:nThreads:=0
    aSize(self:aThreads,self:nThreads)
    self:Start(@nThreads,@nMemMode)
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
    local nThread
    local nThreads:=self:nThreads
    local nThCount:=0
    DEFAULT nSleep:=self:nSleep
    while .T.
        for nThread:=1 to nThreads
            if .not.(hb_MutexLock(self:aThreads[nThread][TH_MTX]))
                tBigNSleep(nSleep)
                loop
            endif
            if self:aThreads[nThread][TH_END]
                ++nThCount
            endif
            hb_MutexUnLock(self:aThreads[nThread][TH_MTX])
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

method function addEvent(uthEvent) class tBigNThreads
    local bEvent:={|aTh|.NOT.(aTh[TH_END]).and.(aTh[TH_EXE]==NIL)}
    local nThEvent:=aScan(self:aThreads,bEvent)
    while (nThEvent==0)
        self:Start(self:nThreads+1,self:nMemMode)
        nThEvent:=aScan(self:aThreads,bEvent)
    end while
    self:setEvent(nThEvent,uthEvent)
return(nThEvent)

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
    endif
return(uResult)

method function getAllResults() class tBigNThreads
    aEval(self:aThreads,{|aTh|if(aTh[TH_RES]==NIL,NIL,aAdd(self:aResults,aTh[TH_RES]))})
return(aClone(self:aResults))

method procedure clearAllResults() class tBigNThreads
    aSize(self:aResults,0)
return

method procedure setSleep(nSleep) class tBigNThreads
    DEFAULT nSleep:=0.01
    self:nSleep:=nSleep
return

static Procedure tbigNthRun(mtxJob,aThreads,nSleep)
    local cTyp
    local xJob
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
                    while .not.(hb_MutexLock(aThreads[xJob][TH_MTX]))
                        tBigNSleep(nSleep)
                    end while
                    cTyp:=ValType(aThreads[xJob][TH_EXE])
                    switch cTyp
                    case "A"
                        aThreads[xJob][TH_RES]:=hb_ExecFromArray(aThreads[xJob][TH_EXE])
                        exit
                    case "B"
                        aThreads[xJob][TH_RES]:=Eval(aThreads[xJob][TH_EXE])
                        exit
                    otherwise
                        aThreads[xJob][TH_RES]:=NIL
                    endswitch
                    aThreads[xJob][TH_END]:=.T.
                    hb_MutexUnLock(aThreads[xJob][TH_MTX])
                    exit
                endswitch
            endif
        end while
    end sequence
return
