#include "tBigNumber.ch"

/*
    Funcao:ThreadSum
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:01/08/2015
    Descricao:Exemplo de uso da Classe utThread (derivada de tBigNThread)
    Sintaxe:u_ThreadSum(xVal1,xVal2)
*/
user function ThreadSum(xVal1,xVal2)
    local nD
    local nJ:=15000
    local nResult:=0
    local nVal1:=if(valType(xVal1)=="C",Val(xVal1),xVal1)
    local nVal2:=if(valType(xVal2)=="C",Val(xVal2),xVal2)
    ConOut(;
                Replicate("-",20),;
                "[ProcName(2)]",ProcName(2),;
                "[ProcName(1)]",ProcName(1),;
                "[ProcName(0)]",ProcName(),;
                "[ThreadID]",ThreadID(),;
                "[nVal1]",nVal1,;
                "[nVal2]",nVal2,;
                Replicate("-",20);
    )
    for nD:=1 to nJ
        if (ThreadQuit())
            OutPutMessage("ThreadQuitRequest..."+NToS(ThreadID()))
            exit
        endif
        nResult+=(nVal1+nVal2)
    next nD
return(nResult)

static function ThreadQuit()
    local lQuit:=.F.
    local lMTXJobThd:=(Type("__cMTXJobThd")=="C")
    local lMTXHdlThd:=(Type("__cMTXHdlThd")=="C")
    if (lMTXJobThd)
        lQuit:=.not.(xGetGlbValue(__cMTXJobThd)=="1")
    endif    
    if (lMTXHdlThd)
        lQuit:=(lQuit.or.(.not.(File(__cMTXHdlThd))))
    endif
return(lQuit)

#include "tBiGNCommon.prg"
