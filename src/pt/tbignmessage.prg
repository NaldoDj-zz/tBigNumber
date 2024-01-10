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
    class:tBigNMessage
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNMessage
    Sintaxe:tBigNMessage():New(nOutPut) -> self
*/
Class tBigNMessage

    data cOwner
    data nOutPut

    method function New(nOutPut) CONSTRUCTOR /*(/!\)*/

    method function OutPutMessage(xOutPut,nOutPut)
    method function ToInternal(cOutInternal)

EndClass

user function tBigNMessage(nOutPut)
return(tBigNMessage():New(@nOutPut))

method function New(nOutPut) class tBigNMessage
    PARAMTYPE 1 VAR nOutPut AS NUMBER OPTIONAL DEFAULT MSG_CONOUT
    self:cOwner:="MSG"
    self:nOutPut:=nOutPut
return(self)

method function OutPutMessage(xOutPut,nOutPut) class tBigNMessage

    local cCRLF      AS CHARACTER
    local cType      AS CHARACTER VALUE valType(xOutPut)
    local cOutPut    AS CHARACTER VALUE ""
    local cProcName  AS CHARACTER VALUE ProcName(1)
    local cProcName1 AS CHARACTER VALUE ProcName(2)

    PARAMTYPE 1 VAR xOutPut AS ARRAY,BLOCK,CHARACTER,DATE,NUMBER,LOGICAL,UNDEFINED
    PARAMTYPE 2 VAR nOutPut AS NUMBER OPTIONAL DEFAULT MSG_CONOUT

    try exception

        if .not.(nOutPut==MSG_LOG)
            if (cType=="A")
                ASSIGN cCRLF:=CRLF
                aEval(xOutPut,{|x|if((valType(x)=="C"),cOutPut+=(xOutPut[x]+cCRLF),cOutPut+=OutPutMessage(x,0))})
            else
                do case
                case (cType=="B")
                    cOutPut:=OutPutMessage(Eval(xOutPut),0)
                case (cType=="O")
                    cOutPut:=OutPutMessage(ClassDataArr(cType,.T.),0)
                otherwise
                    cOutPut:=cValToChar(xOutPut)
                endcase
            endif
            cOutPut:="["+self:cOwner+"]["+NToS(ThreadID())+"]["+cProcName1+"]["+NToS(ProcLine(1))+"]["+DToS(MsDate())+"]["+Time()+"]["+self:cOwner+"]"+cOutPut
        endif

        if (nOutPut==MSG_CONOUT)
            ConOut(cOutPut)
        elseIF (nOutPut==MSG_ALERT)
            ApMsgAlert(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_INFO)
            APMsgInfo(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_STOP)
            APMsgStop(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_INTERNAL)
            self:ToInternal(cOutPut)
        elseIF (nOutPut==MSG_HELP)
            Help("",1,cProcName,NIL,OemToAnsi(cOutPut),1,0)
        elseIF (nOutPut==MSG_LOG)
            if (valType(xOutPut)=="A")
                //TODO: Implementar
                ConOut(cOutPut)
            endif
        endif

    catch exception

        cOutPut:="[OutPutMessage: ERROR]"
        ConOut(cOutPut)

    end exception

Return(cOutPut)

method function ToInternal(cOutInternal) class tBigNMessage
    PARAMTYPE 1 VAR cOutInternal AS CHARACTER OPTIONAL DEFAULT ""
    PTInternal(1,cOutInternal)
    #IFDEF TOP
        TCInternal(1,cOutInternal)
    #ENDIF
Return(cOutInternal)

#include "tryexception.ch"
#include "paramtypex.ch"
