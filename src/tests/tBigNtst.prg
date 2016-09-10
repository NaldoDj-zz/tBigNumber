//--------------------------------------------------------------------------------------------------------
    /*
        TODO:
        (1) core/tests/gtwin.prg         (1/1)
        (2) Main thread GT/Tests Monitor (0/1)
        (3) Configure tests              (1/1)
        (4) tBigNThread.prg              (1/1)
        (4.1) hb_ExecFromArray()         (1/1)
        (5) tBigNSleep.prg               (1/1)
        (6) log file name                (1/1)
*/
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    //--------------------------------------------------------------------------------------------------------
        #pragma -w2
    //--------------------------------------------------------------------------------------------------------
        #require "hbvmmt"
        request HB_MT
    //--------------------------------------------------------------------------------------------------------
        #include "inkey.ch"
        #include "setcurs.ch"
        #include "hbgtinfo.ch"
    //--------------------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------------------
        MEMVAR nACC_SET
        MEMVAR nROOT_ACC_SET
        MEMVAR nACC_ALOG
        MEMVAR __nSLEEP
        MEMVAR nN_TEST
        MEMVAR aC_OOPROGRESS
        MEMVAR lL_OOPROGRAND
        MEMVAR lL_ROPROGRESS
        MEMVAR lL_LOGPROCESS
        MEMVAR cC_GT_MODE
        MEMVAR aAC_TSTEXEC
        MEMVAR cCN_MERSENNE_POW
        MEMVAR __oRTime1
        MEMVAR __oRTime2
        MEMVAR __nMaxRow
        MEMVAR __nMaxCol
        MEMVAR __nCol
        MEMVAR __nRow
        MEMVAR __noProgress
        MEMVAR __oRTimeProc
        MEMVAR __phMutex
        MEMVAR nISQRT
        MEMVAR __CRLF
        MEMVAR __cSep
        MEMVAR lDispML
    //--------------------------------------------------------------------------------------------------------
#endif //__HARBOUR__
//--------------------------------------------------------------------------------------------------------
#include "tBigNtst.ch"
#include "tBigNumber.ch"
#include "paramtypex.ch"
//--------------------------------------------------------------------------------------------------------
#define ACC_SET           "50"
#define ROOT_ACC_SET      "50"
#define ACC_ALOG          "50"
#define __SLEEP         "0.05"
#define N_TEST          "1000"
#define C_OOPROGRESS    "RANDOM,INCREMENT,DECREMENT,DISJUNCTION,UNION,DISPERSION,SHUTTLE,JUNCTION,OCCULT"
#define L_OOPROGRAND       "0"
#define L_ROPROGRESS       "0"
#define L_LOGPROCESS       "1"
#define C_GT_MODE          "ST"
#define AC_TSTEXEC        "1:17,-18,19:37"
#define CN_MERSENNE_POW      "2"
//--------------------------------------------------------------------------------------------------------
#define __SETDEC__         16
#define __NRTTST__         37
#define __PADL_T__          2
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Function Main()

        Local aSect
        Local aScreen
        Local atBigNtst

        Local cIni:="tBigNtst.ini"
        Local hIni:=hb_iniRead(cIni)

        Local cKey
        Local cSection
        Local cChrDOut
        Local cDispOut

        Local nRow
        Local nCol
        Local nSRow
        Local nSCol
        Local nScreen
        Local nMaxScrRow
        Local nMaxScrCol
        Local nSMaxScrRow
        Local nSMaxScrCol
        Local nTMaxRolCol

        Local lChangeC
        Local lFinalize
        Local ptftBigtstThread
        Local ptttBigtstThread

        CLS

        #ifdef __ALT_D__    // Compile with -b
            AltD(1)         // Enables the debugger. Press F5 to go.
            AltD()          // Invokes the debugger
        #endif

        Private nACC_SET
        Private nROOT_ACC_SET
        Private nACC_ALOG
        Private __nSLEEP
        Private nN_TEST
        Private aC_OOPROGRESS
        Private lL_OOPROGRAND
        Private lL_ROPROGRESS
        Private lL_LOGPROCESS
        Private cC_GT_MODE
        Private aAC_TSTEXEC
        Private cCN_MERSENNE_POW
        Private lDispML:=.T.

        #ifdef __HBSHELL_USR_DEF_GT
            hbshell_gtSelect(HBSHELL_GTSELECT)
        #endif

        IF .NOT.(File(cIni)).or. Empty(hIni)
            hIni["GENERAL"]:=hb_Hash()
            hIni["GENERAL"]["ACC_SET"]:=ACC_SET
            hIni["GENERAL"]["ROOT_ACC_SET"]:=ROOT_ACC_SET
            hIni["GENERAL"]["ACC_ALOG"]:=ACC_ALOG
            hIni["GENERAL"]["__SLEEP"]:=__SLEEP
            hIni["GENERAL"]["N_TEST"]:=N_TEST
            hIni["GENERAL"]["C_OOPROGRESS"]:=C_OOPROGRESS
            hIni["GENERAL"]["L_OOPROGRAND"]:=L_OOPROGRAND
            hIni["GENERAL"]["L_ROPROGRESS"]:=L_ROPROGRESS
            hIni["GENERAL"]["L_LOGPROCESS"]:=L_LOGPROCESS
            hIni["GENERAL"]["C_GT_MODE"]:=C_GT_MODE
            hIni["GENERAL"]["AC_TSTEXEC"]:=AC_TSTEXEC
            hIni["GENERAL"]["CN_MERSENNE_POW"]:=CN_MERSENNE_POW
            hb_iniWrite(cIni,hIni,"#tBigNtst.ini","#End of file")
        Else
            FOR EACH cSection IN hIni:Keys
                aSect:=hIni[cSection]
                FOR EACH cKey IN aSect:Keys
                    SWITCH Upper(cKey)
                        CASE "ACC_SET"
                            nACC_SET:=Val(aSect[cKey])
                            EXIT
                        CASE "ROOT_ACC_SET"
                            nROOT_ACC_SET:=Val(aSect[cKey])
                            EXIT
                        CASE "ACC_ALOG"
                            nACC_ALOG:=Val(aSect[cKey])
                            EXIT
                        CASE "__SLEEP"
                            __nSLEEP:=Val(aSect[cKey])
                            EXIT
                        CASE "N_TEST"
                            nN_TEST:=Val(aSect[cKey])
                            EXIT
                        CASE "C_OOPROGRESS"
                            aC_OOPROGRESS:=_StrToKArr(Upper(AllTrim(aSect[cKey])),",")
                            EXIT
                        CASE "L_OOPROGRAND"
                            lL_OOPROGRAND:=(aSect[cKey]=="1")
                            EXIT
                        CASE "L_ROPROGRESS"
                            lL_ROPROGRESS:=(aSect[cKey]=="1")
                            EXIT
                        CASE "L_LOGPROCESS"
                            lL_LOGPROCESS:=(aSect[cKey]=="1")
                            EXIT
                        CASE "C_GT_MODE"
                            cC_GT_MODE:=Upper(AllTrim(aSect[cKey]))
                            EXIT
                        CASE "AC_TSTEXEC"
                            aAC_TSTEXEC:=_StrToKArr(AllTrim(aSect[cKey]),",")
                            EXIT
                        CASE "CN_MERSENNE_POW"
                            cCN_MERSENNE_POW:=AllTrim(aSect[cKey])
                            EXIT
                    ENDSWITCH
                NEXT cKey
            NEXT cSection
        EndIF

        nACC_SET:=IF(Empty(nACC_SET),Val(ACC_SET),nACC_SET)
        nROOT_ACC_SET:=IF(Empty(nROOT_ACC_SET),Val(ROOT_ACC_SET),nROOT_ACC_SET)
        nACC_ALOG:=IF(Empty(nACC_ALOG),Val(ACC_ALOG),nACC_ALOG)
        __nSLEEP:=IF(Empty(__nSLEEP),Val(__SLEEP),__nSLEEP)
        nN_TEST:=IF(Empty(nN_TEST),Val(N_TEST),nN_TEST)
        aC_OOPROGRESS:=IF(Empty(aC_OOPROGRESS),_StrToKArr(Upper(AllTrim(C_OOPROGRESS)),","),aC_OOPROGRESS)
        lL_OOPROGRAND:=IF(Empty(lL_OOPROGRAND),L_OOPROGRAND=="1",lL_OOPROGRAND)
        lL_ROPROGRESS:=IF(Empty(lL_ROPROGRESS),L_ROPROGRESS=="1",lL_ROPROGRESS)
        lL_LOGPROCESS:=IF(Empty(lL_LOGPROCESS),L_LOGPROCESS=="1",lL_LOGPROCESS)
        cC_GT_MODE:=IF(Empty(cC_GT_MODE),C_GT_MODE,cC_GT_MODE)
        aAC_TSTEXEC:=IF(Empty(aAC_TSTEXEC),_StrToKArr(AllTrim(AC_TSTEXEC),","),aAC_TSTEXEC)
        cCN_MERSENNE_POW:=IF(Empty(cCN_MERSENNE_POW),CN_MERSENNE_POW,cCN_MERSENNE_POW)

        __SetCentury("ON")
        SET DATE TO BRITISH

        __nSLEEP:=Min(__nSLEEP,10)
        IF ((__nSLEEP)>10)
            __nSLEEP/=10
        EndIF

        /* set OEM font encoding for non unicode modes*/
        hb_gtInfo(HB_GTI_CODEPAGE,255)
        /* set EN CP-437 encoding*/
        hb_cdpSelect("EN")
        hb_setTermCP("EN")
        /* set font name*/
        *hb_gtInfo(HB_GTI_FONTNAME,"Ms LineDraw"/*"Consolas"*//*"Ms LineDraw"*//*"Lucida Console"*/)
        /* set font size*/
        hb_gtInfo(HB_GTI_FONTWIDTH,6+4)
        hb_gtInfo(HB_GTI_FONTSIZE,12+4)
        /* resize console window using new font size*/
        SetMode(MaxRow()+1,MaxCol()+1)
        /* get screen dimensions*/
        nMaxScrRow:=hb_gtInfo(HB_GTI_DESKTOPROWS)
        nMaxScrCol:=hb_gtInfo(HB_GTI_DESKTOPCOLS)
        /* resize console window to the screen size*/
        SetMode(nMaxScrRow,nMaxScrCol)
        /* set window title*/
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br]")
        hb_gtInfo(HB_GTI_ICONRES,"Main")

        ChkIntTstExec(@aAC_TSTEXEC,__PADL_T__)
        atBigNtst:=GettBigNtst(cC_GT_MODE,aAC_TSTEXEC)

        IF (cC_GT_MODE=="MT")

            lFinalize:=.F.

            ptftBigtstThread:=@tBigtstThread()

            ptttBigtstThread:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
            ptftBigtstThread,@lFinalize,atBigNtst,nMaxScrRow,nMaxScrCol)

            nRow:=Row()
            nCol:=Col()

            nScreen:=0
            lChangeC:=.F.
            cChrDOut:=Chr(254)
            cDispOut:=cChrDOut
            nSMaxScrRow:=(nMaxScrRow+1)
            nSMaxScrCol:=(nMaxScrCol+1)
            nTMaxRolCol:=(nSMaxScrRow*nSMaxScrCol)
            aScreen:=Array(nSMaxScrRow,nSMaxScrCol)
            aEval(aScreen,{|x|aFill(x,.T.)})

            While .NOT.(lFinalize)
 #ifdef __0
                IF(++nCol>=nMaxScrCol)
                    IF (++nRow>=nMaxScrRow)
                        nRow:=0
                    EndIF
                    nCol:=0
                EndIF
                nRow:=HB_RandomInt(nRow,nMaxScrRow)
                nCol:=HB_RandomInt(nCol,nMaxScrCol)
#else
                nRow:=HB_RandomInt(0,nMaxScrRow)
                nCol:=HB_RandomInt(0,nMaxScrCol)
#endif //__0
                nSRow:=(nRow+1)
                nSCol:=(nCol+1)
                if (aScreen[nSRow][nSCol])
                    nScreen:=0
                    lChangeC:=.not.(lChangeC)
                    DispOutAT(nRow,nCol,cDispOut,if(lChangeC,"w+/n","w+/n"))
                    aScreen[nSRow][nSCol]:=.F.
                    aEval(aScreen,{|x|aEval(x,{|y|nScreen+=if(y,0,1)})})
                    if (nScreen==nTMaxRolCol)
                        cDispOut:=if(cDispOut==cChrDOut," ",cChrDOut)
                        aEval(aScreen,{|x|aFill(x,.T.)})
                    endif
                endif
            End While

            hb_threadQuitRequest(ptttBigtstThread)
            hb_ThreadWait(ptttBigtstThread)
            tBigNGC()

        Else

            tBigNtst(atBigNtst)

        EndIF

    Return(0)
    //--------------------------------------------------------------------------------------------------------
    static procedure tBigtstThread(lFinalize,atBigNtst,nMaxScrRow,nMaxScrCol)

        Local oThreads

        Local nThAT
        Local nThread

        Local nThreads:=0

        aEval(atBigNtst,{|e|if(e[2],++nThreads,NIL)})

        IF (nThreads>0)
            //"Share publics and privates with child threads."
            oThreads:=tBigNThread():New()
            oThreads:Start(nThreads,HB_THREAD_INHERIT_MEMVARS)
            nThAT:=0
            While ((nThAT:=aScan(atBigNtst,{|e|e[2]},nThAT+1))>0)
                nThread:=nThreads
                oThreads:setEvent(nThread,{@tBigtstEval(),atBigNtst[nThAT],nMaxScrRow,nMaxScrCol})
                --nThreads
            End While
            oThreads:Notify()
            oThreads:Wait()
            oThreads:Join()
        EndIF

        lFinalize:=.T.

    Return

    Static Function tBigtstEval(atBigNtst,nMaxScrRow,nMaxScrCol)
        Local pGT:=hb_gtSelect(atBigNtst[3])
        hb_gtInfo(HB_GTI_ICONRES,"AppIcon")
        /* set OEM font encoding for non unicode modes*/
        hb_gtInfo(HB_GTI_CODEPAGE,255)
        /* set EN CP-437 encoding*/
        hb_cdpSelect("EN")
        hb_setTermCP("EN")
        /* set font size*/
        hb_gtInfo(HB_GTI_FONTWIDTH,6+4)
        hb_gtInfo(HB_GTI_FONTSIZE,12+4)
        /* resize console window to the screen size*/
        SetMode(nMaxScrRow,nMaxScrCol)
        /* set window title*/
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br]")
        tBigNtst({atBigNtst})
        hb_gtSelect(pGT)
        hb_gtInfo(HB_GTI_ICONRES,"Main")
        atBigNtst[3]:=NIL
        tBigNGC()
    Return(.T.)
    //--------------------------------------------------------------------------------------------------------
    Static Procedure tBigNtst(atBigNtst)

#else /* __PROTHEUS__*/
    //--------------------------------------------------------------------------------------------------------
    #xtranslate ExeName() => ProcName()
    //----------------------------------------------------------
    //Obs.: TAMANHO MAXIMO DE UMA STRING NO PROTHEUS 1.048.575
    //      (1.048.575+1)->String size overflow!
    //      Harbour -> no upper limit

    User Function tBigNtst()

        Local atBigNtst
        Local cIni:="tBigNtst.ini"
        Local otFIni

        Private nACC_SET
        Private nROOT_ACC_SET
        Private nACC_ALOG
        Private __nSLEEP
        Private nN_TEST
        Private aC_OOPROGRESS
        Private lL_OOPROGRAND
        Private lL_ROPROGRESS
        Private lL_LOGPROCESS
        Private cC_GT_MODE
        Private aAC_TSTEXEC
        Private cCN_MERSENNE_POW

        IF FindFunction("U_TFINI") //NDJLIB020.PRG
            otFIni:=U_TFINI(cIni)
            IF .NOT.File(cIni)
                otFIni:AddNewSession("GENERAL")
                otFIni:AddNewProperty("GENERAL","ACC_SET",ACC_SET)
                otFIni:AddNewProperty("GENERAL","ROOT_ACC_SET",ROOT_ACC_SET)
                otFIni:AddNewProperty("GENERAL","ACC_ALOG",ACC_ALOG)
                otFIni:AddNewProperty("GENERAL","__SLEEP",__SLEEP)
                otFIni:AddNewProperty("GENERAL","N_TEST",N_TEST)
                otFIni:AddNewProperty("GENERAL","C_OOPROGRESS",C_OOPROGRESS)
                otFIni:AddNewProperty("GENERAL","L_OOPROGRAND",L_OOPROGRAND)
                otFIni:AddNewProperty("GENERAL","L_ROPROGRESS",L_ROPROGRESS)
                otFIni:AddNewProperty("GENERAL","L_LOGPROCESS",L_LOGPROCESS)
                otFIni:AddNewProperty("GENERAL","C_GT_MODE",C_GT_MODE)
                otFIni:AddNewProperty("GENERAL","AC_TSTEXEC",AC_TSTEXEC)
                otFIni:AddNewProperty("GENERAL","CN_MERSENNE_POW",CN_MERSENNE_POW)
                otFIni:SaveAs(cIni)
            Else
                nACC_SET:=Val(oTFINI:GetPropertyValue("GENERAL","ACC_SET",ACC_SET))
                nROOT_ACC_SET:=Val(oTFINI:GetPropertyValue("GENERAL","ROOT_ACC_SET",ROOT_ACC_SET))
                nACC_ALOG:=Val(oTFINI:GetPropertyValue("GENERAL","ACC_ALOG",ACC_ALOG))
                __nSLEEP:=Val(oTFINI:GetPropertyValue("GENERAL","__SLEEP",__SLEEP))
                nN_TEST:=Val(oTFINI:GetPropertyValue("GENERAL","N_TEST",N_TEST))
                aC_OOPROGRESS:=_StrToKArr(Upper(AllTrim(oTFINI:GetPropertyValue("GENERAL","C_OOPROGRESS",C_OOPROGRESS))),",")
                lL_OOPROGRAND:=(oTFINI:GetPropertyValue("GENERAL","L_OOPROGRAND",L_OOPROGRAND)=="1")
                lL_ROPROGRESS:=(oTFINI:GetPropertyValue("GENERAL","L_ROPROGRESS",L_ROPROGRESS)=="1")
                lL_LOGPROCESS:=(oTFINI:GetPropertyValue("GENERAL","L_LOGPROCESS",L_LOGPROCESS)=="1")
                cC_GT_MODE:=Upper(AllTrim(oTFINI:GetPropertyValue("GENERAL","C_GT_MODE",C_GT_MODE)))
                aAC_TSTEXEC:=_StrToKArr(AllTrim(oTFINI:GetPropertyValue("GENERAL","AC_TSTEXEC",AC_TSTEXEC)),",")
                cCN_MERSENNE_POW:=AllTrim(oTFINI:GetPropertyValue("GENERAL","CN_MERSENNE_POW",CN_MERSENNE_POW))
            EndIF
        EndIF

        nACC_SET:=IF(Empty(nACC_SET),Val(ACC_SET),nACC_SET)
        nROOT_ACC_SET:=IF(Empty(nROOT_ACC_SET),Val(ROOT_ACC_SET),nROOT_ACC_SET)
        nACC_ALOG:=IF(Empty(nACC_ALOG),Val(ACC_ALOG),nACC_ALOG)
        __nSLEEP:=IF(Empty(__nSLEEP),Val(__SLEEP),__nSLEEP)
        nN_TEST:=IF(Empty(nN_TEST),Val(N_TEST),nN_TEST)
        aC_OOPROGRESS:=IF(Empty(aC_OOPROGRESS),_StrToKArr(Upper(AllTrim(C_OOPROGRESS)),","),aC_OOPROGRESS)
        lL_OOPROGRAND:=IF(Empty(lL_OOPROGRAND),L_OOPROGRAND=="1",lL_OOPROGRAND)
        lL_ROPROGRESS:=IF(Empty(lL_ROPROGRESS),L_ROPROGRESS=="1",lL_ROPROGRESS)
        lL_LOGPROCESS:=IF(Empty(lL_LOGPROCESS),L_LOGPROCESS=="1",lL_LOGPROCESS)
        cC_GT_MODE:=IF(Empty(cC_GT_MODE),C_GT_MODE,cC_GT_MODE)
        aAC_TSTEXEC:=IF(Empty(aAC_TSTEXEC),_StrToKArr(AllTrim(AC_TSTEXEC),","),aAC_TSTEXEC)
        cCN_MERSENNE_POW:=IF(Empty(cCN_MERSENNE_POW),CN_MERSENNE_POW,cCN_MERSENNE_POW)
        __nSLEEP:=Max(__nSLEEP,10)

        IF ((__nSLEEP)<10)
            __nSLEEP*=10
        EndIF

    ChkIntTstExec(@aAC_TSTEXEC,__PADL_T__)
    atBigNtst:=GettBigNtst(cC_GT_MODE,aAC_TSTEXEC)

    Return(tBigNtst(@atBigNtst))
    //--------------------------------------------------------------------------------------------------------
    Static Procedure tBigNtst(atBigNtst)

#endif /* __PROTHEUS__*/

    #ifdef __HARBOUR__
        Local tsBegin:=HB_DATETIME()
        Local nsElapsed
    #endif

        Local dStartDate AS DATE      VALUE Date()
        Local dEndDate
        Local cStartTime AS CHARACTER VALUE Time()
        Local cEndTime   AS CHARACTER

    #ifdef __HARBOUR__
        Local cFld       AS CHARACTER VALUE tbNCurrentFolder()+hb_ps()+"tbigN_log"+hb_ps()
        Local cLog       AS CHARACTER VALUE cFld+"tBigNtst_"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,999),3)+".log"
        Local ptfProgress:=@Progress()
        Local pttProgress
        Local ptfftProgress:=@ftProgress()
        Local pttftProgress
    #else
        Local cLog       AS CHARACTER VALUE GetTempPath()+"\tBigNtst_"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(Randomize(1,999),3)+".log"
    #endif

        Local cN         AS CHARACTER
        Local cW         AS CHARACTER
        Local cX         AS CHARACTER

        Local n          AS NUMBER
        Local w          AS NUMBER
        Local x          AS NUMBER
        Local z          AS NUMBER

        Local fhLog      AS NUMBER

        Local ntBigNtst  AS NUMBER

    #ifdef __HARBOUR__

        #ifdef __ALT_D__
            Local lKillProgress AS LOGICAL VALUE .T.
        #else
            Local lKillProgress AS LOGICAL VALUE .F.
        #endif

        Private __nMaxRow       AS NUMBER VALUE (MaxRow()-9)
        Private __nMaxCol       AS NUMBER VALUE MaxCol()
        Private __nCol          AS NUMBER VALUE Int((__nMaxCol)/2)
        Private __nRow          AS NUMBER VALUE 0
        Private __noProgress    AS NUMBER VALUE Int(((__nMaxCol)/3)-(__nCol/6))

        Private __cSep          AS CHARACTER VALUE Replicate("-",__nMaxCol)

        aEval(atBigNtst,{|e|if(e[2],++ntBigNtst,NIL)})
        Private __oRTimeProc    AS OBJECT CLASS "TREMAINING" VALUE tRemaining():New(ntBigNtst)
        IF ((cC_GT_MODE=="MT").and.(ntBigNtst==1))
            cLog:=StrTran(cLog,"tBigNtst_",PadL(atBigNtst[ntBigNtst][5],__PADL_T__,"0")+"_tBigNtst_")
        ENDIF

        MakeDir(cFld)

    #else

        Private __cSep          AS CHARACTER VALUE "---------------------------------------------------------"
        Private __oRTimeProc    AS OBJECT CLASS "TREMAINING" VALUE tRemaining():New(1)

    #endif

        Private __phMutex:=hb_mutexCreate()

        Private __CRLF          AS CHARACTER VALUE CRLF
        Private __oRTime1       AS OBJECT CLASS "TREMAINING" VALUE tRemaining():New()
        Private __oRTime2       AS OBJECT CLASS "TREMAINING" VALUE tRemaining():New()

        ASSIGN fhLog:=if(lL_LOGPROCESS,fCreate(cLog,FC_NORMAL),-1)
        if (lL_LOGPROCESS)
            fClose(fhLog)
            ASSIGN fhLog:=fOpen(cLog,FO_READWRITE+FO_SHARED)
        endif

        Private nISQRT:=Int(SQRT(nN_TEST))

    #ifdef __HARBOUR__
        SetColor("w+/n")
        SetCursor(SC_NONE)
        BuildScreen(fhLog,__nMaxCol)
    #endif

        __ConOut(fhLog,__cSep)                           //3
        #ifdef __HARBOUR__
            DispOutAT(3,(__nCol-1),"[ ]")
        #endif

        __ConOut(fhLog,"START ")                       //4
        __ConOut(fhLog,"DATE        : ",dStartDate)    //5
        __ConOut(fhLog,"TIME        : ",cStartTime)    //6

        #ifdef __HARBOUR__
            __ConOut(fhLog,"TIMESTAMP   : ",HB_TTOC(tsBegin))    //7
        #endif

        #ifdef TBN_DBFILE
            #ifndef TBN_MEMIO
                __ConOut(fhLog,"USING       : ",ExeName()+" :: DBFILE")   //8
            #else
                __ConOut(fhLog,"USING       : ",ExeName()+" :: DBMEMIO")  //8
            #endif
        #else
            #ifdef TBN_ARRAY
                __ConOut(fhLog,"USING       : ",ExeName()+" :: ARRAY")    //8
            #else
                __ConOut(fhLog,"USING       : ",ExeName()+" :: STRING")   //8
            #endif
        #endif

        #ifdef __HARBOUR__
            __ConOut(fhLog,"FINAL1      : ","["+StrZero(__oRTime1:GetnProgress(),16)+"/"+StrZero(__oRTime1:GetnTotal(),16)+"]|["+DtoC(__oRTime1:GetdEndTime())+"]["+__oRTime1:GetcEndTime()+"]|["+__oRTime1:GetcAverageTime()+"]") //9
            __ConOut(fhLog,"FINAL2      : ","["+StrZero(__oRTime2:GetnProgress(),16)+"/"+StrZero(__oRTime2:GetnTotal(),16)+"]|["+DtoC(__oRTime2:GetdEndTime())+"]["+__oRTime2:GetcEndTime()+"]|["+__oRTime2:GetcAverageTime()+"]") //10
            __ConOut(fhLog,"")                                                //11
            __ConOut(fhLog,"")                                                //12
            DispOutAT(12,__noProgress,"["+Space(__noProgress)+"]","w+/n")     //12
        #endif

        __ConOut(fhLog,"")    //13

        #ifdef __HARBOUR__
            DispOutAT(14,0,Replicate("*",__nMaxCol),"w+/n")          //14
            DispOutAT(__nMaxRow+1,0,Replicate("*",__nMaxCol),"w+/n") //14
        #endif

        __ConOut(fhLog,"")    //15

        #define __NROWAT    15

        #ifdef __HARBOUR__
            pttProgress:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
            ptfProgress,@lKillProgress,@__oRTimeProc,@__phMutex,__nCol,aC_OOPROGRESS,__noProgress,__nSLEEP,__nMaxCol,lL_OOPROGRAND,lL_ROPROGRESS)
            pttftProgress:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
            ptfftProgress,@lKillProgress,__nSLEEP,__nMaxCol,__nMaxRow)
         #endif

    #ifdef __HARBOUR__
        __nRow:=__nMaxRow
    #endif

        aEval(atBigNtst,{|e|if(e[2],Eval(e[1],fhLog),NIL)})

    #ifdef __HARBOUR__
        __nRow:=__nMaxRow
    #endif

        __ConOut(fhLog,"END ")

        dEndDate:=Date()
        __ConOut(fhLog,"DATE    :",dEndDate)

        ASSIGN cEndTime:=Time()
        __ConOut(fhLog,"TIME    :",cEndTime)

        IF hb_mutexLock(__phMutex,0)
            __oRTimeProc:Calcule(.F.)
            __ConOut(fhLog,"ELAPSED :",__oRTimeProc:GetcTimeDiff())
            hb_mutexUnLock(__phMutex)
        ENDIF

        #ifdef __HARBOUR__
            nsElapsed:=(HB_DATETIME()-tsBegin)
            __ConOut(fhLog,"tELAPSED:",StrTran(StrTran(HB_TTOC(HB_NTOT(nsElapsed)),"/","")," ",""))
        #endif

        __ConOut(fhLog,__cSep)

        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTimeProc:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)

        __ConOut(fhLog,__cSep)

        __ConOut(fhLog,"ACC_SET     :",nACC_SET)
        __ConOut(fhLog,"ROOT_ACC_SET:",nROOT_ACC_SET)
        __ConOut(fhLog,"ACC_ALOG    :",nACC_ALOG)
        __ConOut(fhLog,"__SLEEP     :",__nSLEEP)
        __ConOut(fhLog,"N_TEST      :",nN_TEST)

        __ConOut(fhLog,__cSep)

        if (lL_LOGPROCESS)
            fClose(fhLog)
        endif

    #ifdef __PROTHEUS__
        #ifdef TBN_DBFILE
            tBigNGC()
        #endif
    #else// __HARBOUR__
        lKillProgress:=.T.
        hb_threadQuitRequest(pttProgress)
        hb_threadQuitRequest(pttftProgress)
        hb_ThreadWait(pttProgress)
        hb_ThreadWait(pttftProgress)
        tBigNGC()
        SET COLOR TO "r+/n"
        __tbnSleep(.5)
        IF .NOT.(cC_GT_MODE=="MT")
            WAIT "Press any key to end"
        EndIF
        CLS
    #endif

    Return
/*tBigNtst*/
//--------------------------------------------------------------------------------------------------------
static procedure ChkIntTstExec(aAC_TSTEXEC,nPad)

    Local aTmp

    Local nD
    Local nJ:=Len(aAC_TSTEXEC)
    Local nTmp

    For nD:=1 To nJ
        IF (":"$aAC_TSTEXEC[nD])
            aTmp:=_StrToKArr(AllTrim(aAC_TSTEXEC[nD]),":")
            nTmp:=Len(aTmp)
            IF (nTmp>=1)
                IF (nTmp==1)
                    aAC_TSTEXEC[nD]:=aTmp[1]
                Else
                    For nTmp:=Val(aTmp[1]) To Val(aTmp[2])
                        aAdd(aAC_TSTEXEC,hb_NtoS(nTmp))
                    Next nTmp
                EndIF
            EndIF
        EndIF
    Next nD
    nJ:=Len(aAC_TSTEXEC)
    nTmp:=0
    While ((nTmp:=aScan(aAC_TSTEXEC,{|e|":"$e}))>0)
        aSize(aDel(aAC_TSTEXEC,nTmp),--nJ)
    End While
    aSort(aAC_TSTEXEC,NIL,NIL,{|x,y|PadL(x,nPad)<PadL(y,nPad)})

return
//--------------------------------------------------------------------------------------------------------
static function GettBigNtst(cC_GT_MODE,aAC_TSTEXEC)

    local nD
    local nJ:=__NRTTST__
    #ifndef __PTCOMPAT__
        local pGT
    #endif

    local lAll:=(aScan(aAC_TSTEXEC,{|c|(c=="*")})>0)

    local atBigNtst:=Array(nJ,IF((cC_GT_MODE=="MT"),5,2))

    atBigNtst[1][1]:={|p|tBigNtst01(p)}
    atBigNtst[2][1]:={|p|tBigNtst02(p)}
    atBigNtst[3][1]:={|p|tBigNtst03(p)}
    atBigNtst[4][1]:={|p|tBigNtst04(p)}
    atBigNtst[5][1]:={|p|tBigNtst05(p)}
    atBigNtst[6][1]:={|p|tBigNtst06(p)}
    atBigNtst[7][1]:={|p|tBigNtst07(p)}
    atBigNtst[8][1]:={|p|tBigNtst08(p)}
    atBigNtst[9][1]:={|p|tBigNtst09(p)}

    atBigNtst[10][1]:={|p|tBigNtst10(p)}
    atBigNtst[11][1]:={|p|tBigNtst11(p)}
    atBigNtst[12][1]:={|p|tBigNtst12(p)}
    atBigNtst[13][1]:={|p|tBigNtst13(p)}
    atBigNtst[14][1]:={|p|tBigNtst14(p)}
    atBigNtst[15][1]:={|p|tBigNtst15(p)}
    atBigNtst[16][1]:={|p|tBigNtst16(p)}
    atBigNtst[17][1]:={|p|tBigNtst17(p)}
    atBigNtst[18][1]:={|p|tBigNtst18(p)}
    atBigNtst[19][1]:={|p|tBigNtst19(p)}

    atBigNtst[20][1]:={|p|tBigNtst20(p)}
    atBigNtst[21][1]:={|p|tBigNtst21(p)}
    atBigNtst[22][1]:={|p|tBigNtst22(p)}
    atBigNtst[23][1]:={|p|tBigNtst23(p)}
    atBigNtst[24][1]:={|p|tBigNtst24(p)}
    atBigNtst[25][1]:={|p|tBigNtst25(p)}
    atBigNtst[26][1]:={|p|tBigNtst26(p)}
    atBigNtst[27][1]:={|p|tBigNtst27(p)}
    atBigNtst[28][1]:={|p|tBigNtst28(p)}
    atBigNtst[29][1]:={|p|tBigNtst29(p)}

    atBigNtst[30][1]:={|p|tBigNtst30(p)}
    atBigNtst[31][1]:={|p|tBigNtst31(p)}
    atBigNtst[32][1]:={|p|tBigNtst32(p)}
    atBigNtst[33][1]:={|p|tBigNtst33(p)}
    atBigNtst[34][1]:={|p|tBigNtst34(p)}
    atBigNtst[35][1]:={|p|tBigNtst35(p)}
    atBigNtst[36][1]:={|p|tBigNtst36(p)}
    atBigNtst[37][1]:={|p|tBigNtst37(p)}

    for nD:=1 to nJ
        atBigNtst[nD][2]:=lAll.or.(aScan(aAC_TSTEXEC,{|c|(nD==Val(c))})>0)
        IF atBigNtst[nD][2].and.(cC_GT_MODE=="MT")
            #ifndef __PTCOMPAT__
                atBigNtst[nD][3]:=hb_gtCreate(THREAD_GT)
                pGT:=hb_gtSelect(atBigNtst[nD][3])
                hb_gtInfo(HB_GTI_ICONRES,"AppIcon")
                hb_gtSelect(pGT)
                atBigNtst[nD][4]:=nD
                atBigNtst[nD][5]:=hb_NtoS(nD)
            #endif
        EndIF
    next nD

return(atBigNtst)
//--------------------------------------------------------------------------------------------------------
Static Function _StrToKArr(cStr,cToken)
    Local cDToken
    DEFAULT cStr:=""
    DEFAULT cToken:=";"
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
#ifdef PROTHEUS
Return(StrToKArr(cStr,cToken))
#else
Return(hb_aTokens(cStr,cToken))
#endif
//--------------------------------------------------------------------------------------------------------
Static Procedure __tbnSleep(nSleep)
    PARAMTYPE 1 VAR nSleep AS NUMBER OPTIONAL DEFAULT __nSLEEP
    tBigNSleep(nSleep)
Return
//--------------------------------------------------------------------------------------------------------
Static Procedure __ConOut(fhLog,e,d)

    Local ld    AS LOGICAL
    Local lTBeg AS LOGICAL

    Local p     AS CHARACTER

    Local nATd  AS NUMBER

    Local x     AS UNDEFINED
    Local y     AS UNDEFINED

#ifdef __HARBOUR__

    Local cDOAt  AS CHARACTER
    Local nLines AS NUMBER
    Local nCLine AS NUMBER
    Local lSep   AS LOGICAL
    Local lMRow  AS LOGICAL

#endif

    PARAMTYPE 1 VAR fhLog AS NUMBER
    PARAMTYPE 2 VAR e     AS UNDEFINED
    PARAMTYPE 3 VAR d     AS UNDEFINED

    ASSIGN ld:=.NOT.(Empty(d))

    ASSIGN x:=cValToChar(e)

    IF (ld)
        ASSIGN y:=cValToChar(d)
        ASSIGN nATd:=AT("RESULT",y)
    Else
        ASSIGN y:=""
    EndIF

    ASSIGN p:=x+IF(ld," "+y,"")

#ifdef __HARBOUR__

    IF hb_mutexLock(__phMutex,0)
        ShowFinalProc()
        hb_mutexUnLock(__phMutex)
    ENDIF

    DEFAULT __nRow:=0
    ASSIGN lSep:=(p==__cSep)

    if lDispML
        ASSIGN nLines:=MLCount(p,__nMaxCol,NIL,.T.)
        For nCLine:=1 TO nLines
            ASSIGN cDOAt:=MemoLine(p,__nMaxCol,nCLine,NIL,.T.)
            IF ++__nRow>=__nMaxRow
                @ __NROWAT,0 CLEAR TO __nMaxRow,__nMaxCol
                ASSIGN __nRow:=__NROWAT
            EndIF
            ASSIGN lMRow:=(__nRow>=__NROWAT)
            DispOutAT(__nRow,0,cDOAt,IF(.NOT.(lSep).AND.lMRow,"w+/n",IF(lSep.AND.lMRow,"c+/n","w+/n")))
        Next nCLine
    else
        IF ++__nRow>=__nMaxRow
            @ __NROWAT,0 CLEAR TO __nMaxRow,__nMaxCol
            ASSIGN __nRow:=__NROWAT
        EndIF
        ASSIGN lMRow:=(__nRow>=__NROWAT)
        DispOutAT(__nRow,0,p,IF(.NOT.(lSep).AND.lMRow,"w+/n",IF(lSep.AND.lMRow,"c+/n","w+/n")))
    endif

    lTBeg:=("BEGIN ------------"$p)

    IF (lTBeg)
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br]["+AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+"]")
        DispOutAT(4,7,PadC(AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+Space(6),__nMaxCol-6),"r+/n")
    EndIF

    IF hb_mutexLock(__phMutex,0)
        __oRTimeProc:Calcule(lTBeg)
        hb_mutexUnLock(__phMutex)
    EndIF

#else
    lTBeg:=("BEGIN ------------"$p)
    IF (lTBeg)
        PTInternal(1,"[tBigNTST]["+AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+"]")
    EndIF
    ? p
#endif

    p:=NIL

    if (lL_LOGPROCESS)
        IF ((ld) .and. (nATd>0))
            fWrite(fhLog,x+__CRLF)
            fWrite(fhLog,"...................................................................................................."+y+__CRLF)
        Else
            fWrite(fhLog,x+y+__CRLF)
        EndIF
    endif

Return
//--------------------------------------------------------------------------------------------------------
Static Function IsHb()
    Local lHarbour AS LOGICAL
    #ifdef __HARBOUR__
        ASSIGN lHarbour:=.T.
    #else
        ASSIGN lHarbour:=.F.
    #endif
Return(lHarbour)
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Static Function cValToChar(e)
        Local s AS UNDEFINED
        SWITCH ValType(e)
        CASE "C"
            ASSIGN s:=e
            EXIT
        CASE "D"
            ASSIGN s:=Dtoc(e)
            EXIT
        CASE "T"
            ASSIGN s:=HB_TTOC(e)
            EXIT
        CASE "N"
            ASSIGN s:=Str(e)
            EXIT
        CASE "L"
            ASSIGN s:=IF(e,".T.",".F.")
            EXIT
        OTHERWISE
            ASSIGN s:=""
        ENDSWITCH
    Return(s)
    //--------------------------------------------------------------------------------------------------------
    Static Procedure Progress(lKillProgress,__oRTimeProc,__phMutex,nCol,aProgress2,nProgress2,nSLEEP,nMaxCol,lRandom,lPRandom)

        Local aRdnPG     AS ARRAY                        VALUE Array(0)
        Local aRdnAn     AS ARRAY                        VALUE Array(0)
        Local aSAnim     AS ARRAY                        VALUE Array(29)

        Local cAT        AS CHARACTER
        Local cRTime     AS CHARACTER
        Local cStuff     AS CHARACTER
        Local cLRTime    AS CHARACTER
        Local cProgress  AS CHARACTER

        Local lChange    AS LOGICAL
        Local lCScreen   AS LOGICAL                       VALUE .T.

        Local nAT        AS NUMBER
        Local nQT        AS NUMBER
        Local nLenA      AS NUMBER                        VALUE Len(aSAnim)
        Local nLenP      AS NUMBER                        VALUE Len(aProgress2)
        Local nSAnim     AS NUMBER                        VALUE 1
        Local nSizeP     AS NUMBER                        VALUE (nProgress2*2)
        Local nSizeP2    AS NUMBER                        VALUE (nSizeP*2)
        Local nSizeP3    AS NUMBER                        VALUE (nSizeP*3)
        Local nChange    AS NUMBER
        Local nProgress  AS NUMBER                        VALUE 1

        Local oProgress1 AS OBJECT CLASS "TSPROGRESS"     VALUE tSProgress():New()
        Local oProgress2 AS OBJECT CLASS "TSPROGRESS"     VALUE tSProgress():New()

        ASSIGN aSAnim[01]:=Replicate(Chr(7)+";",nSizeP2-1)
        ASSIGN aSAnim[01]:=SubStr(aSAnim[01],1,nSizeP2-1)
        IF (SubStr(aSAnim[01],-1)==";")
            ASSIGN aSAnim[01]:=SubStr(aSAnim[01],1,Len(aSAnim[01])-1)
        EndIF

        ASSIGN aSAnim[02]:=Replicate("-;\;|;/;",nSizeP2-1)
        ASSIGN aSAnim[02]:=SubStr(aSAnim[02],1,nSizeP2-1)
        IF (SubStr(aSAnim[02],-1)==";")
            ASSIGN aSAnim[02]:=SubStr(aSAnim[02],1,Len(aSAnim[02])-1)
        EndIF

        ASSIGN aSAnim[03]:=Replicate(Chr(8)+";",nSizeP2-1)
        ASSIGN aSAnim[03]:=SubStr(aSAnim[03],1,nSizeP2-1)
        IF (SubStr(aSAnim[03],-1)==";")
            ASSIGN aSAnim[03]:=SubStr(aSAnim[03],1,Len(aSAnim[03])-1)
        EndIF

        ASSIGN aSAnim[04]:=Replicate("*;",nSizeP2-1)
        ASSIGN aSAnim[04]:=SubStr(aSAnim[04],1,nSizeP2-1)
        IF (SubStr(aSAnim[04],-1)==";")
            ASSIGN aSAnim[04]:=SubStr(aSAnim[04],1,Len(aSAnim[04])-1)
        EndIF

        ASSIGN aSAnim[05]:=Replicate(".;",nSizeP2-1)
        ASSIGN aSAnim[05]:=SubStr(aSAnim[05],1,nSizeP2-1)
        IF (SubStr(aSAnim[05],-1)==";")
            ASSIGN aSAnim[05]:=SubStr(aSAnim[05],1,Len(aSAnim[05])-1)
        EndIF

        ASSIGN aSAnim[06]:=Replicate(":);",nSizeP3-1)
        ASSIGN aSAnim[06]:=SubStr(aSAnim[06],1,nSizeP3-1)
        IF (SubStr(aSAnim[06],-1)==";")
            ASSIGN aSAnim[06]:=SubStr(aSAnim[06],1,Len(aSAnim[06])-1)
        EndIF

        ASSIGN aSAnim[07]:=Replicate(">;",nSizeP2-1)
        ASSIGN aSAnim[07]:=SubStr(aSAnim[07],1,nSizeP2-1)
        IF (SubStr(aSAnim[07],-1)==";")
            ASSIGN aSAnim[07]:=SubStr(aSAnim[07],1,Len(aSAnim[07])-1)
        EndIF

        ASSIGN aSAnim[08]:=Replicate("B;L;A;C;K;T;D;N;;",nSizeP2-1)
        ASSIGN aSAnim[08]:=SubStr(aSAnim[08],1,nSizeP2-1)
        IF (SubStr(aSAnim[08],-1)==";")
            ASSIGN aSAnim[08]:=SubStr(aSAnim[08],1,Len(aSAnim[08])-1)
        EndIF

        ASSIGN aSAnim[09]:=Replicate("T;B;I;G;N;U;M;B;E;R;;",nSizeP2-1)
        ASSIGN aSAnim[09]:=SubStr(aSAnim[09],1,nSizeP2-1)
        IF (SubStr(aSAnim[09],-1)==";")
            ASSIGN aSAnim[09]:=SubStr(aSAnim[09],1,Len(aSAnim[09])-1)
        EndIF

        ASSIGN aSAnim[10]:=Replicate("H;A;R;B;O;U;R;;",nSizeP2-1)
        ASSIGN aSAnim[10]:=SubStr(aSAnim[10],1,nSizeP2-1)
        IF (SubStr(aSAnim[10],-1)==";")
            ASSIGN aSAnim[10]:=SubStr(aSAnim[10],1,Len(aSAnim[10])-1)
        EndIF

        ASSIGN aSAnim[11]:=Replicate("N;A;L;D;O;;D;J;;",nSizeP2-1)
        ASSIGN aSAnim[11]:=SubStr(aSAnim[11],1,nSizeP2-1)
        IF (SubStr(aSAnim[11],-1)==";")
            ASSIGN aSAnim[11]:=SubStr(aSAnim[11],1,Len(aSAnim[11])-1)
        EndIF

        ASSIGN aSAnim[12]:=Replicate(Chr(175)+";",nSizeP2-1)
        ASSIGN aSAnim[12]:=SubStr(aSAnim[12],1,nSizeP2-1)
        IF (SubStr(aSAnim[12],-1)==";")
            ASSIGN aSAnim[12]:=SubStr(aSAnim[12],1,Len(aSAnim[12])-1)
        EndIF

        ASSIGN aSAnim[13]:=Replicate(Chr(254)+";",nSizeP2-1)
        ASSIGN aSAnim[13]:=SubStr(aSAnim[13],1,nSizeP2-1)
        IF (SubStr(aSAnim[13],-1)==";")
            ASSIGN aSAnim[13]:=SubStr(aSAnim[13],1,Len(aSAnim[13])-1)
        EndIF

        ASSIGN aSAnim[14]:=Replicate(Chr(221)+";"+Chr(222)+";",nSizeP2-1)
        ASSIGN aSAnim[14]:=SubStr(aSAnim[14],1,nSizeP2-1)
        IF (SubStr(aSAnim[14],-1)==";")
            ASSIGN aSAnim[14]:=SubStr(aSAnim[14],1,Len(aSAnim[14])-1)
        EndIF

        ASSIGN aSAnim[15]:=Replicate(Chr(223)+";;",nSizeP2-1)
        ASSIGN aSAnim[15]:=SubStr(aSAnim[15],1,nSizeP2-1)
        IF (SubStr(aSAnim[15],-1)==";")
            ASSIGN aSAnim[15]:=SubStr(aSAnim[15],1,Len(aSAnim[15])-1)
        EndIF

        ASSIGN aSAnim[16]:=Replicate(Chr(176)+";;"+Chr(177)+";;"+Chr(178)+";;",nSizeP2-1)
        ASSIGN aSAnim[16]:=SubStr(aSAnim[16],1,nSizeP2-1)
        IF (SubStr(aSAnim[16],-1)==";")
            ASSIGN aSAnim[16]:=SubStr(aSAnim[16],1,Len(aSAnim[16])-1)
        EndIF

        ASSIGN aSAnim[17]:=Replicate(Chr(7)+";;",nSizeP2-1)
        ASSIGN aSAnim[17]:=SubStr(aSAnim[17],1,nSizeP2-1)
        IF (SubStr(aSAnim[17],-1)==";")
            ASSIGN aSAnim[17]:=SubStr(aSAnim[17],1,Len(aSAnim[17])-1)
        EndIF

        ASSIGN aSAnim[18]:=Replicate("-;;\;;|;;/;;",nSizeP2-1)
        ASSIGN aSAnim[18]:=SubStr(aSAnim[18],1,nSizeP2-1)
        IF (SubStr(aSAnim[18],-1)==";")
            ASSIGN aSAnim[18]:=SubStr(aSAnim[18],1,Len(aSAnim[18])-1)
        EndIF

        ASSIGN aSAnim[19]:=Replicate(Chr(8)+";;",nSizeP2-1)
        ASSIGN aSAnim[19]:=SubStr(aSAnim[19],1,nSizeP2-1)
        IF (SubStr(aSAnim[19],-1)==";")
            ASSIGN aSAnim[19]:=SubStr(aSAnim[19],1,Len(aSAnim[19])-1)
        EndIF

        ASSIGN aSAnim[20]:=Replicate("*;;",nSizeP2-1)
        ASSIGN aSAnim[20]:=SubStr(aSAnim[20],1,nSizeP2-1)
        IF (SubStr(aSAnim[20],-1)==";")
            ASSIGN aSAnim[20]:=SubStr(aSAnim[20],1,Len(aSAnim[20])-1)
        EndIF

        ASSIGN aSAnim[21]:=Replicate(".;;",nSizeP2-1)
        ASSIGN aSAnim[21]:=SubStr(aSAnim[21],1,nSizeP2-1)
        IF (SubStr(aSAnim[21],-1)==";")
            ASSIGN aSAnim[21]:=SubStr(aSAnim[21],1,Len(aSAnim[21])-1)
        EndIF

        ASSIGN aSAnim[22]:=Replicate(":);;",nSizeP3-1)
        ASSIGN aSAnim[22]:=SubStr(aSAnim[22],1,nSizeP3-1)
        IF (SubStr(aSAnim[22],-1)==";")
            ASSIGN aSAnim[22]:=SubStr(aSAnim[22],1,Len(aSAnim[22])-1)
        EndIF

        ASSIGN aSAnim[23]:=Replicate(">;;",nSizeP2-1)
        ASSIGN aSAnim[23]:=SubStr(aSAnim[23],1,nSizeP2-1)
        IF (SubStr(aSAnim[23],-1)==";")
            ASSIGN aSAnim[23]:=SubStr(aSAnim[23],1,Len(aSAnim[23])-1)
        EndIF

        ASSIGN aSAnim[24]:=Replicate(Chr(175)+";;",nSizeP2-1)
        ASSIGN aSAnim[24]:=SubStr(aSAnim[24],1,nSizeP2-1)
        IF (SubStr(aSAnim[24],-1)==";")
            ASSIGN aSAnim[24]:=SubStr(aSAnim[24],1,Len(aSAnim[24])-1)
        EndIF

        ASSIGN aSAnim[25]:=Replicate(Chr(254)+";;",nSizeP2-1)
        ASSIGN aSAnim[25]:=SubStr(aSAnim[25],1,nSizeP2-1)
        IF (SubStr(aSAnim[25],-1)==";")
            ASSIGN aSAnim[25]:=SubStr(aSAnim[25],1,Len(aSAnim[25])-1)
        EndIF

        ASSIGN aSAnim[26]:=Replicate(Chr(221)+";;"+Chr(222)+";;",nSizeP2-1)
        ASSIGN aSAnim[26]:=SubStr(aSAnim[26],1,nSizeP2-1)
        IF (SubStr(aSAnim[26],-1)==";")
            ASSIGN aSAnim[26]:=SubStr(aSAnim[26],1,Len(aSAnim[26])-1)
        EndIF

        ASSIGN aSAnim[27]:=Replicate(Chr(223)+";",nSizeP2-1)
        ASSIGN aSAnim[27]:=SubStr(aSAnim[27],1,nSizeP2-1)
        IF (SubStr(aSAnim[27],-1)==";")
            ASSIGN aSAnim[27]:=SubStr(aSAnim[27],1,Len(aSAnim[27])-1)
        EndIF

        ASSIGN aSAnim[28]:=Replicate(Chr(176)+";"+Chr(177)+";"+Chr(178)+";",nSizeP2-1)
        ASSIGN aSAnim[28]:=SubStr(aSAnim[28],1,nSizeP2-1)
        IF (SubStr(aSAnim[28],-1)==";")
            ASSIGN aSAnim[28]:=SubStr(aSAnim[28],1,Len(aSAnim[28])-1)
        EndIF

        ASSIGN aSAnim[29]:=Replicate(Chr(149)+";",nSizeP2-1)
        ASSIGN aSAnim[29]:=SubStr(aSAnim[01],1,nSizeP2-1)
        IF (SubStr(aSAnim[29],-1)==";")
            ASSIGN aSAnim[29]:=SubStr(aSAnim[29],1,Len(aSAnim[29])-1)
        EndIF

        IF (lRandom)
            ASSIGN nSAnim:=abs(HB_RandomInt(1,nLenA))
            aAdd(aRdnAn,nSAnim)
            ASSIGN nProgress:=abs(HB_RandomInt(1,nLenP))
            aAdd(aRdnPG,nProgress)
        EndIF

        oProgress2:SetProgress(aSAnim[nSAnim])
        cProgress:=aProgress2[nProgress]

        While .NOT.(lKillProgress)

            DispOutAT(3,nCol,oProgress1:Eval(),"r+/n")

            IF (oProgress2:GetnProgress()==oProgress2:GetnMax())
                lChange:=(.NOT.("SHUTTLE"$cProgress).or.(("SHUTTLE"$cProgress).and.(++nChange>1)))
                IF (lChange)
                    IF ("SHUTTLE"$cProgress)
                        ASSIGN nChange:=0
                    EndIF
                    IF (lRandom)
                        IF (Len(aRdnAn)==nLenA)
                            aSize(aRdnAn,0)
                        EndIF
                        While (aScan(aRdnAn,{|r|r==(nSAnim:=abs(HB_RandomInt(1,nLenA)))})>0)
                            __tbnSleep(nSLEEP)
                        End While
                        aAdd(aRdnAn,nSAnim)
                        oProgress2:SetProgress(aSAnim[nSAnim])
                        IF (Len(aRdnPG)==nLenP)
                            aSize(aRdnPG,0)
                        EndIF
                        While (aScan(aRdnPG,{|r|r==(nProgress:=abs(HB_RandomInt(1,nLenP)))})>0)
                            __tbnSleep(nSLEEP)
                        End While
                        aAdd(aRdnPG,nProgress)
                    Else
                        IF (++nProgress>nLenP)
                            ASSIGN nProgress:=1
                            IF (++nSAnim>nLenA)
                                ASSIGN nSAnim:=1
                            EndIF
                            oProgress2:SetProgress(aSAnim[nSAnim])
                        EndIF
                    EndIF
                    ASSIGN lCScreen:=.T.
                    ASSIGN cProgress:=aProgress2[nProgress]
                EndIF
            EndIF

            oProgress2:SetRandom(lPRandom)

            IF (lCScreen)
                ASSIGN lCScreen:=.F.
                @ 12,0 CLEAR TO 12,nMaxCol
            EndIF

            ASSIGN cStuff:=PADC("["+cProgress+"] ["+oProgress2:Eval(cProgress)+"] ["+cProgress+"]",nMaxCol)
            ASSIGN nAT:=(AT("] [",cStuff)+3)
            ASSIGN nQT:=(AT("] [",SubSTr(cStuff,nAT))-2)
            ASSIGN cAT:=SubStr(cStuff,nAT,nQT+1)
            ASSIGN cStuff:=Stuff(cStuff,nAT,Len(cAT),Space(Len(cAT)))

            DispOutAT(12,0,cStuff,"w+/n")
            DispOutAT(12,nAT-1,cAT,"r+/n")

            IF hb_mutexLock(__phMutex,0)
                IF (cRTime==cLRTime)
                    __oRTime1:Calcule(.F.)
                    __oRTime2:Calcule(.F.)
                   __oRTimeProc:Calcule(.F.)
                EndIF
                ShowFinalProc()
                ASSIGN cRTime:="["+hb_NtoS(__oRTimeProc:GetnProgress())
                ASSIGN cRTime+="/"+hb_NtoS(__oRTimeProc:GetnTotal())+"]"
                ASSIGN cRTime+="["+DtoC(__oRTimeProc:GetdEndTime())+"]"
                ASSIGN cRTime+="["+__oRTimeProc:GetcEndTime()+"]"
                ASSIGN cRTime+="["+__oRTimeProc:GetcAverageTime()+"]"
                ASSIGN cRTime+="["+hb_NtoS((__oRTimeProc:GetnProgress()/__oRTimeProc:GetnTotal())*100)+" %]"
                ASSIGN cLRTime:=cRTime
                hb_mutexUnLock(__phMutex)
            EndIF

            @ 07,15 CLEAR TO 07,nMaxCol
            DispOutAT(07,15,HB_TTOC(HB_DATETIME()),"r+/n")
            DispOutAT(07,nMaxCol-Len(cRTime),cRTime,"r+/n")

            __tbnSleep(nSLEEP)

        End While

    Return
    Static Procedure ShowFinalProc()

        Local cDOAt      AS CHARACTER

        @ 09,15 CLEAR TO 09,__nMaxCol
        cDOAt:="["
        cDOAt+=StrZero(__oRTime1:GetnProgress(),16)
        cDOAt+="/"
        cDOAt+=StrZero(__oRTime1:GetnTotal(),16)
        cDOAt+="]|["
        cDOAt+=DtoC(__oRTime1:GetdEndTime())
        cDOAt+="]["+__oRTime1:GetcEndTime()
        cDOAt+="]|["
        cDOAt+=__oRTime1:GetcAverageTime()
        cDOAt+="]["
        cDOAt+=hb_NtoS((__oRTime1:GetnProgress()/__oRTime1:GetnTotal())*100)
        cDOAt+=" %]"
        DispOutAT(09,15,cDOAt,"w+/n")

        @ 10,15 CLEAR TO 10,__nMaxCol
        cDOAt:="["
        cDOAt+=StrZero(__oRTime2:GetnProgress(),16)
        cDOAt+="/"
        cDOAt+=StrZero(__oRTime2:GetnTotal(),16)
        cDOAt+="]|["
        cDOAt+=DtoC(__oRTime2:GetdEndTime())
        cDOAt+="]["+__oRTime2:GetcEndTime()
        cDOAt+="]|["
        cDOAt+=__oRTime2:GetcAverageTime()
        cDOAt+="]["
        cDOAt+=hb_NtoS((__oRTime2:GetnProgress()/__oRTime2:GetnTotal())*100)
        cDOAt+=" %]"
        DispOutAT(10,15,cDOAt,"w+/n")



    Return
    //--------------------------------------------------------------------------------------------------------
    Static Procedure ftProgress(lKillProgress,nSLEEP,nMaxCol,nMaxRow)

        Local aAnim    AS ARRAY     VALUE GetBigNAnim()

        Local cRow     AS CHARACTER
        Local cAnim    AS CHARACTER
        Local cRAnim   AS CHARACTER

        Local lBreak   AS LOGICAL   VALUE .F.

        Local nRow     AS NUMBER
        Local nRowC    AS NUMBER
        Local nAnim    AS NUMBER
        Local nAnimes  AS NUMBER    VALUE Len(aAnim)
        Local nRowAnim AS NUMBER    VALUE (nMaxRow+2)

        While .NOT.(lKillProgress)

            For nAnim:=1 To nAnimes
                cAnim:=aAnim[nAnim]
                FOR EACH cRow IN _StrToKArr(cAnim,"[\n]")
                    lBreak:=(";"$cRow)
                    IF (lBreak)
                        IF ((nRowC==0).and..NOT.(nRow==0))
                            nRowC:=(nRowAnim+nRow)
                        EndIF
                        cRAnim:=StrTran(cRow,";","")
                    EndIF
                    cRAnim:=PadC(StrTran(cRow,";",""),nMaxCol)
                    DispOutAT(nRowAnim+nRow,0,cRAnim,IF(lBreak,"w+/n","r+/n"))
                    __tbnSleep(nSLEEP/2)
                    IF (lBreak)
                        nRow:=0
                    Else
                        ++nRow
                    EndIF
                NEXT cRow
                @ nRowAnim,0 CLEAR TO nRowC,nMaxCol
                __tbnSleep(nSLEEP)
                nRow:=0
                nRowC:=0
            Next nAnim

        End While

    Return
    //--------------------------------------------------------------------------------------------------------
    Static Procedure BuildScreen(fhLog,nMaxCol)
        CLEAR SCREEN
        __ConOut(fhLog,PadC("BlackTDN :: tBigNtst [http://www.blacktdn.com.br]",nMaxCol)) //1
        __ConOut(fhLog,PadC("("+Version()+Build_Mode()+","+OS()+")",nMaxCol))            //2
        ShowTime(2,nMaxCol-8,.F.,"r+/n",.F.,.F.)
    Return
    //--------------------------------------------------------------------------------------------------------
    Static Function FreeObj(oObj)
        oObj:=NIL
    Return(tBigNGC())
    Static Function tBigNGC()
    Return(/*hb_gcAll(.T.)*/NIL)
    #include "..\src\tests\hb\tBigNAnim.prg"
#else
    #ifdef TBN_DBFILE
        Static Function tBigNGC()
        Return(StaticCall(TBIGNUMBER,tBigNGC))
    #endif
#endif

//--------------------------------------------------------------------------------------------------------
static function Fibonacci(uN)
    Local oN:=tBigNumber():New(uN)
return(oN:Fibonacci())

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst01(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"")

    __ConOut(fhLog,"BEGIN ------------ Teste MOD 0 -------------- ")


    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        ASSIGN cX:=hb_NtoS(x)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(nN_TEST)
            __oRTime2:SetStep(nISQRT)
            hb_mutexUnLock(__phMutex)
        EndIF
        For n:=nN_TEST To 1 Step -nISQRT
            ASSIGN cN:=hb_NtoS(n)
            ASSIGN cW:=otBigN:SetValue(cX):MOD(cN):ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():MOD('+cN+')',"RESULT: "+cW)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            ENDIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next n
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste MOD 0 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst02(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigX    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    #ifndef __PROTHEUS__
        __ConOut(fhLog,"BEGIN ------------ Teste Operator Overloading 0 -------------- ")

        otBigN:SetDecimals(nACC_SET)
        otBigW:SetDecimals(nACC_SET)
        otBigX:SetDecimals(nACC_SET)

        Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

/*(*)*/ /* OPERATORS NOT IMPLEMENTED: HB_APICLS.H,CLASSES.C AND HVM.C*/
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:SetRemaining(5+1)
            hb_mutexUnLock(__phMutex)
        EndIF

        For w:=0 To 5
            ASSIGN cW:=hb_NtoS(w)
            otBigW:=cW
            __ConOut(fhLog,"otBigW:="+cW,"RESULT: "+otBigW:ExactValue())
            __ConOut(fhLog,"otBigW=="+cW,"RESULT: "+cValToChar(otBigW==cW))
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:SetRemaining(nISQRT)
                __oRTime2:SetStep(Int(nISQRT/2))
                hb_mutexUnLock(__phMutex)
            EndIF
            For n:=1 To nISQRT Step Int(nISQRT/2)
                ASSIGN cN:=hb_NtoS(n)
                __ConOut(fhLog,"otBigW=="+cN,"RESULT: "+cValToChar(otBigW==cN))
/*(*)*/            __ConOut(fhLog,"otBigW%="+cW,"RESULT: "+(otBigX:=(otBigW%=cW),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW^="+cN,"RESULT: "+(otBigX:=(otBigW^=cN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+="+cN,"RESULT: "+(otBigX:=(otBigW+=cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW++","RESULT: "+(otBigX:=(otBigW++),otBigX:ExactValue()))
                __ConOut(fhLog,"++otBigW","RESULT: "+(otBigX:=(++otBigW),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW-="+cN,"RESULT: "+(otBigX:=(otBigW-=cN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+="+cW,"RESULT: "+(otBigX:=(otBigW+=cW),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW*="+cN,"RESULT: "+(otBigX:=(otBigW*=cN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+="+cW,"RESULT: "+(otBigX:=(otBigW+=cW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW++","RESULT: "+(otBigX:=(otBigW++),otBigX:ExactValue()))
                __ConOut(fhLog,"++otBigW","RESULT: "+(otBigX:=(++otBigW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW--","RESULT: "+(otBigX:=(otBigW--),otBigX:ExactValue()))
                __ConOut(fhLog,"--otBigW","RESULT: "+(otBigX:=(--otBigW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW=="+cN,"RESULT: "+cValToChar(otBigW==cN))
                __ConOut(fhLog,"otBigW>"+cN,"RESULT: "+cValToChar(otBigW>cN))
                __ConOut(fhLog,"otBigW<"+cN,"RESULT: "+cValToChar(otBigW<cN))
                __ConOut(fhLog,"otBigW>="+cN,"RESULT: "+cValToChar(otBigW>=cN))
                __ConOut(fhLog,"otBigW<="+cN,"RESULT: "+cValToChar(otBigW<=cN))
                __ConOut(fhLog,"otBigW!="+cN,"RESULT: "+cValToChar(otBigW!=cN))
                __ConOut(fhLog,"otBigW#"+cN,"RESULT: "+cValToChar(otBigW#cN))
                __ConOut(fhLog,"otBigW<>"+cN,"RESULT: "+cValToChar(otBigW<>cN))
                __ConOut(fhLog,"otBigW+"+cN,"RESULT: "+(otBigX:=(otBigW+cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW-"+cN,"RESULT: "+(otBigX:=(otBigW-cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW*"+cN,"RESULT: "+(otBigX:=(otBigW*cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW/"+cN,"RESULT: "+(otBigX:=(otBigW/cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW%"+cN,"RESULT: "+(otBigX:=(otBigW%cN),otBigX:ExactValue()))
                __ConOut(fhLog,__cSep)
                otBigN:=otBigW
                __ConOut(fhLog,"otBigN:=otBigW","RESULT: "+otBigN:ExactValue())
                __ConOut(fhLog,"otBigN","RESULT: "+otBigW:ExactValue())
                __ConOut(fhLog,"otBigW","RESULT: "+otBigW:ExactValue())
                __ConOut(fhLog,"otBigW==otBigN","RESULT: "+cValToChar(otBigW==otBigN))
                __ConOut(fhLog,"otBigW>otBigN","RESULT: "+cValToChar(otBigW>otBigN))
                __ConOut(fhLog,"otBigW<otBigN","RESULT: "+cValToChar(otBigW<otBigN))
                __ConOut(fhLog,"otBigW>=otBigN","RESULT: "+cValToChar(otBigW>=otBigN))
                __ConOut(fhLog,"otBigW<=otBigN","RESULT: "+cValToChar(otBigW<=otBigN))
                __ConOut(fhLog,"otBigW!=otBigN","RESULT: "+cValToChar(otBigW!=otBigN))
                __ConOut(fhLog,"otBigW#otBigN","RESULT: "+cValToChar(otBigW#otBigN))
                __ConOut(fhLog,"otBigW<>otBigN","RESULT: "+cValToChar(otBigW<>otBigN))
                __ConOut(fhLog,"otBigW+otBigN","RESULT: "+(otBigX:=(otBigW+otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW-otBigN","RESULT: "+(otBigX:=(otBigW-otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW*otBigN","RESULT: "+(otBigX:=(otBigW*otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW/otBigN","RESULT: "+(otBigX:=(otBigW/otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW%otBigN","RESULT: "+(otBigX:=(otBigW%otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=otBigN++","RESULT: "+(otBigX:=(otBigW+=otBigN++),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=++otBigN","RESULT: "+(otBigX:=(otBigW+=++otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW-=otBigN","RESULT: "+(otBigX:=(otBigW-=otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW*=otBigN","RESULT: "+(otBigX:=(otBigW*=otBigN),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
                otBigN:=cW
                __ConOut(fhLog,"otBigN:="+cW,"RESULT: "+otBigN:ExactValue())
                __ConOut(fhLog,"otBigN=="+cW,"RESULT: "+cValToChar(otBigN==cW))
/*(*)*/            __ConOut(fhLog,"otBigN^=otBigN","RESULT: "+(otBigX:=(otBigN^=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW--","RESULT: "+(otBigX:=(otBigW--),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=otBigN--","RESULT: "+(otBigX:=(otBigW+=otBigN--),otBigX:ExactValue()))
/*(*)*/            __ConOut(fhLog,"otBigW+=--otBigN","RESULT: "+(otBigX:=(otBigW+=--otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,__cSep)
                IF hb_mutexLock(__phMutex,0)
                    __oRTime2:Calcule()
                    __oRTime1:Calcule(.F.)
                    __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                    hb_mutexUnLock(__phMutex)
                ENDIF
                *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
                __ConOut(fhLog,__cSep)
            Next n
            IF hb_mutexLock(__phMutex,0)
                __oRTime1:Calcule()
                __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next w
        otBigX:=NIL
        tBigNGC()
        __ConOut(fhLog,"------------ Teste Operator Overloading 0 -------------- END")
    #endif

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst03(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o0        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("0")

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER
    Local y         AS NUMBER

    Local aPFact    AS ARRAY

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"")

    __ConOut(fhLog,"BEGIN ------------ Teste Prime 0 -------------- ")


    otBigN:SetDecimals(nACC_SET)
    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To nN_TEST STEP nISQRT
        ASSIGN y:=0
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN aPFact:=otBigN:SetValue(cN):PFactors()
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(Len(aPFact))
            hb_mutexUnLock(__phMutex)
        EndIF
        For x:=1 To Len(aPFact)
            ASSIGN cW:=aPFact[x][2]
#ifndef __PROTHEUS__
            otBigW:=cW
            While otBigW>o0
#else
            otBigW:SetValue(cW)
            While otBigW:gt(o0)
#endif

                __ConOut(fhLog,cN+':tBigNumber():PFactors():'+hb_NtoS(x)+':'+otBigW:ExactValue()+':'+hb_NtoS(++y),"RESULT: "+aPFact[x][1])
                otBigW:OpDec()
            End While
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                hb_mutexUnLock(__phMutex)
            EndIF
        Next x
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    aSize(aPFact,0)
    aPFact:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif //__PROTHEUS__

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Prime 0 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst04(fhLog)

    Local cN        AS CHARACTER

    Local n         AS NUMBER

    Local aPrimes   AS ARRAY  VALUE {;
                                         "15485783", "15485801", "15485807", "15485837", "15485843", "15485849", "15485857", "15485863",;
                                         "15487403", "15487429", "15487457", "15487469", "15487471", "15487517", "15487531", "15487541",;
                                         "32458051", "32458057", "32458073", "32458079", "32458091", "32458093", "32458109", "32458123",;
                                         "49981171", "49981199", "49981219", "49981237", "49981247", "49981249", "49981259", "49981271",;
                                         "67874921", "67874959", "67874969", "67874987", "67875007", "67875019", "67875029", "67875061",;
                                        "982451501","982451549","982451567","982451579","982451581","982451609","982451629","982451653";
                                    }

    Local oPrime    AS OBJECT CLASS "TPRIME"     VALUE tPrime():New()

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste Prime 1 -------------- ")

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    oPrime:IsPReset()
    oPrime:NextPReset()

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(Len(aPrimes))
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To Len(aPrimes)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=PadL(aPrimes[n],oPrime:nSize)
        __ConOut(fhLog,'tPrime():NextPrime('+cN+')',"RESULT: "+cValToChar(oPrime:NextPrime(cN)))
        __ConOut(fhLog,'tPrime():NextPrime('+cN+')',"RESULT: "+oPrime:cPrime)
        __ConOut(fhLog,'tPrime():IsPrime('+oPrime:cPrime+')',"RESULT: "+cValToChar(oPrime:IsPrime()))
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    aSize(aPrimes,0)
    aPrimes:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif //__PROTHEUS__

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Prime 1 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst05(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cHex      AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    Local otBH16    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New(NIL,16)
    Local otBBin    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New(NIL,2)

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste HEX16 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nISQRT*99)
        __oRTime1:SetStep(99)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=0 TO (nISQRT*99) STEP 99
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN n:=x
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN cHex:=otBigN:SetValue(cN):D2H("16"):Int()
        __ConOut(fhLog,cN+':tBigNumber():D2H(16)',"RESULT: "+cHex)
        ASSIGN cN:=otBH16:SetValue(cHex):H2D():Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2D()',"RESULT: "+cN)
        __ConOut(fhLog,cN+"=="+hb_NtoS(n),"RESULT: "+cValToChar(cN==hb_NtoS(n)))
        ASSIGN cN:=otBH16:H2B():Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2B()',"RESULT: "+cN)
        ASSIGN cHex:=otBBin:SetValue(cN):B2H('16'):Int()
        __ConOut(fhLog,cN+':tBigNumber():B2H(16)',"RESULT: "+cHex)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    otBH16:=FreeObj(otBH16)

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste HEX16 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst06(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cHex      AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    Local otBH32    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New(NIL,32)
    Local otBBin    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New(NIL,2)

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste HEX32 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nISQRT*99)
        __oRTime1:SetStep(99)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=0 TO (nISQRT*99) STEP 99
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN n:=x
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN cHex:=otBigN:SetValue(cN):D2H("32"):Int()
        __ConOut(fhLog,cN+':tBigNumber():D2H(32)',"RESULT: "+cHex)
        ASSIGN cN:=otBH32:SetValue(cHex):H2D("32"):Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2D()',"RESULT: "+cN)
        __ConOut(fhLog,cN+"=="+hb_NtoS(n),"RESULT: "+cValToChar(cN==hb_NtoS(n)))
        ASSIGN cN:=otBH32:H2B('32'):Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2B()',"RESULT: "+cN)
        ASSIGN cHex:=otBBin:SetValue(cN):B2H('32'):Int()
        __ConOut(fhLog,cN+':tBigNumber():B2H(32)',"RESULT: "+cHex)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    otBH32:=FreeObj(otBH32)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste HEX32 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst07(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ ADD Teste 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN n:=1

#ifndef __PROTHEUS__
    otBigN:=o1
#else
    otBigN:SetValue(o1)
#endif
    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF
    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n+=9999.9999999999
        __ConOut(fhLog,cN+'+=9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN+="9999.9999999999"
#else
        otBigN:SetValue(otBigN:Add("9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Add(9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD 1 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst08(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ ADD Teste 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN cN:=("0."+Replicate("0",MIN(nACC_SET,10)))
    ASSIGN n:=Val(cN)
    otBigN:SetValue(cN)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n+=9999.9999999999
        __ConOut(fhLog,cN+'+=9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN+="9999.9999999999"
#else
        otBigN:SetValue(otBigN:Add("9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Add(9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD Teste 2 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst09(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ ADD Teste 3 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n+=-9999.9999999999
        __ConOut(fhLog,cN+'+=-9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN+="-9999.9999999999"
#else
        otBigN:SetValue(otBigN:add("-9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():add(-9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD Teste 3 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst10(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ SUB Teste 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n-=9999.9999999999
        __ConOut(fhLog,cN+'-=9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN-="9999.9999999999"
#else
        otBigN:SetValue(otBigN:Sub("9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Sub(9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 1 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst11(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ SUB Teste 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n-=9999.9999999999
        __ConOut(fhLog,cN+'-=9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN-="9999.9999999999"
#else
        otBigN:SetValue(otBigN:Sub("9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Sub(9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 2 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst12(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ SUB Teste 3 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN n-=-9999.9999999999
        __ConOut(fhLog,cN+'-=-9999.9999999999',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN-="-9999.9999999999"
#else
        otBigN:SetValue(otBigN:Sub("-9999.9999999999"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Sub(-9999.9999999999)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 3 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst13(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ MULT Teste 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN n:=1
    otBigN:SetValue(o1)
    otBigW:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN*="1.5"
#else
        otBigN:SetValue(otBigN:Mult("1.5"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Mult(1.5)',"RESULT: "+otBigN:ExactValue())
        ASSIGN cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:egMult("1.5"))
        __ConOut(fhLog,cN+':tBigNumber():egMult(1.5)',"RESULT: "+otBigW:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 1 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst14(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ MULT Teste 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN n:=1
    otBigN:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN*="1.5"
#else
        otBigN:SetValue(otBigN:Mult("1.5"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Mult(1.5)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 2 -------------- END")

     __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst15(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ MULT Teste 3 -------------- ")

    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN n:=1
    otBigW:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:egMult("1.5"))
        __ConOut(fhLog,cN+':tBigNumber():egMult(1.5)',"RESULT: "+otBigW:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 3 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst16(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ MULT Teste 4 -------------- ")

    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN w:=1
    otBigW:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(w)
        ASSIGN w*=3.555
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        ASSIGN cN:=otBigW:ExactValue()
#ifndef __PROTHEUS__
        otBigW*="3.555"
#else
        otBigW:SetValue(otBigW:Mult("3.555"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+otBigW:ExactValue())
        ASSIGN cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 4 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst17(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ MULT Teste 5 -------------- ")

    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN w:=1
    otBigW:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(w)
        ASSIGN w*=3.555
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        ASSIGN cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:egMult("3.555"))
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+otBigW:ExactValue())
        ASSIGN cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 5 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst18(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ MULT Teste 6 -------------- ")

    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN w:=1
    otBigW:SetValue(o1)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            __oRTime2:SetStep()
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(w)
        ASSIGN w*=3.555
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="0") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        ASSIGN z:=Len(cN)
        While ((SubStr(cN,-1)=="*") .and. (z>1))
            ASSIGN cN:=SubStr(cN,1,--z)
        End While
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        ASSIGN cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:rMult("3.555"))
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+otBigW:ExactValue())
        ASSIGN cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        ASSIGN cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 6 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst19(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER

    Local n         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste Factoring -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN n:=0
    While (n<=nN_TEST)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        #ifdef __PROTHEUS__
            otBigN:SetValue(cN)
        #else
            otBigN:=cN
        #endif
        __ConOut(fhLog,cN+':tBigNumber():Factorial()',"RESULT: "+otBigN:Factorial():ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        ASSIGN n+=nISQRT
    End While
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Factoring 0 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst20(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste GCD/LCM 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        ASSIGN cX:=hb_NtoS(x)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(nN_TEST)
            __oRTime2:SetStep(nISQRT)
            hb_mutexUnLock(__phMutex)
        EndIF
        For n:=nN_TEST To 1 Step -nISQRT
            ASSIGN cN:=hb_NtoS(n)
            ASSIGN cW:=otBigN:SetValue(cX):GCD(cN):ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():GCD('+cN+')',"RESULT: "+cW)
            ASSIGN cW:=otBigN:LCM(cN):ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():LCM('+cN+')',"RESULT: "+cW)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next n
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste GCD/LCM 0 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst21(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ DIV Teste 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
       hb_mutexUnLock(__phMutex)
    EndIF

    For n:=0 TO nN_TEST Step nISQRT
        ASSIGN cN:=hb_NtoS(n)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(nISQRT)
            __oRTime2:SetStep(nISQRT)
            hb_mutexUnLock(__phMutex)
        EndIF
        For x:=0 TO nISQRT Step nISQRT
            ASSIGN cX:=hb_NtoS(x)
            __ConOut(fhLog,cN+'/'+cX,"RESULT: "+hb_NtoS(n/x))
#ifndef __PROTHEUS__
            otBigN:=cN
            otBigW:=(otBigN/cX)
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+otBigW:ExactValue())
#else
            otBigN:SetValue(cN)
            otBigW:SetValue(otBigN:Div(cX))
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+otBigW:ExactValue())
#endif
            ASSIGN cW:=otBigW:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            ASSIGN cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            ASSIGN cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next x
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst22(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local n         AS NUMBER VALUE 19701215
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ DIV Teste 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN cN:=hb_NtoS(n)
    otBigN:SetValue(cN)

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cW:=hb_NtoS(n)
        ASSIGN n   /=1.5
        __ConOut(fhLog,cW+'/=1.5',"RESULT: "+hb_NtoS(n))
        ASSIGN cN:=otBigN:ExactValue()
#ifndef __PROTHEUS__
        otBigN/="1.5"
#else
        otBigN:SetValue(otBigN:Div("1.5"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Div(1.5)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 1 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst23(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")
    Local o3        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("3")

    Local cN        AS CHARACTER

    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ DIV Teste 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    otBigN:SetValue(o1)
    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(x)
        otBigN:SetValue(cN)
        __ConOut(fhLog,cN+"/3","RESULT: "+hb_NtoS(x/3))
#ifndef __PROTHEUS__
        otBigN/=o3
#else
        otBigN:SetValue(otBigN:Div(o3))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Div(3)',"RESULT: "+otBigN:ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 2 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst24(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste FI 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigW:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))
    //http://www.javascripter.net/math/calculators/eulertotientfunction.htm

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        __ConOut(fhLog,cN+':tBigNumber():FI()',"RESULT: "+otBigN:SetValue(cN):FI():ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste FI 0 -------------- END")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst25(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"")

    __ConOut(fhLog,"BEGIN ------------ Teste SQRT 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(((nISQRT*999)+999)-((nISQRT*999)-999))
        __oRTime1:SetStep(99)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=((nISQRT*999)-999) TO ((nISQRT*999)+999) STEP 99
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN n:=x
        ASSIGN cN:=hb_NtoS(n)
        __ConOut(fhLog,'SQRT('+cN+')',"RESULT: "+hb_NtoS(SQRT(n)))
        otBigN:SetValue(cN)
        otBigW:SetValue(otBigN:SQRT())
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+otBigW:ExactValue())
        ASSIGN cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        ASSIGN cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        ASSIGN cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste SQRT 1 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst26(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER
    Local x         AS NUMBER
    Local z         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"")

    __ConOut(fhLog,"BEGIN ------------ Teste SQRT 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=1 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN n:=x
        ASSIGN cN:=hb_NtoS(n)
        __ConOut(fhLog,'SQRT('+cN+')',"RESULT: "+hb_NtoS(SQRT(n)))
#ifndef __PROTHEUS__
        otBigN:=cN
        otBigN:=otBigN:SQRT()
#else
        otBigN:SetValue(cN)
        otBigN:SetValue(otBigN:SQRT())
#endif
        ASSIGN cW:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        ASSIGN cW:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        ASSIGN cW:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        ASSIGN cW:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste SQRT 2 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst27(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER

    Local n         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste Exp 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nISQRT+1)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=0 TO nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN n:=x
        ASSIGN cN:=hb_NtoS(n)
        __ConOut(fhLog,'Exp('+cN+')',"RESULT: "+hb_NtoS(Exp(n)))
#ifndef __PROTHEUS__
    otBigN:=cN
#else
    otBigN:SetValue(cN)
#endif
        otBigN:SetValue(otBigN:Exp():ExactValue())
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+otBigN:ExactValue())
        ASSIGN cW:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        ASSIGN cW:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        ASSIGN cW:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Exp 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst28(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste Pow 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    //Tem um BUG aqui. Servidor __PROTHEUS__ Fica Maluco se (0^-n) e Senta..........
    For x:=IF(.NOT.(IsHb()),1,0) TO nN_TEST Step nISQRT
        ASSIGN cN:=hb_NtoS(x)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(nISQRT)
            hb_mutexUnLock(__phMutex)
        EndIF
        For w:=-nISQRT To 0
            ASSIGN cW:=hb_NtoS(w)
            ASSIGN n:=x
            ASSIGN n:=(n^w)
            __ConOut(fhLog,cN+'^'+cW,"RESULT: "+hb_NtoS(n))
#ifndef __PROTHEUS__
            otBigN:=cN
#else
            otBigN:SetValue(cN)
#endif
            ASSIGN cN:=otBigN:ExactValue()

#ifndef __PROTHEUS__
            otBigN^=cW
#else
            otBigN:SetValue(otBigN:Pow(cW))
#endif
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+otBigN:ExactValue())
            ASSIGN cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            ASSIGN cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            ASSIGN cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next w
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst29(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER
    Local x         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste Pow 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nISQRT)
        __oRTime1:SetStep(5)
        hb_mutexUnLock(__phMutex)
    EndIF

    For x:=0 TO nISQRT STEP 5
        ASSIGN cN:=hb_NtoS(x)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(nISQRT)
            __oRTime2:SetStep(5)
            hb_mutexUnLock(__phMutex)
        EndIF
        For w:=0 To nISQRT STEP 5
            ASSIGN cW:=hb_NtoS(w+.5)
            ASSIGN n:=x
            ASSIGN n:=(n^(w+.5))
            __ConOut(fhLog,cN+'^'+cW,"RESULT: "+hb_NtoS(n))
            #ifndef __PROTHEUS__
                otBigN:=cN
            #else
                otBigN:SetValue(cN)
            #endif
            ASSIGN cN:=otBigN:ExactValue()
            #ifndef __PROTHEUS__
                otBigN^=cW
            #else
                otBigN:SetValue(otBigN:Pow(cW))
            #endif
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+otBigN:ExactValue())
            ASSIGN cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            ASSIGN cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            ASSIGN cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next w
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 1 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst30(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local n         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste Pow 2 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(2)
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To 2
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        IF (n==1)
            otBigN:SetValue("1.5")
            __ConOut(fhLog,"otBigN","RESULT: "+otBigN:ExactValue())
            __ConOut(fhLog,"otBigN:Pow('0.5')","RESULT: "+otBigN:SetValue(otBigN:Pow("0.5")):ExactValue())
            __ConOut(fhLog,"otBigN:Pow('0.5')","RESULT: "+otBigN:Rnd():ExactValue())
        Else
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:SetValue(otBigN:nthroot("0.5")):ExactValue())
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:Rnd():ExactValue())
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:Rnd(2):ExactValue())
        EndIF
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 2 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst31(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cX        AS CHARACTER

    Local o0        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("0")
    Local o1        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("1")
    Local o2        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("2")
    Local o3        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("3")
    Local o4        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("4")
    Local o5        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("5")
    Local o6        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("6")
    Local o7        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("7")
    Local o8        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("8")
    Local o9        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("9")
    Local o10       AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("10")

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste LOG 0 -------------- ")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(13)
        hb_mutexUnLock(__phMutex)
    EndIF

    otBigW:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    otBigW:SetDecimals(nACC_ALOG)
    otBigW:nthRootAcc(nACC_ALOG-1)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Ln():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Ln()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log2():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log2()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log10():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log10()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o1):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("1")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o2):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("2")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

     IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o3):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("3")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o4):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("4")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o5):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("5")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o6):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("6")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o7):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("7")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o8):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("8")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

     IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o9):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("9")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    ASSIGN cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o10):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("10")',"RESULT: "+cX)

    o0:=FreeObj(o0)
    o1:=FreeObj(o1)
    o2:=FreeObj(o2)
    o3:=FreeObj(o3)
    o4:=FreeObj(o4)
    o5:=FreeObj(o5)
    o6:=FreeObj(o6)
    o7:=FreeObj(o7)
    o8:=FreeObj(o8)
    o9:=FreeObj(o9)
    o10:=FreeObj(o10)

   __ConOut(fhLog,__cSep)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        hb_mutexUnLock(__phMutex)
    EndIF

    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LOG 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst32(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cN        AS CHARACTER
    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local n         AS NUMBER
    Local w         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"BEGIN ------------ Teste LOG 1 -------------- ")

    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    //Quer comparar o resultado:http://www.gyplclan.com/pt/logar_pt.html

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For w:=0 TO nN_TEST Step nISQRT
        ASSIGN cW:=hb_NtoS(w)
        otBigW:SetValue(cW)
        __ConOut(fhLog,'Log('+cW+')',"RESULT: "+hb_NtoS(Log(w)))
        ASSIGN cX:=otBigW:SetValue(cW):Log():ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
         otBigN:SetValue(cX)
        ASSIGN cX:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        ASSIGN cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        ASSIGN cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(INT(MAX(nISQRT,5)/5)+1)
            hb_mutexUnLock(__phMutex)
        EndIF
        For n:=0 TO INT(MAX(nISQRT,5)/5)
            ASSIGN cN:=hb_NtoS(n)
            ASSIGN cX:=otBigW:SetValue(cW):Log(cN):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            otBigN:SetValue(cX)
            ASSIGN cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            ASSIGN cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            ASSIGN cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            EndIF
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        Next n
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next w

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LOG 1 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst33(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local cW        AS CHARACTER
    Local cX        AS CHARACTER

    Local w         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste LN 1 -------------- ")

    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    //Quer comparar o resultado:http://www.gyplan.com/pt/logar_pt.html

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For w:=0 TO nN_TEST Step nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        ASSIGN cW:=hb_NtoS(w)
        ASSIGN cX:=otBigW:SetValue(cW):Ln():ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Ln()',"RESULT: "+cX)
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next w
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LN 1 -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst34(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local o2        AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("2")

    Local cN        AS CHARACTER

    Local n         AS NUMBER

    Local oPrime    AS OBJECT CLASS "TPRIME"     VALUE tPrime():New()

    Local lMR       AS LOGICAL
    Local lPn       AS LOGICAL

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste millerRabin 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    ASSIGN n:=0

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining((nISQRT/2)+1)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    EndIF

    While (n<=nISQRT)
        IF (n<3)
            ASSIGN n+=1
        Else
            __oRTime1:SetStep(2)
            ASSIGN n+=2
        EndIF
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN lPn:=oPrime:IsPrime(cN,.T.)
        ASSIGN lMR:=IF(lPn,lPn,otBigN:SetValue(cN):millerRabin(o2))
        __ConOut(fhLog,cN+':tBigNumber():millerRabin()',"RESULT: "+cValToChar(lMR)+IF(lMR,"","   "))
        __ConOut(fhLog,cN+':tPrime():IsPrime()',"RESULT: "+cValToChar(lPn)+IF(lPn,"","   "))
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    End While
    oPrime:IsPReset()
    oPrime:NextPReset()

    oPrime:=FreeObj(oPrime)

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste millerRabin 0 -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst35(fhLog)

    Local otBigN    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

    Local n         AS NUMBER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste RANDOMIZE 0 -------------- ")

    otBigN:SetDecimals(nACC_SET)

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To nISQRT
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        EndIF
        __ConOut(fhLog,'tBigNumber():Randomize()',"RESULT: "+otBigN:Randomize():ExactValue())
        __ConOut(fhLog,'tBigNumber():Randomize(999999999999,9999999999999)',"RESULT: "+otBigN:Randomize("999999999999","9999999999999"):ExactValue())
        __ConOut(fhLog,'tBigNumber():Randomize(1,9999999999999999999999999999999999999999"',"RESULT: "+otBigN:Randomize("1","9999999999999999999999999999999999999999"):ExactValue())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste RANDOMIZE  0 -------------- END")

    __ConOut(fhLog,__cSep)
    __ConOut(fhLog,"")
    __ConOut(fhLog,__cSep)

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst36(fhLog)

    Local cN            AS CHARACTER
    Local cW            AS CHARACTER

    Local n             AS NUMBER
    Local x             AS NUMBER

    Local aFibonacci    AS ARRAY

    PARAMTYPE 1 VAR fhLog AS NUMBER

   __ConOut(fhLog,"")

   __ConOut(fhLog,"BEGIN ------------ Teste Fibonacci -------------- ")

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    IF hb_mutexLock(__phMutex,0)
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:SetStep(nISQRT)
        hb_mutexUnLock(__phMutex)
    EndIF

    For n:=1 To nN_TEST STEP nISQRT
        ASSIGN cN:=hb_NtoS(n)
        ASSIGN aFibonacci:=Fibonacci(cN)
        IF hb_mutexLock(__phMutex,0)
            __oRTime2:SetRemaining(Len(aFibonacci))
            hb_mutexUnLock(__phMutex)
        EndIF
        For x:=1 To Len(aFibonacci)
            ASSIGN cW:=aFibonacci[x]
            __ConOut(fhLog,'Fibonacci('+cN+'):'+hb_NtoS(x),"RESULT: "+cW)
            IF hb_mutexLock(__phMutex,0)
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                hb_mutexUnLock(__phMutex)
            EndIF
        Next x
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        IF hb_mutexLock(__phMutex,0)
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        EndIF
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    Next n
    aSize(aFibonacci,0)
    aFibonacci:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif //__PROTHEUS__

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Fibonacci -------------- END")

    __ConOut(fhLog,"")

return
//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst37(fhLog)

    Local otBigW    AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New("2")

    Local cX        AS CHARACTER
    Local cW        AS CHARACTER

    PARAMTYPE 1 VAR fhLog AS NUMBER

    __ConOut(fhLog,"BEGIN ------------ Teste BIG Mersenne number -------------- ")

    IF hb_mutexLock(__phMutex,0)
       __oRTime1:SetRemaining(1)
       __oRTime2:SetRemaining(1)
       __oRTime2:SetStep(1/1000)
       __oRTime2:ForceStep(.T.)
       hb_mutexUnLock(__phMutex)
    EndIF

    Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    __ConOut(fhLog,'2:tBigNumber():Pow('+cCN_MERSENNE_POW+')',":...")

    otBigW:SetValue(otBigW:Pow(cCN_MERSENNE_POW))
    ASSIGN cX:=otBigW:ExactValue()
    ASSIGN cW:=otBigW:OpDec():ExactValue()
    __ConOut(fhLog,'2:tBigNumber():Pow('+cCN_MERSENNE_POW+')',"RESULT: "+cX)
    __ConOut(fhLog,'2:tBigNumber():Pow('+cCN_MERSENNE_POW+'):OpDec()',"RESULT: "+cW)
    IF hb_mutexLock(__phMutex,0)
        __oRTime2:ForceStep(.F.)
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    EndIF
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste BIG Mersenne number -------------- END")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

return
