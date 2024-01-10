/*
 * Copyright 2011-2024 Marinaldo de Jesus (blacktdn.com.br)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 * (or visit their website at https://www.gnu.org/licenses/).
 *
 */

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
    local bProc:={|lEnd,oProcess|ProcRedefine(@oProcess,NIL,0,250,250,.T.,.T.),thProcess(oProcess,lEnd)}
    local cProcD:=ProcName()
    local cProcT:="Processando Threads..."
    local oProcess:=MsNewProcess():New(bProc,cProcT,cProcD,.T.)
    oProcess:Activate()
return

static procedure thProcess(oProcess,lEnd)
    local aEvent
    local bEvent
    local cTypeR
    local nVal1
    local nVal2
    local nNode
    local nTotal
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
        nVal1:=nThread
        nVal2:=(nThreads-nThread)
        if ((nThread%9)==0)
            aEvent:={;
                        {{|n|u_ThreadSum(n[1],n[2])},nVal1,nVal2},;
                        {{|n|u_ThreadSum(n[1],n[2])},nVal1,nVal2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%8)==0)
            aEvent:={;
                        {|n|u_ThreadSum(n[1],n[2])},;
                        {;
                            {nVal1,nVal2},;
                            {nVal1,nVal2},;
                            {nVal1,nVal2},;
                            {nVal1,nVal2};
                        };
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%7)==0)
            aEvent:={;
                        {|n|u_ThreadSum(n[1],n[2])},nVal1,nVal2;
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%6)==0)
            oThread:setEvent(nThread,{||u_ThreadSum(n1,n2)})
        elseif ((nThread%5)==0)
            aEvent:={;
                        {"u_ThreadSum",nVal1,nVal2},;
                        {"u_ThreadSum",nVal1,nVal2},;
                        {"u_ThreadSum",nVal1,nVal2};
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%4)==0)
            aEvent:={;
                        "u_ThreadSum",;
                        {;
                            {nVal1,nVal2},;
                            {nVal1,nVal2},;
                            {nVal1,nVal2},;
                            {nVal1,nVal2};
                         };
            }
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%3)==0)
            aEvent:={"u_ThreadSum",nVal1,nVal2}
            oThread:setEvent(nThread,aEvent)
        elseif ((nThread%2)==0)
            oThread:setEvent(nThread,"u_ThreadSum('"+NToS(nVal1)+"','"+NToS(nVal2)+"')")
        else
            aEvent:={(nVal1+nVal2)}
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
