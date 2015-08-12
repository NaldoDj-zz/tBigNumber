#include "tbiconn.ch"
#include "tBigNumber.ch"

#define TST_MAXTHREAD 50

/*
    Funcao:ThreadT5
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:12/08/2015
    Descricao:Exemplo (5) de uso da Classe utThread (derivada de tBigNThread)
    Sintaxe:u_ThreadT5
*/
user procedure ThreadT5()
    local bProc:={|oProcess|ProcRedefine(@oProcess),thProcess(oProcess,@oProcess:lEnd)}
    local bonWInit:={||oProcess:=tNewProcess():New(@cProcD,@cProcT,@bProc,@cProcD,NIL,NIL,NIL,NIL,NIL,@lViewExecute,@lOneMeter),oMainWnd:End()}
    local cProcD:=ProcName()
    local cProcT:="Processando Threads..."
    Local lViewExecute:=.T.
    Local lOneMeter:=.F.
    local oProcess
    Private oMainWnd
    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"          
        SetBlind(.F.)
        DEFINE WINDOW oMainWnd FROM 000,000 TO 000,000 TITLE cProcT
        ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT Eval(bonWInit)
    RESET ENVIRONMENT
return

static procedure thProcess(oProcess,lEnd)
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
    local oThread:=utThread():New(NIL,oProcess)    
    oThread:Start(nThreads)
    oProcess:SetRegua1(nThreads)
    oProcess:SetRegua2(nThreads)
    For nThread:=1 To nThreads
        oProcess:IncRegua2()
        if (lEnd)
            oThread:QuitRequest()
            exit
        endif
        nValor1:=nThread
        nValor2:=(nThreads-nThread)
        if ((nThread%9)==0)
            aEvent:={;
                        {{|n|u_ThreadSum(n[1],n[2])},nValor1,nValor2},;
                        {{|n|u_ThreadSum(n[1],n[2])},nValor1,nValor2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%8)==0)
            aEvent:={;
                        {|n|u_ThreadSum(n[1],n[2])},;
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
                        {|n|u_ThreadSum(n[1],n[2])},nValor1,nValor2;
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%6)==0)
            oThread:setEvent(nThread,{||u_ThreadSum(n1,n2)})
        elseif ((nThread%5)==0)
            aEvent:={;
                        {"u_ThreadSum",nValor1,nValor2},;
                        {"u_ThreadSum",nValor1,nValor2},;
                        {"u_ThreadSum",nValor1,nValor2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%4)==0)
            aEvent:={;
                        "u_ThreadSum",;
                        {;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2},;
                            {nValor1,nValor2};
                         };
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%3)==0)
            aEvent:={"u_ThreadSum",nValor1,nValor2}
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%2)==0)
            oThread:setEvent(nThread,"u_ThreadSum('"+NToS(nValor1)+"','"+NToS(nValor2)+"')")
        else
            aEvent:={(nValor1+nValor2)}
            oThread:setEvent(nThread,aEvent)
        endif
        oThread:Notify(nThread,.F.)
        while .not.(oThread:Notified(nThread))
            oProcess:IncRegua2("Pending notification...")
        end while
        oProcess:IncRegua1()
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
