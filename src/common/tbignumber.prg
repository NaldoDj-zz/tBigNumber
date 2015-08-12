/*
 *  t    bbbb   iiiii  ggggg  n   n  u   u  mm mm  bbbb   eeeee  rrrr
 * ttt   b   b    i    g      nn  n  u   u  mm mm  b   b  e      r   r
 *  t    bbbb     i    g ggg  n n n  u   u  m m m  bbbb   eeee   rrrr
 *  t t  b   b    i    g   g  n  nn  u   u  m m m  b   b  e      r   r
 *  ttt  bbbbb  iiiii  ggggg  n   n  uuuuu  m   m  bbbbb  eeeee  r   r
 *
 * Copyright 2013-2015 Marinaldo de Jesus <marinaldo\/.\/jesus\/@\/blacktdn\/.\/com\/.\/br>
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
    //-------------------------------------------------------------------------------------
    #xtranslate hb_bLen([<prm,...>])        => Len([<prm>])
    #xtranslate tBIGNaLen([<prm,...>])      => Len([<prm>])
    #xtranslate hb_mutexCreate()            => ThreadID()
    #xtranslate hb_mutexLock([<prm,...>])   => AllWaysTrue([<prm>])
    #xtranslate hb_mutexUnLock([<prm,...>]) => AllWaysTrue([<prm>])
    #xtranslate method <methodName> SETGET  => method <methodName>
    #define MTX_KEY "TBIGNUMBER_0000000000"
    //-------------------------------------------------------------------------------------
#else // __HARBOUR__
    //-------------------------------------------------------------------------------------
    #xtranslate PadL([<prm,...>])    => tBIGNPadL([<prm>])
    #xtranslate PadR([<prm,...>])    => tBIGNPadR([<prm>])
    #xtranslate Left([<prm,...>])    => hb_bLeft([<prm>])
    #xtranslate Right([<prm,...>])   => hb_bRight([<prm>])
    #xtranslate SubStr([<prm,...>])  => hb_bSubStr([<prm>])
    #xtranslate AT([<prm,...>])      => hb_bAT([<prm>])
    #xtranslate Max([<prm,...>])     => tBIGNMax([<prm>])
    #xtranslate Min([<prm,...>])     => tBIGNMin([<prm>])
    //-------------------------------------------------------------------------------------
#endif //__PROTHEUS__

#ifndef __DIVMETHOD__
    #define __DIVMETHOD__ 1
#endif

static s__cN0
static s__nN0
static s__cN9
static s__nN9

static s__o0
static s__o1
static s__o2
static s__o3
static s__o10
static s__od2

static s__oMinFI
static s__oMinGCD
static s__nMinLCM

static s__lstbNSet

static s__nDivMTD

static s__nthRAcc
static s__nDecSet

static s__SysSQRT

static s__MTXcN0:=hb_mutexCreate()
static s__MTXcN9:=hb_mutexCreate()
static s__MTXACC:=hb_mutexCreate()
static s__MTXDEC:=hb_mutexCreate()
static s__MTXSQR:=hb_mutexCreate()

#ifdef TBN_ARRAY
    #define __THREAD_STATIC__ 1
#else
    #ifdef TBN_DBFILE
        #define __THREAD_STATIC__ 1
    #endif
#endif

#ifdef __THREAD_STATIC__
    thread static ths_lsdSet
    #ifdef TBN_ARRAY
        thread static ths_aZAdd
        thread static ths_aZSub
        thread static ths_aZMult
    #else
        #ifdef TBN_DBFILE
            thread static ths_aFiles
        #endif
    #endif
#endif

#define RANDOM_MAX_EXIT 5
#define EXIT_MAX_RANDOM 50

#define NTHROOT_EXIT    3
#define MAX_SYS_SQRT    "9999999999999999"
#define MAX_SYS_lMULT   "9999999999"
#define MAX_SYS_lADD    "99999999999999999"
#define MAX_SYS_lSUB    "99999999999999999"
#define MAX_SYS_iMULT   "999999999999999999"
#define MAX_SYS_GCD     MAX_SYS_iMULT
#define MAX_SYS_LCM     MAX_SYS_iMULT

#define MAX_SYS_FI      MAX_SYS_iMULT

/*
*    Alternative Compile Options: -d
*
*    #ifdef __PROTHEUS__
*        -dTBN_ARRAY
*        -dTBN_DBFILE
*        -d__TBN_DYN_OBJ_SET__
*    #else //__HARBOUR__
*        -dTBN_ARRAY
*        -dTBN_DBFILE
*        -dTBN_MEMIO
*        -d__TBN_DYN_OBJ_SET__
*        -d__PTCOMPAT__
*    #endif
*/

/*
    class:tBigNumber
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Instancia um novo objeto do tipo BigNumber
    Sintaxe:tBigNumber():New(uBigN) -> self
*/
#ifdef __PROTHEUS__
class tBigNumber from LongClassName
#else //__HARBOUR__
class tBigNumber from hbClass
#endif //__PROTHEUS__

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

    method New(uBigN,nBase) CONSTRUCTOR /*( /!\ )*/

#ifndef __PROTHEUS__
    #ifdef TBN_DBFILE
        DESTRUCTOR tBigNGC
    #endif
#endif

    method Normalize(oBigN)

    method __cDec(cDec)   SETGET
    method __cInt(cInt)   SETGET
    method __cRDiv(cRDiv) SETGET
    method __cSig(cSig)   SETGET
    method __lNeg(lNeg)   SETGET
    method __nBase(nBase) SETGET
    method __nDec(nDec)   SETGET
    method __nInt(nInt)   SETGET
    method __nSize(nSize) SETGET

    method Clone()
    method className()

    method SetDecimals(nSet)

    method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc)
    method GetValue(lAbs,lObj)
    method ExactValue(lAbs,lObj)

    method Abs(lObj)

    method Int(lObj,lSig)
    method Dec(lObj,lSig,lNotZ)

    method eq(uBigN)
    method ne(uBigN)
    method gt(uBigN)
    method lt(uBigN)
    method gte(uBigN)
    method lte(uBigN)
    method cmp(uBigN)
    method btw(uBigS,uBigE)
    method ibtw(uiBigS,uiBigE)

    method Max(uBigN)
    method Min(uBigN)

    method Add(uBigN)
#ifndef __PROTHEUS__
    method Plus(uBigN) INLINE self:Add(uBigN)
#else
    method Plus(uBigN)
#endif

    method iAdd(uBigN)
#ifndef __PROTHEUS__
    method iPlus(uBigN) INLINE self:iAdd(uBigN)
#else
    method iPlus(uBigN)
#endif

    method Sub(uBigN)
#ifndef __PROTHEUS__
    method Minus(uBigN) INLINE self:Sub(uBigN)
#else
    method Minus(uBigN)
#endif

    method iSub(uBigN)
#ifndef __PROTHEUS__
    method iMinus(uBigN) INLINE self:iSub(uBigN)
#else
    method iMinus(uBigN)
#endif

    method Mult(uBigN)
#ifndef __PROTHEUS__
    method Multiply(uBigN) INLINE self:Mult(uBigN)
#else
    method Multiply(uBigN)
#endif

    method iMult(uBigN)
#ifndef __PROTHEUS__
    method iMultiply(uBigN) INLINE self:iMult(uBigN)
#else
    method iMultiply(uBigN)
#endif

    method egMult(uBigN)
#ifndef __PROTHEUS__
    method egMultiply(uBigN) INLINE self:egMult(uBigN)
#else
    method egMultiply(uBigN)
#endif

    method rMult(uBigN)
#ifndef __PROTHEUS__
    method rMultiply(uBigN) INLINE self:rMult(uBigN)
#else
    method rMultiply(uBigN)
#endif

    method Div(uBigN,lFloat)
#ifndef __PROTHEUS__
    method Divide(uBigN,lFloat) INLINE self:Div(uBigN,lFloat)
#else
    method Divide(uBigN,lFloat)
#endif

    method Divmethod(nmethod)

    method Mod(uBigN)

    method Pow(uBigN)

    method OpInc()
    method OpDec()

    method e(lforce)

    method Exp(lforce)

    method PI(lforce)    //TODO: Implementar o calculo.

    method GCD(uBigN)
    method LCM(uBigN)

    method nthRoot(uBigN)
    method nthRootPF(uBigN)
    method nthRootAcc(nSet)

    method SQRT()
    method SysSQRT(uSet)

    method Log(uBigNB)
    method LogN(uBigNB)

    method __Log(uBigNB)
    method __LogN(uBigNB)   //TODO: Validar Calculo.

    method Log2()         //TODO: Validar Calculo.
    method Log10()        //TODO: Validar Calculo.

    method Ln()           //TODO: Validar Calculo.

    method MathC(uBigN1,cOperator,uBigN2)
    method MathN(uBigN1,cOperator,uBigN2)

    method Rnd(nAcc)
    method NoRnd(nAcc)
    method Truncate(nAcc)
    method Floor(nAcc)   //TODO: Verificar regra a partir de referencias bibliograficas.
    method Ceiling(nAcc) //TODO: Verificar regra a partir de referencias bibliograficas.

    method D2H(cHexB)
    method H2D()

    method H2B()
    method B2H(cHexB)

    method D2B(cHexB)
    method B2D(cHexB)

    method Randomize(uB,uE,nExit)

    method millerRabin(uI)

    method FI()

    method PFactors()
    method Factorial()    //TODO: Otimizar+
    
    method Fibonacci()

#ifndef __PROTHEUS__

         /* Operators Overloading:
             "+"     =>__OpPlus
             "-"     =>__OpMinus
             "*"     =>__OpMult
             "/"     =>__OpDivide
             "%"     =>__OpMod
             "^"     =>__OpPower
             "**"    =>__OpPower
             "++"    =>__OpInc
             "--"    =>__OpDec
             "=="    =>__OpEqual
             "="     =>__OpEqual (same as "==")
             "!="    =>__OpNotEqual
             "<>"    =>__OpNotEqual (same as "!=")
             "#"     =>__OpNotEqual (same as "!=")
             "<"     =>__OpLess
             "<="    =>__OpLessEqual
             ">"     =>__OpGreater
             ">="    =>__OpGreaterEqual
             "$"     =>__OpInstring
             "$$"    =>__OpInclude
             "!"     =>__OpNot
             ".not." =>__OpNot (same as "!")
             ".and." =>__OpAnd
             ".or."  =>__OpOr
             ":="    =>__OpAssign
             "[]"    =>__OpArrayIndex
        */

/*(*)*/ /* OPERATORS NOT IMPLEMENTED: hb_APICLS.H, CLASSES.C AND HVM.C */

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

endclass

#ifndef __PROTHEUS__

    /* overloaded methods/functions */

    static function __OpEqual(oSelf,uBigN)
    return(oSelf:eq(uBigN))

    static function __OpNotEqual(oSelf,uBigN)
    return(oSelf:ne(uBigN))

    static function __OpGreater(oSelf,uBigN)
    return(oSelf:gt(uBigN))

    static function __OpGreaterEqual(oSelf,uBigN)
    return(oSelf:gte(uBigN))

    static function __OpLess(oSelf,uBigN)
    return(oSelf:lt(uBigN))

    static function __OpLessEqual(oSelf,uBigN)
    return(oSelf:lte(uBigN))

    static function __OpInc(oSelf)
    return(oSelf:OpInc())

    static function __OpDec(oSelf)
    return(oSelf:OpDec())

    static function __OpPlus(cOp,oSelf,uBigN)
        local oOpPlus
        if cOp=="+="
            oOpPlus:=oSelf:SetValue(oSelf:Add(uBigN))
        else
            oOpPlus:=oSelf:Add(uBigN)
        endif
    return(oOpPlus)

    static function __OpMinus(cOp,oSelf,uBigN)
        local oOpMinus
        if cOp=="-="
            oOpMinus:=oSelf:SetValue(oSelf:Sub(uBigN))
        else
            oOpMinus:=oSelf:Sub(uBigN)
        endif
    return(oOpMinus)

    static function __OpMult(cOp,oSelf,uBigN)
        local oOpMult
        if cOp=="*="
            oOpMult:=oSelf:SetValue(oSelf:Mult(uBigN))
        else
            oOpMult:=oSelf:Mult(uBigN)
        endif
    return(oOpMult)

    static function __OpDivide(cOp,oSelf,uBigN,lFloat)
        local oOpDivide
        if cOp=="/="
            oOpDivide:=oSelf:SetValue(oSelf:Div(uBigN,lFloat))
        else
            oOpDivide:=oSelf:Div(uBigN,lFloat)
        endif
    return(oOpDivide)

    static function __OpMod(cOp,oSelf,uBigN)
        local oOpMod
        if cOp=="%="
            oOpMod:=oSelf:SetValue(oSelf:Mod(uBigN))
        else
            oOpMod:=oSelf:Mod(uBigN)
        endif
    return(oOpMod)

    static function __OpPower(cOp,oSelf,uBigN)
        local oOpPower
        switch cOp
            case "^="
            case "**="
                oOpPower:=oSelf:SetValue(oSelf:Pow(uBigN))
                exit
            otherwise
                oOpPower:=oSelf:Pow(uBigN)
        endswitch
    return(oOpPower)

    static function __OpAssign(oSelf,uBigN,nBase,cRDiv,lLZRmv,nAcc)
    return(oSelf:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))

#else //INLINE HARBOUR METHODS

    method Plus(uBigN) class tBigNumber
    return(self:Add(uBigN))

    method iPlus(uBigN) class tBigNumber
    return(self:iAdd(uBigN))
    
    method Minus(uBigN) class tBigNumber
    return(self:Sub(uBigN))

    method iMinus(uBigN) class tBigNumber
    return(self:iSub(uBigN))
    
    method Multiply(uBigN)  class tBigNumber
    return(self:Mult(uBigN))

    method iMultiply(uBigN)  class tBigNumber
    return(self:iMult(uBigN))
    
    method egMultiply(uBigN) class tBigNumber
    return(self:egMult(uBigN))

    method rMultiply(uBigN) class tBigNumber
    return(self:rMult(uBigN))

    method Divide(uBigN,lFloat) class tBigNumber
    return(self:Div(uBigN,lFloat))

#endif //__PROTHEUS__

/*
    function:tBigNumber():New
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Instancia um novo Objeto tBigNumber
    Sintaxe:tBigNumber():New(uBigN,nBase) -> self
*/
#ifdef __PROTHEUS__
    user function tBigNumber(uBigN,nBase)
    return(tBigNumber():New(@uBigN,@nBase))
#endif

/*
    method:New
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:CONSTRUCTOR
    Sintaxe:tBigNumber():New(uBigN,nBase) -> self
*/
method New(uBigN,nBase) class tBigNumber

    DEFAULT nBase:=10
    self:nBase:=nBase

    if s__nDecSet==NIL
        self:SetDecimals()
    endif

    if s__nthRAcc==NIL
        self:nthRootAcc()
    endif

    // -------------------- assign thread static values -------------------------
    #ifdef __THREAD_STATIC__
        if ths_lsdSet==NIL
            __Initsthd()
        endif
    #endif //__THREAD_STATIC__    

    DEFAULT uBigN:="0"
    self:SetValue(uBigN,nBase)

     // -------------------- assign static values --------------------------------
    if s__lstbNSet==NIL
        __InitstbN(nBase)
        self:Divmethod(__DIVMETHOD__)
    endif

return(self)

/*
    method:tBigNGC
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:03/03/2013
    Descricao:DESTRUCTOR
*/
#ifdef TBN_DBFILE
    #ifdef __HARBOUR__
        procedure tBigNGC() class tBigNumber
    #else
        static procedure tBigNGC()
    #endif
            local nFile
            local nFiles
            DEFAULT ths_aFiles:=Array(0)
            nFiles:=tBIGNaLen(ths_aFiles)
            for nFile:=1 to nFiles
                if Select(ths_aFiles[nFile][1])>0
                    (ths_aFiles[nFile][1])->(dbCloseArea())
                endif
                #ifdef __PROTHEUS__
                    MsErase(ths_aFiles[nFile][2],NIL,if((Type("__localDriver")=="C"),__localDriver,"DBFCDXADS"))
                #else
                    #ifdef TBN_MEMIO
                        dbDrop(ths_aFiles[nFile][2])
                    #else
                        fErase(ths_aFiles[nFile][2])
                    #endif
                #endif
            next nFile
            aSize(ths_aFiles,0)
        return
#endif

/*
    method:__cDec
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__cDec
    Sintaxe:tBigNumber():__cDec() -> cDec
*/
method __cDec(cDec) class tBigNumber
    if .not.(cDec==NIL)
        self:lNeg:=Left(cDec,1)=="-"
        if self:lNeg
            cDec:=SubStr(cDec,2)
        endif
        self:cDec:=cDec
        self:nDec:=hb_bLen(cDec)
        self:nSize:=self:nInt+self:nDec
        if self:eq(s__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
    endif
return(self:cDec)

/*
    method:__cInt
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__cDec
    Sintaxe:tBigNumber():__cInt() -> cInt
*/
method __cInt(cInt) class tBigNumber
    if .not.(cInt==NIL)
        self:lNeg:=Left(cInt,1)=="-"
        if self:lNeg
            cInt:=SubStr(cInt,2)
        endif
        self:cInt:=cInt
        self:nInt:=hb_bLen(cInt)
        self:nSize:=self:nInt+self:nDec
        if self:eq(s__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
    endif
return(self:cInt)

/*
    method:__cRDiv
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/03/2014
    Descricao:__cRDiv
    Sintaxe:tBigNumber():__cRDiv() -> __cRDiv
*/
method __cRDiv(cRDiv) class tBigNumber
    if .not.(cRDiv==NIL)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        self:cRDiv:=cRDiv
    endif
return(self:cRDiv)

/*
    method:__cSig
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__cSig
    Sintaxe:tBigNumber():__cSig() -> cSig
*/
method __cSig(cSig) class tBigNumber
    if .not.(cSig==NIL)
        self:cSig:=cSig
        self:lNeg:=(cSig=="-")
        if self:eq(s__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
        if .not.(self:lNeg)
            self:cSig:=""
        endif
    endif
return(self:cSig)

/*
    method:__lNeg
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__lNeg
    Sintaxe:tBigNumber():__lNeg() -> lNeg
*/
method __lNeg(lNeg) class tBigNumber
    if .not.(lNeg==NIL)
        self:lNeg:=lNeg
        if self:eq(s__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
        if lNeg
            self:cSig:="-"
        endif
    endif
return(self:lNeg)

/*
    method:__nBase
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__nBase
    Sintaxe:tBigNumber():__nBase() -> nBase
*/
method __nBase(nBase) class tBigNumber
    if .not.(nBase==NIL)
        self:nBase:=nBase
    endif
return(self:nBase)

/*
    method:__nDec
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__nDec
    Sintaxe:tBigNumber():__nDec() -> nDec
*/
method __nDec(nDec) class tBigNumber
    if .not.(nDec==NIL)
        if nDec>self:nDec
            self:cDec:=PadR(self:cDec,nDec,"0")
        else
            self:cDec:=Left(self:cDec,nDec)
        endif
        self:nDec:=nDec
        self:nSize:=self:nInt+self:nDec
    endif
return(self:nDec)

/*
    method:__nInt
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:__nInt
    Sintaxe:tBigNumber():__nInt() -> nInt
*/
method __nInt(nInt) class tBigNumber
    if .not.(nInt==NIL)
        if nInt>self:nInt
            self:cInt:=PadL(self:cInt,nInt,"0")
            self:nInt:=nInt
            self:nSize:=self:nInt+self:nDec
        endif
    endif
return(self:nInt)

/*
    method:__nSize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:17/02/2014
    Descricao:nSize
    Sintaxe:tBigNumber():__nSize() -> nSize
*/
method __nSize(nSize) class tBigNumber
    if .not.(nSize==NIL)
        if nSize>self:nInt+self:nDec
            if self:nInt>self:nDec
                self:nInt:=nSize-self:nDec
                self:cInt:=PadL(self:cInt,self:nInt,"0")
            else
                 self:nDec:=nSize-self:nInt
                 self:cDec:=PadR(self:cDec,self:nDec,"0")
            endif
            self:nSize:=nSize
        endif
    endif
return(self:nSize)

/*
    method:Clone
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:27/03/2013
    Descricao:Clone
    Sintaxe:tBigNumber():Clone() -> oClone
*/
method Clone() class tBigNumber
    local oClone    
    #ifdef __THREAD_STATIC__
        try
            if ths_lsdSet==NIL
                oClone:=tBigNumber():New(self)
            else
                #ifdef __PROTHEUS__
                    oClone:=tBigNumber():New(self)
                #else  //__HARBOUR__
                    oClone:=__objClone(self)
                #endif //__PROTHEUS__
            endif
        catch    
            ths_lsdSet:=NIL
            oClone:=tBigNumber():New(self)
        end
    #else
        #ifdef __PROTHEUS__
            oClone:=tBigNumber():New(self)
        #else  //__HARBOUR__
            oClone:=__objClone(self)
        #endif //__PROTHEUS__
    #endif //__THREAD_STATIC__    
return(oClone)
    
/*
    method:className
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:className
    Sintaxe:tBigNumber():className() -> cclassName
*/
method className() class tBigNumber
return("TBIGNUMBER")

/*
    method:SetDecimals
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Setar o Numero de Casas Decimais
    Sintaxe:tBigNumber():SetDecimals(nSet) -> nLastSet
*/
method SetDecimals(nSet) class tBigNumber

    local nLastSet

    while .not.(hb_mutexLock(s__MTXDEC))
    end while

    nLastSet:=s__nDecSet

    DEFAULT s__nDecSet:=if(nSet==NIL,32,nSet)
    DEFAULT nSet:=s__nDecSet
    DEFAULT nLastSet:=nSet

    #ifdef _0
        if nSet>MAX_DECIMAL_PRECISION
            nSet:=MAX_DECIMAL_PRECISION
        endif
    #endif

    s__nDecSet:=nSet

    hb_mutexUnLock(s__MTXDEC)

    DEFAULT nLastSet:=if(nSet==NIL,32,nSet)

return(nLastSet)

/*
    method:nthRootAcc
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Setar a Precisao para nthRoot
    Sintaxe:tBigNumber():nthRootAcc(nSet) -> nLastSet
*/
method nthRootAcc(nSet) class tBigNumber

    local nLastSet

    while .not.(hb_mutexLock(s__MTXACC))
    end while

    nLastSet:=s__nthRAcc

    DEFAULT s__nthRAcc:=if(nSet==NIL,6,nSet)
    DEFAULT nSet:=s__nthRAcc
    DEFAULT nLastSet:=nSet

    if nSet>MAX_DECIMAL_PRECISION
        nSet:=MAX_DECIMAL_PRECISION
    endif

    s__nthRAcc:=Min(self:SetDecimals()-1,nSet)

    hb_mutexUnLock(s__MTXACC)

    DEFAULT nLastSet:=if(nSet==NIL,6,nSet)

return(nLastSet)

/*
    method:SetValue
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:SetValue
    Sintaxe:tBigNumber():SetValue(uBigN,nBase,cRDiv,lLZRmv) -> self
*/
method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc) class tBigNumber

    local cType:=ValType(uBigN)

    local nFP

    #ifdef __TBN_DYN_OBJ_SET__
    local nP
        #ifdef __HARBOUR__
            MEMVAR pThis
        #endif
        private pThis
    #endif

    if cType=="O"

        DEFAULT cRDiv:=uBigN:cRDiv

        #ifdef __TBN_DYN_OBJ_SET__

            #ifdef __PROTHEUS__

                This:=self
                uBigN:=classDataArr(uBigN)
                nFP:=hb_bLen(uBigN)

                for nP:=1 to nFP
                    &("This:"+uBigN[nP][1]):=uBigN[nP][2]
                next nP

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

    elseif cType=="A"

        DEFAULT cRDiv:=uBigN[3][2]

        #ifdef __TBN_DYN_OBJ_SET__

            pThis:=self
            nFP:=hb_bLen(uBigN)

            for nP:=1 to nFP
                &("pThis:"+uBigN[nP][1]):=uBigN[nP][2]
            next nP

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

    elseif cType=="C"

        while " " $ uBigN
            uBigN:=StrTran(uBigN," ","")
        end while

        self:lNeg:=Left(uBigN,1)=="-"

        if self:lNeg
            uBigN:=SubStr(uBigN,2)
            self:cSig:="-"
        else
            self:cSig:=""
        endif

        nFP:=AT(".",uBigN)

        DEFAULT nBase:=self:nBase

        self:cInt:="0"
        self:cDec:="0"

        do case
        case nFP==0
            self:cInt:=uBigN
            self:cDec:="0"
        case nFP==1
            self:cInt:="0"
            self:cDec:=SubStr(uBigN,nFP+1)
            if "0"==Left(self:cDec,1)
                nFP:=hb_bLen(self:cDec)
                s__IncS0(nFP)
                if self:cDec==Left(s__cN0,nFP)
                    self:cDec:="0"
                endif
            endif
        otherwise
            self:cInt:=Left(uBigN,nFP-1)
            self:cDec:=SubStr(uBigN,nFP+1)
            if "0"==Left(self:cDec,1)
                nFP:=hb_bLen(self:cDec)
                s__IncS0(nFP)
                if self:cDec==Left(s__cN0,nFP)
                    self:cDec:="0"
                endif
            endif
        endcase

        if self:cInt=="0".and.(self:cDec=="0".or.self:cDec=="")
            self:lNeg:=.F.
            self:cSig:=""
        endif

        self:nInt:=hb_bLen(self:cInt)
        self:nDec:=hb_bLen(self:cDec)

    endif

    if self:cInt==""
        self:cInt:="0"
        self:nInt:=1
    endif

    if self:cDec==""
        self:cDec:="0"
        self:nDec:=1
    endif

    if Empty(cRDiv)
        cRDiv:="0"
    endif
    self:cRDiv:=cRDiv

    DEFAULT lLZRmv:=(self:nBase==10)
    if lLZRmv
        while self:nInt>1.and.Left(self:cInt,1)=="0"
            self:cInt:=Right(self:cInt,--self:nInt)
        end while
    endif

    DEFAULT nAcc:=s__nDecSet
    if self:nDec>nAcc
        self:nDec:=nAcc
        self:cDec:=Left(self:cDec,self:nDec)
        if self:cDec==""
            self:cDec:="0"
            self:nDec:=1
        endif
    endif

    self:nSize:=(self:nInt+self:nDec)

return(self)

/*
    method:GetValue
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:GetValue
    Sintaxe:tBigNumber():GetValue(lAbs,lObj) -> uNR
*/
method GetValue(lAbs,lObj) class tBigNumber

    local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.

    uNR:=if(lAbs,"",self:cSig)
    uNR+=self:cInt
    uNR+="."
    uNR+=self:cDec

    if lObj
        uNR:=tBigNumber():New(uNR)
    endif

return(uNR)

/*
    method:ExactValue
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:ExactValue
    Sintaxe:tBigNumber():ExactValue(lAbs) -> uNR
*/
method ExactValue(lAbs,lObj) class tBigNumber

    local cDec

    local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.

    uNR:=if(lAbs,"",self:cSig)

    uNR+=self:cInt
    cDec:=self:Dec(NIL,NIL,self:nBase==10)

    if .not.(cDec=="")
        uNR+="."
        uNR+=cDec
    endif

    if lObj
        uNR:=tBigNumber():New(uNR)
    endif

return(uNR)

/*
    method:Abs
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna o Valor Absoluto de um Numero
    Sintaxe:tBigNumber():Abs() -> uNR
*/
method Abs(lObj) class tBigNumber
return(self:GetValue(.T.,lObj))

/*
    method:Int
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna a Parte Inteira de um Numero
    Sintaxe:tBigNumber():Int(lObj,lSig) -> uNR
*/
method Int(lObj,lSig) class tBigNumber
    local uNR
    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    uNR:=if(lSig,self:cSig,"")+self:cInt
    if lObj
        uNR:=tBigNumber():New(uNR)
    endif
return(uNR)

/*
    method:Dec
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna a Parte Decimal de um Numero
    Sintaxe:tBigNumber():Dec(lObj,lSig,lNotZ) -> uNR
*/
method Dec(lObj,lSig,lNotZ) class tBigNumber

    local cDec:=self:cDec

    local nDec

    local uNR

    DEFAULT lNotZ:=.F.
    if lNotZ
        nDec:=self:nDec
        while Right(cDec,1)=="0"
            cDec:=Left(cDec,--nDec)
        end while
    endif

    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    if lObj
        uNR:=tBigNumber():New(if(lSig,self:cSig,"")+"0."+cDec)
    else
        uNR:=if(lSig,self:cSig,"")+cDec
    endif

return(uNR)

/*
    method:eq
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Compara se o valor corrente eh igual ao passado como parametro
    Sintaxe:tBigNumber():eq(uBigN) -> leq
*/
method eq(uBigN) class tBigNumber

    local leq

    local oeqN1:=s__o0:Clone()
    local oeqN2:=s__o0:Clone()

    oeqN1:SetValue(self)
    oeqN2:SetValue(uBigN)

    leq:=oeqN1:lNeg==oeqN2:lNeg
    if leq
        oeqN1:Normalize(@oeqN2)
        #ifdef __PTCOMPAT__
            leq:=oeqN1:GetValue(.T.)==oeqN2:GetValue(.T.)
        #else
            leq:=tBIGNmemcmp(oeqN1:GetValue(.T.),oeqN2:GetValue(.T.))==0
        #endif
    endif

return(leq)

/*
    method:ne
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Verifica se o valor corrente eh igual ao valor passado como parametro
    Sintaxe:tBigNumber():ne(uBigN) -> .not.(leq)
*/
method ne(uBigN) class tBigNumber
return(.not.(self:eq(uBigN)))

/*
    method:gt
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Verifica se o valor corrente eh maior que o valor passado como parametro
    Sintaxe:tBigNumber():gt(uBigN) -> lgt
*/
method gt(uBigN) class tBigNumber

    local lgt

    local ogtN1:=s__o0:Clone()
    local ogtN2:=s__o0:Clone()

    ogtN1:SetValue(self)
    ogtN2:SetValue(uBigN)

    if ogtN1:lNeg.or.ogtN2:lNeg
        if ogtN1:lNeg.and.ogtN2:lNeg
            ogtN1:Normalize(@ogtN2)
            #ifdef __PTCOMPAT__
                lgt:=ogtN1:GetValue(.T.)<ogtN2:GetValue(.T.)
            #else
                lgt:=tBIGNmemcmp(ogtN1:GetValue(.T.),ogtN2:GetValue(.T.))==-1
            #endif
        elseif ogtN1:lNeg.and.(.not.(ogtN2:lNeg))
            lgt:=.F.
        elseif .not.(ogtN1:lNeg).and.ogtN2:lNeg
            lgt:=.T.
        endif
    else
        ogtN1:Normalize(@ogtN2)
        #ifdef __PTCOMPAT__
            lgt:=ogtN1:GetValue(.T.)>ogtN2:GetValue(.T.)
        #else
            lgt:=tBIGNmemcmp(ogtN1:GetValue(.T.),ogtN2:GetValue(.T.))==1
        #endif
    endif

return(lgt)

/*
    method:lt
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Verifica se o valor corrente eh menor que o valor passado como parametro
    Sintaxe:tBigNumber():lt(uBigN) -> llt
*/
method lt(uBigN) class tBigNumber

    local llt

    local oltN1:=s__o0:Clone()
    local oltN2:=s__o0:Clone()

    oltN1:SetValue(self)
    oltN2:SetValue(uBigN)

    if oltN1:lNeg.or.oltN2:lNeg
        if oltN1:lNeg.and.oltN2:lNeg
            oltN1:Normalize(@oltN2)
            #ifdef __PTCOMPAT__
                llt:=oltN1:GetValue(.T.)>oltN2:GetValue(.T.)
            #else
                llt:=tBIGNmemcmp(oltN1:GetValue(.T.),oltN2:GetValue(.T.))==1
            #endif
        elseif oltN1:lNeg.and.(.not.(oltN2:lNeg))
            llt:=.T.
        elseif .not.(oltN1:lNeg).and.oltN2:lNeg
            llt:=.F.
        endif
    else
        oltN1:Normalize(@oltN2)
        #ifdef __PTCOMPAT__
            llt:=oltN1:GetValue(.T.)<oltN2:GetValue(.T.)
        #else
            llt:=tBIGNmemcmp(oltN1:GetValue(.T.),oltN2:GetValue(.T.))==-1
        #endif
    endif

return(llt)

/*
    method:gte
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Verifica se o valor corrente eh maior ou igual ao valor passado como parametro
    Sintaxe:tBigNumber():gte(uBigN) -> lgte
*/
method gte(uBigN) class tBigNumber
return(self:cmp(uBigN)>=0)

/*
    method:lte
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Verifica se o valor corrente eh menor ou igual ao valor passado como parametro
    Sintaxe:tBigNumber():lte(uBigN) -> lte
*/
method lte(uBigN) class tBigNumber
return(self:cmp(uBigN)<=0)

/*
    method:cmp
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:11/03/2014
    Descricao:Compara self com valor passado como parametro e retorna:
                  -1:self < que valor de referencia;
                   0:self = valor de referencia;
                   1:self > que valor de referencia;
    Sintaxe:tBigNumber():cmp(uBigN) -> nCmp
*/
method cmp(uBigN) class tBigNumber

    local nCmp
    local iCmp

    local llt
    local leq

    local ocmpN1:=s__o0:Clone()
    local ocmpN2:=s__o0:Clone()

    ocmpN1:SetValue(self)
    ocmpN2:SetValue(uBigN)

#ifdef __PTCOMPAT__
    ocmpN1:Normalize(@ocmpN2)
#endif

    leq:=ocmpN1:lNeg==ocmpN2:lNeg
    if leq
        #ifndef __PTCOMPAT__
            ocmpN1:Normalize(@ocmpN2)
        #endif
        #ifdef __PTCOMPAT__
            iCmp:=if(ocmpN1:GetValue(.T.)==ocmpN2:GetValue(.T.),0,NIL)
        #else
            iCmp:=tBIGNmemcmp(ocmpN1:GetValue(.T.),ocmpN2:GetValue(.T.))
        #endif
        leq:=iCmp==0
    endif

    if leq
        nCmp:=0
    else
        if ocmpN1:lNeg.or.ocmpN2:lNeg
            if ocmpN1:lNeg.and.ocmpN2:lNeg
                if iCmp==NIL
                    #ifndef __PTCOMPAT__
                        ocmpN1:Normalize(@ocmpN2)
                    #endif
                    #ifdef __PTCOMPAT__
                        iCmp:=if(ocmpN1:GetValue(.T.)>ocmpN2:GetValue(.T.),1,-1)
                    #else
                        iCmp:=tBIGNmemcmp(ocmpN1:GetValue(.T.),ocmpN2:GetValue(.T.))
                    #endif
                endif
                llt:=iCmp==1
            elseif ocmpN1:lNeg.and.(.not.(ocmpN2:lNeg))
                llt:=.T.
            elseif .not.(ocmpN1:lNeg).and.ocmpN2:lNeg
                llt:=.F.
            endif
        else
            #ifdef __PTCOMPAT__
                iCmp:=if(ocmpN1:GetValue(.T.)<ocmpN2:GetValue(.T.),-1,1)
            #endif
            llt:=iCmp==-1
        endif
        if llt
            nCmp:=-1
        else
            nCmp:=1
        endif
    endif

return(nCmp)

/*
    method:btw (between)
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:01/04/2014
    Descricao:Retorna .T. se self estiver no intervalo passado.
    Sintaxe:tBigNumber():btw(uBigS,uBigE) -> lRet
*/
method btw(uBigS,uBigE) class tBigNumber
return(self:cmp(uBigS)>=0.and.self:cmp(uBigE)<=0)

/*
    method:ibtw (integer between)
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:11/03/2014
    Descricao:Retorna .T. se self estiver no intervalo passado.
    Sintaxe:tBigNumber():ibtw(uiBigS,uiBigE) -> lRet
*/
method ibtw(uiBigS,uiBigE) class tBigNumber
    local lbtw:=.F.
    local oibtwS
    local oibtwE
    if self:Dec(.T.,.F.,.T.):eq(s__o0)
        oibtwS:=s__o0:Clone()
        oibtwS:SetValue(uiBigS)
        oibtwE:=s__o0:Clone()
        oibtwE:SetValue(uiBigE)
        if oibtwS:Dec(.T.,.F.,.T.):eq(s__o0).and.oibtwE:Dec(.T.,.F.,.T.):eq(s__o0)
            lbtw:=self:cmp(oibtwS)>=0.and.self:cmp(oibtwE)<=0
        endif
    endif
return(lbtw)

/*
    method:Max
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna o maior valor entre o valor corrente e o valor passado como parametro
    Sintaxe:tBigNumber():Max(uBigN) -> oMax
*/
method Max(uBigN) class tBigNumber
    local oMax:=tBigNumber():New(uBigN)
    if self:gt(oMax)
        oMax:SetValue(self)
    endif
return(oMax)

/*
    method:Min
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna o menor valor entre o valor corrente e o valor passado como parametro
    Sintaxe:tBigNumber():Min(uBigN) -> oMin
*/
method Min(uBigN) class tBigNumber
    local oMin:=tBigNumber():New(uBigN)
    if self:lt(oMin)
        oMin:SetValue(self)
    endif
return(oMin)

/*
    method:Add
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Soma
    Sintaxe:tBigNumber():Add(uBigN) -> oBigNR
*/
method Add(uBigN) class tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg
    local lInv
    local lAdd:=.T.

    local nDec
    local nSize

    local oadNR

    local oadN1
    local oadN2

    oadN1:=s__o0:Clone()
    oadN1:SetValue(self)

    oadN2:=s__o0:Clone()
    oadN2:SetValue(uBigN)

    oadN1:Normalize(@oadN2)

    nDec:=oadN1:nDec
    nSize:=oadN1:nSize

    cN1:=oadN1:cInt
    cN1+=oadN1:cDec

    cN2:=oadN2:cInt
    cN2+=oadN2:cDec

    lNeg:=(oadN1:lNeg.and.(.not.(oadN2:lNeg))).or.(.not.(oadN1:lNeg).and.oadN2:lNeg)

    if lNeg
        lAdd:=.F.
        #ifdef __HARBOUR__
            lInv:=tBIGNmemcmp(cN1,cN2)==-1
        #else //__PROTHEUS__
            lInv:=cN1<cN2
        #endif //__HARBOUR__
        lNeg:=(oadN1:lNeg.and.(.not.(lInv))).or.(oadN2:lNeg.and.lInv)
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    else
        lNeg:=oadN1:lNeg
    endif

    if lAdd
        cNT:=Add(cN1,cN2,nSize,self:nBase)
    else
        cNT:=Sub(cN1,cN2,nSize,self:nBase)
    endif

    cDec:=Right(cNT,nDec)
    cInt:=Left(cNT,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    oadNR:=s__o0:Clone()
    oadNR:SetValue(cNT)

    if lNeg
        oadNR:__cSig("-")
    endif

return(oadNR)

/*
    method:iAdd
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/02/2015
    Descricao:Soma de Inteiros
    Sintaxe:tBigNumber():iAdd(uBigN) -> oBigNR
*/
method iAdd(uBigN) class tBigNumber

    local cN1
    local cN2
    local cNT

    local lNeg
    local lInv
    local lAdd:=.T.

    local nSize

    local oadNR

    local oadN1
    local oadN2

    oadN1:=s__o0:Clone()
    oadN1:SetValue(self)

    oadN2:=s__o0:Clone()
    oadN2:SetValue(uBigN)

    oadN1:Normalize(@oadN2)

    nSize:=oadN1:nInt

    cN1:=oadN1:cInt
    cN2:=oadN2:cInt

    lNeg:=(oadN1:lNeg.and.(.not.(oadN2:lNeg))).or.(.not.(oadN1:lNeg).and.oadN2:lNeg)

    if lNeg
        lAdd:=.F.
        #ifdef __HARBOUR__
            lInv:=tBIGNmemcmp(cN1,cN2)==-1
        #else //__PROTHEUS__
            lInv:=cN1<cN2
        #endif //__HARBOUR__
        lNeg:=(oadN1:lNeg.and.(.not.(lInv))).or.(oadN2:lNeg.and.lInv)
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    else
        lNeg:=oadN1:lNeg
    endif

    if lAdd
        cNT:=Add(cN1,cN2,nSize,self:nBase)
    else
        cNT:=Sub(cN1,cN2,nSize,self:nBase)
    endif

    oadNR:=s__o0:Clone()
    oadNR:SetValue(cNT)

    if lNeg
        oadNR:__cSig("-")
    endif

return(oadNR)

/*
    method:Sub
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Subtracao
    Sintaxe:tBigNumber():Sub(uBigN) -> oBigNR
*/
method Sub(uBigN) class tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg
    local lInv
    local lSub:=.T.

    local nDec
    local nSize

    local osbNR

    local osbN1
    local osbN2

    osbN1:=s__o0:Clone()
    osbN1:SetValue(self)

    osbN2:=s__o0:Clone()
    osbN2:SetValue(uBigN)

    osbN1:Normalize(@osbN2)

    nDec:=osbN1:nDec
    nSize:=osbN1:nSize

    cN1:=osbN1:cInt
    cN1+=osbN1:cDec

    cN2:=osbN2:cInt
    cN2+=osbN2:cDec

    lNeg:=(osbN1:lNeg.and.(.not.(osbN2:lNeg))).or.(.not.(osbN1:lNeg).and.osbN2:lNeg)

    if lNeg
        lSub:=.F.
        lNeg:=osbN1:lNeg
    else
        #ifdef __HARBOUR__
            lInv:=tBIGNmemcmp(cN1,cN2)==-1
        #else //__PROTHEUS__
            lInv:=cN1<cN2
        #endif //__HARBOUR__
        lNeg:=osbN1:lNeg.or.lInv
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    endif

    if lSub
        cNT:=Sub(cN1,cN2,nSize,self:nBase)
    else
        cNT:=Add(cN1,cN2,nSize,self:nBase)
    endif

    cDec:=Right(cNT,nDec)
    cInt:=Left(cNT,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    osbNR:=s__o0:Clone()
    osbNR:SetValue(cNT)

    if lNeg
        osbNR:__cSig("-")
    endif

return(osbNR)

/*
    method:iSub
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/02/2015
    Descricao:Subtracao de Inteiros
    Sintaxe:tBigNumber():iSub(uBigN) -> oBigNR
*/
method iSub(uBigN) class tBigNumber

    local cN1
    local cN2
    local cNT

    local lNeg
    local lInv
    local lSub:=.T.

    local nSize

    local osbNR

    local osbN1
    local osbN2

    osbN1:=s__o0:Clone()
    osbN1:SetValue(self)

    osbN2:=s__o0:Clone()
    osbN2:SetValue(uBigN)

    osbN1:Normalize(@osbN2)

    nSize:=osbN1:nInt

    cN1:=osbN1:cInt
    cN2:=osbN2:cInt

    lNeg:=(osbN1:lNeg.and.(.not.(osbN2:lNeg))).or.(.not.(osbN1:lNeg).and.osbN2:lNeg)

    if lNeg
        lSub:=.F.
        lNeg:=osbN1:lNeg
    else
        #ifdef __HARBOUR__
            lInv:=tBIGNmemcmp(cN1,cN2)==-1
        #else //__PROTHEUS__
            lInv:=cN1<cN2
        #endif //__HARBOUR__
        lNeg:=osbN1:lNeg.or.lInv
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    endif

    if lSub
        cNT:=Sub(cN1,cN2,nSize,self:nBase)
    else
        cNT:=Add(cN1,cN2,nSize,self:nBase)
    endif

    osbNR:=s__o0:Clone()
    osbNR:SetValue(cNT)

    if lNeg
        osbNR:__cSig("-")
    endif

return(osbNR)

/*
    method:Mult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Multiplicacao
    Sintaxe:tBigNumber():Mult(uBigN) -> oBigNR
*/
method Mult(uBigN) class tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg
    local lNeg1
    local lNeg2

    local nDec
    local nSize

    local omtNR

    local omtN1
    local omtN2

    omtN1:=s__o0:Clone()
    omtN1:SetValue(self)

    omtN2:=s__o0:Clone()
    omtN2:SetValue(uBigN)

    omtN1:Normalize(@omtN2)

    lNeg1:=omtN1:lNeg
    lNeg2:=omtN2:lNeg
    lNeg:=(lNeg1.and.(.not.(lNeg2))).or.(.not.(lNeg1).and.lNeg2)

    cN1:=omtN1:cInt
    cN1+=omtN1:cDec

    cN2:=omtN2:cInt
    cN2+=omtN2:cDec

    nDec:=omtN1:nDec*2
    nSize:=omtN1:nSize

    cNT:=Mult(cN1,cN2,nSize,self:nBase)

    if nDec>0
        cDec:=Right(cNT,nDec)
        cInt:=Left(cNT,hb_bLen(cNT)-nDec)
        cNT:=cInt
        cNT+="."
        cNT+=cDec
    endif

    omtNR:=s__o0:Clone()
    omtNR:SetValue(cNT)

    cNT:=omtNR:ExactValue()

    omtNR:SetValue(cNT)

    if lNeg
        omtNR:__cSig("-")
    endif

return(omtNR)

/*
    method:iMult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/02/2015
    Descricao:Multiplicacao
    Sintaxe:tBigNumber():iMult(uBigN) -> oBigNR
*/
method iMult(uBigN) class tBigNumber

    local cN1
    local cN2
    local cNT

    local lNeg
    local lNeg1
    local lNeg2

    local nSize

    local omtNR

    local omtN1
    local omtN2

    omtN1:=s__o0:Clone()
    omtN1:SetValue(self)

    omtN2:=s__o0:Clone()
    omtN2:SetValue(uBigN)

    omtN1:Normalize(@omtN2)

    lNeg1:=omtN1:lNeg
    lNeg2:=omtN2:lNeg
    lNeg:=(lNeg1.and.(.not.(lNeg2))).or.(.not.(lNeg1).and.lNeg2)

    cN1:=omtN1:cInt
    cN2:=omtN2:cInt

    nSize:=omtN1:nInt

    cNT:=Mult(cN1,cN2,nSize,self:nBase)

    omtNR:=s__o0:Clone()
    omtNR:SetValue(cNT)

    if lNeg
        omtNR:__cSig("-")
    endif

return(omtNR)

/*
    method:egMult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Multiplicacao Egipcia
    Sintaxe:tBigNumber():egMult(uBigN) -> oBigNR
*/
method egMult(uBigN) class tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg
    local lNeg1
    local lNeg2

    local nDec

    local omtNR

    local omtN1
    local omtN2

    omtN1:=s__o0:Clone()
    omtN1:SetValue(self)

    omtN2:=s__o0:Clone()
    omtN2:SetValue(uBigN)

    omtN1:Normalize(@omtN2)

    lNeg1:=omtN1:lNeg
    lNeg2:=omtN2:lNeg
    lNeg:=(lNeg1.and.(.not.(lNeg2))).or.(.not.(lNeg1).and.lNeg2)

    cN1:=omtN1:cInt
    cN1+=omtN1:cDec

    cN2:=omtN2:cInt
    cN2+=omtN2:cDec

    nDec:=omtN1:nDec*2

    cNT:=egMult(cN1,cN2,self:nBase):__cInt()

    cDec:=Right(cNT,nDec)
    cInt:=Left(cNT,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    omtNR:=s__o0:Clone()
    omtNR:SetValue(cNT)

    cNT:=omtNR:ExactValue()

    omtNR:SetValue(cNT)

    if lNeg
        omtNR:__cSig("-")
    endif

return(omtNR)

/*
    method:rMult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Multiplicacao Russa
    Sintaxe:tBigNumber():rMult(uBigN) -> oBigNR
*/
method rMult(uBigN) class tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg
    local lNeg1
    local lNeg2

    local nDec

    local omtNR

    local omtN1
    local omtN2

    omtN1:=s__o0:Clone()
    omtN1:SetValue(self)

    omtN2:=s__o0:Clone()
    omtN2:SetValue(uBigN)

    omtN1:Normalize(@omtN2)

    lNeg1:=omtN1:lNeg
    lNeg2:=omtN2:lNeg
    lNeg:=(lNeg1.and.(.not.(lNeg2))).or.(.not.(lNeg1).and.lNeg2)

    cN1:=omtN1:cInt
    cN1+=omtN1:cDec

    cN2:=omtN2:cInt
    cN2+=omtN2:cDec

    nDec:=omtN1:nDec*2

    cNT:=rMult(cN1,cN2,self:nBase):__cInt()

    cDec:=Right(cNT,nDec)
    cInt:=Left(cNT,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    omtNR:=s__o0:Clone()
    omtNR:SetValue(cNT)

    cNT:=omtNR:ExactValue()

    omtNR:SetValue(cNT)

    if lNeg
        omtNR:__cSig("-")
    endif

return(omtNR)

/*
    method:Div
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Divisao
    Sintaxe:tBigNumber():Div(uBigN,lFloat) -> oBigNR
*/
method Div(uBigN,lFloat) class tBigNumber

    local cDec

    local cN1
    local cN2
    local cNR

    local lNeg
    local lNeg1
    local lNeg2

    local nAcc:=s__nDecSet
    local nDec

    local odvN1
    local odvN2

    local odvRD
    local odvNR:=s__o0:Clone()

    begin sequence

        if s__o0:eq(uBigN)
            odvNR:SetValue(s__o0)
            break
        endif

        odvN1:=s__o0:Clone()
        odvN1:SetValue(self)

        odvN2:=s__o0:Clone()
        odvN2:SetValue(uBigN)

        DEFAULT lFloat:=.T.

        if odvN2:eq(s__o2)
            //-------------------------------------------------------------------------------------
            //(Div(2)==Mult(.5)
            odvNR:SetValue(odvN1:Mult(s__od2))
            if .not.(lFloat)
                odvNR:__cDec("0")
                odvNR:__cInt(odvNR:Int(.F.,.T.))
                odvNR:__cRDiv(odvN1:Sub(odvN2:Mult(odvNR:Int(.T.,.F.))):ExactValue(.T.))
            endif
            break
        endif

        odvN1:Normalize(@odvN2)

        lNeg1:=odvN1:lNeg
        lNeg2:=odvN2:lNeg
        lNeg:=(lNeg1.and.(.not.(lNeg2))).or.(.not.(lNeg1).and.lNeg2)

        cN1:=odvN1:cInt
        cN1+=odvN1:cDec

        cN2:=odvN2:cInt
        cN2+=odvN2:cDec

        if s__nDivMTD==2
            odvNR:SetValue(ecDiv(cN1,cN2,odvN1:nSize,odvN1:nBase,nAcc,lFloat))
        else
            odvNR:SetValue(egDiv(cN1,cN2,odvN1:nSize,odvN1:nBase,nAcc,lFloat))
        endif

        if lFloat

            odvRD:=s__o0:Clone()
            odvRD:SetValue(odvNR:cRDiv,NIL,NIL,.F.)

            if odvRD:gt(s__o0)

                cDec:=""

                odvN2:SetValue(cN2)

                while odvRD:lt(odvN2)
                    odvRD:cInt+="0"
                    odvRD:nInt++
                    odvRD:nSize++
                    if odvRD:lt(odvN2)
                        cDec+="0"
                    endif
                end while

                while odvRD:gte(odvN2)

                    odvRD:Normalize(@odvN2)

                    cN1:=odvRD:cInt
                    cN1+=odvRD:cDec

                    cN2:=odvN2:cInt
                    cN2+=odvN2:cDec

                    if s__nDivMTD==2
                        odvRD:SetValue(ecDiv(cN1,cN2,odvRD:nSize,odvRD:nBase,nAcc,lFloat))
                    else
                        odvRD:SetValue(egDiv(cN1,cN2,odvRD:nSize,odvRD:nBase,nAcc,lFloat))
                    endif

                    cDec+=odvRD:ExactValue(.T.)
                    nDec:=hb_bLen(cDec)

                    odvRD:SetValue(odvRD:cRDiv,NIL,NIL,.F.)
                    odvRD:SetValue(odvRD:ExactValue(.T.))

                    if odvRD:eq(s__o0).or.nDec>=nAcc
                        exit
                    endif

                    odvN2:SetValue(cN2)

                    while odvRD:lt(odvN2)
                        odvRD:cInt+="0"
                        odvRD:nInt++
                        odvRD:nSize++
                        if odvRD:lt(odvN2)
                            cDec+="0"
                        endif
                    end while

                end while

                cNR:=odvNR:__cInt()
                cNR+="."
                cNR+=Left(cDec,nAcc)

                odvNR:SetValue(cNR,NIL,odvRD:ExactValue(.T.))

            endif

        endif

        if lNeg
            odvNR:__cSig("-")
        endif

    end sequence

return(odvNR)

/*
    method:Divmethod
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:24/03/2014
    Descricao:Setar o metodo de Divisao a ser utilizado
    Sintaxe:tBigNumber():Divmethod(nmethod) -> nLstmethod
*/
method Divmethod(nmethod) class tBigNumber
    local nLstmethod
    DEFAULT s__nDivMTD:=__DIVMETHOD__
    DEFAULT nmethod:=s__nDivMTD
    nLstmethod:=s__nDivMTD
    s__nDivMTD:=nmethod
return(nLstmethod)

/*
    method:Mod
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2013
    Descricao:Resto da Divisao
    Sintaxe:tBigNumber():Mod(uBigN) -> oMod
*/
method Mod(uBigN) class tBigNumber
    local oMod:=tBigNumber():New(uBigN)
    local nCmp:=self:cmp(oMod)
    if nCmp==-1
        oMod:SetValue(self)
    elseif nCmp==0
        oMod:SetValue(s__o0)
    else
        oMod:SetValue(self:Div(oMod,.F.))
        oMod:SetValue(oMod:cRDiv,NIL,NIL,.F.)
    endif
return(oMod)

/*
    method:Pow
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2013
    Descricao:Calculo de Potencia n^x
    Sintaxe:tBigNumber():Pow(uBigN) -> oBigNR
*/
method Pow(uBigN) class tBigNumber

#ifndef __PTCOMPAT__
    local oThreads
#endif

    local oSelf:=self:Clone()

    local cM10

    local cPowB
    local cPowA

    local lPoWN
    local lPowF

    local nZS

    local opwA
    local opwB

    local opwNP:=s__o0:Clone()
    local opwNR:=s__o0:Clone()

    local opwGCD

    lPoWN:=opwNP:SetValue(uBigN):lt(s__o0)

    begin sequence

        if oSelf:eq(s__o0).and.opwNP:eq(s__o0)
            opwNR:SetValue(s__o1)
            break
        endif

        if oSelf:eq(s__o0)
            opwNR:SetValue(s__o0)
            break
        endif

        if opwNP:eq(s__o0)
            opwNR:SetValue(s__o1)
            break
        endif

        if oSelf:eq(s__o1)
            opwNR:SetValue(s__o1)
            break
        endif

        opwNR:SetValue(oSelf)

        if s__o1:eq(opwNP:SetValue(opwNP:Abs()))
            break
        endif

        opwA:=s__o0:Clone()
        lPowF:=opwA:SetValue(opwNP:cDec):gt(s__o0)

        if lPowF

            cPowA:=opwNP:cInt+opwNP:Dec(NIL,NIL,.T.)
            opwA:SetValue(cPowA)

            nZS:=hb_bLen(opwNP:Dec(NIL,NIL,.T.))
            s__IncS0(nZS)

            cM10:="1"
            cM10+=Left(s__cN0,nZS)

            cPowB:=cM10

            opwB:=s__o0:Clone()
            if opwB:SetValue(cPowB):gt(s__o1)
                opwGCD:=s__o0:Clone()
                opwGCD:SetValue(opwA:GCD(opwB))
                #ifndef __PTCOMPAT__
                    oThreads:=tBigNThread():New()
                    oThreads:Start(2)
                    oThreads:setEvent(1,{@thDiv(),opwA,opwGCD})
                    oThreads:setEvent(2,{@thDiv(),opwB,opwGCD})
                    oThreads:Notify()
                    oThreads:Wait()
                    oThreads:Join()
                    opwA:SetValue(oThreads:getResult(1))
                    opwB:SetValue(oThreads:getResult(2))
                #else
                    opwA:SetValue(opwA:Div(opwGCD))
                    opwB:SetValue(opwB:Div(opwGCD))
                #endif
            endif

            opwA:Normalize(@opwB)

            opwNP:SetValue(opwA)

        endif

        opwNR:SetValue(Power(opwNR,opwNP))

        if lPowF
            opwNR:SetValue(opwNR:nthRoot(opwB))
        endif

    end sequence

    if lPoWN
        opwNR:SetValue(s__o1:Div(opwNR))
    endif

return(opwNR)

/*
    method:OpInc
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Incrementa em 1
    Sintaxe:tBigNumber():OpInc() -> oBigNR
*/
method OpInc() class tBigNumber
#ifdef __PTCOMPAT__
    return(self:SetValue(self:iAdd(s__o1)))
#else
    return(self:SetValue(tBIGNiADD(self:cInt,1,self:nBase)))
#endif

/*
    method:OpDec
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Decrementa em 1
    Sintaxe:tBigNumber():OpDec() -> oBigNR
*/
method OpDec() class tBigNumber
#ifdef __PTCOMPAT__
    return(self:SetValue(self:iSub(s__o1)))
#else
    return(self:SetValue(tBIGNiSUB(self:cInt,1,self:nBase)))
#endif


/*
    method:e
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/02/2013
    Descricao:Retorna o Numero de Neper (2.718281828459045235360287471352662497757247...)
    Sintaxe:tBigNumber():e(lforce) -> oeTthD
    (((n+1)^(n+1))/(n^n))-((n^n)/((n-1)^(n-1)))
*/
method e(lforce) class tBigNumber

    local oeTthD

    local oPowN
    local oDiv1P
    local oDiv1S
    local oBigNC
    local oAdd1N
    local oSub1N
    local oPoWNAd
    local oPoWNS1

    begin sequence

        DEFAULT lforce:=.F.

        oeTthD:=s__o0:Clone()

        if .not.(lforce)

            oeTthD:SetValue(__eTthD())

            break

        endif

        oBigNC:=self:Clone()

        if oBigNC:eq(s__o0)
            oBigNC:SetValue(s__o1)
        endif

        oPowN:=oBigNC:Clone()

        oPowN:SetValue(oPowN:Pow(oPowN))

        oAdd1N:=oBigNC:Add(s__o1)
        oSub1N:=oBigNC:Sub(s__o1)

        oPoWNAd:=oAdd1N:Pow(oAdd1N)
        oPoWNS1:=oSub1N:Pow(oSub1N)

        oDiv1P:=oPoWNAd:Div(oPowN)
        oDiv1S:=oPowN:Div(oPoWNS1)

        oeTthD:SetValue(oDiv1P:Sub(oDiv1S))

    end sequence

return(oeTthD)

/*
    method:Exp
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/02/2013
    Descricao:Potencia do Numero de Neper e^cN
    Sintaxe:tBigNumber():Exp(lforce) -> oBigNR
*/
method Exp(lforce) class tBigNumber
    local oBigNe:=self:e(lforce)
    local oBigNR:=oBigNe:Pow(self)
return(oBigNR)

/*
    method:PI
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Retorna o Numero Irracional PI (3.1415926535897932384626433832795...)
    Sintaxe:tBigNumber():PI(lforce) -> oPITthD
*/
method PI(lforce) class tBigNumber

    local oPITthD

    DEFAULT lforce:=.F.

    begin sequence

        lforce:=.F.    //TODO: Implementar o calculo.

        if .not.(lforce)

            oPITthD:=s__o0:Clone()
            oPITthD:SetValue(__PITthD())

            break

        endif

        //TODO: Implementar o calculo,Depende de Pow com Expoente Fracionario

    end sequence

return(oPITthD)

/*
    method:GCD
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/02/2013
    Descricao:Retorna o GCD/MDC
    Sintaxe:tBigNumber():GCD(uBigN) -> oGCD
*/
method GCD(uBigN) class tBigNumber

    local oX:=self:Clone()
    local oY:=tBigNumber():New(uBigN)

    local oGCD

    oX:SetValue(oY:Max(self))
    oY:SetValue(oY:Min(self))

    if oY:eq(s__o0)
        oGCD:=oX
    else
        oGCD:=oY:Clone()
        if oX:lte(s__oMinGCD).and.oY:lte(s__oMinGCD)
            oGCD:SetValue(cGCD(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
        else
            while .T.
                oY:SetValue(oX:Mod(oY))
                if oY:eq(s__o0)
                    exit
                endif
                oX:SetValue(oGCD)
                oGCD:SetValue(oY)
            end while
        endif
    endif

return(oGCD)

static function cGCD(nX,nY)
    #ifndef __PTCOMPAT__
        local nGCD:=TBIGNGCD(nX,nY)
    #else //__PROTHEUS__
        local nGCD:=nX
        nX:=Max(nY,nGCD)
        nY:=Min(nGCD,nY)
        if nY==0
            nGCD:=nX
        else
            nGCD:=nY
            while .T.
                if (nY:=(nX%nY))==0
                    exit
                endif
                nX:=nGCD
                nGCD:=nY
            end while
        endif
    #endif //__PTCOMPAT__
return(hb_ntos(nGCD))

/*
    method:LCM
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/02/2013
    Descricao:Retorna o LCM/MMC
    Sintaxe:tBigNumber():LCM(uBigN) -> oLCM
*/
method LCM(uBigN) class tBigNumber

#ifndef __PTCOMPAT__
    local oThreads
#endif

    local oX:=self:Clone()
    local oY:=tBigNumber():New(uBigN)

    local oI:=s__o2:Clone()

    local oLCM:=s__o1:Clone()

    local lMX
    local lMY

    if oX:nInt<=s__nMinLCM.and.oY:nInt<=s__nMinLCM
        oLCM:SetValue(cLCM(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
    else
        #ifndef __PTCOMPAT__
            oThreads:=tBigNThread():New()
            oThreads:Start(3)
        #endif
        while .T.
            #ifndef __PTCOMPAT__
                oThreads:setEvent(1,{@thMod0(),oX,oI})
                oThreads:setEvent(2,{@thMod0(),oY,oI})
                oThreads:Notify()
                oThreads:Wait()
                lMX:=oThreads:getResult(1)
                lMY:=oThreads:getResult(2)
            #else
                lMX:=oX:Mod(oI):eq(s__o0)
                lMY:=oY:Mod(oI):eq(s__o0)
            #endif
            while lMX.or.lMY
                #ifndef __PTCOMPAT__
                    if lMX.and.lMY
                        oThreads:setEvent(1,{@thMult(),oLCM,oI})
                        oThreads:setEvent(2,{@thDiv(),oX,oI,.F.})
                        oThreads:setEvent(3,{@thDiv(),oY,oI,.F.})
                        oThreads:Notify()
                        oThreads:Wait()
                        oLCM:SetValue(oThreads:getResult(1))
                        oX:SetValue(oThreads:getResult(2))
                        oY:SetValue(oThreads:getResult(3))
                        oThreads:setEvent(1,{@thMod0(),oX,oI})
                        oThreads:setEvent(2,{@thMod0(),oY,oI})
                        oThreads:setEvent(3,NIL)
                        oThreads:Notify()
                        oThreads:Wait()
                        lMX:=oThreads:getResult(1)
                        lMY:=oThreads:getResult(2)
                    else
                        oThreads:setEvent(1,{@thMult(),oLCM,oI})
                        if lMX
                            oThreads:setEvent(2,{@thDiv(),oX,oI,.F.})
                        endif
                        if lMY
                            oThreads:setEvent(2,{@thDiv(),oY,oI,.F.})
                        endif
                        oThreads:setEvent(3,NIL)
                        oThreads:Notify()
                        oThreads:Wait()
                        oLCM:SetValue(oThreads:getResult(1))
                        if lMX
                            oX:SetValue(oThreads:getResult(2))
                            lMX:=oX:Mod(oI):eq(s__o0)
                        endif
                        if lMY
                            oY:SetValue(oThreads:getResult(2))
                            lMY:=oY:Mod(oI):eq(s__o0)
                        endif
                    endif
                #else
                    oLCM:SetValue(oLCM:Mult(oI))
                    if lMX
                        oX:SetValue(oX:Div(oI,.F.))
                        lMX:=oX:Mod(oI):eq(s__o0)
                    endif
                    if lMY
                        oY:SetValue(oY:Div(oI,.F.))
                        lMY:=oY:Mod(oI):eq(s__o0)
                    endif
                #endif
            end while
            if oX:eq(s__o1).and.oY:eq(s__o1)
                exit
            endif
            oI:OpInc()
        end while
       #ifndef __PTCOMPAT__
            oThreads:Join()
        #endif
    endif

return(oLCM)

static function cLCM(nX,nY)
    #ifndef __PTCOMPAT__
        local nLCM:=TBIGNLCM(nX,nY)
    #else //__PROTHEUS__
        local nLCM:=1
        local nI:=2
        local lMX
        local lMY
        while .T.
            lMX:=(nX%nI)==0
            lMY:=(nY%nI)==0
            while lMX.or.lMY
                nLCM *=nI
                if lMX
                    nX:=Int(nX/nI)
                    lMX:=(nX%nI)==0
                endif
                if lMY
                    nY:=Int(nY/nI)
                    lMY:=(nY%nI)==0
                endif
            end while
            if nX==1.and.nY==1
                exit
            endif
            ++nI
        end while
    #endif //__PTCOMPAT__
return(hb_ntos(nLCM))

/*

    method:nthRoot
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2013
    Descricao:Radiciacao
    Sintaxe:tBigNumber():nthRoot(uBigN) -> othRoot
*/
method nthRoot(uBigN) class tBigNumber

    local cFExit

    local nZS

    local oRootB:=self:Clone()
    local oRootE

    local othRoot:=s__o0:Clone()

    local oFExit

    begin sequence

        if oRootB:eq(s__o0)
            break
        endif

        if oRootB:lNeg
            break
        endif

        if oRootB:eq(s__o1)
            othRoot:SetValue(s__o1)
            break
        endif

        oRootE:=tBigNumber():New(uBigN)

        if oRootE:eq(s__o0)
            break
        endif

        if oRootE:eq(s__o1)
            othRoot:SetValue(oRootB)
            break
        endif

        nZS:=s__nthRAcc-1
        s__IncS0(nZS)

        cFExit:="0."+Left(s__cN0,nZS)+"1"

        oFExit:=s__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,s__nthRAcc)

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    end sequence

return(othRoot)

/*

    method:nthRootPF
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2013
    Descricao:Radiciacao utilizando Fatores Primos
    Sintaxe:tBigNumber():nthRootPF(uBigN) -> othRoot
*/
method nthRootPF(uBigN) class tBigNumber

    local aIPF
    local aDPF

    local cFExit

    local lDec

    local nZS

    local nPF
    local nPFs

    local oRootB:=self:Clone()
    local oRootD
    local oRootE

    local oRootT

    local othRoot:=s__o0:Clone()
    local othRootD

    local oFExit

    begin sequence

        if oRootB:eq(s__o0)
            break
        endif

        if oRootB:lNeg
            break
        endif

        if oRootB:eq(s__o1)
            othRoot:SetValue(s__o1)
            break
        endif

        oRootE:=tBigNumber():New(uBigN)

        if oRootE:eq(s__o0)
            break
        endif

        if oRootE:eq(s__o1)
            othRoot:SetValue(oRootB)
            break
        endif

        oRootT:=s__o0:Clone()

        nZS:=s__nthRAcc-1
        s__IncS0(nZS)

        cFExit:="0."+Left(s__cN0,nZS)+"1"

        oFExit:=s__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,s__nthRAcc)

        lDec:=oRootB:Dec(.T.):gt(s__o0)

        if lDec

            nZS:=hb_bLen(oRootB:Dec(NIL,NIL,.T.))
            s__IncS0(nZS)

            oRootD:=tBigNumber():New("1"+Left(s__cN0,nZS))
            oRootT:SetValue(oRootB:cInt+oRootB:cDec)

            aIPF:=oRootT:PFactors()
            aDPF:=oRootD:PFactors()

        else

            aIPF:=oRootB:PFactors()
            aDPF:=Array(0)

        endif

        nPFs:=tBIGNaLen(aIPF)

        if nPFs>0
            othRoot:SetValue(s__o1)
            othRootD:=s__o0:Clone()
            oRootT:SetValue(s__o0)
            for nPF:=1 to nPFs
                if oRootE:eq(aIPF[nPF][2])
                    othRoot:SetValue(othRoot:Mult(aIPF[nPF][1]))
                else
                    oRootT:SetValue(aIPF[nPF][1])
                    oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                    oRootT:SetValue(oRootT:Pow(aIPF[nPF][2]))
                    othRoot:SetValue(othRoot:Mult(oRootT))
                endif
            next nPF
            if .not.(Empty(aDPF))
                nPFs:=tBIGNaLen(aDPF)
                if nPFs>0
                    othRootD:SetValue(s__o1)
                    for nPF:=1 to nPFs
                        if oRootE:eq(aDPF[nPF][2])
                            othRootD:SetValue(othRootD:Mult(aDPF[nPF][1]))
                        else
                            oRootT:SetValue(aDPF[nPF][1])
                            oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                            oRootT:SetValue(oRootT:Pow(aDPF[nPF][2]))
                            othRootD:SetValue(othRootD:Mult(oRootT))
                        endif
                    next nPF
                    if othRootD:gt(s__o0)
                        othRoot:SetValue(othRoot:Div(othRootD))
                    endif
                endif
            endif
            break
        endif

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    end sequence

return(othRoot)

/*
    method:SQRT
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/03/2013
    Descricao:Retorna a Raiz Quadrada (radix quadratum -> O Lado do Quadrado) do Numero passado como parametro
    Sintaxe:tBigNumber():SQRT() -> oSQRT
*/
method SQRT() class tBigNumber

    local oSQRT:=self:Clone()

    begin sequence

        if oSQRT:lte(oSQRT:SysSQRT())
            oSQRT:SetValue(__SQRT(hb_ntos(Val(oSQRT:GetValue()))))
            break
        endif

        if oSQRT:eq(s__o0)
            break
        endif

        oSQRT:SetValue(__SQRT(oSQRT))

    end sequence

return(oSQRT)

/*
    method:SysSQRT
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/03/2013
    Descricao:Define o valor maximo para calculo da SQRT considerando a funcao padrao
    Sintaxe:tBigNumber():SysSQRT(uSet) -> oSysSQRT
*/
method SysSQRT(uSet) class tBigNumber

    local cType

    cType:=ValType(uSet)
    if ( cType $ "C|N|O" )
        while .not.(hb_mutexLock(s__MTXSQR))
        end while
        s__SysSQRT:SetValue(if(cType$"C|O",uSet,if(cType=="N",hb_ntos(uSet),"0")))
        if s__SysSQRT:gt(MAX_SYS_SQRT)
            s__SysSQRT:SetValue(MAX_SYS_SQRT)
        endif
        hb_MutexUnLock(s__MTXSQR)
    endif

return(s__SysSQRT)

/*
    method:Log
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo na Base N DEFAULT e
    Sintaxe:tBigNumber():Log(BigNB) -> oBigNR
*/
method Log(uBigNB) class tBigNumber
return(self:LogN(uBigNB))

/*
    method:LogN
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo na Base N DEFAULT e
    Sintaxe:tBigNumber():LogN(BigNB) -> oBigNR
*/
method LogN(uBigNB) class tBigNumber
    local oB:=s__o0:Clone()
    local oR:=s__o0:Clone()
    DEFAULT uBigNB:=self:e()
    oB:SetValue(uBigNB)
#ifndef __PTCOMPAT__
    oR:SetValue(TBIGNLOG(self:GetValue(),oB:GetValue()))
#else
    oR:SetValue(self:__Log(oB))
#endif
return(oR)

/*
    method:__Log
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo na Base N DEFAULT e
    Sintaxe:tBigNumber():__Log(BigNB) -> oBigNR
*/
method __Log(uBigNB) class tBigNumber
return(self:__LogN(uBigNB))
/*
#ifndef __PTCOMPAT__
    local oThreads
#endif
    local ob10:=s__o10:Clone()
    local oN:=self:Clone()
    local oB:=s__o0:Clone()
    oB:SetValue(uBigNB)
    #ifndef __PTCOMPAT__
        oThreads:=tBigNThread():New()
        oThreads:Start(2)
        oThreads:setEvent(1,{@thLogN(),oN,ob10})
        oThreads:setEvent(2,{@thLogN(),oB,ob10})
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()
        oN:SetValue(oThreads:getResult(1))
        oB:SetValue(oThreads:getResult(2))
    #else
        oN:SetValue(oN:LogN(ob10))
        oB:SetValue(oB:LogN(ob10))
    #endif
return(oN:Div(oB))
*/

/*
    method:__LogN
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo na Base N DEFAULT e
    Sintaxe:tBigNumber():__LogN(BigNB) -> oBigNR
    Referencia://http://www.vivaolinux.com.br/script/Calculo-de-logaritmo-de-um-numero-por-um-terceiro-metodo-em-C
*/
method __LogN(uBigNB) class tBigNumber

#ifndef __PTCOMPAT__
    local oThreads_1
    local oThreads_2
#endif

    local oS:=s__o0:Clone()
    local oT:=s__o0:Clone()
    local oI:=s__o1:Clone()
    local oX:=self:Clone()
    local oY:=s__o0:Clone()
    local oLT:=s__o0:Clone()

    local noTcmp1

    local lflag:=.F.

    if oX:eq(s__o0)
        return(s__o0:Clone())
    endif

    DEFAULT uBigNB:=self:e()

    oT:SetValue(uBigNB)

    noTcmp1:=oT:cmp(s__o1)
    if noTcmp1==0
        return(s__o0:Clone())
    endif

    if s__o0:lt(oT).and.noTcmp1==-1
         lflag:=.not.(lflag)
         oT:__cSig("")
         oT:SetValue(s__o1:Div(oT))
         noTcmp1:=oT:cmp(s__o1)
    endif

    #ifndef __PTCOMPAT__
        oThreads_1:=tBigNThread():New()
        oThreads_1:Start(2)
        oThreads_1:setEvent(1,{@thAdd(),oY,oI})
        oThreads_1:setEvent(2,{@thDiv(),oX,oT})
    #endif

    while oX:gt(oT).and.noTcmp1==1
        #ifndef __PTCOMPAT__
            oThreads_1:Notify()
            oThreads_1:Wait()
            oY:SetValue(oThreads_1:getResult(1))
            oX:SetValue(oThreads_1:getResult(2))
        #else
            oY:SetValue(oY:Add(oI))
            oX:SetValue(oX:Div(oT))
        #endif
    end while

    #ifndef __PTCOMPAT__
        oThreads_2:=tBigNThread():New()
        oThreads_2:Start(3)
        oThreads_2:setEvent(1,{@thAdd(),oS,oY})
        oThreads_2:setEvent(2,{@thnthRoot(),oT,s__o2})
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oThreads_2:setEvent(3,{@thMult(),oI,s__od2})
        oThreads_2:Notify()
        oThreads_2:Wait()
        oThreads_2:Join()
        oS:SetValue(oThreads_2:getResult(1))
        oT:SetValue(oThreads_2:getResult(2))
        oI:SetValue(oThreads_2:getResult(3))
    #else
        oS:SetValue(oS:Add(oY))
        oT:SetValue(oT:nthRoot(s__o2))
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oI:SetValue(oI:Mult(s__od2))
    #endif

    oY:SetValue(s__o0)

    noTcmp1:=oT:cmp(s__o1)

    while noTcmp1==1

        while oX:gt(oT).and.noTcmp1==1
            #ifndef __PTCOMPAT__
                oThreads_1:Notify()
                oThreads_1:Wait()
                oY:SetValue(oThreads_1:getResult(1))
                oX:SetValue(oThreads_1:getResult(2))
            #else
                oY:SetValue(oY:Add(oI))
                oX:SetValue(oX:Div(oT))
            #endif
        end while

        oS:SetValue(oS:Add(oY))

        oY:SetValue(s__o0)

        oLT:SetValue(oT)

        oT:SetValue(oT:nthRoot(s__o2))

        if oT:eq(oLT)
            exit
        endif

        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oI:SetValue(oI:Mult(s__od2))

        noTcmp1:=oT:cmp(s__o1)

    end while

    #ifndef __PTCOMPAT__
        oThreads_1:Join()
    #endif

    if lflag
        oS:__cSig("-")
    endif

return(oS)

/*
    method:Log2
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo Base 2
    Sintaxe:tBigNumber():Log2() -> oBigNR
*/
method Log2() class tBigNumber
    local ob2:=s__o2:Clone()
return(self:LogN(ob2))

/*
    method:Log10
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Retorna o logaritmo Base 10
    Sintaxe:tBigNumber():Log10() -> oBigNR
*/
method Log10() class tBigNumber
    local ob10:=s__o10:Clone()
return(self:LogN(ob10))

/*
    method:Ln
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/02/2013
    Descricao:Logaritmo Natural
    Sintaxe:tBigNumber():Ln() -> oBigNR
*/
method Ln() class tBigNumber
return(self:LogN(s__o1:Exp()))

/*
    method:MathC
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2013
    Descricao:Operacoes Matematicas
    Sintaxe:tBigNumber():MathC(uBigN1,cOperator,uBigN2) -> cNR
*/
method MathC(uBigN1,cOperator,uBigN2) class tBigNumber
return(MathO(uBigN1,cOperator,uBigN2,.F.))

/*
    method:MathN
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Operacoes Matematicas
    Sintaxe:tBigNumber():MathN(uBigN1,cOperator,uBigN2) -> oBigNR
*/
method MathN(uBigN1,cOperator,uBigN2) class tBigNumber
return(MathO(uBigN1,cOperator,uBigN2,.T.))

/*
    method:Rnd
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/02/2013
    Descricao:Rnd arredonda um numero decimal, "para cima", se o digito da precisao definida for >= 5, caso contrario, truca.
    Sintaxe:tBigNumber():Rnd(nAcc) -> oRND
*/
method Rnd(nAcc) class tBigNumber

    local oRnd:=self:Clone()

    local cAdd
    local cAcc

    DEFAULT nAcc:=Max((Min(oRnd:nDec,s__nDecSet)-1),0)

    if .not.(oRnd:eq(s__o0))
        cAcc:=SubStr(oRnd:cDec,nAcc+1,1)
        if cAcc==""
            cAcc:=SubStr(oRnd:cDec,--nAcc+1,1)
        endif
        if cAcc>="5"
            cAdd:="0."
            s__IncS0(nAcc)
            cAdd+=Left(s__cN0,nAcc)+"5"
            oRnd:SetValue(oRnd:Add(cAdd))
        endif
        oRnd:SetValue(oRnd:cInt+"."+Left(oRnd:cDec,nAcc),NIL,oRnd:cRDiv)
    endif

return(oRnd)

/*
    method:NoRnd
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/02/2013
    Descricao:NoRnd trunca um numero decimal
    Sintaxe:tBigNumber():NoRnd(nAcc) -> oBigNR
*/
method NoRnd(nAcc) class tBigNumber
return(self:Truncate(nAcc))

/*
    method:Floor
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2014
    Descricao:Retorna o "Piso" de um Numero Real de acordo com o Arredondamento para "baixo"
    Sintaxe:tBigNumber():Floor(nAcc) -> oFloor
*/
method Floor(nAcc) class tBigNumber
    local oInt:=self:Int(.T.,.T.)
    local oFloor:=self:Clone()
    DEFAULT nAcc:=Max((Min(oFloor:nDec,s__nDecSet)-1),0)
    oFloor:SetValue(oFloor:Rnd(nAcc):Int(.T.,.T.))
    oFloor:SetValue(oFloor:Min(oInt))
return(oFloor)

/*
    method:Ceiling
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:05/03/2014
    Descricao:Retorna o "Teto" de um Numero Real de acordo com o Arredondamento para "cima"
    Sintaxe:tBigNumber():Ceiling(nAcc) -> oCeiling
*/
method Ceiling(nAcc) class tBigNumber
    local oInt:=self:Int(.T.,.T.)
    local oCeiling:=self:Clone()
    DEFAULT nAcc:=Max((Min(oCeiling:nDec,s__nDecSet)-1),0)
    oCeiling:SetValue(oCeiling:Rnd(nAcc):Int(.T.,.T.))
    oCeiling:SetValue(oCeiling:Max(oInt))
return(oCeiling)

/*
    method:Truncate
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:06/02/2013
    Descricao:Truncate trunca um numero decimal
    Sintaxe:tBigNumber():Truncate(nAcc) -> oTrc
*/
method Truncate(nAcc) class tBigNumber

    local oTrc:=self:Clone()
    local cDec:=oTrc:cDec

    if .not.(s__o0:eq(cDec))
        DEFAULT nAcc:=Min(oTrc:nDec,s__nDecSet)
        cDec:=Left(cDec,nAcc)
        oTrc:SetValue(oTrc:cInt+"."+cDec)
    endif

return(oTrc)

/*
    method:Normalize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Normaliza os Dados
    Sintaxe:tBigNumber():Normalize(oBigN) -> self
*/
method Normalize(oBigN) class tBigNumber
#ifdef __PTCOMPAT__
    local nPadL:=Max(self:nInt,oBigN:nInt)
    local nPadR:=Max(self:nDec,oBigN:nDec)
    local nSize:=(nPadL+nPadR)

    local lPadL:=nPadL!=self:nInt
    local lPadR:=nPadR!=self:nDec

    s__IncS0(nSize)

    if lPadL.or.lPadR
        if lPadL
            self:cInt:=Left(s__cN0,nPadL-self:nInt)+self:cInt
            self:nInt:=nPadL
        endif
        if lPadR
            self:cDec+=Left(s__cN0,nPadR-self:nDec)
            self:nDec:=nPadR
        endif
        self:nSize:=nSize
    endif

    lPadL:=nPadL!=oBigN:nInt
    lPadR:=nPadR!=oBigN:nDec

    if lPadL.or.lPadR
        if lPadL
            oBigN:cInt:=Left(s__cN0,nPadL-oBigN:nInt)+oBigN:cInt
            oBigN:nInt:=nPadL
        endif
        if lPadR
            oBigN:cDec+=Left(s__cN0,nPadR-oBigN:nDec)
            oBigN:nDec:=nPadR
        endif
        oBigN:nSize:=nSize
    endif
#else
    tBIGNNormalize(@self:cInt,@self:nInt,@self:cDec,@self:nDec,@self:nSize,@oBigN:cInt,@oBigN:nInt,@oBigN:cDec,@oBigN:nDec,@oBigN:nSize)
#endif
return(self)

/*
    method:D2H
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:07/02/2013
    Descricao:Converte Decimal para Hexa
    Sintaxe:tBigNumber():D2H(cHexB) -> cHexN
*/
method D2H(cHexB) class tBigNumber

    local otH:=s__o0:Clone()
    local otN:=tBigNumber():New(self:cInt)

    local cHexN:=""
    local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"

    local cInt
    local cDec
    local cSig:=self:cSig

    local oHexN

    local nAT

    DEFAULT cHexB:="16"

    otH:SetValue(cHexB)

    while otN:gt(s__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    end while

    if cHexN==""
        cHexN:="0"
    endif

    cInt:=cHexN

    cHexN:=""
    otN:=tBigNumber():New(self:Dec(NIL,NIL,.T.))

    while otN:gt(s__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    end while

    if cHexN==""
        cHexN:="0"
    endif

    cDec:=cHexN

    oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

return(oHexN)

/*
    method:H2D
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:07/02/2013
    Descricao:Converte Hexa para Decimal
    Sintaxe:tBigNumber():H2D() -> otNR
*/
method H2D() class tBigNumber

    local otH:=s__o0:Clone()
    local otNR:=s__o0:Clone()
    local otLN:=s__o0:Clone()
    local otPw:=s__o0:Clone()
    local otNI:=s__o0:Clone()
    local otAT:=s__o0:Clone()

    local cHexB:=hb_ntos(self:nBase)
    local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"
    local cHexN:=self:cInt

    local cInt
    local cDec
    local cSig:=self:cSig

    local nLn:=hb_bLen(cHexN)
    local nI:=nLn

    otH:SetValue(cHexB)
    otLN:SetValue(hb_ntos(nLn))

    while nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1)))
        otPw:SetValue(otLN:Sub(otNI))
        otPw:OpDec()
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    end while

    cInt:=otNR:cInt

    cHexN:=self:cDec
    nLn:=self:nDec
    nI:=nLn

    otLN:SetValue(hb_ntos(nLn))

    while nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1)))
        otPw:SetValue(otLN:Sub(otNI))
        otPw:OpDec()
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    end while

    cDec:=otNR:cDec

    otNR:SetValue(cSig+cInt+"."+cDec)

return(otNR)

/*
    method:H2B
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:07/02/2013
    Descricao:Converte Hex para Bin
    Sintaxe:tBigNumber():H2B(cHexN) -> cBin
*/
method H2B() class tBigNumber

    local aH2B:={;
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

    local cChr
    local cBin:=""

    local cInt
    local cDec

    local cSig:=self:cSig
    local cHexB:=hb_ntos(self:nBase)
    local cHexN:=self:cInt

    local oBin:=tBigNumber():New(NIL,2)

    local nI:=0
    local nLn:=hb_bLen(cHexN)
    local nAT

    local l16

    begin sequence

        if Empty(cHexB)
             break
        endif

        if .not.(cHexB $ "[16][32]")
            break
        endif

        l16:=cHexB=="16"

        while ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            if nAT>0
                cBin+=if(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            endif
        end while

        cInt:=cBin

        nI:=0
        cBin:=""
        cHexN:=self:cDec
        nLn:=self:nDec

        while ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            if nAT>0
                cBin+=if(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            endif
        end while

        cDec:=cBin

        oBin:SetValue(cSig+cInt+"."+cDec)

    end sequence

return(oBin)

/*
    method:B2H
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:07/02/2013
    Descricao:Converte Bin para Hex
    Sintaxe:tBigNumber():B2H(cHexB) -> cHexN
*/
method B2H(cHexB) class tBigNumber

    local aH2B:={;
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

    local cChr
    local cInt
    local cDec
    local cSig:=self:cSig
    local cBin:=self:cInt
    local cHexN:=""

    local oHexN

    local nI:=1
    local nLn:=hb_bLen(cBin)
    local nAT

    local l16

    begin sequence

        if Empty(cHexB)
            break
        endif

        if .not.(cHexB $ "[16][32]")
            oHexN:=tBigNumber():New(NIL,16)
            break
        endif

        l16:=cHexB=="16"

        while nI<=nLn
            cChr:=SubStr(cBin,nI,if(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(if(l16,SubStr(aE[2],2),aE[2])==cChr)})
            if nAT>0
                cHexN+=aH2B[nAT][1]
            endif
            nI+=if(l16,4,5)
        end while

        cInt:=cHexN

        nI:=1
        cBin:=self:cDec
        nLn:=self:nDec
        cHexN:=""

        while nI<=nLn
            cChr:=SubStr(cBin,nI,if(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(if(l16,SubStr(aE[2],2),aE[2])==cChr)})
            if nAT>0
                cHexN+=aH2B[nAT][1]
            endif
            nI+=if(l16,4,5)
        end while

        cDec:=cHexN

        oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

    end sequence

return(oHexN)

/*
    method:D2B
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2013
    Descricao:Converte Dec para Bin
    Sintaxe:tBigNumber():D2B(cHexB) -> oBin
*/
method D2B(cHexB) class tBigNumber
    local oHex:=self:D2H(cHexB)
    local oBin:=oHex:H2B()
return(oBin)

/*
    method:B2D
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2013
    Descricao:Converte Bin para Dec
    Sintaxe:tBigNumber():B2D(cHexB) -> oDec
*/
method B2D(cHexB) class tBigNumber
    local oHex:=self:B2H(cHexB)
    local oDec:=oHex:H2D()
return(oDec)

/*
    method:Randomize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:03/03/2013
    Descricao:Randomize BigN Integer
    Sintaxe:tBigNumber():Randomize(uB,uE,nExit) -> oR
*/
method Randomize(uB,uE,nExit) class tBigNumber

    local aE

    local oB:=s__o0:Clone()
    local oE:=s__o0:Clone()
    local oT:=s__o0:Clone()
    local oM:=s__o0:Clone()
    local oR:=s__o0:Clone()

    local cR:=""

    local nB
    local nE
    local nR
    local nS
    local nT

    local lI

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

    begin sequence

        if oB:gt(oM)

            nE:=Val(oM:ExactValue())
            nB:=Int(nE/2)
            nR:=__Random(nB,nE)
            cR:=hb_ntos(nR)

            oR:SetValue(cR)

            lI:=.F.
            nS:=oE:nInt

            while oR:lt(oM)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                if lI
                    while nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(Left(cR,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT+=nR
                    end while
                else
                    while nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(Left(cR,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT-=nR
                    end while
                endif
                lI:=.not.(lI)
            end while

            DEFAULT nExit:=EXIT_MAX_RANDOM
            aE:=Array(0)

            nS:=oE:nInt

            while oR:lt(oE)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                if lI
                    while  nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(Left(cR,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT+=nR
                    end while
                else
                    while nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(Left(cR,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT-=nR
                    end while
                endif
                lI:=.not.(lI)
                nT:=0
                if aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                    exit
                endif
                if nT<=RANDOM_MAX_EXIT
                    aAdd(aE,__Random(1,nExit))
                endif
            end while

            break

        endif

        if oE:lte(oM)
            nB:=Val(oB:ExactValue())
            nE:=Val(oE:ExactValue())
            nR:=__Random(nB,nE)
            cR+=hb_ntos(nR)
            oR:SetValue(cR)
            break
        endif

        DEFAULT nExit:=EXIT_MAX_RANDOM
        aE:=Array(0)

        lI:=.F.
        nS:=oE:nInt

        while oR:lt(oE)
            nB:=Val(oB:ExactValue())
            nE:=Val(oM:ExactValue())
            nR:=__Random(nB,nE)
            cR+=hb_ntos(nR)
            nT:=nS
            if lI
                while nT>0
                    nR:=-(__Random(1,nS))
                    oR:SetValue(oR:Add(Left(cR,nR)))
                    if oR:gte(oE)
                        exit
                    endif
                    nT+=nR
                end while
            else
                while nT>0
                    nR:=__Random(1,nS)
                    oR:SetValue(oR:Add(Left(cR,nR)))
                    if oR:gte(oE)
                        exit
                    endif
                    nT-=nR
                end while
            endif
            lI:=.not.(lI)
            nT:=0
            if aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                exit
            endif
            if nT<=RANDOM_MAX_EXIT
                aAdd(aE,__Random(1,nExit))
            endif
        end while

    end sequence

    if oR:lt(oB).or.oR:gt(oE)

        nT:=Min(oE:nInt,oM:nInt)
        s__IncS9(nT)
        cR:=Left(s__cN9,nT)
        oT:SetValue(cR)
        cR:=oM:Min(oE:Min(oT)):ExactValue()
        nT:=Val(cR)

        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oT:SetValue(oE:Sub(oB):Mult(s__od2):Int(.T.))

        while oR:lt(oB)
            oR:SetValue(oR:Add(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Sub(cR))
        end while

        while oR:gt(oE)
            oR:SetValue(oR:Sub(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Add(cR))
        end while

    endif

return(oR)

/*
    function:__Random
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:03/03/2013
    Descricao:Define a chamada para a funcao Random Padrao
    Sintaxe:__Random(nB,nE)
*/
static function __Random(nB,nE)

    local nR

    if nB==0
        nB:=1
    endif

    if nB==nE
        ++nE
    endif

    #ifdef __HARBOUR__
        nR:=Abs(hb_RandomInt(nB,nE))
    #else //__PROTHEUS__
        nR:=Randomize(nB,nE)
    #endif

return(nR)

/*
    method:millerRabin
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:03/03/2013
    Descricao:Miller-Rabin method (Primality test)
    Sintaxe:tBigNumber():millerRabin(uI) -> lPrime
    Ref.::http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
method millerRabin(uI) class tBigNumber

    local oN:=self:Clone()
    local oD:=tBigNumber():New(oN:Sub(s__o1))
    local oS:=s__o0:Clone()
    local oI:=s__o0:Clone()
    local oA:=s__o0:Clone()

    local lPrime:=.T.

    begin sequence

        if oN:lte(s__o1)
            lPrime:=.F.
            break
        endif

        while oD:Mod(s__o2):eq(s__o0)
            //-------------------------------------------------------------------------------------
            //(Div(2)==Mult(.5)
            oD:SetValue(oD:Mult(s__od2))
            oS:OpInc()
        end while

        DEFAULT uI:=s__o2:Clone()

        oI:SetValue(uI)
        while oI:gt(s__o0)
            oA:SetValue(oA:Randomize(s__o1,oN))
            lPrime:=mrPass(oA,oS,oD,oN)
            if .not.(lPrime)
                break
            endif
            oI:OpDec()
        end while

    end sequence

return(lPrime)

/*
    function:mrPass
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:03/03/2013
    Descricao:Miller-Rabin Pass (Primality test)
    Sintaxe:mrPass(uA,uS,uD,uN)
    Ref.::http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
static function mrPass(uA,uS,uD,uN)

    local oA:=tBigNumber():New(uA)
    local oS:=tBigNumber():New(uS)
    local oD:=tBigNumber():New(uD)
    local oN:=tBigNumber():New(uN)
    local oM:=tBigNumber():New(oN:Sub(s__o1))

    local oP:=tBigNumber():New(oA:Pow(oD):Mod(oN))
    local oW:=tBigNumber():New(oS:Sub(s__o1))

    local lmrP:=.T.

    begin sequence

        if oP:eq(s__o1)
            break
        endif

        while oW:gt(s__o0)
            lmrP:=oP:eq(oM)
            if lmrP
                break
            endif
            oP:SetValue(oP:Mult(oP):Mod(oN))
            oW:OpDec()
        end while

        lmrP:=oP:eq(oM)

    end sequence

return(lmrP)

/*
    method:FI
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:10/03/2013
    Descricao:Euler's totient function
    Sintaxe:tBigNumber():FI() -> oT
    Ref.::(Euler's totient function) http://community.topcoder.com/tc?module=static&d1=tutorials&d2=primeNumbers
    Consultar:http://www.javascripter.net/math/calculators/eulertotientfunction.htm para otimizar.

    int fi(int n)
     {
       int result=n;
       for(int i=2;i*i<=n;i++)
       {
         if (n%i==0) result-=result/i;
         while (n%i==0) n/=i;
      }
       if (n>1) result-=result/n;
       return result;
    }

*/
method FI() class tBigNumber

    local oC:=self:Clone()
    local oT:=tBigNumber():New(oC:Int(.T.))

    local oI
    local oN

    if oT:lte(s__oMinFI)
        oT:SetValue(hb_ntos(TBIGNFI(Val(oT:Int(.F.,.F.)))))
    else
        oI:=s__o2:Clone()
        oN:=oT:Clone()
        while oI:Mult(oI):lte(oC)
            if oN:Mod(oI):eq(s__o0)
                oT:SetValue(oT:Sub(oT:Div(oI,.F.)))
            endif
            while oN:Mod(oI):eq(s__o0)
                oN:SetValue(oN:Div(oI,.F.))
            end while
            oI:OpInc()
        end while
        if oN:gt(s__o1)
            oT:SetValue(oT:Sub(oT:Div(oN,.F.)))
        endif
    endif

return(oT)
#ifdef __PROTHEUS__
    static function TBIGNFI(n)
        local i:=2
        local fi:=n
        while ((i*i)<=n)
            if ((n%i)==0)
                fi-=Int(fi/i)
            endif
            while ((n%i)==0)
                n:=Int(n/i)
            end while
            i++
        end while
        if (n>1)
            fi-=Int(fi/n)
        endif
    return(fi)
#endif //__PROTHEUS__

/*
    method:PFactors
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/03/2013
    Descricao:Fatores Primos
    Sintaxe:tBigNumber():PFactors() -> aPFactors
*/
method PFactors() class tBigNumber

    local aPFactors:=Array(0)

    local cP:=""

    local oN:=self:Clone()
    local oP:=s__o0:Clone()
    local oT:=s__o0:Clone()

    local otP:=tPrime():New()

    local nP
    local nC:=0

    local lPrime:=.T.

    otP:IsPReset()
    otP:nextPReset()

    while otP:nextPrime(cP)
        cP:=LTrim(otP:cPrime)
        oP:SetValue(cP)
        if oP:gte(oN).or.if(lPrime,lPrime:=otP:IsPrime(oN:cInt),lPrime.or.(++nC>1.and.oN:gte(otP:cLPrime)))
            aAdd(aPFactors,{oN:cInt,"1"})
            exit
        endif
        while oN:Mod(oP):eq(s__o0)
            nP:=aScan(aPFactors,{|e|e[1]==cP})
            if nP==0
                aAdd(aPFactors,{cP,"1"})
            else
                oT:SetValue(aPFactors[nP][2])
                aPFactors[nP][2]:=oT:OpInc():ExactValue()
            endif
            oN:SetValue(oN:Div(oP,.F.))
            nC:=0
            lPrime:=.T.
        end while
        if oN:lte(s__o1)
            exit
        endif
    end while

return(aPFactors)

/*
    method:Factorial
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/03/2013
    Descricao:Fatorial de Numeros Inteiros
    Sintaxe:tBigNumber():Factorial() -> oF
    TODO:Otimizar++
    Referencias:http://www.luschny.de/math/factorial/FastFactorialFunctions.htm
                http://www.luschny.de/math/factorial/index.html
                 
*/
method Factorial() class tBigNumber
    local aRecFact:=Array(0)
    local oN:=self:Clone():Int(.T.,.F.)
    local oR:=s__o1:Clone()
    local nD
    local nJ
    local nT
    local pMTX
    local oThreads
    begin sequence
        if oN:eq(s__o0)
            break
        endif
        #ifdef __HARBOUR__
            pMTX:=hb_MutexCreate()
        #else //__PROTHEUS__
            pMTX:=MTXCreate(NIL,MTX_KEY)
        #endif
        recFact(s__o1:Clone(),oN,@aRecFact,pMTX)
        #ifdef __PROTHEUS__
            aEval(getGlbVarResult(pMTX),{|r|aAdd(aRecFact,r)})
        #endif //__PROTHEUS__
        oThreads:=tBigNThread():New(MTX_KEY)
        #ifdef __PROTHEUS__
            pMTX:=MTXCreate(NIL,MTX_KEY)
            oThreads:cGlbResult:=pMTX
            oThreads:bOnStartJob:="u_tBigNumber()"
        #endif //__PROTHEUS__
        oThreads:Start(Len(aRecFact))
        #ifdef __PROTHEUS__
            aEval(aRecFact,{|e,i|oThreads:SetEvent(i,"u_thMultFact('"+e[1]+"','"+e[2]+"')")})
        #else //__HARBOUR__
            aEval(aRecFact,{|e,i|oThreads:SetEvent(i,{@multFact(),e[1],e[2]})})
        #endif //__PROTHEUS__
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()
        #ifdef __PROTHEUS__
            oThreads:Finalize()
            MTXObj(NIL,MTX_KEY):Clear()
            while ((nJ:=Len(aRecFact:=getGlbVarResult(pMTX)))>1)
        #else //__HARBOUR__
            while ((nJ:=Len(aRecFact:=oThreads:getAllResults()))>1)
        #endif
                if .not.((nJ%2)==0)
                    ++nJ
                    #ifdef __PROTHEUS__
                        aAdd(aRecFact,s__o1:Clone():GetValue())
                    #else //__HARBOUR__
                        aAdd(aRecFact,s__o1:Clone())
                    #endif //__PROTHEUS__
                endif
                oThreads:=tBigNThread():New(MTX_KEY)
                #ifdef __PROTHEUS__
                    pMTX:=MTXCreate(NIL,MTX_KEY)
                    oThreads:cGlbResult:=pMTX
                    oThreads:bOnStartJob:="u_tBigNumber()"
                #endif //__PROTHEUS__
                oThreads:Start(nJ/2)
                nT:=0
                for nD:=1 to nJ step 2
                    #ifdef __PROTHEUS__
                        oThreads:SetEvent(++nT,"u_thiMult('"+aRecFact[nD]+"','"+aRecFact[nD+1]+"')")
                    #else //__HARBOUR__
                        oThreads:SetEvent(++nT,{@thiMult(),aRecFact[nD],aRecFact[nD+1]})
                    #endif //__PROTHEUS__
                next nD
                oThreads:Notify()
                oThreads:Wait()
                oThreads:Join()
                #ifdef __PROTHEUS__
                    oThreads:Finalize()
                    MTXObj(NIL,MTX_KEY):Clear()
                #endif //__PROTHEUS__
            end while
        #ifdef __PROTHEUS__
            aEval(aRecFact,{|r|oR:SetValue(oR:iMult(r))})
        #else //__HARBOUR__
            aEval(aRecFact,{|r|oR:=oR:iMult(r)})
        #endif //__PROTHEUS__
    end sequence
return(oR)

/*
    function:recFact
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/01/2014
    Descricao:Fatorial de Numeros Inteiros
    Sintaxe:recFact(oS,oN)
    Referencias:http://www.luschny.de/math/factorial/FastFactorialFunctions.htm
    static BigInt recfact(long start, long n) {
        long i;
        if (n <= 16) { 
            BigInt r = new BigInt(start);
            for (i = start + 1; i < start + n; i++) r *= i;
            return r;
        }
        i = n / 2;
        return recfact(start, i) * recfact(start + i, n - i);
    }
    static BigInt factorial(long n) { return recfact(1, n); }        
*/
#ifdef __PROTHEUS__
static function recFact(oS,oN,aRecFact,pMTX)
#else //__HARBOUR__
static procedure recFact(oS,oN,aRecFact,pMTX)
#endif //__PROTHEUS__

    local oI    
    local oSI
    local oNI

#ifndef __PROTHEUS__
    local oThreads
#endif //__PTCOMPAT__
    
    begin sequence

        oI:=oN:Clone()
        
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oI:SetValue(oI:Mult(s__od2):Int(.T.,.F.))

        //TODO: Porque? n<=(3*(n/2))  
        if oN:lte(s__o3:iMult(oI))
            #ifdef __PROTHEUS__
                DEFAULT aRecFact:=Array(0)
                aAdd(aRecFact,{oS:GetValue(),oN:GetValue()})
            #else //__HARBOUR__
                while .not.(hb_MutexLock(pMTX))
                end while
                aAdd(aRecFact,{oS,oN})
                hb_MutexUnLock(pMTX)
            #endif //__PROTHEUS__
            break
        endif

        oSI:=oS:Clone()
        oSI:SetValue(oSI:iAdd(oI))

        oNI:=oN:Clone()
        oNI:SetValue(oNI:iSub(oI))
        
        oThreads:=tBigNThread():New(MTX_KEY)
        #ifdef __PROTHEUS__
            oThreads:cGlbResult:=pMTX
            oThreads:bOnStartJob:="u_tBigNumber()"
        #endif //__PROTHEUS__
        oThreads:Start(2)
        #ifdef __HARBOUR__ 
            oThreads:setEvent(1,{||recFact(oS,oI,@aRecFact)})
            oThreads:setEvent(2,{||recFact(oSI,oNI,@aRecFact)})
        #else //__PROTHEUS__
            oThreads:setEvent(1,"u_threcFact('"+oS:GetValue()+"','"+oI:GetValue()+"','"+pMTX+"')")
            oThreads:setEvent(2,"u_threcFact('"+oSI:GetValue()+"','"+oNI:GetValue()+"','"+pMTX+"')")
        #endif //__HARBOUR__
            oThreads:Notify()
            oThreads:Wait()
            oThreads:Join()
        #ifdef __PROTHEUS__
            oThreads:Finalize()
        #endif //__PROTHEUS__
 
    end sequence

#ifdef __PROTHEUS__        
return(aRecFact)
#else //__HARBOUR__
return
#endif

/*
    function:multFact
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:27/07/2015
    Descricao:Fatorial de Numeros Inteiros
    Sintaxe:recFact(oS,oN)
    Referencias:http://www.luschny.de/math/factorial/FastFactorialfunctions.htm
*/
static function multFact(oS,oN)
    local oR:=oS:Clone()
#ifndef __PTCOMPAT__
    local nB
    local nI
    local nSN
#else
    local oI
    local oSN
#endif
    #ifdef __PTCOMPAT__
        oI:=oS:Clone()
        oSN:=oS:Clone()
        oSN:SetValue(oSN:iAdd(oN))
        oI:OpInc()
        while oI:lt(oSN)
            oR:SetValue(oR:iMult(oI))
            oI:OpInc()
        end while
    #else //__HARBOUR__
        nB:=oS:__nBase()
        nI:=Val(oS:__cInt())
        nSN:=nI
        nSN+=Val(oN:__cInt())
        while ++nI<nSN
            oR:SetValue(tBigNiMult(oR:__cInt(),nI,nB))
        end while
    #endif //__PTCOMPAT__        
return(oR)

/*
    method:Fibonacci
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/05/2015
    Descricao: Retorna a Sequencia de Fibonacci
    Sintaxe: tBigNumber():Fibonacci() -> aFibonacci
    
#fib.py
#-----------------------------------------------------
import math
def fib(n):
     a, b = 0, 1
     print(n,':')
     while a < n:
         print(a, end=' ')
         a, b = b, a+b
     print()
#-----------------------------------------------------
t=1000
for number in range(1,t,int(math.sqrt(t)/2)):
    fib(number)

*/
method Fibonacci() class tBigNumber
    Local aFibonacci:=Array(0)
    Local oN:=self
    Local oA:=tBigNumber():New("0")
    Local oB:=tBigNumber():New("1")
#ifdef __HARBOUR__
    Local oT
#else
    Local oT:=tBigNumber():New("0")
#endif //__PROTHEUS__
#ifdef __HARBOUR__
    While (oA<oN)
        aAdd(aFibonacci,oA:ExactValue())
        oT:=oB:Clone()
        oB:=oA+oB
        oA:=oT
   End While
#else //__PROTHEUS__
    While (oA:lt(oN))
        aAdd(aFibonacci,oA:ExactValue())
        oT:SetValue(oB)
        oB:SetValue(oA:Add(oB))
        oA:SetValue(oT)
    End While
#endif
return(aFibonacci)

/*
    function:egMult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Multiplicacao Egipcia (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
    Sintaxe:egMult(cN1,cN2,nBase,nAcc) -> oMTP
    Obs.:Interessante+lenta... Utiliza Soma e Subtracao para obter o resultado
*/
static function egMult(cN1,cN2,nBase)

#ifdef __PTCOMPAT__

    local aeMT:=Array(0)

    local nI:=0
    local nCmp

    local oN1:=tBigNumber():New(cN1,nBase)
    local oMTM:=s__o1:Clone()
    local oMTP:=tBigNumber():New(cN2,nBase)

    while oMTM:lte(oN1)
        ++nI
        aAdd(aeMT,{oMTM:Int(.F.,.F.),oMTP:Int(.F.,.F.)})
        oMTM:__cInt(oMTM:Add(oMTM):__cInt())
        oMTP:__cInt(oMTP:Add(oMTP):__cInt())
    end while

    oMTM:__cInt("0")
    oMTP:__cInt("0")

    while nI>0
        oMTM:__cInt(oMTM:Add(aeMT[nI][1]):__cInt())
        oMTP:__cInt(oMTP:Add(aeMT[nI][2]):__cInt())
        nCmp:=oMTM:cmp(oN1)
        if nCmp==0
            exit
        elseif nCmp==1
            oMTM:__cInt(oMTM:Sub(aeMT[nI][1]):__cInt())
            oMTP:__cInt(oMTP:Sub(aeMT[nI][2]):__cInt())
        endif
        --nI
    end while

#else

    local oMTP:=s__o0:Clone()
    oMTP:__cInt(TBIGNegMult(cN1,cN2,hb_bLen(cN1),nBase))

#endif //__PTCOMPAT__

return(oMTP)

/*
    function:rMult
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Multiplicacao Russa (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
    Sintaxe:rMult(cN1,cN2,nBase) -> oNR

    Exemplo em PowerShell:
    //-----------------------------------------------------------------------------------
    function ps_rMult([int]$a,[int]$b){
        $r=0;
        do {
            "$a x $b";
            if (($a%2)-and($a -gt 0)){
                $r+=$b;
                "`t+$b";
                $a--;
            }
            $a=$a/2;
            $b=$b*2;
        } until ($a -eq 0);
        "result:$r";
    }
    ps_rMult 340 125

    340 x 125
    170 x 250
     85 x 500
                +500
     42 x 1000
     21 x 2000
                +2000
     10 x 4000
     5 x 8000
                +8000
     2 x 16000
     1 x 32000
               +32000
    result:   42500

*/
static function rMult(cA,cB,nBase)

#ifndef __PTCOMPAT__
    local oThreads
#endif

    local oa:=tBigNumber():New(cA,nBase)
    local ob:=tBigNumber():New(cB,nBase)
    local oR:=s__o0:Clone()

#ifndef __PTCOMPAT__
    oThreads:=tBigNThread():New()
    oThreads:Start(2)
    oThreads:setEvent(1,{@thMult(),oa,s__oD2})
    oThreads:setEvent(2,{@th2Mult(),ob})
#endif

    while oa:ne(s__o0)
        if oa:Mod(s__o2):gt(s__o0)
            oR:__cInt(oR:Add(ob):__cInt())
            oa:OpDec()
        endif
        #ifndef __PTCOMPAT__
            oThreads:Notify()
            oThreads:Wait()
            oa:__cInt(oThreads:getResult(1):__cInt())
            ob:__cInt(oThreads:getResult(2):__cInt())
        #else
            oa:__cInt(oa:Mult(s__oD2):__cInt())
            ob:__cInt(ob:Mult(s__o2):__cInt())
        #endif
    end while

#ifndef __PTCOMPAT__
    oThreads:Join()
#endif

return(oR)

/*
    function:egDiv
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Divisao Egipcia (http://cognosco.blogs.sapo.pt/13236.html)
    Sintaxe:egDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> oeDivQ
*/
static function egDiv(cN,cD,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__
    local aeDV:=Array(0)
    local nI:=0
    local nCmp
    local oeDivN
#endif //__PTCOMPAT__

    local cRDiv
    local oeDivR
    local oeDivQ

#ifndef __PTCOMPAT__
    local cQDiv
#endif //__PTCOMPAT__

#ifdef __PTCOMPAT__

    SYMBOL_UNUSED(nSize)

    oeDivN:=s__o0:Clone()
    oeDivN:SetValue(cN,nBase,NIL,NIL,nAcc)

    oeDivQ:=s__o0:Clone()
    oeDivQ:SetValue(s__o1)

    oeDivR:=s__o0:Clone()
    oeDivR:SetValue(cD,nBase,NIL,NIL,nAcc)

    while .T.
        ++nI
        aAdd(aeDV,{oeDivQ:Int(.F.,.F.),oeDivR:Int(.F.,.F.)})
        oeDivQ:SetValue(oeDivQ:Add(oeDivQ),nBase,"0",NIL,nAcc)
        oeDivR:SetValue(oeDivR:Add(oeDivR),nBase,"0",NIL,nAcc)
        nCmp:=oeDivR:cmp(oeDivN)
        if nCmp==1
            exit
        endif
    end while

    oeDivQ:SetValue(s__o0)
    oeDivR:SetValue(s__o0)

    while nI>0
        oeDivQ:SetValue(oeDivQ:Add(aeDV[nI][1]),nBase,"0",NIL,nAcc)
        oeDivR:SetValue(oeDivR:Add(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        nCmp:=oeDivR:cmp(oeDivN)
        if nCmp==0
            exit
        elseif nCmp==1
            oeDivQ:SetValue(oeDivQ:Sub(aeDV[nI][1]),nBase,"0",NIL,nAcc)
            oeDivR:SetValue(oeDivR:Sub(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        endif
        --nI
    end while

    aSize(aeDV,0)

    oeDivR:SetValue(oeDivN:Sub(oeDivR),nBase,"0",NIL,nAcc)

#else //__HARBOUR__

    cQDiv:=tBIGNegDiv(cN,cD,@cRDiv,nSize,nBase)

    oeDivQ:=s__o0:Clone()
    oeDivQ:__cInt(cQDiv)
    oeDivR:=s__o0:Clone()
    oeDivR:__cInt(cRDiv)

#endif //__PTCOMPAT__

    cRDiv:=oeDivR:Int(.F.,.F.)

    oeDivQ:SetValue(oeDivQ,nBase,cRDiv,NIL,nAcc)

    if .not.(lFloat).and.Right(cRDiv,1)=="0"
        cRDiv:=Left(cRDiv,oeDivR:__nInt()-1)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        oeDivQ:SetValue(oeDivQ,nBase,cRDiv,NIL,nAcc)
    endif

return(oeDivQ)

/*
    function:ecDiv
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/03/2014
    Descricao:Divisao Euclidiana (http://compoasso.free.fr/primelistweb/page/prime/euclide_en.php)
    Sintaxe:ecDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> q
 */
static function ecDiv(pA,pB,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__

   local a:=tBigNumber():New(pA,nBase)
   local b:=tBigNumber():New(pB,nBase)
   local r:=a:Clone()

#else

    local r:=s__o0:Clone()

#endif

   local q:=s__o0:Clone()

#ifdef __PTCOMPAT__

   local n:=s__o1:Clone()
   local aux:=s__o0:Clone()
   local tmp:=s__o0:Clone()
   local base:=tBigNumber():New(hb_ntos(nBase),nBase)

#endif

   local cRDiv

#ifndef __PTCOMPAT__
    local cQDiv
#endif //__PTCOMPAT__

#ifdef __PTCOMPAT__

   SYMBOL_UNUSED(nSize)

    while r:gte(b)
        aux:SetValue(b:Mult(n))
        if aux:lte(a)
            while .T.
                n:SetValue(n:Mult(base))
                tmp:SetValue(b:Mult(n))
                if tmp:gt(a)
                    exit
                endif
                aux:SetValue(tmp)
            end while
        endif
        n:Normalize(@base)
        n:SetValue(egDiv(n:__cInt(),base:__cInt(),n:__nInt(),nBase,nAcc,.F.))
        while r:gte(aux)
            r:SetValue(r:Sub(aux))
            q:SetValue(q:Add(n))
        end while
        a:SetValue(r)
        n:SetValue(s__o1)
    end while

#else

    cQDiv:=tBIGNecDiv(pA,pB,@cRDiv,nSize,nBase)

    q:__cInt(cQDiv)
    r:__cInt(cRDiv)

#endif

    cRDiv:=r:Int(.F.,.F.)
    q:SetValue(q,nBase,cRDiv,NIL,nAcc)

    if .not.(lFloat).and.Right(cRDiv,1)=="0"
        cRDiv:=Left(cRDiv,r:__nInt()-1)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        q:SetValue(q,nBase,cRDiv,NIL,nAcc)
    endif

return(q)

/*
    function:nthRoot
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:10/02/2013
    Descricao:Metodo Newton-Raphson
    Sintaxe:nthRoot(oRootB,oRootE,oAcc) -> othRoot
*/
static function nthRoot(oRootB,oRootE,oAcc)
return(__Pow(oRootB,s__o1:Div(oRootE),oAcc))

/*
    function:__Pow
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:10/02/2013
    Descricao:Metodo Newton-Raphson
    Sintaxe:__Pow(base,exp,EPS) -> oPow
    Ref.:http://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function
        :http://stackoverflow.com/questions/2882706/how-can-i-write-a-power-function-myself
*/
static function __Pow(base,expR,EPS)

    local acc
    local sqr
    local tmp

    local low
    local mid
    local lst
    local high

    local lDo

    local exp:=expR:Clone()

    if base:eq(s__o1).or.exp:eq(s__o0)
        return(s__o1:Clone())
    elseif base:eq(s__o0)
        return(s__o0:Clone())
    elseif exp:lt(s__o0)
        acc:=__pow(base,exp:Abs(.T.),EPS)
        return(s__o1:Div(acc))
    elseif exp:Mod(s__o2):eq(s__o0)
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        acc:=__pow(base,exp:Mult(s__od2),EPS)
        return(acc:Mult(acc))
    elseif exp:Dec(.T.):gt(s__o0).and.exp:Int(.T.):gt(s__o0)
        acc:=base:Pow(exp)
        return(acc)
    elseif exp:gt(s__o1)
        acc:=base:Pow(exp)
        return(acc)
    else
        low:=s__o0:Clone()
        high:=s__o1:Clone()
        sqr:=__SQRT(base)
        acc:=sqr:Clone()
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        mid:=high:Mult(s__od2)
        tmp:=mid:Sub(exp):Abs(.T.)
        lst:=s__o0:Clone()
        lDo:=tmp:gte(EPS)
        while lDo
            sqr:SetValue(__SQRT(sqr))
            if mid:lte(exp)
                low:SetValue(mid)
                acc:SetValue(acc:Mult(sqr))
            else
                high:SetValue(mid)
                acc:SetValue(s__o1:Div(sqr))
            endif
            //-------------------------------------------------------------------------------------
            //(Div(2)==Mult(.5)
            mid:SetValue(low:Add(high):Mult(s__od2))
            tmp:SetValue(mid:Sub(exp):Abs(.T.))
            lDo:=tmp:gte(EPS)
            if .not.(lDo).or.tmp:eq(lst)
                exit
            endif
            lst:SetValue(tmp)
        end while
    endif

return(acc)

/*
    function:__SQRT
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:10/02/2013
    Descricao:SQRT
    Sintaxe:__SQRT(p) -> oSQRT
*/
static function __SQRT(p)
#ifdef TBIGN_RECPOWER
    /*
        TODO:   This application has requested the Runtime to terminate it in an unusual way
                Please contact the application's support team for more information.
    */
    #ifndef __PTCOMPAT__
        local oThreads
    #endif
#endif
    local l
    local r
    local t
    local s
    local n
    local x
    local y
    local EPS
    local q:=tBigNumber():New(p)
    if q:lte(q:SysSQRT())
        #ifdef __PROTHEUS__
            r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
        #else //__HARBOUR__
            #ifdef __PTCOMPAT__
                r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
            #else
                r:=tBigNumber():New(TBIGNSQRT(q:GetValue()))
            #endif //__PTCOMPAT__
        #endif //__PROTHEUS__
    else
        n:=s__nthRAcc-1
        s__IncS0(n)
        s:="0."+Left(s__cN0,n)+"1"
        EPS:=s__o0:Clone()
        EPS:SetValue(s,NIL,NIL,NIL,s__nthRAcc)
        #ifdef __PROTHEUS__
            r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
        #else //__HARBOUR__
            #ifdef __PTCOMPAT__
                r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
            #else
                r:=tBigNumber():New(TBIGNSQRT(q:GetValue()))
            #endif //__PTCOMPAT__
        #endif //__PROTHEUS__
#ifdef __PROTHEUS__
        if r:eq(s__o0).or."*"$r:GetValue()
#else //__HARBOUR__
    #ifdef __PTCOMPAT__
        if r:eq(s__o0).or."*"$r:GetValue()
    #else
        if r:lte(s__o1)
    #endif
#endif
            //-------------------------------------------------------------------------------------
            //(Div(2)==Mult(.5)
            r:=q:Mult(s__od2)
        endif
        t:=r:Pow(s__o2):Sub(q):Abs(.T.)
        l:=s__o0:Clone()
        #ifdef TBIGN_RECPOWER
            #ifndef __PTCOMPAT__
                oThreads:=tBigNThread():New()
                oThreads:Start(2)
                oThreads:setEvent(1,{@thPow(),r,s__o2})
                oThreads:setEvent(2,{@th2Mult(),r})
            #endif
        #endif
        while t:gte(EPS)
            #ifdef TBIGN_RECPOWER
                #ifndef __PTCOMPAT__
                    oThreads:Notify()
                    oThreads:Wait()
                    x:=oThreads:getResult(1)
                    y:=oThreads:getResult(2)
                #else
                    x:=r:pow(s__o2)
                    y:=s__o2:Mult(r)
                #endif
            #else
                x:=r:pow(s__o2)
                y:=s__o2:Mult(r)
            #endif
            r:SetValue(x:Add(q):Div(y))
            t:SetValue(r:Pow(s__o2):Sub(q):Abs(.T.))
            if t:eq(l)
                exit
            endif
            l:SetValue(t)
        end while
        #ifdef TBIGN_RECPOWER
            #ifndef __PTCOMPAT__
                oThreads:Join()
            #endif
        #endif
    endif
return(r)

#ifdef TBN_DBFILE

    /*
        function:Add
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Adicao
        Sintaxe:Add(a,b,n,nBase) -> cNR
    */
    static function Add(a,b,n,nBase)

        local c

        local y:=n+1
        local k:=y

        local s:=""

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        s__IncS0(y)

        c:=aNumber(Left(s__cN0,y),y,"ADD_C")

        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])+Val(b[n])
                #endif
                if (c)->FN>=nBase
                    (c)->FN-=nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    if (c)->(rLock())
                        (c)->FN+=1
                    endif
                endif
                (c)->(dbUnLock())
            endif
            --k
            --n
        end while

        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))

    return(s)

    /*
        function:Sub
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Subtracao
        Sintaxe:Sub(a,b,n,nBase) -> cNR
    */
    static function Sub(a,b,n,nBase)

        local c

        local y:=n
        local k:=y

        local s:=""

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        s__IncS0(y)

        c:=aNumber(Left(s__cN0,y),y,"SUB_C")

        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])-Val(b[n])
                #endif
                if (c)->FN<0
                    (c)->FN+=nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    if (c)->(rLock())
                        (c)->FN-=1
                    endif
                endif
                (c)->(dbUnLock())
            endif
            --k
            --n
        end while

        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))

    return(s)

    /*
        function:Mult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Multiplicacao de Inteiros
        Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
        Obs.:Mais rapida,usa a multiplicacao nativa
    */
    static function Mult(cN1,cN2,n,nBase)

        local c

        local a:=tBigNInvert(cN1,n)
        local b:=tBigNInvert(cN2,n)
        local y:=n+n

        local i:=1
        local k:=1
        local l:=2

        local s
        local x
        local j
        local w

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        s__IncS0(y)

        c:=aNumber(Left(s__cN0,y),y,"MULT_C")

        while i<=n
            s:=1
            j:=i
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                while s<=i
                    #ifdef __PROTHEUS__
                        (c)->FN+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        (c)->FN+=Val(a[s++])*Val(b[j--])
                    #endif
                end while
                if (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    if (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN-=w
                    endif
                endif
                (c)->(dbUnLock())
            endif
            k++
            i++
        end while

        while l<=n
            s:=n
            j:=l
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                while s>=l
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,s--,1))*Val(SubStr(b,j++,1))
                #else
                    (c)->FN+=Val(a[s--])*Val(b[j++])
                #endif
                end while
                if (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    if (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN-=w
                    endif
                endif
                (c)->(dbUnLock())
            endif
            if ++k>=y
                exit
            endif
            l++
        end while

        s:=dbGetcN(c,y)

    return(s)

    /*
        function:aNumber
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:db OF Numbers
        Sintaxe:aNumber(c,n,o) -> a
    */
    static function aNumber(c,n,o)

        local a:=dbNumber(o)

        local y:=0

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        while ++y<=n
            (a)->(dbAppend(.T.))
        #ifdef __PROTHEUS__
            (a)->FN:=Val(SubStr(c,y,1))
        #else
            (a)->FN:=Val(c[y])
        #endif
            (a)->(dbUnLock())
        end while

    return(a)

    /*
        function:dbGetcN
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Montar a String de Retorno
        Sintaxe:dbGetcN(a,x) -> s
    */
    static function dbGetcN(a,n)

        local s:=""
        local y:=n

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        while y>=1
            (a)->(dbGoTo(y))
            while y>=1.and.(a)->FN==0
                (a)->(dbGoTo(--y))
            end while
            while y>=1
                (a)->(dbGoTo(y--))
                s+=hb_ntos((a)->FN)
            end while
        end while

        if s==""
            s:="0"
        endif

        if hb_bLen(s)<n
            s:=PadL(s,n,"0")
        endif

    return(s)

    static function dbNumber(cAlias)
        local aStru:={{"FN","N",18,0}}
        local cFile
    #ifndef __HARBOUR__
        local cLDriver
        local cRDD:=if((Type("__localDriver")=="C"),__localDriver,"DBFCDXADS")
    #else
        #ifndef TBN_MEMIO
        local cRDD:="DBFCDX"
        #endif
    #endif
    #ifndef __HARBOUR__
        if .not.(Type("__localDriver")=="C")
            private __localDriver
        endif
        cLDriver:=__localDriver
        __localDriver:=cRDD
    #endif
        if Select(cAlias)==0
    #ifndef __HARBOUR__
            cFile:=CriaTrab(aStru,.T.,GetdbExtension())
            if .not.(GetdbExtension()$cFile)
                cFile+=GetdbExtension()
            endif
            dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
    #else
            #ifndef TBN_MEMIO
                cFile:=CriaTrab(aStru,cRDD)
                dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
            #else
                cFile:=CriaTrab(aStru,cAlias)
            #endif
    #endif
            DEFAULT ths_aFiles:=Array(0)
            aAdd(ths_aFiles,{cAlias,cFile})
        else
            (cAlias)->(dbRLock())
    #ifdef __HARBOUR__
            (cAlias)->(hb_dbZap())
    #else
            (cAlias)->(__dbZap())
    #endif
            (cAlias)->(dbRUnLock())
        endif
    #ifndef __HARBOUR__
        if .not.(Empty(cLDriver))
            __localDriver:=cLDriver
        endif
    #endif
    return(cAlias)

    #ifdef __HARBOUR__
        #ifndef TBN_MEMIO
            static function CriaTrab(aStru,cRDD)
                local cFolder:=tbNCurrentFolder()+hb_ps()+"tbigN_tmp"+hb_ps()
                local cFile:=cFolder+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                local lSuccess:=.F.
                while .not.(lSuccess)
                    Try
                      MakeDir(cFolder)
                      dbCreate(cFile,aStru,cRDD)
                      lSuccess:=.T.
                    Catch
                      lSuccess:=.F.
                      cFile:=cFolder+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                    end
                end while
            return(cFile)
        #else
            static function CriaTrab(aStru,cAlias)
                local cFile:="mem:"+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                local lSuccess:=.F.
                while .not.(lSuccess)
                    Try
                      dbCreate(cFile,aStru,NIL,.T.,cAlias)
                      lSuccess:=.T.
                    Catch
                      lSuccess:=.F.
                      cFile:="mem:"+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                    end
                end while
            return(cFile)
        #endif
    #endif

#else

    #ifdef TBN_ARRAY

        /*
            function:Add
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Adicao
            Sintaxe:Add(a,b,n,nBase) -> cNR
        */
        static function Add(a,b,n,nBase)

            local y:=n+1
            local c:=aFill(aSize(ths_aZAdd,y),0)
            local k:=y
            local s:=""

            while n>0
            #ifdef __PROTHEUS__
                c[k]+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
            #else
                c[k]+=Val(a[n])+Val(b[n])
            #endif
                if c[k]>=nBase
                    c[k-1]+=1
                    c[k]-=nBase
                endif
                --k
                --n
            end while

            aEval(c,{|v|s+=hb_ntos(v)})

        return(s)

        /*
            function:Sub
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Subtracao
            Sintaxe:Sub(a,b,n,nBase) -> cNR
        */
        static function Sub(a,b,n,nBase)

            local y:=n
            local c:=aFill(aSize(ths_aZSub,y),0)
            local k:=y
            local s:=""

            while n>0
            #ifdef __PROTHEUS__
                c[k]+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
            #else
                c[k]+=Val(a[n])-Val(b[n])
            #endif
                if c[k]<0
                    c[k-1]-=1
                    c[k]+=nBase
                endif
                --k
                --n
            end while

            aEval(c,{|v|s+=hb_ntos(v)})

        return(s)

        /*
            function:Mult
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Multiplicacao de Inteiros
            Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
            Obs.:Mais rapida,usa a multiplicacao nativa
        */
        static function Mult(cN1,cN2,n,nBase)

            local a:=tBigNInvert(cN1,n)
            local b:=tBigNInvert(cN2,n)

            local y:=n+n
            local c:=aFill(aSize(ths_aZMult,y),0)

            local i:=1
            local k:=1
            local l:=2

            local s
            local x
            local j

            while i<=n
                s:=1
                j:=i
                while s<=i
                #ifdef __PROTHEUS__
                    c[k]+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                #else
                    c[k]+=Val(a[s++])*Val(b[j--])
                #endif
                end while
                if c[k]>=nBase
                    x:=k+1
                    c[x]:=Int(c[k]/nBase)
                    c[k]-=(c[x]*nBase)
                endif
                k++
                i++
            end while

            while l<=n
                s:=n
                j:=l
                while s>=l
                #ifdef __PROTHEUS__
                    c[k]+=Val(SubStr(a,s--,1))*Val(SubStr(b,j++,1))
                #else
                    c[k]+=Val(a[s--])*Val(b[j++])
                #endif
                end while
                if c[k]>=nBase
                    x:=k+1
                    c[x]:=Int(c[k]/nBase)
                    c[k]-=(c[x]*nBase)
                endif
                if ++k>=y
                    exit
                endif
                l++
            end while

        return(aGetcN(c,y))

        /*
            function:aGetcN
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Montar a String de Retorno
            Sintaxe:aGetcN(a,x) -> s
        */
        static function aGetcN(a,n)

            local s:=""
            local y:=n

            while y>=1
                while y>=1.and.a[y]==0
                    y--
                end while
                while y>=1
                    s+=hb_ntos(a[y])
                    y--
                end while
            end while

            if s==""
                s:="0"
            endif

            if hb_bLen(s)<n
                s:=PadL(s,n,"0")
            endif

        return(s)

    #else /*String*/

        /*
            function:Add
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Adicao
            Sintaxe:Add(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            static function Add(a,b,n,nBase)

                local c

                local y:=n+1
                local k:=y

                local v:=0
                local v1

                s__IncS0(y)

                c:=Left(s__cN0,y)

                while n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])+Val(b[n])
                    #endif
                    if v>=nBase
                        v-=nBase
                        v1:=1
                    else
                        v1:=0
                    endif
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
                end while

            return(c)
        #else //__HARBOUR__
            static function Add(a,b,n,nB)
            return(tBIGNADD(a,b,n,n,nB))
        #endif //__PTCOMPAT__

        /*
            function:Sub
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Subtracao
            Sintaxe:Sub(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            static function Sub(a,b,n,nBase)

                local c

                local y:=n
                local k:=y

                local v:=0
                local v1

                s__IncS0(y)

                c:=Left(s__cN0,y)

                while n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])-Val(b[n])
                    #endif
                    if v<0
                        v+=nBase
                        v1:=-1
                    else
                        v1:=0
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                    #else
                        c[k]:=hb_ntos(v)
                    #endif
                    v:=v1
                    --k
                    --n
                end while

            return(c)
        #else //__HARBOUR__
            static function Sub(a,b,n,nB)
            return(tBIGNSUB(a,b,n,nB))
        #endif //__PTCOMPAT__
        /*
            function:Mult
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Multiplicacao de Inteiros
            Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
            Obs.:Mais rapida, usa a multiplicacao nativa
        */
        #ifdef __PTCOMPAT__
            static function Mult(cN1,cN2,n,nBase)

                local c

                local a:=tBigNInvert(cN1,n)
                local b:=tBigNInvert(cN2,n)

                local y:=n+n

                local i:=1
                local k:=1
                local l:=2

                local s
                local j

                local v:=0
                local v1

                s__IncS0(y)

                c:=Left(s__cN0,y)

                while i<=n
                    s:=1
                    j:=i
                    while s<=i
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        v+=Val(a[s++])*Val(b[j--])
                    #endif
                    end while
                    if v>=nBase
                        v1:=Int(v/nBase)
                        v-=(v1*nBase)
                    else
                        v1:=0
                    endif
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
                end while

                while l<=n
                    s:=n
                    j:=l
                    while s>=l
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,s--,1))*Val(SubStr(b,j++,1))
                    #else
                        v+=Val(a[s--])*Val(b[j++])
                    #endif
                    end while
                    if v>=nBase
                        v1:=Int(v/nBase)
                        v-=v1*nBase
                    else
                        v1:=0
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k+1,1,hb_ntos(v1))
                    #else
                        c[k]:=hb_ntos(v)
                        c[k+1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    if ++k>=y
                        exit
                    endif
                    l++
                end while

            return(cGetcN(c,y))
        #else //__HARBOUR__
            static function Mult(a,b,n,nB)
            return(tBIGNMULT(a,b,n,n,nB))
        #endif //__PTCOMPAT__

        /*
            function:cGetcN
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Montar a String de Retorno
            Sintaxe:cGetcN(c,n) -> s
        */
        #ifdef __PTCOMPAT__
            static function cGetcN(c,n)
                local s:=""
                local y:=n
                while y>=1
                #ifdef __PROTHEUS__
                    while y>=1.and.SubStr(c,y,1)=="0"
                #else
                    while y>=1.and.c[y]=="0"
                #endif
                        y--
                    end while
                    while y>=1
                    #ifdef __PROTHEUS__
                        s+=SubStr(c,y,1)
                    #else
                        s+=c[y]
                    #endif
                        y--
                    end while
                end while
                if s==""
                    s:="0"
                endif

                if hb_bLen(s)<n
                    s:=PadL(s,n,"0")
                endif

            return(s)
        #endif //__PTCOMPAT__

    #endif /*String*/

#endif

#ifndef __PTCOMPAT__
    static function thAdd(oN,oP)
    return(oN:Add(oP))
    static function thDiv(oN,oD,lFloat)
    return(oN:Div(oD,lFloat))
    static function thMod0(oN,oD)
    return(oN:Mod(oD):eq(s__o0))
    static function thnthRoot(oN,oE)
    return(oN:nthRoot(oE))
    static function thMult(oN,oM)
    return(oN:Mult(oM))
    static function thPow(oN,oB)
    return(oN:Pow(oB))
    static function th2Mult(oN)
    return(s__o2:Mult(oN))
    static function thiMult(oN,oM)
    return(oN:iMult(oM))
    static function thLogN(oN,oB)
    return(oN:LogN(oB))
#else
    #ifdef __PROTHEUS__
        user function thMultFact(cS,cN)    
            local oS:=tBigNumber():New(cS)
            local oN:=tBigNumber():New(cN)
        return(multFact(oS,oN):GetValue())
        user function threcFact(cS,cN,cMTX)   
            local oS:=tBigNumber():New(cS)
            local oN:=tBigNumber():New(cN)
        return(recFact(oS,oN,NIL,cMTX))
        user function thiMult(cN,cM)
            local oN:=tBigNumber():New(cN)
            local oM:=tBigNumber():New(cM)
        return(oN:iMult(oM):GetValue())        
    #endif //__PROTHEUS__
#endif //__PTCOMPAT__

/*
    function:Power
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:26/08/2014
    Descricao:Exponenciação de Números Inteiros
    Sintaxe:Power(oB,oE)
*/
static function Power(oB,oE)
#ifdef TBIGN_RECPOWER
    /*
        TODO:   This application has requested the Runtime to terminate it in an unusual way
                Please contact the application's support team for more information.
    */
    return(recPower(oB,oE))
    /*
        function:recPower
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:26/08/2014
        Descricao:Exponenciação de Números Inteiros
        Sintaxe:recPower(oB,oE)
        Referencias:Baseada em recFact
        //-------------------------------------------------------------------------------------
        2^10-> (2*2)*(2*2)*(2*2)*(2*2)*(2*2)
                 4  *  4  *  4  *  4  *  4
                      16     *    16  *  4
                                 256  *  4
                                      1024
        //-------------------------------------------------------------------------------------
        2^11-> (2*2)*(2*2)*(2*2)*(2*2)*(2*2)*(1*2)
                 4  *  4  *  4  *  4  *  4  *  2
                      16     *    16  *  4  *  2
                                 256  *  4  *  2
                                      1024  *  2
                                            2048
        //-------------------------------------------------------------------------------------
    */
    static function recPower(oB,oE)

    #ifndef __PTCOMPAT__
        local oThreads
    #endif

        local oR:=oB:Clone()

        local oI
        local oE1
        local oE2

        if oE:lte(s__o2)

            oI:=oE:Clone()
            while oI:gt(s__o1)
                oR:SetValue(oR:Mult(oB))
                oI:OpDec()
            end while
            return(oR)
        endif

        oE1:=oE:Clone()
        oE2:=oE:Clone()

        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oE1:SetValue(oE1:Mult(s__od2):Int(.T.,.F.))
        oE2:SetValue(oE2:Sub(oE1))

    #ifndef __PTCOMPAT__
        oThreads:=tBigNThread():New()
        oThreads:Start(2)
        oThreads:setEvent(1,{@recPower(),oB,oE1})
        oThreads:setEvent(2,{@recPower(),oB,oE2})
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()
        return(oThreads:getResult(1):Mult(oThreads:getResult(2)))
    #else
        return(recPower(oB,oE1):Mult(recPower(oB,oE2)))
    #endif //__PTCOMPAT__
#else
    local oR:=oB:Clone()
    local oI:=oE:Clone()
    while oI:gt(s__o1)
        oR:SetValue(oR:Mult(oB))
        oI:OpDec()
    end while
return(oR)
#endif

/*
    function:tBigNInvert
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Inverte o Numero
    Sintaxe:tBigNInvert(c,n) -> s
*/
#ifdef __PTCOMPAT__
    static function tBigNInvert(c,n)
        local s:=""
        local y:=n
        while y>0
        #ifdef __PROTHEUS__
            s+=SubStr(c,y--,1)
        #else
            s+=c[y--]
        #endif
        end while
    return(s)
#else //__HARBOUR__
    static function tBigNInvert(c,n)
    return(tBigNReverse(c,n))
#endif //__PTCOMPAT__

/*
    function:MathO
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:04/02/2013
    Descricao:Operacoes matematicas
    Sintaxe:MathO(uBigN1,cOperator,uBigN2,lRetObject)
*/
static function MathO(uBigN1,cOperator,uBigN2,lRetObject)

    local oBigNR:=s__o0:Clone()

    local oBigN1:=tBigNumber():New(uBigN1)
    local oBigN2:=tBigNumber():New(uBigN2)

    do case
        case (aScan(OPERATOR_ADD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Add(oBigN2))
        case (aScan(OPERATOR_SUBTRACT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Sub(oBigN2))
        case (aScan(OPERATOR_MULTIPLY,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mult(oBigN2))
        case (aScan(OPERATOR_DIVIDE,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Div(oBigN2))
        case (aScan(OPERATOR_POW,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Pow(oBigN2))
        case (aScan(OPERATOR_MOD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mod(oBigN2))
        case (aScan(OPERATOR_ROOT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:nthRoot(oBigN2))
        case (aScan(OPERATOR_SQRT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:SQRT())
    endcase

    DEFAULT lRetObject:=.T.

return(if(lRetObject,oBigNR,oBigNR:ExactValue()))

// -------------------- assign thread static values -------------------------
#ifdef __THREAD_STATIC__
    static procedure __Initsthd()
        ths_lsdSet:=.F.
        #ifdef TBN_ARRAY
            ths_aZAdd:=Array(0)
            ths_aZSub:=Array(0)
            ths_aZMult:=Array(0)
        #else
            #ifdef TBN_DBFILE
                if (ths_aFiles==NIL)
                    ths_aFiles:=Array(0)
                endif
            #endif
        #endif
        ths_lsdSet:=.T.
    return
#endif //__THREAD_STATIC__

// -------------------- assign static values --------------------------------
static procedure __InitstbN(nBase)
    s__lstbNSet:=.F.
    *                10        20        30        40        50        60        70        80        90       100       110       120       130       140       150      
    *        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    s__cN0:="000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    s__cN0+="000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    s__nN0:=150*2
    s__cN9:="999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    s__cN9+="999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    s__nN9:=150*2
    s__o0:=tBigNumber():New("0",nBase)
    s__o1:=tBigNumber():New("1",nBase)
    s__o2:=tBigNumber():New("2",nBase)
    s__o3:=tBigNumber():New("3",nBase)
    s__o10:=tBigNumber():New("10",nBase)
    s__od2:=tBigNumber():New("0.5",nBase)
    s__oMinFI:=tBigNumber():New(MAX_SYS_FI,nBase)
    s__oMinGCD:=tBigNumber():New(MAX_SYS_GCD,nBase)
    s__nMinLCM:=Int(hb_bLen(MAX_SYS_LCM)/2)
    s__SysSQRT:=tBigNumber():New("0",nBase)
    s__lstbNSet:=.T.
return

static procedure s__IncS0(n)
    while n>s__nN0
        while .not.(hb_mutexLock(s__MTXcN0))
        end while
        s__cN0+=s__cN0
        s__nN0+=s__nN0
        hb_mutexUnLock(s__MTXcN0)
    end while
return

static procedure s__IncS9(n)
    while n>s__nN9
        while .not.(hb_mutexLock(s__MTXcN9))
        end while
        s__cN9+=s__cN9
        s__nN9+=s__nN9
        hb_mutexUnLock(s__MTXcN9)
    end while
return

#ifdef __PROTHEUS__

    static function __eTthD()
    return(staticCall(__pteTthD,__eTthD))
    static function __PITthD()
    return(staticCall(__ptPITthD,__PITthD))

#else //__HARBOUR__

    static function __eTthD()
    return(__hbeTthD())
    static function __PITthD()
    return(__hbPITthD())

    /* warning: 'void hb_FUN_...()'  defined but not used [-Wunused-function]...*/
    static function __Dummy(lDummy)
        lDummy:=.F.
        if (lDummy)
            __Dummy()
            EGDIV()
            ECDIV()
            TBIGNPADL()
            TBIGNPADR()
            TBIGNINVERT()
            TBIGNREVERSE()
            TBIGNADD()
            TBIGNSUB()
            TBIGNMULT()
            TBIGNEGMULT()
            TBIGNEGDIV()
            TBIGNECDIV()
            TBIGNGCD()
            TBIGNLCM()
            TBIGNFI()
            TBIGNALEN()
            TBIGNMEMCMP()
            TBIGN2MULT()
            TBIGNIMULT()
            TBIGNIADD()
            TBIGNISUB()
            TBIGNLMULT()
            TBIGNLADD()
            TBIGNLSUB()
            TBIGNNORMALIZE()
            TBIGNSQRT()
            TBIGNLOG()
            #ifndef __PTCOMPAT__
                THADD()
                THDIV()
                THMOD0()
                THNTHROOT()
                THMULT()
                THIMULT()
                TH2MULT()
                THPOW()
                THLOGN()
            #endif
        endif
    return(lDummy)

#endif //__PROTHEUS__

#ifdef __HARBOUR__
    #include "..\src\hb\c\tbigNumber.c"
#else //__PROTHEUS__
    #include "tBiGNCommon.prg"
#endif // __HARBOUR__
