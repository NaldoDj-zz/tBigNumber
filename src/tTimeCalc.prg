#ifdef PROTHEUS
    #define __PROTHEUS__
    #include "protheus.ch"
#else
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif
#endif
#include "tBigNumber.ch"
Class tTimeCalc
#ifndef __PROTHEUS__
    EXPORTED:
#endif    
    Method New() CONSTRUCTOR
    Method ClassName()    
    Method HMSToTime(nHours,nMinuts,nSeconds)
    Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
    Method SecsToTime(nSecs)
    Method TimeToSecs(cTime)
    Method SecsToHrs(nSeconds)
    Method HrsToSecs(nHours)
    Method SecsToMin(nSeconds)
    Method MinToSecs(nMinuts)
    Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
    Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
    Method Time2NextDay(cTime,dDate)
    Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet)
    Method AverageTime(cTime,nDividendo,lMiliSecs)
EndClass

Method New() Class tTimeCalc
Return(self)

Method ClassName() Class tTimeCalc
Return("TTIMECALC")

Method HMSToTime(nHours,nMinuts,nSeconds) Class tTimeCalc

    Local cTime
    
    DEFAULT nHours:=0
    DEFAULT nMinuts:=0
    DEFAULT nSeconds:=0
        
    cTime:=hb_ntos(nHours)
    cTime:=StrZero(Val(cTime),Max(Len(cTime),2))
    cTime+=":"
    cTime+=StrZero(Val(hb_ntos(nMinuts)),2)
    cTime+=":"
    cTime+=StrZero(Val(hb_ntos(nSeconds)),2)

Return(cTime)

Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) Class tTimeCalc

    Local nRet:=0
    
    DEFAULT nSecsToHMS:=0
    DEFAULT cRet:="H"
    
    nHours:=self:SecsToHrs(nSecsToHMS)
    nMinuts:=self:SecsToMin(nSecsToHMS)
    nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts))
    nSeconds:=(nSecsToHMS-nSeconds)
    nSeconds:=Int(nSeconds)
    nSeconds:=Mod(nSeconds,60)
    
    IF (cRet$"Hh")
        nRet:=nHours
    ElseIF (cRet$"Mm")
        nRet:=nMinuts
    ElseIF (cRet$"Ss")
        nRet:=nSeconds
    EndIF

Return(nRet)

Method SecsToTime(nSecs) Class tTimeCalc
    Local nHours
    Local nMinuts
    Local nSeconds
    self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
Return(self:HMSToTime(nHours,nMinuts,nSeconds))

Method TimeToSecs(cTime) Class tTimeCalc

    Local nHours
    Local nMinuts
    Local nSeconds
    
    DEFAULT cTime:="00:00:00"
    
    self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
    
    nMinuts+=(nHours*60)
    nSeconds+=(nMinuts*60)

Return(nSeconds)

Method SecsToHrs(nSeconds) Class tTimeCalc
    Local nHours
    nHours:=(nSeconds/3600)
    nHours:=Int(nHours)
Return(nHours)

Method HrsToSecs(nHours) Class tTimeCalc
Return((nHours*3600))

Method SecsToMin(nSeconds) Class tTimeCalc
    Local nMinuts
    nMinuts:=(nSeconds/60)
    nMinuts:=Int(nMinuts)
    nMinuts:=Mod(nMinuts,60)
Return(nMinuts)

Method MinToSecs(nMinuts) Class tTimeCalc
Return((nMinuts*60))

Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) Class tTimeCalc

    Local nSeconds
    Local nMinuts
    Local nHours
    
    DEFAULT nIncHours:=0
    DEFAULT nIncMinuts:=0
    DEFAULT nIncSeconds:=0
    
    self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
    
    nHours+=nIncHours
    nMinuts+=nIncMinuts
    nSeconds+=nIncSeconds
    nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
    
Return(self:SecsToTime(nSeconds))

Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) Class tTimeCalc

    Local nSeconds
    Local nMinuts
    Local nHours
    
    DEFAULT nDecHours:=0
    DEFAULT nDecMinuts:=0
    DEFAULT nDecSeconds:=0
    
    self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
    
    nHours-=nDecHours
    nMinuts-=nDecMinuts
    nSeconds-=nDecSeconds
    nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
    
Return(self:SecsToTime(nSeconds))

Method Time2NextDay(cTime,dDate) Class tTimeCalc
    While (Val(cTime)>=24)
        cTime:=self:DecTime(cTime,24)
        ++dDate
    End While
Return({cTime,dDate})

Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet) Class tTimeCalc

    Local nRet:=0
    
    Local nAT
    
    DEFAULT cTime:="00:00:00"
    DEFAULT cRet:="H"
    
    nAT:=AT(":",cTime)
    
    IF (nAT ==0)
        nHours:=Val(cTime)
        nMinutes:=0
        nSeconds:=0
    Else
        nHours:=Val(SubStr(cTime,1,nAT-1))
        cTime:=SubStr(cTime,nAT+1)
        nAT:=(At(":",cTime))
        IF (nAT ==0)
            nMinutes:=Val(cTime)
            nSeconds:=0
        Else
            nMinutes:=Val(SubStr(cTime,1,nAT-1))
            nSeconds:=Val(SubStr(cTime,nAT+1))
        EndIF
    EndIF
    
    IF (cRet$"Hh")
        nRet:=nHours
    ElseIF (cRet$"Mm")
        nRet:=nMinutes
    ElseIF (cRet$"Ss")
        nRet:=nSeconds
    EndIF

Return(nRet)

Method AverageTime(cTime,nDividendo,lMiliSecs) Class tTimeCalc

    Local cAverageTime:="00:00:00:000"
    
    Local nSeconds
    Local nAverageTime
    Local nMiliSecs
    
    DEFAULT nDividendo:=0
    
    IF (nDividendo>0)
    
        nSeconds:=self:TimeToSecs(cTime)
        nSeconds:=(nSeconds/nDividendo)
        nAverageTime:=Int(nSeconds)
    
        nMiliSecs:=(nSeconds-nAverageTime)
        nMiliSecs*=1000
        nMiliSecs:=Int(nMiliSecs)
    
        cAverageTime:=self:SecsToTime(nAverageTime)

    EndIF
    
    DEFAULT lMiliSecs:=.T.
    IF (lMiliSecs)
        DEFAULT nMiliSecs:=0
         cAverageTime+=(":"+StrZero(nMiliSecs,IF(nMiliSecs>999,4,3)))
    EndIF

Return(cAverageTime)