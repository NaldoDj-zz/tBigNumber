#include "hbclass.ch"
#include "tBigNThread.ch"

static s_aResults

Class tBigNThreads

    PROTECTED:
    
    data aThreads
    data aResults
    
    data nThreads
    data nMemMode
    data nID    

    EXPORTED:
    
    method New(nThreads) CONSTRUCTOR /*( /!\ )*/
    
    method Start(nThreads,nMemMode)
    method Notify()
    method Wait()
    method Join()
    
    method addEvent(uthEvent)
    method setEvent(nThEvent,uthEvent)

    method getResult(nThEvent)
    method getAllResults()
    
    method clearAllResults()
    
EndClass

method new(nThreads) class tBigNThreads
    DEFAULT s_aResults:=Array(0)
    DEFAULT nThreads:=0
    DEFAULT self:nThreads:=nThreads
    self:aThreads:=if(self:nThreads>0,Array(self:aThreads,SIZ_TH),Array(0))
    self:aResults:=Array(0)
    self:nMemMode:=NIL
    self:nID:=hb_ThreadID()
return(self)

method Start(nThreads,nMemMode) class tBigNThreads
    local nStart
    local nThread
    DEFAULT nThreads:=self:nThreads
    DEFAULT nMemMode:=self:nMemMode
    self:nMemMode:=nMemMode
    if (nThreads>self:nThreads).or.(self:nThreads==0)
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
    for nThread:=nStart To nThreads
        self:aThreads[nThread][TH_MTX]:=hb_mutexCreate()
        self:aThreads[nThread][TH_EXE]:=NIL
        self:aThreads[nThread][TH_RES]:=NIL
        self:aThreads[nThread][TH_END]:=.F.
        if nMemMode==NIL
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
        else
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
        endif
        while (self:aThreads[nThread][TH_NUM]==NIL)
            if nMemMode==NIL
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
            else
                self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
            endif
        end while
    next nThread
return(self)

method Notify() class tBigNThreads
    aEval(self:aThreads,{|ath,nTh|self:aThreads[nTh][TH_RES]:=NIL,self:aThreads[nTh][TH_END]:=.F.,hb_mutexNotify(ath[TH_MTX],nTh)})
return(self)

method Wait() class tBigNThreads
    local nThread
    local nThreads:=self:nThreads
    local nThCount:=0
    while .T.
        for nThread:=1 to nThreads
            if hb_mutexLock(self:aThreads[nThread][TH_MTX])
                if self:aThreads[nThread][TH_END]
                    ++nThCount
                endif
                hb_MutexUnLock(self:aThreads[nThread][TH_MTX])
            endif
        next nThread
        if nThCount==nThreads
            exit
        endif
        nThCount:=0
    end while
return(self)

method Join() class tBigNThreads
    aEval(self:aThreads,{|ath|hb_mutexNotify(ath[TH_MTX],{||break()}),if(.not.(ath[TH_NUM]==NIL),hb_threadJoin(ath[TH_NUM]),NIL)})
return(self)

method addEvent(uthEvent) class tBigNThreads
    Local bEvent
    Local nThEvent
    Local oThreads
    if (self:nID==hb_ThreadID())
        bEvent:={|aTh|.NOT.(aTh[TH_END]).and.(aTh[TH_EXE]==NIL)}
        nThEvent:=aScan(self:aThreads,bEvent)
        while (nThEvent==0)
            self:Start(self:nThreads+1,self:nMemMode)
            nThEvent:=aScan(self:aThreads,bEvent)
        end while
        self:setEvent(nThEvent,uthEvent)
    else
        oThreads:=tBigNThreads():New()
        nThEvent:=1
        oThreads:Start(nThEvent)
        oThreads:setEvent(nThEvent,uthEvent)
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()
        aAdd(s_aResults,oThreads:getResult(nThEvent))
    endif
return(nThEvent)

method setEvent(nThEvent,uthEvent) class tBigNThreads
    local uLEvent
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uLEvent:=self:aThreads[nThEvent][TH_EXE]
        self:aThreads[nThEvent][TH_EXE]:=uthEvent
    endif
return(uLEvent)

method getResult(nThEvent) class tBigNThreads
    local uResult
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uResult:=self:aThreads[nThEvent][TH_RES]
    endif
return(uResult)

method getAllResults() class tBigNThreads
    aEval(self:aThreads,{|aTh|if(aTh[TH_RES]==NIL,NIL,aAdd(self:aResults,aTh[TH_RES]))})
    if .not.(Empty(s_aResults))
        aEval(s_aResults,{|r|aAdd(self:aResults,r)})
        aSize(s_aResults,0)
    endif
return(self:aResults)

method clearAllResults() class tBigNThreads
    aSize(s_aResults,0)
    aSize(self:aResults,0)
return(NIL)

static Procedure tbigNthRun(mtxJob,aThreads)
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
                    while .not.(hb_mutexLock(aThreads[xJob][TH_MTX]))
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