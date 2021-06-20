#include "hbclass.ch"
#include "hbthread.ch"
#include "tBigNThread.ch"

class tBigNThread

    PROTECTED:
    
    data aThreads   as array
    data aResults   as array

    data aRChilds   as array
    
    data nThreads   as numeric
    data nMemMode   as numeric
    data nThreadID  as numeric

    EXPORTED:
    
    method New(nThreads as numeric) CONSTRUCTOR /*( /!\ )*/
    
    method Start(nThreads as numeric,nMemMode as numeric)
    method Notify()
    method Wait()
    method Join()
    method Clear()
    
    method addEvent(uthEvent)
    method setEvent(nThEvent as numeric,uthEvent)

    method getResult(nThEvent as numeric)
    method getAllResults()
    
    method clearAllResults()
    
endclass

method new(nThreads as numeric) class tBigNThread
    DEFAULT nThreads:=0
    DEFAULT self:nThreads:=nThreads
    self:aThreads:=if(self:nThreads>0,array(self:aThreads,SIZ_TH),array(0))
    self:aResults:=array(0)
    self:aRChilds:=array(0)
    self:nMemMode:=hb_bitOr(HB_THREAD_INHERIT_PUBLIC,HB_THREAD_INHERIT_PRIVATE,HB_THREAD_INHERIT_MEMVARS,HB_THREAD_MEMVARS_COPY)
    self:nThreadID:=hb_ThreadID()
    return(self)

method Start(nThreads as numeric,nMemMode as numeric) class tBigNThread
    local nStart    as numeric
    local nThread   as numeric
    DEFAULT nThreads:=self:nThreads
    DEFAULT nMemMode:=self:nMemMode
    self:nMemMode:=nMemMode
    if ((nThreads>self:nThreads).or.(self:nThreads==0))
        if (self:nThreads==0)
            nStart:=1
        else
            nStart:=(self:nThreads+(nThreads-self:nThreads))
        endif
        while (nThreads>0)
            aAdd(self:aThreads,array(SIZ_TH))
            ++self:nThreads
            --nThreads
        end while
    else
        nStart:=1
    endif
    nThreads:=self:nThreads    
    for nThread:=nStart To nThreads
        self:aThreads[nThread][TH_MTX]:=hb_mutexCreate()
        self:aThreads[nThread][TH_EXE]:=nil
        self:aThreads[nThread][TH_RES]:=nil
        self:aThreads[nThread][TH_END]:=.F.
        self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
        while (self:aThreads[nThread][TH_NUM]==nil)
            self:aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),self:aThreads[nThread][TH_MTX],@self:aThreads)
        end while
    next nThread
    return(self)

method Notify() class tBigNThread
    local bNotify as block
    bNotify:={|ath,nTh|self:aThreads[nTh][TH_RES]:=nil,self:aThreads[nTh][TH_END]:=.F.,hb_mutexNotify(ath[TH_MTX],nTh)}
    aEval(self:aThreads,bNotify)
    return(self)

method Wait() class tBigNThread
    local nThread   as numeric
    local nThreads  as numeric
    local nThCount  as numeric
    nThreads:=self:nThreads
    nThCount:=0
    while (.T.)
        for nThread:=1 to nThreads
            if (hb_mutexLock(self:aThreads[nThread][TH_MTX]))
                if (self:aThreads[nThread][TH_END])
                    ++nThCount
                endif
                hb_MutexUnLock(self:aThreads[nThread][TH_MTX])
            endif
        next nThread
        if (nThCount==nThreads)
            exit
        endif
        nThCount:=0
    end while
    return(self)

method Join() class tBigNThread
    local bJoin as block
    bJoin:={|ath|hb_mutexNotify(ath[TH_MTX],{||break()}),if(.not.(ath[TH_NUM]==nil),hb_threadJoin(ath[TH_NUM]),nil)}
    aEval(self:aThreads,bJoin)
    return(self)

method addEvent(uthEvent) class tBigNThread
    local bEvent    as block
    local nThEvent  as numeric
    local oThreads  as object
    if (self:nThreadID==hb_ThreadID())
        bEvent:={|aTh|.NOT.(aTh[TH_END]).and.(aTh[TH_EXE]==nil)}
        nThEvent:=aScan(self:aThreads,bEvent)
        while (nThEvent==0)
            self:Start(self:nThreads+1,self:nMemMode)
            nThEvent:=aScan(self:aThreads,bEvent)
        end while
        self:setEvent(nThEvent,uthEvent)
    else
        oThreads:=tBigNThread():New()
        nThEvent:=1
        oThreads:Start(nThEvent)
        oThreads:setEvent(nThEvent,uthEvent)
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()
        aAdd(self:aRChilds,oThreads:getResult(nThEvent))
    endif
    return(nThEvent)

method setEvent(nThEvent as numeric,uthEvent) class tBigNThread
    local uLEvent
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uLEvent:=self:aThreads[nThEvent][TH_EXE]
        self:aThreads[nThEvent][TH_EXE]:=uthEvent
    endif
    return(uLEvent)

method getResult(nThEvent as numeric) class tBigNThread
    local uResult
    DEFAULT nThEvent:=0
    if ((nThEvent>0).and.(nThEvent<=self:nThreads))
        uResult:=self:aThreads[nThEvent][TH_RES]
    endif
    return(uResult)

method getAllResults() class tBigNThread
    aEval(self:aThreads,{|aTh|if(aTh[TH_RES]==nil,nil,aAdd(self:aResults,aTh[TH_RES]))})
    if (.not.(Empty(self:aRChilds)))
        aEval(self:aRChilds,{|r|aAdd(self:aResults,r)})
    endif
    return(self:aResults)

method clearAllResults() class tBigNThread
    aSize(self:aRChilds,0)
    aSize(self:aResults,0)
    return(nil)
    
method Clear() class tBigNThread
    self:clearAllResults()
    aSize(self:aThreads,0)
    self:nThreads:=0
    return(nil)    

static procedure tbigNthRun(mtxJob as numeric,aThreads as array)
    local cTyp as character
    local xJob
    begin sequence
        while (.T.)
            if (hb_mutexSubscribe(mtxJob,nil,@xJob))
                cTyp:=ValType(xJob)
                switch (cTyp)
                case ("B")
                    Eval(xJob)
                    exit
                case ("A")
                    hb_ExecFromarray(xJob)
                    exit
                case ("N")
                    while (.not.(hb_mutexLock(aThreads[xJob][TH_MTX])))
                    end while
                    cTyp:=ValType(aThreads[xJob][TH_EXE])
                    switch (cTyp)
                    case ("A")
                        aThreads[xJob][TH_RES]:=hb_ExecFromarray(aThreads[xJob][TH_EXE])
                        exit
                    case ("B")
                        aThreads[xJob][TH_RES]:=Eval(aThreads[xJob][TH_EXE])
                        exit
                    otherwise
                        aThreads[xJob][TH_RES]:=nil
                    endswitch
                    aThreads[xJob][TH_END]:=.T.
                    hb_MutexUnLock(aThreads[xJob][TH_MTX])
                    exit
                endswitch
            endif
        end while
    end sequence
    return
