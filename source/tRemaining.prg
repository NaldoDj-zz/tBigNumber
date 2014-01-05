#IFDEF PROTHEUS
	#DEFINE __PROTHEUS__
	#include "protheus.ch"
#ELSE
	#IFDEF __HARBOUR__
		#include "hbClass.ch"
	#ENDIF
#ENDIF
#include "tBigNumber.ch"
Class tRemaining FROM tTimeCalc

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

	Method New(nTotal) CONSTRUCTOR
	Method ClassName()

	Method SetRemaining(nTotal)

	Method Calcule()
	Method RemainingTime()
	Method CalcEndTime()
	
	Method GetcMediumTime()
	Method GetcEndTime()
	Method GetcStartTime()
	Method GetcTimeDiff()
	Method GetcTRemaining()
	Method GetdEndTime()
	Method GetdIncTime()
	Method GetdStartTime()
	Method GetnIncTime()
	Method GetnProgress()
	Method GetnSRemaining()
	Method GetnTotal()
	
EndClass

Method New(nTotal) Class tRemaining
#IFDEF __PROTHEUS__
	_Super:New()
#ELSE
	self:super:New()
#ENDIF	
	self:SetRemaining(@nTotal)
Return(self)

Method ClassName() Class tRemaining
Return("TREMAINING")

Method SetRemaining(nTotal) Class tRemaining
	DEFAULT nTotal 		:= 1
	self:cMediumTime	:= "00:00:00"	
	self:cEndTime		:= "00:00:00"
	self:cStartTime		:= Time()
	self:cTimeDiff		:= "00:00:00"
	self:cTRemaining	:= "00:00:00"
	self:dEndTime		:= CToD("//")
	self:dIncTime		:= Date()
	self:dStartTime		:= Date()
	self:nIncTime		:= 0
	self:nProgress		:= 0
	self:nSRemaining	:= 0
	self:nTotal			:= nTotal
Return(self)

Method Calcule() Class tRemaining
	Local aEndTime
	self:RemainingTime()
	self:cMediumTime		:= self:MediumTime(self:cTimeDiff,++self:nProgress,.T.)
	self:cEndTime			:= self:CalcEndTime()
	self:cEndTime			:= self:IncTime(Time(),NIL,NIL,self:TimeToSecs(self:cEndTime))
	aEndTime				:= self:Time2NextDay(self:cEndTime,Date())
	self:cEndTime			:= aEndTime[1]
	self:dEndTime			:= aEndTime[2]
Return(self)

Method RemainingTime() Class tRemaining

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

Method CalcEndTime() Class tRemaining
	Local nTimeEnd := (((self:nTotal-self:nProgress)*self:nSRemaining)/self:nProgress)
Return(self:SecsToTime(nTimeEnd))

Method GetcMediumTime() Class tRemaining
Return(self:cMediumTime)

Method GetcEndTime() Class tRemaining
Return(self:cEndTime)

Method GetcStartTime() Class tRemaining
Return(self:cStartTime)

Method GetcTimeDiff() Class tRemaining
Return(self:cTimeDiff)

Method GetcTRemaining() Class tRemaining
Return(self:cTRemaining)

Method GetdEndTime() Class tRemaining
Return(self:dEndTime)

Method GetdIncTime() Class tRemaining
Return(self:dIncTime)

Method GetdStartTime() Class tRemaining
Return(self:dStartTime)

Method GetnIncTime() Class tRemaining
Return(self:nIncTime)

Method GetnProgress() Class tRemaining
Return(self:nProgress)

Method GetnSRemaining() Class tRemaining
Return(self:nSRemaining)

Method GetnTotal() Class tRemaining
Return(self:nTotal)