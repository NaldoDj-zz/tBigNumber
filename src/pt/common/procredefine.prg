#ifndef _pt_ProcRedefine_CH
    #define _pt_ProcRedefine_CH
    #include "totvs.ch"
    static function ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW)
        local aClassData
        local laMeter
        local nObj
        local nMeter
        local nMeters
        local lProcRedefine:=.F.
        if (valType(oProcess)=="O")
            aClassData:=ClassDataArr(oProcess,.T.)
            laMeter:=(aScan(aClassData,{|e|e[1]=="AMETER"})>0)
            if (laMeter)
                DEFAULT oFont:=TFont():New("Lucida Console",NIL,12,NIL,.T.)
                DEFAULT nLeft:=40
                DEFAULT nWidth:=80
                nMeters:=Len(oProcess:aMeter)
                For nMeter:=1 To nMeters
                    For nObj:=1 To 2
                        oProcess:aMeter[nMeter][nObj]:oFont:=oFont
                        oProcess:aMeter[nMeter][nObj]:nWidth+=nWidth
                        oProcess:aMeter[nMeter][nObj]:nLeft-=nLeft
                    Next nObj
                Next nMeter
            else
                DEFAULT oFont:=TFont():New("Lucida Console",NIL,18,NIL,.T.)
                DEFAULT lODlgF:=.T.
                DEFAULT lODlgW:=.F.
                DEFAULT nLeft:=100
                DEFAULT nWidth:=200
                DEFAULT nCTLFLeft:=if(lODlgW,nWidth,nWidth/2)
                if (lODlgF)
                    oProcess:oDlg:oFont:=oFont
                endif
                if (lODlgW)
                    oProcess:oDlg:nWidth+=nWidth
                    oProcess:oDlg:nLeft-=(nWidth/2)
                endif
                oProcess:oMsg1:oFont:=oFont
                oProcess:oMsg2:oFont:=oFont
                oProcess:oMsg1:nLeft-=nLeft
                oProcess:oMsg1:nWidth+=nWidth
                oProcess:oMsg2:nLeft-=nLeft
                oProcess:oMsg2:nWidth+=nWidth
                oProcess:oMeter1:nWidth+=nWidth
                oProcess:oMeter1:nLeft-=nLeft
                oProcess:oMeter2:nWidth+=nWidth
                oProcess:oMeter2:nLeft-=nLeft
                if (valType(oProcess:oDlg:oCTLFocus)=="O")
                    oProcess:oDlg:oCTLFocus:nLeft+=nCTLFLeft
                endif
                oProcess:oDlg:Refresh(.T.)
            endif
            lProcRedefine:=.T.
        endif
    return(lProcRedefine)
    static procedure SetBlind(lIsBlind)
        DEFAULT lIsBlind:= .F.
        IF ( lIsBlind )
            __cINTERNET:="AUTOMATICO"
        Else
            __cINTERNET:=NIL
        EndIF
        IF (Type("oApp")=="O")
            oApp:lIsBlind:=lIsBlind
            oApp:cInternet:=__cINTERNET
        EndIF
        __cBinder:=__cINTERNET
    return 
#endif /*_pt_ProcRedefine_CH*/
