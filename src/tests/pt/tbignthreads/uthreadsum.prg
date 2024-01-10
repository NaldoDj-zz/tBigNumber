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
