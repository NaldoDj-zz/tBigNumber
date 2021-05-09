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
        #pragma -w3
    //--------------------------------------------------------------------------------------------------------
        #require "xhb"
        #require "hbct"
        #require "hbwin"
        #require "hbvmmt"
        #require "hbgtqtc"
        
        REQUEST HB_MT

    //--------------------------------------------------------------------------------------------------------
        #include "inkey.ch"
        #include "setcurs.ch"
        #include "hbgtinfo.ch"
    //--------------------------------------------------------------------------------------------------------
        #xtranslate Val([<prm,...>])     => hb_Val([<prm>])
    //--------------------------------------------------------------------------------------------------------
        memvar aAC_TSTEXEC
        memvar aC_OOPROGRESS
        memvar aACN_MERSENNE_POW

        memvar __cSep
        memvar __CRLF
        memvar cC_GT_MODE

        memvar nISQRT
        memvar nN_TEST
        memvar __nSLEEP
        memvar nACC_SET
        memvar nACC_ALOG
        memvar nROOT_ACC_SET

        memvar lDispML
        memvar lL_OOPROGRAND
        memvar lL_ROPROGRESS
        memvar lL_LOGPROCESS

        memvar __nCol
        memvar __nRow
        memvar __nMaxRow
        memvar __nMaxCol
        memvar __noProgress

        memvar __oRTime1
        memvar __oRTime2
        memvar __oRTimeProc

        memvar __phMutex
    //--------------------------------------------------------------------------------------------------------
#endif /*__HARBOUR__*/
//--------------------------------------------------------------------------------------------------------
#include "tBigNtst.ch"
#include "tBigNumber.ch"
//--------------------------------------------------------------------------------------------------------
#define __SETDEC__         16
#define __NRTTST__         38
#define __PADL_T__          2
#define N_MTX_TIMEOUT     NIL
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
#define AC_TSTEXEC        "1:17,-18,19:38"
//--------------------------------------------------------------------------------------------------------
//Mersenne:
//http://mathworld.wolfram.com/MersennePrime.html
//https://en.wikipedia.org/wiki/Mersenne_prime
#ifdef __HARBOUR__
    #ifdef __PTCOMPAT__
        //1..15,(#...49) Mersenne prime List
        #define ACN_MERSENNE_POW "2,3,4,5,13,17,19,31,61,89,107,127,521,607,1279"+CRLF+"#ACN_MERSENNE_POW=2203,2281,3217,4253,4423,9689,9941,11213,19937,21701,23209,44497,86243,110503,132049,216091,756839,859433,1257787,1398269,2976221,3021377,6972593,13466917,20996011,24036583,25964951,30402457,32582657,37156667,42643801,43112609,57885161,74207281,77232917"
    #else
         //1..38,(#...49) Mersenne prime List
        #define ACN_MERSENNE_POW "2,3,4,5,13,17,19,31,61,89,107,127,521,607,1279,2203,2281,3217,4253,4423,9689,9941,11213,19937,21701,23209,44497,86243,110503,132049,216091,756839,859433,1257787,1398269,2976221,3021377,6972593"+CRLF+"#ACN_MERSENNE_POW=13466917,20996011,24036583,25964951,30402457,32582657,37156667,42643801,43112609,57885161,74207281,77232917"
    #endif /*__PTCOMPAT__*/
#else /*__ADVPL__*/
    //1..15,(#...49) Mersenne prime List
    #define ACN_MERSENNE_POW     "2,3,4,5,13,17,19,31,61,89,107,127,521,607,1279"+CRLF+";ACN_MERSENNE_POW=2203,2281,3217,4253,4423,9689,9941,11213,19937,21701,23209,44497,86243,110503,132049,216091,756839,859433,1257787,1398269,2976221,3021377,6972593,13466917,20996011,24036583,25964951,30402457,32582657,37156667,42643801,43112609,57885161,74207281,77232917"
#endif /*__HARBOUR__*/
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    function Main()

        local aSect             as array
        local aScreen           as array
        local atBigNtst         as array

        local cIni              as character

        local cKey              as character
        local cSection          as character
        local cChrDOut          as character
        local cDispOut          as character

        local hIni              as hash

        local nRow              as numeric
        local nCol              as numeric
        local nSRow             as numeric
        local nSCol             as numeric
        local nScreen           as numeric
        local nMaxScrRow        as numeric
        local nMaxScrCol        as numeric
        local nSMaxScrRow       as numeric
        local nSMaxScrCol       as numeric
        local nTMaxRolCol       as numeric

        local lChangeC          as logical
        local lFinalize         as logical

        local ptftBigtstThread  as pointer
        local ptttBigtstThread  as pointer

        CLS

        #ifdef __ALT_D__    // Compile with -b
            AltD(1)         // Enables the debugger. Press F5 to go.
            AltD()          // Invokes the debugger
        #endif

        private aAC_TSTEXEC         as array
        private aACN_MERSENNE_POW   as array
        private aC_OOPROGRESS       as array

        private cC_GT_MODE          as character

        private nN_TEST             as numeric
        private __nSLEEP            as numeric
        private nACC_SET            as numeric
        private nACC_ALOG           as numeric
        private nROOT_ACC_SET       as numeric

        private lDispML             as logical
        private lL_OOPROGRAND       as logical
        private lL_ROPROGRESS       as logical
        private lL_LOGPROCESS       as logical

        lDispML:=.T.

        #if defined( __HBSCRIPT__HBSHELL )
           #if defined( __PLATFORM__WINDOWS )
              hbshell_gtSelect( "GTWVT" )
           #elif defined( __PLATFORM__UNIX )
              hbshell_gtSelect( "GTXWC" )
           #endif
        #else
            #ifdef __HBSHELL_USR_DEF_GT
                hbshell_gtSelect(HBSHELL_GTSELECT)
            #endif
        #endif

        cIni:="tBigNtst.ini"
        hIni:=hb_iniRead(cIni)

        if (.NOT.(File(cIni)).or.Empty(hIni))
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
            hIni["GENERAL"]["ACN_MERSENNE_POW"]:=ACN_MERSENNE_POW
            hb_iniWrite(cIni,hIni,"#tBigNtst.ini","#end of file")
            hIni:=hb_iniRead(cIni)
        endif

        if (File(cIni)).and.(.NOT.(Empty(hIni)))
            for each cSection in hIni:Keys
                aSect:=hIni[cSection]
                for each cKey in aSect:Keys
                    switch Upper(cKey)
                        case "ACC_SET"
                            nACC_SET:=Val(aSect[cKey])
                            EXIT
                        case "ROOT_ACC_SET"
                            nROOT_ACC_SET:=Val(aSect[cKey])
                            EXIT
                        case "ACC_ALOG"
                            nACC_ALOG:=Val(aSect[cKey])
                            EXIT
                        case "__SLEEP"
                            __nSLEEP:=Val(aSect[cKey])
                            EXIT
                        case "N_TEST"
                            nN_TEST:=Val(aSect[cKey])
                            EXIT
                        case "C_OOPROGRESS"
                            aC_OOPROGRESS:=_StrTokArr(Upper(AllTrim(aSect[cKey])),",")
                            EXIT
                        case "L_OOPROGRAND"
                            lL_OOPROGRAND:=(aSect[cKey]=="1")
                            EXIT
                        case "L_ROPROGRESS"
                            lL_ROPROGRESS:=(aSect[cKey]=="1")
                            EXIT
                        case "L_LOGPROCESS"
                            lL_LOGPROCESS:=(aSect[cKey]=="1")
                            EXIT
                        case "C_GT_MODE"
                            cC_GT_MODE:=Upper(AllTrim(aSect[cKey]))
                            EXIT
                        case "AC_TSTEXEC"
                            aAC_TSTEXEC:=_StrTokArr(AllTrim(aSect[cKey]),",")
                            EXIT
                        case "ACN_MERSENNE_POW"
                            aACN_MERSENNE_POW:=_StrTokArr(aSect[cKey],",")
                            EXIT
                    endswitch
                next cKey
            next cSection
        endif

        nACC_SET:=if(Empty(nACC_SET),Val(ACC_SET),nACC_SET)
        nROOT_ACC_SET:=if(Empty(nROOT_ACC_SET),Val(ROOT_ACC_SET),nROOT_ACC_SET)
        nACC_ALOG:=if(Empty(nACC_ALOG),Val(ACC_ALOG),nACC_ALOG)
        __nSLEEP:=if(Empty(__nSLEEP),Val(__SLEEP),__nSLEEP)
        nN_TEST:=if(Empty(nN_TEST),Val(N_TEST),nN_TEST)
        aC_OOPROGRESS:=if(Empty(aC_OOPROGRESS),_StrTokArr(Upper(AllTrim(C_OOPROGRESS)),","),aC_OOPROGRESS)
        lL_OOPROGRAND:=if(Empty(lL_OOPROGRAND),L_OOPROGRAND=="1",lL_OOPROGRAND)
        lL_ROPROGRESS:=if(Empty(lL_ROPROGRESS),L_ROPROGRESS=="1",lL_ROPROGRESS)
        lL_LOGPROCESS:=if(Empty(lL_LOGPROCESS),L_LOGPROCESS=="1",lL_LOGPROCESS)
        cC_GT_MODE:=if(Empty(cC_GT_MODE),C_GT_MODE,cC_GT_MODE)
        aAC_TSTEXEC:=if(Empty(aAC_TSTEXEC),_StrTokArr(AllTrim(AC_TSTEXEC),","),aAC_TSTEXEC)
        aACN_MERSENNE_POW:=if(Empty(aACN_MERSENNE_POW),_StrTokArr(AllTrim(StrTran(StrTran(subStr(ACN_MERSENNE_POW,1,rAT("#ACN_MERSENNE_POW",ACN_MERSENNE_POW)-1),"#",""),CRLF,"")),","),aACN_MERSENNE_POW)

        __SetCentury("ON")
        SET DATE TO BRITISH

        __nSLEEP:=Min(__nSLEEP,10)
        if ((__nSLEEP)>10)
            __nSLEEP/=10
        endif

        /* set OEM font encoding for non unicode modes*/
        hb_gtInfo(HB_GTI_CODEPAGE,255)
        hb_gtInfo(HB_GTI_BOXCP,hb_cdpSelect())
        hb_gtInfo(HB_GTI_COMPATBUFFER,.T.)
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
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br] :: PID["+hb_NtoS(GETCURRENTPROCESSID())+"]")
        hb_gtInfo(HB_GTI_ICONRES,"Main")
        hb_gtInfo(HB_GTI_MOUSESTATUS,1)
        *hb_gtInfo(HB_GTI_NOTIFIERBLOCK,{|nEvent,...|myGTIEvent(nEvent,...)})

        ChkIntTstExec(@aAC_TSTEXEC,__PADL_T__)
        atBigNtst:=GettBigNtst(cC_GT_MODE,aAC_TSTEXEC)

        if (cC_GT_MODE=="MT")

            lFinalize:=.F.

            ptftBigtstThread:=@tBigtstThread()

            ptttBigtstThread:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
            ptftBigtstThread,@lFinalize,atBigNtst,nMaxScrRow,nMaxScrCol)

 #ifdef __0
            nRow:=Row()
            nCol:=Col()
#endif /*__0*/

            nScreen:=0
            lChangeC:=.F.
            cChrDOut:=Chr(254)
            cDispOut:=cChrDOut
            nSMaxScrRow:=(nMaxScrRow+1)
            nSMaxScrCol:=(nMaxScrCol+1)
            nTMaxRolCol:=(nSMaxScrRow*nSMaxScrCol)
            aScreen:=Array(nSMaxScrRow,nSMaxScrCol)
            aEval(aScreen,{|x as array|aFill(x,.T.)})

            while (.NOT.(lFinalize))
 
                DispBegin()
     
     #ifdef __0
                    if(++nCol>=nMaxScrCol)
                        if (++nRow>=nMaxScrRow)
                            nRow:=0
                        endif
                        nCol:=0
                    endif
                    nRow:=HB_RandomInt(nRow,nMaxScrRow)
                    nCol:=HB_RandomInt(nCol,nMaxScrCol)
    #else
                    nRow:=HB_RandomInt(0,nMaxScrRow)
                    nCol:=HB_RandomInt(0,nMaxScrCol)
    #endif /*__0*/
                    nSRow:=(nRow+1)
                    nSCol:=(nCol+1)
                    if (aScreen[nSRow][nSCol])
                        nScreen:=0
                        lChangeC:=(.NOT.(lChangeC))
                        DispBegin()
                        DispOutAT(nRow,nCol,cDispOut,if(lChangeC,"w+/n","w+/n"))
                        DispEnd()
                        aScreen[nSRow][nSCol]:=.F.
                        aEval(aScreen,{|x as array|aEval(x,{|y as numeric|nScreen+=if(y,0,1)})})
                        if (nScreen==nTMaxRolCol)
                            cDispOut:=if(cDispOut==cChrDOut," ",cChrDOut)
                            aEval(aScreen,{|x as array|aFill(x,.T.)})
                        endif
                    endif
                DispEnd()
            end while

            hb_threadQuitRequest(ptttBigtstThread)
            hb_ThreadWait(ptttBigtstThread)
            tBigNGC()

        else

            tBigNtst(atBigNtst)

        endif

        return(0)
    /*function Main*/
    //--------------------------------------------------------------------------------------------------------
    static procedure tBigtstThread(lFinalize as logical,atBigNtst as array,nMaxScrRow as numeric,nMaxScrCol as numeric)

        local oThreads  as object

        local nThAT     as numeric
        local nThread   as numeric
        local nThreads  as numeric

        nThreads:=0

        aEval(atBigNtst,{|e as array|if(e[2],++nThreads,NIL)})

        if (nThreads>0)
            //"Share publics and privates with child threads."
            oThreads:=tBigNThread():New()
            oThreads:Start(nThreads,HB_THREAD_INHERIT_MEMVARS)
            nThAT:=0
            while ((nThAT:=aScan(atBigNtst,{|e as array|e[2]},nThAT+1))>0)
                nThread:=nThreads
                oThreads:setEvent(nThread,{@tBigtstEval(),atBigNtst[nThAT],nMaxScrRow,nMaxScrCol})
                --nThreads
            end while
            oThreads:Notify()
            oThreads:Wait()
            oThreads:Join()
        endif

        lFinalize:=.T.

        return
    /*static procedure tBigtstThread*/

    //--------------------------------------------------------------------------------------------------------
    static procedure tBigtstEval(atBigNtst as array,nMaxScrRow as numeric,nMaxScrCol as numeric)
        local pGT   as pointer
        pGT:=hb_gtSelect(atBigNtst[3])
        hb_gtInfo(HB_GTI_ICONRES,"AppIcon")
        /* set OEM font encoding for non unicode modes*/
        hb_gtInfo(HB_GTI_CODEPAGE,255)
        hb_gtInfo(HB_GTI_BOXCP,hb_cdpSelect())
        hb_gtInfo(HB_GTI_COMPATBUFFER,.T.)
        /* set EN CP-437 encoding*/
        hb_cdpSelect("EN")
        hb_setTermCP("EN")
        /* set font size*/
        hb_gtInfo(HB_GTI_FONTWIDTH,6+4)
        hb_gtInfo(HB_GTI_FONTSIZE,12+4)
        /* resize console window to the screen size*/
        SetMode(nMaxScrRow,nMaxScrCol)
        /* set window title*/
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br] :: PID["+hb_NtoS(GETCURRENTPROCESSID())+"]")
        hb_gtInfo(HB_GTI_MOUSESTATUS,1)
        *hb_gtInfo(HB_GTI_NOTIFIERBLOCK,{|nEvent,...|myGTIEvent(nEvent,...)})
        myGTIEvent()
        tBigNtst({atBigNtst})
        hb_gtSelect(pGT)
        hb_gtInfo(HB_GTI_ICONRES,"Main")
        atBigNtst[3]:=NIL
        tBigNGC()
        return
    /*static procedure tBigtstEval*/

    //--------------------------------------------------------------------------------------------------------
    static procedure myGTIEvent(nEvent as numeric)
        DEFAULT nEvent:=0
        #ifndef HB_GTE_CLOSE
            #define HB_GTE_CLOSE 4
        #endif
        switch nEvent
            case HB_GTE_CLOSE
                QUIT
                exit
            otherwise
                ? hb_gtInfo(HB_GTI_MOUSEPOS_XY)
                exit
        endswitch
        return
    /*static procedure myGTIEvent*/

    //--------------------------------------------------------------------------------------------------------
    static procedure tBigNtst(atBigNtst as array)

#else /*__ADVPL__*/
        //--------------------------------------------------------------------------------------------------------
        #xtranslate ExeName() => ProcName()
        //----------------------------------------------------------
        //Obs.: TAMANHO MAXIMO DE UMA STRING NO PROTHEUS 1.048.575
        //      (1.048.575+1)->String size overflow!
        //      Harbour -> no upper limit

        User function tBigNtst()

            local atBigNtst             as array

            local cIni                  as character

            local otFIni                as object

            private aAC_TSTEXEC         as array
            private aC_OOPROGRESS       as array
            private aACN_MERSENNE_POW   as array

            private cC_GT_MODE          as character

            private nN_TEST             as numeric
            private __nSLEEP            as numeric
            private nACC_SET            as numeric
            private nACC_ALOG           as numeric
            private nROOT_ACC_SET       as numeric

            private lL_OOPROGRAND       as logical
            private lL_ROPROGRESS       as logical
            private lL_LOGPROCESS       as logical

            cIni:="tBigNtst.ini"

            if (Findfunction("U_TFINI")) //NDJLIB020.PRG
                otFIni:=u_TFINI(cIni)
                if (.NOT.File(cIni))
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
                    otFIni:AddNewProperty("GENERAL","ACN_MERSENNE_POW",ACN_MERSENNE_POW)
                    otFIni:SaveAs(cIni)
                    otFIni:=u_TFINI(cIni)
                endif
                if (.NOT.(otFIni:lHasError))
                    nACC_SET:=Val(oTFINI:GetPropertyValue("GENERAL","ACC_SET",ACC_SET))
                    nROOT_ACC_SET:=Val(oTFINI:GetPropertyValue("GENERAL","ROOT_ACC_SET",ROOT_ACC_SET))
                    nACC_ALOG:=Val(oTFINI:GetPropertyValue("GENERAL","ACC_ALOG",ACC_ALOG))
                    __nSLEEP:=Val(oTFINI:GetPropertyValue("GENERAL","__SLEEP",__SLEEP))
                    nN_TEST:=Val(oTFINI:GetPropertyValue("GENERAL","N_TEST",N_TEST))
                    aC_OOPROGRESS:=_StrTokArr(Upper(AllTrim(oTFINI:GetPropertyValue("GENERAL","C_OOPROGRESS",C_OOPROGRESS))),",")
                    lL_OOPROGRAND:=(oTFINI:GetPropertyValue("GENERAL","L_OOPROGRAND",L_OOPROGRAND)=="1")
                    lL_ROPROGRESS:=(oTFINI:GetPropertyValue("GENERAL","L_ROPROGRESS",L_ROPROGRESS)=="1")
                    lL_LOGPROCESS:=(oTFINI:GetPropertyValue("GENERAL","L_LOGPROCESS",L_LOGPROCESS)=="1")
                    cC_GT_MODE:=Upper(AllTrim(oTFINI:GetPropertyValue("GENERAL","C_GT_MODE",C_GT_MODE)))
                    aAC_TSTEXEC:=_StrTokArr(AllTrim(oTFINI:GetPropertyValue("GENERAL","AC_TSTEXEC",AC_TSTEXEC)),",")
                    aACN_MERSENNE_POW:=_StrTokArr(AllTrim(oTFINI:GetPropertyValue("GENERAL","ACN_MERSENNE_POW",StrTran(StrTran(subStr(ACN_MERSENNE_POW,1,rAT(";ACN_MERSENNE_POW",ACN_MERSENNE_POW)-1),";",""),CRLF,""))),",")
                endif
            endif

            nACC_SET:=if(Empty(nACC_SET),Val(ACC_SET),nACC_SET)
            nROOT_ACC_SET:=if(Empty(nROOT_ACC_SET),Val(ROOT_ACC_SET),nROOT_ACC_SET)
            nACC_ALOG:=if(Empty(nACC_ALOG),Val(ACC_ALOG),nACC_ALOG)
            __nSLEEP:=if(Empty(__nSLEEP),Val(__SLEEP),__nSLEEP)
            nN_TEST:=if(Empty(nN_TEST),Val(N_TEST),nN_TEST)
            aC_OOPROGRESS:=if(Empty(aC_OOPROGRESS),_StrTokArr(Upper(AllTrim(C_OOPROGRESS)),","),aC_OOPROGRESS)
            lL_OOPROGRAND:=if(Empty(lL_OOPROGRAND),L_OOPROGRAND=="1",lL_OOPROGRAND)
            lL_ROPROGRESS:=if(Empty(lL_ROPROGRESS),L_ROPROGRESS=="1",lL_ROPROGRESS)
            lL_LOGPROCESS:=if(Empty(lL_LOGPROCESS),L_LOGPROCESS=="1",lL_LOGPROCESS)
            cC_GT_MODE:=if(Empty(cC_GT_MODE),C_GT_MODE,cC_GT_MODE)
            aAC_TSTEXEC:=if(Empty(aAC_TSTEXEC),_StrTokArr(AllTrim(AC_TSTEXEC),","),aAC_TSTEXEC)
            aACN_MERSENNE_POW:=if(Empty(aACN_MERSENNE_POW),_StrTokArr(StrTran(StrTran(ACN_MERSENNE_POW,";",""),CRLF,""),","),aACN_MERSENNE_POW)
            __nSLEEP:=Max(__nSLEEP,10)

            if ((__nSLEEP)<10)
                __nSLEEP*=10
            endif

            ChkIntTstExec(@aAC_TSTEXEC,2)
            atBigNtst:=GettBigNtst(cC_GT_MODE,aAC_TSTEXEC)

            return(tBigNtst(@atBigNtst))
        /*User function tBigNtst*/

    //--------------------------------------------------------------------------------------------------------
    static function tBigNtst(atBigNtst as array)

#endif /*__ADVPL__*/

        #ifdef __HARBOUR__
            local tsBegin           as datetime
            local nsElapsed
        #endif

            local dStartDate        as date
            local dEndDate          as date
            local cStartTime        as character
            local cEndTime          as character

        #ifdef __HARBOUR__
            local cFld              as character
            local cLog              as character
            local ntBigNtst         as numeric
            local ptfProgress       as pointer
            local pttProgress       as pointer
            local ptfftProgress     as pointer
            local pttftProgress     as pointer
        #else /*__ADVPL__*/
            local cLog              as character
        #endif /*__HARBOUR__*/

            local fhLog             as numeric

        #ifdef __HARBOUR__

            local lKillProgress     as logical

            ptfProgress:=@Progress()
            ptfftProgress:=@ftProgress()

            #ifdef __ALT_D__
                lKillProgress:=.T.
            #else
                lKillProgress:=.F.
            #endif /*__ALT_D__*/

            private __nMaxRow       as numeric
            __nMaxRow:=(MaxRow()-13)

            private __nMaxCol       as numeric
            __nMaxCol:=MaxCol()

            private __nCol          as numeric
            __nCol:=Int((__nMaxCol)/2)

            private __nRow          as numeric
            __nRow:=0

            private __noProgress    as numeric
            __noProgress:=Int(((__nMaxCol)/3)-(__nCol/6))

            private __cSep          as character
            __cSep:=Replicate("-",__nMaxCol)

            ntBigNtst:=0
            aEval(atBigNtst,{|e as array|if(e[2],++ntBigNtst,NIL)})

            private __oRTimeProc    as object
            __oRTimeProc:=tRemaining():New(ntBigNtst)

            cFld:=tbNCurrentFolder()+hb_ps()+"tbigN_log"+hb_ps()
            cLog:=cFld+"tBigNtst_"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,999),3)+".log"

            if ((cC_GT_MODE=="MT").and.(ntBigNtst==1))
                cLog:=StrTran(cLog,"tBigNtst_",PadL(atBigNtst[ntBigNtst][5],__PADL_T__,"0")+"_tBigNtst_")
            endif

            MakeDir(cFld)

        #else /*__ADVPL__*/

            cLog:=GetTempPath()+"\tBigNtst_"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(Randomize(1,999),3)+".log"

            private __cSep          as character
            __cSep:="---------------------------------------------------------"
            private __oRTimeProc    as object
            __oRTimeProc:=tRemaining():New(1)

        #endif

            private __phMutex       as pointer
            __phMutex:=hb_mutexCreate()

            private __CRLF          as character
            __CRLF:=CRLF

            private __oRTime1       as object
            __oRTime1:=tRemaining():New()

            private __oRTime2       as object
            __oRTime2:=tRemaining():New()

            fhLog:=if(lL_LOGPROCESS,fCreate(cLog,FC_NORMAL),-1)
            if (lL_LOGPROCESS)
                fClose(fhLog)
                fhLog:=fOpen(cLog,FO_READWRITE+FO_SHARED)
            endif

            private nISQRT          as numeric
            nISQRT:=Int(SQRT(nN_TEST))

        #ifdef __HARBOUR__
            DispBegin()
            SetColor("w+/n")
            SetCursor(SC_NONE)
            BuildScreen(fhLog,__nMaxCol)
        #endif

            __ConOut(fhLog,__cSep)                                              //3
            #ifdef __HARBOUR__
                DispOutAT(3,(__nCol-1),"[ ]")
            #endif

            __ConOut(fhLog,"START ")                                            //4

            dStartDate:=Date()
            __ConOut(fhLog,"DATE        : ",dStartDate)                         //5

            cStartTime:=Time()
            __ConOut(fhLog,"TIME        : ",cStartTime)                         //6

            #ifdef __HARBOUR__
                tsBegin:=HB_DATETIME()
                __ConOut(fhLog,"TIMESTAMP   : ",HB_TTOC(tsBegin))               //7
            #endif /*__HARBOUR__*/

            #ifdef TBN_DBFILE
                #ifndef TBN_MEMIO
                    __ConOut(fhLog,"USING       : ",ExeName()+" :: DBFILE")     //8
                #else
                    __ConOut(fhLog,"USING       : ",ExeName()+" :: DBMEMIO")    //8
                #endif /*TBN_MEMIO*/
            #else
                #ifdef TBN_ARRAY
                    __ConOut(fhLog,"USING       : ",ExeName()+" :: ARRAY")      //8
                #else
                    __ConOut(fhLog,"USING       : ",ExeName()+" :: STRING")     //8
                #endif /*TBN_ARRAY*/
            #endif /*TBN_DBFILE*/

            #ifdef __HARBOUR__
                __ConOut(fhLog,"FINAL1      : ","["+StrZero(__oRTime1:GetnProgress(),16)+"/"+StrZero(__oRTime1:GetnTotal(),16)+"]|["+DtoC(__oRTime1:GetdendTime())+"]["+__oRTime1:GetcEndTime()+"]|["+__oRTime1:GetcAverageTime()+"]") //9
                __ConOut(fhLog,"FINAL2      : ","["+StrZero(__oRTime2:GetnProgress(),16)+"/"+StrZero(__oRTime2:GetnTotal(),16)+"]|["+DtoC(__oRTime2:GetdendTime())+"]["+__oRTime2:GetcEndTime()+"]|["+__oRTime2:GetcAverageTime()+"]") //10
                __ConOut(fhLog,"")                                              //11
                __ConOut(fhLog,"")                                              //12
                DispOutAT(12,__noProgress,"["+Space(__noProgress)+"]","w+/n")   //12
            #endif /*__HARBOUR__*/

            __ConOut(fhLog,"")                                                  //13

            #ifdef __HARBOUR__
                DispOutAT(14,0,Replicate("*",__nMaxCol),"w+/n")                 //14
                DispOutAT(__nMaxRow+1,0,Replicate("*",__nMaxCol),"w+/n")        //14
            #endif

            __ConOut(fhLog,"")                                                  //15

            #define __NROWAT    15

            #ifdef __HARBOUR__
                pttProgress:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
                ptfProgress,@lKillProgress,@__oRTimeProc,@__phMutex,__nCol,aC_OOPROGRESS,__noProgress,__nSLEEP,__nMaxCol,lL_OOPROGRAND,lL_ROPROGRESS)
                pttftProgress:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
                ptfftProgress,@lKillProgress,__nSLEEP,__nMaxCol,__nMaxRow)
            #endif /*__HARBOUR__*/

        #ifdef __HARBOUR__
            __nRow:=__nMaxRow
            DispEnd()
        #endif

            aEval(atBigNtst,{|e|if(e[2],Eval(e[1],fhLog),NIL)})

        #ifdef __HARBOUR__
            __nRow:=__nMaxRow
            DispBegin()
        #endif /*__HARBOUR__*/

            __ConOut(fhLog,"end ")

            dEndDate:=Date()
            __ConOut(fhLog,"DATE    :",dEndDate)

            cEndTime:=Time()
            __ConOut(fhLog,"TIME    :",cEndTime)

            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTimeProc:Calcule(.F.)
                __ConOut(fhLog,"ELAPSED :",__oRTimeProc:GetcTimeDiff())
                hb_mutexUnLock(__phMutex)
            endif

            #ifdef __HARBOUR__
                nsElapsed:=(HB_DATETIME()-tsBegin)
                __ConOut(fhLog,"tELAPSED:",StrTran(StrTran(HB_TTOC(HB_NTOT(nsElapsed)),"/","")," ",""))
            #endif /*__HARBOUR__*/

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

        #ifdef __ADVPL__
            #ifdef TBN_DBFILE
                tBigNGC()
            #endif
        #else /*__HARBOUR__*/
            DispEnd()
            lKillProgress:=.T.
            hb_threadQuitRequest(pttProgress)
            hb_threadQuitRequest(pttftProgress)
            hb_ThreadWait(pttProgress)
            hb_ThreadWait(pttftProgress)
            tBigNGC()
            SET COLOR TO "r+/n"
            __tbnSleep(.5)
            if (.NOT.(cC_GT_MODE=="MT"))
                WAIT "Press any key to end"
            endif
            CLS
        #endif /*__ADVPL__*/

        return
    /*static procedure tBigNtst*/

//--------------------------------------------------------------------------------------------------------
static function ChkIntTstExec(aAC_TSTEXEC as array,nPad as numeric)

    local aTmp  as array

    local bAsc  as block
    local bSrt  as block

    local nD    as numeric
    local nJ    as numeric
    local nTmp  as numeric

    nJ:=Len(aAC_TSTEXEC)
    for nD:=1 to nJ
        if (":"$aAC_TSTEXEC[nD])
            aTmp:=_StrTokArr(AllTrim(aAC_TSTEXEC[nD]),":")
            nTmp:=Len(aTmp)
            if (nTmp>=1)
                if (nTmp==1)
                    aAC_TSTEXEC[nD]:=aTmp[1]
                else
                    for nTmp:=Val(aTmp[1]) to Val(aTmp[2])
                        aAdd(aAC_TSTEXEC,hb_NtoS(nTmp))
                    next nTmp
                endif
            endif
        endif
    next nD

    #ifdef __HARBOUR__
        bAsc:={|e as character|":"$e}
    #else
        bAsc:={|e|":"$e}
    #endif /*__HARBOUR__*/

    nJ:=Len(aAC_TSTEXEC)

    while ((nTmp:=aScan(aAC_TSTEXEC,bAsc))>0)
        aSize(aDel(aAC_TSTEXEC,nTmp),--nJ)
    end while

    #ifdef __HARBOUR__
        bSrt:={|x as character,y as character|PadL(x,nPad)<PadL(y,nPad)}
    #else
        DEFAULT nPad:=__PADL_T__
        bSrt:={|x,y|PadL(x,nPad)<PadL(y,nPad)}
    #endif /*__HARBOUR__*/

    aSort(aAC_TSTEXEC,NIL,NIL,bSrt)

    return(.T.)
/*static procedure ChkIntTstExec*/

//--------------------------------------------------------------------------------------------------------
static function GettBigNtst(cC_GT_MODE as character,aAC_TSTEXEC as array)

    local atBigNtst as array

    local bAsc      as block

    local nD        as numeric
    local nJ        as numeric

    local lAll      as logical

    #ifndef __PTCOMPAT__
        local pGT   as pointer
    #endif

    nJ:=__NRTTST__

    #ifdef __HARBOUR__
        bAsc:={|c as character|(c=="*")}
    #else
        bAsc:={|c|(c=="*")}
    #endif /*__HARBOUR__*/

    lAll:=(aScan(aAC_TSTEXEC,bAsc)>0)
    atBigNtst:=Array(nJ,if((cC_GT_MODE=="MT"),5,2))

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
    atBigNtst[38][1]:={|p|tBigNtst38(p)}

    #ifdef __HARBOUR__
        bAsc:={|c as character|(nD==Val(c))}
    #else
        bAsc:={|c|(nD==Val(c))}
    #endif /*__HARBOUR__*/

    for nD:=1 to nJ
        atBigNtst[nD][2]:=(lAll.or.(aScan(aAC_TSTEXEC,bAsc)>0))
        if ((atBigNtst[nD][2]).and.(cC_GT_MODE=="MT"))
            #ifndef __PTCOMPAT__
                atBigNtst[nD][3]:=hb_gtCreate(THREAD_GT)
                pGT:=hb_gtSelect(atBigNtst[nD][3])
                hb_gtInfo(HB_GTI_ICONRES,"AppIcon")
                *hb_gtInfo(HB_GTI_NOTIFIERBLOCK,{|nEvent,...|myGTIEvent(nEvent,...)})
                hb_gtSelect(pGT)
                atBigNtst[nD][4]:=nD
                atBigNtst[nD][5]:=hb_NtoS(nD)
            #endif
        endif
    next nD

    return(atBigNtst)
/*static function GettBigNtst*/

//--------------------------------------------------------------------------------------------------------
static function _StrTokArr(cStr as character,cToken as character)
    local cDToken   as character
    DEFAULT cStr:=""
    DEFAULT cToken:=";"
    cDToken:=(cToken+cToken)
    while (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    end while
 #ifdef PROTHEUS
    return(StrTokArr2(cStr,cToken))
#else
    return(hb_aTokens(cStr,cToken))
#endif
/*static function _StrTokArr*/

//--------------------------------------------------------------------------------------------------------
static procedure __tbnSleep(nSleep as numeric)
    DEFAULT nSleep:=__nSLEEP
    if (.f.)
        __tbnSleep(@nSleep)
    endif
    tBigNSleep(nSleep)
    return
/*static procedure __tbnSleep*/

//--------------------------------------------------------------------------------------------------------
static procedure __ConOut(fhLog as numeric,e,d)

    local ld    as logical
    local lTBeg as logical

    local p     as character

    local nATd  as numeric

    local x
    local y

#ifdef __HARBOUR__

    local cDOAt  as character
    local nLines as numeric
    local nCLine as numeric
    local lSep   as logical
    local lMRow  as logical

#endif

    ld:=(.NOT.(Empty(d)))

    x:=cValToChar(e)

    if (ld)
        y:=cValToChar(d)
        nATd:=AT("RESULT",y)
    else
        y:=""
    endif

    p:=x+if(ld," "+y,"")

#ifdef __HARBOUR__

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        ShowFinalProc()
        hb_mutexUnLock(__phMutex)
    endif

    DispBegin()

    DEFAULT __nRow:=0
    lSep:=(p==__cSep)

    if (lDispML)
        nLines:=MLCount(p,__nMaxCol,NIL,.T.)
        for nCLine:=1 to nLines
            cDOAt:=MemoLine(p,__nMaxCol,nCLine,NIL,.T.)
            if (++__nRow>=__nMaxRow)
                @ __NROWAT,0 CLEAR TO __nMaxRow,__nMaxCol
                __nRow:=__NROWAT
            endif
            lMRow:=(__nRow>=__NROWAT)
            DispOutAT(__nRow,0,cDOAt,if((.NOT.(lSep)).and.lMRow,"w+/n",if(lSep.and.lMRow,"c+/n","w+/n")))
        next nCLine
    else
        if (++__nRow>=__nMaxRow)
            @ __NROWAT,0 CLEAR TO __nMaxRow,__nMaxCol
            __nRow:=__NROWAT
        endif
        lMRow:=(__nRow>=__NROWAT)
        DispOutAT(__nRow,0,p,if((.NOT.(lSep)).and.lMRow,"w+/n",if(lSep.and.lMRow,"c+/n","w+/n")))
    endif

    lTBeg:=("BEGIN ------------"$p)

    if (lTBeg)
        hb_gtInfo(HB_GTI_WINTITLE,"BlackTDN :: tBigNtst [http://www.blacktdn.com.br] :: PID["+hb_NtoS(GETCURRENTPROCESSID())+"] :: {"+AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+"}")
        DispOutAT(4,7,PadC(AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+Space(6),__nMaxCol-6),"r+/n")
    endif

    DispEnd()

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTimeProc:Calcule(lTBeg)
        hb_mutexUnLock(__phMutex)
    endif

#else
    lTBeg:=("BEGIN ------------"$p)
    if (lTBeg)
        PTInternal(1,"[tBigNTST]["+AllTrim(StrTran(StrTran(p,"BEGIN",""),"-",""))+"]")
    endif
    ? p
#endif

    p:=NIL

    if (lL_LOGPROCESS)
        if ((ld) .and. (nATd>0))
            fWrite(fhLog,x+__CRLF)
            fWrite(fhLog,"...................................................................................................."+y+__CRLF)
        else
            fWrite(fhLog,x+y+__CRLF)
        endif
    endif

    return
/*static procedure __ConOut*/

//--------------------------------------------------------------------------------------------------------
static function IsHb()
    local lHarbour as logical
    #ifdef __HARBOUR__
        lHarbour:=.T.
    #else
        lHarbour:=.F.
    #endif
    return(lHarbour)
/*static function IsHb*/

//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    static function cValToChar(e)
        local s
        switch ValType(e)
        case "C"
            s:=e
            EXIT
        case "D"
            s:=Dtoc(e)
            EXIT
        case "T"
            s:=HB_TTOC(e)
            EXIT
        case "N"
            s:=Str(e)
            EXIT
        case "L"
            s:=if(e,".T.",".F.")
            EXIT
        OTHERWISE
            s:=""
        endswitch
        return(s)
    /*static function cValToChar*/

    //--------------------------------------------------------------------------------------------------------
    static procedure Progress(lKillProgress as logical,__oRTimeProc as object,__phMutex as pointer,nCol as numeric,aProgress2 as array,nProgress2 as numeric,nSLEEP as numeric,nMaxCol as numeric,lRandom as logical,lPRandom as logical)

        local aRdnPG     as array
        local aRdnAn     as array
        local aSAnim     as array

        local cAT        as character
        local cRTime     as character
        local cStuff     as character
        local cLRTime    as character
        local cProgress  as character

        local lChange    as logical
        local lCScreen   as logical

        local nAT        as numeric
        local nQT        as numeric
        local nLenA      as numeric
        local nLenP      as numeric
        local nSAnim     as numeric
        local nSizeP     as numeric
        local nSizeP2    as numeric
        local nSizeP3    as numeric
        local nChange    as numeric
        local nProgress  as numeric

        local oProgress1 as object
        local oProgress2 as object

        aRdnPG:=Array(0)
        aRdnAn:=Array(0)
        aSAnim:=Array(29)

        lCScreen:=.T.

        nLenA:=Len(aSAnim)
        nLenP:=Len(aProgress2)

        nSAnim:=1

        nSizeP:=(nProgress2*2)
        nSizeP2:=(nSizeP*2)
        nSizeP3:=(nSizeP*3)

        nProgress:=1

        oProgress1:=tSProgress():New()
        oProgress2:=tSProgress():New()

        aSAnim[01]:=Replicate(Chr(7)+";",nSizeP2-1)
        aSAnim[01]:=SubStr(aSAnim[01],1,nSizeP2-1)
        if (SubStr(aSAnim[01],-1)==";")
            aSAnim[01]:=SubStr(aSAnim[01],1,Len(aSAnim[01])-1)
        endif

        aSAnim[02]:=Replicate("-;\;|;/;",nSizeP2-1)
        aSAnim[02]:=SubStr(aSAnim[02],1,nSizeP2-1)
        if (SubStr(aSAnim[02],-1)==";")
            aSAnim[02]:=SubStr(aSAnim[02],1,Len(aSAnim[02])-1)
        endif

        aSAnim[03]:=Replicate(Chr(8)+";",nSizeP2-1)
        aSAnim[03]:=SubStr(aSAnim[03],1,nSizeP2-1)
        if (SubStr(aSAnim[03],-1)==";")
            aSAnim[03]:=SubStr(aSAnim[03],1,Len(aSAnim[03])-1)
        endif

        aSAnim[04]:=Replicate("*;",nSizeP2-1)
        aSAnim[04]:=SubStr(aSAnim[04],1,nSizeP2-1)
        if (SubStr(aSAnim[04],-1)==";")
            aSAnim[04]:=SubStr(aSAnim[04],1,Len(aSAnim[04])-1)
        endif

        aSAnim[05]:=Replicate(".;",nSizeP2-1)
        aSAnim[05]:=SubStr(aSAnim[05],1,nSizeP2-1)
        if (SubStr(aSAnim[05],-1)==";")
            aSAnim[05]:=SubStr(aSAnim[05],1,Len(aSAnim[05])-1)
        endif

        aSAnim[06]:=Replicate(":);",nSizeP3-1)
        aSAnim[06]:=SubStr(aSAnim[06],1,nSizeP3-1)
        if (SubStr(aSAnim[06],-1)==";")
            aSAnim[06]:=SubStr(aSAnim[06],1,Len(aSAnim[06])-1)
        endif

        aSAnim[07]:=Replicate(">;",nSizeP2-1)
        aSAnim[07]:=SubStr(aSAnim[07],1,nSizeP2-1)
        if (SubStr(aSAnim[07],-1)==";")
            aSAnim[07]:=SubStr(aSAnim[07],1,Len(aSAnim[07])-1)
        endif

        aSAnim[08]:=Replicate("B;L;A;C;K;T;D;N;;",nSizeP2-1)
        aSAnim[08]:=SubStr(aSAnim[08],1,nSizeP2-1)
        if (SubStr(aSAnim[08],-1)==";")
            aSAnim[08]:=SubStr(aSAnim[08],1,Len(aSAnim[08])-1)
        endif

        aSAnim[09]:=Replicate("T;B;I;G;N;U;M;B;E;R;;",nSizeP2-1)
        aSAnim[09]:=SubStr(aSAnim[09],1,nSizeP2-1)
        if (SubStr(aSAnim[09],-1)==";")
            aSAnim[09]:=SubStr(aSAnim[09],1,Len(aSAnim[09])-1)
        endif

        aSAnim[10]:=Replicate("H;A;R;B;O;U;R;;",nSizeP2-1)
        aSAnim[10]:=SubStr(aSAnim[10],1,nSizeP2-1)
        if (SubStr(aSAnim[10],-1)==";")
            aSAnim[10]:=SubStr(aSAnim[10],1,Len(aSAnim[10])-1)
        endif

        aSAnim[11]:=Replicate("N;A;L;D;O;;D;J;;",nSizeP2-1)
        aSAnim[11]:=SubStr(aSAnim[11],1,nSizeP2-1)
        if (SubStr(aSAnim[11],-1)==";")
            aSAnim[11]:=SubStr(aSAnim[11],1,Len(aSAnim[11])-1)
        endif

        aSAnim[12]:=Replicate(Chr(175)+";",nSizeP2-1)
        aSAnim[12]:=SubStr(aSAnim[12],1,nSizeP2-1)
        if (SubStr(aSAnim[12],-1)==";")
            aSAnim[12]:=SubStr(aSAnim[12],1,Len(aSAnim[12])-1)
        endif

        aSAnim[13]:=Replicate(Chr(254)+";",nSizeP2-1)
        aSAnim[13]:=SubStr(aSAnim[13],1,nSizeP2-1)
        if (SubStr(aSAnim[13],-1)==";")
            aSAnim[13]:=SubStr(aSAnim[13],1,Len(aSAnim[13])-1)
        endif

        aSAnim[14]:=Replicate(Chr(221)+";"+Chr(222)+";",nSizeP2-1)
        aSAnim[14]:=SubStr(aSAnim[14],1,nSizeP2-1)
        if (SubStr(aSAnim[14],-1)==";")
            aSAnim[14]:=SubStr(aSAnim[14],1,Len(aSAnim[14])-1)
        endif

        aSAnim[15]:=Replicate(Chr(223)+";;",nSizeP2-1)
        aSAnim[15]:=SubStr(aSAnim[15],1,nSizeP2-1)
        if (SubStr(aSAnim[15],-1)==";")
            aSAnim[15]:=SubStr(aSAnim[15],1,Len(aSAnim[15])-1)
        endif

        aSAnim[16]:=Replicate(Chr(176)+";;"+Chr(177)+";;"+Chr(178)+";;",nSizeP2-1)
        aSAnim[16]:=SubStr(aSAnim[16],1,nSizeP2-1)
        if (SubStr(aSAnim[16],-1)==";")
            aSAnim[16]:=SubStr(aSAnim[16],1,Len(aSAnim[16])-1)
        endif

        aSAnim[17]:=Replicate(Chr(7)+";;",nSizeP2-1)
        aSAnim[17]:=SubStr(aSAnim[17],1,nSizeP2-1)
        if (SubStr(aSAnim[17],-1)==";")
            aSAnim[17]:=SubStr(aSAnim[17],1,Len(aSAnim[17])-1)
        endif

        aSAnim[18]:=Replicate("-;;\;;|;;/;;",nSizeP2-1)
        aSAnim[18]:=SubStr(aSAnim[18],1,nSizeP2-1)
        if (SubStr(aSAnim[18],-1)==";")
            aSAnim[18]:=SubStr(aSAnim[18],1,Len(aSAnim[18])-1)
        endif

        aSAnim[19]:=Replicate(Chr(8)+";;",nSizeP2-1)
        aSAnim[19]:=SubStr(aSAnim[19],1,nSizeP2-1)
        if (SubStr(aSAnim[19],-1)==";")
            aSAnim[19]:=SubStr(aSAnim[19],1,Len(aSAnim[19])-1)
        endif

        aSAnim[20]:=Replicate("*;;",nSizeP2-1)
        aSAnim[20]:=SubStr(aSAnim[20],1,nSizeP2-1)
        if (SubStr(aSAnim[20],-1)==";")
            aSAnim[20]:=SubStr(aSAnim[20],1,Len(aSAnim[20])-1)
        endif

        aSAnim[21]:=Replicate(".;;",nSizeP2-1)
        aSAnim[21]:=SubStr(aSAnim[21],1,nSizeP2-1)
        if (SubStr(aSAnim[21],-1)==";")
            aSAnim[21]:=SubStr(aSAnim[21],1,Len(aSAnim[21])-1)
        endif

        aSAnim[22]:=Replicate(":);;",nSizeP3-1)
        aSAnim[22]:=SubStr(aSAnim[22],1,nSizeP3-1)
        if (SubStr(aSAnim[22],-1)==";")
            aSAnim[22]:=SubStr(aSAnim[22],1,Len(aSAnim[22])-1)
        endif

        aSAnim[23]:=Replicate(">;;",nSizeP2-1)
        aSAnim[23]:=SubStr(aSAnim[23],1,nSizeP2-1)
        if (SubStr(aSAnim[23],-1)==";")
            aSAnim[23]:=SubStr(aSAnim[23],1,Len(aSAnim[23])-1)
        endif

        aSAnim[24]:=Replicate(Chr(175)+";;",nSizeP2-1)
        aSAnim[24]:=SubStr(aSAnim[24],1,nSizeP2-1)
        if (SubStr(aSAnim[24],-1)==";")
            aSAnim[24]:=SubStr(aSAnim[24],1,Len(aSAnim[24])-1)
        endif

        aSAnim[25]:=Replicate(Chr(254)+";;",nSizeP2-1)
        aSAnim[25]:=SubStr(aSAnim[25],1,nSizeP2-1)
        if (SubStr(aSAnim[25],-1)==";")
            aSAnim[25]:=SubStr(aSAnim[25],1,Len(aSAnim[25])-1)
        endif

        aSAnim[26]:=Replicate(Chr(221)+";;"+Chr(222)+";;",nSizeP2-1)
        aSAnim[26]:=SubStr(aSAnim[26],1,nSizeP2-1)
        if (SubStr(aSAnim[26],-1)==";")
            aSAnim[26]:=SubStr(aSAnim[26],1,Len(aSAnim[26])-1)
        endif

        aSAnim[27]:=Replicate(Chr(223)+";",nSizeP2-1)
        aSAnim[27]:=SubStr(aSAnim[27],1,nSizeP2-1)
        if (SubStr(aSAnim[27],-1)==";")
            aSAnim[27]:=SubStr(aSAnim[27],1,Len(aSAnim[27])-1)
        endif

        aSAnim[28]:=Replicate(Chr(176)+";"+Chr(177)+";"+Chr(178)+";",nSizeP2-1)
        aSAnim[28]:=SubStr(aSAnim[28],1,nSizeP2-1)
        if (SubStr(aSAnim[28],-1)==";")
            aSAnim[28]:=SubStr(aSAnim[28],1,Len(aSAnim[28])-1)
        endif

        aSAnim[29]:=Replicate(Chr(149)+";",nSizeP2-1)
        aSAnim[29]:=SubStr(aSAnim[01],1,nSizeP2-1)
        if (SubStr(aSAnim[29],-1)==";")
            aSAnim[29]:=SubStr(aSAnim[29],1,Len(aSAnim[29])-1)
        endif

        if (lRandom)
            nSAnim:=abs(HB_RandomInt(1,nLenA))
            aAdd(aRdnAn,nSAnim)
            nProgress:=abs(HB_RandomInt(1,nLenP))
            aAdd(aRdnPG,nProgress)
        endif

        oProgress2:SetProgress(aSAnim[nSAnim])
        cProgress:=aProgress2[nProgress]

        nChange:=0

        while (.NOT.(lKillProgress))

            DispBegin()

                DispOutAT(3,nCol,oProgress1:Eval(),"r+/n")

                if (oProgress2:GetnProgress()==oProgress2:GetnMax())
                    lChange:=(.NOT.("SHUTTLE"$cProgress).or.(("SHUTTLE"$cProgress).and.(++nChange>1)))
                    if (lChange)
                        if ("SHUTTLE"$cProgress)
                            nChange:=0
                        endif
                        if (lRandom)
                            if (Len(aRdnAn)==nLenA)
                                aSize(aRdnAn,0)
                            endif
                            while (aScan(aRdnAn,{|r|r==(nSAnim:=abs(HB_RandomInt(1,nLenA)))})>0)
                                __tbnSleep(nSLEEP)
                            end while
                            aAdd(aRdnAn,nSAnim)
                            oProgress2:SetProgress(aSAnim[nSAnim])
                            if (Len(aRdnPG)==nLenP)
                                aSize(aRdnPG,0)
                            endif
                            while (aScan(aRdnPG,{|r|r==(nProgress:=abs(HB_RandomInt(1,nLenP)))})>0)
                                __tbnSleep(nSLEEP)
                            end while
                            aAdd(aRdnPG,nProgress)
                        else
                            if (++nProgress>nLenP)
                                nProgress:=1
                                if (++nSAnim>nLenA)
                                    nSAnim:=1
                                endif
                                oProgress2:SetProgress(aSAnim[nSAnim])
                            endif
                        endif
                        lCScreen:=.T.
                        cProgress:=aProgress2[nProgress]
                    endif
                endif

            DispEnd()

            DispBegin()

                oProgress2:SetRandom(lPRandom)

                if (lCScreen)
                    lCScreen:=.F.
                    @ 12,0 CLEAR TO 12,nMaxCol
                endif

                cStuff:=PADC("["+cProgress+"] ["+oProgress2:Eval(cProgress)+"] ["+cProgress+"]",nMaxCol)
                nAT:=(AT("] [",cStuff)+3)
                nQT:=(AT("] [",SubSTr(cStuff,nAT))-2)
                cAT:=SubStr(cStuff,nAT,nQT+1)
                cStuff:=Stuff(cStuff,nAT,Len(cAT),Space(Len(cAT)))

                DispOutAT(12,0,cStuff,"w+/n")
                DispOutAT(12,nAT-1,cAT,"r+/n")

                if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                    if (cRTime==cLRTime)
                        __oRTime1:Calcule(.F.)
                        __oRTime2:Calcule(.F.)
                       __oRTimeProc:Calcule(.F.)
                    endif
                    ShowFinalProc()
                    cRTime:="["+hb_NtoS(__oRTimeProc:GetnProgress())
                    cRTime+="/"+hb_NtoS(__oRTimeProc:GetnTotal())+"]"
                    cRTime+="["+DtoC(__oRTimeProc:GetdendTime())+"]"
                    cRTime+="["+__oRTimeProc:GetcEndTime()+"]"
                    cRTime+="["+__oRTimeProc:GetcAverageTime()+"]"
                    cRTime+="["+hb_NtoS((__oRTimeProc:GetnProgress()/__oRTimeProc:GetnTotal())*100)+" %]"
                    cLRTime:=cRTime
                    hb_mutexUnLock(__phMutex)
                endif

                @ 07,15 CLEAR TO 07,nMaxCol
                DispOutAT(07,15,HB_TTOC(HB_DATETIME()),"r+/n")
                DispOutAT(07,nMaxCol-Len(cRTime),cRTime,"r+/n")

            DispEnd()

            __tbnSleep(nSLEEP)

        end while

        return
    /*static procedure Progress*/

    static procedure ShowFinalProc()

        local cDOAt as character

        DispBegin()

            @ 09,15 CLEAR TO 09,__nMaxCol
            cDOAt:="["
            cDOAt+=StrZero(__oRTime1:GetnProgress(),16)
            cDOAt+="/"
            cDOAt+=StrZero(__oRTime1:GetnTotal(),16)
            cDOAt+="]|["
            cDOAt+=DtoC(__oRTime1:GetdendTime())
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
            cDOAt+=DtoC(__oRTime2:GetdendTime())
            cDOAt+="]["+__oRTime2:GetcEndTime()
            cDOAt+="]|["
            cDOAt+=__oRTime2:GetcAverageTime()
            cDOAt+="]["
            cDOAt+=hb_NtoS((__oRTime2:GetnProgress()/__oRTime2:GetnTotal())*100)
            cDOAt+=" %]"
            DispOutAT(10,15,cDOAt,"w+/n")

        DispEnd()

        return
    /*static procedure ShowFinalProc*/

    //--------------------------------------------------------------------------------------------------------
    static procedure ftProgress(lKillProgress as logical,nSLEEP as numeric,nMaxCol as numeric,nMaxRow as numeric)

        local aAnim    as array

        local cRow     as character
        local cAnim    as character
        local cRAnim   as character

        local lBreak   as logical

        local nRow     as numeric
        local nRowC    as numeric
        local nAnim    as numeric
        local nAnimes  as numeric
        local nRowAnim as numeric

        aAnim:=GetBigNAnim()

#if defined( __PLATFORM__LINUX )
        aSize(aAnim,0)
#endif        

        nRow:=0
        nRowC:=0
        nAnimes:=Len(aAnim)
        nRowAnim:=(nMaxRow+2)

        while (.NOT.(lKillProgress))

            for nAnim:=1 to nAnimes
                cAnim:=aAnim[nAnim]
                for each cRow in _StrTokArr(cAnim,"[\n]")
                    DispBegin()
                        lBreak:=(";"$cRow)
                        if (lBreak)
                            if ((nRowC==0).and.(.NOT.(nRow==0)))
                                nRowC:=(nRowAnim+nRow)
                            endif
                        endif
                        cRAnim:=PadC(StrTran(cRow,";",""),nMaxCol)
                        DispOutAT(nRowAnim+nRow,0,cRAnim,if(lBreak,"w+/n","r+/n"))
                        __tbnSleep(nSLEEP/2)
                        if (lBreak)
                            nRow:=0
                        else
                            ++nRow
                        endif
                    DispEnd()
                next cRow
                @ nRowAnim,0 CLEAR TO nRowC,nMaxCol
                __tbnSleep(nSLEEP)
                nRow:=0
                nRowC:=0
            next nAnim

        end while

        return
    /*static procedure ftProgress*/

    //--------------------------------------------------------------------------------------------------------
    static procedure BuildScreen(fhLog as numeric,nMaxCol as numeric)
        CLEAR SCREEN
        __ConOut(fhLog,PadC("BlackTDN :: tBigNtst [http://www.blacktdn.com.br] :: PID["+hb_NtoS(GETCURRENTPROCESSID())+"]",nMaxCol)) //1
        __ConOut(fhLog,PadC("("+Version()+Build_Mode()+","+OS()+")",nMaxCol))            //2
        ShowTime(2,nMaxCol-8,.F.,"r+/n",.F.,.F.)
        return
    /*static procedure BuildScreen*/

    //--------------------------------------------------------------------------------------------------------
    static function FreeObj(oObj as object)
        oObj:=NIL
        return(tBigNGC())
    /*static function FreeObj*/

    static function tBigNGC()
        return(/*hb_gcAll(.T.)*/NIL)
    /*static function tBigNGC*/

    #include "../src/tests/hb/tBigNAnim.prg"
#else
    #ifdef TBN_DBFILE
        static function tBigNGC()
            return(StaticCall(TBIGNUMBER,tBigNGC))
        /*static function tBigNGC*/
    #endif
#endif

//--------------------------------------------------------------------------------------------------------
static function Fibonacci(uN)
    local oN:=tBigNumber():New(uN)
    return(oN:Fibonacci())
/*static function Fibonacci*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst01(fhLog as numeric)

    local otBigN    as object
    local otBigM    as object

    local cN        as character
    local cM        as character
    local cX        as character

    local n         as numeric
    local x         as numeric

    local nSetDec   as numeric

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste MOD 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        cX:=hb_NtoS(x)
        otBigN:SetValue(cX)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(nN_TEST)
            __oRTime2:Setstep(nISQRT)
            hb_mutexUnLock(__phMutex)
        endif
        for n:=nN_TEST to 1 step -nISQRT
            cN:=hb_NtoS(n)
            otBigM:=otBigN:MOD(cN)
            cM:=otBigM:ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():MOD('+cN+')',"RESULT: "+cM)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next n
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste MOD 0 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst01*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst02(fhLog as numeric)

    #ifndef __ADVPL__

        local otBigN    as object
        local otBigW    as object
        local otBigX    as object

        local cN        as character
        local cW        as character

        local n         as numeric
        local w         as numeric

        local nSetDec   as numeric

        __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Operator Overloading 0 -------------- ")

        __ConOut(fhLog,"")

/*(*)*/ /* OPERATORS NOT IMPLEMENTED: HB_APICLS.H,CLASSES.C AND HVM.C*/
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:SetRemaining(5+1)
            hb_mutexUnLock(__phMutex)
        endif

        otBigN:=tBigNumber():New()
        otBigN:SetDecimals(nACC_SET)

        otBigW:=tBigNumber():New()
        otBigW:SetDecimals(nACC_SET)

        otBigX:=tBigNumber():New()
        otBigX:SetDecimals(nACC_SET)

        nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

        for w:=0 to 5
            cW:=hb_NtoS(w)
            otBigW:=cW
            __ConOut(fhLog,"otBigW:="+cW,"RESULT: "+otBigW:ExactValue())
            __ConOut(fhLog,"otBigW=="+cW,"RESULT: "+cValToChar(otBigW==cW))
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:SetRemaining(nISQRT)
                __oRTime2:Setstep(Int(nISQRT/2))
                hb_mutexUnLock(__phMutex)
            endif
            for n:=1 to nISQRT step Int(nISQRT/2)
                cN:=hb_NtoS(n)
                __ConOut(fhLog,"otBigW=="+cN,"RESULT: "+cValToChar(otBigW==cN))
                __ConOut(fhLog,"otBigW%="+cW,"RESULT: "+(otBigX:=(otBigW%=cW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW^="+cN,"RESULT: "+(otBigX:=(otBigW^=cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+="+cN,"RESULT: "+(otBigX:=(otBigW+=cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW++","RESULT: "+(otBigX:=(otBigW++),otBigX:ExactValue()))
                __ConOut(fhLog,"++otBigW","RESULT: "+(otBigX:=(++otBigW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW-="+cN,"RESULT: "+(otBigX:=(otBigW-=cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+="+cW,"RESULT: "+(otBigX:=(otBigW+=cW),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW*="+cN,"RESULT: "+(otBigX:=(otBigW*=cN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+="+cW,"RESULT: "+(otBigX:=(otBigW+=cW),otBigX:ExactValue()))
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
                __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=otBigN++","RESULT: "+(otBigX:=(otBigW+=otBigN++),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=++otBigN","RESULT: "+(otBigX:=(otBigW+=++otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW-=otBigN","RESULT: "+(otBigX:=(otBigW-=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW*=otBigN","RESULT: "+(otBigX:=(otBigW*=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=otBigN","RESULT: "+(otBigX:=(otBigW+=otBigN),otBigX:ExactValue()))
                otBigN:=cW
                __ConOut(fhLog,"otBigN:="+cW,"RESULT: "+otBigN:ExactValue())
                __ConOut(fhLog,"otBigN=="+cW,"RESULT: "+cValToChar(otBigN==cW))
                __ConOut(fhLog,"otBigN^=otBigN","RESULT: "+(otBigX:=(otBigN^=otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW--","RESULT: "+(otBigX:=(otBigW--),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=otBigN--","RESULT: "+(otBigX:=(otBigW+=otBigN--),otBigX:ExactValue()))
                __ConOut(fhLog,"otBigW+=--otBigN","RESULT: "+(otBigX:=(otBigW+=--otBigN),otBigX:ExactValue()))
                __ConOut(fhLog,__cSep)
                if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                    __oRTime2:Calcule()
                    __oRTime1:Calcule(.F.)
                    __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                    hb_mutexUnLock(__phMutex)
                endif
                *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
                __ConOut(fhLog,__cSep)
            next n
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime1:Calcule()
                __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next w
        otBigX:=NIL
        tBigNGC()
        __ConOut(fhLog,"------------ Teste Operator Overloading 0 -------------- end")

        Set(_SET_DECIMALS,nSetDec)

    #endif

    return
/*static procedure tBigNtst02*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst03(fhLog as numeric)

    local aPFact    as array

    local cN        as character
    local cW        as character

    local n         as numeric
    local x         as numeric
    local y         as numeric

    local nSetDec   as numeric

    local otBigN    as object
    local otBigW    as object

    local o0        as object

    __ConOut(fhLog,"")

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Prime 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    o0:=tBigNumber():New("0")

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 to nN_TEST step nISQRT
        y:=0
        cN:=hb_NtoS(n)
        aPFact:=otBigN:SetValue(cN):PFactors()
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(Len(aPFact))
            hb_mutexUnLock(__phMutex)
        endif
        for x:=1 to Len(aPFact)
            cW:=aPFact[x][2]
#ifndef __ADVPL__
            otBigW:=cW
            while otBigW>o0
#else
            otBigW:SetValue(cW)
            while (otBigW:gt(o0))
#endif
                __ConOut(fhLog,cN+':tBigNumber():PFactors():'+hb_NtoS(x)+':'+otBigW:ExactValue()+':'+hb_NtoS(++y),"RESULT: "+aPFact[x][1])
                otBigW:OpDec()
            end while
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                hb_mutexUnLock(__phMutex)
            endif
        next x
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    aSize(aPFact,0)
    aPFact:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif /*__ADVPL__*/

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Prime 0 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst03*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst04(fhLog as numeric)

    local aPrimes   as array

    local cP        as character
    local cN        as character

    local n         as numeric
    local nSetDec   as numeric

    local oPrime    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Prime 1 -------------- ")

    __ConOut(fhLog,"")

    aPrimes:={;
        "15485783","15485801","15485807","15485837","15485843","15485849","15485857","15485863",;
        "15487403","15487429","15487457","15487469","15487471","15487517","15487531","15487541",;
        "32458051","32458057","32458073","32458079","32458091","32458093","32458109","32458123",;
        "49981171","49981199","49981219","49981237","49981247","49981249","49981259","49981271",;
        "67874921","67874959","67874969","67874987","67875007","67875019","67875029","67875061",;
        "982451501",;
        "982451549",;
        "982451567",;
        "982451579",;
        "982451581",;
        "982451609",;
        "982451629",;
        "982451653";
    }

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(Len(aPrimes))
        hb_mutexUnLock(__phMutex)
    endif

    oPrime:=tPrime():New()
    oPrime:IsPReset()
    oPrime:nextPReset()

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 to Len(aPrimes)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cP:=aPrimes[n]
        cN:=PadL(cP,oPrime:nSize)
        __ConOut(fhLog,'tPrime():nextPrime('+cP+')',"RESULT: "+cValToChar(oPrime:nextPrime(cN)))
        __ConOut(fhLog,'tPrime():nextPrime('+cP+')',"RESULT: "+oPrime:cPrime)
        cP:=LTrim(oPrime:cPrime)
        __ConOut(fhLog,'tPrime():IsPrime('+cP+')',"RESULT: "+cValToChar(oPrime:IsPrime()))
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    aSize(aPrimes,0)
    aPrimes:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif /*__ADVPL__*/

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Prime 1 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst04*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst05(fhLog as numeric)

    local cN        as character
    local cHex      as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBH16    as object
    local otBBin    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste HEX16 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nISQRT*99)
        __oRTime1:Setstep(99)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    otBH16:=tBigNumber():New(NIL,16)
    otBBin:=tBigNumber():New(NIL,2)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=0 to (nISQRT*99) step 99
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        n:=x
        cN:=hb_NtoS(n)
        cHex:=otBigN:SetValue(cN):D2H("16"):Int()
        __ConOut(fhLog,cN+':tBigNumber():D2H(16)',"RESULT: "+cHex)
        cN:=otBH16:SetValue(cHex):H2D():Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2D()',"RESULT: "+cN)
        __ConOut(fhLog,cN+"=="+hb_NtoS(n),"RESULT: "+cValToChar(cN==hb_NtoS(n)))
        cN:=otBH16:H2B():Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2B()',"RESULT: "+cN)
        cHex:=otBBin:SetValue(cN):B2H('16'):Int()
        __ConOut(fhLog,cN+':tBigNumber():B2H(16)',"RESULT: "+cHex)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    FreeObj(@otBH16)

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste HEX16 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst05*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst06(fhLog as numeric)

    local cN        as character
    local cHex      as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBH32    as object
    local otBBin    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste HEX32 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nISQRT*99)
        __oRTime1:Setstep(99)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    otBH32:=tBigNumber():New(NIL,32)
    otBBin:=tBigNumber():New(NIL,2)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=0 to (nISQRT*99) step 99
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        n:=x
        cN:=hb_NtoS(n)
        cHex:=otBigN:SetValue(cN):D2H("32"):Int()
        __ConOut(fhLog,cN+':tBigNumber():D2H(32)',"RESULT: "+cHex)
        cN:=otBH32:SetValue(cHex):H2D("32"):Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2D()',"RESULT: "+cN)
        __ConOut(fhLog,cN+"=="+hb_NtoS(n),"RESULT: "+cValToChar(cN==hb_NtoS(n)))
        cN:=otBH32:H2B('32'):Int()
        __ConOut(fhLog,cHex+':tBigNumber():H2B()',"RESULT: "+cN)
        cHex:=otBBin:SetValue(cN):B2H('32'):Int()
        __ConOut(fhLog,cN+':tBigNumber():B2H(32)',"RESULT: "+cHex)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    FreeObj(@otBH32)

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste HEX32 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst06*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst07(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ ADD Teste 1 -------------- ")

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    __ConOut(fhLog,"")

    n:=1

    o1:=tBigNumber():New("1")

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

#ifndef __ADVPL__
    otBigN:=o1
#else
    otBigN:SetValue(o1)
#endif
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif
    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n+=9999.9999999999
        __ConOut(fhLog,cN+'+=9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN+="9999.9999999999"
#else
        cR:=otBigN:Add("9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Add(9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD 1 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst07*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst08(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ ADD Teste 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    cN:=("0."+Replicate("0",MIN(nACC_SET,10)))
    n:=Val(cN)

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:SetValue(cN)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n+=9999.9999999999
        __ConOut(fhLog,cN+'+=9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN+="9999.9999999999"
#else
        cR:=otBigN:Add("9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Add(9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD Teste 2 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst08*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst09(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ ADD Teste 3 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=0

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n+=-9999.9999999999
        __ConOut(fhLog,cN+'+=-9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN+="-9999.9999999999"
#else
        cR:=otBigN:add("-9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():add(-9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ ADD Teste 3 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst09*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst10(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ SUB Teste 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=0

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n-=9999.9999999999
        __ConOut(fhLog,cN+'-=9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN-="9999.9999999999"
#else
        cR:=otBigN:Sub("9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Sub(9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 1 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst10*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst11(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ SUB Teste 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=0

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n-=9999.9999999999
        __ConOut(fhLog,cN+'-=9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN-="9999.9999999999"
#else
        cR:=otBigN:Sub("9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Sub(9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 2 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst11*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst12(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ SUB Teste 3 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=0

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        n-=-9999.9999999999
        __ConOut(fhLog,cN+'-=-9999.9999999999',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN-="-9999.9999999999"
#else
        cR:=otBigN:Sub("-9999.9999999999"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Sub(-9999.9999999999)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ SUB Teste 3 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst12*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst13(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigN    as object
    local otBigW    as object

   __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 1 -------------- ")

   __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=1

    o1:=tBigNumber():New("1")

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:SetValue(o1)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN*="1.5"
#else
        cR:=otBigN:Mult("1.5"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(1.5)',"RESULT: "+cR)
        cN:=otBigW:ExactValue()
        cR:=otBigW:egMult("1.5"):ExactValue()
        cR:=otBigW:SetValue(cR):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(1.5)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 1 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst13*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst14(fhLog as numeric)

    local cN        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=1

    o1:=tBigNumber():New("1")

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN*="1.5"
#else
        cR:=otBigN:Mult("1.5"):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(1.5)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 2 -------------- end")

     __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst14*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst15(fhLog as numeric)

    local cN        as character

    local n         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 3 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=1

    o1:=tBigNumber():New("1")

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        n*=1.5
        __ConOut(fhLog,cN+'*=1.5',"RESULT: "+hb_NtoS(n))
        cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:egMult("1.5"))
        __ConOut(fhLog,cN+':tBigNumber():egMult(1.5)',"RESULT: "+otBigW:ExactValue())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 3 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst15*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst16(fhLog as numeric)

    local cN        as character
    local cW        as character

    local w         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 4 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    w:=1

    o1:=tBigNumber():New("1")

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(w)
        w*=3.555
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        cN:=otBigW:ExactValue()
#ifndef __ADVPL__
        otBigW*="3.555"
#else
        otBigW:SetValue(otBigW:Mult("3.555"))
#endif
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+otBigW:ExactValue())
        cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Mult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 4 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst16*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst17(fhLog as numeric)

    local cN        as character
    local cW        as character

    local w         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 5 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    w:=1

    o1:=tBigNumber():New("1")

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(w)
        w*=3.555
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:egMult("3.555"))
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+otBigW:ExactValue())
        cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():egMult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 5 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst17*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst18(fhLog as numeric)

    local cN        as character
    local cW        as character

    local w         as numeric
    local x         as numeric
    local z         as numeric
    local nSetDec   as numeric

    local o1        as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ MULT Teste 6 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    w:=1

    o1:=tBigNumber():New("1")

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            __oRTime2:Setstep()
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(w)
        w*=3.555
        z:=Len(cN)
        while ((SubStr(cN,-1)=="0") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        z:=Len(cN)
        while ((SubStr(cN,-1)=="*") .and. (z>1))
            cN:=SubStr(cN,1,--z)
        end while
        __ConOut(fhLog,cN+'*=3.555',"RESULT: "+hb_NtoS(w))
        cN:=otBigW:ExactValue()
        otBigW:SetValue(otBigW:rMult("3.555"))
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+otBigW:ExactValue())
        cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():rMult(3.555)',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ MULT Teste 6 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst18*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst19(fhLog as numeric)

    local cN        as character

    local n         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Factoring -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    n:=0
    while (n<=nN_TEST)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        #ifdef __ADVPL__
            otBigN:SetValue(cN)
        #else
            otBigN:=cN
        #endif
        __ConOut(fhLog,cN+':tBigNumber():Factorial()',"RESULT: "+otBigN:Factorial():ExactValue())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        n+=nISQRT
    end while
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Factoring 0 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst19*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst20(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cX        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste GCD/LCM 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        cX:=hb_NtoS(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(nN_TEST)
            __oRTime2:Setstep(nISQRT)
            hb_mutexUnLock(__phMutex)
        endif
        for n:=nN_TEST to 1 step -nISQRT
            cN:=hb_NtoS(n)
            cW:=otBigN:SetValue(cX):GCD(cN):ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():GCD('+cN+')',"RESULT: "+cW)
            cW:=otBigN:LCM(cN):ExactValue()
            __ConOut(fhLog,cX+':tBigNumber():LCM('+cN+')',"RESULT: "+cW)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next n
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste GCD/LCM 0 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst20*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst21(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cX        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ DIV Teste 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
       hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=0 to nN_TEST step nISQRT
        cN:=hb_NtoS(n)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(nISQRT)
            __oRTime2:Setstep(nISQRT)
            hb_mutexUnLock(__phMutex)
        endif
        for x:=0 to nISQRT step nISQRT
            cX:=hb_NtoS(x)
            __ConOut(fhLog,cN+'/'+cX,"RESULT: "+hb_NtoS(n/x))
#ifndef __ADVPL__
            otBigN:=cN
            otBigW:=(otBigN/cX)
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+otBigW:ExactValue())
#else
            otBigN:SetValue(cN)
            otBigW:SetValue(otBigN:Div(cX))
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+otBigW:ExactValue())
#endif
            cW:=otBigW:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Div('+cX+')',"RESULT: "+cW)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next x
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst21*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst22(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ DIV Teste 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    n:=19701215
    cN:=hb_NtoS(n)

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:SetValue(cN)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cW:=hb_NtoS(n)
        n/=1.5
        __ConOut(fhLog,cW+'/=1.5',"RESULT: "+hb_NtoS(n))
        cN:=otBigN:ExactValue()
#ifndef __ADVPL__
        otBigN/="1.5"
#else
        cR:=otBigN:Div("1.5")
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Div(1.5)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 1 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst22*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst23(fhLog as numeric)

    local cN        as character
    local cR        as character

    local x         as numeric
    local nSetDec   as numeric

    local o1        as object
    local o3        as object
    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ DIV Teste 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    o1:=tBigNumber():New("1")
    o3:=tBigNumber():New("3")

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:SetValue(o1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(x)
        otBigN:SetValue(cN)
        __ConOut(fhLog,cN+"/3","RESULT: "+hb_NtoS(x/3))
#ifndef __ADVPL__
        otBigN/=o3
#else
        cR:=otBigN:Div(o3):ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Div(3)',"RESULT: "+cR)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ DIV Teste 2 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst23*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst24(fhLog as numeric)

    local cN        as character

    local n         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBigW    as object

    //http://www.javascripter.net/math/calculators/eulertotientfunction.htm

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste FI 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 to nN_TEST step nISQRT
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cN:=hb_NtoS(n)
        __ConOut(fhLog,cN+':tBigNumber():FI()',"RESULT: "+otBigN:SetValue(cN):FI():ExactValue())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste FI 0 -------------- end")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst24*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst25(fhLog as numeric)

    local cN        as character
    local cW        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste SQRT 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(((nISQRT*999)+999)-((nISQRT*999)-999))
        __oRTime1:Setstep(99)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=((nISQRT*999)-999) TO ((nISQRT*999)+999) step 99
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        n:=x
        cN:=hb_NtoS(n)
        __ConOut(fhLog,'SQRT('+cN+')',"RESULT: "+hb_NtoS(SQRT(n)))
        otBigN:SetValue(cN)
        otBigW:SetValue(otBigN:SQRT())
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+otBigW:ExactValue())
        cW:=otBigW:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        cW:=otBigW:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        cW:=otBigW:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste SQRT 1 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst25*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst26(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste SQRT 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=1 to nN_TEST step nISQRT
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        n:=x
        cN:=hb_NtoS(n)
        __ConOut(fhLog,'SQRT('+cN+')',"RESULT: "+hb_NtoS(SQRT(n)))
#ifndef __ADVPL__
        otBigN:=cN
        otBigN:=otBigN:SQRT()
#else
        otBigN:SetValue(cN)
        cR:=otBigN:SQRT():ExactValue()
        otBigN:SetValue(cR)
#endif
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cR)
        cW:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        cW:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        cW:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():SQRT()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste SQRT 2 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst26*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst27(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cR        as character

    local n         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Exp 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nISQRT+1)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=0 to nISQRT
        SYMBOL_UNUSED(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        n:=x
        cN:=hb_NtoS(n)
        __ConOut(fhLog,'Exp('+cN+')',"RESULT: "+hb_NtoS(Exp(n)))
#ifndef __ADVPL__
    otBigN:=cN
#else
    otBigN:SetValue(cN)
#endif
        cR:=otBigN:Exp():ExactValue()
        otBigN:SetValue(cR)
        cR:=otBigN:ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cR)
        cW:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        cW:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        cW:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cN+':tBigNumber():Exp()',"RESULT: "+cW)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Exp 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst27*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst28(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cX        as character
    local cR        as character

    local n         as numeric
    local w         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Pow 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    //Tem (ou TINHA) um BUG aqui. Servidor __ADVPL__ Fica Maluco se (0^-n) e Senta..........
    for x:=if(.NOT.(IsHb()),1,0) to nN_TEST step nISQRT
        cN:=hb_NtoS(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(nISQRT)
            hb_mutexUnLock(__phMutex)
        endif
        for w:=-nISQRT To 0
            cW:=hb_NtoS(w)
            n:=x
            n:=(n^w)
            __ConOut(fhLog,cN+'^'+cW,"RESULT: "+hb_NtoS(n))
#ifndef __ADVPL__
            otBigN:=cN
#else
            otBigN:SetValue(cN)
#endif
            cN:=otBigN:ExactValue()

#ifndef __ADVPL__
            otBigN^=cW
#else
            cR:=otBigN:Pow(cW):ExactValue()
            otBigN:SetValue(cR)
#endif
            cR:=otBigN:ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cR)
            cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next w
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst28*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst29(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cX        as character

    local n         as numeric
    local w         as numeric
    local x         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Pow 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nISQRT)
        __oRTime1:Setstep(5)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for x:=0 to nISQRT step 5
        cN:=hb_NtoS(x)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(nISQRT)
            __oRTime2:Setstep(5)
            hb_mutexUnLock(__phMutex)
        endif
        for w:=0 to nISQRT step 5
            cW:=hb_NtoS(w+.5)
            n:=x
            n:=(n^(w+.5))
            __ConOut(fhLog,cN+'^'+cW,"RESULT: "+hb_NtoS(n))
            #ifndef __ADVPL__
                otBigN:=cN
            #else
                otBigN:SetValue(cN)
            #endif
            cN:=otBigN:ExactValue()
            #ifndef __ADVPL__
                otBigN^=cW
            #else
                otBigN:SetValue(otBigN:Pow(cW))
            #endif
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+otBigN:ExactValue())
            cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cN+':tBigNumber():Pow('+cW+')',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next w
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next x

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 1 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst29*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst30(fhLog as numeric)

    local n         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Pow 2 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(2)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 To 2
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        if (n==1)
            otBigN:SetValue("1.5")
            __ConOut(fhLog,"otBigN","RESULT: "+otBigN:ExactValue())
            __ConOut(fhLog,"otBigN:Pow('0.5')","RESULT: "+otBigN:SetValue(otBigN:Pow("0.5")):ExactValue())
            __ConOut(fhLog,"otBigN:Pow('0.5')","RESULT: "+otBigN:Rnd():ExactValue())
        else
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:SetValue(otBigN:nthroot("0.5")):ExactValue())
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:Rnd():ExactValue())
            __ConOut(fhLog,"otBigN:nthroot('0.5')","RESULT: "+otBigN:Rnd(2):ExactValue())
        endif
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Pow 2 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst30*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst31(fhLog as numeric)

    local cX        as character

    local nSetDec   as numeric

    local o0        as object
    local o1        as object
    local o2        as object
    local o3        as object
    local o4        as object
    local o5        as object
    local o6        as object
    local o7        as object
    local o8        as object
    local o9        as object
    local o10       as object

    local otBigW    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste LOG 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(13)
        hb_mutexUnLock(__phMutex)
    endif

    o0:=tBigNumber():New("0")
    o1:=tBigNumber():New("1")
    o2:=tBigNumber():New("2")
    o3:=tBigNumber():New("3")
    o4:=tBigNumber():New("4")
    o5:=tBigNumber():New("5")
    o6:=tBigNumber():New("6")
    o7:=tBigNumber():New("7")
    o8:=tBigNumber():New("8")
    o9:=tBigNumber():New("9")
    o10:=tBigNumber():New("10")

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_ALOG)
    otBigW:SysSQRT(0)
    otBigW:nthRootAcc(nACC_ALOG-1)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Ln():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Ln()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log2():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log2()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log10():ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log10()',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o1):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("1")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o2):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("2")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

     if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o3):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("3")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o4):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("4")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o5):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("5")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o6):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("6")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o7):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("7")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o8):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("8")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

     if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o9):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("9")',"RESULT: "+cX)

    __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        hb_mutexUnLock(__phMutex)
    endif

    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    cX:=otBigW:SetValue("100000000000000000000000000000"):Log(o10):ExactValue()
    __ConOut(fhLog,'100000000000000000000000000000:tBigNumber():Log("10")',"RESULT: "+cX)

    FreeObj(@o0)
    FreeObj(@o1)
    FreeObj(@o2)
    FreeObj(@o3)
    FreeObj(@o4)
    FreeObj(@o5)
    FreeObj(@o6)
    FreeObj(@o7)
    FreeObj(@o8)
    FreeObj(@o9)
    FreeObj(@o10)

   __ConOut(fhLog,__cSep)
    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime2:Calcule()
        __oRTime1:Calcule()
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        hb_mutexUnLock(__phMutex)
    endif

    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LOG 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst31*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst32(fhLog as numeric)

    local cN        as character
    local cW        as character
    local cX        as character

    local n         as numeric
    local w         as numeric
    local nSetDec   as numeric

    local otBigN    as object
    local otBigW    as object

    //Quer comparar o resultado:http://www.gyplclan.com/pt/logar_pt.html

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste LOG 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)
    otBigN:nthRootAcc(nROOT_ACC_SET)
    otBigN:SysSQRT(0)

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for w:=0 to nN_TEST step nISQRT
        cW:=hb_NtoS(w)
        otBigW:SetValue(cW)
        __ConOut(fhLog,'Log('+cW+')',"RESULT: "+hb_NtoS(Log(w)))
        cX:=otBigW:SetValue(cW):Log():ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
         otBigN:SetValue(cX)
        cX:=otBigN:Rnd(nACC_SET):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Log()',"RESULT: "+cX)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(INT(MAX(nISQRT,5)/5)+1)
            hb_mutexUnLock(__phMutex)
        endif
        for n:=0 TO INT(MAX(nISQRT,5)/5)
            cN:=hb_NtoS(n)
            cX:=otBigW:SetValue(cW):Log(cN):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            otBigN:SetValue(cX)
            cX:=otBigN:Rnd(nACC_SET):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            cX:=otBigN:NoRnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            cX:=otBigN:Rnd(Min(__SETDEC__,nACC_SET)):ExactValue()
            __ConOut(fhLog,cW+':tBigNumber():Log("'+cN+'")',"RESULT: "+cX)
            __ConOut(fhLog,__cSep)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
                hb_mutexUnLock(__phMutex)
            endif
            *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
            __ConOut(fhLog,__cSep)
        next n
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next w

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LOG 1 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst32*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst33(fhLog as numeric)

    local cW        as character
    local cX        as character

    local w         as numeric
    local nSetDec   as numeric

    local otBigW    as object

    //Quer comparar o resultado:http://www.gyplan.com/pt/logar_pt.html

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste LN 1 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigW:=tBigNumber():New()
    otBigW:SetDecimals(nACC_SET)
    otBigW:nthRootAcc(nROOT_ACC_SET)
    otBigW:SysSQRT(0)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for w:=0 to nN_TEST step nISQRT
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        cW:=hb_NtoS(w)
        cX:=otBigW:SetValue(cW):Ln():ExactValue()
        __ConOut(fhLog,cW+':tBigNumber():Ln()',"RESULT: "+cX)
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next w
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste LN 1 -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst33*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst34(fhLog as numeric)

    local cN        as character

    local lPn       as logical
    local lMR       as logical

    local n         as numeric
    local nSetDec   as numeric

    local o2        as object
    local otBigN    as object
    local oPrime    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste millerRabin 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining((nISQRT/2)+1)
        __oRTime2:SetRemaining(1)
        hb_mutexUnLock(__phMutex)
    endif

    o2:=tBigNumber():New("2")

    oPrime:=tPrime():New()

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    n:=0

    while (n<=nISQRT)
        if (n<3)
            n+=1
        else
            __oRTime1:Setstep(2)
            n+=2
        endif
        cN:=hb_NtoS(n)
        lPn:=oPrime:IsPrime(cN,.T.)
        lMR:=if(lPn,lPn,otBigN:SetValue(cN):millerRabin(o2))
        __ConOut(fhLog,cN+':tBigNumber():millerRabin()',"RESULT: "+cValToChar(lMR)+if(lMR,"","   "))
        __ConOut(fhLog,cN+':tPrime():IsPrime()',"RESULT: "+cValToChar(lPn)+if(lPn,"","   "))
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    end while
    oPrime:IsPReset()
    oPrime:nextPReset()

    FreeObj(@oPrime)

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste millerRabin 0 -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst34*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst35(fhLog as numeric)

    local n         as numeric
    local nSetDec   as numeric

    local otBigN    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste RANDOMIZE 0 -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    otBigN:=tBigNumber():New()
    otBigN:SetDecimals(nACC_SET)

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 to nISQRT
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(1)
            hb_mutexUnLock(__phMutex)
        endif
        __ConOut(fhLog,'tBigNumber():Randomize()',"RESULT: "+otBigN:Randomize():ExactValue())
        __ConOut(fhLog,'tBigNumber():Randomize(999999999999,9999999999999)',"RESULT: "+otBigN:Randomize("999999999999","9999999999999"):ExactValue())
        __ConOut(fhLog,'tBigNumber():Randomize(1,9999999999999999999999999999999999999999"',"RESULT: "+otBigN:Randomize("1","9999999999999999999999999999999999999999"):ExactValue())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste RANDOMIZE  0 -------------- end")

    __ConOut(fhLog,__cSep)
    __ConOut(fhLog,"")
    __ConOut(fhLog,__cSep)

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst35*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst36(fhLog as numeric)

    local aFibonacci    as array

    local cN            as character
    local cW            as character

    local n             as numeric
    local x             as numeric
    local nSetDec       as numeric

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Fibonacci -------------- ")

    __ConOut(fhLog,"")

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
        __oRTime1:SetRemaining(nN_TEST)
        __oRTime1:Setstep(nISQRT)
        hb_mutexUnLock(__phMutex)
    endif

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for n:=1 to nN_TEST step nISQRT
        cN:=hb_NtoS(n)
        aFibonacci:=Fibonacci(cN)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(Len(aFibonacci))
            hb_mutexUnLock(__phMutex)
        endif
        for x:=1 To Len(aFibonacci)
            cW:=aFibonacci[x]
            __ConOut(fhLog,'Fibonacci('+cN+'):'+hb_NtoS(x),"RESULT: "+cW)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                hb_mutexUnLock(__phMutex)
            endif
        next x
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    aSize(aFibonacci,0)
    aFibonacci:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif /*__ADVPL__*/

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Fibonacci -------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst36*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst37(fhLog as numeric)

    local aFibonacci    as array

    local cN            as character
    local cF            as character

    local f             as numeric
    local nD            as numeric
    local nJ            as numeric
    local nSetDec       as numeric

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste Fibonacci x Mersenne-------------- ")

    __ConOut(fhLog,"")

    nJ:=Len(aACN_MERSENNE_POW)

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
       __oRTime1:SetRemaining(nJ)
       hb_mutexUnLock(__phMutex)
    endif

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for nD:=1 To nJ
        cN:=aACN_MERSENNE_POW[nD]
        aFibonacci:=Fibonacci(cN)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime2:SetRemaining(Len(aFibonacci))
            hb_mutexUnLock(__phMutex)
        endif
        for f:=1 To Len(aFibonacci)
            cF:=aFibonacci[f]
            __ConOut(fhLog,'Fibonacci('+cN+'):'+hb_NtoS(f),"RESULT: "+cF)
            if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                __oRTime2:Calcule()
                __oRTime1:Calcule(.F.)
                hb_mutexUnLock(__phMutex)
            endif
        next x
        __ConOut(fhLog,__cSep)
        __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            __oRTime1:Calcule()
            __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next n
    aSize(aFibonacci,0)
    aFibonacci:=NIL
    #ifdef __HARBOUR__
        tBigNGC()
    #endif /*__ADVPL__*/

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste Fibonacci x Mersenne-------------- end")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst37*/

//--------------------------------------------------------------------------------------------------------
static procedure tBigNtst38(fhLog as numeric)

    local cM        as character
    local cR        as character

    local nD        as numeric
    local nJ        as numeric
    local nSetDec   as numeric

    #ifdef __HARBOUR__
        local nstep as numeric
        local ptftBigNtst38  as pointer
        local ptttBigNtst38  as pointer
        local lFinalize      as logical
    #endif

    local otBig2    as object
    local otBigM    as object

    __ConOut(fhLog,"["+ProcName()+"]: BEGIN ------------ Teste BIG Mersenne Number -------------- ")

    __ConOut(fhLog,"")

    nJ:=Len(aACN_MERSENNE_POW)

    if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
       __oRTime1:SetRemaining(nJ)
       hb_mutexUnLock(__phMutex)
    endif

    otBig2:=tBigNumber():New("2")
    otBigM:=tBigNumber():New("0")

    nSetDec:=Set(_SET_DECIMALS,Min(__SETDEC__,nACC_SET))

    for nD:=1 to nJ
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
           __oRTime2:SetRemaining(1)
           #ifdef __HARBOUR__
                nstep:=(1/1000)
                __oRTime2:Setstep(nstep)
                __oRTime2:forcestep(.T.)
           #endif /*__HARBOUR__*/
           hb_mutexUnLock(__phMutex)
        endif
        cM:=aACN_MERSENNE_POW[nD]
        __ConOut(fhLog,'2:tBigNumber():iPow('+cM+'):OpDec()',":...")
        #ifdef __HARBOUR__
            lFinalize:=.F.
            ptftBigNtst38:=@tBigNtst38Thread()
            ptttBigNtst38:=hb_threadStart(HB_THREAD_INHERIT_MEMVARS,;
            ptftBigNtst38,@lFinalize,otBig2,cM,otBigM,@cR)
            while (!lFinalize)
                if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
                    #ifdef __HARBOUR__
                        __oRTime2:forcestep(.F.)
                    #endif /*__HARBOUR__*/
                    __oRTime2:Calcule()
                    __oRTime1:Calcule()
                hb_mutexUnLock(__phMutex)
        endif
            end while
            hb_threadQuitRequest(ptttBigNtst38)
            hb_ThreadWait(ptttBigNtst38)
        #else
            otBigM:SetValue(otBig2:iPow(cM))
            cR:=otBigM:OpDec():ExactValue()
        #endif
        otBigM:SetValue("0")
        __ConOut(fhLog,otBig2:ExactValue()+':tBigNumber():iPow('+cM+'):OpDec()',"RESULT: "+cR)
        if (hb_mutexLock(__phMutex,N_MTX_TIMEOUT))
            #ifdef __HARBOUR__
                __oRTime2:forcestep(.F.)
            #endif /*__HARBOUR__*/
            __oRTime2:Calcule()
            __oRTime1:Calcule()
            __ConOut(fhLog,__cSep)
            __ConOut(fhLog,"AVG TIME: "+__oRTime2:GetcAverageTime())
            hb_mutexUnLock(__phMutex)
        endif
        *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
        __ConOut(fhLog,__cSep)
    next nD

    __ConOut(fhLog,"AVG TIME: "+__oRTime1:GetcAverageTime())
    *__ConOut(fhLog,"DATE/TIME: "+DToC(Date())+"/"+Time())
    __ConOut(fhLog,__cSep)

    __ConOut(fhLog,"")

    __ConOut(fhLog,"------------ Teste BIG Mersenne Number -------------- end")

    __ConOut(fhLog,"")

    __ConOut(fhLog,"")

    Set(_SET_DECIMALS,nSetDec)

    return
/*static procedure tBigNtst38*/

#ifdef __HARBOUR__

    static procedure tBigNtst38Thread(lFinalize as logical,otBig2 as object,cM as character,otBigM as object,cR as character)

        local aEvent    as array
        
        local oThreads  as object

        //"Share publics and privates with child threads."
        oThreads:=tBigNThread():New()
        oThreads:Start(1,HB_THREAD_INHERIT_MEMVARS)
        aEvent:={@tBigNtst38Eval(),otBig2,cM,otBigM,cR}
        oThreads:setEvent(1,@aEvent)
        oThreads:Notify()
        oThreads:Wait()
        oThreads:Join()

        cR:=oThreads:getResult(1)

        lFinalize:=.T.

        return
        
    static function tBigNtst38Eval(otBig2 as object,cM as character,otBigM as object,cR as character)
        otBigM:SetValue(otBig2:iPow(cM))
        cR:=otBigM:OpDec():ExactValue()
    return(cR)

    static function GETCURRENTPROCESSID()
    #if defined( __PLATFORM__WINDOWS )
       return(WAPI_GETCURRENTPROCESSID())
    #else
       return(ExecPIDNum())
    #endif
 
 #endif
