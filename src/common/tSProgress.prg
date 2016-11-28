#ifdef PROTHEUS
    #define __ADVPL__
    #include "protheus.ch"
#else /*__HARBOUR__*/
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif /*__HARBOUR__*/
#endif /*PROTHEUS*/

#include "tBigNumber.ch"

//--------------------------------------------------------------------------------------------------------
    /*
        Class:tSProgress
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:29/12/2013
        Descricao:Instancia um novo objeto do tipo tSProgress
        Sintaxe:tSProgress():New(cProgress,cToken) -> self
    */
//--------------------------------------------------------------------------------------------------------
Class tSProgress

    #ifndef __ADVPL__
        PROTECTED:
    #endif

    #ifdef __HARBOUR__
        DATA aMethods   AS ARRAY INIT Array(0) HIDDEN
    #else /*__ADVPL__*/
        DATA aMethods   AS ARRAY
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA aProgress  AS ARRAY INIT Array(0) HIDDEN
    #else /*__ADVPL__*/
        DATA aProgress  AS ARRAY
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA lRandom    AS LOGICAL INIT .F.    HIDDEN
    #else /*__ADVPL__*/
        DATA lRandom    AS LOGICAL
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA nMax       AS NUMERIC INIT 0      HIDDEN
    #else /*__ADVPL__*/
        DATA nMax       AS NUMERIC
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA nMethod    AS NUMERIC INIT 0      HIDDEN
    #else /*__ADVPL__*/
        DATA nMethod    AS NUMERIC
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA nMethods   AS NUMERIC INIT 0      HIDDEN
    #else /*__ADVPL__*/
        DATA nMethods   AS NUMERIC
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA nProgress  AS NUMERIC INIT 0      HIDDEN
    #else /*__ADVPL__*/
        DATA nProgress  AS NUMERIC
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        DATA lShuttle   AS LOGICAL INIT .F.    HIDDEN
    #else /*__ADVPL__*/
        DATA lShuttle   AS LOGICAL
    #endif /*__HARBOUR__*/

    #ifndef __ADVPL__
        EXPORTED:
    #endif /*__ADVPL__*/

        #ifdef __HARBOUR__
            Method New(cProgress AS CHARACTER,cToken AS CHARACTER)  CONSTRUCTOR
        #else /*__ADVPL__*/
            Method New(cProgress,cToken)  CONSTRUCTOR
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method ClassName()
        #else /*__ADVPL__*/
            Method ClassName()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method SetProgress(cProgress AS CHARACTER,cToken AS CHARACTER)
        #else /*__ADVPL__*/
            Method SetProgress(cProgress,cToken)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Eval(cMethod AS CHARACTER,cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Eval(cMethod,cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Progress()
        #else /*__ADVPL__*/
            Method Progress()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Increment(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Increment(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Decrement(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Decrement(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Shuttle(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Shuttle(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Junction(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Junction(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Dispersion(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Dispersion(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Disjunction(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Disjunction(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Union(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Union(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Occult(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Occult(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Random(cAlign AS CHARACTER)
        #else /*__ADVPL__*/
            Method Random(cAlign)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetnMax()
        #else /*__ADVPL__*/
            Method GetnMax()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetnProgress()
        #else /*__ADVPL__*/
            Method GetnProgress()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method SetRandom(lSet AS LOGICAL)
        #else /*__ADVPL__*/
            Method SetRandom(lSet)
        #endif /*__HARBOUR__*/

EndClass

#ifdef __ADVPL__
    Function u_tSProgress(cProgress AS CHARACTER,cToken AS CHARACTER)
        Return(tSProgress():New(@cProgress,@cToken))
    /*Function u_tSProgress*/
#endif

#ifdef __HARBOUR__
    Method New(cProgress AS CHARACTER,cToken AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method New(cProgress,cToken) Class tSProgress
        PARAMETER cProgress AS CHARACTER
        PARAMETER cToken    AS CHARACTER
#endif /*__HARBOUR__*/
        self:SetProgress(@cProgress,@cToken)
        Return(self)
/*Method New*/

#ifdef __HARBOUR__
    Method ClassName() Class tSProgress
#else /*__ADVPL__*/
    Method ClassName() Class tSProgress
#endif /*__HARBOUR__*/
        Return("TSPROGRESS")
/*Method ClassName*/

#ifdef __HARBOUR__
    Method SetProgress(cProgress AS CHARACTER,cToken AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method SetProgress(cProgress,cToken) Class tSProgress
#endif /*__HARBOUR__*/
        Local lMacro    AS LOGICAL
        #ifdef __ADVPL__
            PARAMETER cProgress AS CHARACTER
            PARAMETER cToken    AS CHARACTER
        #endif /*__ADVPL__*/
        DEFAULT cProgress:="-;\;|;/"
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
        DEFAULT cToken:=";"
        self:aProgress:=_StrToKArr(@cProgress,@cToken)
        self:lRandom:=.F.
        self:lShuttle:=.NOT.(self:lShuttle)
        self:nMethod:=0
        self:nMax:=Len(self:aProgress)
        self:nProgress:=0
        Return(self)
/*Method SetProgress*/

#ifdef __HARBOUR__
    Method Eval(cMethod AS CHARACTER,cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Eval(cMethod,cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cEval     AS CHARACTER
        Local nMethod   AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cMethod   AS CHARACTER
            PARAMETER cAlign    AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Progress() Class tSProgress
#else /*__ADVPL__*/
    Method Progress() Class tSProgress
#endif /*__HARBOUR__*/
        Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])
/*Method Progress*/

#ifdef __HARBOUR__
    Method Increment(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Increment(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cPADFunc      AS CHARACTER
        Local cProgress     AS CHARACTER
        Local nProgress     AS NUMERIC
        Local nsProgress    AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Decrement(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Decrement(cAlign) Class tSProgress
        PARAMETER cAlign AS CHARACTER
#endif /*__HARBOUR__*/
        DEFAULT cAlign:="L"
        Return(self:Increment(cAlign))
/*Method Decrement*/

#ifdef __HARBOUR__
    Method Shuttle(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Shuttle(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cEval AS CHARACTER
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Junction(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Junction(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cLToR     AS CHARACTER
        Local cRToL     AS CHARACTER
        Local cProgress AS CHARACTER
        Local cPADFunc  AS CHARACTER
        Local nProgress AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Dispersion(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Dispersion(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cEval AS CHARACTER
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Disjunction(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Disjunction(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cPADFunc  AS CHARACTER
        Local cProgress AS CHARACTER
        Local nAT       AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Union(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Union(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cPADFunc  AS CHARACTER
        Local cProgress AS CHARACTER
        Local nAT       AS NUMERIC
        Local nQT       AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Occult(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Occult(cAlign) Class tSProgress
#endif /*__HARBOUR__*/
        Local cPADFunc      AS CHARACTER
        Local cProgress     AS CHARACTER
        Local nProgress     AS NUMERIC
        Local nsProgress    AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER cAlign AS CHARACTER
        #endif /*__ADVPL__*/
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

#ifdef __HARBOUR__
    Method Random(cAlign AS CHARACTER) Class tSProgress
#else /*__ADVPL__*/
    Method Random(cAlign) Class tSProgress
        PARAMETER cAlign AS CHARACTER
#endif /*__HARBOUR__*/
        IF ((self:nMethod==0) .or. (self:nProgress>=self:nMax))
            self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
            While (("RANDOM"$self:aMethods[self:nMethod]).or.("PROGRESS"$self:aMethods[self:nMethod]))
                self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
            End While
        EndIF
        Return(self:Eval(self:aMethods[self:nMethod],@cAlign))
/*Method Random*/

#ifdef __HARBOUR__
    Method SetRandom(lSet AS LOGICAL) Class tSProgress
#else /*__ADVPL__*/
    Method SetRandom(lSet) Class tSProgress
#endif /*__HARBOUR__*/
        Local lRandom   AS LOGICAL
        #ifdef __ADVPL__
            PARAMETER lSet AS LOGICAL
        #endif /*__ADVPL__*/
        lRandom:=self:lRandom
        DEFAULT lSet:=.T.
        self:lRandom:=lSet
        Return(lRandom)
/*Method SetRandom*/

#ifdef __HARBOUR__
    Method GetnMax() Class tSProgress
#else /*__ADVPL__*/
    Method GetnMax() Class tSProgress
#endif /*__HARBOUR__*/
        Return(self:nMax)
/*Method GetnMax*/

#ifdef __HARBOUR__
    Method GetnProgress() Class tSProgress
#else /*__ADVPL__*/
    Method GetnProgress() Class tSProgress
#endif /*__HARBOUR__*/
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
    #else /*__ADVPL__*/
        nR:=Randomize(nB,nE)
    #endif

    Return(nR)
/*Static Function __Random*/
