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
    local oProcess:=MsNewProcess():New({||thProcess(oProcess)})
    oProcess:Activate()
return

static function thProcess(oProcess)
    Local nTotal
    Local nValor1
    Local nValor2
    Local nThread
    Local nThreads:=TST_MAXTHREAD
    Local oThread:=utThread():New(oProcess)    
    oThread:Start(nThreads)
    oProcess:SetRegua1(nThreads)
    oProcess:SetRegua2(0)
    For nThread:=1 To nThreads
        oProcess:IncRegua2()
        nValor1:=nThread
        nValor2:=(nThreads-nThread)
        if ((nThread%2)==0)
            oThread:setEvent(nThread,{"u_Sum1",nValor1,nValor2})
        else
            oThread:setEvent(nThread,"u_Sum1('"+NToS(nValor1)+"','"+NToS(nValor2)+"')")    
        endif
        oProcess:SetRegua1()
    Next nThread
    oThread:Notify()
    oThread:Wait()
    oThread:Join()
    aResults:=oThread:getAllResults(.T.)
    oThread:Finalize()
    nTotal:=0
    aEval(aResults,{|r,i|ConOut("Result Index["+NToS(i)+"]",r,Replicate("-",20)),nTotal+=Val(r)})
    ConOut("Total:",nTotal)
return

user function Sum1(xValor1,xValor2)
    local nValor1:=if(valType(xValor1)=="C",Val(xValor1),xValor1)
    local nValor2:=if(valType(xValor2)=="C",Val(xValor2),xValor2)
    //-----------------------------------------------------------
    //OBS.: NAO ESPERE QUE ESSA INFOMACAO SEJA IMPRESSA NA ORDEM
    //      AFINAL: MT
    ConOut(;
                Replicate("-",20),;
                "[ProcName(2)]",ProcName(2),;
                "[ProcName(1)]",ProcName(1),;
                "[ProcName(0)]",ProcName(),;
                "[ThreadID]",ThreadID(),;
                "[nValor1]",nValor1,;
                "[nValor2]",nValor2,;
                Replicate("-",20);
    )
return((nValor1+nValor2))
