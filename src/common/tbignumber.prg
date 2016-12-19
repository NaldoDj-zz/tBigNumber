//--------------------------------------------------------------------------------------------------------
    /*
     *  t    bbbb   iiiii  ggggg  n   n  u   u  mm mm  bbbb   eeeee  rrrr
     * ttt   b   b    i    g      nn  n  u   u  mm mm  b   b  e      r   r
     *  t    bbbb     i    g ggg  n n n  u   u  m m m  bbbb   eeee   rrrr
     *  t t  b   b    i    g   g  n  nn  u   u  m m m  b   b  e      r   r
     *  ttt  bbbbb  iiiii  ggggg  n   n  uuuuu  m   m  bbbbb  eeeee  r   r
     *
     * Copyright 2013-2016 Marinaldo de Jesus <marinaldo\/.\/jesus\/@\/blacktdn\/.\/com\/.\/br>
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
//--------------------------------------------------------------------------------------------------------
#include "tBigNumber.ch"

 #ifdef __HARBOUR__
    //--------------------------------------------------------------------------------------------------------
        #xtranslate PadL([<prm,...>])    => tBIGNPadL([<prm>])
        #xtranslate PadR([<prm,...>])    => tBIGNPadR([<prm>])
        #xtranslate Max([<prm,...>])     => tBIGNMax([<prm>])
        #xtranslate Min([<prm,...>])     => tBIGNMin([<prm>])
    //--------------------------------------------------------------------------------------------------------
#endif /*__HARBOUR__*/

#ifndef __DIVMETHOD__
    #define __DIVMETHOD__ 1
#endif

static s_aH2B   AS ARRAY

static s__cN0   AS CHARACTER
static s__nN0   AS NUMERIC
static s__cN9   AS CHARACTER
static s__nN9   AS  NUMERIC

static s__o0    AS OBJECT
static s__o1    AS OBJECT
static s__o2    AS OBJECT
static s__o10   AS OBJECT
static s__o20   AS OBJECT
static s__od2   AS OBJECT

static s__oMinFI    AS OBJECT
static s__oMinGCD   AS OBJECT
static s__nMinLCM   AS OBJECT

static s__lstbNSet  AS LOGICAL

static s__nDivMTD   AS NUMERIC

static s__nthRAcc   AS NUMERIC
static s__nDecSet   AS NUMERIC

static s__SysSQRT   AS NUMERIC

static s__MTXcN0    AS POINTER
static s__MTXcN9    AS POINTER
static s__MTXACC    AS POINTER
static s__MTXDEC    AS POINTER
static s__MTXSQR    AS POINTER

#ifdef TBN_ARRAY
    #define __THREAD_STATIC__ 1
#else
    #ifdef TBN_DBFILE
        #define __THREAD_STATIC__ 1
    #endif
#endif

#ifdef __THREAD_STATIC__
    thread static ths_lsdSet            AS LOGICAL
    #ifdef TBN_ARRAY
        thread static ths_aZAdd         AS ARRAY
        thread static ths_aZSub         AS ARRAY
        thread static ths_aZMult        AS ARRAY
    #else
        #ifdef TBN_DBFILE
            thread static ths_aFiles    AS ARRAY
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

//--------------------------------------------------------------------------------------------------------
    /*
    *    Alternative Compile Options: -d
    *
    *    #ifdef __ADVPL__
    *        -dTBN_ARRAY
    *        -dTBN_DBFILE
    *        -d__TBN_DYN_OBJ_SET__
    *    #else /*__HARBOUR__*/
    *        -dTBN_ARRAY
    *        -dTBN_DBFILE
    *        -dTBN_MEMIO
    *        -d__TBN_DYN_OBJ_SET__
    *        -d__PTCOMPAT__
    *    #endif
    */
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
    /*
        class:tBigNumber
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Instancia um novo objeto do tipo BigNumber
        Sintaxe:tBigNumber():New(uBigN) -> self
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __ADVPL__
    class tBigNumber from LongClassName
#else /*__HARBOUR__*/
    class tBigNumber from hbClass
#endif /*__ADVPL__*/

    #ifndef __ADVPL__
        #ifndef __TBN_DYN_OBJ_SET__
            #ifndef __ALT_D__
                PROTECTED:
            #endif
        #endif
    #endif
        //--------------------------------------------------------------------------------------------------------
        /* Keep in alphabetical order */
        #ifdef __HARBOUR__
            DATA cDec  AS CHARACTER INIT "0"
        #else /*__ADVPL__*/
            DATA cDec  AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cInt  AS CHARACTER INIT "0"
        #else /*__ADVPL__*/
            DATA cInt  AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cRDiv AS CHARACTER INIT "0"
        #else /*__ADVPL__*/
            DATA cRDiv AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cSig  AS CHARACTER INIT ""
        #else /*__ADVPL__*/
            DATA cSig  AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA lNeg  AS LOGICAL   INIT .F.
        #else /*__ADVPL__*/
            DATA lNeg  AS LOGICAL
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nBase AS NUMERIC   INIT 10
        #else /*__ADVPL__*/
            DATA nBase AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nDec  AS NUMERIC   INIT 1
        #else /*__ADVPL__*/
            DATA nDec  AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nInt  AS NUMERIC   INIT 1
        #else /*__ADVPL__*/
            DATA nInt  AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nSize AS NUMERIC   INIT 2
        #else /*__ADVPL__*/
            DATA nSize AS NUMERIC
        #endif /*__HARBOUR__*/

    #ifndef __ADVPL__
        EXPORTED:
    #endif

        #ifdef __HARBOUR__
            method New(uBigN,nBase AS NUMERIC) CONSTRUCTOR /*( /!\ )*/
        #else /*__ADVPL__*/
            method New(uBigN,nBase) CONSTRUCTOR /*( /!\ )*/
        #endif /*__HARBOUR__*/

        #ifndef __ADVPL__
            #ifdef TBN_DBFILE
                DESTRUCTOR tBigNGC
            #endif
        #endif

        #ifdef __HARBOUR__
            method Normalize(oBigN AS OBJECT)
        #else /*__ADVPL__*/
            method Normalize(oBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __cDec(cDec AS CHARACTER)    SETGET
        #else /*__ADVPL__*/
            method __cDec(cDec)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __cInt(cInt AS CHARACTER)    SETGET
        #else /*__ADVPL__*/
            method __cInt(cInt)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __cRDiv(cRDiv AS CHARACTER)  SETGET
        #else /*__ADVPL__*/
            method __cRDiv(cRDiv)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __cSig(cSig AS CHARACTER)    SETGET
        #else /*__ADVPL__*/
            method __cSig(cSig)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __lNeg(lNeg AS LOGICAL)      SETGET
        #else /*__ADVPL__*/
            method __lNeg(lNeg)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __nBase(nBase AS NUMERIC)    SETGET
        #else /*__ADVPL__*/
            method __nBase(nBase)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __nDec(nDec AS NUMERIC)      SETGET
        #else /*__ADVPL__*/
            method __nDec(nDec)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __nInt(nInt AS NUMERIC)      SETGET
        #else /*__ADVPL__*/
            method __nInt(nInt)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __nSize(nSize AS NUMERIC)    SETGET
        #else /*__ADVPL__*/
            method __nSize(nSize)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Clone()
        #else /*__ADVPL__*/
            method Clone()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method className()
        #else /*__ADVPL__*/
            method className()
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method SetDecimals(nSet AS NUMERIC)
        #else /*__ADVPL__*/
            method SetDecimals(nSet)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method SetValue(uBigN,nBase AS NUMERIC,cRDiv AS CHARACTER,lLZRmv AS LOGICAL,nAcc AS NUMERIC)
        #else /*__ADVPL__*/
            method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method GetValue(lAbs AS LOGICAL,lObj AS LOGICAL)
        #else /*__ADVPL__*/
            method GetValue(lAbs,lObj)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method ExactValue(lAbs AS LOGICAL,lObj AS LOGICAL)
        #else /*__ADVPL__*/
            method ExactValue(lAbs,lObj)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Abs(lObj AS LOGICAL)
        #else /*__ADVPL__*/
            method Abs(lObj)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Int(lObj AS LOGICAL,lSig AS LOGICAL)
        #else /*__ADVPL__*/
            method Int(lObj,lSig)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Dec(lObj AS LOGICAL,lSig AS LOGICAL,lNotZ AS LOGICAL)
        #else /*__ADVPL__*/
            method Dec(lObj,lSig,lNotZ)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method eq(uBigN)
        #else /*__ADVPL__*/
            method eq(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method ne(uBigN)
        #else /*__ADVPL__*/
            method ne(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method gt(uBigN)
        #else /*__ADVPL__*/
            method gt(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method lt(uBigN)
        #else /*__ADVPL__*/
            method lt(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method gte(uBigN)
        #else /*__ADVPL__*/
            method gte(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method lte(uBigN)
        #else /*__ADVPL__*/
            method lte(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method cmp(uBigN)
        #else /*__ADVPL__*/
            method cmp(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method btw(uBigS,uBigE)
        #else /*__ADVPL__*/
            method btw(uBigS,uBigE)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method ibtw(uiBigS,uiBigE)
        #else /*__ADVPL__*/
            method ibtw(uiBigS,uiBigE)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Max(uBigN)
        #else /*__ADVPL__*/
            method Max(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Min(uBigN)
        #else /*__ADVPL__*/
            method Min(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Add(uBigN)
        #else /*__ADVPL__*/
            method Add(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Plus(uBigN) INLINE self:Add(uBigN)
        #else /*__ADVPL__*/
            method Plus(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method iAdd(uBigN)
            method iPlus(uBigN) INLINE self:iAdd(uBigN)
        #else /*__ADVPL__*/
            method iAdd(uBigN)
            method iPlus(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Sub(uBigN)
            method Minus(uBigN) INLINE self:Sub(uBigN)
        #else /*__ADVPL__*/
            method Sub(uBigN)
            method Minus(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method iSub(uBigN)
            method iMinus(uBigN) INLINE self:iSub(uBigN)
        #else /*__ADVPL__*/
            method iSub(uBigN)
            method iMinus(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Mult(uBigN)
            method Multiply(uBigN) INLINE self:Mult(uBigN)
        #else /*__ADVPL__*/
            method Mult(uBigN)
            method Multiply(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method iMult(uBigN)
            method iMultiply(uBigN) INLINE self:iMult(uBigN)
        #else /*__ADVPL__*/
            method iMult(uBigN)
            method iMultiply(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method egMult(uBigN)
            method egMultiply(uBigN) INLINE self:egMult(uBigN)
        #else /*__ADVPL__*/
            method egMult(uBigN)
            method egMultiply(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method rMult(uBigN)
            method rMultiply(uBigN) INLINE self:rMult(uBigN)
        #else /*__ADVPL__*/
            method rMult(uBigN)
            method rMultiply(uBigN)
        #endif /*__HARBOUR__*/


        #ifdef __HARBOUR__
            method Div(uBigN,lFloat AS LOGICAL)
            method Divide(uBigN,lFloat) INLINE self:Div(uBigN,lFloat)
        #else /*__ADVPL__*/
            method Div(uBigN,lFloat)
            method Divide(uBigN,lFloat)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Divmethod(nMethod AS NUMERIC)
        #else /*__ADVPL__*/
            method Divmethod(nMethod)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Mod(uBigN)
        #else /*__ADVPL__*/
            method Mod(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Pow(uBigN,lIPower AS LOGICAL)
        #else /*__ADVPL__*/
            method Pow(uBigN,lIPower)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method iPow(uBigN)
        #else /*__ADVPL__*/
            method iPow(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method OpInc()
        #else /*__ADVPL__*/
            method OpInc()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method OpDec()
        #else /*__ADVPL__*/
            method OpDec()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method e(lforce AS LOGICAL)
        #else /*__ADVPL__*/
            method e(lforce)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Exp(lforce AS LOGICAL)
        #else /*__ADVPL__*/
            method Exp(lforce)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method PI(lforce AS LOGICAL)    //TODO: Implementar o calculo.
        #else /*__ADVPL__*/
            method PI(lforce)               //TODO: Implementar o calculo.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method GCD(uBigN)
        #else /*__ADVPL__*/
            method GCD(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method LCM(uBigN)
        #else /*__ADVPL__*/
            method LCM(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method nthRoot(uBigN)
        #else /*__ADVPL__*/
            method nthRoot(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method nthRootPF(uBigN)
        #else /*__ADVPL__*/
            method nthRootPF(uBigN)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method nthRootAcc(nSet AS NUMERIC)
        #else /*__ADVPL__*/
            method nthRootAcc(nSet)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method SQRT()
        #else /*__ADVPL__*/
            method SQRT()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method SysSQRT(uSet)
        #else /*__ADVPL__*/
            method SysSQRT(uSet)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Log(uBigNB)
        #else /*__ADVPL__*/
            method Log(uBigNB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method LogN(uBigNB)
        #else /*__ADVPL__*/
            method LogN(uBigNB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __Log(uBigNB)
        #else /*__ADVPL__*/
            method __Log(uBigNB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method __LogN(uBigNB)   //TODO: Validar Calculo.
        #else /*__ADVPL__*/
            method __LogN(uBigNB)   //TODO: Validar Calculo.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Log2()           //TODO: Validar Calculo.
        #else /*__ADVPL__*/
            method Log2()           //TODO: Validar Calculo.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Log10()          //TODO: Validar Calculo.
        #else /*__ADVPL__*/
            method Log10()          //TODO: Validar Calculo.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Ln()             //TODO: Validar Calculo.
        #else /*__ADVPL__*/
            method Ln()             //TODO: Validar Calculo.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method MathC(uBigN1,cOperator AS CHARACTER,uBigN2)
        #else /*__ADVPL__*/
            method MathC(uBigN1,cOperator,uBigN2)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method MathN(uBigN1,cOperator AS CHARACTER,uBigN2)
        #else /*__ADVPL__*/
            method MathN(uBigN1,cOperator,uBigN2)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Rnd(nAcc AS NUMERIC)
        #else /*__ADVPL__*/
            method Rnd(nAcc)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method NoRnd(nAcc AS NUMERIC)
        #else /*__ADVPL__*/
            method NoRnd(nAcc)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Truncate(nAcc AS NUMERIC)
        #else /*__ADVPL__*/
            method Truncate(nAcc)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Floor(nAcc AS NUMERIC)   //TODO: Verificar regra a partir de referencias bibliograficas.
        #else /*__ADVPL__*/
            method Floor(nAcc)              //TODO: Verificar regra a partir de referencias bibliograficas.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Ceiling(nAcc AS NUMERIC) //TODO: Verificar regra a partir de referencias bibliograficas.
        #else /*__ADVPL__*/
            method Ceiling(nAcc)            //TODO: Verificar regra a partir de referencias bibliograficas.
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method D2H(cHexB AS CHARACTER)
        #else /*__ADVPL__*/
            method D2H(cHexB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method H2D()
        #else /*__ADVPL__*/
            method H2D()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method H2B()
        #else /*__ADVPL__*/
            method H2B()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method B2H(cHexB AS CHARACTER)
        #else /*__ADVPL__*/
            method B2H(cHexB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method D2B(cHexB AS CHARACTER)
        #else /*__ADVPL__*/
            method D2B(cHexB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method B2D(cHexB AS CHARACTER)
        #else /*__ADVPL__*/
            method B2D(cHexB)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Randomize(uB,uE)
        #else /*__ADVPL__*/
            method Randomize(uB,uE)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method millerRabin(uI)
        #else /*__ADVPL__*/
            method millerRabin(uI)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method FI()
        #else /*__ADVPL__*/
            method FI()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method PFactors()
        #else /*__ADVPL__*/
            method PFactors()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Factorial()    //TODO: Otimizar+
        #else /*__ADVPL__*/
            method Factorial()    //TODO: Otimizar+
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            method Fibonacci()
        #else /*__ADVPL__*/
            method Fibonacci()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__

                 //--------------------------------------------------------------------------------------------------------
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
                //--------------------------------------------------------------------------------------------------------

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

                OPERATOR "^"   ARGS uBigN,lIPower INLINE __OpPower("^",self,uBigN,lIPower)
                OPERATOR "**"  ARGS uBigN,lIPower INLINE __OpPower("**",self,uBigN,lIPower)     //(same as "^")

        /*(*)*/ OPERATOR "^="  ARGS uBigN,lIPower INLINE __OpPower("^=",self,uBigN,lIPower)
        /*(*)*/ OPERATOR "**=" ARGS uBigN,lIPower INLINE __OpPower("**=",self,uBigN,lIPower)    //(same as "^=")

                OPERATOR ":="  ARGS uBigN,nBase,cRDiv,lLZRmv,nAcc INLINE __OpAssign(self,uBigN,nBase,cRDiv,lLZRmv,nAcc)

        #endif /*__HARBOUR__*/

endclass

#ifndef __ADVPL__

    //--------------------------------------------------------------------------------------------------------
    /* overloaded methods/functions */

    //--------------------------------------------------------------------------------------------------------
    static function __OpEqual(oSelf AS OBJECT,uBigN)
        return(oSelf:eq(uBigN))
    /*static function __OpEqual*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpNotEqual(oSelf AS OBJECT,uBigN)
        return(oSelf:ne(uBigN))
    /*static function __OpNotEqual*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpGreater(oSelf AS OBJECT,uBigN)
        return(oSelf:gt(uBigN))
    /*static function __OpGreater*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpGreaterEqual(oSelf AS OBJECT,uBigN)
        return(oSelf:gte(uBigN))
    /*static function __OpGreaterEqual*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpLess(oSelf AS OBJECT,uBigN)
        return(oSelf:lt(uBigN))
    /*static function __OpLess*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpLessEqual(oSelf AS OBJECT,uBigN)
        return(oSelf:lte(uBigN))
    /*static function __OpLessEqual*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpInc(oSelf AS OBJECT)
        return(oSelf:OpInc())
    /*static function __OpInc*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpDec(oSelf AS OBJECT)
        return(oSelf:OpDec())
    /*static function __OpDec*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpPlus(cOp AS CHARACTER,oSelf AS OBJECT,uBigN)
        local oOpPlus   AS OBJECT
        if cOp=="+="
            oOpPlus:=oSelf:SetValue(oSelf:Add(uBigN))
        else
            oOpPlus:=oSelf:Add(uBigN)
        endif
        return(oOpPlus)
    /*static function __OpPlus*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpMinus(cOp AS CHARACTER,oSelf AS OBJECT,uBigN)
        local oOpMinus  AS OBJECT
        if cOp=="-="
            oOpMinus:=oSelf:SetValue(oSelf:Sub(uBigN))
        else
            oOpMinus:=oSelf:Sub(uBigN)
        endif
        return(oOpMinus)
    /*static function __OpMinus*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpMult(cOp AS CHARACTER,oSelf AS OBJECT,uBigN)
        local oOpMult   AS OBJECT
        if cOp=="*="
            oOpMult:=oSelf:SetValue(oSelf:Mult(uBigN))
        else
            oOpMult:=oSelf:Mult(uBigN)
        endif
        return(oOpMult)
    /*static function __OpMult*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpDivide(cOp AS CHARACTER,oSelf AS OBJECT,uBigN,lFloat AS LOGICAL)
        local oOpDivide AS OBJECT
        if cOp=="/="
            oOpDivide:=oSelf:SetValue(oSelf:Div(uBigN,lFloat))
        else
            oOpDivide:=oSelf:Div(uBigN,lFloat)
        endif
        return(oOpDivide)
    /*static function __OpDivide*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpMod(cOp AS CHARACTER,oSelf AS OBJECT,uBigN)
        local oOpMod    AS OBJECT
        if cOp=="%="
            oOpMod:=oSelf:SetValue(oSelf:Mod(uBigN))
        else
            oOpMod:=oSelf:Mod(uBigN)
        endif
        return(oOpMod)
    /*static function __OpMod*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpPower(cOp AS CHARACTER,oSelf AS OBJECT,uBigN)
        local oOpPower  AS OBJECT
        switch cOp
            case "^="
            case "**="
                oOpPower:=oSelf:SetValue(oSelf:Pow(uBigN))
                exit
            otherwise
                oOpPower:=oSelf:Pow(uBigN)
        endswitch
        return(oOpPower)
    /*static function __OpPower*/

    //--------------------------------------------------------------------------------------------------------
    static function __OpAssign(oSelf AS OBJECT,uBigN,nBase AS NUMERIC,cRDiv AS CHARACTER,lLZRmv AS LOGICAL,nAcc AS NUMERIC)
        return(oSelf:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))
    /*static function __OpAssign*/

#else /*__ADVPL__*//*INLINE HARBOUR/ADVPL METHODS*/

    //--------------------------------------------------------------------------------------------------------
    method Plus(uBigN) class tBigNumber
        return(self:Add(uBigN))
    /*method Plus*/

    //--------------------------------------------------------------------------------------------------------
    method iPlus(uBigN) class tBigNumber
        return(self:iAdd(uBigN))
    /*method iPlus*/

    //--------------------------------------------------------------------------------------------------------
    method Minus(uBigN) class tBigNumber
        return(self:Sub(uBigN))
    /*method Minus*/

    //--------------------------------------------------------------------------------------------------------
    method iMinus(uBigN) class tBigNumber
        return(self:iSub(uBigN))
    /*method iMinus*/

    //--------------------------------------------------------------------------------------------------------
    method Multiply(uBigN)  class tBigNumber
        return(self:Mult(uBigN))
    /*method Multiply*/

    //--------------------------------------------------------------------------------------------------------
    method iMultiply(uBigN)  class tBigNumber
        return(self:iMult(uBigN))
    /*method iMultiply*/

    //--------------------------------------------------------------------------------------------------------
    method egMultiply(uBigN) class tBigNumber
        return(self:egMult(uBigN))
    /*method egMultiply*/

    //--------------------------------------------------------------------------------------------------------
    method rMultiply(uBigN) class tBigNumber
        return(self:rMult(uBigN))
    /*method rMultiply*/

    //--------------------------------------------------------------------------------------------------------
    method Divide(uBigN,lFloat) class tBigNumber
        return(self:Div(uBigN,lFloat))
    /*method Divide*/

#endif /*__ADVPL__*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:u_tBigNumber()
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Instancia um novo Objeto tBigNumber
        Sintaxe:u_tBigNumber(uBigN,nBase) -> otBigNumber
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __ADVPL__
    function u_tBigNumber(uBigN,nBase AS NUMERIC) AS OBJECT
        return(tBigNumber():New(uBigN,nBase))
    /*function u_tBigNumber*/
#endif

//--------------------------------------------------------------------------------------------------------
    /*
        method:New
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:CONSTRUCTOR
        Sintaxe:tBigNumber():New(uBigN,nBase) -> self
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method New(uBigN,nBase AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method New(uBigN,nBase) class tBigNumber
#endif /*__HARBOUR__*/

        if s__lstbNSet==NIL
            DEFAULT s__MTXcN0:=hb_mutexCreate()
            DEFAULT s__MTXcN9:=hb_mutexCreate()
            DEFAULT s__MTXACC:=hb_mutexCreate()
            DEFAULT s__MTXDEC:=hb_mutexCreate()
            DEFAULT s__MTXSQR:=hb_mutexCreate()
        endif

        #ifdef __ADVPL__

            PARAMETER nBase AS NUMERIC

            DEFAULT self:cDec:="0"
            DEFAULT self:cInt:="0"
            DEFAULT self:cRDiv:="0"
            DEFAULT self:cSig:=""
            DEFAULT self:lNeg:=.F.
            DEFAULT self:nBase:=10
            DEFAULT self:nDec:=1
            DEFAULT self:nInt:=1
            DEFAULT self:nSize:=2

        #endif /*__ADVPL__*/

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

/*method New*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:tBigNGC
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:03/03/2013
        Descricao:DESTRUCTOR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef TBN_DBFILE
    #ifdef __HARBOUR__
        procedure tBigNGC() class tBigNumber
    #else
        static procedure tBigNGC()
    #endif
            local nFile     AS NUMERIC
            local nFiles    AS NUMERIC
            DEFAULT ths_aFiles:=Array(0)
            nFiles:=tBIGNaLen(ths_aFiles)
            for nFile:=1 to nFiles
                if Select(ths_aFiles[nFile][1])>0
                    (ths_aFiles[nFile][1])->(dbCloseArea())
                endif
                #ifdef __PROTEUS__
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
        /*static procedure tBigNGC*/
#endif

//--------------------------------------------------------------------------------------------------------
    /*
        method:__cDec
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__cDec
        Sintaxe:tBigNumber():__cDec() -> cDec
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __cDec(cDec AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method __cDec(cDec) class tBigNumber
        PARAMETER cDec AS CHARACTER
#endif /*__HARBOUR__*/

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
/*method __cDec*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__cInt
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__cDec
        Sintaxe:tBigNumber():__cInt() -> cInt
    */
//--------------------------------------------------------------------------------------------------------3
#ifdef __HARBOUR__
    method __cInt(cInt AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method __cInt(cInt) class tBigNumber
        PARAMETER cInt AS CHARACTER
#endif /*__HARBOUR__*/
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
/*method __cInt*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__cRDiv
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:30/03/2014
        Descricao:__cRDiv
        Sintaxe:tBigNumber():__cRDiv() -> __cRDiv
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __cRDiv(cRDiv AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method __cRDiv(cRDiv) class tBigNumber
        PARAMETER cRDiv AS CHARACTER
#endif /*__HARBOUR__*/
        if .not.(cRDiv==NIL)
            if Empty(cRDiv)
                cRDiv:="0"
            endif
            self:cRDiv:=cRDiv
        endif
        return(self:cRDiv)
/*method __cRDiv*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__cSig
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__cSig
        Sintaxe:tBigNumber():__cSig() -> cSig
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __cSig(cSig AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method __cSig(cSig) class tBigNumber
        PARAMETER cSig AS CHARACTER
#endif /*__HARBOUR__*/
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
/*method __cSig*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__lNeg
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__lNeg
        Sintaxe:tBigNumber():__lNeg() -> lNeg
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __lNeg(lNeg AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method __lNeg(lNeg) class tBigNumber
        PARAMETER lNeg AS LOGICAL
#endif /*__HARBOUR__*/
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
/*method __lNeg*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__nBase
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__nBase
        Sintaxe:tBigNumber():__nBase() -> nBase
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __nBase(nBase AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method __nBase(nBase) class tBigNumber
        PARAMETER nBase AS NUMERIC
#endif /*__HARBOUR__*/
        if .not.(nBase==NIL)
            self:nBase:=nBase
        endif
        return(self:nBase)
/*method __nBase*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__nDec
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__nDec
        Sintaxe:tBigNumber():__nDec() -> nDec
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __nDec(nDec AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method __nDec(nDec) class tBigNumber
        PARAMETER nDec AS NUMERIC
#endif /*__HARBOUR__*/
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
/*method __nDec*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__nInt
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:__nInt
        Sintaxe:tBigNumber():__nInt() -> nInt
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __nInt(nInt AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method __nInt(nInt) class tBigNumber
        PARAMETER nInt AS NUMERIC
#endif /*__HARBOUR__*/
        if .not.(nInt==NIL)
            if nInt>self:nInt
                self:cInt:=PadL(self:cInt,nInt,"0")
                self:nInt:=nInt
                self:nSize:=self:nInt+self:nDec
            endif
        endif
        return(self:nInt)
/*method __nInt*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__nSize
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:17/02/2014
        Descricao:nSize
        Sintaxe:tBigNumber():__nSize() -> nSize
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __nSize(nSize AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method __nSize(nSize) class tBigNumber
        PARAMETER nSize AS NUMERIC
#endif /*__HARBOUR__*/
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
/*method __nSize*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Clone
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:27/03/2013
        Descricao:Clone
        Sintaxe:tBigNumber():Clone() -> oClone
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Clone() class tBigNumber
#else /*__ADVPL__*/
    method Clone() class tBigNumber
#endif /*__HARBOUR__*/
        local oClone    AS OBJECT
        #ifdef __THREAD_STATIC__
            try
                if ths_lsdSet==NIL
                    oClone:=tBigNumber():New(self)
                else
                    #ifdef __ADVPL__
                        oClone:=tBigNumber():New(self)
                    #else  /*__HARBOUR__*/
                        oClone:=__objClone(self)
                    #endif /*__ADVPL__*/
                endif
            catch
                ths_lsdSet:=NIL
                oClone:=tBigNumber():New(self)
            end
        #else
            #ifdef __ADVPL__
                oClone:=tBigNumber():New(self)
            #else  /*__HARBOUR__*/
                oClone:=__objClone(self)
            #endif /*__ADVPL__*/
        #endif //__THREAD_STATIC__
        return(oClone)
/*method Clone*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:className
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:className
        Sintaxe:tBigNumber():className() -> cclassName
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method className() class tBigNumber
#else /*__ADVPL__*/
    method className() class tBigNumber
#endif /*__HARBOUR__*/
        return("TBIGNUMBER")
/*method className*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:SetDecimals
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Setar o Numero de Casas Decimais
        Sintaxe:tBigNumber():SetDecimals(nSet) -> nLastSet
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method SetDecimals(nSet AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method SetDecimals(nSet) class tBigNumber
#endif /*__HARBOUR__*/

        local nLastSet  AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER nSet AS NUMERIC
        #endif /*__ADVPL__*/

        if hb_mutexLock(s__MTXDEC)

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

        endif

        DEFAULT nLastSet:=if(nSet==NIL,32,nSet)

        return(nLastSet)

/*method SetDecimals*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:nthRootAcc
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Setar a Precisao para nthRoot
        Sintaxe:tBigNumber():nthRootAcc(nSet) -> nLastSet
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method nthRootAcc(nSet AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method nthRootAcc(nSet) class tBigNumber
#endif /*__HARBOUR__*/

        local nLastSet  AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER nSet AS NUMERIC
        #endif /*__ADVPL__*/

        if hb_mutexLock(s__MTXACC)

            nLastSet:=s__nthRAcc

            DEFAULT s__nthRAcc:=if(nSet==NIL,6,nSet)
            DEFAULT nSet:=s__nthRAcc
            DEFAULT nLastSet:=nSet

            if nSet>MAX_DECIMAL_PRECISION
                nSet:=MAX_DECIMAL_PRECISION
            endif

            s__nthRAcc:=Min(self:SetDecimals()-1,nSet)

            hb_mutexUnLock(s__MTXACC)

        endif

        DEFAULT nLastSet:=if(nSet==NIL,6,nSet)

        return(nLastSet)

/*method nthRootAcc*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:SetValue
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:SetValue
        Sintaxe:tBigNumber():SetValue(uBigN,nBase,cRDiv,lLZRmv) -> self
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method SetValue(uBigN,nBase AS NUMERIC,cRDiv AS CHARACTER,lLZRmv AS LOGICAL,nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc) class tBigNumber
#endif /*__HARBOUR__*/

        local cType AS CHARACTER

        local nFP   AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER nBase     AS NUMERIC
            PARAMETER cRDiv     AS CHARACTER
            PARAMETER lLZRmv    AS LOGICAL
            PARAMETER nAcc      AS NUMERIC
        #endif /*__ADVPL__*/

        #ifdef __TBN_DYN_OBJ_SET__
            local nP    AS NUMERIC
            #ifdef __HARBOUR__
                MEMVAR oThis
            #endif
            private oThis   AS OBJECT
        #endif

        cType:=ValType(uBigN)

        if cType=="O"

            DEFAULT cRDiv:=uBigN:cRDiv

            #ifdef __TBN_DYN_OBJ_SET__

                #ifdef __ADVPL__

                    oThis:=self
                    uBigN:=classDataArr(uBigN)
                    nFP:=hb_bLen(uBigN)

                    for nP:=1 to nFP
                        &("oThis:"+uBigN[nP][1]):=uBigN[nP][2]
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

                oThis:=self
                nFP:=hb_bLen(uBigN)

                for nP:=1 to nFP
                    &("oThis:"+uBigN[nP][1]):=uBigN[nP][2]
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

            while " "$uBigN
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
            #ifdef __HARBOUR__
                if self:nInt>1.and.Left(self:cInt,1)=="0"
                    self:cInt:=RemLeft(self:cInt,"0")
                    self:nInt:=hb_bLen(self:cInt)
                    if (self:nInt==0)
                        self:cInt:="0"
                        self:nInt:=1
                    endif
                endif
            #else //__PROTEUS__
                while self:nInt>1.and.Left(self:cInt,1)=="0"
                    self:cInt:=Right(self:cInt,--self:nInt)
                end while
            #endif /*__HARBOUR__*/
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

    /*method SetValue*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:GetValue
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:GetValue
        Sintaxe:tBigNumber():GetValue(lAbs,lObj) -> uNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method GetValue(lAbs AS LOGICAL,lObj AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method GetValue(lAbs,lObj) class tBigNumber
#endif /*__HARBOUR__*/

        local uNR

        #ifdef __ADVPL__
            PARAMETER lAbs AS LOGICAL
            PARAMETER lObj AS LOGICAL
        #endif /*__ADVPL__*/

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

/*method GetValue*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:ExactValue
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:ExactValue
        Sintaxe:tBigNumber():ExactValue(lAbs) -> uNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method ExactValue(lAbs AS LOGICAL,lObj AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method ExactValue(lAbs,lObj) class tBigNumber
#endif /*__HARBOUR__*/

        local cDec  AS CHARACTER

        local uNR

        #ifdef __ADVPL__
            PARAMETER lAbs AS LOGICAL
            PARAMETER lObj AS LOGICAL
        #endif /*__ADVPL__*/

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

/*method ExactValue*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Abs
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna o Valor Absoluto de um Numero
        Sintaxe:tBigNumber():Abs() -> uNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Abs(lObj AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Abs(lObj) class tBigNumber
        PARAMETER lObj AS LOGICAL
#endif /*__HARBOUR__*/
        return(self:GetValue(.T.,lObj))
/*method Abs*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Int
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna a Parte Inteira de um Numero
        Sintaxe:tBigNumber():Int(lObj,lSig) -> uNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Int(lObj AS LOGICAL,lSig AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Int(lObj,lSig) class tBigNumber
#endif /*__HARBOUR__*/
        local uNR
        #ifdef __ADVPL__
            PARAMETER lObj AS LOGICAL
            PARAMETER lSig AS LOGICAL
        #endif /*__ADVPL__*/
        DEFAULT lObj:=.F.
        DEFAULT lSig:=.F.
        uNR:=if(lSig,self:cSig,"")+self:cInt
        if lObj
            uNR:=tBigNumber():New(uNR)
        endif
        return(uNR)
/*method Int*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Dec
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna a Parte Decimal de um Numero
        Sintaxe:tBigNumber():Dec(lObj,lSig,lNotZ) -> uNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Dec(lObj AS LOGICAL,lSig AS LOGICAL,lNotZ AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Dec(lObj,lSig,lNotZ) class tBigNumber
#endif /*__HARBOUR__*/

        local cDec  AS CHARACTER

        local nDec

        local uNR

        #ifdef __ADVPL__
            PARAMETER lObj    AS LOGICAL
            PARAMETER lSig    AS LOGICAL
            PARAMETER lNotZ   AS LOGICAL
        #endif /*__ADVPL__*/

        cDec:=self:cDec

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

/*method Dec*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:eq
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Compara se o valor corrente eh igual ao passado como parametro
        Sintaxe:tBigNumber():eq(uBigN) -> leq
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method eq(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method eq(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local leq   AS LOGICAL

        local oeqN1 AS OBJECT
        local oeqN2 AS OBJECT

        oeqN1:=s__o0:Clone()
        oeqN1:SetValue(self)

        oeqN2:=s__o0:Clone()
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

 /*method eq*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:ne
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Verifica se o valor corrente eh igual ao valor passado como parametro
        Sintaxe:tBigNumber():ne(uBigN) -> .not.(leq)
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method ne(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method ne(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        return(.not.(self:eq(uBigN)))
/*method ne*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:gt
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Verifica se o valor corrente eh maior que o valor passado como parametro
        Sintaxe:tBigNumber():gt(uBigN) -> lgt
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method gt(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method gt(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local lgt   AS LOGICAL

        local ogtN1 AS OBJECT
        local ogtN2 AS OBJECT

        ogtN1:=s__o0:Clone()
        ogtN1:SetValue(self)

        ogtN2:=s__o0:Clone()
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

/*method gt*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:lt
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Verifica se o valor corrente eh menor que o valor passado como parametro
        Sintaxe:tBigNumber():lt(uBigN) -> llt
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method lt(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method lt(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local llt   AS LOGICAL

        local oltN1 AS OBJECT
        local oltN2 AS OBJECT

        oltN1:=s__o0:Clone()
        oltN1:SetValue(self)

        oltN2:=s__o0:Clone()
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

/*method lt*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:gte
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Verifica se o valor corrente eh maior ou igual ao valor passado como parametro
        Sintaxe:tBigNumber():gte(uBigN) -> lgte
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method gte(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method gte(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:cmp(uBigN)>=0)
/*method gte(*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:lte
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Verifica se o valor corrente eh menor ou igual ao valor passado como parametro
        Sintaxe:tBigNumber():lte(uBigN) -> lte
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method lte(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method lte(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:cmp(uBigN)<=0)
/*method lte*/

//--------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method cmp(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method cmp(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local nCmp  AS NUMERIC
        local iCmp  AS NUMERIC

        local llt   AS LOGICAL
        local leq   AS LOGICAL

        local ocmpN1    AS OBJECT
        local ocmpN2    AS OBJECT

        ocmpN1:=s__o0:Clone()
        ocmpN1:SetValue(self)

        ocmpN2:=s__o0:Clone()
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

/*method cmp*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:btw (between)
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/04/2014
        Descricao:Retorna .T. se self estiver no intervalo passado.
        Sintaxe:tBigNumber():btw(uBigS,uBigE) -> lRet
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method btw(uBigS,uBigE) class tBigNumber
#else /*__ADVPL__*/
    method btw(uBigS,uBigE) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:cmp(uBigS)>=0.and.self:cmp(uBigE)<=0)
/*method btw*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:ibtw (integer between)
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:11/03/2014
        Descricao:Retorna .T. se self estiver no intervalo passado.
        Sintaxe:tBigNumber():ibtw(uiBigS,uiBigE) -> lRet
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method ibtw(uiBigS,uiBigE) class tBigNumber
#else /*__ADVPL__*/
    method ibtw(uiBigS,uiBigE) class tBigNumber
#endif /*__HARBOUR__*/
        local lbtw      AS LOGICAL
        local oibtwS    AS OBJECT
        local oibtwE    AS OBJECT
        lbtw:=.F.
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
/*method ibtw*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Max
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna o maior valor entre o valor corrente e o valor passado como parametro
        Sintaxe:tBigNumber():Max(uBigN) -> oMax
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Max(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Max(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        local oMax  AS OBJECT
        oMax:=tBigNumber():New(uBigN)
        if self:gt(oMax)
            oMax:SetValue(self)
        endif
        return(oMax)
/*method Max*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Min
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna o menor valor entre o valor corrente e o valor passado como parametro
        Sintaxe:tBigNumber():Min(uBigN) -> oMin
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Min(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Min(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        local oMin  AS OBJECT
        oMin:=tBigNumber():New(uBigN)
        if self:lt(oMin)
            oMin:SetValue(self)
        endif
        return(oMin)
/*method Min*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Add
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Soma
        Sintaxe:tBigNumber():Add(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Add(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Add(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lInv  AS LOGICAL
        local lAdd  AS LOGICAL

        local nDec  AS NUMERIC
        local nSize AS NUMERIC

        local oadNR AS OBJECT

        local oadN1 AS OBJECT
        local oadN2 AS OBJECT

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
            #else //__PROTEUS__
                lInv:=cN1<cN2
            #endif /*__HARBOUR__*/
            lNeg:=(oadN1:lNeg.and.(.not.(lInv))).or.(oadN2:lNeg.and.lInv)
            if lInv
                cNT:=cN1
                cN1:=cN2
                cN2:=cNT
                cNT:=NIL
            endif
        else
            lAdd:=.T.
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

/*method Add*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:iAdd
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:18/02/2015
        Descricao:Soma de Inteiros
        Sintaxe:tBigNumber():iAdd(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method iAdd(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method iAdd(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lInv  AS LOGICAL
        local lAdd  AS LOGICAL

        local nSize AS NUMERIC

        local oadNR AS OBJECT

        local oadN1 AS OBJECT
        local oadN2 AS OBJECT

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
            #else //__PROTEUS__
                lInv:=cN1<cN2
            #endif /*__HARBOUR__*/
            lNeg:=(oadN1:lNeg.and.(.not.(lInv))).or.(oadN2:lNeg.and.lInv)
            if lInv
                cNT:=cN1
                cN1:=cN2
                cN2:=cNT
                cNT:=NIL
            endif
        else
            lAdd:=.T.
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

/*method iAdd*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Sub
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Subtracao
        Sintaxe:tBigNumber():Sub(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Sub(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Sub(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lInv  AS LOGICAL
        local lSub  AS LOGICAL

        local nDec  AS NUMERIC
        local nSize AS NUMERIC

        local osbNR AS NUMERIC

        local osbN1 AS NUMERIC
        local osbN2 AS NUMERIC

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
            lSub:=.T.
            #ifdef __HARBOUR__
                lInv:=tBIGNmemcmp(cN1,cN2)==-1
            #else //__PROTEUS__
                lInv:=cN1<cN2
            #endif /*__HARBOUR__*/
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

/*method Sub*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:iSub
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:18/02/2015
        Descricao:Subtracao de Inteiros
        Sintaxe:tBigNumber():iSub(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method iSub(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method iSub(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lInv  AS LOGICAL
        local lSub  AS LOGICAL

        local nSize AS NUMERIC

        local osbNR AS NUMERIC

        local osbN1 AS NUMERIC
        local osbN2 AS NUMERIC

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
            lSub:=.T.
            #ifdef __HARBOUR__
                lInv:=tBIGNmemcmp(cN1,cN2)==-1
            #else //__PROTEUS__
                lInv:=cN1<cN2
            #endif /*__HARBOUR__*/
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

/*method iSub*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Mult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Multiplicacao
        Sintaxe:tBigNumber():Mult(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Mult(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Mult(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lNeg1 AS LOGICAL
        local lNeg2 AS LOGICAL

        local nDec  AS NUMERIC
        local nSize AS NUMERIC

        local omtNR AS OBJECT

        local omtN1 AS OBJECT
        local omtN2 AS OBJECT

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

/*method Mult*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:iMult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:18/02/2015
        Descricao:Multiplicacao
        Sintaxe:tBigNumber():iMult(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method iMult(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method iMult(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lNeg1 AS LOGICAL
        local lNeg2 AS LOGICAL

        local nSize AS NUMERIC

        local omtNR AS OBJECT

        local omtN1 AS OBJECT
        local omtN2 AS OBJECT

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

/*method iMult*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:egMult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Multiplicacao Egipcia
        Sintaxe:tBigNumber():egMult(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method egMult(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method egMult(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lNeg1 AS LOGICAL
        local lNeg2 AS LOGICAL

        local nDec  AS NUMERIC

        local omtNR AS OBJECT

        local omtN1 AS OBJECT
        local omtN2 AS OBJECT

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

/*method egMult*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:rMult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Multiplicacao Russa
        Sintaxe:tBigNumber():rMult(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method rMult(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method rMult(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNT   AS CHARACTER

        local lNeg  AS LOGICAL
        local lNeg1 AS LOGICAL
        local lNeg2 AS LOGICAL

        local nDec  AS NUMERIC

        local omtNR AS OBJECT

        local omtN1 AS OBJECT
        local omtN2 AS OBJECT

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

/*method rMult*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Div
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Divisao
        Sintaxe:tBigNumber():Div(uBigN,lFloat) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Div(uBigN,lFloat AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Div(uBigN,lFloat) class tBigNumber
#endif /*__HARBOUR__*/

        local cDec  AS CHARACTER

        local cN1   AS CHARACTER
        local cN2   AS CHARACTER
        local cNR   AS CHARACTER

        local lNeg  AS LOGICAL
        local lNeg1 AS LOGICAL
        local lNeg2 AS LOGICAL

        local nAcc  AS NUMERIC
        local nDec  AS NUMERIC

        local odvN1 AS OBJECT
        local odvN2 AS OBJECT

        local odvRD AS OBJECT
        local odvNR AS OBJECT

        #ifdef __ADVPL__
            PARAMETER lFloat AS LOGICAL
        #endif /*__ADVPL__*/

        begin sequence

            odvNR:=s__o0:Clone()

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

            nAcc:=s__nDecSet

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
/*method Div*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Divmethod
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:24/03/2014
        Descricao:Setar o metodo de Divisao a ser utilizado
        Sintaxe:tBigNumber():Divmethod(nMethod) -> nLstmethod
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Divmethod(nMethod AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method Divmethod(nMethod) class tBigNumber
#endif /*__HARBOUR__*/
        local nLstmethod    AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER nMethod AS NUMERIC
        #endif /*__ADVPL__*/
        DEFAULT s__nDivMTD:=__DIVMETHOD__
        DEFAULT nMethod:=s__nDivMTD
        nLstmethod:=s__nDivMTD
        s__nDivMTD:=nMethod
        return(nLstmethod)
/*method Divmethod*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Mod
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2013
        Descricao:Resto da Divisao
        Sintaxe:tBigNumber():Mod(uBigN) -> oMod
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Mod(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method Mod(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        local oMod  AS OBJECT
        local nCmp  AS NUMERIC
        oMod:=tBigNumber():New(uBigN)
        nCmp:=self:cmp(oMod)
        if nCmp==-1
            oMod:SetValue(self)
        elseif nCmp==0
            oMod:SetValue(s__o0)
        else
            oMod:SetValue(self:Div(oMod,.F.))
            oMod:SetValue(oMod:cRDiv,NIL,NIL,.F.)
        endif
        return(oMod)
/*method Mod*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Pow
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2013
        Descricao:Calculo de Potencia n^x
        Sintaxe:tBigNumber():Pow(uBigN,lIPower) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Pow(uBigN,lIPower AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Pow(uBigN,lIPower) class tBigNumber
#endif /*__HARBOUR__*/

        local oSelf AS OBJECT

        local cM10  AS CHARACTER

        local cPowB AS CHARACTER
        local cPowA AS CHARACTER

        local lPoWN AS LOGICAL
        local lPowF AS LOGICAL

        local nZS   AS NUMERIC

        local opwA  AS OBJECT
        local opwB  AS OBJECT

        local opwNP AS OBJECT
        local opwNR AS OBJECT

        local opwGCD

        #ifdef __ADVPL__
            PARAMETER lIPower AS LOGICAL
        #endif /*__ADVPL__*/

        begin sequence

            opwNR:=s__o0:Clone()
            oSelf:=self:Clone()

            opwNP:=s__o0:Clone()
            lPoWN:=opwNP:SetValue(uBigN):lt(s__o0)

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
                    opwA:SetValue(opwA:Div(opwGCD))
                    opwB:SetValue(opwB:Div(opwGCD))
                endif

                opwA:Normalize(@opwB)

                opwNP:SetValue(opwA)

            endif

            DEFAULT lIPower:=.F.
            opwNR:SetValue(Power(opwNR,opwNP,lIPower))

            if lPowF
                opwNR:SetValue(opwNR:nthRoot(opwB))
            endif

        end sequence

        if lPoWN
            opwNR:SetValue(s__o1:Div(opwNR))
        endif

        return(opwNR)
/*method Pow*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:iPow
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:19/09/2016
        Descricao:Calculo de Potencia de Inteiros n^x
        Sintaxe:tBigNumber():iPow(uBigN) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method iPow(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method iPow(uBigN) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:Pow(uBigN,.T.))
/*method iPow*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:OpInc
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Incrementa em 1
        Sintaxe:tBigNumber():OpInc() -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method OpInc() class tBigNumber
#else /*__ADVPL__*/
    method OpInc() class tBigNumber
#endif /*__HARBOUR__*/
    #ifdef __PTCOMPAT__
        return(self:SetValue(self:iAdd(s__o1)))
    #else
        return(self:SetValue(tBIGNiADD(self:cInt,1,self:nBase)))
    #endif
/*method OpInc()*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:OpDec
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Decrementa em 1
        Sintaxe:tBigNumber():OpDec() -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method OpDec() class tBigNumber
#else /*__ADVPL__*/
    method OpDec() class tBigNumber
#endif /*__HARBOUR__*/
    #ifdef __PTCOMPAT__
        return(self:SetValue(self:iSub(s__o1)))
    #else
        return(self:SetValue(tBIGNiSUB(self:cInt,1,self:nBase)))
    #endif
/*method OpDec*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:e
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/02/2013
        Descricao:Retorna o Numero de Neper (2.718281828459045235360287471352662497757247...)
        Sintaxe:tBigNumber():e(lforce) -> oeTthD
        (((n+1)^(n+1))/(n^n))-((n^n)/((n-1)^(n-1)))
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method e(lforce AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method e(lforce) class tBigNumber
#endif /*__HARBOUR__*/

        local oeTthD    AS OBJECT

        local oPowN     AS OBJECT
        local oDiv1P    AS OBJECT
        local oDiv1S    AS OBJECT
        local oBigNC    AS OBJECT
        local oAdd1N    AS OBJECT
        local oSub1N    AS OBJECT
        local oPoWNAd   AS OBJECT
        local oPoWNS1   AS OBJECT

        #ifdef __ADVPL__
            PARAMETER lforce AS LOGICAL
        #endif /*__ADVPL__*/

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

 /*method e*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Exp
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/02/2013
        Descricao:Potencia do Numero de Neper e^cN
        Sintaxe:tBigNumber():Exp(lforce) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Exp(lforce AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method Exp(lforce) class tBigNumber
#endif /*__HARBOUR__*/

        local oBigNe    AS OBJECT
        local oBigNR    AS OBJECT

        #ifdef __ADVPL__
            PARAMETER lforce AS LOGICAL
        #endif /*__ADVPL__*/

        oBigNe:=self:e(lforce)
        oBigNR:=oBigNe:Pow(self)

        return(oBigNR)
/*method Exp*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:PI
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Retorna o Numero Irracional PI (3.1415926535897932384626433832795...)
        Sintaxe:tBigNumber():PI(lforce) -> oPITthD
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method PI(lforce AS LOGICAL) class tBigNumber
#else /*__ADVPL__*/
    method PI(lforce) class tBigNumber
#endif /*__HARBOUR__*/

        local oPITthD   AS OBJECT

        #ifdef __ADVPL__
            PARAMETER lforce AS LOGICAL
        #endif /*__ADVPL__*/

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
/*method PI*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:GCD
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:23/02/2013
        Descricao:Retorna o GCD/MDC
        Sintaxe:tBigNumber():GCD(uBigN) -> oGCD
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method GCD(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method GCD(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local oX    AS OBJECT
        local oY    AS OBJECT

        local oGCD

        oY:=tBigNumber():New(uBigN)
        oY:SetValue(oY:Min(self))

        oX:=self:Clone()
        oX:SetValue(oY:Max(self))

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

/*method GCD*/

static function cGCD(nX AS NUMERIC,nY AS NUMERIC)
    #ifndef __PTCOMPAT__
        local nGCD  AS NUMERIC
        nGCD:=TBIGNGCD(nX,nY)
    #else /*__ADVPL__*/
        local nGCD  AS NUMERIC
        nGCD:=nX
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

/*static function cGCD*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:LCM
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:23/02/2013
        Descricao:Retorna o LCM/MMC
        Sintaxe:tBigNumber():LCM(uBigN) -> oLCM
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method LCM(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method LCM(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local oX    AS OBJECT
        local oY    AS OBJECT

        local oI    AS OBJECT

        local oLCM  AS OBJECT

        local lMX
        local lMY

        oX:=self:Clone()
        oY:=tBigNumber():New(uBigN)
        oLCM:=s__o1:Clone()
        if oX:nInt<=s__nMinLCM.and.oY:nInt<=s__nMinLCM
            oLCM:SetValue(cLCM(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
        else
            oI:=s__o2:Clone()
            while .T.
               lMX:=oX:Mod(oI):eq(s__o0)
               lMY:=oY:Mod(oI):eq(s__o0)
                while lMX.or.lMY
                    oLCM:SetValue(oLCM:Mult(oI))
                    if lMX
                        oX:SetValue(oX:Div(oI,.F.))
                        lMX:=oX:Mod(oI):eq(s__o0)
                    endif
                    if lMY
                        oY:SetValue(oY:Div(oI,.F.))
                        lMY:=oY:Mod(oI):eq(s__o0)
                    endif
                end while
                if oX:eq(s__o1).and.oY:eq(s__o1)
                    exit
                endif
                oI:OpInc()
            end while
        endif

        return(oLCM)

/*method LCM*/

static function cLCM(nX AS NUMERIC,nY AS NUMERIC)
    #ifndef __PTCOMPAT__

        local nLCM  AS NUMERIC
        nLCM:=TBIGNLCM(nX,nY)

    #else /*__ADVPL__*/

        local nLCM  AS NUMERIC
        local nI    AS NUMERIC

        local lMX   AS LOGICAL
        local lMY   AS LOGICAL

        nLCM:=1
        nI:=2

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

/*static function cLCM*/

//--------------------------------------------------------------------------------------------------------
    /*

        method:nthRoot
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2013
        Descricao:Radiciacao
        Sintaxe:tBigNumber():nthRoot(uBigN) -> othRoot
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method nthRoot(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method nthRoot(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local cFExit    AS CHARACTER

        local nZS       AS NUMERIC

        local oRootB    AS OBJECT
        local oRootE

        local othRoot   AS OBJECT

        local oFExit    AS OBJECT

        begin sequence

            othRoot:=s__o0:Clone()

            oRootB:=self:Clone()
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

/*method nthRoot*/

//--------------------------------------------------------------------------------------------------------
    /*

        method:nthRootPF
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2013
        Descricao:Radiciacao utilizando Fatores Primos
        Sintaxe:tBigNumber():nthRootPF(uBigN) -> othRoot
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method nthRootPF(uBigN) class tBigNumber
#else /*__ADVPL__*/
    method nthRootPF(uBigN) class tBigNumber
#endif /*__HARBOUR__*/

        local aIPF      AS ARRAY
        local aDPF      AS ARRAY

        local cFExit    AS CHARACTER

        local lDec      AS LOGICAL

        local nZS       AS NUMERIC

        local nPF       AS NUMERIC
        local nPFs      AS NUMERIC

        local oRootB    AS OBJECT
        local oRootD    AS OBJECT
        local oRootE    AS OBJECT

        local oRootT    AS OBJECT

        local othRoot   AS OBJECT
        local othRootD  AS OBJECT

        local oFExit    AS OBJECT

        begin sequence

            othRoot:=s__o0:Clone()

            oRootB:=self:Clone()
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

/*method nthRootPF*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:SQRT
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/03/2013
        Descricao:Retorna a Raiz Quadrada (radix quadratum -> O Lado do Quadrado) do Numero passado como parametro
        Sintaxe:tBigNumber():SQRT() -> oSQRT
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method SQRT() class tBigNumber
#else /*__ADVPL__*/
    method SQRT() class tBigNumber
#endif /*__HARBOUR__*/

        local oSQRT AS OBJECT

        begin sequence

            oSQRT:=self:Clone()
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

/*method SQRT*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:SysSQRT
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/03/2013
        Descricao:Define o valor maximo para calculo da SQRT considerando a funcao padrao
        Sintaxe:tBigNumber():SysSQRT(uSet) -> oSysSQRT
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method SysSQRT(uSet) class tBigNumber
#else /*__ADVPL__*/
    method SysSQRT(uSet) class tBigNumber
#endif /*__HARBOUR__*/

        local cType AS CHARACTER

        cType:=ValType(uSet)
        if ( cType$"C|N|O" )
            if hb_mutexLock(s__MTXSQR)
                s__SysSQRT:SetValue(if(cType$"C|O",uSet,if(cType=="N",hb_ntos(uSet),"0")))
                if s__SysSQRT:gt(MAX_SYS_SQRT)
                    s__SysSQRT:SetValue(MAX_SYS_SQRT)
                endif
                hb_MutexUnLock(s__MTXSQR)
            endif
        endif

        return(s__SysSQRT)

/*method SysSQRT*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Log
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo na Base N DEFAULT e
        Sintaxe:tBigNumber():Log(BigNB) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Log(uBigNB) class tBigNumber
#else /*__ADVPL__*/
    method Log(uBigNB) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:LogN(uBigNB))
/*method Log*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:LogN
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo na Base N DEFAULT e
        Sintaxe:tBigNumber():LogN(BigNB) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method LogN(uBigNB) class tBigNumber
#else /*__ADVPL__*/
    method LogN(uBigNB) class tBigNumber
#endif /*__HARBOUR__*/
        local oB    AS OBJECT
        local oR    AS OBJECT
        DEFAULT uBigNB:=self:e()
        oB:=s__o0:Clone()
        oB:SetValue(uBigNB)
        oR:=s__o0:Clone()
        #ifndef __PTCOMPAT__
            #ifndef __LMETHOD__
                oR:SetValue(TBIGNLOG(self:GetValue(),oB:GetValue()))
            #else
                oR:SetValue(self:__Log(oB))
            #endif //__LMETHOD__
        #else //__PTCOMPAT__
            oR:SetValue(self:__Log(oB))
        #endif //__PTCOMPAT__
        return(oR)
/*method LogN*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__Log
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo na Base N DEFAULT e
        Sintaxe:tBigNumber():__Log(BigNB) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __Log(uBigNB) class tBigNumber
#else /*__ADVPL__*/
    method __Log(uBigNB) class tBigNumber
#endif /*__HARBOUR__*/
        return(self:__LogN(uBigNB))
/*method __Log*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:__LogN
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo na Base N DEFAULT e
        Sintaxe:tBigNumber():__LogN(BigNB) -> oBigNR
        Referencia://http://www.vivaolinux.com.br/script/Calculo-de-logaritmo-de-um-numero-por-um-terceiro-metodo-em-C
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method __LogN(uBigNB) class tBigNumber
#else /*__ADVPL__*/
    method __LogN(uBigNB) class tBigNumber
#endif /*__HARBOUR__*/

        local oS        AS OBJECT
        local oT        AS OBJECT
        local oI        AS OBJECT
        local oX        AS OBJECT
        local oY        AS OBJECT
        local oLT       AS OBJECT

        local noTcmp1   AS NUMERIC

        local lflag     AS LOGICAL

        oX:=self:Clone()
        if oX:eq(s__o0)
            return(s__o0:Clone())
        endif

        DEFAULT uBigNB:=self:e()

        oT:=s__o0:Clone()
        oT:SetValue(uBigNB)

        noTcmp1:=oT:cmp(s__o1)
        if noTcmp1==0
            return(s__o0:Clone())
        endif

        lflag:=.F.
        if s__o0:lt(oT).and.noTcmp1==-1
             lflag:=.not.(lflag)
             oT:__cSig("")
             oT:SetValue(s__o1:Div(oT))
             noTcmp1:=oT:cmp(s__o1)
        endif

        oI:=s__o1:Clone()
        oY:=s__o0:Clone()
        while oX:gt(oT).and.noTcmp1==1
           oY:SetValue(oY:Add(oI))
           oX:SetValue(oX:Div(oT))
        end while

        oS:=s__o0:Clone()
        oS:SetValue(oS:Add(oY))
        oT:SetValue(oT:nthRoot(s__o2))
        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oI:SetValue(oI:Mult(s__od2))

        oY:SetValue(s__o0)

        oLT:=s__o0:Clone()
        noTcmp1:=oT:cmp(s__o1)

        while noTcmp1==1

            while oX:gt(oT).and.noTcmp1==1
                oY:SetValue(oY:Add(oI))
                oX:SetValue(oX:Div(oT))
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

        if lflag
            oS:__cSig("-")
        endif

        return(oS)
/*method __LogN*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Log2
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo Base 2
        Sintaxe:tBigNumber():Log2() -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Log2() class tBigNumber
#else /*__ADVPL__*/
    method Log2() class tBigNumber
#endif /*__HARBOUR__*/
        local ob2   AS OBJECT
        ob2:=s__o2:Clone()
        return(self:LogN(ob2))
/*method Log2*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Log10
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Retorna o logaritmo Base 10
        Sintaxe:tBigNumber():Log10() -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Log10() class tBigNumber
#else /*__ADVPL__*/
    method Log10() class tBigNumber
#endif /*__HARBOUR__*/
        local ob10  AS OBJECT
        ob10:=s__o10:Clone()
        return(self:LogN(ob10))
/*method Log10*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Ln
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:20/02/2013
        Descricao:Logaritmo Natural
        Sintaxe:tBigNumber():Ln() -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Ln() class tBigNumber
#else /*__ADVPL__*/
    method Ln() class tBigNumber
#endif /*__HARBOUR__*/
        return(self:LogN(s__o1:Exp()))
/*method Ln*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:MathC
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2013
        Descricao:Operacoes Matematicas
        Sintaxe:tBigNumber():MathC(uBigN1,cOperator,uBigN2) -> cNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method MathC(uBigN1,cOperator AS CHARACTER,uBigN2) class tBigNumber
#else /*__ADVPL__*/
    method MathC(uBigN1,cOperator,uBigN2) class tBigNumber
        PARAMETER cOperator AS CHARACTER
#endif /*__HARBOUR__*/
        return(MathO(uBigN1,cOperator,uBigN2,.F.))
/*method MathC*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:MathN
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Operacoes Matematicas
        Sintaxe:tBigNumber():MathN(uBigN1,cOperator,uBigN2) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method MathN(uBigN1,cOperator AS CHARACTER,uBigN2) class tBigNumber
#else /*__ADVPL__*/
    method MathN(uBigN1,cOperator,uBigN2) class tBigNumber
        PARAMETER cOperator AS CHARACTER
#endif /*__HARBOUR__*/
        return(MathO(uBigN1,cOperator,uBigN2,.T.))
/*method MathN*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Rnd
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/02/2013
        Descricao:Rnd arredonda um numero decimal, "para cima", se o digito da precisao definida for >= 5, caso contrario, truca.
        Sintaxe:tBigNumber():Rnd(nAcc) -> oRND
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Rnd(nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method Rnd(nAcc) class tBigNumber
#endif /*__HARBOUR__*/

        local oRnd  AS OBJECT

        local cAdd  AS CHARACTER
        local cAcc  AS CHARACTER

        #ifdef __ADVPL__
            PARAMETER nAcc AS NUMERIC
        #endif /*__ADVPL__*/

        oRnd:=self:Clone()
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
/*method Rnd*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:NoRnd
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/02/2013
        Descricao:NoRnd trunca um numero decimal
        Sintaxe:tBigNumber():NoRnd(nAcc) -> oBigNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method NoRnd(nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method NoRnd(nAcc) class tBigNumber
        PARAMETER nAcc AS NUMERIC
#endif /*__HARBOUR__*/
        return(self:Truncate(nAcc))
/*method NoRnd*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Floor
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2014
        Descricao:Retorna o "Piso" de um Numero Real de acordo com o Arredondamento para "baixo"
        Sintaxe:tBigNumber():Floor(nAcc) -> oFloor
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Floor(nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method Floor(nAcc) class tBigNumber
#endif /*__HARBOUR__*/

        local oInt      AS OBJECT
        local oFloor    AS OBJECT

        #ifdef __ADVPL__
            PARAMETER nAcc AS NUMERIC
        #endif /*__ADVPL__*/

        oFloor:=self:Clone()
        DEFAULT nAcc:=Max((Min(oFloor:nDec,s__nDecSet)-1),0)
        oFloor:SetValue(oFloor:Rnd(nAcc):Int(.T.,.T.))

        oInt:=self:Int(.T.,.T.)
        oFloor:SetValue(oFloor:Min(oInt))

        return(oFloor)
/*method Floor*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Ceiling
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:05/03/2014
        Descricao:Retorna o "Teto" de um Numero Real de acordo com o Arredondamento para "cima"
        Sintaxe:tBigNumber():Ceiling(nAcc) -> oCeiling
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Ceiling(nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method Ceiling(nAcc) class tBigNumber
#endif /*__HARBOUR__*/

        local oInt      AS OBJECT
        local oCeiling  AS OBJECT

        #ifdef __ADVPL__
            PARAMETER nAcc AS NUMERIC
        #endif /*__ADVPL__*/

        oCeiling:=self:Clone()
        DEFAULT nAcc:=Max((Min(oCeiling:nDec,s__nDecSet)-1),0)
        oCeiling:SetValue(oCeiling:Rnd(nAcc):Int(.T.,.T.))

        oInt:=self:Int(.T.,.T.)
        oCeiling:SetValue(oCeiling:Max(oInt))

        return(oCeiling)
/*method Ceiling(nAcc)*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Truncate
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:06/02/2013
        Descricao:Truncate trunca um numero decimal
        Sintaxe:tBigNumber():Truncate(nAcc) -> oTrc
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Truncate(nAcc AS NUMERIC) class tBigNumber
#else /*__ADVPL__*/
    method Truncate(nAcc) class tBigNumber
#endif /*__HARBOUR__*/

        local oTrc  AS OBJECT
        local cDec  AS CHARACTER

        #ifdef __ADVPL__
            PARAMETER nAcc AS NUMERIC
        #endif /*__ADVPL__*/

        oTrc:=self:Clone()

        cDec:=oTrc:cDec
        if .not.(s__o0:eq(cDec))
            DEFAULT nAcc:=Min(oTrc:nDec,s__nDecSet)
            cDec:=Left(cDec,nAcc)
            oTrc:SetValue(oTrc:cInt+"."+cDec)
        endif

        return(oTrc)
/*method Truncate*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Normalize
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Normaliza os Dados
        Sintaxe:tBigNumber():Normalize(oBigN) -> self
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Normalize(oBigN AS OBJECT) class tBigNumber
#else /*__ADVPL__*/
    method Normalize(oBigN) class tBigNumber
#endif /*__HARBOUR__*/
        #ifdef __PTCOMPAT__
            local nPadL AS NUMERIC
            local nPadR AS NUMERIC
            local nSize AS NUMERIC

            local lPadL AS LOGICAL
            local lPadR AS LOGICAL

            #ifdef __ADVPL__
                PARAMETER oBigN AS OBJECT
            #endif /*__ADVPL__*/

            nPadL:=Max(self:nInt,oBigN:nInt)
            nPadR:=Max(self:nDec,oBigN:nDec)
            nSize:=(nPadL+nPadR)

            s__IncS0(nSize)

            lPadR:=nPadR!=self:nDec
            lPadL:=nPadL!=self:nInt

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
        #else /*__HARBOUR__*/
            tBIGNNormalize(@self:cInt,@self:nInt,@self:cDec,@self:nDec,@self:nSize,@oBigN:cInt,@oBigN:nInt,@oBigN:cDec,@oBigN:nDec,@oBigN:nSize)
        #endif /*__PTCOMPAT__*/
    return(self)
/*method Normalize*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:D2H
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:07/02/2013
        Descricao:Converte Decimal para Hexa
        Sintaxe:tBigNumber():D2H(cHexB) -> cHexN
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method D2H(cHexB AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method D2H(cHexB) class tBigNumber
#endif /*__HARBOUR__*/

        local otH   AS OBJECT
        local otN   AS OBJECT

        local cHexN AS CHARACTER
        local cHexC AS CHARACTER

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER
        local cSig  AS CHARACTER

        local oHexN AS OBJECT

        local nAT   AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER cHexB AS CHARACTER
        #endif /*__ADVPL__*/

        DEFAULT cHexB:="16"

        otH:=s__o0:Clone()
        otH:SetValue(cHexB)

        otN:=tBigNumber():New(self:cInt)

        cHexN:=""
        cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"

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

        cSig:=self:cSig
        oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

        return(oHexN)
/*method D2H*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:H2D
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:07/02/2013
        Descricao:Converte Hexa para Decimal
        Sintaxe:tBigNumber():H2D() -> otNR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method H2D() class tBigNumber
#else /*__ADVPL__*/
    method H2D() class tBigNumber
#endif /*__HARBOUR__*/

        local otH   AS OBJECT
        local otNR  AS OBJECT
        local otLN  AS OBJECT
        local otPw  AS OBJECT
        local otNI  AS OBJECT
        local otAT  AS OBJECT

        local cHexB AS CHARACTER
        local cHexC AS CHARACTER
        local cHexN AS CHARACTER

        local cInt
        local cDec
        local cSig  AS CHARACTER

        local nLn   AS NUMERIC
        local nI    AS NUMERIC

        otH:=s__o0:Clone()
        cHexB:=hb_ntos(self:nBase)
        otH:SetValue(cHexB)
        cHexN:=self:cInt
        nLn:=hb_bLen(cHexN)
        otLN:=s__o0:Clone()
        otLN:SetValue(hb_ntos(nLn))

        otNR:=s__o0:Clone()

        otPw:=s__o0:Clone()
        otNI:=s__o0:Clone()
        otAT:=s__o0:Clone()

        cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"
        nI:=nLn
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

        cSig:=self:cSig
        otNR:SetValue(cSig+cInt+"."+cDec)

        return(otNR)
/*method H2D*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:H2B
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:07/02/2013
        Descricao:Converte Hex para Bin
        Sintaxe:tBigNumber():H2B(cHexN) -> cBin
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method H2B() class tBigNumber
#else /*__ADVPL__*/
    method H2B() class tBigNumber
#endif /*__HARBOUR__*/

        local aH2B  AS ARRAY

        local cChr  AS CHARACTER
        local cBin  AS CHARACTER

        local cInt  AS CHARACTER
        local cDec  AS CHARACTER

        local cSig  AS CHARACTER
        local cHexB AS CHARACTER
        local cHexN AS CHARACTER

        local oBin  AS OBJECT

        local nI    AS NUMERIC
        local nLn   AS NUMERIC
        local nAT   AS NUMERIC

        local l16   AS LOGICAL

        begin sequence

            cBin:=""

            cHexB:=hb_ntos(self:nBase)
            if Empty(cHexB)
                 break
            endif

            if .not.(cHexB$"[16][32]")
                break
            endif

            l16:=cHexB=="16"

            aH2B:=s_aH2B

            cHexN:=self:cInt
            nLn:=hb_bLen(cHexN)
            nI:=0
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

            oBin:=tBigNumber():New(NIL,2)
            cSig:=self:cSig
            oBin:SetValue(cSig+cInt+"."+cDec)

        end sequence

        DEFAULT oBin:=tBigNumber():New(NIL,2)

        return(oBin)
/*method H2B*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:B2H
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:07/02/2013
        Descricao:Converte Bin para Hex
        Sintaxe:tBigNumber():B2H(cHexB) -> cHexN
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method B2H(cHexB AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method B2H(cHexB) class tBigNumber
#endif /*__HARBOUR__*/

        local aH2B  AS ARRAY

        local cChr  AS CHARACTER
        local cInt  AS CHARACTER
        local cDec  AS CHARACTER
        local cSig  AS CHARACTER
        local cBin  AS CHARACTER
        local cHexN AS CHARACTER

        local oHexN AS OBJECT

        local nI    AS NUMERIC
        local nLn   AS NUMERIC
        local nAT   AS NUMERIC

        local l16   AS LOGICAL

        #ifdef __ADVPL__
            PARAMETER cHexB AS CHARACTER
        #endif /*__ADVPL__*/

        begin sequence

            if Empty(cHexB)
                break
            endif

            if .not.(cHexB$"[16][32]")
                oHexN:=tBigNumber():New(NIL,16)
                break
            endif

            l16:=cHexB=="16"

            aH2B:=s_aH2B
            cBin:=self:cInt
            cHexN:=""

            nI:=1
            nLn:=hb_bLen(cBin)

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

            cSig:=self:cSig
            oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

        end sequence

        return(oHexN)
/*method B2H*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:D2B
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:23/03/2013
        Descricao:Converte Dec para Bin
        Sintaxe:tBigNumber():D2B(cHexB) -> oBin
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method D2B(cHexB AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method D2B(cHexB) class tBigNumber
#endif /*__HARBOUR__*/
        local oHex  AS OBJECT
        local oBin  AS OBJECT
        #ifdef __ADVPL__
            PARAMETER cHexB AS CHARACTER
        #endif /*__ADVPL__*/
        oHex:=self:D2H(cHexB)
        oBin:=oHex:H2B()
        return(oBin)
/*method D2B*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:B2D
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:23/03/2013
        Descricao:Converte Bin para Dec
        Sintaxe:tBigNumber():B2D(cHexB) -> oDec
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method B2D(cHexB AS CHARACTER) class tBigNumber
#else /*__ADVPL__*/
    method B2D(cHexB) class tBigNumber
#endif /*__HARBOUR__*/
        local oHex  AS OBJECT
        local oDec  AS OBJECT
        #ifdef __ADVPL__
            PARAMETER cHexB AS CHARACTER
        #endif /*__ADVPL__*/
        oHex:=self:B2H(cHexB)
        oDec:=oHex:H2D()
        return(oDec)
/*method B2D*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Randomize
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:03/03/2013
        Descricao:Randomize BigN Integer
        Sintaxe:tBigNumber():Randomize(uB,uE) -> oR
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Randomize(uB,uE) class tBigNumber
#else /*__ADVPL__*/
    method Randomize(uB,uE) class tBigNumber
#endif /*__HARBOUR__*/

        local oB    AS OBJECT
        local oE    AS OBJECT
        local oT    AS OBJECT
        local oR    AS OBJECT

        local cN    AS CHARACTER
        local cR    AS CHARACTER
        local cT    AS CHARACTER

        DEFAULT uB:="1"
        DEFAULT uE:="99999999999999999999999999999999"

        oB:=s__o0:Clone()
        oB:SetValue(uB)

        oE:=s__o0:Clone()
        oE:SetValue(uE)

        oB:SetValue(oB:Int(.T.):Abs(.T.))
        oE:SetValue(oE:Int(.T.):Abs(.T.))

        oT:=s__o0:Clone()
        oT:SetValue(oB:Min(oE))

        oE:SetValue(oB:Max(oE))
        oB:SetValue(oT)

        oT:SetValue(oE:Sub(oB):Div(s__o2):Int(.T.):Abs(.T.))

        cR:=""
        cT:=oT:__cInt()
        #ifdef __HARBOUR__
            for each cN in cT
                cR+=hb_NToS(__Random(0,Val(cN:__enumValue())))
            next
        #else
            while (Len(cT)>0)
                cR+=hb_NToS(__Random(0,Val(SubStr(cT,1,1))))
                cT:=SubStr(cT,2)
            end while
        #endif

        oR:=s__o0:Clone()
        oR:SetValue(oR:Add(cR))

        oT:SetValue(oB)

        cR:=""
        cT:=oT:__cInt()
        #ifdef __HARBOUR__
            for each cN in cT
                cR+=hb_NToS(__Random(0,Val(cN:__enumValue())))
            next
        #else
            while (Len(cT)>0)
                cR+=hb_NToS(__Random(0,Val(SubStr(cT,1,1))))
                cT:=SubStr(cT,2)
            end while
        #endif

        oR:SetValue(oR:Add(cR))

        oT:SetValue(oE:Sub(oR):Int(.T.):Abs(.T.))

        cR:=""
        cT:=oT:__cInt()
        #ifdef __HARBOUR__
            for each cN in cT
                cR+=hb_NToS(__Random(0,Val(cN:__enumValue())))
            next
        #else
            while (Len(cT)>0)
                cR+=hb_NToS(__Random(0,Val(SubStr(cT,1,1))))
                cT:=SubStr(cT,2)
            end while
        #endif

        oR:SetValue(cR)

        while (oR:gt(oE))
            oT:SetValue(oR:Sub(oB):Div(s__o2):Int(.T.):Abs(.T.))
            oR:SetValue(oT)
        end while

        return(oR)

/*method Randomize*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:__Random
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:03/03/2013
        Descricao:Define a chamada para a funcao Random Padrao
        Sintaxe:__Random(nB,nE)
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    static function __Random(nB AS NUMERIC,nE AS NUMERIC)
#else /*__ADVPL__*/
    static function __Random(nB AS NUMERIC,nE AS NUMERIC) AS NUMERIC
#endif /*__HARBOUR__*/

        local nR AS NUMERIC

        if (nB==0)
            nB:=1
        endif

        if (nB==nE)
            ++nE
        elseif (nB>nE)
            nR:=nB
            nB:=nE
            nE:=nR
        endif

        #ifdef __HARBOUR__
            nR:=Abs(hb_RandomInt(nB,nE))
        #else /*__ADVPL__*/
            nR:=Randomize(nB,nE)
        #endif /*__HARBOUR__*/

#ifdef __HARBOUR__
        return(nR) AS NUMERIC
#else /*__ADVPL__*/
        return(nR)
#endif /*__HARBOUR__*/

/*static function __Random*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:millerRabin
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:03/03/2013
        Descricao:Miller-Rabin method (Primality test)
        Sintaxe:tBigNumber():millerRabin(uI) -> lPrime
        Ref.::http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method millerRabin(uI) class tBigNumber
#else /*__ADVPL__*/
    method millerRabin(uI) class tBigNumber
#endif /*__HARBOUR__*/

        local oN    AS OBJECT
        local oD    AS OBJECT
        local oS    AS OBJECT
        local oA    AS OBJECT
        local oI    AS OBJECT

        local lPrime    AS LOGICAL

        begin sequence

            oN:=self:Clone()
            if oN:lte(s__o1)
                lPrime:=.F.
                break
            endif

            oS:=s__o0:Clone()
            oD:=tBigNumber():New(oN:Sub(s__o1))
            while oD:Mod(s__o2):eq(s__o0)
                //-------------------------------------------------------------------------------------
                //(Div(2)==Mult(.5)
                oD:SetValue(oD:Mult(s__od2))
                oS:OpInc()
            end while

            DEFAULT uI:=s__o2:Clone()
            DEFAULT lPrime:=.T.

            oA:=s__o0:Clone()
            oI:=s__o0:Clone()
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

/*method millerRabin*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:mrPass
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:03/03/2013
        Descricao:Miller-Rabin Pass (Primality test)
        Sintaxe:mrPass(uA,uS,uD,uN)
        Ref.::http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
    */
//--------------------------------------------------------------------------------------------------------
static function mrPass(uA,uS,uD,uN)

    local oA    AS OBJECT
    local oS    AS OBJECT
    local oD    AS OBJECT
    local oN    AS OBJECT
    local oM    AS OBJECT

    local oP    AS OBJECT
    local oW    AS OBJECT

    local lmrP  AS LOGICAL

    begin sequence

        oN:=tBigNumber():New(uN)
        oD:=tBigNumber():New(uD)
        oA:=tBigNumber():New(uA)
        oP:=tBigNumber():New(oA:Pow(oD):Mod(oN))
        if oP:eq(s__o1)
            break
        endif

        oM:=tBigNumber():New(oN:Sub(s__o1))
        oS:=tBigNumber():New(uS)
        oW:=tBigNumber():New(oS:Sub(s__o1))
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

    DEFAULT lmrP:=.T.

    return(lmrP)

/*static function mrPass*/

//--------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method FI() class tBigNumber
#else /*__ADVPL__*/
    method FI() class tBigNumber
#endif /*__HARBOUR__*/

        local oC    AS OBJECT
        local oT    AS OBJECT
        local oI    AS OBJECT
        local oN    AS OBJECT

        oC:=self:Clone()
        oT:=tBigNumber():New(oC:Int(.T.))
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
/*method FI*/

#ifdef __ADVPL__
    static function TBIGNFI(n AS NUMERIC)
        local i     AS NUMERIC
        local fi    AS NUMERIC
        fi:=n
        i:=2
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
    /*static function TBIGNFI*/
#endif /*__ADVPL__*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:PFactors
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:19/03/2013
        Descricao:Fatores Primos
        Sintaxe:tBigNumber():PFactors() -> aPFactors
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method PFactors() class tBigNumber
#else /*__ADVPL__*/
    method PFactors() class tBigNumber
#endif /*__HARBOUR__*/

        local aPFactors AS ARRAY

        local cP        AS CHARACTER

        local oN        AS OBJECT
        local oP        AS OBJECT
        local oT        AS OBJECT

        local otP       AS OBJECT

        local nP        AS NUMERIC
        local nC        AS NUMERIC

        local lPrime    AS LOGICAL

        aPFactors:=Array(0)

        oT:=s__o0:Clone()
        oN:=self:Clone()
        oP:=s__o0:Clone()

        nC:=0

        lPrime:=.T.

        otP:=tPrime():New()
        otP:IsPReset()
        otP:NextPReset()

        cP:=""

        while otP:NextPrime(cP)
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

/*method PFactors*/

//--------------------------------------------------------------------------------------------------------
    /*
        method:Factorial
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:19/03/2013
        Descricao: Fatorial de Numeros Inteiros
        Sintaxe: tBigNumber():Factorial() -> oF
        TODO   : Otimizar++
        Referencias: http://www.luschny.de/math/factorial/FastFactorialfunctions.htm
                     http://www.luschny.de/math/factorial/index.html
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Factorial() class tBigNumber
#else /*__ADVPL__*/
    method Factorial() class tBigNumber
#endif /*__HARBOUR__*/
        local oN    AS OBJECT
        oN:=self:Clone():Int(.T.,.F.)
        if oN:eq(s__o0)
            return(s__o1:Clone())
        endif
        return(recFact(s__o1:Clone(),oN))
/*method Factorial*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:recFact
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/01/2014
        Descricao:Fatorial de Numeros Inteiros
        Sintaxe:recFact(oS,oN)
        Referencias:http://www.luschny.de/math/factorial/FastFactorialfunctions.htm
    */
//--------------------------------------------------------------------------------------------------------
static function recFact(oS AS OBJECT,oN AS OBJECT)

#ifdef __PTCOMPAT__
    local oSN   AS OBJECT
#endif //__PTCOMPAT__

    local oI    AS OBJECT

    local oR    AS OBJECT
    local oSI   AS OBJECT
    local oNI   AS OBJECT

#ifndef __PTCOMPAT__
    local nB    AS NUMERIC
    local nI    AS NUMERIC
    local nSN   AS NUMERIC
#endif //__PTCOMPAT__

    oR:=s__o0:Clone()

#ifdef __PTCOMPAT__
    //-------------------------------------------------------------------------------------
    //(Div(2)==Mult(.5)
    if oN:lte(s__o20:Mult(oN:Mult(s__od2):Int(.T.,.F.)))
#else
    if oN:lte(s__o20)
#endif
        oR:SetValue(oS)
        #ifdef __PTCOMPAT__
            oI:=oS:Clone()
            oSN:=oS:Clone()
            oSN:SetValue(oSN:iAdd(oN))
            oI:OpInc()
            while oI:lt(oSN)
                oR:SetValue(oR:iMult(oI))
                oI:OpInc()
            end while
        #else
            nB:=oS:__nBase()
            nI:=Val(oS:__cInt())
            nSN:=nI
            nSN+=Val(oN:__cInt())
            while ++nI<nSN
                oR:SetValue(tBigNiMult(oR:__cInt(),nI,nB))
            end while
        #endif //__PTCOMPAT__
        return(oR)
    endif

    oI:=oN:Clone()
    //-------------------------------------------------------------------------------------
    //(Div(2)==Mult(.5)
    oI:SetValue(oI:Mult(s__od2):Int(.T.,.F.))

    oSI:=oS:Clone()
    oSI:SetValue(oSI:iAdd(oI))

    oNI:=oN:Clone()
    oNI:SetValue(oNI:iSub(oI))

    return(recFact(oS,oI):iMult(recFact(oSI,oNI)))

/*static function recFact*/

//--------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    method Fibonacci() class tBigNumber
#else /*__ADVPL__*/
    method Fibonacci() class tBigNumber
#endif /*__HARBOUR__*/
        local aFibonacci    AS ARRAY
        local oN            AS OBJECT
        local oA            AS OBJECT
        local oB            AS OBJECT
        local oT            AS OBJECT
        aFibonacci:=Array(0)
        oB:=tBigNumber():New("1")
        oN:=self:Clone()
        oA:=tBigNumber():New("0")
        #ifdef __HARBOUR__
            While (oA<oN)
                aAdd(aFibonacci,oA:ExactValue())
                oT:=oB:Clone()
                oB:=oA+oB
                oA:=oT
           End While
        #else //__PROTEUS__
            oT:=tBigNumber():New("0")
            While (oA:lt(oN))
                aAdd(aFibonacci,oA:ExactValue())
                oT:SetValue(oB)
                oB:SetValue(oA:Add(oB))
                oA:SetValue(oT)
            End While
        #endif
        return(aFibonacci)
/*method Fibonacci*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:egMult
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Multiplicacao Egipcia (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
        Sintaxe:egMult(cN1,cN2,nBase,nAcc) -> oMTP
        Obs.:Interessante+lenta... Utiliza Soma e Subtracao para obter o resultado
    */
//--------------------------------------------------------------------------------------------------------
static function egMult(cN1 AS CHARACTER,cN2 AS CHARACTER,nBase AS NUMERIC)

#ifdef __PTCOMPAT__

    local aeMT  AS ARRAY

    local nI    AS NUMERIC
    local nCmp  AS NUMERIC

    local oN1   AS OBJECT
    local oMTM  AS OBJECT
    local oMTP  AS OBJECT

    aeMT:=Array(0)

    nI:=0

    oMTP:=tBigNumber():New(cN2,nBase)
    oMTM:=s__o1:Clone()
    oN1:=tBigNumber():New(cN1,nBase)

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

    local oMTP  AS OBJECT
    oMTP:=s__o0:Clone()
    oMTP:__cInt(TBIGNegMult(cN1,cN2,hb_bLen(cN1),nBase))

#endif //__PTCOMPAT__

    return(oMTP)

/*static function egMult*/

//--------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------
static function rMult(cA AS CHARACTER,cB AS CHARACTER,nBase AS NUMERIC)

    local oa    AS OBJECT
    local ob    AS OBJECT
    local oR    AS OBJECT

    oR:=s__o0:Clone()
    ob:=tBigNumber():New(cB,nBase)
    oa:=tBigNumber():New(cA,nBase)

    while oa:ne(s__o0)
        if oa:Mod(s__o2):gt(s__o0)
            oR:__cInt(oR:Add(ob):__cInt())
            oa:OpDec()
        endif
        oa:__cInt(oa:Mult(s__oD2):__cInt())
        ob:__cInt(ob:Mult(s__o2):__cInt())
    end while

    return(oR)

/*static function rMult*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:egDiv
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Divisao Egipcia (http://cognosco.blogs.sapo.pt/13236.html)
        Sintaxe:egDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> oeDivQ
    */
//--------------------------------------------------------------------------------------------------------
static function egDiv(cN AS CHARACTER,cD AS CHARACTER,nSize AS NUMERIC,nBase AS NUMERIC,nAcc AS NUMERIC,lFloat AS LOGICAL)

#ifdef __PTCOMPAT__
    local aeDV      AS ARRAY
    local nI        AS NUMERIC
    local nCmp      AS NUMERIC
    local oeDivN    AS OBJECT
#endif //__PTCOMPAT__

    local cRDiv     AS OBJECT
    local oeDivR    AS OBJECT
    local oeDivQ    AS OBJECT

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

    aeDV:=Array(0)

    nI:=0

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

#else /*__HARBOUR__*/

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

/*static function egDiv*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:ecDiv
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:18/03/2014
        Descricao:Divisao Euclidiana (http://compoasso.free.fr/primelistweb/page/prime/euclide_en.php)
        Sintaxe:ecDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> q
    */
//--------------------------------------------------------------------------------------------------------
static function ecDiv(pA AS CHARACTER,pB AS CHARACTER,nSize AS NUMERIC,nBase AS NUMERIC,nAcc AS NUMERIC,lFloat AS LOGICAL)

#ifdef __PTCOMPAT__

   local a  AS OBJECT
   local b  AS OBJECT

#endif

   local r AS OBJECT
   local q  AS OBJECT

#ifdef __PTCOMPAT__

   local n      AS OBJECT
   local aux    AS OBJECT
   local tmp    AS OBJECT
   local base   AS OBJECT

#endif

   local cRDiv

#ifndef __PTCOMPAT__
    local cQDiv
#endif //__PTCOMPAT__

#ifdef __PTCOMPAT__

   SYMBOL_UNUSED(nSize)

   tmp:=s__o0:Clone()
   base:=tBigNumber():New(hb_ntos(nBase),nBase)

   q:=s__o0:Clone()

   aux:=s__o0:Clone()
   n:=s__o1:Clone()

   a:=tBigNumber():New(pA,nBase)
   r:=a:Clone()

   b:=tBigNumber():New(pB,nBase)

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

    q:=s__o0:Clone()
    q:__cInt(cQDiv)

    r:=s__o0:Clone()
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

/*static function ecDiv*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:nthRoot
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:10/02/2013
        Descricao:Metodo Newton-Raphson
        Sintaxe:nthRoot(oRootB,oRootE,oAcc) -> othRoot
    */
//--------------------------------------------------------------------------------------------------------
static function nthRoot(oRootB AS OBJECT,oRootE AS OBJECT,oAcc AS OBJECT)
    return(__Pow(oRootB,s__o1:Div(oRootE),oAcc))
/*static function nthRoot*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:__Pow
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:10/02/2013
        Descricao:Metodo Newton-Raphson
        Sintaxe:__Pow(base,exp,EPS) -> oPow
        Ref.:http://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function
            :http://stackoverflow.com/questions/2882706/how-can-i-write-a-power-function-myself
    */
//--------------------------------------------------------------------------------------------------------
static function __Pow(base AS OBJECT,expR AS OBJECT,EPS AS OBJECT)

    local acc   AS OBJECT
    local sqr   AS OBJECT
    local tmp   AS OBJECT

    local low   AS OBJECT
    local mid   AS OBJECT
    local lst   AS OBJECT
    local high  AS OBJECT

    local lDo   AS LOGICAL

    local exp   AS OBJECT

    exp:=expR:Clone()
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

/*static function __Pow*/

//--------------------------------------------------------------------------------------------------------
    /*
        function:__SQRT
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:10/02/2013
        Descricao:SQRT
        Sintaxe:__SQRT(p) -> oSQRT
    */
//--------------------------------------------------------------------------------------------------------
static function __SQRT(p)
    local l     AS OBJECT
    local r     AS OBJECT
    local t     AS OBJECT
    local s     AS OBJECT
    local n     AS OBJECT
    local x     AS OBJECT
    local y     AS OBJECT
    local EPS   AS OBJECT
    local q     AS OBJECT
    q:=tBigNumber():New(p)
    if q:lte(q:SysSQRT())
        #ifdef __PROTEUS__
            r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
        #else /*__HARBOUR__*/
            #ifdef __PTCOMPAT__
                r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
            #else
                r:=tBigNumber():New(TBIGNSQRT(q:GetValue()))
            #endif //__PTCOMPAT__
        #endif //__PROTEUS__
    else
        n:=s__nthRAcc-1
        s__IncS0(n)
        s:="0."+Left(s__cN0,n)+"1"
        EPS:=s__o0:Clone()
        EPS:SetValue(s,NIL,NIL,NIL,s__nthRAcc)
        #ifdef __PROTEUS__
            r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
        #else /*__HARBOUR__*/
            #ifdef __PTCOMPAT__
                r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
            #else
                r:=tBigNumber():New(TBIGNSQRT(q:GetValue()))
            #endif //__PTCOMPAT__
        #endif //__PROTEUS__
#ifdef __PROTEUS__
        if r:eq(s__o0).or."*"$r:GetValue()
#else /*__HARBOUR__*/
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
        while t:gte(EPS)
            x:=r:pow(s__o2)
            y:=s__o2:Mult(r)
            r:SetValue(x:Add(q):Div(y))
            t:SetValue(r:Pow(s__o2):Sub(q):Abs(.T.))
            if t:eq(l)
                exit
            endif
            l:SetValue(t)
        end while
    endif
    return(r)

/*static function __SQRT*/

#ifdef TBN_DBFILE

    //--------------------------------------------------------------------------------------------------------
        /*
            function:Add
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Adicao
            Sintaxe:Add(a,b,n,nBase) -> cNR
        */
    //--------------------------------------------------------------------------------------------------------
    static function Add(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS CHARACTER)

        local c AS CHARACTER

        local y AS NUMERIC
        local k AS NUMERIC

        local s AS CHARACTER

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        y:=n+1

        s__IncS0(y)

        k:=y

        c:=aNumber(Left(s__cN0,y),y,"ADD_C")

        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __ADVPL__
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
        s:=""
        (c)->(dbEval({||s+=hb_ntos(FN)}))

        return(s)

    /*static function Add*/

    //--------------------------------------------------------------------------------------------------------
        /*
            function:Sub
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Subtracao
            Sintaxe:Sub(a,b,n,nBase) -> cNR
        */
    //--------------------------------------------------------------------------------------------------------
    static function Sub(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

        local c AS CHARACTER

        local y AS NUMERIC
        local k AS NUMERIC

        local s AS CHARACTER

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        y:=n

        s__IncS0(y)

        c:=aNumber(Left(s__cN0,y),y,"SUB_C")

        k:=y

        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __ADVPL__
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
        s:=""
        (c)->(dbEval({||s+=hb_ntos(FN)}))

        return(s)

    /*static function Sub*/

    //--------------------------------------------------------------------------------------------------------
        /*
            function:Mult
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Multiplicacao de Inteiros
            Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
            Obs.:Mais rapida,usa a multiplicacao nativa
        */
    //--------------------------------------------------------------------------------------------------------
    static function Mult(cN1 AS CHARACTER,cN2 AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

        local c AS CHARACTER

        local a AS ARRAY
        local b AS ARRAY
        local y AS NUMERIC

        local i AS NUMERIC
        local k AS NUMERIC
        local l AS NUMERIC

        local s AS NUMERIC
        local x AS NUMERIC
        local j AS NUMERIC
        local w AS NUMERIC

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        y:=n+n

        s__IncS0(y)

        c:=aNumber(Left(s__cN0,y),y,"MULT_C")

        a:=tBigNInvert(cN1,n)
        b:=tBigNInvert(cN2,n)

        k:=1
        l:=2

        i:=1

        while i<=n
            s:=1
            j:=i
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                while s<=i
                    #ifdef __ADVPL__
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
                #ifdef __ADVPL__
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

    /*static function Mult*/

    //--------------------------------------------------------------------------------------------------------
        /*
            function:aNumber
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:db OF Numbers
            Sintaxe:aNumber(c,n,o) -> a
        */
    //--------------------------------------------------------------------------------------------------------
    static function aNumber(c AS CHARACTER,n AS NUMERIC,o AS CHARACTER)

        local a AS CHARACTER

        local y AS NUMERIC

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        a:=dbNumber(o)
        y:=0
        while ++y<=n
            (a)->(dbAppend(.T.))
        #ifdef __ADVPL__
            (a)->FN:=Val(SubStr(c,y,1))
        #else
            (a)->FN:=Val(c[y])
        #endif
            (a)->(dbUnLock())
        end while

        return(a)

    /*static function aNumber*/

    //--------------------------------------------------------------------------------------------------------
        /*
            function:dbGetcN
            Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data:04/02/2013
            Descricao:Montar a String de Retorno
            Sintaxe:dbGetcN(a,x) -> s
        */
    //--------------------------------------------------------------------------------------------------------
    static function dbGetcN(a AS CHARACTER,n AS NUMERIC)

        local s AS CHARACTER

        local y AS NUMERIC

        #ifdef __HARBOUR__
            FIELD FN
        #endif

        s:=""
        y:=n

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

    /*static function dbGetcN*/

    static function dbNumber(cAlias AS CHARACTER)
        local aStru     AS ARRAY
        local cFile     AS CHARACTER
    #ifndef __HARBOUR__
        local cRDD      AS CHARACTER
        local cLDriver  AS CHARACTER
    #else
        #ifndef TBN_MEMIO
            local cRDD  AS CHARACTER
        #endif
    #endif
    #ifndef __HARBOUR__
        cRDD:=if((Type("__localDriver")=="C"),__localDriver,"DBFCDXADS")
        if .not.(Type("__localDriver")=="C")
            private __localDriver
        endif
        cLDriver:=__localDriver
        __localDriver:=cRDD
    #endif
        if Select(cAlias)==0
            aStru:={{"FN","N",18,0}}
    #ifndef __HARBOUR__
            cFile:=CriaTrab(aStru,.T.,GetdbExtension())
            if .not.(GetdbExtension()$cFile)
                cFile+=GetdbExtension()
            endif
            dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
    #else
            #ifndef TBN_MEMIO
                cRDD:="DBFCDX"
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
    /*static function dbNumber*/

    #ifdef __HARBOUR__
        #ifndef TBN_MEMIO
            static function CriaTrab(aStru AS ARRAY,cRDD AS CHARACTER)
                local cFolder   AS CHARACTER
                local cFile     AS CHARACTER
                local lSuccess  AS LOGICAL
                cFolder:=tbNCurrentFolder()+hb_ps()+"tbigN_tmp"+hb_ps()
                cFile:=cFolder+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                lSuccess:=.F.
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
            /*static function CriaTrab*/
        #else
            static function CriaTrab(aStru AS ARRAY,cAlias AS CHARACTER)
                local cFile     AS CHARACTER
                local lSuccess  AS LOGICAL
                cFile:="mem:"+"tBN_"+Dtos(Date())+"_"+hb_ntos(hb_threadID())+"_"+StrTran(Time(),":","_")+"_"+StrZero(hb_RandomInt(1,9999),4)+".dbf"
                lSuccess:=.F.
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
            /*static function CriaTrab*/
        #endif
    #endif

#else

    #ifdef TBN_ARRAY

        //--------------------------------------------------------------------------------------------------------
            /*
                function:Add
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Adicao
                Sintaxe:Add(a,b,n,nBase) -> cNR
            */
        //--------------------------------------------------------------------------------------------------------
        static function Add(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

            local c AS ARRAY

            local s AS CHARACTER

            local k AS NUMERIC
            local y AS NUMERIC

            y:=n+1
            k:=y
            c:=aFill(aSize(ths_aZAdd,y),0)

            while n>0
            #ifdef __ADVPL__
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

            s:=""

            #ifdef __ADVPL__
                aEval(c,{|v|s+=hb_ntos(v)})
            #else /*__HARBOUR__*/
                aEval(c,{|v AS NUMERIC|s+=hb_ntos(v)})
            #endif

            return(s)

        /*static function Add*/

        //--------------------------------------------------------------------------------------------------------
            /*
                function:Sub
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Subtracao
                Sintaxe:Sub(a,b,n,nBase) -> cNR
            */
        //--------------------------------------------------------------------------------------------------------
        static function Sub(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

            local c AS ARRAY

            local s AS CHARACTER

            local k AS NUMERIC
            local y AS NUMERIC

            y:=n
            k:=y
            c:=aFill(aSize(ths_aZSub,y),0)

            while n>0
            #ifdef __ADVPL__
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

            s:=""

            #ifdef __ADVPL__
                aEval(c,{|v|s+=hb_ntos(v)})
            #else /*__HARBOUR__*/
                aEval(c,{|v AS NUMERIC|s+=hb_ntos(v)})
            #endif

            return(s)

        /*static function Sub*/

        //--------------------------------------------------------------------------------------------------------
            /*
                function:Mult
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Multiplicacao de Inteiros
                Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
                Obs.:Mais rapida,usa a multiplicacao nativa
            */
        //--------------------------------------------------------------------------------------------------------
        static function Mult(cN1 AS CHARACTER,cN2 AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

            local c AS ARRAY

            local a AS CHARACTER
            local b AS CHARACTER

            local y AS NUMERIC

            local i AS NUMERIC
            local k AS NUMERIC
            local l AS NUMERIC

            local s AS NUMERIC
            local x AS NUMERIC
            local j AS NUMERIC

            a:=tBigNInvert(cN1,n)
            b:=tBigNInvert(cN2,n)

            y:=n+n
            c:=aFill(aSize(ths_aZMult,y),0)

            k:=1
            l:=2

            i:=1

            while i<=n
                s:=1
                j:=i
                while s<=i
                #ifdef __ADVPL__
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
                #ifdef __ADVPL__
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

        /*static function Mult*/

        //--------------------------------------------------------------------------------------------------------
            /*
                function:aGetcN
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Montar a String de Retorno
                Sintaxe:aGetcN(a,x) -> s
            */
        //--------------------------------------------------------------------------------------------------------
        static function aGetcN(a AS ARRAY,n AS NUMERIC)

            local s AS CHARACTER

            local y AS NUMERIC

            s:=""
            y:=n

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

        /*static function aGetcN*/

    #else /*String*/

        //--------------------------------------------------------------------------------------------------------
            /*
                function:Add
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Adicao
                Sintaxe:Add(a,b,n,nBase) -> cNR
            */
        //--------------------------------------------------------------------------------------------------------
        #ifdef __PTCOMPAT__
            static function Add(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

                local c     AS CHARACTER

                local y     AS NUMERIC
                local k     AS NUMERIC

                local v     AS NUMERIC
                local v1    AS NUMERIC

                y:=n+1

                s__IncS0(y)

                c:=Left(s__cN0,y)

                k:=y

                v:=0

                while n>0
                    #ifdef __ADVPL__
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
                    #ifdef __ADVPL__
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

            /*static function Add*/

        #else /*__HARBOUR__*/
            static function Add(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nB AS NUMERIC)
                return(tBIGNADD(a,b,n,n,nB))
            /*static function Add*/
        #endif //__PTCOMPAT__

        //--------------------------------------------------------------------------------------------------------
            /*
                function:Sub
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Subtracao
                Sintaxe:Sub(a,b,n,nBase) -> cNR
            */
        //--------------------------------------------------------------------------------------------------------
        #ifdef __PTCOMPAT__
            static function Sub(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

                local c     AS CHARACTER

                local y     AS NUMERIC
                local k     AS NUMERIC

                local v     AS NUMERIC
                local v1    AS NUMERIC

                y:=n

                s__IncS0(y)

                c:=Left(s__cN0,y)

                k:=y

                v:=0

                while n>0
                    #ifdef __ADVPL__
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
                    #ifdef __ADVPL__
                        c:=Stuff(c,k,1,hb_ntos(v))
                    #else
                        c[k]:=hb_ntos(v)
                    #endif
                    v:=v1
                    --k
                    --n
                end while

                return(c)

            /*static function Sub*/

        #else /*__HARBOUR__*/
            static function Sub(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nB AS NUMERIC)
                    return(tBIGNSUB(a,b,n,nB))
            /*static function Sub*/
        #endif //__PTCOMPAT__
        //--------------------------------------------------------------------------------------------------------
            /*
                function:Mult
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Multiplicacao de Inteiros
                Sintaxe:Mult(cN1,cN2,n,nBase) -> cNR
                Obs.:Mais rapida, usa a multiplicacao nativa
            */
        //--------------------------------------------------------------------------------------------------------
        #ifdef __PTCOMPAT__
            static function Mult(cN1 AS CHARACTER,cN2 AS CHARACTER,n AS NUMERIC,nBase AS NUMERIC)

                local c     AS CHARACTER

                local a     AS CHARACTER
                local b     AS CHARACTER

                local y     AS NUMERIC

                local i     AS NUMERIC
                local k     AS NUMERIC
                local l     AS NUMERIC

                local s     AS NUMERIC
                local j     AS NUMERIC

                local v     AS NUMERIC
                local v1    AS NUMERIC

                a:=tBigNInvert(cN1,n)
                b:=tBigNInvert(cN2,n)

                k:=1
                l:=2

                v:=0

                y:=n+n

                s__IncS0(y)

                c:=Left(s__cN0,y)

                i:=1

                while i<=n
                    s:=1
                    j:=i
                    while s<=i
                    #ifdef __ADVPL__
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
                    #ifdef __ADVPL__
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
                    #ifdef __ADVPL__
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
                    #ifdef __ADVPL__
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

            /*static function Mult*/

        #else /*__HARBOUR__*/
            static function Mult(a AS CHARACTER,b AS CHARACTER,n AS NUMERIC,nB AS NUMERIC)
                local cN    AS CHARACTER
                local y     AS NUMERIC
                y:=n
                cN:=tBIGNMULT(a,b,n,y,nB)
                return(cN)
            /*static function Mult*/
        #endif //__PTCOMPAT__

        //--------------------------------------------------------------------------------------------------------
            /*
                function:cGetcN
                Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
                Data:04/02/2013
                Descricao:Montar a String de Retorno
                Sintaxe:cGetcN(c,n) -> s
            */
        //--------------------------------------------------------------------------------------------------------
        #ifdef __PTCOMPAT__
            static function cGetcN(c AS CHARACTER,n AS NUMERIC)

                local s AS CHARACTER
                local y AS NUMERIC

                s:=""
                y:=n

                while y>=1
                #ifdef __ADVPL__
                    while y>=1.and.SubStr(c,y,1)=="0"
                #else
                    while y>=1.and.c[y]=="0"
                #endif
                        y--
                    end while
                    while y>=1
                    #ifdef __ADVPL__
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

            /*static function cGetcN*/

        #endif //__PTCOMPAT__

    #endif /*String*/

#endif

#ifndef __PTCOMPAT__
    static function thAdd(oN AS OBJECT,oP AS OBJECT)
        return(oN:Add(oP))
    /*static function thAdd*/
    static function thDiv(oN AS OBJECT,oD AS OBJECT,lFloat AS LOGICAL)
        return(oN:Div(oD,lFloat))
    /*static function thDiv*/
    static function thMod0(oN AS OBJECT,oD AS OBJECT)
        return(oN:Mod(oD):eq(s__o0))
    /*static function thMod0*/
    static function thnthRoot(oN AS OBJECT,oE AS OBJECT)
        return(oN:nthRoot(oE))
    /*static function thnthRoot*/
    static function thMult(oN AS OBJECT,oM AS OBJECT)
        return(oN:Mult(oM))
    /*static function thMult*/
    static function thPow(oN AS OBJECT,oB AS OBJECT)
        return(oN:Pow(oB))
    /*static function thPow*/
    static function th2Mult(oN AS OBJECT)
        return(s__o2:Mult(oN))
    /*static function th2Mult*/
    static function thiMult(oN AS OBJECT,oM AS OBJECT)
        return(oN:iMult(oM))
    /*static function thiMult*/
    static function thLogN(oN AS OBJECT,oB AS OBJECT)
        return(oN:LogN(oB))
    /*static function thLogN*/
#endif //__PTCOMPAT__

//--------------------------------------------------------------------------------------------------------
    /*
        function:Power
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:26/08/2014
        Descricao:Exponenciação de Números Inteiros
        Sintaxe:Power(oB,oE,lIPower)
    */
//--------------------------------------------------------------------------------------------------------
static function Power(oB AS OBJECT,oE AS OBJECT,lIPower AS LOGICAL)
#ifdef TBIGN_RECPOWER
    /*
        TODO:   This application has requested the Runtime to terminate it in an unusual way
                Please contact the application's support team for more information.
    */
    return(recPower(oB AS OBJECT,oE AS OBJECT,lIPower AS LOGICAL))
    //--------------------------------------------------------------------------------------------------------
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
    //--------------------------------------------------------------------------------------------------------
    static function recPower(oB AS OBJECT,oE AS OBJECT,lIPower AS LOGICAL)

        #ifdef __HARBOUR__
            local cR    AS CHARACTER
        #endif /*__HARBOUR__*/
        
        local oR    AS OBJECT

        local oI    AS OBJECT
        local oE1   AS OBJECT
        local oE2   AS OBJECT

        oR:=oB:Clone()

        if oE:lte(s__o2)
            #ifdef __PTCOMPAT__
                SYMBOL_UNUSED(lIPower)
                oI:=oE:Clone()
                while oI:gt(s__o1)
                    oR:SetValue(oR:Mult(oB))
                    oI:OpDec()
                end while
            #else /*__HARBOUR__*/
                if (lIPower)
                    #ifdef TBN_DBFILE
                        lIPower:=.F.
                    #else
                        #ifdef TBN_ARRAY
                            lIPower:=.F.
                        #endif
                    #endif
                endif
                if .not.(lIPower)
                    oI:=oE:Clone()
                    while oI:gt(s__o1)
                        oR:SetValue(oR:Mult(oB))
                        oI:OpDec()
                    end while
                else
                    oB:Normalize(@oE)
                    cR:=TBIGNPOWER(oB:__cInt(),oE:__cInt(),oB:__nInt(),oE:__nInt(),oB:__nBase())
                    oR:SetValue(cR)
                endif
            #endif //__PTCOMPAT__
            return(oR)
        endif

        oE1:=oE:Clone()
        oE2:=oE:Clone()

        //-------------------------------------------------------------------------------------
        //(Div(2)==Mult(.5)
        oE1:SetValue(oE1:Mult(s__od2):Int(.T.,.F.))
        oE2:SetValue(oE2:Sub(oE1))

        return(recPower(oB,oE1,lIPower):Mult(recPower(oB,oE2,lIPower)))

    /*static function recPower*/

#else

    #ifdef __HARBOUR__
        local cR    AS CHARACTER
    #endif /*__HARBOUR__*/
    
    local oR    AS OBJECT
    local oI    AS OBJECT

    oR:=oB:Clone()
    oI:=oE:Clone()

    #ifdef __PTCOMPAT__
        SYMBOL_UNUSED(lIPower)
        while oI:gt(s__o1)
            oR:SetValue(oR:Mult(oB))
            oI:OpDec()
        end while
    #else /*__HARBOUR__*/
        if (lIPower)
            #ifdef TBN_DBFILE
                lIPower:=.F.
            #else
                #ifdef TBN_ARRAY
                    lIPower:=.F.
                #endif
            #endif
        endif
        if .not.(lIPower)
            while oI:gt(s__o1)
                oR:SetValue(oR:Mult(oB))
                oI:OpDec()
            end while
        else
            oB:Normalize(@oE)
            cR:=TBIGNPOWER(oB:__cInt(),oE:__cInt(),oB:__nInt(),oE:__nInt(),oB:__nBase())
            oR:SetValue(cR)
        endif
    #endif //__PTCOMPAT__

    return(oR)

/*static function recPower*/

#endif

//--------------------------------------------------------------------------------------------------------
    /*
        function:tBigNInvert
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Inverte o Numero
        Sintaxe:tBigNInvert(c,n) -> s
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __PTCOMPAT__
    static function tBigNInvert(c AS CHARACTER,n AS NUMERIC)

        local s AS CHARACTER
        local y AS NUMERIC

        s:=""
        y:=n
        while y>0
        #ifdef __ADVPL__
            s+=SubStr(c,y--,1)
        #else
            s+=c[y--]
        #endif
        end while

        return(s)

    /*static function tBigNInvert*/

#else /*__HARBOUR__*/
    static function tBigNInvert(c AS CHARACTER,n AS NUMERIC)
        return(tBigNReverse(c,n))
    /*static function tBigNInvert*/
#endif //__PTCOMPAT__

//--------------------------------------------------------------------------------------------------------
    /*
        function:MathO
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:04/02/2013
        Descricao:Operacoes matematicas
        Sintaxe:MathO(uBigN1,cOperator,uBigN2,lRetObject)
    */
//--------------------------------------------------------------------------------------------------------
static function MathO(uBigN1,cOperator AS CHARACTER,uBigN2,lRetObject AS LOGICAL)

    local bAsc      AS BLOCK

    local oBigNR    AS OBJECT

    local oBigN1    AS OBJECT
    local oBigN2    AS OBJECT

    oBigNR:=s__o0:Clone()

    oBigN1:=tBigNumber():New(uBigN1)
    oBigN2:=tBigNumber():New(uBigN2)

    #ifdef __PROTEUS__
        bAsc:={|cOp|cOperator==cOp}
    #else /*__HARBOUR__*/
        bAsc:={|cOp AS CHARACTER|cOperator==cOp}
    #endif

    do case
        case (aScan(OPERATOR_ADD,bAsc)>0)
            oBigNR:SetValue(oBigN1:Add(oBigN2))
        case (aScan(OPERATOR_SUBTRACT,bAsc)>0)
            oBigNR:SetValue(oBigN1:Sub(oBigN2))
        case (aScan(OPERATOR_MULTIPLY,bAsc)>0)
            oBigNR:SetValue(oBigN1:Mult(oBigN2))
        case (aScan(OPERATOR_DIVIDE,bAsc)>0)
            oBigNR:SetValue(oBigN1:Div(oBigN2))
        case (aScan(OPERATOR_POW,bAsc)>0)
            oBigNR:SetValue(oBigN1:Pow(oBigN2))
        case (aScan(OPERATOR_MOD,bAsc)>0)
            oBigNR:SetValue(oBigN1:Mod(oBigN2))
        case (aScan(OPERATOR_ROOT,bAsc)>0)
            oBigNR:SetValue(oBigN1:nthRoot(oBigN2))
        case (aScan(OPERATOR_SQRT,bAsc)>0)
            oBigNR:SetValue(oBigN1:SQRT())
    endcase

    DEFAULT lRetObject:=.T.

    return(if(lRetObject,oBigNR,oBigNR:ExactValue()))

/*static function MathO*/

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
    /*static procedure __Initsthd*/
#endif //__THREAD_STATIC__

// -------------------- assign static values --------------------------------
static procedure __InitstbN(nBase AS NUMERIC)
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
    s__o10:=tBigNumber():New("10",nBase)
    s__o20:=tBigNumber():New("20",nBase)
    s__od2:=tBigNumber():New("0.5",nBase)
    s__oMinFI:=tBigNumber():New(MAX_SYS_FI,nBase)
    s__oMinGCD:=tBigNumber():New(MAX_SYS_GCD,nBase)
    s__nMinLCM:=Int(hb_bLen(MAX_SYS_LCM)/2)
    s__SysSQRT:=tBigNumber():New("0",nBase)
    s__lstbNSet:=.T.
    s_aH2B:={;
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
    return
/*static procedure __InitstbN*/

static procedure s__IncS0(n AS NUMERIC)
    while n>s__nN0
        if hb_mutexLock(s__MTXcN0)
            s__cN0+=s__cN0
            s__nN0+=s__nN0
            hb_mutexUnLock(s__MTXcN0)
        endif
    end while
    return
/*static procedure s__IncS0*/

static procedure s__IncS9(n AS NUMERIC)
    while n>s__nN9
        if hb_mutexLock(s__MTXcN9)
            s__cN9+=s__cN9
            s__nN9+=s__nN9
            hb_mutexUnLock(s__MTXcN9)
        endif
    end while
    return
/*static procedure s__IncS9*/

#ifdef __ADVPL__

    static function __eTthD()
        return(staticCall(__pteTthD,__eTthD))
    /*static function __eTthD*/
    static function __PITthD()
        return(staticCall(__ptPITthD,__PITthD))
    /*static function __PITthD*/

    /*warning W0010 Static Function ...() never called*/
    static function __Dummy(lDummy AS LOGICAL)
        DEFAULT lDummy:=.F.
        lDummy:=if(lDummy,(.not.(lDummy)),.F.)
        if (lDummy)
            __Dummy(@lDummy)
            s__IncS9()
        endif
        return(lDummy)


#else /*__HARBOUR__*/

    static function __eTthD()
        return(__hbeTthD())
    /*return(__hbeTthD())*/
    static function __PITthD()
        return(__hbPITthD())
    /*static function __PITthD*/

    /* warning: 'void hb_FUN_...()'  defined but not used [-Wunused-function]...*/
    static function __Dummy(lDummy AS LOGICAL)
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
            S__INCS9()
            TBIGNPOWER()
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
    /*static function __Dummy*/

#endif /*__ADVPL__*/

#ifdef __HARBOUR__
    #include "..\src\hb\c\tbigNumber.c"
#endif // __HARBOUR__
