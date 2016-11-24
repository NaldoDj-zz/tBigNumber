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
    Method HMSToTime(nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC)
    Method SecsToHMS(nSecsToHMS AS NUMERIC,nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER)
    Method SecsToTime(nSecs AS NUMERIC)
    Method TimeToSecs(cTime AS CHARACTER)
    Method SecsToHrs(nSeconds AS NUMERIC)
    Method HrsToSecs(nHours AS NUMERIC)
    Method SecsToMin(nSeconds AS NUMERIC)
    Method MinToSecs(nMinuts AS NUMERIC)
    Method IncTime(cTime AS CHARACTER,nIncHours AS NUMERIC,nIncMinuts AS NUMERIC,nIncSeconds AS NUMERIC)
    Method DecTime(cTime AS CHARACTER,nDecHours AS NUMERIC,nDecMinuts AS NUMERIC,nDecSeconds AS NUMERIC)
    Method Time2NextDay(cTime AS CHARACTER,dDate AS DATE)
    Method ExtractTime(cTime AS CHARACTER,nHours AS NUMERIC,nMinutes AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER)
    Method AverageTime(cTime AS CHARACTER,nDividendo AS NUMERIC,lMiliSecs AS LOGICAL)
EndClass

Method New() Class tTimeCalc
    Return(self)
/*Method New*/

#ifdef __PROTHEUS__
    Function u_tTimeCalc()
        Return(tTimeCalc():New())
    /*Function u_tTimeCalc*/
#endif

Method ClassName() Class tTimeCalc
    Return("TTIMECALC")
/*Method ClassName*/

Method HMSToTime(nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC) Class tTimeCalc

    Local cTime AS CHARACTER

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
/*Method HMSToTime*/

Method SecsToHMS(nSecsToHMS AS NUMERIC,nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER) Class tTimeCalc

    Local nRet  AS NUMERIC

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
    Else
        nRet:=0
    EndIF

    Return(nRet)
/*Method SecsToHMS*/

Method SecsToTime(nSecs AS NUMERIC) Class tTimeCalc
    Local nHours    AS NUMERIC
    Local nMinuts   AS NUMERIC
    Local nSeconds  AS NUMERIC
    self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
    Return(self:HMSToTime(nHours,nMinuts,nSeconds))
/*Method SecsToTime*/

Method TimeToSecs(cTime AS CHARACTER) Class tTimeCalc

    Local nHours    AS NUMERIC
    Local nMinuts   AS NUMERIC
    Local nSeconds  AS NUMERIC

    DEFAULT cTime:="00:00:00"

    self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)

    nMinuts+=(nHours*60)
    nSeconds+=(nMinuts*60)

    Return(nSeconds)
/*Method TimeToSecs*/

Method SecsToHrs(nSeconds AS NUMERIC) Class tTimeCalc
    Local nHours AS NUMERIC
    nHours:=(nSeconds/3600)
    nHours:=Int(nHours)
    Return(nHours)
/*Method SecsToHrs*/

Method HrsToSecs(nHours AS NUMERIC) Class tTimeCalc
    Return((nHours*3600))
/*Method HrsToSecs*/

Method SecsToMin(nSeconds AS NUMERIC) Class tTimeCalc
    Local nMinuts
    nMinuts:=(nSeconds/60)
    nMinuts:=Int(nMinuts)
    nMinuts:=Mod(nMinuts,60)
    Return(nMinuts)
/*Method SecsToMin*/

Method MinToSecs(nMinuts AS NUMERIC) Class tTimeCalc
    Return((nMinuts*60))
/*Method MinToSecs*/

Method IncTime(cTime AS CHARACTER,nIncHours AS NUMERIC,nIncMinuts AS NUMERIC,nIncSeconds AS NUMERIC) Class tTimeCalc

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
/*Method IncTime*/

Method DecTime(cTime AS CHARACTER,nDecHours AS NUMERIC,nDecMinuts AS NUMERIC,nDecSeconds AS NUMERIC) Class tTimeCalc

    Local nSeconds  AS NUMERIC
    Local nMinuts   AS NUMERIC
    Local nHours    AS NUMERIC

    DEFAULT nDecHours:=0
    DEFAULT nDecMinuts:=0
    DEFAULT nDecSeconds:=0

    self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)

    nHours-=nDecHours
    nMinuts-=nDecMinuts
    nSeconds-=nDecSeconds
    nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)

    Return(self:SecsToTime(nSeconds))
/*Method DecTime*/

Method Time2NextDay(cTime AS CHARACTER,dDate AS DATE) Class tTimeCalc
    While (Val(cTime)>=24)
        cTime:=self:DecTime(cTime,24)
        ++dDate
    End While
    Return({cTime,dDate})
/*Method Time2NextDay*/

Method ExtractTime(cTime AS CHARACTER,nHours AS NUMERIC,nMinutes AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER) Class tTimeCalc

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
/*Method ExtractTime*/


Method AverageTime(cTime AS CHARACTER,nDividendo AS NUMERIC,lMiliSecs AS LOGICAL) Class tTimeCalc

    Local cAverageTime  AS CHARACTER

    Local nSeconds      AS NUMERIC
    Local nAverageTime  AS NUMERIC
    Local nMiliSecs     AS NUMERIC

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
        DEFAULT cAverageTime:="00:00:00"
        cAverageTime+=(":"+StrZero(nMiliSecs,IF(nMiliSecs>999,4,3)))
    EndIF

    Return(cAverageTime)
 /*Method AverageTime*/
