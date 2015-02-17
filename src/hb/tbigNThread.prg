#include "tbigNThread.ch"
procedure tBigNthStart(nThreads,aThreads,nMemMode)
    local nThread
    DEFAULT nThreads:=1
    aThreads:=Array(nThreads,SIZ_TH)
    for nThread:=1 To nThreads
        aThreads[nThread][TH_MTX]:=hb_mutexCreate()
        aThreads[nThread][TH_EXE]:=NIL
        aThreads[nThread][TH_RES]:=NIL
        aThreads[nThread][TH_END]:=.F.
        if nMemMode==NIL
            aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),aThreads[nThread][TH_MTX],@aThreads)
        else
            aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),aThreads[nThread][TH_MTX],@aThreads)
        endif
        while (aThreads[nThread][TH_NUM]==NIL)
            if nMemMode==NIL
                aThreads[nThread][TH_NUM]:=hb_threadStart(@tbigNthRun(),aThreads[nThread][TH_MTX],@aThreads)
            else
                aThreads[nThread][TH_NUM]:=hb_threadStart(nMemMode,@tbigNthRun(),aThreads[nThread][TH_MTX],@aThreads)
            endif
        end while
    next nThread
return

procedure tBigNthNotify(aThreads)
    aEval(aThreads,{|ath,nTh|aThreads[nTh][TH_RES]:=NIL,aThreads[nTh][TH_END]:=.F.,hb_mutexNotify(ath[TH_MTX],nTh)})
return

procedure tBigNthWait(aThreads)
    local nThread
    local nThreads:=tBIGNaLen(aThreads)
    local nThCount:=0
    while .T.
        for nThread:=1 to nThreads
            if aThreads[nThread][TH_END]
                ++nThCount
            endif
        next nThread
        if nThCount==nThreads
            exit
        endif
        nThCount:=0
    end while
return

procedure tBigNthJoin(aThreads)
    aEval(aThreads,{|ath|hb_mutexNotify(ath[TH_MTX],{||break()}),if(.not.(ath[TH_NUM]==NIL),hb_threadJoin(ath[TH_NUM]),NIL)})
return

procedure tbigNthRun(mtxJob,aThreads)
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
                    exit
                endswitch
            endif
        end while
    end sequence
return

#pragma BEGINDUMP
    #include <hbapi.h>
    #include <hbdefs.h>
    #include <hbstack.h>
    #include <hbapiitm.h>
    HB_FUNC_STATIC( TBIGNALEN ){
       hb_retns(hb_arrayLen(hb_param(1,HB_IT_ARRAY)));
    }
#pragma ENDDUMP