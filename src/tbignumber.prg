/*                                                                         
 *  t    bbbb   iiiii  ggggg  n   n  u   u  mm mm  bbbb   eeeee  rrrr     
 * ttt   b   b    i    g      nn  n  u   u  mm mm  b   b  e      r   r    
 *  t    bbbb     i    g ggg  n n n  u   u  m m m  bbbb   eeee   rrrr     
 *  t t  b   b    i    g   g  n  nn  u   u  m m m  b   b  e      r   r    
 *  ttt  bbbbb  iiiii  ggggg  n   n  uuuuu  m   m  bbbbb  eeeee  r   r    
 *
 * Copyright 2013-2014 Marinaldo de Jesus <marinaldo\/.\/jesus\/@\/blacktdn\/.\/com\/.\/br>
 * www - http://www.blacktdn.com.br
 *
 * Harbour Project license:
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.txt.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
 
#include "tBigNumber.ch"

#ifdef __PROTHEUS__
    Static __cEnvSrv
    #xtranslate hb_bLen([<prm,...>])   => Len([<prm>])
    #xtranslate tBIGNaLen([<prm,...>]) => Len([<prm>])
#else // __HARBOUR__
    #pragma -w3
    #require "hbvmmt"
    request HB_MT
    *#xtranslate PadL([<prm,...>])   => tBIGNPadL([<prm>])
    *#xtranslate PadR([<prm,...>])   => tBIGNPadR([<prm>])
    #xtranslate SubStr([<prm,...>])  => hb_bSubStr([<prm>])
    #xtranslate AT([<prm,...>])      => hb_bAT([<prm>])
#endif //__PROTHEUS__

#xcommand IncZeros(<n>);
=>;
While <n>\>__nstcZ0;;
    __cstcZ0+=__cstcZ0;;
    __nstcZ0+=__nstcZ0;;
End While;;

Static __o0
Static __o1
Static __o2
*Static __o5
Static __o10
Static __o20
Static __oMinFI
Static __oMinGCD
Static __nMinLCM
Static __cstcZ0
Static __nstcZ0
Static __cstcN9
Static __nstcN9
Static __lstbNSet
Static __nDivMeth

#ifdef TBN_ARRAY
    THREAD Static __aZAdd
    THREAD Static __aZSub
    THREAD Static __aZMult
#endif

#ifdef TBN_DBFILE
    THREAD Static __athdFiles
#endif

THREAD Static __nthRootAcc
THREAD Static __nSetDecimals

THREAD Static __eqoN1
THREAD Static __eqoN2

THREAD Static __gtoN1
THREAD Static __gtoN2

THREAD Static __ltoN1
THREAD Static __ltoN2

THREAD Static __cmpoN1
THREAD Static __cmpoN2

THREAD Static __adoNR
THREAD Static __adoN1
THREAD Static __adoN2

THREAD Static __sboNR
THREAD Static __sboN1
THREAD Static __sboN2

THREAD Static __mtoNR
THREAD Static __mtoN1
THREAD Static __mtoN2

THREAD Static __dvoNR
THREAD Static __dvoN1
THREAD Static __dvoN2
THREAD Static __dvoRDiv    

THREAD Static __pwoA
THREAD Static __pwoB
THREAD Static __pwoNP
THREAD Static __pwoNR
THREAD Static __pwoNT
THREAD Static __pwoGCD

#ifdef __PTCOMPAT__
THREAD Static __oeDivN
THREAD Static __oeDivD
#endif //__PTCOMPAT__
THREAD Static __oeDivR
THREAD Static __oeDivQ 
#ifdef __PTCOMPAT__
THREAD Static __oeDivDvQ
THREAD Static __oeDivDvR
#endif //__PTCOMPAT__

THREAD Static __oSysSQRT

THREAD Static __lsthdSet

#define RANDOM_MAX_EXIT            5
#define EXIT_MAX_RANDOM            50
#ifdef __PROTHEUS__
    #define MAX_LENGHT_ADD_THREAD   1000 //Achar o Melhor Valor para q seja compensador
#else
    #define MAX_LENGHT_ADD_THREAD   1000 //Achar o Melhor Valor para q seja compensador
#endif    

#define NTHROOT_EXIT        3
#define MAX_SYS_SQRT        "9999999999999999"

#define MAX_SYS_GCD         "999999999999999999"
#define MAX_SYS_LCM         "999999999999999999"

#define MAX_SYS_FI          "999999999999999999"

/*
*    Alternative Compile Options: /d
*
*    #ifdef __PROTHEUS__
*        /dTBN_ARRAY
*        /dTBN_DBFILE 
*        /d__TBN_DYN_OBJ_SET__ 
*        /d__ADDMT__
*        /d__SUBTMT__
*    #else //__HARBOUR__
*        /dTBN_ARRAY
*        /dTBN_DBFILE 
*        /dTBN_MEMIO 
*        /d__TBN_DYN_OBJ_SET__ 
*        /d__ADDMT__
*        /d__SUBTMT__
*        /d__PTCOMPAT__
*    #endif
*/

/*
    Class       : tBigNumber
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Instancia um novo objeto do tipo BigNumber
    Sintaxe     : tBigNumber():New(uBigN) -> self
*/
CLASS tBigNumber

#ifndef __PROTHEUS__
    #ifndef __TBN_DYN_OBJ_SET__
        #ifndef __ALT_D__
            PROTECTED:
        #endif
    #endif
#endif
    /* Keep in alphabetical order */
    DATA cDec  AS CHARACTER INIT "0"
    DATA cInt  AS CHARACTER INIT "0"
    DATA cRDiv AS CHARACTER INIT "0"
    DATA cSig  AS CHARACTER INIT ""
    DATA lNeg  AS LOGICAL   INIT .F. 
    DATA nBase AS NUMERIC   INIT 10
    DATA nDec  AS NUMERIC   INIT 1
    DATA nInt  AS NUMERIC   INIT 1
    DATA nSize AS NUMERIC   INIT 2

#ifndef __PROTHEUS__
    EXPORTED:
#endif    
    
    Method New(uBigN,nBase) CONSTRUCTOR /*( /!\ )*/

#ifndef __PROTHEUS__
    #ifdef TBN_DBFILE
        DESTRUCTOR tBigNGC
    #endif    
#endif    

    Method Normalize(oBigN)

    Method __cDec(cDec)   SETGET
    Method __cInt(cInt)   SETGET
    Method __cSig(cSig)   SETGET
    Method __lNeg(lNeg)   SETGET
    Method __nBase(nBase) SETGET
    Method __nDec(nDec)   SETGET
    Method __nInt(nInt)   SETGET 
    Method __nSize(nSize) SETGET

    Method Clone()
    Method ClassName()

    Method SetDecimals(nSet)

    Method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc)
    Method GetValue(lAbs,lObj)
    Method ExactValue(lAbs,lObj)

    Method Abs(lObj)
    
    Method Int(lObj,lSig)
    Method Dec(lObj,lSig,lNotZ)

    Method eq(uBigN)
    Method ne(uBigN)
    Method gt(uBigN)
    Method lt(uBigN)
    Method gte(uBigN)
    Method lte(uBigN)
    Method cmp(uBigN)
    
    Method Max(uBigN)
    Method Min(uBigN)
    
    Method Add(uBigN)
    Method Plus(uBigN) INLINE self:Add(uBigN)    
    
    Method Sub(uBigN)
    Method Minus(uBigN) INLINE self:Sub(uBigN)
    
    Method Mult(uBigN)
    Method Multiply(uBigN) INLINE self:Mult(uBigN)
    
    Method egMult(uBigN)
    Method egMultiply(uBigN) INLINE self:egMult(uBigN)
    
    Method Div(uBigN,lFloat)
    Method Divide(uBigN,lFloat) INLINE self:Div(uBigN,lFloat)
    Method DivMethod(nMethod)

    Method Mod(uBigN)

    Method Pow(uBigN)
    
    Method e(lForce)
    
    Method Exp(lForce)
    
    Method PI(lForce)    //TODO: Implementar o calculo.
   
    Method GCD(uBigN)
    Method LCM(uBigN)
    
    Method nthRoot(uBigN)
    Method nthRootPF(uBigN)
    Method nthRootAcc(nSet)

    Method SQRT()
    Method SysSQRT(uSet)

    Method Log(uBigNB)    //TODO: Validar Calculo.
    Method Log2()         //TODO: Validar Calculo.
    Method Log10()        //TODO: Validar Calculo.
    Method Ln()           //TODO: Validar Calculo.

    Method aLog(uBigNB)   //TODO: Validar Calculo.
    Method aLog2()        //TODO: Validar Calculo.
    Method aLog10()       //TODO: Validar Calculo.
    Method aLn()          //TODO: Validar Calculo.

    Method MathC(uBigN1,cOperator,uBigN2)
    Method MathN(uBigN1,cOperator,uBigN2)

    Method Rnd(nAcc)
    Method NoRnd(nAcc)
    Method Truncate(nAcc)
    Method Floor(nAcc)   //TODO: Verificar regra a partir de referencias bibliograficas.
    Method Ceiling(nAcc) //TODO: Verificar regra a partir de referencias bibliograficas.

    Method D2H(cHexB)
    Method H2D()

    Method H2B()
    Method B2H(cHexB)

    Method D2B(cHexB)
    Method B2D(cHexB)

    Method Randomize(uB,uE,nExit)

    Method millerRabin(uI)
    
    Method FI()
    
    Method PFactors()
    Method Factorial()    //TODO: Otimizar+
    
#ifndef __PROTHEUS__

         /* Operators Overloading:     
            "+"     = __OpPlus
             "-"     = __OpMinus
             "*"     = __OpMult
             "/"     = __OpDivide
             "%"     = __OpMod
             "^"     = __OpPower
             "**"    = __OpPower
             "++"    = __OpInc
             "--"    = __OpDec
             "=="    = __OpEqual
             "="     = __OpEqual (same as "==")
             "!="    = __OpNotEqual
             "<>"    = __OpNotEqual (same as "!=")
             "#"     = __OpNotEqual (same as "!=")
             "<"     = __OpLess
             "<="    = __OpLessEqual
             ">"     = __OpGreater
             ">="    = __OpGreaterEqual
             "$"     = __OpInstring
             "$$"    = __OpInclude
             "!"     = __OpNot
             ".NOT." = __OpNot (same as "!")
             ".AND." = __OpAnd
             ".OR."  = __OpOr
             ":="    = __OpAssign
             "[]"    = __OpArrayIndex
        */

/*(*)*/ /* OPERATORS NOT IMPLEMENTED: HB_APICLS.H, CLASSES.C AND HVM.C */

        OPERATOR "=="  ARG uBigN INLINE __OpEqual(self,uBigN)
        OPERATOR "="   ARG uBigN INLINE __OpEqual(self,uBigN)        //(same as "==")
        
        OPERATOR "!="  ARG uBigN INLINE __OpNotEqual(self,uBigN)
        OPERATOR "#"   ARG uBigN INLINE __OpNotEqual(self,uBigN)     //(same as "!=")
        OPERATOR "<>"  ARG uBigN INLINE __OpNotEqual(self,uBigN)     //(same as "!=")
        
        OPERATOR ">"   ARG uBigN INLINE __OpGreater(self,uBigN)
        OPERATOR ">="  ARG uBigN INLINE __OpGreaterEqual(self,uBigN)

        OPERATOR "<"   ARG uBigN INLINE __OpLess(self,uBigN)
        OPERATOR "<="  ARG uBigN INLINE __OpLessEqual(self,uBigN)

        OPERATOR "++"  INLINE __OpInc(self)
        OPERATOR "--"  INLINE __OpDec(self)
    
        OPERATOR "+"   ARG uBigN INLINE __OpPlus("+",self,uBigN)
/*(*)*/ OPERATOR "+="  ARG uBigN INLINE __OpPlus("+=",self,uBigN)

        OPERATOR "-"   ARG uBigN INLINE __OpMinus("-",self,uBigN)
/*(*)*/ OPERATOR "-="  ARG uBigN INLINE __OpMinus("-=",self,uBigN)
    
        OPERATOR "*"   ARG uBigN INLINE __OpMult("*",self,uBigN)
/*(*)*/ OPERATOR "*="  ARG uBigN INLINE __OpMult("*=",self,uBigN)

        OPERATOR "/"   ARGS uBigN,lFloat INLINE __OpDivide("/",self,uBigN,lFloat)
/*(*)*/ OPERATOR "/="  ARGS uBigN,lFloat INLINE __OpDivide("/=",self,uBigN,lFloat)
    
        OPERATOR "%"   ARG uBigN INLINE __OpMod("%",self,uBigN)
/*(*)*/ OPERATOR "%="  ARG uBigN INLINE __OpMod("%=",self,uBigN)

        OPERATOR "^"   ARG uBigN INLINE __OpPower("^",self,uBigN)
        OPERATOR "**"  ARG uBigN INLINE __OpPower("**",self,uBigN)     //(same as "^")

/*(*)*/ OPERATOR "^="  ARG uBigN INLINE __OpPower("^=",self,uBigN)
/*(*)*/ OPERATOR "**=" ARG uBigN INLINE __OpPower("**=",self,uBigN)    //(same as "^=")
    
        OPERATOR ":="  ARGS uBigN,nBase,cRDiv,lLZRmv,nAcc INLINE __OpAssign(self,uBigN,nBase,cRDiv,lLZRmv,nAcc)

#endif //__PROTHEUS__
                    
ENDCLASS

#ifndef __PROTHEUS__

    /* overloaded methods/functions */

    Static Function __OpEqual(oSelf,uBigN)
    Return(oSelf:eq(uBigN))
    
    Static Function __OpNotEqual(oSelf,uBigN)
    Return(oSelf:ne(uBigN))
    
    Static Function __OpGreater(oSelf,uBigN)
    Return(oSelf:gt(uBigN))
    
    Static Function __OpGreaterEqual(oSelf,uBigN)
    Return(oSelf:gte(uBigN))
    
    Static Function __OpLess(oSelf,uBigN)
    Return(oSelf:lt(uBigN))
    
    Static Function __OpLessEqual(oSelf,uBigN)
    Return(oSelf:lte(uBigN))
    
    Static Function __OpInc(oSelf)
    Return(oSelf:SetValue(oSelf:Add(__o1)))
    
    Static Function __OpDec(oSelf)
    Return(oSelf:SetValue(oSelf:Sub(__o1)))
    
    Static Function __OpPlus(cOp,oSelf,uBigN)
        Local oOpPlus
        IF cOp=="+="
            oOpPlus:=oSelf:SetValue(oSelf:Add(uBigN))
        Else
            oOpPlus:=oSelf:Add(uBigN)
        EndIF
    Return(oOpPlus)
    
    Static Function __OpMinus(cOp,oSelf,uBigN)
        Local oOpMinus
        IF cOp=="-="
            oOpMinus:=oSelf:SetValue(oSelf:Sub(uBigN))
        Else
            oOpMinus:=oSelf:Sub(uBigN)
        EndIF
    Return(oOpMinus)
    
    Static Function __OpMult(cOp,oSelf,uBigN)
        Local oOpMult
        IF cOp=="*="
            oOpMult:=oSelf:SetValue(oSelf:Mult(uBigN))    
        Else
            oOpMult:=oSelf:Mult(uBigN)
        EndIF
    Return(oOpMult)
    
    Static Function __OpDivide(cOp,oSelf,uBigN,lFloat)
        Local oOpDivide
        IF cOp=="/="
            oOpDivide:=oSelf:SetValue(oSelf:Div(uBigN,lFloat))            
        Else
            oOpDivide:=oSelf:Div(uBigN,lFloat)
        EndIF
    Return(oOpDivide)
    
    Static Function __OpMod(cOp,oSelf,uBigN)
        Local oOpMod
        IF cOp=="%="
            oOpMod:=oSelf:SetValue(oSelf:Mod(uBigN))    
        Else
            oOpMod:=oSelf:Mod(uBigN)
        EndIF
    Return(oOpMod)
    
    Static Function __OpPower(cOp,oSelf,uBigN)
        Local oOpPower
        switch cOp
            case "^="
            case "**="
                oOpPower:=oSelf:SetValue(oSelf:Pow(uBigN))
                exit
            otherwise
                oOpPower:=oSelf:Pow(uBigN)
        endswitch
    Return(oOpPower)
    
    Static Function __OpAssign(oSelf,uBigN,nBase,cRDiv,lLZRmv,nAcc)
    Return(oSelf:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))

#endif //__PROTHEUS__

/*
    Function    : tBigNumber():New
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Instancia um novo Objeto tBigNumber
    Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
#ifdef __PROTHEUS__
    User Function tBigNumber(uBigN,nBase)
    Return(tBigNumber():New(uBigN,nBase))
#endif

/*
    Method      : New
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : CONSTRUCTOR
    Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
Method New(uBigN,nBase) CLASS tBigNumber
    
    DEFAULT nBase:=10    
    self:nBase:=nBase

    // -------------------- assign THREAD STATIC values -------------------------
    IF __lsthdSet==NIL
        self:SetDecimals()
        self:nthRootAcc()
        __Initsthd(nBase)
    EndIF

    DEFAULT uBigN:="0"
    self:SetValue(uBigN,nBase)

     // -------------------- assign STATIC values --------------------------------
    IF __lstbNSet==NIL
        __InitstbN(nBase)
        self:DivMethod()
    EndIF

Return(self)

/*
    Method      : tBigNGC
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : DESTRUCTOR
*/
#ifdef TBN_DBFILE
    #ifdef __HARBOUR__
        Procedure tBigNGC() CLASS tBigNumber
    #else
        Static Procedure tBigNGC()
    #endif    
            Local nFile
            Local nFiles
            DEFAULT __athdFiles:=Array(0)
            nFiles:=tBIGNaLen(__athdFiles)
            For nFile:=1 To nFiles
                IF Select(__athdFiles[nFile][1])>0
                    (__athdFiles[nFile][1])->(dbCloseArea())
                EndIF            
                #ifdef __PROTEUS__
                    MsErase(__athdFiles[nFile][2],NIL,IF((Type("__LocalDriver")=="C"),__LocalDriver,"DBFCDXADS"))
                #else
                    #ifdef TBN_MEMIO
                        dbDrop(__athdFiles[nFile][2])
                    #else
                        fErase(__athdFiles[nFile][2])
                    #endif
                #endif    
            Next nFile
            aSize(__athdFiles,0)
        Return
#endif    

/*
    Method      : __cDec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cDec
    Sintaxe     : tBigNumber():__cDec() -> cDec
*/
Method __cDec(cDec) CLASS tBigNumber
    IF .NOT.(cDec==NIL)
        self:lNeg:=SubStr(cDec,1,1)=="-"
        IF self:lNeg
            cDec:=SubStr(cDec,2)
        EndIF
        self:cDec:=cDec
        self:nDec:=hb_bLen(cDec)
        self:nSize:=self:nInt+self:nDec
        IF self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        EndIF
    ENDIF
Return(self:cDec)

/*
    Method      : __cInt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cDec
    Sintaxe     : tBigNumber():__cInt() -> cInt
*/
Method __cInt(cInt) CLASS tBigNumber
    IF .NOT.(cInt==NIL)
        self:lNeg:=SubStr(cInt,1,1)=="-"
        IF self:lNeg
            cInt:=SubStr(cInt,2)
        EndIF
        self:cInt:=cInt
        self:nInt:=hb_bLen(cInt)
        self:nSize:=self:nInt+self:nDec
        IF self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        EndIF
    ENDIF
Return(self:cInt)

/*
    Method      : __cSig
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cSig
    Sintaxe     : tBigNumber():__cSig() -> cSig
*/
Method __cSig(cSig) CLASS tBigNumber
    IF .NOT.(cSig==NIL)
        self:cSig:=cSig 
        self:lNeg:=(cSig=="-")
        IF self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        EndIF
        IF .NOT.(self:lNeg)
            self:cSig:=""
        EndIF
    ENDIF
Return(self:cSig)

/*
    Method      : __lNeg
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __lNeg
    Sintaxe     : tBigNumber():__lNeg() -> lNeg
*/
Method __lNeg(lNeg) CLASS tBigNumber
    IF .NOT.(lNeg==NIL)
        self:lNeg:=lNeg
        IF self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        EndIF
        IF lNeg
            self:cSig:="-"    
        EndIF
    ENDIF
Return(self:lNeg)

/*
    Method      : __nBase
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nBase
    Sintaxe     : tBigNumber():__nBase() -> nBase
*/
Method __nBase(nBase) CLASS tBigNumber
    IF .NOT.(nBase==NIL)
        self:nBase:=nBase
    ENDIF
Return(self:nBase)

/*
    Method      : __nDec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nDec
    Sintaxe     : tBigNumber():__nDec() -> nDec
*/
Method __nDec(nDec) CLASS tBigNumber
    IF .NOT.(nDec==NIL)
        IF nDec>self:nDec
            self:cDec:=PadR(self:cDec,nDec,"0")
        Else
            self:cDec:=SubStr(self:cDec,1,nDec)
        EndIF
        self:nDec:=nDec
        self:nSize:=self:nInt+self:nDec
    ENDIF
Return(self:nDec)

/*
    Method      : __nInt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nInt
    Sintaxe     : tBigNumber():__nInt() -> nInt
*/
Method __nInt(nInt) CLASS tBigNumber
    IF .NOT.(nInt==NIL)
        IF nInt>self:nInt
            self:cInt:=PadL(self:cInt,nInt,"0")
            self:nInt:=nInt
            self:nSize:=self:nInt+self:nDec
        EndIF    
    ENDIF
Return(self:nInt)

/*
    Method      : __nSize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : nSize
    Sintaxe     : tBigNumber():__nSize() -> nSize
*/
Method __nSize(nSize) CLASS tBigNumber
    IF .NOT.(nSize==NIL)
        IF nSize>self:nInt+self:nDec
            IF self:nInt>self:nDec
                self:nInt:=nSize-self:nDec
                self:cInt:=PadL(self:cInt,self:nInt,"0")
            Else
                 self:nDec:=nSize-self:nInt
                 self:cDec:=PadR(self:cDec,self:nDec,"0")
            EndIF    
            self:nSize:=nSize
        EndIF
    ENDIF
Return(self:nSize)

/*
    Method      : Clone
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 27/03/2013
    Descricao   : Clone
    Sintaxe     : tBigNumber():Clone() -> oClone
*/
Method Clone() CLASS tBigNumber
    IF __lsthdSet==NIL
        Return(tBigNumber():New(self))
    EndIF
#ifdef __PROTHEUS__
Return(tBigNumber():New(self))
#else  //__HARBOUR__
Return(__objClone(self))
#endif //__PROTHEUS__    

/*
    Method      : ClassName
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : ClassName
    Sintaxe     : tBigNumber():ClassName() -> cClassName
*/
Method ClassName() CLASS tBigNumber
Return("TBIGNUMBER")

/*
    Method    : SetDecimals
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 04/02/2013
    Descricao : Setar o Numero de Casas Decimais
    Sintaxe   : tBigNumber():SetDecimals(nSet) -> nLastSet
*/
Method SetDecimals(nSet) CLASS tBigNumber

    Local nLastSet:=__nSetDecimals

    DEFAULT __nSetDecimals:=IF(nSet==NIL,32,nSet)
    DEFAULT nSet :=__nSetDecimals
    DEFAULT nLastSet:=nSet

    IF nSet>MAX_DECIMAL_PRECISION
        nSet:=MAX_DECIMAL_PRECISION
    EndIF

    __nSetDecimals:=nSet

Return(nLastSet)

/*
    Method      : nthRootAcc
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Setar a Precisao para nthRoot
    Sintaxe     : tBigNumber():nthRootAcc(nSet) -> nLastSet
*/
Method nthRootAcc(nSet) CLASS tBigNumber

    Local nLastSet:=__nthRootAcc

    DEFAULT __nthRootAcc:=IF(nSet==NIL,6,nSet)
    DEFAULT nSet:=__nthRootAcc
    DEFAULT nLastSet:=nSet

    IF nSet>MAX_DECIMAL_PRECISION
        nSet:=MAX_DECIMAL_PRECISION
    EndIF

    __nthRootAcc:=Min(self:SetDecimals()-1,nSet)

Return(nLastSet)

/*
    Method      : SetValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : SetValue
    Sintaxe     : tBigNumber():SetValue(uBigN,nBase,cRDiv,lLZRmv) -> self
*/
Method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc) CLASS tBigNumber

    Local cType:=ValType(uBigN)

    Local nFP

    #ifdef __TBN_DYN_OBJ_SET__
    Local nP
        #ifdef __HARBOUR__
            MEMVAR This
        #endif
        Private This
    #endif    

    IF cType=="O"
    
        DEFAULT cRDiv:=uBigN:cRDiv

        #ifdef __TBN_DYN_OBJ_SET__

            #ifdef __PROTHEUS__
    
                This:=self
                uBigN:=ClassDataArr(uBigN)
                nFP:=hb_bLen(uBigN)
                
                For nP:=1 To nFP
                    &("This:"+uBigN[nP][1]):=uBigN[nP][2]
                Next nP    
            
            #else
    
                __objSetValueList(self,__objGetValueList(uBigN))
    
            #endif    
            
        #else

            self:cDec:=uBigN:cDec
            self:cInt:=uBigN:cInt
            self:cRDiv:=uBigN:cRDiv
            self:cSig:=uBigN:cSig
            self:lNeg:=uBigN:lNeg
            self:nBase:=uBigN:nBase
            self:nDec:=uBigN:nDec
            self:nInt:=uBigN:nInt
            self:nSize:=uBigN:nSize
            
        #endif
    
    ElseIF cType=="A"

        DEFAULT cRDiv:=uBigN[3][2]
        
        #ifdef __TBN_DYN_OBJ_SET__

            This:=self
            nFP:=hb_bLen(uBigN)
    
            For nP:=1 To nFP
                &("This:"+uBigN[nP][1]):=uBigN[nP][2]
            Next nP    
        
        #else

            self:cDec:=uBigN[1][2]
            self:cInt:=uBigN[2][2]
            self:cRDiv:=uBigN[3][2]
            self:cSig:=uBigN[4][2]
            self:lNeg:=uBigN[5][2]
            self:nBase:=uBigN[6][2]
            self:nDec:=uBigN[7][2]
            self:nInt:=uBigN[8][2]
            self:nSize:=uBigN[9][2]
        
        #endif
    
    ElseIF cType=="C"

        While " " $ uBigN
            uBigN:=StrTran(uBigN," ","")    
        End While

        self:lNeg:=SubStr(uBigN,1,1)=="-"

        IF self:lNeg
            uBigN:=SubStr(uBigN,2)
            self:cSig:="-"
        Else
            self:cSig:=""
        EndIF

        nFP:=AT(".",uBigN)

        DEFAULT nBase:=self:nBase

        self:cInt:="0"
        self:cDec:="0"

        DO CASE
        CASE nFP==0
            self:cInt:=SubStr(uBigN,1)
            self:cDec:="0"
        CASE nFP==1
            self:cInt:="0"
            self:cDec:=SubStr(uBigN,nFP+1)
            IF "0"==SubStr(self:cDec,1,1)
                nFP:=hb_bLen(self:cDec)
                IncZeros(nFP)
                IF self:cDec==SubStr(__cstcZ0,1,nFP)
                    self:cDec:="0"
                EndIF
            EndIF    
        OTHERWISE
            self:cInt:=SubStr(uBigN,1,nFP-1)
            self:cDec:=SubStr(uBigN,nFP+1)
            IF "0"==SubStr(self:cDec,1,1)
                nFP:=hb_bLen(self:cDec)
                IncZeros(nFP)
                IF self:cDec==SubStr(__cstcZ0,1,nFP)
                    self:cDec:="0"
                EndIF
            EndIF    
        ENDCASE
        
        IF self:cInt=="0" .and. (self:cDec=="0".or.self:cDec=="")
            self:lNeg:=.F.
            self:cSig:=""
        EndIF
 
        self:nInt:=hb_bLen(self:cInt)
        self:nDec:=hb_bLen(self:cDec)
            
    EndIF

    IF self:cInt==""
        self:cInt:="0"
        self:nInt:=1
    EndIF

    IF self:cDec==""
        self:cDec:="0"
        self:nDec:=1
    EndIF
 
    IF Empty(cRDiv)
        cRDiv:="0"
    EndIF
    self:cRDiv:=cRDiv

    DEFAULT lLZRmv:=(self:nBase==10)
    IF lLZRmv
        While self:nInt>1 .and. SubStr(self:cInt,1,1)=="0"
            self:cInt:=SubStr(self:cInt,2)
            --self:nInt
        End While
    EndIF

    DEFAULT nAcc:=__nSetDecimals
    IF self:nDec>nAcc
        self:nDec:=nAcc
        self:cDec:=SubStr(self:cDec,1,self:nDec)
        IF self:cDec==""
            self:cDec:="0"
            self:nDec:=1
        EndIF
    EndIF
    
    self:nSize:=(self:nInt+self:nDec)

Return(self)

/*
    Method      : GetValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : GetValue
    Sintaxe     : tBigNumber():GetValue(lAbs,lObj) -> uNR
*/
Method GetValue(lAbs,lObj) CLASS tBigNumber

    Local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.
    
    uNR:=IF(lAbs,"",self:cSig)
    uNR+=self:cInt
    uNR+="."
    uNR+=self:cDec

    IF lObj
        uNR:=tBigNumber():New(uNR)
    EndIF

Return(uNR)        

/*
    Method      : ExactValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : ExactValue
    Sintaxe     : tBigNumber():ExactValue(lAbs) -> uNR
*/
Method ExactValue(lAbs,lObj) CLASS tBigNumber

    Local cDec

    Local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.

    uNR:=IF(lAbs,"",self:cSig)

    uNR+=self:cInt
    cDec:=self:Dec(NIL,NIL,self:nBase==10)

    IF .NOT.(cDec=="")
        uNR+="."
        uNR+=cDec
    EndIF

    IF lObj
        uNR:=tBigNumber():New(uNR)
    EndIF

Return(uNR)

/*
    Method      : Abs
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o Valor Absoluto de um Numero
    Sintaxe     : tBigNumber():Abs() -> uNR
*/
Method Abs(lObj) CLASS tBigNumber
Return(self:GetValue(.T.,lObj))

/*
    Method      : Int
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna a Parte Inteira de um Numero
    Sintaxe     : tBigNumber():Int(lObj,lSig) -> uNR
*/
Method Int(lObj,lSig) CLASS tBigNumber
    Local uNR
    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    uNR:=IF(lSig,self:cSig,"")+self:cInt
    IF lObj
        uNR:=tBigNumber():New(uNR)
    EndIF
Return(uNR)

/*
    Method      : Dec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna a Parte Decimal de um Numero
    Sintaxe     : tBigNumber():Dec(lObj,lSig,lNotZ) -> uNR
*/
Method Dec(lObj,lSig,lNotZ) CLASS tBigNumber

    Local cDec:=self:cDec
    
    Local nDec
    
    Local uNR

    DEFAULT lNotZ:=.F.
    IF lNotZ
        nDec:=self:nDec
        While SubStr(cDec,-1)=="0"
            cDec:=SubStr(cDec,1,--nDec)
        End While
    EndIF

    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    IF lObj
        uNR:=tBigNumber():New(IF(lSig,self:cSig,"")+"0."+cDec)
    Else
        uNR:=IF(lSig,self:cSig,"")+cDec
    EndIF

Return(uNR)

/*
    Method      : eq
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Compara se o valor corrente eh igual ao passado como parametro
    Sintaxe     : tBigNumber():eq(uBigN) -> leq
*/
Method eq(uBigN) CLASS tBigNumber

    Local leq

    __eqoN1:SetValue(self)
    __eqoN2:SetValue(uBigN)
 
    leq:=__eqoN1:lNeg==__eqoN2:lNeg
    IF leq
        __eqoN1:Normalize(@__eqoN2)
        #ifdef __PTCOMPAT__
            leq:=__eqoN1:GetValue(.T.)==__eqoN2:GetValue(.T.)
        #else
            leq:=tBIGNmemcmp(__eqoN1:GetValue(.T.),__eqoN2:GetValue(.T.))==0
        #endif    
    EndIF        

Return(leq)

/*
    Method      : ne
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh igual ao valor passado como parametro
    Sintaxe     : tBigNumber():ne(uBigN) -> .NOT.(leq)
*/
Method ne(uBigN) CLASS tBigNumber
Return(.NOT.(self:eq(uBigN)))

/*
    Method      : gt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh maior que o valor passado como parametro
    Sintaxe     : tBigNumber():gt(uBigN) -> lgt
*/
Method gt(uBigN) CLASS tBigNumber

    Local lgt

    __gtoN1:SetValue(self)
    __gtoN2:SetValue(uBigN)
    
    IF __gtoN1:lNeg .or. __gtoN2:lNeg
        IF __gtoN1:lNeg .and. __gtoN2:lNeg
            __gtoN1:Normalize(@__gtoN2)
            #ifdef __PTCOMPAT__
                lgt:=__gtoN1:GetValue(.T.)<__gtoN2:GetValue(.T.)
            #else
                lgt:=tBIGNmemcmp(__gtoN1:GetValue(.T.),__gtoN2:GetValue(.T.))==-1
            #endif    
        ElseIF __gtoN1:lNeg .and. .NOT.(__gtoN2:lNeg)
            lgt:=.F.
        ElseIF .NOT.(__gtoN1:lNeg) .and. __gtoN2:lNeg
            lgt:=.T.
        EndIF
    Else
        __gtoN1:Normalize(@__gtoN2)
        #ifdef __PTCOMPAT__
            lgt:=__gtoN1:GetValue(.T.)>__gtoN2:GetValue(.T.)
        #else
            lgt:=tBIGNmemcmp(__gtoN1:GetValue(.T.),__gtoN2:GetValue(.T.))==1
        #endif    
    EndIF 

Return(lgt)

/*
    Method      : lt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh menor que o valor passado como parametro
    Sintaxe     : tBigNumber():lt(uBigN) -> llt
*/
Method lt(uBigN) CLASS tBigNumber
   
    Local llt

    __ltoN1:SetValue(self)
    __ltoN2:SetValue(uBigN)
    
    IF __ltoN1:lNeg .or. __ltoN2:lNeg
        IF __ltoN1:lNeg .and. __ltoN2:lNeg
            __ltoN1:Normalize(@__ltoN2)
            #ifdef __PTCOMPAT__
                llt:=__ltoN1:GetValue(.T.)>__ltoN2:GetValue(.T.)
            #else
                llt:=tBIGNmemcmp(__ltoN1:GetValue(.T.),__ltoN2:GetValue(.T.))==1
            #endif    
        ElseIF __ltoN1:lNeg .and. .NOT.(__ltoN2:lNeg)
            llt:=.T.
        ElseIF .NOT.(__ltoN1:lNeg) .and. __ltoN2:lNeg
            llt:=.F.
        EndIF
    Else
        __ltoN1:Normalize(@__ltoN2)
        #ifdef __PTCOMPAT__
            llt:=__ltoN1:GetValue(.T.)<__ltoN2:GetValue(.T.)
        #else
            llt:=tBIGNmemcmp(__ltoN1:GetValue(.T.),__ltoN2:GetValue(.T.))==-1
        #endif    
    EndIF    

Return(llt)

/*
    Method      : gte
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh maior ou igual ao valor passado como parametro
    Sintaxe     : tBigNumber():gte(uBigN) -> lgte
*/
Method gte(uBigN) CLASS tBigNumber
Return(self:cmp(uBigN)>=0)

/*
    Method      : lte
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh menor ou igual ao valor passado como parametro
    Sintaxe     : tBigNumber():lte(uBigN) -> lte
*/
Method lte(uBigN) CLASS tBigNumber
Return(self:cmp(uBigN)<=0)

/*
    Method      : cmp
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 11/03/2014
    Descricao   : Compara self com valor passado como parametro e retorna:
                  -1 : self < que valor de referencia;
                   0 : self = valor de referencia;
                   1 : self > que valor de referencia;
    Sintaxe     : tBigNumber():cmp(uBigN) -> nCmp
*/
Method cmp(uBigN) CLASS tBigNumber

    Local nCmp
    Local iCmp
    
    Local llt
    Local leq
    
    __cmpoN1:SetValue(self)
    __cmpoN2:SetValue(uBigN)
    
#ifdef __PTCOMPAT__
    __cmpoN1:Normalize(@__cmpoN2)
#endif
    
    leq:=__cmpoN1:lNeg==__cmpoN2:lNeg
    IF leq
        #ifndef __PTCOMPAT__    
            __cmpoN1:Normalize(@__cmpoN2)
        #endif        
        #ifdef __PTCOMPAT__
            iCmp:=IF(__cmpoN1:GetValue(.T.)==__cmpoN2:GetValue(.T.),0,NIL)
        #else
            iCmp:=tBIGNmemcmp(__cmpoN1:GetValue(.T.),__cmpoN2:GetValue(.T.))
        #endif
        leq:=iCmp==0
    EndIF    

    IF leq
        nCmp:=0    
    Else
        IF __cmpoN1:lNeg .or. __cmpoN2:lNeg
            IF __cmpoN1:lNeg .and. __cmpoN2:lNeg
                IF iCmp==NIL
                    #ifndef __PTCOMPAT__
                        __cmpoN1:Normalize(@__cmpoN2)
                    #endif    
                    #ifdef __PTCOMPAT__
                        iCmp:=IF(__cmpoN1:GetValue(.T.)>__cmpoN2:GetValue(.T.),1,-1)
                    #else
                        iCmp:=tBIGNmemcmp(__cmpoN1:GetValue(.T.),__cmpoN2:GetValue(.T.))
                    #endif    
                EndIF
                llt:=iCmp==1
            ElseIF __cmpoN1:lNeg .and. .NOT.(__cmpoN2:lNeg)
                llt:=.T.
            ElseIF .NOT.(__cmpoN1:lNeg) .and. __cmpoN2:lNeg
                llt:=.F.
            EndIF
        Else
            llt:=iCmp==-1
        EndIF
        IF llt
            nCmp:=-1
        Else
            nCmp:=1
        EndIF
    EndIF
    
Return(nCmp)

/*
    Method      : Max
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o maior valor entre o valor corrente e o valor passado como parametro
    Sintaxe     : tBigNumber():Max(uBigN) -> oMax
*/
Method Max(uBigN) CLASS tBigNumber
    Local oMax:=tBigNumber():New(uBigN)
    IF self:gt(oMax)
        oMax:SetValue(self)
    EndIF
Return(oMax)

/*
    Method      : Min
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o menor valor entre o valor corrente e o valor passado como parametro
    Sintaxe     : tBigNumber():Min(uBigN) -> oMin
*/
Method Min(uBigN) CLASS tBigNumber
    Local oMin:=tBigNumber():New(uBigN)
    IF self:lt(oMin)
        oMin:SetValue(self)
    EndIF
Return(oMin)

/*
    Method      : Add
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Soma
    Sintaxe     : tBigNumber():Add(uBigN) -> oBigNR
*/
Method Add(uBigN) CLASS tBigNumber

    Local cInt        
    Local cDec        

    Local cN1
    Local cN2
    Local cNT

    Local lNeg         
    Local lInv
    Local lAdd:=.T.

    Local nDec        
    Local nSize     

    __adoN1:SetValue(self)
    __adoN2:SetValue(uBigN)
    
    __adoN1:Normalize(@__adoN2)

    nDec:=__adoN1:nDec
    nSize:=__adoN1:nSize

    cN1:=__adoN1:cInt
    cN1+=__adoN1:cDec

    cN2:=__adoN2:cInt
    cN2+=__adoN2:cDec

    lNeg:=(__adoN1:lNeg .and. .NOT.(__adoN2:lNeg)) .or. (.NOT.(__adoN1:lNeg) .and. __adoN2:lNeg)

    IF lNeg
        lAdd:=.F.
        lInv:=cN1<cN2
        lNeg:=(__adoN1:lNeg .and. .NOT.(lInv)) .or. (__adoN2:lNeg .and. lInv)
        IF lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        EndIF
    Else
        lNeg:=__adoN1:lNeg
    EndIF

    IF lAdd
        #ifdef __ADDMT__
            IF nSize>MAX_LENGHT_ADD_THREAD .and. Int(nSize/MAX_LENGHT_ADD_THREAD)>=2
                __adoNR:SetValue(AddThread(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
            Else
                __adoNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
            EndIF
        #else
            __adoNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
        #endif
    Else
        #ifdef __SUBMT__
            __adoNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
        #else
            __adoNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
        #endif
    EndIF

    cNT:=__adoNR:cInt
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    __adoNR:SetValue(cNT)

    IF lNeg
        IF  __adoNR:gt(__o0)
            __adoNR:cSig:="-"
            __adoNR:lNeg:=lNeg
        EndIF
    EndIF

Return(__adoNR:Clone())

#ifdef __ADDMT__

    /*/
        Function  : AddThread
        Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data      : 25/02/2013
        Descricao : ADD via JOB
        Sintaxe   : AddThread(oN1,oN2)
    /*/
    Static Function AddThread(cN1,cN2,nSize,nBase)
    
        Local aNR

        Local cNR
        Local cT1
        Local cT2

        Local aThreads

    #ifdef __PROTHEUS__
        Local cGlbV
        Local cThread:=hb_ntos(ThreadID())
    #endif    

        Local lAdd1

    #ifdef __PROTHEUS__
        Local nNR
        Local lExit
    #endif

        Local nID

    #ifdef __PROTHEUS__
        Local nIDs
        Local n
        Local t
    #endif        

        Local w
        Local x
        Local y:=Mod(nSize,MAX_LENGHT_ADD_THREAD)
        Local z
    
        BEGIN SEQUENCE

            lAdd1:=(y>0)
            
            IF (lAdd1)
                cT1:=SubStr(cN1,1,y)
                cT2:=SubStr(cN2,1,y)
                y:=1
            EndIF

            aNR:=Array(Int(nSize/MAX_LENGHT_ADD_THREAD)+y,5)
            
            IF (lAdd1)
                aNR[1][2]:=cT1
                aNR[1][3]:=cT2
                x:=2
                y:=hb_bLen(cT1)+1
                cT1:=SubStr(cN1,y)
                cT2:=SubStr(cN2,y)
            Else
                x:=1
                cT1:=cN1
                cT2:=cN2
            EndIF

            z:=1
            y:=tBIGNaLen(aNR)
            
            For x:=x To y
                aNR[x][2]:=SubStr(cT1,z,MAX_LENGHT_ADD_THREAD)
                aNR[x][3]:=SubStr(cT2,z,MAX_LENGHT_ADD_THREAD)
                z+=MAX_LENGHT_ADD_THREAD
            Next x
            
            z:=0

            aThreads:=Array(0)

            For x:=1 TO y

                #ifdef __PROTHEUS__
                    lExit:=KillApp()
                    IF lExit
                        EXIT
                    EndIF
                #endif    
            
                ++z

                nID:=x
    
                aNR[nID][1]:=.F.

                #ifdef __HARBOUR__
                    aNR[nID][4]:=hb_threadStart(@ThAdd(),aNR[nID][2],aNR[nID][3],hb_bLen(aNR[nID][2]),nBase)
                    aNR[nID][5]:=Array(0)
                    hb_threadJoin(aNR[nID][4],@aNR[nID][5])
                    aAdd(aThreads,aNR[nID][4])
                #else //__PROTHEUS__
                    aNR[nID][4]:=("__ADD__"+"ThAdd__"+cThread+"__ID__"+hb_ntos(nID))
                    PutGlbValue(aNR[nID][4],"")
                    StartJob("U_ThAdd",__cEnvSrv,.F.,aNR[nID][2],aNR[nID][3],hb_bLen(aNR[nID][2]),nBase,aNR[nID][4])
                    aAdd(aThreads,nID)
                #endif //__HARBOUR__

                IF z==y .or. Mod(z,5)==0
                    
                    #ifdef __HARBOUR__
                    
                        hb_threadWait(aThreads)

                    #else //__PROTHEUS__

                        t:=tBIGNaLen(aThreads)
                        nIDs:=t
    
                        While .NOT.(lExit)
                        
                            lExit:=lExit .or. KillApp()
                            IF lExit
                                EXIT
                            EndIF
    
                            nNR:=0

                            For n:=1 To t
                                
                                nID:=aThreads[n]
            
                                IF .NOT.(aNR[nID][1])
                
                                    cGlbV:=GetGlbValue(aNR[nID][4])
                                    
                                    IF .NOT.(cGlbV=="")
                    
                                        aNR[nID][1]:=.T.
                                        aNR[nID][5]:=cGlbV
                        
                                        cGlbV:=NIL
                
                                        ClearGlbValue(aNR[nID][4])
                
                                        lExit:=++nNR==nIDs
                                                                                          
                                        IF lExit
                                            EXIT
                                        EndIF
                
                                    EndIF
                
                                Else
                
                                    lExit:=++nNR==nIDs
                
                                    IF lExit
                                        EXIT
                                    EndIF
                            
                                EndIF
                
                            Next i
                
                            IF lExit
                                EXIT
                            EndIF
    
                        End While
    
                    #endif    //__HARBOUR__

                    aSize(aThreads,0)

                EndIF

            Next x

            For x:=y To 1 STEP -1
                z:=x-1
                cT1:=aNR[x][5]
                IF z>0 .and. hb_bLen(cT1)>MAX_LENGHT_ADD_THREAD
                    cT2:=SubStr(cT1,1,1)
                    cT1:=SubStr(cT1,2)
                    IF cT2<>"0"
                        w:=hb_bLen(aNR[z][5])
                        cT2:=Add(aNR[z][5],PadL(cT2,w,"0"),w,nBase)
                        aNR[z][5]:=IF(SubStr(cT2,1,1)=="0",SubStr(cT2,2),cT2)
                    EndIF
                    aNR[x][5]:=cT1
                EndIF
            Next x

            cNR:=""
            For x:=1 To y
                cNR+=aNR[x][5]
            Next x

        END SEQUENCE
    
    Return(cNR)

    #ifdef __PROTHEUS__
        User Function ThAdd(cN1,cN2,nSize,nBase,cID)
            PTInternal(1,"[tBigNumber][ADD][U_THADD]["+cID+"][CALC]["+cN1+"+"+cN2+"]")
                PutGlbValue(cID,Add(cN1,cN2,nSize,nBase))
            PTInternal(1,"[tBigNumber][ADD][U_THADD]["+cID+"][END]["+cN1+"+"+cN2+"]")
            tBigNGC()
        Return(.T.)
    #else
        Static Function ThAdd(cN1,cN2,nSize,nBase)
        Return(Add(cN1,cN2,nSize,nBase))
    #endif

#endif

/*
    Method      : Sub
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Soma
    Sintaxe     : tBigNumber():Sub(uBigN) -> oBigNR
*/
Method Sub(uBigN) CLASS tBigNumber

    Local cInt        
    Local cDec        

    Local cN1     
    Local cN2     
    Local cNT         

    Local lNeg        
    Local lInv        
    Local lSub:=.T.

    Local nDec        
    Local nSize     

    __sboN1:SetValue(self)
    __sboN2:SetValue(uBigN)
    
    __sboN1:Normalize(@__sboN2)
    
    nDec:=__sboN1:nDec
    nSize:=__sboN1:nSize

    cN1:=__sboN1:cInt
    cN1+=__sboN1:cDec

    cN2:=__sboN2:cInt
    cN2+=__sboN2:cDec

    lNeg:=(__sboN1:lNeg .and. .NOT.(__sboN2:lNeg)) .or. (.NOT.(__sboN1:lNeg) .and. __sboN2:lNeg)

    IF lNeg
        lSub:=.F.
        lNeg:=__sboN1:lNeg
    Else
        lInv:=cN1<cN2
        lNeg:=__sboN1:lNeg .or. lInv
        IF lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        EndIF
    EndIF

    IF lSub
        #ifdef __SUBMT__
            __sboNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
        #else
            __sboNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
        #endif
    Else
        #ifdef __ADDMT__
            IF nSize>MAX_LENGHT_ADD_THREAD .and. Int(nSize/MAX_LENGHT_ADD_THREAD)>=2
                __sboNR:SetValue(AddThread(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
            Else
                __sboNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
            EndIF
        #else
            __sboNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)            
        #endif
    EndIF

    cNT:=__sboNR:cInt
    
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
    
    cNT:=cInt
    cNT+="."
    cNT+=cDec
    
    __sboNR:SetValue(cNT)

    IF lNeg
        IF __sboNR:gt(__o0)
            __sboNR:cSig:="-"
            __sboNR:lNeg:=lNeg
        EndIF
    EndIF

Return(__sboNR:Clone())

/*
    Method      : Mult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao 
    Sintaxe     : tBigNumber():Mult(uBigN) -> oBigNR
*/
Method Mult(uBigN) CLASS tBigNumber

    Local cInt
    Local cDec

    Local cN1
    Local cN2
    Local cNT

    Local lNeg    
    Local lNeg1 
    Local lNeg2 

    Local nDec    
    Local nSize 

    __mtoN1:SetValue(self)
    __mtoN2:SetValue(uBigN)
    
    __mtoN1:Normalize(@__mtoN2)

    nDec:=__mtoN1:nDec*2
    nSize:=__mtoN1:nSize

    lNeg1:=__mtoN1:lNeg
    lNeg2:=__mtoN2:lNeg    
    lNeg:=(lNeg1 .and. .NOT.(lNeg2)) .or. (.NOT.(lNeg1) .and. lNeg2)

    cN1:=__mtoN1:cInt
    cN1+=__mtoN1:cDec

    cN2:=__mtoN2:cInt
    cN2+=__mtoN2:cDec

    __mtoNR:SetValue(Mult(cN1,cN2,nSize,self:nBase),self:nBase,NIL,.F.)

    cNT:=__mtoNR:cInt
    
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
    
    cNT:=cInt
    cNT+="."
    cNT+=cDec
    
    __mtoNR:SetValue(cNT)
    
    cNT:=__mtoNR:ExactValue()
    
    __mtoNR:SetValue(cNT)

    IF lNeg
        IF __mtoNR:gt(__o0)
            __mtoNR:cSig:="-"
            __mtoNR:lNeg:=lNeg
        EndIF
    EndIF

Return(__mtoNR:Clone())

/*
    Method      : egMult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao Egipcia
    Sintaxe     : tBigNumber():egMult(uBigN) -> oBigNR
*/
Method egMult(uBigN) CLASS tBigNumber

    Local cInt
    Local cDec

    Local cN1
    Local cN2
    Local cNT

    Local lNeg    
    Local lNeg1 
    Local lNeg2 

    Local nDec    

    __mtoN1:SetValue(self)
    __mtoN2:SetValue(uBigN)
    
    __mtoN1:Normalize(@__mtoN2)

    nDec:=__mtoN1:nDec*2
  
    lNeg1:=__mtoN1:lNeg
    lNeg2:=__mtoN2:lNeg    
    lNeg:=(lNeg1 .and. .NOT.(lNeg2)) .or. (.NOT.(lNeg1) .and. lNeg2)

    cN1:=__mtoN1:cInt
    cN1+=__mtoN1:cDec

    cN2:=__mtoN2:cInt
    cN2+=__mtoN2:cDec

    __mtoNR:SetValue(egMult(cN1,cN2,self:nBase),self:nBase,NIL,.F.)

    cNT:=__mtoNR:cInt
    
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
    
    cNT:=cInt
    cNT+="."
    cNT+=cDec
    
    __mtoNR:SetValue(cNT)
    
    cNT:=__mtoNR:ExactValue()
    
    __mtoNR:SetValue(cNT)

    IF lNeg
        IF __mtoNR:gt(__o0)
            __mtoNR:cSig:="-"
            __mtoNR:lNeg:=lNeg
        EndIF
    EndIF

Return(__mtoNR:Clone())

/*
    Method      : Div
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Divisao
    Sintaxe     : tBigNumber():Div(uBigN,lFloat) -> oBigNR
*/
Method Div(uBigN,lFloat) CLASS tBigNumber

    Local cDec
    
    Local cN1
    Local cN2
    Local cNR

    Local lNeg    
    Local lNeg1 
    Local lNeg2
    
    Local nAcc:=__nSetDecimals
    Local nDec
    
    BEGIN SEQUENCE

        IF __o0:eq(uBigN)
            __dvoNR:SetValue(__o0)
            BREAK
        EndIF

        __dvoN1:SetValue(self)
        __dvoN2:SetValue(uBigN)
        
        __dvoN1:Normalize(@__dvoN2)
    
        lNeg1:=__dvoN1:lNeg
        lNeg2:=__dvoN2:lNeg    
        lNeg:=(lNeg1 .and. .NOT.(lNeg2)) .or. (.NOT.(lNeg1) .and. lNeg2)
    
        cN1:=__dvoN1:cInt
        cN1+=__dvoN1:cDec
    
        cN2:=__dvoN2:cInt
        cN2+=__dvoN2:cDec

        DEFAULT lFloat:=.T.

        IF __nDivMeth==2
            __dvoNR:SetValue(ecDiv(cN1,cN2,__dvoN1:nSize,__dvoN1:nBase,nAcc,lFloat))
        Else
            __dvoNR:SetValue(egDiv(cN1,cN2,__dvoN1:nSize,__dvoN1:nBase,nAcc,lFloat))
        EndIF    

        IF lFloat

            __dvoRDiv:SetValue(__dvoNR:cRDiv,NIL,NIL,.F.)
        
            IF __dvoRDiv:gt(__o0)
    
                cDec:=""
        
                __dvoN2:SetValue(cN2)
        
                While __dvoRDiv:lt(__dvoN2)
                    __dvoRDiv:cInt+="0"
                    __dvoRDiv:nInt++
                    __dvoRDiv:nSize++
                    IF __dvoRDiv:lt(__dvoN2)
                        cDec+="0"
                    EndIF
                End While
        
                While __dvoRDiv:gte(__dvoN2)
                    
                    __dvoRDiv:Normalize(@__dvoN2)
            
                    cN1:=__dvoRDiv:cInt
                    cN1+=__dvoRDiv:cDec
        
                    cN2:=__dvoN2:cInt
                    cN2+=__dvoN2:cDec

                    IF __nDivMeth==2
                        __dvoRDiv:SetValue(ecDiv(cN1,cN2,__dvoRDiv:nSize,__dvoRDiv:nBase,nAcc,lFloat))
                    Else
                        __dvoRDiv:SetValue(egDiv(cN1,cN2,__dvoRDiv:nSize,__dvoRDiv:nBase,nAcc,lFloat))
                    EndIF

                    cDec+=__dvoRDiv:ExactValue(.T.)
                    nDec:=hb_bLen(cDec)
        
                    __dvoRDiv:SetValue(__dvoRDiv:cRDiv,NIL,NIL,.F.)
                    __dvoRDiv:SetValue(__dvoRDiv:ExactValue(.T.))

                    IF __dvoRDiv:eq(__o0) .or. nDec>=nAcc
                        EXIT
                    EndIF
        
                    __dvoN2:SetValue(cN2)        
                    
                    While __dvoRDiv:lt(__dvoN2)
                        __dvoRDiv:cInt+="0"
                        __dvoRDiv:nInt++
                        __dvoRDiv:nSize++
                        IF __dvoRDiv:lt(__dvoN2)
                            cDec+="0"
                        EndIF
                    End While
                
                End While
        
                cNR:=__dvoNR:__cInt()
                cNR+="."
                cNR+=SubStr(cDec,1,nAcc)
        
                __dvoNR:SetValue(cNR,NIL,__dvoRDiv:ExactValue(.T.))
    
            EndIF
    
        EndIF
    
        IF lNeg
            IF __dvoNR:gt(__o0)
                __dvoNR:cSig:="-"
                __dvoNR:lNeg:=lNeg
            EndIF
        EndIF

    End Sequence

Return(__dvoNR:Clone())

/*
    Method      : DivMethod
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 24/03/2014
    Descricao   : Setar o metodo de Divisao a ser utilizado
    Sintaxe     : tBigNumber():DivMethod(nMethod) -> nLstMethod
*/
Method DivMethod(nMethod) CLASS tBigNumber
    Local nLstMethod
    DEFAULT __nDivMeth:= 1
    DEFAULT nMethod:= __nDivMeth
    nLstMethod:= __nDivMeth
    __nDivMeth:=nMethod
Return(nLstMethod)

/*
    Method      : Mod
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2013
    Descricao   : Resto da Divisao
    Sintaxe     : tBigNumber():Mod(uBigN) -> oMod
*/
Method Mod(uBigN) CLASS tBigNumber
    Local oMod:=tBigNumber():New(uBigN)
    Local nCmp:=self:cmp(oMod)
    IF nCmp==-1
        oMod:SetValue(self)
    ElseIF nCmp==0
        oMod:SetValue(__o0)
    Else
        oMod:SetValue(self:Div(oMod,.F.))
        oMod:SetValue(oMod:cRDiv,NIL,NIL,.F.)
    EndIF    
Return(oMod)

/*
    Method      : Pow
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2013
    Descricao   : Caltulo de Potencia
    Sintaxe     : tBigNumber():Pow(uBigN) -> oBigNR
*/
Method Pow(uBigN) CLASS tBigNumber

    Local oSelf:=self:Clone()
    
    Local cM10
    
    Local cPowB
    Local cPowA
    
    Local lPoWN
    Local lPowF
    
    Local nZS

    lPoWN:=__pwoNP:SetValue(uBigN):lt(__o0)

    BEGIN SEQUENCE

        IF oSelf:eq(__o0) .and. __pwoNP:eq(__o0)
            __pwoNR:SetValue(__o1)
            BREAK
        EndIF

        IF oSelf:eq(__o0)
            __pwoNR:SetValue(__o0)
            BREAK
        EndIF

        IF __pwoNP:eq(__o0)
            __pwoNR:SetValue(__o1)
            BREAK
        EndIF

        __pwoNR:SetValue(oSelf)

        IF __pwoNR:eq(__o1)
            __pwoNR:SetValue(__o1)
            BREAK
        EndIF

        IF __o1:eq(__pwoNP:SetValue(__pwoNP:Abs()))
            BREAK
        EndIF

        lPowF:=__pwoA:SetValue(__pwoNP:cDec):gt(__o0)
        
        IF lPowF

            cPowA:=__pwoNP:cInt+__pwoNP:Dec(NIL,NIL,.T.)
            __pwoA:SetValue(cPowA)

            nZS:=hb_bLen(__pwoNP:Dec(NIL,NIL,.T.))
            IncZeros(nZS)
            
            cM10:="1"
            cM10+=SubStr(__cstcZ0,1,nZS)
            
            cPowB:=cM10

            IF __pwoB:SetValue(cPowB):gt(__o1)
                __pwoGCD:SetValue(__pwoA:GCD(__pwoB))
                __pwoA:SetValue(__pwoA:Div(__pwoGCD))
                __pwoB:SetValue(__pwoB:Div(__pwoGCD))
            EndIF

            __pwoA:Normalize(@__pwoB)
    
            __pwoNP:SetValue(__pwoA)

        EndIF

        __pwoNT:SetValue(__o0)
        __pwoNP:SetValue(__pwoNP:Sub(__o1))
        While __pwoNT:lt(__pwoNP)
            __pwoNR:SetValue(__pwoNR:Mult(oSelf))
            __pwoNT:SetValue(__pwoNT:Add(__o1))
        End While

        IF lPowF
            __pwoNR:SetValue(__pwoNR:nthRoot(__pwoB))
        EndIF

    END SEQUENCE

    IF lPoWN
        __pwoNR:SetValue(__o1:Div(__pwoNR))    
    EndIF

Return(__pwoNR:Clone())

/*
    Method      : e
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Retorna o Numero de Neper (2.718281828459045235360287471352662497757247...)
    Sintaxe     : tBigNumber():e(lForce) -> oeTthD
    (((n+1)^(n+1))/(n^n))-((n^n)/((n-1)^(n-1)))
*/
Method e(lForce) CLASS tBigNumber

    Local oeTthD

    Local oPowN
    Local oDiv1P
    Local oDiv1S
    Local oBigNC
    Local oAdd1N
    Local oSub1N
    Local oPoWNAd
    Local oPoWNS1

    BEGIN SEQUENCE
        
        DEFAULT lForce:=.F.

        IF .NOT.(lForce)

            oeTthD:=__o0:Clone()
            oeTthD:SetValue(__eTthD())

            BREAK

        EndIF

        oBigNC:=self:Clone()
        
        IF oBigNC:eq(__o0)
            oBigNC:SetValue(__o1)
        EndIF

        oPowN:=oBigNC:Clone()
        
        oPowN:SetValue(oPowN:Pow(oPowN))
        
        oAdd1N:=oBigNC:Add(__o1)
        oSub1N:=oBigNC:Sub(__o1)

        oPoWNAd:=oAdd1N:Pow(oAdd1N)
        oPoWNS1:=oSub1N:Pow(oSub1N)
        
        oDiv1P:=oPoWNAd:Div(oPowN)
        oDiv1S:=oPowN:Div(oPoWNS1)

        oeTthD:SetValue(oDiv1P:Sub(oDiv1S))

    END SEQUENCE

Return(oeTthD)

/*
    Method    : Exp
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/02/2013
    Descricao : Potencia do Numero de Neper e^cN
    Sintaxe   : tBigNumber():Exp(lForce) -> oBigNR
*/
Method Exp(lForce) CLASS tBigNumber
    Local oBigNe:=self:e(lForce)
    Local oBigNR:=oBigNe:Pow(self)
Return(oBigNR)

/*
    Method    : PI
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 04/02/2013
    Descricao : Retorna o Numero Irracional PI (3.1415926535897932384626433832795...)
    Sintaxe   : tBigNumber():PI(lForce) -> oPITthD
*/
Method PI(lForce) CLASS tBigNumber
    
    Local oPITthD

    DEFAULT lForce:=.F.

    BEGIN SEQUENCE

        lForce:=.F.    //TODO: Implementar o calculo.

        IF .NOT.(lForce)

            oPITthD:=__o0:Clone()
            oPITthD:SetValue(__PITthD())

            BREAK

        EndIF

        //TODO: Implementar o calculo,Depende de Pow com Expoente Fracionario

    END SEQUENCE

Return(oPITthD)

/*
    Method    : GCD
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 23/02/2013
    Descricao : Retorna o GCD/MDC
    Sintaxe   : tBigNumber():GCD(uBigN) -> oGCD
*/
Method GCD(uBigN) CLASS tBigNumber

    Local oX:=self:Clone()
     Local oY:=tBigNumber():New(uBigN)
     
     Local oGCD  
     
     oX:SetValue(oY:Max(self))
     oY:SetValue(oY:Min(self))

    IF oY:eq(__o0)
        oGCD:=oX
    Else
        oGCD:=oY:Clone()
        IF oX:lte(__oMinGCD).and.oY:lte(__oMinGCD)
            oGCD:SetValue(cGCD(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
        Else
            While .T.
                oY:SetValue(oX:Mod(oY))
                IF oY:eq(__o0)
                    EXIT
                EndIF
                oX:SetValue(oGCD)
                oGCD:SetValue(oY)
            End While
        EndIF
    EndIF 

Return(oGCD)

Static Function cGCD(nX,nY)
    #ifndef __PTCOMPAT__
        Local nGCD:=TBIGNGDC(nX,nY)
    #else //__PROTHEUS__
         Local nGCD:=nX  
         
         nX:=Max(nY,nGCD)
         nY:=Min(nGCD,nY)
    
        IF nY==0
            nGCD:=nX
        Else
               nGCD:=nY
               While .T.
                   IF (nY:=(nX%nY))==0
                       EXIT
                   EndIF
                   nX:=nGCD
                   nGCD:=nY
               End While
        EndIF
    #endif //__PTCOMPAT__
Return(hb_ntos(nGCD))

/*
    Method    : LCM
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 23/02/2013
    Descricao : Retorna o LCM/MMC
    Sintaxe   : tBigNumber():LCM(uBigN) -> oLCM
*/
Method LCM(uBigN) CLASS tBigNumber

#ifndef __PTCOMPAT__
    Local aThreads
#endif
    
    Local oX:=self:Clone()
    Local oY:=tBigNumber():New(uBigN)

    Local oI:=__o2:Clone()
    
    Local oLCM:=__o1:Clone()
    
    Local lMX
    Local lMY
    
    IF oX:nInt<=__nMinLCM.and.oY:nInt<=__nMinLCM
        oLCM:SetValue(cLCM(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
    Else
        #ifndef __PTCOMPAT__
            aThreads:=Array(2,2)
        #endif    
        While .T.
            #ifndef __PTCOMPAT__
                aThreads[1][1]:=hb_threadStart(@thMod0(),oX,oI)
                hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                aThreads[1][2]:=hb_threadStart(@thMod0(),oY,oI)
                hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                hb_threadWait(aThreads[1])
                lMX:=aThreads[2][1]
                lMY:=aThreads[2][2]
            #else
                lMX:=oX:Mod(oI):eq(__o0)
                lMY:=oY:Mod(oI):eq(__o0)
            #endif    
            While lMX .or. lMY
                oLCM:SetValue(oLCM:Mult(oI))
                #ifndef __PTCOMPAT__
                    IF lMX .and. lMY
                        oX:SetValue(oX:Div(oI,.F.))
                        oY:SetValue(oY:Div(oI,.F.))
                        aThreads[1][1]:=hb_threadStart(@thMod0(),oX,oI)
                        hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                        aThreads[1][2]:=hb_threadStart(@thMod0(),oY,oI)
                        hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                        hb_threadWait(aThreads[1])
                        lMX:=aThreads[2][1]
                        lMY:=aThreads[2][2]
                    Else
                        IF lMX
                            oX:SetValue(oX:Div(oI,.F.))
                            lMX:=oX:Mod(oI):eq(__o0)
                        EndIF
                        IF lMY
                            oY:SetValue(oY:Div(oI,.F.))
                            lMY:=oY:Mod(oI):eq(__o0)
                        EndIF
                    EndIF    
                #else
                    IF lMX
                        oX:SetValue(oX:Div(oI,.F.))
                        lMX:=oX:Mod(oI):eq(__o0)
                    EndIF
                    IF lMY
                        oY:SetValue(oY:Div(oI,.F.))
                        lMY:=oY:Mod(oI):eq(__o0)
                    EndIF
                #endif    
            End While
            IF oX:eq(__o1) .and. oY:eq(__o1)
                EXIT
            EndIF
            oI:SetValue(oI:Add(__o1))        
        End While
    EndIF
    
Return(oLCM)

Static Function cLCM(nX,nY)

    #ifndef __PTCOMPAT__
    
        Local nLCM:=TBIGNLCM(nX,nY)
    
    #else //__PROTHEUS__
         
        Local nLCM:=1
    
        Local nI:=2
    
        Local lMX
        Local lMY
    
        While .T.
            lMX:=(nX%nI)==0
            lMY:=(nY%nI)==0
            While lMX .or. lMY
                nLCM *= nI
                IF lMX
                    nX:=Int(nX/nI)
                    lMX:=(nX%nI)==0
                EndIF
                IF lMY
                    nY:=Int(nY/nI)
                    lMY:=(nY%nI)==0
                EndIF
            End While
            IF nX==1 .and. nY==1
                EXIT
            EndIF
            ++nI
        End While
    
    #endif //__PTCOMPAT__    
    
Return(hb_ntos(nLCM))

#ifndef __PTCOMPAT__
    Static Function thMod0(oBN,oMN)
        Local oRet:=__o0:Clone()
        oRet:SetValue(oBN:Mod(oMN))
    Return(oRet:eq(__o0))
#endif //__PTCOMPAT__    

/*

    Method    : nthRoot
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Radiciacao 
    Sintaxe   : tBigNumber():nthRoot(uBigN) -> othRoot
*/
Method nthRoot(uBigN) CLASS tBigNumber

    Local cFExit

    Local nZS

    Local oRootB:=self:Clone()
    Local oRootE
    
    Local othRoot:=__o0:Clone()

    Local oFExit

    BEGIN SEQUENCE

        IF oRootB:eq(__o0)
            BREAK
        EndIF

        IF oRootB:lNeg
            BREAK
        EndIF

        IF oRootB:eq(__o1)
            othRoot:SetValue(__o1)
            BREAK
        EndIF

        oRootE:=tBigNumber():New(uBigN)

        IF oRootE:eq(__o0)
            BREAK
        EndIF

        IF oRootE:eq(__o1)
            othRoot:SetValue(oRootB)
            BREAK
        EndIF

        nZS:=__nthRootAcc-1
        IncZeros(nZS)
        
        cFExit:="0."+SubStr(__cstcZ0,1,nZS)+"1"
            
        oFExit:=__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,__nthRootAcc)

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    END SEQUENCE

Return(othRoot)

/*

    Method    : nthRootPF
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Radiciacao utilizando Fatores Primos
    Sintaxe   : tBigNumber():nthRootPF(uBigN) -> othRoot
*/
Method nthRootPF(uBigN) CLASS tBigNumber

    Local aIPF
    Local aDPF

    Local cFExit
    
    Local lDec

    Local nZS
    
    Local nPF
    Local nPFs

    Local oRootB:=self:Clone()
    Local oRootD
    Local oRootE

    Local oRootT

    Local othRoot:=__o0:Clone()
    Local othRootD

    Local oFExit

    BEGIN SEQUENCE

        IF oRootB:eq(__o0)
            BREAK
        EndIF

        IF oRootB:lNeg
            BREAK
        EndIF

        IF oRootB:eq(__o1)
            othRoot:SetValue(__o1)
            BREAK
        EndIF

        oRootE:=tBigNumber():New(uBigN)

        IF oRootE:eq(__o0)
            BREAK
        EndIF

        IF oRootE:eq(__o1)
            othRoot:SetValue(oRootB)
            BREAK
        EndIF
        
        oRootT:=__o0:Clone()

        nZS:=__nthRootAcc-1
        IncZeros(nZS)
    
        cFExit:="0."+SubStr(__cstcZ0,1,nZS)+"1"
            
        oFExit:=__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,__nthRootAcc)

        lDec:=oRootB:Dec(.T.):gt(__o0)
        
        IF lDec
            
            nZS:=hb_bLen(oRootB:Dec(NIL,NIL,.T.))
            IncZeros(nZS)
            
            oRootD:=tBigNumber():New("1"+SubStr(__cstcZ0,1,nZS))
            oRootT:SetValue(oRootB:cInt+oRootB:cDec)
            
            aIPF:=oRootT:PFactors()
            aDPF:=oRootD:PFactors()

        Else
        
            aIPF:=oRootB:PFactors()
            aDPF:=Array(0)
        
        EndIF

        nPFs:=tBIGNaLen(aIPF)

        IF nPFs>0
            othRoot:SetValue(__o1)
            othRootD:=__o0:Clone()
            oRootT:SetValue(__o0)
            For nPF:=1 To nPFs
                IF oRootE:eq(aIPF[nPF][2])
                    othRoot:SetValue(othRoot:Mult(aIPF[nPF][1]))
                Else
                    oRootT:SetValue(aIPF[nPF][1])
                    oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                    oRootT:SetValue(oRootT:Pow(aIPF[nPF][2]))
                    othRoot:SetValue(othRoot:Mult(oRootT))
                EndIF    
            Next nPF
            IF .NOT.(Empty(aDPF))
                nPFs:=tBIGNaLen(aDPF)
                IF nPFs>0
                    othRootD:SetValue(__o1)
                    For nPF:=1 To nPFs
                        IF oRootE:eq(aDPF[nPF][2])
                            othRootD:SetValue(othRootD:Mult(aDPF[nPF][1]))
                        Else
                            oRootT:SetValue(aDPF[nPF][1])
                            oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                            oRootT:SetValue(oRootT:Pow(aDPF[nPF][2]))
                            othRootD:SetValue(othRootD:Mult(oRootT))
                        EndIF
                    Next nPF
                    IF othRootD:gt(__o0)
                        othRoot:SetValue(othRoot:Div(othRootD))    
                    EndIF
                EndIF    
            EndIF
            BREAK
        EndIF

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    END SEQUENCE

Return(othRoot)

/*
    Method    : SQRT
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/03/2013
    Descricao : Retorna a Raiz Quadrada (radix quadratum -> O Lado do Quadrado) do Numero passado como parametro
    Sintaxe   : tBigNumber():SQRT() -> oSQRT
*/
Method SQRT() CLASS tBigNumber

    Local oSQRT:=self:Clone()    
    
    BEGIN SEQUENCE

        IF oSQRT:lte(oSQRT:SysSQRT())
            oSQRT:SetValue(__SQRT(hb_ntos(Val(oSQRT:GetValue()))))
            BREAK
        EndIF

        IF oSQRT:eq(__o0)
            oSQRT:SetValue(__o0)
            BREAK
        EndIF

        oSQRT:SetValue(__SQRT(oSQRT))

    END SEQUENCE

Return(oSQRT)

/*
    Method    : SysSQRT
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/03/2013
    Descricao : Define o valor maximo para calculo da SQRT considerando a funcao padrao
    Sintaxe   : tBigNumber():SysSQRT(uSet) -> oSysSQRT
*/
Method SysSQRT(uSet) CLASS tBigNumber

    Local cType
    
    cType:=ValType(uSet)
    IF ( cType $ "C|N|O" )
        __oSysSQRT:SetValue(IF(cType$"C|O",uSet,IF(cType=="N",hb_ntos(uSet),"0")))
        IF __oSysSQRT:gt(MAX_SYS_SQRT)
            __oSysSQRT:SetValue(MAX_SYS_SQRT)
        EndIF
    EndIF
    
Return(__oSysSQRT)

/*
    Method      : Log
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo na Base N DEFAULT 10
    Sintaxe     : tBigNumber():Log(Log(uBigNB) -> oBigNR
    Referencia  : //http://www.vivaolinux.com.br/script/Calculo-de-logaritmo-de-um-numero-por-um-terceiro-metodo-em-C
*/
Method Log(uBigNB) CLASS tBigNumber

    Local oS:=__o0:Clone()
    Local oT:=__o0:Clone()
    Local oI:=__o1:Clone()
    Local oX:=self:Clone()
    Local oY:=__o0:Clone()
    Local oLT:=__o0:Clone()

    Local lflag:=.F.
    
    IF oX:eq(__o0)
        Return(__o0:Clone())
    EndIF

    DEFAULT uBigNB:=self:e()

    oT:SetValue(uBigNB)

    IF oT:eq(__o1)
        Return(__o0:Clone())
    EndIF
    
    IF __o0:lt(oT) .and. oT:lt(__o1)
         lflag:=.NOT.(lflag)
         oT:SetValue(__o1:Div(oT))
    EndIF

    While oX:gt(oT) .and. oT:gt(__o1)
        oY:SetValue(oY:Add(oI))
        oX:SetValue(oX:Div(oT))
    End While 

    oS:SetValue(oS:Add(oY))
    oY:SetValue(__o0)
*    oT:SetValue(oT:Sqrt())
    oT:SetValue(__SQRT(oT))
    oI:SetValue(oI:Div(__o2))
    
    While oT:gt(__o1)

        While oX:gt(oT) .and. oT:gt(__o1)
            oY:SetValue(oY:Add(oI))
            oX:SetValue(oX:Div(oT))
        End While 
    
        oS:SetValue(oS:Add(oY))
        oY:SetValue(__o0)
        oLT:SetValue(oT)
*        oT:SetValue(oT:Sqrt())
        oT:SetValue(__SQRT(oT))
        IF oT:eq(oLT)
            oT:SetValue(__o0)    
        EndIF 
        oI:SetValue(oI:Div(__o2))

    End While

    IF lflag
        oS:SetValue(oS:Mult("-1"))
    EndIF    

Return(oS)

/*
    Method      : Log2
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo Base 2
    Sintaxe     : tBigNumber():Log2() -> oBigNR
*/
Method Log2() CLASS tBigNumber
    Local ob2:=__o2:Clone()
Return(self:Log(ob2))

/*
    Method      : Log10
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo Base 10
    Sintaxe     : tBigNumber():Log10() -> oBigNR
*/
Method Log10() CLASS tBigNumber
    Local ob10:=__o10:Clone()
Return(self:Log(ob10))

/*
    Method      : Ln
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Logaritmo Natural
    Sintaxe     : tBigNumber():Ln() -> oBigNR
*/
Method Ln() CLASS tBigNumber
Return(self:Log(__o1:Exp()))

/*
    Method      : aLog
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo 
    Sintaxe     : tBigNumber():aLog(Log(uBigNB) -> oBigNR
*/
Method aLog(uBigNB) CLASS tBigNumber
    Local oaLog:=tBigNumber():New(uBigNB)
Return(oaLog:Pow(self))

/*
    Method      : aLog2
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo Base 2
    Sintaxe     : tBigNumber():aLog2() -> oBigNR
*/
Method aLog2() CLASS tBigNumber
    Local ob2:=__o2:Clone()
Return(self:aLog(ob2))

/*
    Method      : aLog10
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo Base 10
    Sintaxe     : tBigNumber():aLog10() -> oBigNR
*/
Method aLog10() CLASS tBigNumber
    Local ob10:=__o10:Clone()
Return(self:aLog(ob10))

/*
    Method      : aLn
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o AntiLogaritmo Natural
    Sintaxe     : tBigNumber():aLn() -> oBigNR
*/
Method aLn() CLASS tBigNumber
Return(self:aLog(__o1:Exp()))

/*
    Method    : MathC
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Operacoes Matematicas
    Sintaxe   : tBigNumber():MathC(uBigN1,cOperator,uBigN2) -> cNR
*/
Method MathC(uBigN1,cOperator,uBigN2) CLASS tBigNumber
Return(MathO(uBigN1,cOperator,uBigN2,.F.))

/*
    Method      : MathN
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Operacoes Matematicas
    Sintaxe     : tBigNumber():MathN(uBigN1,cOperator,uBigN2) -> oBigNR
*/
Method MathN(uBigN1,cOperator,uBigN2) CLASS tBigNumber
Return(MathO(uBigN1,cOperator,uBigN2,.T.))

/*
    Method      : Rnd
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Rnd arredonda um numero decimal, "para cima", se o digito da precisao definida for >= 5, caso contrario, truca.
    Sintaxe     : tBigNumber():Rnd(nAcc) -> oRND
*/
Method Rnd(nAcc) CLASS tBigNumber

    Local oRnd:=self:Clone()

    Local cAdd
    Local cAcc

    DEFAULT nAcc:=Max((Min(oRnd:nDec,__nSetDecimals)-1),0)

    IF .NOT.(oRnd:eq(__o0))
        cAcc:=SubStr(oRnd:cDec,nAcc+1,1)
        IF cAcc==""
            cAcc:=SubStr(oRnd:cDec,--nAcc+1,1)
        EndIF
        IF cAcc>="5"
            cAdd:="0."
            IncZeros(nAcc)
            cAdd+=SubStr(__cstcZ0,1,nAcc)+"5"
            oRnd:SetValue(oRnd:Add(cAdd))
        EndIF
        oRnd:SetValue(oRnd:cInt+"."+SubStr(oRnd:cDec,1,nAcc),NIL,oRnd:cRDiv)
    EndIF

Return(oRnd)

/*
    Method      : NoRnd
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : NoRnd trunca um numero decimal
    Sintaxe     : tBigNumber():NoRnd(nAcc) -> oBigNR
*/
Method NoRnd(nAcc) CLASS tBigNumber
Return(self:Truncate(nAcc))

/*
    Method      : Floor
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2014
    Descricao   : Retorna o "Piso" de um Numero Real de acordo com o Arredondamento para "baixo"
    Sintaxe     : tBigNumber():Floor(nAcc) -> oFloor
*/
Method Floor(nAcc) CLASS tBigNumber
    Local oInt:=self:Int(.T.,.T.)
    Local oFloor:=self:Clone()
    DEFAULT nAcc:=Max((Min(oFloor:nDec,__nSetDecimals)-1),0)
    oFloor:SetValue(oFloor:Rnd(nAcc):Int(.T.,.T.))
    oFloor:SetValue(oFloor:Min(oInt))
Return(oFloor)

/*
    Method      : Ceiling
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2014
    Descricao   : Retorna o "Teto" de um Numero Real de acordo com o Arredondamento para "cima"
    Sintaxe     : tBigNumber():Ceiling(nAcc) -> oCeiling
*/
Method Ceiling(nAcc) CLASS tBigNumber
    Local oInt:=self:Int(.T.,.T.)
    Local oCeiling:=self:Clone()
    DEFAULT nAcc:=Max((Min(oCeiling:nDec,__nSetDecimals)-1),0)
    oCeiling:SetValue(oCeiling:Rnd(nAcc):Int(.T.,.T.))
    oCeiling:SetValue(oCeiling:Max(oInt))
Return(oCeiling)

/*
    Method      : Truncate
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Truncate trunca um numero decimal
    Sintaxe     : tBigNumber():Truncate(nAcc) -> oTrc
*/
Method Truncate(nAcc) CLASS tBigNumber

    Local oTrc:=self:Clone()
    Local cDec:=oTrc:cDec

    IF .NOT.(__o0:eq(cDec))
        DEFAULT nAcc:=Min(oTrc:nDec,__nSetDecimals)
        cDec:=SubStr(cDec,1,nAcc)
        oTrc:SetValue(oTrc:cInt+"."+cDec)
    EndIF

Return(oTrc)

/*
    Method      : Normalize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Normaliza os Dados
    Sintaxe     : tBigNumber():Normalize(oBigN) -> self
*/
Method Normalize(oBigN) CLASS tBigNumber
    
    Local nPadL:=Max(self:nInt,oBigN:nInt)
    Local nPadR:=Max(self:nDec,oBigN:nDec)
    Local nSize:=(nPadL+nPadR)
    
    Local lPadL:=nPadL!=self:nInt
    Local lPadR:=nPadR!=self:nDec

    IncZeros(nSize)
    
    IF lPadL .or. lPadR
        IF lPadL
            self:cInt:=SubStr(__cstcZ0,1,nPadL-self:nInt)+self:cInt
            self:nInt:=nPadL
        EndIF
        IF lPadR
            self:cDec+=SubStr(__cstcZ0,1,nPadR-self:nDec)
            self:nDec:=nPadR
        EndIF
        self:nSize:=nSize
    EndIF

    lPadL:=nPadL!=oBigN:nInt
    lPadR:=nPadR!=oBigN:nDec 
    
    IF lPadL .or. lPadR
        IF lPadL
            oBigN:cInt:=SubStr(__cstcZ0,1,nPadL-oBigN:nInt)+oBigN:cInt
            oBigN:nInt:=nPadL
        EndIF
        IF lPadR
            oBigN:cDec+=SubStr(__cstcZ0,1,nPadR-oBigN:nDec)
            oBigN:nDec:=nPadR
        EndIF
        oBigN:nSize:=nSize
    EndIF
    
Return(self)

/*
    Method      : D2H
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Decimal para Hexa
    Sintaxe     : tBigNumber():D2H(cHexB) -> cHexN
*/
Method D2H(cHexB) CLASS tBigNumber

    Local otH:=__o0:Clone()
    Local otN:=tBigNumber():New(self:cInt)

    Local cHexN:=""
    Local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"

    Local cInt
    Local cDec
    Local cSig:=self:cSig

    Local oHexN

    Local nAT
    
    DEFAULT cHexB:="16"

    otH:SetValue(cHexB)
    
    While otN:gt(__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    End While

    IF cHexN==""
        cHexN:="0"        
    EndIF

    cInt:=cHexN

    cHexN:=""
    otN:=tBigNumber():New(self:Dec(NIL,NIL,.T.))

    While otN:gt(__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    End While

    IF cHexN==""
        cHexN:="0"        
    EndIF

    cDec:=cHexN

    oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

Return(oHexN)

/*
    Method      : H2D
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Hexa para Decimal
    Sintaxe     : tBigNumber():H2D() -> otNR
*/
Method H2D() CLASS tBigNumber

    Local otH:=__o0:Clone()
    Local otNR:=__o0:Clone()
    Local otLN:=__o0:Clone()
    Local otPw:=__o0:Clone()
    Local otNI:=__o0:Clone()
    Local otAT:=__o0:Clone()

    Local cHexB:=hb_ntos(self:nBase)
    Local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"
    Local cHexN:=self:cInt
    
    Local cInt
    Local cDec
    Local cSig:=self:cSig

    Local nLn:=hb_bLen(cHexN)
    Local nI:=nLn

    otH:SetValue(cHexB)
    otLN:SetValue(hb_ntos(nLn))

    While nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1))) 
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:Sub(__o1))
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    End While

    cInt:=otNR:cInt

    cHexN:=self:cDec
    nLn:=self:nDec
    nI:=nLn

    otLN:SetValue(hb_ntos(nLn))

    While nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1)))
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:Sub(__o1))
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    End While

    cDec:=otNR:cDec

    otNR:SetValue(cSig+cInt+"."+cDec)

Return(otNR)

/*
    Method      : H2B
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Hex para Bin
    Sintaxe     : tBigNumber():H2B(cHexN) -> cBin
*/
Method H2B() CLASS tBigNumber

    Local aH2B:={;
                            {"0","00000"},;
                            {"1","00001"},;
                            {"2","00010"},;
                            {"3","00011"},;
                            {"4","00100"},;
                            {"5","00101"},;
                            {"6","00110"},;
                            {"7","00111"},;
                            {"8","01000"},;
                            {"9","01001"},;
                            {"A","01010"},;
                            {"B","01011"},;
                            {"C","01100"},;
                            {"D","01101"},;
                            {"E","01110"},;
                            {"F","01111"},;
                            {"G","10000"},;
                            {"H","10001"},;
                            {"I","10010"},;
                            {"J","10011"},;
                            {"K","10100"},;
                            {"L","10101"},;
                            {"M","10110"},;
                            {"N","10111"},;
                            {"O","11000"},;
                            {"P","11001"},;
                            {"Q","11010"},;
                            {"R","11011"},;
                            {"S","11100"},;
                            {"T","11101"},;
                            {"U","11110"},;
                            {"V","11111"};
                        }

    Local cChr
    Local cBin:=""

    Local cInt
    Local cDec

    Local cSig:=self:cSig
    Local cHexB:=hb_ntos(self:nBase)
    Local cHexN:=self:cInt

    Local oBin:=tBigNumber():New(NIL,2)

    Local nI:=0
    Local nLn:=hb_bLen(cHexN)
    Local nAT

    Local l16

    BEGIN SEQUENCE

        IF Empty(cHexB)
             BREAK
        EndIF

        IF .NOT.(cHexB $ "[16][32]")
            BREAK
        EndIF

        l16:=cHexB=="16"

        While ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            IF nAT>0
                cBin+=IF(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            EndIF
        End While

        cInt:=cBin

        nI:=0
        cBin:=""
        cHexN:=self:cDec
        nLn:=self:nDec
        
        While ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            IF nAT>0
                cBin+=IF(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            EndIF
        End While

        cDec:=cBin

        oBin:SetValue(cSig+cInt+"."+cDec)

    END SEQUENCE

Return(oBin)

/*
    Method      : B2H
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Bin para Hex
    Sintaxe     : tBigNumber():B2H(cHexB) -> cHexN
*/
Method B2H(cHexB) CLASS tBigNumber
    
    Local aH2B:={;
                            {"0","00000"},;
                            {"1","00001"},;
                            {"2","00010"},;
                            {"3","00011"},;
                            {"4","00100"},;
                            {"5","00101"},;
                            {"6","00110"},;
                            {"7","00111"},;
                            {"8","01000"},;
                            {"9","01001"},;
                            {"A","01010"},;
                            {"B","01011"},;
                            {"C","01100"},;
                            {"D","01101"},;
                            {"E","01110"},;
                            {"F","01111"},;
                            {"G","10000"},;
                            {"H","10001"},;
                            {"I","10010"},;
                            {"J","10011"},;
                            {"K","10100"},;
                            {"L","10101"},;
                            {"M","10110"},;
                            {"N","10111"},;
                            {"O","11000"},;
                            {"P","11001"},;
                            {"Q","11010"},;
                            {"R","11011"},;
                            {"S","11100"},;
                            {"T","11101"},;
                            {"U","11110"},;
                            {"V","11111"};
                        }

    Local cChr
    Local cInt
    Local cDec
    Local cSig:=self:cSig
    Local cBin:=self:cInt
    Local cHexN:=""

    Local oHexN

    Local nI:=1
    Local nLn:=hb_bLen(cBin)
    Local nAT

    Local l16
    
    BEGIN SEQUENCE

        IF Empty(cHexB)
            BREAK
        EndIF

        IF .NOT.(cHexB $ "[16][32]")
            oHexN:=tBigNumber():New(NIL,16)
            BREAK
        EndIF

        l16:=cHexB=="16"

        While nI<=nLn
            cChr:=SubStr(cBin,nI,IF(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(IF(l16,SubStr(aE[2],2),aE[2])==cChr)})
            IF nAT>0
                cHexN+=aH2B[nAT][1]
            EndIF
            nI+=IF(l16,4,5)
        End While
    
        cInt:=cHexN

        nI:=1
        cBin:=self:cDec
        nLn:=self:nDec
        cHexN:=""

        While nI<=nLn
            cChr:=SubStr(cBin,nI,IF(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(IF(l16,SubStr(aE[2],2),aE[2])==cChr)})
            IF nAT>0
                cHexN+=aH2B[nAT][1]
            EndIF
            nI+=IF(l16,4,5)
        End While

        cDec:=cHexN

        oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

    END SEQUENCE

Return(oHexN)

/*
    Method      : D2B
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 23/03/2013
    Descricao   : Converte Dec para Bin
    Sintaxe     : tBigNumber():D2B(cHexB) -> oBin
*/
Method D2B(cHexB) CLASS tBigNumber
    Local oHex:=self:D2H(cHexB)
    Local oBin:=oHex:H2B()
Return(oBin)

/*
    Method      : B2D
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 23/03/2013
    Descricao   : Converte Bin para Dec
    Sintaxe     : tBigNumber():B2D(cHexB) -> oDec
*/
Method B2D(cHexB) CLASS tBigNumber
    Local oHex:=self:B2H(cHexB) 
    Local oDec:=oHex:H2D()
Return(oDec)

/*
    Method      : Randomize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Randomize BigN Integer
    Sintaxe     : tBigNumber():Randomize(uB,uE,nExit) -> oR
*/
Method Randomize(uB,uE,nExit) CLASS tBigNumber

    Local aE
    
    Local oB:=__o0:Clone()
    Local oE:=__o0:Clone()
    Local oT:=__o0:Clone()
    Local oM:=__o0:Clone()
    Local oR:=__o0:Clone()

    Local cR:=""

    Local nB
    Local nE
    Local nR
    Local nS
    Local nT

    Local lI

    #ifdef __HARBOUR__
        oM:SetValue("9999999999999999999999999999")
    #else //__PROTHEUS__
        oM:SetValue("999999999")
    #endif    

    DEFAULT uB:="1"
    DEFAULT uE:=oM:ExactValue()

    oB:SetValue(uB)
    oE:SetValue(uE)

    oB:SetValue(oB:Int(.T.):Abs(.T.))
    oE:SetValue(oE:Int(.T.):Abs(.T.))
    
    oT:SetValue(oB:Min(oE))
    oE:SetValue(oB:Max(oE))
    oB:SetValue(oT)

    BEGIN SEQUENCE
    
        IF oB:gt(oM)
    
            nE:=Val(oM:ExactValue())
            nB:=Int(nE/2)
            nR:=__Random(nB,nE)
            cR:=hb_ntos(nR)
            
            oR:SetValue(cR)
            
            lI:=.F.
            nS:=oE:nInt
            
            While oR:lt(oM)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                IF lI
                    While nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        IF oR:gte(oE)
                            EXIT
                        EndIF
                        nT+=nR
                    End While
                Else
                    While nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        IF oR:gte(oE)
                            EXIT
                        EndIF
                        nT -= nR
                    End While
                EndIF
                lI:=.NOT.(lI)
            End While
            
            DEFAULT nExit:=EXIT_MAX_RANDOM
            aE:=Array(0)

            nS:=oE:nInt
            
            While oR:lt(oE)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                IF lI
                    While  nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        IF oR:gte(oE)
                            EXIT
                        EndIF
                        nT+=nR
                    End While
                Else
                    While nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        IF oR:gte(oE)
                            EXIT
                        EndIF
                        nT -= nR
                    End While
                EndIF
                lI:=.NOT.(lI)
                nT:=0
                IF aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                    EXIT
                EndIF
                IF nT<=RANDOM_MAX_EXIT
                    aAdd(aE,__Random(1,nExit))
                EndIF
            End While

            BREAK
        
        EndIF
        
        IF oE:lte(oM)
            nB:=Val(oB:ExactValue())
            nE:=Val(oE:ExactValue())
            nR:=__Random(nB,nE)    
            cR+=hb_ntos(nR)
            oR:SetValue(cR)
            BREAK
        EndIF

        DEFAULT nExit:=EXIT_MAX_RANDOM 
        aE:=Array(0)

        lI:=.F.
        nS:=oE:nInt

        While oR:lt(oE)
            nB:=Val(oB:ExactValue())
            nE:=Val(oM:ExactValue())
            nR:=__Random(nB,nE)
            cR+=hb_ntos(nR)
            nT:=nS
            IF lI
                While nT>0
                    nR:=-(__Random(1,nS))
                    oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                    IF oR:gte(oE)
                        EXIT
                    EndIF
                    nT+=nR
                End While
            Else
                While nT>0
                    nR:=__Random(1,nS)
                    oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                    IF oR:gte(oE)
                        EXIT
                    EndIF
                    nT    -= nR
                End While
            EndIF
            lI:=.NOT.(lI)
            nT:=0
            IF aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                EXIT
            EndIF
            IF nT<=RANDOM_MAX_EXIT
                aAdd(aE,__Random(1,nExit))
            EndIF
        End While
    
    END SEQUENCE
    
    IF oR:lt(oB) .or. oR:gt(oE)

        nT:=Min(oE:nInt,oM:nInt)
        While nT>__nstcN9
            __cstcN9+=__cstcN9
            __nstcN9+=__nstcN9
        End While
        cR:=SubStr(__cstcN9,1,nT)
        oT:SetValue(cR)
        cR:=oM:Min(oE:Min(oT)):ExactValue()
        nT:=Val(cR)

        oT:SetValue(oE:Sub(oB):Div(__o2):Int(.T.))

        While oR:lt(oB)
            oR:SetValue(oR:Add(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Sub(cR))
        End    While 
    
        While oR:gt(oE)
            oR:SetValue(oR:Sub(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Add(cR))
        End While

    EndIF

Return(oR)

/*
    Function    : __Random
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Define a chamada para a funcao Random Padrao
    Sintaxe     : __Random(nB,nE)
*/
Static Function __Random(nB,nE)

    Local nR

    IF nB==0
        nB:=1
    EndIF

    IF nB==nE
        ++nE        
    EndIF

    #ifdef __HARBOUR__
        nR:=Abs(HB_RandomInt(nB,nE))
    #else //__PROTHEUS__
        nR:=Randomize(nB,nE)        
    #endif    

Return(nR)

/*
    Method      : millerRabin
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Miller-Rabin Method (Primality test)
    Sintaxe     : tBigNumber():millerRabin(uI) -> lPrime
    Ref.:       : http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
Method millerRabin(uI) CLASS tBigNumber

    Local o2:=__o2:Clone()

    Local oN:=self:Clone()
    Local oD:=tBigNumber():New(oN:Sub(__o1))
    Local oS:=__o0:Clone()
    Local oI:=__o0:Clone()
    Local oA:=__o0:Clone()

    Local lPrime:=.T.

    BEGIN SEQUENCE

        IF oN:lte(__o1)
            lPrime:=.F.
            BREAK
        EndIF

        While oD:Mod(o2):eq(__o0)
            oD:SetValue(oD:Div(o2,.F.))
            oS:SetValue(oS:Add(__o1))
        End While
    
        DEFAULT uI:=__o2:Clone()

        oI:SetValue(uI)
        While oI:gt(__o0)
            oA:SetValue(oA:Randomize(__o1,oN))
            lPrime:=mrPass(oA,oS,oD,oN)
            IF .NOT.(lPrime)
                BREAK
            EndIF
            oI:SetValue(oI:Sub(__o1))
        End While

    END SEQUENCE

Return(lPrime)

/*
    Function    : mrPass
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Miller-Rabin Pass (Primality test)
    Sintaxe     : mrPass(uA,uS,uD,uN)
    Ref.:       : http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
Static Function mrPass(uA,uS,uD,uN)

    Local oA:=tBigNumber():New(uA)
    Local oS:=tBigNumber():New(uS)
    Local oD:=tBigNumber():New(uD)
    Local oN:=tBigNumber():New(uN)
    Local oM:=tBigNumber():New(oN:Sub(__o1))

    Local oP:=tBigNumber():New(oA:Pow(oD):Mod(oN))
    Local oW:=tBigNumber():New(oS:Sub(__o1))
    
    Local lmrP:=.T.

    BEGIN SEQUENCE

        IF oP:eq(__o1)
            BREAK
        EndIF

        While oW:gt(__o0)
            lmrP:=oP:eq(oM)
            IF lmrP
                BREAK
            EndIF
            oP:SetValue(oP:Mult(oP):Mod(oN))
            oW:SetValue(oW:Sub(__o1))
        End While

        lmrP:=oP:eq(oM)        

    END SEQUENCE

Return(lmrP)

/*
    Method      : FI
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/03/2013
    Descricao   : Euler's totient function
    Sintaxe     : tBigNumber():FI() -> oT
    Ref.:       : (Euler's totient function) http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=primeNumbers
    Consultar   : http://www.javascripter.net/math/calculators/eulertotientfunction.htm para otimizar.
    
    int fi(int n) 
     {
       int result = n; 
       for(int i=2;i*i<=n;i++) 
       {
         if (n % i==0) result -= result/i; 
         while (n % i==0) n /= i; 
      } 
       if (n>1) result -= result/n; 
       return result; 
    } 
    
*/
Method FI() CLASS tBigNumber

    Local oC:=self:Clone()
    Local oT:=tBigNumber():New(oC:Int(.T.))

    Local oI
    Local oN
    
    IF oT:lte(__oMinFI)
        oT:SetValue(hb_ntos(TBIGNFI(Val(oT:Int(.F.,.F.)))))
    Else
        oI:=__o2:Clone()
        oN:=oT:Clone()
        While oI:Mult(oI):lte(oC)
            IF oN:Mod(oI):eq(__o0)
                oT:SetValue(oT:Sub(oT:Div(oI,.F.)))
            EndIF
            While oN:Mod(oI):eq(__o0)
                oN:SetValue(oN:Div(oI,.F.))
            End While
            oI:SetValue(oI:Add(__o1))
        End While
        IF oN:gt(__o1)
            oT:SetValue(oT:Sub(oT:Div(oN,.F.)))        
        EndIF
    EndIF
    
Return(oT)
#ifdef __PROTHEUS__
    Static Function TBIGNFI(n)
        Local i:=2
        Local fi:=n
        While ((i*i)<=n)
            IF ((n%i)==0)
                fi -= Int(fi/i)
            EndIF
            While ((n%i)==0)
                n:=Int(n/i)
            End While
            i++
        End While
           IF (n>1)
               fi -= Int(fi/n)
           EndIF
    Return(fi)
#endif //__PROTHEUS__

/*
    Method      : PFactors
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 19/03/2013
    Descricao   : Fatores Primos
    Sintaxe     : tBigNumber():PFactors() -> aPFactors
*/
Method PFactors() CLASS tBigNumber
    
    Local aPFactors:=Array(0)
    
    Local cP:=""

    Local oN:=self:Clone()
    Local oP:=__o0:Clone()
    Local oT:=__o0:Clone()

    Local otP:=tPrime():New()
    
    Local nP
    Local nC:=0
    
    Local lPrime:=.T.

    otP:IsPReset()
    otP:NextPReset()

    While otP:NextPrime(cP)
        cP:=LTrim(otP:cPrime)
        oP:SetValue(cP)
        IF oP:gte(oN) .or. IF(lPrime,lPrime:=otP:IsPrime(oN:cInt),lPrime .or. (++nC>1 .and. oN:gte(otP:cLPrime)))
            aAdd(aPFactors,{oN:cInt,"1"})
            EXIT
        EndIF
        While oN:Mod(oP):eq(__o0)
            nP:=aScan(aPFactors,{|e|e[1]==cP})
            IF nP==0
                aAdd(aPFactors,{cP,"1"})
            Else
                oT:SetValue(aPFactors[nP][2])
                aPFactors[nP][2]:=oT:SetValue(oT:Add(__o1)):ExactValue()
            EndIF
            oN:SetValue(oN:Div(oP,.F.))
            nC:=0
            lPrime:=.T.
        End While
        IF oN:lte(__o1)
            EXIT
        EndIF
    End While

Return(aPFactors)

/*
    Method      : Factorial 
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 19/03/2013
    Descricao   : Fatorial de Numeros Inteiros
    Sintaxe     : tBigNumber():Factorial() -> oF
    TODO        : Otimizar. 
                  Referencias: http://www.luschny.de/math/factorial/FastFactorialFunctions.htm
                               http://www.luschny.de/math/factorial/index.html 
*/
Method Factorial() CLASS tBigNumber 
    Local oN:=self:Clone():Int(.T.,.F.)
    IF oN:eq(__o0)
        Return(__o1:Clone())
    EndIF
Return(recFact(__o1:Clone(),oN))

/*
    Function    : recFact 
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/01/2014
    Descricao   : Fatorial de Numeros Inteiros
    Sintaxe     : recFact(oS,oN)
    Referencias : http://www.luschny.de/math/factorial/FastFactorialFunctions.htm
*/
Static Function recFact(oS,oN)

#ifndef __PTCOMPAT__
    Local aThreads
#endif

    Local oI
    Local oR:=__o0:Clone()
    Local oSN
    Local oSI
    Local oNI

#ifdef __PTCOMPAT__
    IF oN:lte(__o20:Mult(oN:Div(__o2):Int(.T.,.F.)))
#else
    IF oN:lte(__o20)
#endif    
        oR:SetValue(oS)
        oI:=oS:Clone()
        oI:SetValue(oI:Add(__o1))
        oSN:=oS:Clone()
        oSN:SetValue(oSN:Add(oN)) 
        While oI:lt(oSN)
            oR:SetValue(oR:Mult(oI))            
            oI:SetValue(oI:Add(__o1))
        End While
        Return(oR)
    EndIF

    oI:=oN:Clone()
    oI:SetValue(oI:Div(__o2):Int(.T.,.F.))

    oSI:=oS:Clone()
    oSI:SetValue(oSI:Add(oI))

    oNI:=oN:Clone()
    oNI:SetValue(oNI:Sub(oI))

#ifndef __PTCOMPAT__

    aThreads:=Array(2,2)

    aThreads[1][1]:=hb_threadStart(@recFact(),oS,oI)
    hb_threadJoin(aThreads[1][1],@aThreads[2][1])                

    aThreads[1][2]:=hb_threadStart(@recFact(),oSI,oNI)
    hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
    
    hb_threadWait(aThreads[1])    

Return(aThreads[2][1]:Mult(aThreads[2][2]))
#else    
Return(recFact(oS,oI):Mult(recFact(oSI,oNI)))
#endif

/*
    Function    : egMult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao Egipcia (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
    Sintaxe     : egMult(cN1,cN2,nBase,nAcc) -> oMTP
    Obs.        : Interessante+lenta... Utiliza Soma e Subtracao para obter o resultado
*/
Static Function egMult(cN1,cN2,nBase,nAcc)

#ifdef __PTCOMPAT__

    Local aeMT:=Array(0)
                    
    Local nI:=0
    Local nCmp
    
    Local oN1:=tBigNumber():New(cN1)
    Local oMTM:=__o1:Clone()
    Local oMTP:=tBigNumber():New(cN2)

    While oMTM:lte(oN1)
        ++nI
        aAdd(aeMT,{oMTM:Int(.F.,.F.),oMTP:Int(.F.,.F.)})
        oMTM:SetValue(oMTM:Add(oMTM),nBase,"0",NIL,nAcc)
        oMTP:SetValue(oMTP:Add(oMTP),nBase,"0",NIL,nAcc)
    End While

    oMTM:SetValue(__o0)
    oMTP:SetValue(__o0)
    
    While nI>0
        oMTM:SetValue(oMTM:Add(aeMT[nI][1]),nBase,"0",NIL,nAcc)
        oMTP:SetValue(oMTP:Add(aeMT[nI][2]),nBase,"0",NIL,nAcc)
        nCmp:=oMTM:cmp(oN1)
        IF nCmp==0
            EXIT
        ElseIF nCmp==1
            oMTM:SetValue(oMTM:Sub(aeMT[nI][1]),nBase,"0",NIL,nAcc)
            oMTP:SetValue(oMTP:Sub(aeMT[nI][2]),nBase,"0",NIL,nAcc)
        EndIF
        --nI
    End While
    
#else

    Local oMTP:=__o0:Clone()
    Local n:=(Len(cN1)*2)
    cN1:=PadL(cN1,n,"0")
    cN2:=PadL(cN2,n,"0")
    oMTP:SetValue(TBIGNegMult(cN1,cN2,n,nBase),nBase,"0",NIL,nAcc)
    
#endif //__PTCOMPAT__
    
Return(oMTP)
    
/*
    Function    : egDiv
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Divisao Egipcia (http://cognosco.blogs.sapo.pt/13236.html)
    Sintaxe     : egDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> __oeDivQ
*/
Static Function egDiv(cN,cD,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__
    Local aeDV:=Array(0)
    Local nI:=0
    Local nCmp
#endif //__PTCOMPAT__

    Local cRDiv

#ifndef __PTCOMPAT__
    Local cQDiv
#endif //__PTCOMPAT__
    
#ifdef __PTCOMPAT__
 
    SYMBOL_UNUSED( nSize )

    __oeDivN:SetValue(cN,nBase,NIL,NIL,nAcc)
    __oeDivD:SetValue(cD,nBase,NIL,NIL,nAcc)
    __oeDivR:SetValue(__o0,nBase,"0",NIL,nAcc)
    __oeDivQ:SetValue(__o0,nBase,"0",NIL,nAcc)

    __oeDivDvQ:SetValue(__o1)
    __oeDivDvR:SetValue(__oeDivD)

    While __oeDivDvR:lte(__oeDivN)
        ++nI
        aAdd(aeDV,{__oeDivDvQ:Int(.F.,.F.),__oeDivDvR:Int(.F.,.F.)})
        __oeDivDvQ:SetValue(__oeDivDvQ:Add(__oeDivDvQ),nBase,"0",NIL,nAcc)
        __oeDivDvR:SetValue(__oeDivDvR:Add(__oeDivDvR),nBase,"0",NIL,nAcc)
    End While

    While nI>0
        __oeDivQ:SetValue(__oeDivQ:Add(aeDV[nI][1]),nBase,"0",NIL,nAcc)
        __oeDivR:SetValue(__oeDivR:Add(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        nCmp:=__oeDivR:cmp(__oeDivN)
        IF nCmp==0
            EXIT
        ElseIF nCmp==1
            __oeDivQ:SetValue(__oeDivQ:Sub(aeDV[nI][1]),nBase,"0",NIL,nAcc)
            __oeDivR:SetValue(__oeDivR:Sub(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        EndIF
        --nI
    End While

    __oeDivR:SetValue(__oeDivN:Sub(__oeDivR),nBase,"0",NIL,nAcc)

#else //__HARBOUR__

    cQDiv:=tBIGNegDiv("0"+cN,"0"+cD,@cRDiv,nSize+1,nBase)
    
    __oeDivQ:SetValue(cQDiv,NIL,"0",NIL,nAcc)
    __oeDivR:SetValue(cRDiv,NIL,"0",NIL,nAcc)
    
#endif //__PTCOMPAT__
    
    cRDiv:=__oeDivR:Int(.F.,.F.)

    __oeDivQ:SetValue(__oeDivQ,nBase,cRDiv,NIL,nAcc)
    
    IF .NOT.(lFloat) .and. SubStr(cRDiv,__oeDivR:__nInt(),1)=="0"
        cRDiv:=SubStr(cRDiv,1,__oeDivR:__nInt()-1)
        IF Empty(cRDiv)
            cRDiv:="0"
        EndIF
        __oeDivQ:SetValue(__oeDivQ,nBase,cRDiv,NIL,nAcc)
    EndIF

Return(__oeDivQ:Clone())

/*
    Function    : ecDiv
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 18/03/2014
    Descricao   : Divisao Euclidiana (http://compoasso.free.fr/primelistweb/page/prime/euclide_en.php)
    Sintaxe     : ecDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> q    
 */
Static Function ecDiv(pA,pB,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__

   Local a:=tBigNumber():New(pA,nBase) 
   Local b:=tBigNumber():New(pB,nBase)
   Local r:=a:Clone()

#else
    
    Local r:=__o0:Clone()   

#endif   

   Local q:=__o0:Clone()

#ifdef __PTCOMPAT__

   Local n:=__o1:Clone()
   Local aux:=__o0:Clone()
   Local tmp:=__o0:Clone()
   Local base:=tBigNumber():New(hb_ntos(nBase),nBase)

#endif
   
   Local cRDiv

#ifndef __PTCOMPAT__
    Local cQDiv
#endif //__PTCOMPAT__
   
#ifdef __PTCOMPAT__   
   
   SYMBOL_UNUSED( nSize )

   While r:gte(b)
      aux:SetValue(b:Mult(n))
      IF aux:lte(a)
        While .T.
           n:SetValue(n:Mult(base))
           tmp:SetValue(b:Mult(n))
           IF tmp:gt(a)
               EXIT
           EndIF
           aux:SetValue(tmp)
        End While
      EndIF      
      n:Normalize(@base)  
      n:SetValue(egDiv(n:__cInt(),base:__cInt(),n:__nInt(),nBase,nAcc,.F.))
      While r:gte(aux)
        r:SetValue(r:Sub(aux))
        q:SetValue(q:Add(n))
      End While
      a:SetValue(r)
      n:SetValue(__o1)
    End While

#else

   cQDiv:=tBIGNecDiv("0"+pA,"0"+pB,@cRDiv,nSize+1,nBase)
    
    q:SetValue(cQDiv,NIL,"0",NIL,nAcc)
    r:SetValue(cRDiv,NIL,"0",NIL,nAcc)

#endif    
    
    cRDiv:=r:Int(.F.,.F.)
    q:SetValue(q,nBase,cRDiv,NIL,nAcc)
    
    IF .NOT.(lFloat) .and. SubStr(cRDiv,r:__nInt(),1)=="0"
        cRDiv:=SubStr(cRDiv,1,r:__nInt()-1)
        IF Empty(cRDiv)
            cRDiv:="0"
        EndIF
        q:SetValue(q,nBase,cRDiv,NIL,nAcc)
    EndIF

Return(q)

/*
    Function    : nthRoot
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : Metodo Newton-Raphson
    Sintaxe     : nthRoot(oRootB,oRootE,oAcc) -> othRoot
*/
Static Function nthRoot(oRootB,oRootE,oAcc)   
Return(__Pow(oRootB,__o1:Div(oRootE),oAcc))

/*
    Function    : __Pow
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : Metodo Newton-Raphson
    Sintaxe     : __Pow(base,exp,EPS) -> oPow
    Ref.        : http://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function 
                : http://stackoverflow.com/questions/2882706/how-can-i-write-a-power-function-myself
*/
Static Function __Pow(base,expR,EPS)

    Local acc
    Local sqr
    Local tmp

    Local low
    Local mid
    Local lst
    Local high
    
    Local exp:=expR:Clone()

    if base:eq(__o1) .or. exp:eq(__o0)
        return(__o1:Clone())
    elseif base:eq(__o0)
        return(__o0:Clone())
    elseif exp:lt(__o0)
        acc:=__pow(base,exp:Abs(.T.),EPS)
        return(__o1:Div(acc))
    elseif exp:Mod(__o2):eq(__o0)
         acc:=__pow(base,exp:Div(__o2),EPS)
        return(acc:Mult(acc))
    elseif exp:Dec(.T.):gt(__o0) .and. exp:Int(.T.):gt(__o0)
        acc:=base:Pow(expR)
        return(acc)
    elseif exp:gte(__o1)
        acc:=base:Mult(__pow(base,exp:Sub(__o1),EPS))
        return(acc)
    else
        low:=__o0:Clone()
        high:=__o1:Clone()
        sqr:=__SQRT(base)
        acc:=sqr:Clone()    
        mid:=high:Div(__o2)
        tmp:=mid:Sub(exp):Abs(.T.)
        lst:=__o0:Clone()    
        while tmp:gte(EPS)
            sqr:SetValue(__SQRT(sqr))
            if mid:lte(exp)
                low:SetValue(mid)
                acc:SetValue(acc:Mult(sqr))
              else
                  high:SetValue(mid)
                  acc:SetValue(__o1:Div(sqr))
              endif
              mid:SetValue(low:Add(high):Div(__o2))
              tmp:SetValue(mid:Sub(exp):Abs(.T.))
              if tmp:eq(lst)
                  exit
              endif
              lst:SetValue(tmp)
        end while
    endif

return(acc)

/*
    Function    : __SQRT
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : SQRT
    Sintaxe     : __SQRT(p) -> oSQRT
*/
Static Function __SQRT(p)
    Local l
    Local r
    Local t
    Local s
    Local n
    Local EPS
    Local q:=tBigNumber():New(p)
    IF q:lte(q:SysSQRT())
        r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
    Else
        n:=__nthRootAcc-1
        IncZeros(n)
        s:="0."+SubStr(__cstcZ0,1,n)+"1"
        EPS:=__o0:Clone()
        EPS:SetValue(s,NIL,NIL,NIL,__nthRootAcc)
        r:=q:Div(__o2)
        t:=r:Pow(__o2):Sub(q):Abs(.T.)
        l:=__o0:Clone()
        while t:gte(EPS)
            r:SetValue(r:pow(__o2):Add(q):Div(__o2:Mult(r)))
            t:SetValue(r:Pow(__o2):Sub(q):Abs(.T.))
            if t:eq(l)
                exit
            endif
            l:SetValue(t)
        end while
    EndIF
Return(r)

#ifdef TBN_DBFILE

    /*
        Function    : Add
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Adicao
        Sintaxe     : Add(a,b,n,nBase) -> cNR
    */
    Static Function Add(a,b,n,nBase)
    
        Local c

        Local y:=n+1
        Local k:=y
        
        Local s:=""

        #ifdef __HARBOUR__
            FIELD FN
        #endif    
        
        IncZeros(y)

        c:=aNumber(SubStr(__cstcZ0,1,y),y,"ADD_C")
    
        While n>0
            (c)->(dbGoTo(k))
            IF (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])+Val(b[n])
                #endif
                IF (c)->FN>=nBase
                    (c)->FN    -= nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    IF (c)->(rLock())
                        (c)->FN+=1
                    EndIF    
                EndIF
                (c)->(dbUnLock())
            EndIF
            --k
            --n
        End While
        
        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))
        
    Return(s)
    
    /*
        Function    : Sub
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Subtracao
        Sintaxe     : Sub(a,b,n,nBase) -> cNR
    */
    Static Function Sub(a,b,n,nBase)

        Local c

        Local y:=n
        Local k:=y
        
        Local s:=""
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif
        
        IncZeros(y)
        
        c:=aNumber(SubStr(__cstcZ0,1,y),y,"SUB_C")

        While n>0
            (c)->(dbGoTo(k))
            IF (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])-Val(b[n])
                #endif
                IF (c)->FN<0
                    (c)->FN+=nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    IF (c)->(rLock())
                        (c)->FN -= 1
                    EndIF
                EndIF
                (c)->(dbUnLock())
            EndIF
            --k
            --n
        End While

        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))

    Return(s)
    
    /*
        Function    : Mult
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Multiplicacao de Inteiros
        Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
        Obs.        : Mais rapida,usa a multiplicacao nativa
    */
    Static Function Mult(cN1,cN2,n,nBase)

        Local c
        
        Local a:=tBigNInvert(cN1,n)
        Local b:=tBigNInvert(cN2,n)
        Local y:=n+n
    
        Local i:=1
        Local k:=1
        Local l:=2
        
        Local s
        Local x
        Local j
        Local w

        #ifdef __HARBOUR__
            FIELD FN
        #endif
        
        IncZeros(y)
        
        c:=aNumber(SubStr(__cstcZ0,1,y),y,"MULT_C")
    
        While i<=n
            s:=1
            j:=i
            (c)->(dbGoTo(k))
            IF (c)->(rLock())
                While s<=i
                    #ifdef __PROTHEUS__
                        (c)->FN+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        (c)->FN+=Val(a[s++])*Val(b[j--])
                    #endif
                End While
                IF (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    IF (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN    -= w
                    EndIF    
                EndIF
                (c)->(dbUnLock())
            EndIF
            k++
            i++
        End While
    
        While l<=n
            s:=n
            j:=l
            (c)->(dbGoTo(k))
            IF (c)->(rLock())
                While s>=l
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
                #else
                    (c)->FN+=Val(a[s--])*Val(b[j++])    
                #endif
                End While
                IF (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    IF (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN -= w
                    EndIF    
                EndIF
                (c)->(dbUnLock())
            EndIF
            IF ++k>=y
                EXIT
            EndIF
            l++
        End While
        
        s:=dbGetcN(c,y)

    Return(s)

    /*
        Function    : aNumber
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : db OF Numbers
        Sintaxe     : aNumber(c,n,o) -> a
    */
    Static Function aNumber(c,n,o)
    
        Local a:=dbNumber(o)
    
        Local y:=0
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif    
    
        While ++y<=n
            (a)->(dbAppend(.T.))
        #ifdef __PROTHEUS__
            (a)->FN:=Val(SubStr(c,y,1))
        #else
            (a)->FN:=Val(c[y])
        #endif    
            (a)->(dbUnLock())
        End While
    
    Return(a)
    
    /*
        Function    : dbGetcN
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Montar a String de Retorno
        Sintaxe     : dbGetcN(a,x) -> s
    */
    Static Function dbGetcN(a,n)
    
        Local s:=""
        Local y:=n
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif    
    
        While y>=1
            (a)->(dbGoTo(y))
            While y>=1 .and. (a)->FN==0
                (a)->(dbGoTo(--y))
            End While
            While y>=1
                (a)->(dbGoTo(y--))
                s+=hb_ntos((a)->FN)
            End While
        End While
    
        IF s==""
            s:="0"    
        EndIF
    
        IF hb_bLen(s)<n
            s:=PadL(s,n,"0")
        EndIF
    
    Return(s)
                                        
    Static Function dbNumber(cAlias)
        Local aStru:={{"FN","N",18,0}}
        Local cFile
    #ifndef __HARBOUR__
        Local cLDriver
        Local cRDD:=IF((Type("__LocalDriver")=="C"),__LocalDriver,"DBFCDXADS")
    #else
        #ifndef TBN_MEMIO
        Local cRDD:="DBFCDX"
        #endif
    #endif
    #ifndef __HARBOUR__
        IF .NOT.(Type("__LocalDriver")=="C")
            Private __LocalDriver
        EndIF
        cLDriver:=__LocalDriver
        __LocalDriver:=cRDD
    #endif
        IF Select(cAlias)==0
    #ifndef __HARBOUR__
            cFile:=CriaTrab(aStru,.T.,GetdbExtension())
            IF .NOT.(GetdbExtension()$cFile)
                cFile+=GetdbExtension()
            EndIF
            dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
    #else
            #ifndef TBN_MEMIO
                cFile:=CriaTrab(aStru,cRDD)
                dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
            #else
                cFile:=CriaTrab(aStru,cAlias)
            #endif    
    #endif
            DEFAULT __athdFiles:=Array(0)
            aAdd(__athdFiles,{cAlias,cFile})
        Else
            (cAlias)->(dbRLock())
    #ifdef __HARBOUR__        
            (cAlias)->(hb_dbZap())
    #else
            (cAlias)->(__dbZap())
    #endif        
            (cAlias)->(dbRUnLock())
        EndIF    
    #ifndef __HARBOUR__
        IF .NOT.(Empty(cLDriver))
            __LocalDriver:=cLDriver
        EndIF    
    #endif
    Return(cAlias)
    
    #ifdef __HARBOUR__
        #ifndef TBN_MEMIO
            Static Function CriaTrab(aStru,cRDD)
                Local cFolder:=tbNCurrentFolder()+hb_ps()+"tbigN_tmp"+hb_ps()
                Local cFile:=cFolder+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
                Local lSuccess:=.F.
                While .NOT.(lSuccess)
                    Try
                      MakeDir(cFolder)
                      dbCreate(cFile,aStru,cRDD)
                      lSuccess:=.T.
                    Catch
                      cFile:="TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
                      lSuccess:=.F.
                    End
                End While    
            Return(cFile)
        #else
            Static Function CriaTrab(aStru,cAlias)
                Local cFile:="mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
                Local lSuccess:=.F.     
                While .NOT.(lSuccess)
                    Try
                      dbCreate(cFile,aStru,NIL,.T.,cAlias)
                      lSuccess:=.T.
                    Catch
                      cFile:="mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
                      lSuccess:=.F.
                    End
                End While    
            Return(cFile)
        #endif
    #endif

#else

    #ifdef TBN_ARRAY

    /*
        Function    : Add
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Adicao
        Sintaxe     : Add(a,b,n,nBase) -> cNR
    */
    Static Function Add(a,b,n,nBase)

        Local y:=n+1
        Local c:=aFill(aSize(__aZAdd,y),0)
        Local k:=y
        Local s:=""

        While n>0
        #ifdef __PROTHEUS__
            c[k]+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
        #else
            c[k]+=Val(a[n])+Val(b[n])
        #endif
            IF c[k]>=nBase
                c[k-1]+=1
                c[k]    -= nBase
            EndIF
            --k
            --n
        End While
        
        aEval(c,{|v|s+=hb_ntos(v)})

    Return(s)
    
    /*
        Function    : Sub
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Subtracao
        Sintaxe     : Sub(a,b,n,nBase) -> cNR
    */
    Static Function Sub(a,b,n,nBase)

        Local y:=n
        Local c:=aFill(aSize(__aZSub,y),0)
        Local k:=y
        Local s:=""
    
        While n>0
        #ifdef __PROTHEUS__
            c[k]+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
        #else
            c[k]+=Val(a[n])-Val(b[n])
        #endif
            IF c[k]<0
                c[k-1]    -= 1
                c[k]+=nBase
            EndIF
            --k
            --n
        End While
        
        aEval(c,{|v|s+=hb_ntos(v)})

    Return(s)
    
    /*
        Function    : Mult
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Multiplicacao de Inteiros
        Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
        Obs.        : Mais rapida,usa a multiplicacao nativa
    */
    Static Function Mult(cN1,cN2,n,nBase)

        Local a:=tBigNInvert(cN1,n)
        Local b:=tBigNInvert(cN2,n)

        Local y:=n+n
        Local c:=aFill(aSize(__aZMult,y),0)
    
        Local i:=1
        Local k:=1
        Local l:=2
        
        Local s
        Local x
        Local j
    
        While i<=n
            s:=1
            j:=i
            While s<=i
            #ifdef __PROTHEUS__
                c[k]+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
            #else
                c[k]+=Val(a[s++])*Val(b[j--])
            #endif
            End While
            IF c[k]>=nBase
                x:=k+1
                c[x]:=Int(c[k]/nBase)
                c[k]    -= c[x]*nBase
            EndIF
            k++
            i++
        End While
    
        While l<=n
            s:=n
            j:=l
            While s>=l
            #ifdef __PROTHEUS__
                c[k]+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
            #else
                c[k]+=Val(a[s--])*Val(b[j++])    
            #endif
            End While
            IF c[k]>=nBase
                x:=k+1
                c[x]:=Int(c[k]/nBase)
                c[k]    -= c[x]*nBase
            EndIF
            IF ++k>=y
                EXIT
            EndIF
            l++
        End While

    Return(aGetcN(c,y))

    /*
        Function    : aGetcN
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Montar a String de Retorno
        Sintaxe     : aGetcN(a,x) -> s
    */
    Static Function aGetcN(a,n)
    
        Local s:=""
        Local y:=n
    
        While y>=1
            While y>=1 .and. a[y]==0
                y--
            End While
            While y>=1
                s+=hb_ntos(a[y])
                y--
            End While
        End While
    
        IF s==""
            s:="0"
        EndIF
    
        IF hb_bLen(s)<n
            s:=PadL(s,n,"0")
        EndIF
    
    Return(s)
    
    #else

        /*
            Function    : Add
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Adicao
            Sintaxe     : Add(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            Static Function Add(a,b,n,nBase)

                Local c

                Local y:=n+1
                Local k:=y
            
                Local v:=0
                Local v1
                
                IncZeros(y)
                
                c:=SubStr(__cstcZ0,1,y)

                While n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])+Val(b[n])
                    #endif
                    IF v>=nBase
                        v  -= nBase
                        v1:=1
                    Else
                        v1:=0
                    EndIF
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k-1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k-1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    --k
                    --n
                End While

            Return(c)
        #else //__HARBOUR__
            Static Function Add(a,b,n,nB)
            Return(TBIGNADD(a,b,n,n+1,nB))
        #endif //__PTCOMPAT__
        
        /*
            Function    : Sub
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Subtracao
            Sintaxe     : Sub(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            Static Function Sub(a,b,n,nBase)

                Local c

                Local y:=n
                Local k:=y
                
                Local v:=0
                Local v1
                
                IncZeros(y)
                
                c:=SubStr(__cstcZ0,1,y)
            
                While n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])-Val(b[n])
                    #endif
                    IF v<0
                        v+=nBase
                        v1:=-1
                    Else
                        v1:=0
                    EndIF
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v)) 
                    #else
                        c[k]:=hb_ntos(v)
                    #endif
                    v:=v1
                    --k
                    --n
                End While

            Return(c)
        #else //__HARBOUR__
            Static Function Sub(a,b,n,nB)
            Return(TBIGNSUB(a,b,n,nB))
        #endif //__PTCOMPAT__
        /*
            Function    : Mult
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Multiplicacao de Inteiros
            Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
            Obs.        : Mais rapida, usa a multiplicacao nativa
        */
        #ifdef __PTCOMPAT__
            Static Function Mult(cN1,cN2,n,nBase)

                Local c

                Local a:=tBigNInvert(cN1,n)
                Local b:=tBigNInvert(cN2,n)

                Local y:=n+n

                Local i:=1
                Local k:=1
                Local l:=2
                
                Local s
                Local j
                
                Local v:=0
                Local v1
                
                IncZeros(y)
                
                c:=SubStr(__cstcZ0,1,y)
                    
                While i<=n
                    s:=1
                    j:=i
                    While s<=i
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        v+=Val(a[s++])*Val(b[j--])
                    #endif
                    End While
                    IF v>=nBase
                        v1:=Int(v/nBase)
                        v    -= v1*nBase
                    Else
                        v1:=0    
                    EndIF
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k+1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k+1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    k++
                    i++
                End While

                While l<=n
                    s:=n
                    j:=l
                    While s>=l
                    #ifdef __PROTHEUS__
                        v+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
                    #else
                        v+=Val(a[s--])*Val(b[j++])    
                    #endif
                    End While
                    IF v>=nBase
                        v1:=Int(v/nBase)
                        v    -= v1*nBase
                    Else
                        v1:=0    
                    EndIF
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k+1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k+1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    IF ++k>=y
                        EXIT
                    EndIF
                    l++
                End While

            Return(cGetcN(c,y))
        #else //__HARBOUR__
            Static Function Mult(cN1,cN2,n,nB)
                Local a:=tBigNInvert(cN1,n)
                Local b:=tBigNInvert(cN2,n)
            Return(TBIGNMULT(a,b,n,n+n,nB))
        #endif //__PTCOMPAT__

        /*
            Function    : cGetcN
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Montar a String de Retorno
            Sintaxe     : cGetcN(c,n) -> s
        */
        #ifdef __PTCOMPAT__
            Static Function cGetcN(c,n)
                Local s:=""
                Local y:=n
                While y>=1
                #ifdef __PROTHEUS__
                    While y>=1 .and. SubStr(c,y,1)=="0"
                #else
                    While y>=1 .and. c[y]=="0"
                #endif    
                        y--
                    End While
                    While y>=1
                    #ifdef __PROTHEUS__
                        s+=SubStr(c,y,1)
                    #else
                        s+=c[y]
                    #endif
                        y--
                    End While
                End While
                IF s==""
                    s:="0"
                EndIF
            
                IF hb_bLen(s)<n
                    s:=PadL(s,n,"0")
                EndIF
            
            Return(s)
        #endif __PTCOMPAT__
    
    #endif

#endif

/*
    Function    : tBigNInvert
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Inverte o Numero
    Sintaxe     : tBigNInvert(c,n) -> s
*/
#ifdef __PTCOMPAT__
    Static Function tBigNInvert(c,n)
        Local s:=""
        Local y:=n
        While y>0
        #ifdef __PROTHEUS__
            s+=SubStr(c,y--,1)
        #else
            s+=c[y--]
        #endif
        End While
    Return(s)
#else //__HARBOUR__
    Static Function tBigNInvert(c,n)
    Return(tBigNReverse(c,n))
#endif //__PTCOMPAT__

/*
    Function    : MathO
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Operacoes matematicas
    Sintaxe     : MathO(uBigN1,cOperator,uBigN2,lRetObject)
*/
Static Function MathO(uBigN1,cOperator,uBigN2,lRetObject)

    Local oBigNR:=__o0:Clone()

    Local oBigN1:=tBigNumber():New(uBigN1)
    Local oBigN2:=tBigNumber():New(uBigN2)

    DO CASE
        CASE (aScan(OPERATOR_ADD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Add(oBigN2))
        CASE (aScan(OPERATOR_SUBTRACT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Sub(oBigN2))
        CASE (aScan(OPERATOR_MULTIPLY,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mult(oBigN2))
        CASE (aScan(OPERATOR_DIVIDE,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Div(oBigN2))
        CASE (aScan(OPERATOR_POW,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Pow(oBigN2))
        CASE (aScan(OPERATOR_MOD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mod(oBigN2))
        CASE (aScan(OPERATOR_ROOT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:nthRoot(oBigN2))
        CASE (aScan(OPERATOR_SQRT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:SQRT())
    ENDCASE

    DEFAULT lRetObject:=.T.

Return(IF(lRetObject,oBigNR,oBigNR:ExactValue()))

// -------------------- assign THREAD STATIC values -------------------------
Static Procedure __Initsthd(nBase)

    Local oTBigN

    __lsthdSet:=.F.

    __cstcZ0:="000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    __nstcZ0:=150

    __cstcN9:="999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    __nstcN9:=150
    
    #ifdef TBN_ARRAY
        __aZAdd:=Array(0)
        __aZSub:=Array(0)
        __aZMult:=Array(0)
    #endif    

    #ifdef TBN_DBFILE
        IF (__athdFiles==NIL)
            __athdFiles:=Array(0)
        EndIF
    #endif
    
    oTBigN:=tBigNumber():New("0",nBase)

    __eqoN1:=oTBigN:Clone()
    __eqoN2:=oTBigN:Clone()

    __gtoN1:=oTBigN:Clone()
    __gtoN2:=oTBigN:Clone()

    __ltoN1:=oTBigN:Clone()
    __ltoN2:=oTBigN:Clone()
    
    __cmpoN1:=oTBigN:Clone()
    __cmpoN2:=oTBigN:Clone()

    __adoNR:=oTBigN:Clone()
    __adoN1:=oTBigN:Clone()
    __adoN2:=oTBigN:Clone()

    __sboNR:=oTBigN:Clone()
    __sboN1:=oTBigN:Clone()
    __sboN2:=oTBigN:Clone()

    __mtoNR:=oTBigN:Clone()
    __mtoN1:=oTBigN:Clone()
    __mtoN2:=oTBigN:Clone()

    __dvoNR:=oTBigN:Clone()
    __dvoN1:=oTBigN:Clone()
    __dvoN2:=oTBigN:Clone()
    __dvoRDiv:=oTBigN:Clone()

    __pwoA:=oTBigN:Clone()
    __pwoB:=oTBigN:Clone()
    __pwoNP:=oTBigN:Clone()
    __pwoNR:=oTBigN:Clone()
    __pwoNT:=oTBigN:Clone()
    __pwoGCD:=oTBigN:Clone()
    
#ifdef __PTCOMPAT__
    __oeDivN:=oTBigN:Clone()
    __oeDivD:=oTBigN:Clone()
#endif //__PTCOMPAT__
    __oeDivR:=oTBigN:Clone()
    __oeDivQ:=oTBigN:Clone()
#ifdef __PTCOMPAT__
    __oeDivDvQ:=oTBigN:Clone()
    __oeDivDvR:=oTBigN:Clone()
#endif //__PTCOMPAT__

    __oSysSQRT:=oTBigN:Clone()
    
    __lsthdSet:=.T.

Return

// -------------------- assign STATIC values --------------------------------
Static Procedure __InitstbN(nBase)
    __lstbNSet:=.F.
    __o0:=tBigNumber():New("0",nBase)
    __o1:=tBigNumber():New("1",nBase)
    __o2:=tBigNumber():New("2",nBase)
*   __o5:=tBigNumber():New("5",nBase)
    __o10:=tBigNumber():New("10",nBase)
    __o20:=tBigNumber():New("20",nBase)
    __oMinFI:=tBigNumber():New(MAX_SYS_FI,nBase)
    __oMinGCD:=tBigNumber():New(MAX_SYS_GCD,nBase)
    __nMinLCM:=Int(hb_bLen(MAX_SYS_LCM)/2)
    #ifdef __PROTHEUS__
        DEFAULT __cEnvSrv:=GetEnvServer()
    #endif
    __lstbNSet:=.T.
Return

#ifdef __PROTHEUS__

    Static Function __eTthD()
    Return(StaticCall(__pteTthD,__eTthD))
    Static Function __PITthD()
    Return(StaticCall(__ptPITthD,__PITthD))

#else //__HARBOUR__

    Static Function __eTthD()
    Return(__hbeTthD())
    Static Function __PITthD()
    Return(__hbPITthD())
    
    /* warning: 'void HB_FUN_...()'  defined but not used [-Wunused-function]...*/    
    Static Function __Dummy(lDummy)
        lDummy:=.F.
        IF (lDummy)
            __Dummy()
            EGDIV()
            ECDIV()
            TBIGNPADL()
            TBIGNPADR()
            TBIGNREVERSE()
            TBIGNADD()
            TBIGNSUB()
            TBIGNMULT()
            TBIGNEGMULT()
            TBIGNEGDIV()
            TBIGNECDIV()
            TBIGNGDC()
            TBIGNLCM()
            TBIGNFI()
            TBIGNALEN()
            TBIGNMEMCMP()
        EndIF
    Return(lDummy)
    
#endif //__PROTHEUS__

#ifdef __HARBOUR__

    #pragma BEGINDUMP

        #include <stdio.h>
        #include <string.h>
        #include <hbapi.h>
        #include <hbdefs.h>
        #include <hbstack.h>
        #include <hbapiitm.h>

        static char * TBIGNReplicate(const char * szText,HB_ISIZ nTimes){
            HB_SIZE nLen    = strlen(szText);       
            HB_ISIZ nRLen   = (nLen*nTimes);
            char * szResult = (char*)hb_xgrab(nRLen+1);
            char * szPtr    = szResult;
            HB_ISIZ n;
            for(n=0;n<nTimes;++n)
            {
                memcpy(szPtr,szText,nLen);
                szPtr+=nLen;
            }
            return szResult;
        }

        static char * tBIGNPadL(const char * szItem,HB_ISIZ nLen,const char * szPad){
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%*.*s%s",padLen,padLen,padding,szItem);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }

        HB_FUNC_STATIC( TBIGNPADL ){      
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadL(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNPadR(const char * szItem,HB_ISIZ nLen,const char * szPad){    
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%s%*.*s",szItem,padLen,padLen,padding);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }
       
        HB_FUNC_STATIC( TBIGNPADR ){
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadR(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNReverse(const char * szF,const HB_SIZE s){
            HB_SIZE f  = s;
            HB_SIZE t  = 0;
            char * szT = (char*)hb_xgrab(s+1);
            for(;f;){
                szT[t++]=szF[--f];
            }
            memset(&szT[t],szF[t],1);
            return szT;
        }

        HB_FUNC_STATIC( TBIGNREVERSE ){
            const char * szF = hb_parc(1);
            const HB_SIZE s  = (HB_SIZE)hb_parnint(2);
            char * szR       = tBIGNReverse(szF,s);
            hb_retclen(szR,s);
            hb_xfree(szR);
        }

        static char * tBIGNAdd(const char * a, const char * b, int n, const HB_SIZE y, const HB_MAXUINT nB){    
            char * c         = (char*)hb_xgrab(y+1);
            HB_SIZE k        = y-1;
            HB_MAXUINT v     = 0;
            HB_MAXUINT v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')+(*(&b[n])-'0');
                if ( v>=nB ){
                    v  -= nB;
                    v1 = 1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v%nB];
                c[k-1] = "0123456789"[v1%nB];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNADD ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = (HB_SIZE)hb_parnint(4);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNAdd(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
   
        static char * tBIGNSub(const char * a, const char * b, int n, const HB_SIZE y, const HB_MAXUINT nB){
            char * c      = (char*)hb_xgrab(y+1);
            HB_SIZE k     = y-1;
            int v         = 0;
            int v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')-(*(&b[n])    -'0');
                if ( v<0 ){
                    v+=nB;
                    v1 = -1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v%nB];
                c[k-1] = "0123456789"[v1%nB];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNSUB ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = n;
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            char * szRet        = tBIGNSub(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }

        static char * tBIGNMult(const char * a, const char * b, HB_SIZE n, const HB_SIZE y, const HB_MAXUINT nB){
            
            char * c     = (char*)hb_xgrab(y+1);
            
            HB_SIZE i    = 0;
            HB_SIZE k    = 0;
            HB_SIZE l    = 1;
            HB_SIZE s;
            HB_SIZE j;
            
            HB_MAXUINT v = 0;
            HB_MAXUINT v1;
            
            n-=1;
            
            while (i<=n){
                s = 0;
                j = i;
                while (s<=i){
                    v+=(*(&a[s++])-'0')*(*(&b[j--])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
                    c[k]   = "0123456789"[v];
                    c[k+1] = "0123456789"[v1%nB];
               }else{
                    v1 = 0;
                    c[k]   = "0123456789"[v%nB];
                    c[k+1] = "0123456789"[v1];
                 };
                v = v1;
                k++;
                i++;
            }
        
            while (l<=n){
                s = n;
                j = l;
                while (s>=l){
                    v+=(*(&a[s--])-'0')*(*(&b[j++])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
                    c[k]   = "0123456789"[v];
                    c[k+1] = "0123456789"[v1%nB];
                }else{
                    v1     = 0;
                    c[k]   = "0123456789"[v%nB];
                    c[k+1] = "0123456789"[v1];                    
                }
                v = v1;
                if (++k>=y){
                    break;
                }
                l++;
            }        
            
            char * r = tBIGNReverse(c,y);
            hb_xfree(c);
    
            return r;
        }
    
        HB_FUNC_STATIC( TBIGNMULT ){
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = (HB_SIZE)hb_parnint(4);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNMult(a,b,n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
        
        typedef struct
        {
            char * cMultM;
            char * cMultP;
        } stBIGNeMult, * ptBIGNeMult;

        static void tBIGNegMult(const char * pN, const char * pD, int n, const HB_MAXUINT nB , ptBIGNeMult pegMult){
    
            PHB_ITEM peMTArr       = hb_itemArrayNew(0);
        
            ptBIGNeMult pegMultTmp = (ptBIGNeMult)hb_xgrab(sizeof(stBIGNeMult));
            
            char * Tmp             = tBIGNPadL("1",n,"0");
            pegMultTmp->cMultM     = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegMultTmp->cMultP     = hb_strdup(pD);
    
            Tmp                    = tBIGNPadL("0",n,"0");
            pegMult->cMultM        = hb_strdup(Tmp);
            pegMult->cMultP        = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            HB_MAXUINT nI          = 0;

            while (memcmp(pegMultTmp->cMultM,pN,n)<=0){

                 PHB_ITEM pNI = hb_itemArrayNew(2);
                
                    hb_arraySetC(pNI,1,pegMultTmp->cMultM);
                    hb_arraySetC(pNI,2,pegMultTmp->cMultP);
                    hb_arrayAddForward(peMTArr,pNI);  

                    char * tmp = tBIGNAdd(pegMultTmp->cMultM,pegMultTmp->cMultM,n,n,nB);
                    memcpy(pegMultTmp->cMultM,tmp,n);
                    hb_xfree(tmp);
                    
                    tmp        = tBIGNAdd(pegMultTmp->cMultP,pegMultTmp->cMultP,n,n,nB);                
                    memcpy(pegMultTmp->cMultP,tmp,n);
                    hb_xfree(tmp);

                 hb_itemRelease(pNI);

                ++nI;

            }
            
            hb_xfree(pegMultTmp->cMultM);
            hb_xfree(pegMultTmp->cMultP);

            while (nI){

                PHB_ITEM pNI = hb_arrayGetItemPtr(peMTArr,nI);
                
                pegMultTmp->cMultM = tBIGNAdd(pegMult->cMultM,hb_arrayGetCPtr(pNI,1),n,n,nB);
                memcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                hb_xfree(pegMultTmp->cMultM);
    
                pegMultTmp->cMultP = tBIGNAdd(pegMult->cMultP,hb_arrayGetCPtr(pNI,2),n,n,nB);
                memcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
                hb_xfree(pegMultTmp->cMultP);
                
                int iCmp = memcmp(pegMult->cMultM,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegMultTmp->cMultM = tBIGNSub(pegMult->cMultM,hb_arrayGetCPtr(pNI,1),n,n,nB);
                            memcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                            hb_xfree(pegMultTmp->cMultM);
    
                            pegMultTmp->cMultP = tBIGNSub(pegMult->cMultP,hb_arrayGetCPtr(pNI,2),n,n,nB);
                            memcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
                            hb_xfree(pegMultTmp->cMultP);
    
                    }
                }  
                
                --nI;
                
            }

            hb_xfree(pegMultTmp);
            hb_itemRelease(peMTArr);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGMULT ){
            
            const char * pN     = hb_parc(1);
            const char * pD     = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            
            ptBIGNeMult pegMult  = (ptBIGNeMult)hb_xgrab(sizeof(stBIGNeMult));
            
            tBIGNegMult(pN,pD,(int)n,nB,pegMult);
        
            hb_retclen(pegMult->cMultP,n);

            hb_xfree(pegMult->cMultM);
            hb_xfree(pegMult->cMultP);
            hb_xfree(pegMult);
        }

        typedef struct
        {
            char * cDivQ;
            char * cDivR;
        } stBIGNeDiv, * ptBIGNeDiv;

        static void tBIGNegDiv(const char * pN, const char * pD, int n, const HB_MAXUINT nB , ptBIGNeDiv pegDiv){
    
            PHB_ITEM peDVArr     = hb_itemArrayNew(0);
        
            ptBIGNeDiv pegDivTmp = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            
            char * Tmp           = tBIGNPadL("1",n,"0");
            pegDivTmp->cDivQ     = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegDivTmp->cDivR     = hb_strdup(pD);
    
            Tmp                  = tBIGNPadL("0",n,"0");
            pegDiv->cDivQ        = hb_strdup(Tmp);
            pegDiv->cDivR        = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            HB_MAXUINT nI        = 0;

            while (memcmp(pegDivTmp->cDivR,pN,n)<=0){

                 PHB_ITEM pNI = hb_itemArrayNew(2);
                
                    hb_arraySetC(pNI,1,pegDivTmp->cDivQ);
                    hb_arraySetC(pNI,2,pegDivTmp->cDivR);
                    hb_arrayAddForward(peDVArr,pNI);  

                    char * tmp = tBIGNAdd(pegDivTmp->cDivQ,pegDivTmp->cDivQ,n,n,nB);
                    memcpy(pegDivTmp->cDivQ,tmp,n);
                    hb_xfree(tmp);
                    
                    tmp        = tBIGNAdd(pegDivTmp->cDivR,pegDivTmp->cDivR,n,n,nB);                
                    memcpy(pegDivTmp->cDivR,tmp,n);
                    hb_xfree(tmp);

                 hb_itemRelease(pNI);

                ++nI;

            }
            
            hb_xfree(pegDivTmp->cDivQ);
            hb_xfree(pegDivTmp->cDivR);

            while (nI){

                PHB_ITEM pNI = hb_arrayGetItemPtr(peDVArr,nI);
                
                pegDivTmp->cDivQ = tBIGNAdd(pegDiv->cDivQ,hb_arrayGetCPtr(pNI,1),n,n,nB);
                memcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                hb_xfree(pegDivTmp->cDivQ);
    
                pegDivTmp->cDivR = tBIGNAdd(pegDiv->cDivR,hb_arrayGetCPtr(pNI,2),n,n,nB);
                memcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
                hb_xfree(pegDivTmp->cDivR);
                
                int iCmp = memcmp(pegDiv->cDivR,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegDivTmp->cDivQ = tBIGNSub(pegDiv->cDivQ,hb_arrayGetCPtr(pNI,1),n,n,nB);
                            memcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                            hb_xfree(pegDivTmp->cDivQ);
    
                            pegDivTmp->cDivR = tBIGNSub(pegDiv->cDivR,hb_arrayGetCPtr(pNI,2),n,n,nB);
                            memcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
                            hb_xfree(pegDivTmp->cDivR);
    
                    }
                }  
                
                --nI;
                
            }

            hb_itemRelease(peDVArr);
    
            pegDivTmp->cDivR = tBIGNSub(pN,pegDiv->cDivR,n,n,nB);
            memcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
            hb_xfree(pegDivTmp->cDivR);
            hb_xfree(pegDivTmp);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGDIV ){
            
            const char * pN     = hb_parc(1);
            const char * pD     = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(4);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            
            ptBIGNeDiv pegDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            
            tBIGNegDiv(pN,pD,(int)n,nB,pegDiv);
            
            hb_storclen(pegDiv->cDivR,n,3);
            hb_retclen(pegDiv->cDivQ,n);

            hb_xfree(pegDiv->cDivR);
            hb_xfree(pegDiv->cDivQ);
            hb_xfree(pegDiv);
        }
        
        static void tBIGNecDiv(const char * pA, const char * pB, int ipN, const HB_MAXUINT nB , ptBIGNeDiv pecDiv){
            
            char * a        = tBIGNPadL(pA,ipN,"0");
            char * b        = tBIGNPadL(pB,ipN,"0");
            
            pecDiv->cDivR   = hb_strdup(a);
            pecDiv->cDivQ   = tBIGNPadL("0",ipN,"0");
            int n           = 0;
            char * aux      = hb_strdup(b);
            
            char * sN1      = tBIGNPadL("1",ipN,"0");
            char * sN2      = tBIGNPadL("2",ipN,"0");
            
            char * tmp;
            
            HB_MAXUINT ipNS1 = ipN-1;

            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            HB_MAXUINT i;
          
            ptBIGNeDiv  pecDivTmp   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            //ptBIGNeMult pegMultTmp  = (ptBIGNeMult)hb_xgrab(sizeof(stBIGNeMult));
            
            while (memcmp(aux,a,ipN)<=0){
                n++;
                v1 = 0;
                for(i=ipNS1;i>0;i--){
                    v = (*(&aux[i])-'0');
                    v <<= 1;
                    v += v1;
                    if (v>=nB){
                        v1 = v/nB;
                        v %= nB;
                        aux[i] = "0123456789"[v];
                    }else{
                        v1 = 0;
                        aux[i] = "0123456789"[v%nB];                        
                    }
                }
                /*
                tBIGNegMult(aux,sN2,ipN,nB,pegMultTmp);
                memcpy(aux,pegMultTmp->cMultP,ipN);
                hb_xfree(pegMultTmp->cMultP);
                hb_xfree(pegMultTmp->cMultM);
                */
            }

            while (n){                
                --n;                
                tBIGNegDiv(aux,sN2,ipN,nB,pecDivTmp);
                memcpy(aux,pecDivTmp->cDivQ,ipN);
                hb_xfree(pecDivTmp->cDivQ);
                hb_xfree(pecDivTmp->cDivR);    
                v1 = 0;
                for(i=ipNS1;i>0;i--){
                    v = (*(&pecDiv->cDivQ[i])-'0');
                    v <<= 1;
                    v += v1;
                    if (v>=nB){
                        v1 = v/nB;
                        v %= nB;
                        pecDiv->cDivQ[i] = "0123456789"[v];
                    }else{
                        v1 = 0;    
                        pecDiv->cDivQ[i] = "0123456789"[v%nB];
                    }                    
                }
                /*
                tBIGNegMult(pecDiv->cDivQ,sN2,ipN,nB,pegMultTmp);
                memcpy(pecDiv->cDivQ,pegMultTmp->cMultP,ipN);
                hb_xfree(pegMultTmp->cMultP);
                hb_xfree(pegMultTmp->cMultM);
                */
                if (memcmp(pecDiv->cDivR,aux,ipN)>=0){
                    tmp = tBIGNSub(pecDiv->cDivR,aux,ipN,ipN,nB);
                    memcpy(pecDiv->cDivR,tmp,ipN);
                    hb_xfree(tmp);
                    tmp = tBIGNAdd(pecDiv->cDivQ,sN1,ipN,ipN,nB);
                    memcpy(pecDiv->cDivQ,tmp,ipN);
                    hb_xfree(tmp);
                }
            }
            
            hb_xfree(a);
            hb_xfree(b);
            hb_xfree(aux);
            hb_xfree(sN1);
            hb_xfree(sN2);
            hb_xfree(pecDivTmp);
            //hb_xfree(pegMultTmp);
            
        }
        
        HB_FUNC_STATIC( TBIGNECDIV ){
            
            const char * pN     = hb_parc(1);
            const char * pD     = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(4);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            
            ptBIGNeDiv pecDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
          
            tBIGNecDiv(pN,pD,(int)(n+=2),nB,pecDiv);
            
            hb_storclen(pecDiv->cDivR,n,3);
            hb_retclen(pecDiv->cDivQ,n);

            hb_xfree(pecDiv->cDivR);
            hb_xfree(pecDiv->cDivQ);
            hb_xfree(pecDiv);
        }
                
        /*
        static HB_MAXUINT tBIGNGDC(HB_MAXUINT x, HB_MAXUINT y){
            HB_MAXUINT nGCD = x;  
            x = HB_MAX(y,nGCD);
            y = HB_MIN(nGCD,y);
            if (y==0){
               nGCD = x;
            } else {
                  nGCD = y;
                  while (HB_TRUE){
                      if ((y=(x%y))==0){
                          break;
                      }
                      x    = nGCD;
                      nGCD = y;
                  }
            }
            return nGCD;
        }*/
        
        //http://en.wikipedia.org/wiki/Binary_GCD_algorithm
        static HB_MAXUINT tBIGNGDC(HB_MAXUINT u, HB_MAXUINT v){
          int shift;
         
          /* GCD(0,v) == v; GCD(u,0) == u, GCD(0,0) == 0 */
          if (u == 0) return v;
          if (v == 0) return u;
         
          /* Let shift := lg K, where K is the greatest power of 2
                dividing both u and v. */
          for (shift = 0; ((u | v) & 1) == 0; ++shift) {
                 u >>= 1;
                 v >>= 1;
          }
         
          while ((u & 1) == 0)
            u >>= 1;
         
          /* From here on, u is always odd. */
          do {
               /* remove all factors of 2 in v -- they are not common */
               /*   note: v is not zero, so while will terminate */
               while ((v & 1) == 0)  /* Loop X */
                   v >>= 1;
         
               /* Now u and v are both odd. Swap if necessary so u <= v,
                  then set v = v - u (which is even). For bignums, the
                  swapping is just pointer movement, and the subtraction
                  can be done in-place. */
               if (u > v) {
                 unsigned int t = v; v = u; u = t;}  // Swap u and v.
               v = v - u;                            // Here v >= u.
             } while (v != 0);
         
          /* restore common factors of 2 */
          return u << shift;
        }

        HB_FUNC_STATIC( TBIGNGDC ){
            hb_retnint(tBIGNGDC((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        /*
        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x, HB_MAXUINT y){
             
            HB_MAXUINT nLCM = 1;
            HB_MAXUINT i    = 2;
        
            HB_BOOL lMx;
            HB_BOOL lMy;
        
            while (HB_TRUE){
                lMx = ((x%i)==0);
                lMy = ((y%i)==0);
                while (lMx||lMy){
                    nLCM *= i;
                    if (lMx){
                        x   /= i;
                        lMx = ((x%i)==0);
                    }
                    if (lMy){
                        y   /= i;
                        lMy = ((y%i)==0);
                    }
                }
                if ((x==1)&&(y==1)){
                    break;
                }
                ++i;
            }
            
            return nLCM;

        }
        */

        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x, HB_MAXUINT y){
            return (y/tBIGNGDC(x,y))*x;
        }    
        
        HB_FUNC_STATIC( TBIGNLCM ){
            hb_retnint(tBIGNLCM((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        static HB_MAXUINT tBIGNFI(HB_MAXUINT n){
            HB_MAXUINT i;
            HB_MAXUINT fi = n;
            for(i=2;((i*i)<=n);i++){
                if ((n%i)==0){
                    fi -= fi/i;
                }    
                while ((n%i)==0){
                    n /= i;
                }    
            } 
               if (n>1){
                   fi -= fi/n;
               }     
               return fi; 
        }
        
        HB_FUNC_STATIC( TBIGNFI ){
            hb_retnint(tBIGNFI((HB_MAXUINT)hb_parnint(1)));
        }
        
        HB_FUNC_STATIC( TBIGNALEN ){
           hb_retns(hb_arrayLen(hb_param(1,HB_IT_ARRAY)));
        }
      
        HB_FUNC_STATIC( TBIGNMEMCMP ){
           hb_retnint(memcmp(hb_parc(1),hb_parc(2),hb_parclen(1)));
        }
    
    #pragma ENDDUMP

#endif // __HARBOUR__