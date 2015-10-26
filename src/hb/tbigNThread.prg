#include "hbclass.ch"
#include "tBigNThread.ch"

Class tBigNThread

    PROTECTED:
    
    data aThreads
    
    data nThreads
    data nMemMode
    
    data nMtxJob
    
    data nSleep

    EXPORTED:
    
    method New() CONSTRUCTOR /*( /!\ )*/
    
    method Start(nThreads,nMemMode)
    
    method Notify()
    method Wait(nSleep)
    method Join()
    
    method setEvent(nThEvent,uthEvent)

    method getResult(nThEvent)
    method getAllResults()
    
    method setSleep(nSleep)
    
EndClass

method function new() class tBigNThread
    self:aThreads:=Array(0)
    self:nThreads:=0
    self:nMtxJob:=hb_mutexCreate()
    self:setSleep()
return(self)

method procedure Start(nThreads,nMemMode) class tBigNThread
    local nStart
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
            nThread:=Len(self:aThreads)
            self:aThreads[nThread][TH_MTX]:=hb_mutexCreate()
            self:aThreads[nThread][TH_EXE]:=NIL
            self:aThreads[nThread][TH_RES]:=NIL
            self:aThreads[nThread][TH_END]:=hb_mutexCreate()
            ++self:nThreads
            --nThreads
        End While
    else
        nStart:=1
    endif
    nThreads:=self:nThreads    
    for nThread:=nStart to nThreads
        if (nMemMode==NIL)
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),@self:nMtxJob)
        else
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),@self:nMtxJob)
        endif
        while (self:aThreads[nThread][TH_NUM]==NIL)
            if (nMemMode==NIL)
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),@self:nMtxJob)
            else
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),@self:nMtxJob)
            endif
        end while
    next nThread
return

method procedure Notify() class tBigNThread
    local nThread
    for nThread:=1 to self:nThreads
        self:aThreads[nThread][TH_RES]:=NIL
        while .not.(hb_MutexLock(self:aThreads[nThread][TH_END]))
            tBigNSleep(self:nSleep)
        end while
        hb_mutexNotify(self:aThreads[nThread][TH_END],.F.)
        hb_MutexUnLock(self:aThreads[nThread][TH_END])
        while .not.(hb_MutexLock(self:nMtxJob))
            tBigNSleep(self:nSleep)
        end while
        hb_mutexNotify(self:nMtxJob,self:aThreads[nThread])
        hb_MutexUnLock(self:nMtxJob)
    next nThread
return

method procedure Wait(nSleep) class tBigNThread
    local athEnd
    local lThEnd
    local nThread
    local nThreads:=self:nThreads
    local nThCount:=0
    local xRes
    DEFAULT nSleep:=self:nSleep
    athEnd:=Array(nThreads)
    aFill(athEnd,.F.)
    while .T.
        for nThread:=1 to nThreads
            if .not.(hb_MutexLock(self:aThreads[nThread][TH_MTX]))
                tBigNSleep(nSleep)
                loop
            endif
            lThEnd:=athEnd[nThread]
            if .not.(lThEnd)
                if hb_mutexSubscribe(self:aThreads[nThread][TH_END],NIL,@lThEnd)
                    athEnd[nThread]:=lThEnd
                endif    
            endif
            if lThEnd
                if (self:aThreads[nThread][TH_RES]==NIL)
                    if hb_mutexSubscribe(self:aThreads[nThread][TH_MTX],NIL,@xRes)
                        self:aThreads[nThread][TH_RES]:=xRes
                    endif
                endif
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

method procedure Join() class tBigNThread
    local nThread
    local pFunc:=@break()
    for nThread:=1 to self:nThreads
        hb_mutexNotify(self:nMtxJob,{"H_ACTION"=>pFunc})
    next nTread
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
        self:aThreads[nThEvent][TH_RES]:=NIL
    endif
return(uResult)

method function getAllResults() class tBigNThread
    local aResults:=Array(0)
    local nThread
    for nThread:=1 to self:nThreads
        if .not.(self:aThreads[nThread][TH_RES]==NIL)
            aAdd(aResults,self:getResult(nThread))        
        endif
    next nResult
return(aResults)

method procedure setSleep(nSleep) class tBigNThread
    DEFAULT nSleep:=0.01
    self:nSleep:=nSleep
return

static Procedure tbigNthRun(mtxJob)
    local aJob
    local cTyp
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
                case "H"
                    hb_ExecFromArray(xJob["H_ACTION"])
                    exit
                case "A"
                    aJob:=xJob
                    xJob:=aJob[TH_EXE]
                    cTyp:=ValType(xJob)
                    switch cTyp
                    case "A"
                        xRes:=hb_ExecFromArray(xJob)
                        exit
                    case "B"
                        xRes:=Eval(xJob)
                        exit
                    otherwise
                        xRes:=NIL
                    endswitch
                    hb_mutexNotify(aJob[TH_MTX],xRes)
                    hb_mutexNotify(aJob[TH_END],.T.)
                    exit
                endswitch
            endif
        end while
    end sequence
return
