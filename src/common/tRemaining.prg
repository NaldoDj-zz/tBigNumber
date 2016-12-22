#include "tBigNDef.ch"

#ifdef PROTHEUS
    #ifndef __ADVPL__
        #define __ADVPL__
    #endif
    #include "protheus.ch"
#else
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif
#endif

//--------------------------------------------------------------------------------------------------------
    /*
        Class:tRemaining
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:29/12/2013
        Descricao:Instancia um novo objeto do tipo tRemaining
        Sintaxe:tRemaining():New() -> self
    */
//--------------------------------------------------------------------------------------------------------
Class tRemaining FROM tTimeCalc

    #ifndef __ADVPL__
        PROTECTED:
    #endif

        #ifdef __HARBOUR__
            DATA cAverageTime   AS CHARACTER INIT "00:00:00:000" HIDDEN
            DATA cAverageStep   AS CHARACTER INIT "00:00:00:000" HIDDEN
        #else /*__ADVPL__*/
            DATA cAverageTime   AS CHARACTER
            DATA cAverageStep   AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cEndTime       AS CHARACTER INIT "00:00:00"     HIDDEN
        #else /*__ADVPL__*/
            DATA cEndTime       AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cStartTime     AS CHARACTER INIT Time()        HIDDEN
        #else /*__ADVPL__*/
            DATA cStartTime     AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cTimeDiff      AS CHARACTER INIT "00:00:00"     HIDDEN
        #else /*__ADVPL__*/
            DATA cTimeDiff      AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA cTRemaining    AS CHARACTER INIT "00:00:00"     HIDDEN
        #else /*__ADVPL__*/
            DATA cTRemaining    AS CHARACTER
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA dEndTime       AS DATE      INIT Ctod("//")     HIDDEN
        #else /*__ADVPL__*/
            DATA dEndTime       AS DATE
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA dStartTime     AS DATE      INIT Date()         HIDDEN
        #else /*__ADVPL__*/
            DATA dStartTime     AS DATE
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nProgress      AS NUMERIC   INIT 0              HIDDEN
        #else /*__ADVPL__*/
            DATA nProgress      AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nSRemaining    AS NUMERIC   INIT 0              HIDDEN
        #else /*__ADVPL__*/
            DATA nSRemaining    AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nTotal         AS NUMERIC   INIT 0              HIDDEN
        #else /*__ADVPL__*/
            DATA nTotal         AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA nStep          AS NUMERIC   INIT 1              HIDDEN
        #else /*__ADVPL__*/
            DATA nStep          AS NUMERIC
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            DATA lForceStep     AS LOGICAL   INIT .F.            HIDDEN
        #else /*__ADVPL__*/
            DATA lForceStep     AS LOGICAL
        #endif /*__HARBOUR__*/

    #ifndef __ADVPL__
        EXPORTED:
    #endif

        #ifdef __HARBOUR__
            Method New(nTotal AS NUMERIC) CONSTRUCTOR
        #else /*__ADVPL__*/
            Method New(nTotal) CONSTRUCTOR
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method ClassName()
        #else /*__ADVPL__*/
            Method ClassName()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method SetStep(nStep AS NUMERIC)
        #else /*__ADVPL__*/
            Method SetStep(nStep)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method ForceStep(lSet AS LOGICAL)
        #else /*__ADVPL__*/
            Method ForceStep(lSet)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method SetRemaining(nTotal AS NUMERIC)
        #else /*__ADVPL__*/
            Method SetRemaining(nTotal)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method Calcule(lProgress AS LOGICAL)
        #else /*__ADVPL__*/
            Method Calcule(lProgress)
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetcAverageTime()
        #else /*__ADVPL__*/
            Method GetcAverageTime()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetcEndTime()
        #else /*__ADVPL__*/
            Method GetcEndTime()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetcStartTime()
        #else /*__ADVPL__*/
            Method GetcStartTime()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetcTimeDiff()
        #else /*__ADVPL__*/
            Method GetcTimeDiff()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetcTRemaining()
        #else /*__ADVPL__*/
            Method GetcTRemaining()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetdEndTime()
        #else /*__ADVPL__*/
            Method GetdEndTime()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetdStartTime()
        #else /*__ADVPL__*/
            Method GetdStartTime()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetnProgress()
        #else /*__ADVPL__*/
            Method GetnProgress()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetnSRemaining()
        #else /*__ADVPL__*/
            Method GetnSRemaining()
        #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            Method GetnTotal()
        #else /*__ADVPL__*/
            Method GetnTotal()
        #endif /*__HARBOUR__*/

EndClass

#ifdef __HARBOUR__
    Method New(nTotal AS NUMERIC) Class tRemaining
        ::super:New()
#else /*__ADVPL__*/
    Method New(nTotal) Class tRemaining
        _Super:New()
        PARAMETER nTotal AS NUMERIC
        DEFAULT nTotal:=0
        self:cAverageTime:="00:00:00:000"
        self:cAverageStep:="00:00:00:000"
        self:cEndTime:="00:00:00"
        self:cStartTime:=Time()
        self:cTimeDiff:="00:00:00"
        self:cTRemaining:="00:00:00"
        self:dEndTime:=Ctod("//")
        self:dStartTime:=Date()
        self:nProgress:=0
        self:nSRemaining:=0
        self:nTotal:=0
        self:nStep:=1
        self:lForceStep:=.F.
#endif /*__HARBOUR__*/
        self:SetStep()
        self:SetRemaining(@nTotal)
        Return(self)
/*Method New*/

#ifdef __ADVPL__
    Function u_tRemaining(nTotal AS NUMERIC)
        Return(tRemaining():New(nTotal))
    /*Function u_tRemaining*/
#endif

#ifdef __HARBOUR__
    Method ClassName() Class tRemaining
#else /*__ADVPL__*/
    Method ClassName() Class tRemaining
#endif /*__HARBOUR__*/
        Return("TREMAINING")
/*Method ClassName*/

#ifdef __HARBOUR__
    Method SetRemaining(nTotal AS NUMERIC) Class tRemaining
#else /*__ADVPL__*/
    Method SetRemaining(nTotal) Class tRemaining
        PARAMETER nTotal AS NUMERIC
#endif /*__HARBOUR__*/
        DEFAULT nTotal:=1
        self:nTotal:=nTotal
        self:nProgress:=0
        self:nSRemaining:=0
        self:cAverageTime:="00:00:00:000"
        self:cAverageStep:="00:00:00:000"
        self:SetStep()
        self:ForceStep()
        self:cStartTime:=Time()
        self:dStartTime:=Date()
        Return(self)
/*Method SetRemaining*/

#ifdef __HARBOUR__
    Method SetStep(nStep AS NUMERIC) Class tRemaining
#else /*__ADVPL__*/
    Method SetStep(nStep) Class tRemaining
        PARAMETER nStep AS NUMERIC
#endif /*__HARBOUR__*/
        DEFAULT nStep:=1
        self:nStep:=nStep
        Return(self)
/*Method SetStep*/

#ifdef __HARBOUR__
    Method ForceStep(lSet AS LOGICAL) Class tRemaining
#else /*__ADVPL__*/
    Method ForceStep(lSet) Class tRemaining
#endif /*__HARBOUR__*/
        local lLast AS LOGICAL
        #ifdef __ADVPL__
            PARAMETER lSet AS LOGICAL
        #endif /*__ADVPL__*/
        lLast:=self:lForceStep
        DEFAULT lSet:=.F.
        self:lForceStep:=lSet
        Return(lLast)
/*Method ForceStep*/

#ifdef __HARBOUR__
    Method Calcule(lProgress AS LOGICAL) Class tRemaining
#else /*__ADVPL__*/
    Method Calcule(lProgress) Class tRemaining
#endif /*__HARBOUR__*/

        Local aEndTime      AS ARRAY

        Local cTime         AS CHARACTER
        Local dDate         AS DATE

        Local nIncTime      AS NUMERIC

        Local nTime         AS NUMERIC
        Local nTimeEnd      AS NUMERIC
        Local nTimeDiff     AS NUMERIC
        Local nStartTime    AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER lProgress AS LOGICAL
        #endif /*__ADVPL__*/

        dDate:=Date()
        cTime:=Time()
        nIncTime:=0

        IF .NOT.(dDate==self:dStartTime)
            nIncTime:=abs(dDate-self:dStartTime)
            nIncTime*=24
        EndIF

        nTime:=(self:TimeToSecs(cTime)+IF(nIncTime>0,self:HrsToSecs(nIncTime),0))
        nStartTime:=self:TimeToSecs(self:cStartTime)

        nTimeDiff:=abs(nTime-nStartTime)
        self:cTimeDiff:=self:SecsToTime(nTimeDiff)
        self:cTRemaining:=self:SecsToTime(abs(nTimeDiff-nStartTime))
        self:nSRemaining:=nTimeDiff

        DEFAULT lProgress:=.T.
        IF (lProgress).or.(self:lForceStep)
            self:nProgress+=self:nStep
            self:nProgress:=Min(self:nProgress,self:nTotal)
        EndIF

        self:cAverageTime:=self:AverageTime(self:cTimeDiff,self:nProgress,.T.)

        nTimeEnd:=(((self:nTotal-self:nProgress)*self:nSRemaining)/self:nProgress)
        self:cEndTime:=self:SecsToTime(nTimeEnd)
        self:cEndTime:=self:IncTime(cTime,0,0,self:TimeToSecs(self:cEndTime))
        aEndTime:=self:Time2NextDay(self:cEndTime,dDate)
        self:cEndTime:=aEndTime[1]
        self:dEndTime:=aEndTime[2]

        IF (self:lForceStep)
            IF (self:nProgress>=self:nTotal)                
                self:cAverageStep:=self:IncTime(self:cAverageStep,0,0,self:TimeToSecs(self:cAverageTime))
                self:cAverageTime:="00:00:00:000"
                self:nTotal+=self:nProgress
                self:nProgress:=0
                self:dStartTime:=Date()
                self:cStartTime:=Time()              
            EndIF
        EndIF

        self:cAverageTime:=self:IncTime(self:cAverageTime,0,0,self:TimeToSecs(self:cAverageStep))
        
        Return(self)
/*Method Calcule*/

#ifdef __HARBOUR
    Method GetcAverageTime() Class tRemaining
#else /*__ADVPL__*/
    Method GetcAverageTime() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:cAverageTime)
/*Method GetcAverageTime*/

#ifdef __HARBOUR
    Method GetcEndTime() Class tRemaining
#else /*__ADVPL__*/
    Method GetcEndTime() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:cEndTime)
/*Method GetcEndTime*/

#ifdef __HARBOUR
    Method GetcStartTime() Class tRemaining
#else /*__ADVPL__*/
    Method GetcStartTime() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:cStartTime)
/*Method GetcStartTime*/

#ifdef __HARBOUR
    Method GetcTimeDiff() Class tRemaining
#else /*__ADVPL__*/
    Method GetcTimeDiff() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:cTimeDiff)
/*Method GetcTimeDiff*/

#ifdef __HARBOUR
    Method GetcTRemaining() Class tRemaining
#else /*__ADVPL__*/
    Method GetcTRemaining() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:cTRemaining)
/*Method GetcTRemaining*/

#ifdef __HARBOUR
    Method GetdEndTime() Class tRemaining
#else /*__ADVPL__*/
    Method GetdEndTime() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:dEndTime)
/*Method GetdEndTime*/

#ifdef __HARBOUR
    Method GetdStartTime() Class tRemaining
#else /*__ADVPL__*/
    Method GetdStartTime() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:dStartTime)
/*Method GetdStartTime*/

#ifdef __HARBOUR
    Method GetnProgress() Class tRemaining
#else /*__ADVPL__*/
    Method GetnProgress() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:nProgress)
/*Method GetnProgress*/

#ifdef __HARBOUR
    Method GetnSRemaining() Class tRemaining
#else /*__ADVPL__*/
    Method GetnSRemaining() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:nSRemaining)
/*Method GetnSRemaining*/

#ifdef __HARBOUR
    Method GetnTotal() Class tRemaining
#else /*__ADVPL__*/
    Method GetnTotal() Class tRemaining
#endif /*__HARBOUR__*/
        Return(self:nTotal)
/*Method GetnTotal*/
