#ifdef PROTHEUS
    #define __PROTHEUS__
    #include "protheus.ch"
#else
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif
#endif
#include "tBigNumber.ch"
Class tRemaining FROM tTimeCalc

#ifndef __PROTHEUS__
    PROTECTED:
#endif

    DATA cAverageTime   AS CHARACTER INIT "00:00:00:000" HIDDEN
    DATA cEndTime       AS CHARACTER INIT "00:00:00"     HIDDEN
    DATA cStartTime     AS CHARACTER INIT "00:00:00"     HIDDEN
    DATA cTimeDiff      AS CHARACTER INIT "00:00:00"     HIDDEN
    DATA cTRemaining    AS CHARACTER INIT "00:00:00"     HIDDEN
    DATA dEndTime       AS DATE      INIT Ctod("//")     HIDDEN
    DATA dStartTime     AS DATE      INIT Ctod("//")     HIDDEN
    DATA nProgress      AS NUMERIC   INIT 0              HIDDEN
    DATA nSRemaining    AS NUMERIC   INIT 0              HIDDEN
    DATA nTotal         AS NUMERIC   INIT 0              HIDDEN
    DATA nStep          AS NUMERIC   INIT 1              HIDDEN
    DATA lForceStep     AS LOGICAL   INIT .F.            HIDDEN

#ifndef __PROTHEUS__
    EXPORTED:
#endif

    Method New(nTotal AS NUMERIC) CONSTRUCTOR

    Method ClassName()

    Method SetStep(nStep AS NUMERIC)
    Method ForceStep(lSet AS LOGICAL)
    Method SetRemaining(nTotal AS NUMERIC)

    Method Calcule(lProgress AS LOGICAL)

    Method GetcAverageTime()
    Method GetcEndTime()
    Method GetcStartTime()
    Method GetcTimeDiff()
    Method GetcTRemaining()
    Method GetdEndTime()
    Method GetdStartTime()
    Method GetnProgress()
    Method GetnSRemaining()
    Method GetnTotal()

EndClass

Method New(nTotal AS NUMERIC) Class tRemaining
#ifdef __PROTHEUS__
    _Super:New()
#else
    ::super:New()
#endif
    self:SetStep()
    self:SetRemaining(@nTotal)
    Return(self)
/*Method New*/

#ifdef __PROTHEUS__
    Function u_tRemaining(nTotal AS NUMERIC)
        Return(tRemaining():New(nTotal))
    /*Function u_tRemaining*/
#endif

Method ClassName() Class tRemaining
    Return("TREMAINING")
/*Method ClassName*/

Method SetRemaining(nTotal AS NUMERIC) Class tRemaining
    DEFAULT nTotal:=1
    self:cAverageTime:="00:00:00:000"
    self:cEndTime:="00:00:00"
    self:cStartTime:=Time()
    self:cTimeDiff:="00:00:00"
    self:cTRemaining:="00:00:00"
    self:dEndTime:=CToD("//")
    self:dStartTime:=Date()
    self:nProgress:=0
    self:nSRemaining:=0
    self:nTotal:=nTotal
    self:SetStep()
    self:ForceStep()
    Return(self)
/*Method SetRemaining*/

Method SetStep(nStep AS NUMERIC) Class tRemaining
    DEFAULT nStep:=1
    self:nStep:=nStep
    Return(self)
/*Method SetStep*/

Method ForceStep(lSet AS LOGICAL) Class tRemaining
    local lLast AS LOGICAL
    lLast:=self:lForceStep
    DEFAULT lSet:=.F.
    self:lForceStep:=lSet
    Return(lLast)
/*Method ForceStep*/

Method Calcule(lProgress AS LOGICAL) Class tRemaining

    Local aEndTime      AS ARRAY

    Local cTime         AS CHARACTER
    Local dDate         AS DATE

    Local nIncTime      AS NUMERIC

    Local nTime         AS NUMERIC
    Local nTimeEnd      AS NUMERIC
    Local nTimeDiff     AS NUMERIC
    Local nStartTime    AS NUMERIC

    dDate:=Date()
    cTime:=Time()
    nIncTime:=0

    IF .NOT.(dDate==Self:dStartTime)
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
    self:cEndTime:=self:IncTime(cTime,NIL,NIL,self:TimeToSecs(self:cEndTime))
    aEndTime:=self:Time2NextDay(self:cEndTime,dDate)
    self:cEndTime:=aEndTime[1]
    self:dEndTime:=aEndTime[2]

    IF (self:lForceStep)
        IF (self:nProgress>=self:nTotal)
            self:nTotal+=self:nProgress
            self:nProgress:=0
        EndIF
    EndIF

    Return(self)
/*Method Calcule*/

Method GetcAverageTime() Class tRemaining
    Return(self:cAverageTime)
/*Method GetcAverageTime*/

Method GetcEndTime() Class tRemaining
    Return(self:cEndTime)
/*Method GetcEndTime*/

Method GetcStartTime() Class tRemaining
    Return(self:cStartTime)
/*Method GetcStartTime*/

Method GetcTimeDiff() Class tRemaining
    Return(self:cTimeDiff)
/*Method GetcTimeDiff*/

Method GetcTRemaining() Class tRemaining
    Return(self:cTRemaining)
/*Method GetcTRemaining*/

Method GetdEndTime() Class tRemaining
    Return(self:dEndTime)
/*Method GetdEndTime*/

Method GetdStartTime() Class tRemaining
    Return(self:dStartTime)
/*Method GetdStartTime*/

Method GetnProgress() Class tRemaining
    Return(self:nProgress)
/*Method GetnProgress*/

Method GetnSRemaining() Class tRemaining
    Return(self:nSRemaining)
/*Method GetnSRemaining*/

Method GetnTotal() Class tRemaining
    Return(self:nTotal)
/*Method GetnTotal*/
