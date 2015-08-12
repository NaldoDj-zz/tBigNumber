#include "tBigNumber.ch"

#define TST_MAXTHREAD 15

/*
    Funcao:ThreadT1
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Exemplo (1) de uso da Classe utThread (derivada de tBigNThread)
    Sintaxe:u_ThreadT1
*/
user procedure ThreadT1()
    local bProc:={|lEnd,oProcess|ProcRedefine(@oProcess,NIL,0,250,250,.T.,.T.),thProcess(oProcess,lEnd)}
    local cProcD:=ProcName()
    local cProcT:="Processando Threads..."
    local oProcess:=MsNewProcess():New(bProc,cProcT,cProcD,.T.)
    oProcess:Activate()
return

static procedure thProcess(oProcess,lEnd)
    local nTotal
    local nValor1
    local nValor2
    local nThread
    local nThreads:=TST_MAXTHREAD
    local oThread:=utThread():New(NIL,oProcess)    
    oThread:Start(nThreads)
    oProcess:SetRegua1(nThreads)
    oProcess:SetRegua2(nThreads)
    for nThread:=1 To nThreads
        oProcess:IncRegua2()
        if (lEnd)
            oThread:QuitRequest()
            exit
        endif
        nValor1:=nThread
        nValor2:=(nThreads-nThread)
        if ((nThread%2)==0)
            oThread:setEvent(nThread,{"u_ThreadSum",nValor1,nValor2})
        else
            oThread:setEvent(nThread,"u_ThreadSum('"+NToS(nValor1)+"','"+NToS(nValor2)+"')")    
        endif
        oProcess:IncRegua1()
    next nThread
    oThread:Notify()
    oThread:Wait()
    oThread:Join()
    aResults:=oThread:getAllResults(.T.)
    oThread:Finalize()
    nTotal:=0
    aEval(aResults,{|r,i|ConOut("Result Index["+NToS(i)+"]",r,Replicate("-",20)),nTotal+=Val(r)})
    ConOut("Total:",nTotal)
return

#include "procredefine.prg"
