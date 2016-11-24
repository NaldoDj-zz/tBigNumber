#ifdef PROTHEUS
    #define __PROTHEUS__
    #include "protheus.ch"
#else
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif
#endif
#include "tBigNumber.ch"
/*
    Class       : tSProgress
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 29/12/2013
    Descricao   : Instancia um novo objeto do tipo tSProgress
    Sintaxe     : tSProgress():New(cProgress,cToken) -> self
*/
Class tSProgress

#IFNDEF __PROTHEUS__
    PROTECTED:
#endif

    DATA aMethods   AS ARRAY INIT Array(0) HIDDEN
    DATA aProgress  AS ARRAY INIT Array(0) HIDDEN

    DATA lRandom    AS LOGICAL INIT .F.    HIDDEN

    DATA nMax       AS NUMERIC INIT 0      HIDDEN
    DATA nMethod    AS NUMERIC INIT 0      HIDDEN
    DATA nMethods   AS NUMERIC INIT 0      HIDDEN
    DATA nProgress  AS NUMERIC INIT 0      HIDDEN

    DATA lShuttle   AS LOGICAL INIT .F.    HIDDEN

#IFNDEF __PROTHEUS__
    EXPORTED:
#endif

    Method New(cProgress AS CHARACTER,cToken AS CHARACTER)  CONSTRUCTOR

    Method ClassName()

    Method SetProgress(cProgress AS CHARACTER,cToken AS CHARACTER)

    Method Eval(cMethod AS CHARACTER,cAlign AS CHARACTER)
    Method Progress()
    Method Increment(cAlign AS CHARACTER)
    Method Decrement(cAlign AS CHARACTER)
    Method Shuttle(cAlign AS CHARACTER)
    Method Junction(cAlign AS CHARACTER)
    Method Dispersion(cAlign AS CHARACTER)
    Method Disjunction(cAlign AS CHARACTER)
    Method Union(cAlign AS CHARACTER)
    Method Occult(cAlign AS CHARACTER)
    Method Random(cAlign AS CHARACTER)

    Method GetnMax()
    Method GetnProgress()

    Method SetRandom(lSet AS LOGICAL)

EndClass

#ifdef __PROTHEUS__
    Function u_tSProgress(cProgress AS CHARACTER,cToken AS CHARACTER)
        Return(tSProgress():New(@cProgress,@cToken))
    /*Function u_tSProgress*/
#endif

Method New(cProgress AS CHARACTER,cToken AS CHARACTER) Class tSProgress
    self:SetProgress(@cProgress,@cToken)
    Return(self)
/*Method New*/

Method ClassName() Class tSProgress
    Return("TSPROGRESS")
/*Method ClassName*/

Method SetProgress(cProgress AS CHARACTER,cToken AS CHARACTER) Class tSProgress
    Local lMacro    AS LOGICAL
    DEFAULT cProgress:="-;\;|;/"
    DEFAULT cToken:=";"
    lMacro:=(SubStr(cProgress,1,1)=="&")
    IF (lMacro)
        cProgress:=SubStr(cProgress,2)
        cProgress:=&(cProgress)
    EndIF
    IF Empty(self:aMethods)
        DEFAULT self:aMethods:=Array(0)
        aAdd(self:aMethods,"PROGRESS")
        aAdd(self:aMethods,"INCREMENT")
        aAdd(self:aMethods,"DECREMENT")
        aAdd(self:aMethods,"SHUTTLE")
        aAdd(self:aMethods,"JUNCTION")
        aAdd(self:aMethods,"DISPERSION")
        aAdd(self:aMethods,"DISJUNCTION")
        aAdd(self:aMethods,"UNION")
        aAdd(self:aMethods,"OCCULT")
        aAdd(self:aMethods,"RANDOM")
        self:nMethods:=Len(self:aMethods)
    EndIF
    self:aProgress:=_StrToKArr(@cProgress,@cToken)
    self:lRandom:=.F.
    self:lShuttle:=.NOT.(self:lShuttle)
    self:nMethod:=0
    self:nMax:=Len(self:aProgress)
    self:nProgress:=0
    Return(self)
/*Method SetProgress*/

Method Eval(cMethod AS CHARACTER,cAlign AS CHARACTER) Class tSProgress
    Local cEval     AS CHARACTER
    Local nMethod   AS NUMERIC
    DEFAULT cMethod:="PROGRESS"
    cMethod:=Upper(AllTrim(cMethod))
    nMethod:=Max(aScan(self:aMethods,{|m|m==cMethod}),1)
    cMethod:=self:aMethods[nMethod]
    DO CASE
    CASE (cMethod=="PROGRESS")
        cEval:=self:Progress()
    CASE (cMethod=="INCREMENT")
        cEval:=self:Increment(@cAlign)
    CASE (cMethod=="DECREMENT")
        cEval:=self:Decrement(@cAlign)
    CASE (cMethod=="SHUTTLE")
        cEval:=self:Shuttle(@cAlign)
    CASE (cMethod=="JUNCTION")
        cEval:=self:Junction(@cAlign)
    CASE (cMethod=="DISPERSION")
        cEval:=self:Dispersion(@cAlign)
    CASE (cMethod=="DISJUNCTION")
        cEval:=self:Disjunction(@cAlign)
    CASE (cMethod=="UNION")
        cEval:=self:Union(@cAlign)
    CASE (cMethod=="OCCULT")
        cEval:=self:Occult(@cAlign)
    CASE (cMethod=="RANDOM")
        cEval:=self:Random(@cAlign)
    OTHERWISE
        cEval:=self:Progress()
    ENDCASE
    Return(cEval)
/*Method Eval*/

Method Progress() Class tSProgress
    Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])
/*Method Progress*/

Method Increment(cAlign AS CHARACTER) Class tSProgress
    Local cPADFunc      AS CHARACTER
    Local cProgress     AS CHARACTER
    Local nProgress     AS NUMERIC
    Local nsProgress    AS NUMERIC
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    nsProgress:=self:nProgress
    IF (cAlign=="C")
        ++nsProgress
        IF (nsProgress>self:nMax)
            nsProgress:=1
        EndIF
    EndIF
    cProgress:=""
    For nProgress:=1 To nsProgress
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cProgress+=Space(Len(self:aProgress[nProgress]))
        Else
            cProgress+=self:aProgress[nProgress]
        EndIF
    Next nProgress
    cPADFunc:="PAD"
    cPADFunc+=cAlign
    Return(&cPADFunc.(cProgress,self:nMax))
/*Method Increment*/

Method Decrement(cAlign AS CHARACTER) Class tSProgress
    DEFAULT cAlign:="L"
    Return(self:Increment(cAlign))
/*Method Decrement*/

Method Shuttle(cAlign AS CHARACTER) Class tSProgress
    Local cEval AS CHARACTER
    IF (.NOT.(self:lShuttle).and.(self:nProgress>=self:nMax))
        self:lShuttle:=.T.
    ElseIF (self:lShuttle.and.(self:nProgress>=self:nMax))
        self:lShuttle:=.F.
    EndIF
    IF (self:lShuttle)
        cEval:="DECREMENT"
        cAlign:="L"
    Else
        cEval:="INCREMENT"
        cAlign:="R"
    EndIF
    Return(self:Eval(cEval,@cAlign))
/*Method Shuttle*/

Method Junction(cAlign AS CHARACTER) Class tSProgress
    Local cLToR     AS CHARACTER
    Local cRToL     AS CHARACTER
    Local cProgress AS CHARACTER
    Local cPADFunc  AS CHARACTER
    Local nProgress AS NUMERIC
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    cLToR:=""
    cRToL:=""
    For nProgress:=1 To self:nProgress
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cLToR+=Space(Len(self:aProgress[nProgress]))
        Else
            cLToR+=self:aProgress[nProgress]
        EndIF
    Next nProgress
    For nProgress:=self:nMax To Min(((self:nMax-self:nProgress)+1),self:nMax) STEP (-1)
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cRToL+=Space(Len(self:aProgress[nProgress]))
        Else
            cRToL+=self:aProgress[nProgress]
        EndIF
    Next nProgress
    self:nProgress+=Len(cRToL)
    self:nProgress:=Min(self:nProgress,self:nMax)
    cProgress:=cLToR
    cProgress+=Space(self:nMax-self:nProgress)
    cProgress+=cRToL
    cPADFunc:="PAD"
    cPADFunc+=cAlign
    Return(&cPADFunc.(cProgress,self:nMax))
/*Method Junction*/

Method Dispersion(cAlign AS CHARACTER) Class tSProgress
    Local cEval AS CHARACTER
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (cAlign=="R")
        cEval:="INCREMENT"
    Else
        cEval:="DECREMENT"
    EndIF
    Return(self:Eval(cEval,"C"))
/*Method Dispersion*/

Method Disjunction(cAlign AS CHARACTER) Class tSProgress
    Local cPADFunc  AS CHARACTER
    Local cProgress AS CHARACTER
    Local nAT       AS NUMERIC
    DEFAULT cAlign:="C" //L,C,R
    IF Empty(cAlign)
        cAlign:="C"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    cProgress:=""
    aEval(self:aProgress,{|p,n|cProgress+=IF(self:lRandom.and.((__Random(n,self:nMax)%__Random(1,5))==0),Space(Len(p)),p)})
    IF (self:nProgress>1)
        nAT:=Int(self:nMax/self:nProgress)
        cProgress:=SubStr(cProgress,1,nAT)
        cProgress+=Space(self:nProgress-1)+cProgress
    EndIF
    cPADFunc:="PAD"
    cPADFunc+=cAlign
    Return(&cPADFunc.(cProgress,self:nMax))
/*Method Disjunction*/

Method Union(cAlign AS CHARACTER) Class tSProgress
    Local cPADFunc  AS CHARACTER
    Local cProgress AS CHARACTER
    Local nAT       AS NUMERIC
    Local nQT       AS NUMERIC
    DEFAULT cAlign:="C" //L,C,R
    IF Empty(cAlign)
        cAlign:="C"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    cProgress:=""
    aEval(self:aProgress,{|p,n|cProgress+=IF(self:lRandom.and.((__Random(n,self:nMax)%__Random(1,5))==0),Space(Len(p)),p)})
    IF (self:nProgress>1)
        nAT:=Round(self:nMax/self:nProgress,0)
        IF (Mod(self:nMax,2)==0)
            nQT:=((self:nProgress-1)*2)
        Else
            nQT:=((self:nProgress-1)*3)
        EndIF
        cProgress:=Stuff(cProgress,nAT,nQT,"")
    EndIF
    cPADFunc:="PAD"
    cPADFunc+=cAlign
    Return(&cPADFunc.(cProgress,self:nMax))
/*Method Union*/

Method Occult(cAlign AS CHARACTER) Class tSProgress
    Local cPADFunc      AS CHARACTER
    Local cProgress     AS CHARACTER
    Local nProgress     AS NUMERIC
    Local nsProgress    AS NUMERIC
    DEFAULT cAlign:="L" //L,C,R
    IF Empty(cAlign)
        cAlign:="L"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    nsProgress:=self:nProgress
    IF (cAlign=="C")
        ++nsProgress
        IF (nsProgress>self:nMax)
            nsProgress:=1
        EndIF
    EndIF
    cProgress:=""
    For nProgress:=self:nMax To nsProgress STEP (-1)
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cProgress+=Space(Len(self:aProgress[(self:nMax-nProgress)+1]))
        Else
            cProgress+=self:aProgress[(self:nMax-nProgress)+1]
        EndIF
    Next nProgress
    cPADFunc:="PAD"
    cPADFunc+=cAlign
    Return(&cPADFunc.(cProgress,self:nMax))
/*Method Occult*/

Method Random(cAlign AS CHARACTER) Class tSProgress
    IF ((self:nMethod==0) .or. (self:nProgress>=self:nMax))
        self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
        While (("RANDOM"$self:aMethods[self:nMethod]).or.("PROGRESS"$self:aMethods[self:nMethod]))
            self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
        End While
    EndIF
    Return(self:Eval(self:aMethods[self:nMethod],@cAlign))
/*Method Random*/

Method SetRandom(lSet AS LOGICAL) Class tSProgress
    Local lRandom   AS LOGICAL
    lRandom:=self:lRandom
    DEFAULT lSet:=.T.
    self:lRandom:=lSet
    Return(lRandom)
/*Method SetRandom*/

Method GetnMax() Class tSProgress
    Return(self:nMax)
/*Method GetnMax*/

Method GetnProgress() Class tSProgress
    Return(self:nProgress)
/*Method GetnProgress*/

Static Function _StrToKArr(cStr AS CHARACTER,cToken AS CHARACTER)
    Local cDToken   AS CHARACTER
    DEFAULT cStr:=""
    DEFAULT cToken:=";"
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
#ifdef PROTHEUS
    Return(StrTokArr2(cStr,cToken))
#else
    Return(hb_aTokens(cStr,cToken))
#endif
/*Static Function*/

Static Function __Random(nB AS NUMERIC,nE AS NUMERIC)

    Local nR    AS NUMERIC

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
/*Static Function __Random*/
