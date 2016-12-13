#include "tBigNDef.ch"

#ifdef PROTHEUS
    #ifndef __ADVPL__
        #define __ADVPL__
    #endif
    #include "protheus.ch"    
#else /*__HARBOUR__*/
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif /*__HARBOUR__*/
#endif /*PROTHEUS*/

//--------------------------------------------------------------------------------------------------------
    /*
        Class:tTimeCalc
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:29/12/2013
        Descricao:Instancia um novo objeto do tipo tTimeCalc
        Sintaxe:tTimeCalc():New() -> self
    */
//--------------------------------------------------------------------------------------------------------
Class tTimeCalc

    #ifndef __ADVPL__
        EXPORTED:
    #endif

    #ifdef __HARBOUR__
        Method New() CONSTRUCTOR
    #else /*__ADVPL__*/
        Method New() CONSTRUCTOR
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method ClassName()
    #else /*__ADVPL__*/
        Method ClassName()
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method HMSToTime(nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC)
    #else /*__ADVPL__*/
        Method HMSToTime(nHours,nMinuts,nSeconds)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method SecsToHMS(nSecsToHMS AS NUMERIC,nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER)
    #else /*__ADVPL__*/
        Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method SecsToTime(nSecs AS NUMERIC)
    #else /*__ADVPL__*/
        Method SecsToTime(nSecs)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method TimeToSecs(cTime AS CHARACTER)
    #else /*__ADVPL__*/
        Method TimeToSecs(cTime)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method SecsToHrs(nSeconds AS NUMERIC)
    #else /*__ADVPL__*/
        Method SecsToHrs(nSeconds)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method HrsToSecs(nHours AS NUMERIC)
    #else /*__ADVPL__*/
        Method HrsToSecs(nHours)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method SecsToMin(nSeconds AS NUMERIC)
    #else /*__ADVPL__*/
        Method SecsToMin(nSeconds)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method MinToSecs(nMinuts AS NUMERIC)
    #else /*__ADVPL__*/
        Method MinToSecs(nMinuts)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method IncTime(cTime AS CHARACTER,nIncHours AS NUMERIC,nIncMinuts AS NUMERIC,nIncSeconds AS NUMERIC)
    #else /*__ADVPL__*/
        Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method DecTime(cTime AS CHARACTER,nDecHours AS NUMERIC,nDecMinuts AS NUMERIC,nDecSeconds AS NUMERIC)
    #else /*__ADVPL__*/
        Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method Time2NextDay(cTime AS CHARACTER,dDate AS DATE)
    #else /*__ADVPL__*/
        Method Time2NextDay(cTime,dDate)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method ExtractTime(cTime AS CHARACTER,nHours AS NUMERIC,nMinutes AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER)
    #else /*__ADVPL__*/
        Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method AverageTime(cTime AS CHARACTER,nDividendo AS NUMERIC,lMiliSecs AS LOGICAL)
    #else /*__ADVPL__*/
        Method AverageTime(cTime,nDividendo,lMiliSecs)
    #endif /*__HARBOUR__*/

EndClass

#ifdef __HARBOUR__
    Method New() Class tTimeCalc
#else /*__ADVPL__*/
    Method New() Class tTimeCalc
#endif /*__HARBOUR__*/
        Return(self)
/*Method New*/

#ifdef __ADVPL__
    Function u_tTimeCalc()
        Return(tTimeCalc():New())
    /*Function u_tTimeCalc*/
#endif /*__ADVPL__*/

#ifdef __HARBOUR__
    Method ClassName() Class tTimeCalc
#else /*__ADVPL__*/
    Method ClassName() Class tTimeCalc
#endif /*__HARBOUR__*/
        Return("TTIMECALC")
/*Method ClassName*/

#ifdef __HARBOUR__
    Method HMSToTime(nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method HMSToTime(nHours,nMinuts,nSeconds) Class tTimeCalc
#endif /*__HARBOUR__*/

        Local cTime AS CHARACTER

        #ifdef __ADVPL__
            PARAMETER nHours    AS NUMERIC
            PARAMETER nMinuts   AS NUMERIC
            PARAMETER nSeconds  AS NUMERIC
        #endif /*__ADVPL__*/

        DEFAULT nHours:=0
        cTime:=hb_ntos(nHours)

        cTime:=StrZero(Val(cTime),Max(Len(cTime),2))

        cTime+=":"

        DEFAULT nMinuts:=0
        cTime+=StrZero(Val(hb_ntos(nMinuts)),2)

        cTime+=":"

        DEFAULT nSeconds:=0
        cTime+=StrZero(Val(hb_ntos(nSeconds)),2)

        Return(cTime)
/*Method HMSToTime*/

#ifdef __HARBOUR__
    Method SecsToHMS(nSecsToHMS AS NUMERIC,nHours AS NUMERIC,nMinuts AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER) Class tTimeCalc
#else /*__ADVPL__*/
    Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) Class tTimeCalc
#endif /*__HARBOUR__*/

        Local nRet  AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER nSecsToHMS    AS NUMERIC
            PARAMETER nHours        AS NUMERIC
            PARAMETER nMinuts       AS NUMERIC
            PARAMETER nSeconds      AS NUMERIC
            PARAMETER cRet          AS CHARACTER
        #endif /*__ADVPL__*/

        DEFAULT nSecsToHMS:=0

        nHours:=self:SecsToHrs(nSecsToHMS)
        nMinuts:=self:SecsToMin(nSecsToHMS)
        nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts))
        nSeconds:=(nSecsToHMS-nSeconds)
        nSeconds:=Int(nSeconds)
        nSeconds:=Mod(nSeconds,60)

        DEFAULT cRet:="H"
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

#ifdef __HARBOUR__
    Method SecsToTime(nSecs AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method SecsToTime(nSecs) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nHours    AS NUMERIC
        Local nMinuts   AS NUMERIC
        Local nSeconds  AS NUMERIC

        #ifdef __ADVPL__

            PARAMETER nSecs AS NUMERIC

            nHours:=0
            nMinuts:=0
            nSeconds:=0

        #endif /*__ADVPL__*/

        self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
        Return(self:HMSToTime(nHours,nMinuts,nSeconds))
/*Method SecsToTime*/

#ifdef __HARBOUR__
    Method TimeToSecs(cTime AS CHARACTER) Class tTimeCalc
#else /*__ADVPL__*/
    Method TimeToSecs(cTime) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nHours    AS NUMERIC
        Local nMinuts   AS NUMERIC
        Local nSeconds  AS NUMERIC

        #ifdef __ADVPL__

            PARAMETER cTime AS CHARACTER

            nHours:=0
            nMinuts:=0
            nSeconds:=0

        #endif /*__ADVPL__*/

        DEFAULT cTime:="00:00:00"

        self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)

        nMinuts+=(nHours*60)
        nSeconds+=(nMinuts*60)

        Return(nSeconds)
/*Method TimeToSecs*/

#ifdef __HARBOUR__
    Method SecsToHrs(nSeconds AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method SecsToHrs(nSeconds) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nHours AS NUMERIC
        #ifdef __ADVPL__
            PARAMETER nSeconds AS NUMERIC
            DEFAULT nSeconds:=0
        #endif /*__ADVPL__*/
        nHours:=(nSeconds/3600)
        nHours:=Int(nHours)
        Return(nHours)
/*Method SecsToHrs*/

#ifdef __HARBOUR__
    Method HrsToSecs(nHours AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method HrsToSecs(nHours) Class tTimeCalc
        PARAMETER nHours AS NUMERIC
        DEFAULT nHours:=0
#endif /*__HARBOUR__*/
        Return((nHours*3600))
/*Method HrsToSecs*/

#ifdef __HARBOUR__
    Method SecsToMin(nSeconds AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method SecsToMin(nSeconds) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nMinuts
        #ifdef __ADVPL__
            PARAMETER nSeconds AS NUMERIC
            DEFAULT nSeconds:=0
        #endif /*__ADVPL__*/
        nMinuts:=(nSeconds/60)
        nMinuts:=Int(nMinuts)
        nMinuts:=Mod(nMinuts,60)
        Return(nMinuts)
/*Method SecsToMin*/

#ifdef __HARBOUR__
    Method MinToSecs(nMinuts AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method MinToSecs(nMinuts) Class tTimeCalc
        PARAMETER nMinuts AS NUMERIC
        DEFAULT nMinuts:=0
#endif /*__HARBOUR__*/
        Return((nMinuts*60))
/*Method MinToSecs*/

#ifdef __HARBOUR__
    Method IncTime(cTime AS CHARACTER,nIncHours AS NUMERIC,nIncMinuts AS NUMERIC,nIncSeconds AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nSeconds
        Local nMinuts
        Local nHours

        #ifdef __ADVPL__

            PARAMETER cTime         AS CHARACTER
            PARAMETER nIncHours     AS NUMERIC
            PARAMETER nIncMinuts    AS NUMERIC
            PARAMETER nIncSeconds   AS NUMERIC

            DEFAULT nSeconds:=0
            DEFAULT nMinuts:=0
            DEFAULT nHours:=0

        #endif /*__ADVPL__*/

        DEFAULT cTime:="00:00:00"
        
        self:ExtractTime(@cTime,@nHours,@nMinuts,@nSeconds)

        DEFAULT nIncHours:=0
        nHours+=nIncHours

        DEFAULT nIncMinuts:=0
        nMinuts+=nIncMinuts

        DEFAULT nIncSeconds:=0
        nSeconds+=nIncSeconds

        nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)

        Return(self:SecsToTime(nSeconds))
/*Method IncTime*/

#ifdef __HARBOUR__
    Method DecTime(cTime AS CHARACTER,nDecHours AS NUMERIC,nDecMinuts AS NUMERIC,nDecSeconds AS NUMERIC) Class tTimeCalc
#else /*__ADVPL__*/
    Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) Class tTimeCalc
#endif /*__HARBOUR__*/
        Local nSeconds  AS NUMERIC
        Local nMinuts   AS NUMERIC
        Local nHours    AS NUMERIC

        #ifdef __ADVPL__

            PARAMETER cTime         AS CHARACTER
            PARAMETER nDecHours     AS NUMERIC
            PARAMETER nDecMinuts    AS NUMERIC
            PARAMETER nDecSeconds   AS NUMERIC

            DEFAULT nSeconds:=0
            DEFAULT nMinuts:=0
            DEFAULT nHours:=0

        #endif /*__ADVPL__*/

        self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)

        DEFAULT nDecHours:=0
        nHours-=nDecHours

        DEFAULT nDecMinuts:=0
        nMinuts-=nDecMinuts

        DEFAULT nDecSeconds:=0
        nSeconds-=nDecSeconds

        nSeconds:=(self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)

        Return(self:SecsToTime(nSeconds))
/*Method DecTime*/

#ifdef __HARBOUR__
    Method Time2NextDay(cTime AS CHARACTER,dDate AS DATE) Class tTimeCalc
#else /*__ADVPL__*/
    Method Time2NextDay(cTime,dDate) Class tTimeCalc
            PARAMETER cTime AS CHARACTER
            DEFAULT cTime:="00:00:00"
            PARAMETER dDate AS DATE
            DEFAULT dDate:=Date()
#endif /*__HARBOUR__*/
        While (Val(cTime)>=24)
            cTime:=self:DecTime(cTime,24)
            ++dDate
        End While
        Return({cTime,dDate})
/*Method Time2NextDay*/

#ifdef __HARBOUR__
    Method ExtractTime(cTime AS CHARACTER,nHours AS NUMERIC,nMinutes AS NUMERIC,nSeconds AS NUMERIC,cRet AS CHARACTER) Class tTimeCalc
#else /*__ADVPL__*/
    Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet) Class tTimeCalc
#endif /*__HARBOUR__*/

        Local nRet  AS NUMERIC

        Local nAT   AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER cTime     AS CHARACTER
            PARAMETER nHours    AS NUMERIC
            PARAMETER nMinutes  AS NUMERIC
            PARAMETER nSeconds  AS NUMERIC
            PARAMETER cRet      AS CHARACTER
        #endif /*__ADVPL__*/

        DEFAULT cTime:="00:00:00"

        nAT:=AT(":",cTime)

        IF (nAT==0)
            nHours:=Val(cTime)
            nMinutes:=0
            nSeconds:=0
        Else
            nHours:=Val(SubStr(cTime,1,nAT-1))
            cTime:=SubStr(cTime,nAT+1)
            nAT:=(At(":",cTime))
            IF (nAT==0)
                nMinutes:=Val(cTime)
                nSeconds:=0
            Else
                nMinutes:=Val(SubStr(cTime,1,nAT-1))
                nSeconds:=Val(SubStr(cTime,nAT+1))
            EndIF
        EndIF

        DEFAULT cRet:="H"
        IF (cRet$"Hh")
            nRet:=nHours
        ElseIF (cRet$"Mm")
            nRet:=nMinutes
        ElseIF (cRet$"Ss")
            nRet:=nSeconds
        Else
            DEFAULT nRet:=0
        EndIF

        Return(nRet)
/*Method ExtractTime*/

#ifdef __HARBOUR__
    Method AverageTime(cTime AS CHARACTER,nDividendo AS NUMERIC,lMiliSecs AS LOGICAL) Class tTimeCalc
#else /*__ADVPL__*/
    Method AverageTime(cTime,nDividendo,lMiliSecs) Class tTimeCalc
#endif /*__HARBOUR__*/

        Local cAverageTime  AS CHARACTER

        Local nSeconds      AS NUMERIC
        Local nAverageTime  AS NUMERIC
        Local nMiliSecs     AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER cTime         AS CHARACTER
            PARAMETER nDividendo    AS NUMERIC
            PARAMETER lMiliSecs     AS LOGICAL
        #endif /*__ADVPL__*/

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
