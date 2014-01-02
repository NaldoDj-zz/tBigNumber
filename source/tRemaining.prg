#IFDEF PROTHEUS
	#DEFINE __PROTHEUS__
	#include "protheus.ch"
#ELSE
	#IFDEF __HARBOUR__
		#include "hbclass.ch"
	#ENDIF
#ENDIF
#include "tBigNumber.ch"
CLASS tRemaining FROM tTimeCalc

#IFNDEF __PROTHEUS__	
	PROTECTED:
#ENDIF
	
	DATA cMediumTime	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cEndTime  		AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cStartTime  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cTimeDiff  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cTRemaining  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA dEndTime		AS DATE      INIT Ctod("//") HIDDEN
	DATA dIncTime		AS DATE      INIT Ctod("//") HIDDEN
	DATA dStartTime		AS DATE      INIT Ctod("//") HIDDEN
	DATA nIncTime		AS NUMERIC   INIT 0			 HIDDEN	
	DATA nProgress		AS NUMERIC   INIT 0			 HIDDEN	
	DATA nSRemaining	AS NUMERIC   INIT 0			 HIDDEN
	DATA nTotal			AS NUMERIC   INIT 0			 HIDDEN
	
#IFNDEF __PROTHEUS__
	EXPORTED:
#ENDIF	

	METHOD New(nTotal) CONSTRUCTOR
	METHOD ClassName()

	METHOD SetRemaining(nTotal)

	METHOD Calcule()
	METHOD RemainingTime()
	METHOD CalcEndTime()
	
	METHOD GetcMediumTime()
	METHOD GetcEndTime()
	METHOD GetcStartTime()
	METHOD GetcTimeDiff()
	METHOD GetcTRemaining()
	METHOD GetdEndTime()
	METHOD GetdIncTime()
	METHOD GetdStartTime()
	METHOD GetnIncTime()
	METHOD GetnProgress()
	METHOD GetnSRemaining()
	METHOD GetnTotal()
	
ENDCLASS

METHOD New(nTotal) CLASS tRemaining
#IFDEF __PROTHEUS__
	_Super:New()
#ELSE
	self:super:New()
#ENDIF	
	self:SetRemaining(@nTotal)
Return(self)

METHOD ClassName() CLASS tRemaining
Return("TREMAINING")

METHOD SetRemaining(nTotal) CLASS tRemaining
	DEFAULT nTotal 		:= 0
	self:cMediumTime	:= "00:00:00"	
	self:cEndTime		:= "00:00:00"
	self:cStartTime		:= Time()
	self:cTimeDiff		:= "00:00:00"
	self:cTRemaining	:= "00:00:00"
	self:dEndTime		:= CToD("//")
	self:dIncTime		:= Date()
	self:dStartTime		:= self:dEndTime
	self:nIncTime		:= 0
	self:nProgress		:= 0
	self:nSRemaining	:= 0
	self:nTotal			:= nTotal
Return(self)

METHOD Calcule() CLASS tRemaining
	Local aEndTime
	self:RemainingTime()
	self:cMediumTime		:= self:MediumTime(self:cTimeDiff,++self:nProgress,.T.)
	self:cEndTime			:= self:CalcEndTime()
	self:cEndTime			:= self:IncTime(Time(),NIL,NIL,self:TimeToSecs(self:cEndTime))
	aEndTime				:= self:Time2NextDay(self:cEndTime,Date())
	self:cEndTime			:= aEndTime[1]
	self:dEndTime			:= aEndTime[2]
Return(self)

METHOD RemainingTime() CLASS tRemaining

	Local cTime		:= Time()
	Local dDate		:= Date()

	Local nHrsInc
	Local nMinInc
	Local nSecInc

	IF .NOT.(self:dIncTime==dDate)
		self:dIncTime := dDate
		++self:nIncTime
	EndIF

	IF (self:nIncTime>0)
	    self:ExtractTime(self:cStartTime,@nHrsInc,@nMinInc,@nSecInc)
		cTime := self:IncTime(self:HMSToTime((self:nIncTime*24)),nHrsInc,nMinInc,nSecInc)
	EndIF

	self:cTimeDiff		:= ElapTime(self:cStartTime,cTime)
	self:cTRemaining	:= ElapTime(self:cTimeDiff,self:cStartTime)
	self:nSRemaining	:= self:TimeToSecs(self:cTimeDiff)

Return(self)

METHOD CalcEndTime() CLASS tRemaining
	Local nTimeEnd := (((self:nTotal-self:nProgress)*self:nSRemaining)/self:nProgress)
Return(self:SecsToTime(nTimeEnd))

METHOD GetcMediumTime() CLASS tRemaining
Return(self:cMediumTime)

METHOD GetcEndTime() CLASS tRemaining
Return(self:cEndTime)

METHOD GetcStartTime() CLASS tRemaining
Return(self:cStartTime)

METHOD GetcTimeDiff() CLASS tRemaining
Return(self:cTimeDiff)

METHOD GetcTRemaining() CLASS tRemaining
Return(self:cTRemaining)

METHOD GetdEndTime() CLASS tRemaining
Return(self:dEndTime)

METHOD GetdIncTime() CLASS tRemaining
Return(self:dIncTime)

METHOD GetdStartTime() CLASS tRemaining
Return(self:dStartTime)

METHOD GetnIncTime() CLASS tRemaining
Return(self:nIncTime)

METHOD GetnProgress() CLASS tRemaining
Return(self:nProgress)

METHOD GetnSRemaining() CLASS tRemaining
Return(self:nSRemaining)

METHOD GetnTotal() CLASS tRemaining
Return(self:nTotal)