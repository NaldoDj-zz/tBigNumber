#include "tBigNumber.ch"

/*
    Funcao:ThreadSum
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:01/08/2015
    Descricao:Exemplo de uso da Classe utThread (derivada de tBigNThread)
    Sintaxe:u_ThreadSum(xValor1,xValor2)
*/
user function ThreadSum(xValor1,xValor2)
    local nD
    local nJ:=1500
    local nResult:=0
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
    for nD:=1 to nJ
        if (ThreadQuit())
            OutPutMessage("ThreadQuitRequest..."+NToS(ThreadID()))
            exit
        endif
        nResult+=(nValor1+nValor2)
    next nD
return(nResult)

static function ThreadQuit()
    local lQuit:=.F.
    local lMTXJobThd:=(Type("__cMTXJobThd")=="C")
    local lMTXHdlThd:=(Type("__cMTXHdlThd")=="C")
    if (lMTXJobThd)
        lQuit:=.not.(xGetGlbValue(__cMTXJobThd)=="1")
        OutPutMessage("QUIT:"+if(lQuit,".T.",".F.")+"|"+xGetGlbValue(__cMTXJobThd))
    endif    
    if (lMTXHdlThd)
        lQuit:=(lQuit.or.(.not.(File(__cMTXHdlThd))))
        OutPutMessage("QUIT:"+if(lQuit,".T.",".F.")+"|"+__cMTXHdlThd)
    endif
return(lQuit)

#include "tBiGNCommon.prg"
