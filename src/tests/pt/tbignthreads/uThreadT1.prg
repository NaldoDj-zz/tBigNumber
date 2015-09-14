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
    local bEvent
    local cTypeR
    local nVal1
    local nVal2
    local nNode
    local nTotal
    local nThread
    local nThreads:=TST_MAXTHREAD
    local nResult
    local nResults
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
        nVal1:=nThread
        nVal2:=(nThreads-nThread)
        if ((nThread%2)==0)
            oThread:setEvent(nThread,{"u_ThreadSum",nVal1,nVal2})
        else
            oThread:setEvent(nThread,"u_ThreadSum('"+NToS(nVal1)+"','"+NToS(nVal2)+"')")    
        endif
        oProcess:IncRegua1()
    next nThread
    oThread:Notify()
    oThread:Wait()
    oThread:Join()
    aResults:=oThread:getAllResults(.T.)
    oThread:Finalize()
    nNode:=0
    nTotal:=0
    nResults:=Len(aResults)
    bEvent={|r,i|if(;
                        (valType(r)=="A"),;
                        (++nNode,aEval(r,bEvent),--nNode),;
                        (;
                            ConOut(;
                                    "Result Index["+NToS(nResult)+"]"+if(nNode>0,"["+NToS(nNode)+"]["+NToS(i)+"]","["+NToS(i)+"]"),;
                                    if(valType(r)$"C|N",r,valType(r)),;
                                    Replicate("-",20);
                           ),;
                           nTotal+=if(valType(r)=="C",Val(r),if(valType(r)=="N",r,0));
                         );
                    );
    }
    oProcess:SetRegua1(nResults)
    oProcess:SetRegua2(nResults)
    for nResult:=1 to nResults
        oProcess:IncRegua2()
        cTypeR:=valType(aResults[nResult])
        if (cTypeR=="A")
            aEval(aResults[nResult],bEvent)
        else
            ConOut("Result Index["+NToS(nResult)+"]",aResults[nResult],Replicate("-",20))
            if (cTypeR=="C")
                nTotal+=Val(aResults[nResult])
            elseif (cTypeR=="N")
                nTotal+=aResults[nResult]
            endif
        endif    
        oProcess:IncRegua1()
    next nResult
    ConOut("Total:",nTotal)
return

#include "procredefine.prg"
