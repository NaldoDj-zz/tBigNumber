#include "tBigNumber.ch"

#define TST_MAXTHREAD 50

/*
    Funcao:ThreadT4
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:01/08/2015
    Descricao:Exemplo (4) de uso da Classe utThread (derivada de tBigNThread)
    Sintaxe:u_ThreadT4
*/
user procedure ThreadT4()
    local oProcess:=MsNewProcess():New({||thProcess(oProcess)})
    oProcess:Activate()
return

static function thProcess(oProcess)
    local aEvent
    local bEvent
    local cTypeR
    local nNode
    local nTotal
    local nValor1
    local nValor2
    local nThread
    local nResult
    local nResults
    local nThreads:=TST_MAXTHREAD
    local oThread:=utThread():New(oProcess)    
    oThread:Start(nThreads)
    oProcess:SetRegua1(nThreads)
    oProcess:SetRegua2(0)
    For nThread:=1 To nThreads
        oProcess:IncRegua2()
        nValor1:=nThread
        nValor2:=(nThreads-nThread)
        if ((nThread%9)==0)
            aEvent:={;
                        {{|n|u_Sum4(n[1],n[2])},nValor1,nValor2},;
                        {{|n|u_Sum4(n[1],n[2])},nValor1,nValor2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%8)==0)
            aEvent:={;
                        {|n|u_Sum4(n[1],n[2])},;
                        {;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2};
                        };
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%7)==0)
            aEvent:={;
                        {|n|u_Sum4(n[1],n[2])},nValor1,nValor2;
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%6)==0)
            oThread:setEvent(nThread,{||u_Sum4(n1,n2)})
        elseif ((nThread%5)==0)
            aEvent:={;
                        {"u_Sum4",nValor1,nValor2},;
                        {"u_Sum4",nValor1,nValor2},;
                        {"u_Sum4",nValor1,nValor2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%4)==0)
            aEvent:={;
                        "u_Sum4",;
                        {;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2};
                         };
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%3)==0)
            aEvent:={"u_Sum4",nValor1,nValor2}
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%2)==0)
            oThread:setEvent(nThread,"u_Sum4('"+NToS(nValor1)+"','"+NToS(nValor2)+"')")
        else
            aEvent:={(nValor1+nValor2)}
            oThread:setEvent(nThread,aEvent)
        endif
        oThread:Notify(nThread,.F.)
        while .not.(oThread:Notified(nThread))
            oProcess:IncRegua2()
        end while
        oProcess:SetRegua1()
        sleep(oThread:nSleep)
    Next nThread
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
    for nResult:=1 to nResults
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
    next nResult
    ConOut("Total:",nTotal)
return

user function Sum4(xValor1,xValor2)
    local nValor1:=if(valType(xValor1)=="C",Val(xValor1),xValor1)
    local nValor2:=if(valType(xValor2)=="C",Val(xValor2),xValor2)
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
