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
    class:tBigNExecFromArray
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNExecFromArray
    Sintaxe:tBigNExecFromArray():New() -> self
*/
Class tBigNExecFromArray

    method function New() CONSTRUCTOR /*(/!\)*/

    method function ExecFromArray(xExec)

EndClass

user function tBigNExFArray()
return(tBigNExecFromArray():New())

method function New() class tBigNExecFromArray
return(self)

method function ExecFromArray(xExec,bError) class tBigNExecFromArray
return(ExecFromArray(xExec,bError))
static function ExecFromArray(xExec AS ARRAY,BLOCK,CHARACTER,LOGICAL,NUMBER,DATE,OBJECT,bError)
    local nD
    local nJ
    local aPrm
    local cTyp
    local lArr
    local nLen
    local xRet
    local xFun
    local xPrm
    PARAMTYPE 1 VAR xExec  AS ARRAY,BLOCK,CHARACTER,LOGICAL,NUMBER,DATE,OBJECT
    PARAMTYPE 2 VAR bError AS BLOCK OPTIONAL DEFAULT ErrorBlock()
    tryexception using bError
        cTyp:=valType(xExec)
        if .not.(cTyp=="A")
            xFun:=xExec
            do case
            case (cTyp=="B")
                xRet:=Eval(xFun)
            case (cTyp=="C")
                xRet:=&(xFun)
            otherwise
                xRet:=xFun
            end case
        elseif (Len(xExec)==1)
            xFun:=xExec[1]
            cTyp:=valType(xFun)
            do case
            case (cTyp=="A")
                xRet:=Array(0)
                aAdd(xRet,ExecFromArray(xFun,bError))
            case (cTyp=="B")
                xRet:=Eval(xFun)
            case (cTyp=="C")
                xRet:=&(xFun)
            otherwise
                xRet:=xFun
            end case
        else
            xFun:=xExec[1]
            cTyp:=valType(xFun)
            do case
            case (cTyp=="A")
                xRet:=Array(0)
                nJ:=Len(xExec)
                for nD:=1 to nJ
                    aPrm:=xExec[nD]
                    aAdd(xRet,ExecFromArray(aPrm,bError))
                next nD
            case (cTyp=="B")
                cTyp:=valType(xExec[2])
                if (cTyp=="A")
                    xRet:=Array(0)
                    nJ:=Len(xExec[2])
                    if (nJ>0)
                        lArr:=(valType(xExec[2][1])=="A")
                        if (lArr)
                            nLen:=Len(xExec[2][1])
                            for nD:=2 to nJ
                                lArr:=(lArr.and.(valType(xExec[2][nD])=="A"))
                                lArr:=(lArr.and.(Len(xExec[2][nD])==nLen))
                                if .not.(lArr)
                                    exit
                                endif
                            next nD
                        endif
                        if (lArr)
                            for nD:=1 to nJ
                                aPrm:=xExec[2][nD]
                                aAdd(xRet,Eval(xFun,aPrm))
                            next nD
                        else
                            aPrm:=xExec[2]
                            xRet:=Eval(xFun,aPrm)
                        endif
                    else
                        aPrm:=xExec[2]
                        xRet:=Eval(xFun,aPrm)
                    endif
                else
                    aPrm:=Array(0)
                    nJ:=Len(xExec)
                    for nD:=2 to nJ
                        aAdd(aPrm,xExec[nD])
                    next nD
                    xRet:=Eval(xFun,aPrm)
                 endif
            case (cTyp=="C")
                cTyp:=valType(xExec[2])
                if (cTyp=="A")
                    nJ:=Len(xExec[2])
                    if (nJ>0)
                        lArr:=(valType(xExec[2][1])=="A")
                        if (lArr)
                            nLen:=Len(xExec[2][1])
                            for nD:=2 to nJ
                                lArr:=(lArr.and.(valType(xExec[2][nD])=="A"))
                                lArr:=(lArr.and.(Len(xExec[2][nD])==nLen))
                                if .not.(lArr)
                                    exit
                                endif
                            next nD
                        endif
                        if (lArr)
                            xRet:=Array(0)
                            for nD:=1 to nJ
                                aPrm:=xExec[2][nD]
                                aAdd(xRet,&(ToExecFromArr(xFun,aPrm)))
                            next nD
                        else
                            aPrm:=xExec[2]
                            xRet:=&(ToExecFromArr(xFun,aPrm))
                        endif
                    else
                        aPrm:=xExec[2]
                        xRet:=&(ToExecFromArr(xFun,aPrm))
                    endif
                else
                    aPrm:=Array(0)
                    nJ:=Len(xExec)
                    for nD:=2 to nJ
                        aAdd(aPrm,xExec[nD])
                    next nD
                    xRet:=&(ToExecFromArr(xFun,aPrm))
                 endif
            otherwise
                xRet:=xExec
            end case
        endif
    end exception
return(xRet)

static function ToExecFromArr(cFun,aParameters)

    local nAt
    local nParam
    local nParameters

    DEFAULT cFun:=""

    if .not.(Empty(cFun))
        DEFAULT aParameters:=Array(0)
        _SetOwnerPrvt("__aParameters__",aParameters)
        cFun:=StrTran(cFun," ","")
        nParameters:=Len(__aParameters__)
        if ((nAt:=At("(",cFun))>0)
            cFun:=SubStr(cFun,1,nAt)
        else
            cFun+="("
        endif
        if (nParameters>0)
            for nParam:=1 to nParameters
                cFun+="@__aParameters__["+NToS(nParam)+"],"
            next nParam
            cFun:=SubStr(cFun,1,Len(cFun)-1)+")"
        else
            cFun+=")"
        endif
    endif

Return(cFun)

#include "paramtypex.ch"
#include "tryexception.ch"
