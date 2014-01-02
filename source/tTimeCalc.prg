#IFDEF PROTHEUS
	#DEFINE __PROTHEUS__
	#include "protheus.ch"
#ELSE
	#IFDEF __HARBOUR__
		#include "hbclass.ch"
	#ENDIF
#ENDIF
#include "tBigNumber.ch"
CLASS tTimeCalc
#IFNDEF __PROTHEUS__
	EXPORTED:
#ENDIF	
	METHOD New() CONSTRUCTOR
	METHOD ClassName()	
	METHOD HMSToTime(nHours,nMinuts,nSeconds)
	METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
	METHOD SecsToTime(nSecs)
	METHOD TimeToSecs(cTime)
	METHOD SecsToHrs(nSeconds)
	METHOD HrsToSecs(nHours)
	METHOD SecsToMin(nSeconds)
	METHOD MinToSecs(nMinuts)
	METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
	METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
	METHOD Time2NextDay(cTime,dDate)
	METHOD ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet)
	METHOD MediumTime(cTime,nDividendo,lMiliSecs)
ENDCLASS

METHOD New() CLASS tTimeCalc
Return(self)

METHOD ClassName() CLASS tTimeCalc
Return("TTIMECALC")

METHOD HMSToTime(nHours,nMinuts,nSeconds) CLASS tTimeCalc

	Local cTime
	
	DEFAULT nHours		:= 0
	DEFAULT nMinuts		:= 0
	DEFAULT nSeconds	:= 0
	
	cTime := AllTrim(Str(nHours))
	cTime := StrZero(Val(cTime),Max(Len(cTime),2))
	cTime += ":"
	cTime += StrZero(Val(AllTrim(Str(nMinuts))),2)
	cTime += ":"
	cTime += StrZero(Val(AllTrim(Str(nSeconds))),2)

Return(cTime)

METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) CLASS tTimeCalc

	Local nRet	:= 0
	
	DEFAULT nSecsToHMS	:= 0
	DEFAULT cRet		:= "H"
	
	nHours		:= self:SecsToHrs(nSecsToHMS)
	nMinuts		:= self:SecsToMin(nSecsToHMS)
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts))
	nSeconds	:= (nSecsToHMS-nSeconds)
	nSeconds	:= Int(nSeconds)
	nSeconds	:= Mod(nSeconds,60)
	
	IF (cRet$"Hh")
		nRet := nHours
	ElseIF (cRet$"Mm")
		nRet := nMinuts
	ElseIF (cRet$"Ss")
		nRet := nSeconds
	EndIF

Return(nRet)

METHOD SecsToTime(nSecs) CLASS tTimeCalc
	Local nHours
	Local nMinuts
	Local nSeconds
	self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
Return(self:HMSToTime(nHours,nMinuts,nSeconds))

METHOD TimeToSecs(cTime) CLASS tTimeCalc

	Local nHours
	Local nMinuts
	Local nSeconds
	
	DEFAULT cTime	:= "00:00:00"
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nMinuts		+= (nHours*60)
	nSeconds	+= (nMinuts*60)

Return(nSeconds)

METHOD SecsToHrs(nSeconds) CLASS tTimeCalc
	Local nHours
	nHours	:= (nSeconds/3600)
	nHours	:= Int(nHours)
Return(nHours)

METHOD HrsToSecs(nHours) CLASS tTimeCalc
Return((nHours*3600))

METHOD SecsToMin(nSeconds) CLASS tTimeCalc
	Local nMinuts
	nMinuts		:= (nSeconds/60)
	nMinuts		:= Int(nMinuts)
	nMinuts		:= Mod(nMinuts,60)
Return(nMinuts)

METHOD MinToSecs(nMinuts) CLASS tTimeCalc
Return((nMinuts*60))

METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) CLASS tTimeCalc

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nIncHours	:= 0
	DEFAULT nIncMinuts	:= 0
	DEFAULT nIncSeconds	:= 0
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nHours		+= nIncHours
	nMinuts		+= nIncMinuts
	nSeconds	+= nIncSeconds
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
	
Return(self:SecsToTime(nSeconds))

METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) CLASS tTimeCalc

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nDecHours	:= 0
	DEFAULT nDecMinuts	:= 0
	DEFAULT nDecSeconds	:= 0
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nHours		-= nDecHours
	nMinuts		-= nDecMinuts
	nSeconds	-= nDecSeconds
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
	
Return(self:SecsToTime(nSeconds))

METHOD Time2NextDay(cTime,dDate) CLASS tTimeCalc
	While (Val(cTime)>=24)
		cTime := self:DecTime(cTime,24)
		++dDate
	End While
Return({cTime,dDate})

METHOD ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet) CLASS tTimeCalc

	Local nRet		:= 0
	
	Local nAT
	
	DEFAULT cTime	:= "00:00:00"
	DEFAULT cRet	:= "H"
	
	nAT	:= AT(":",cTime)
	
	IF (nAT == 0)
		nHours	:= Val(cTime)
		nMinutes:= 0
		nSeconds:= 0
	Else
		nHours	:= Val(SubStr(cTime,1,nAT-1))
		cTime	:= SubStr(cTime,nAT+1)
		nAT		:= (At(":",cTime))
		IF (nAT == 0)
			nMinutes := Val(cTime)
			nSeconds := 0
		Else
			nMinutes := Val(SubStr(cTime,1,nAT-1))
			nSeconds := Val(SubStr(cTime,nAT+1))
		EndIF
	EndIF
	
	IF (cRet$"Hh")
		nRet := nHours
	ElseIF (cRet$"Mm")
		nRet := nMinutes
	ElseIF (cRet$"Ss")
		nRet := nSeconds
	EndIF

Return(nRet)

METHOD MediumTime(cTime,nDividendo,lMiliSecs) CLASS tTimeCalc

	Local cMediumTime	:= "00:00:00"
	
	Local nSeconds
	Local nMediumTime
	Local nMiliSecs
	
	DEFAULT nDividendo := 0
	
	IF (nDividendo>0)
	
		nSeconds	:= self:TimeToSecs(cTime)
		nSeconds	:= (nSeconds/nDividendo)
		nMediumTime	:= Int(nSeconds)
	
		nMiliSecs	:= (nSeconds-nMediumTime)
		nMiliSecs	*= 100
		nMiliSecs	:= Int(nMiliSecs)
	
		cMediumTime	:= self:SecsToTime(nMediumTime)
	
		DEFAULT lMiliSecs	:= .F.
		IF (;
				(lMiliSecs);
				.and.;
				(nMiliSecs>0);
			)
			cMediumTime += (":"+StrZero(nMiliSecs,02))
		EndIF
	
	EndIF

Return(cMediumTime)