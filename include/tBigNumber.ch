#ifndef _TBigNumber_CH

    #define _TBigNumber_CH

    #ifndef _hb_TBigNDef_CH
        #include "tbigNDef.ch"
    #endif

    #ifdef __ADVPL__
        #include "pt_tBigNumber.ch"
    #else
        #ifdef __HARBOUR__
            #include "hb_tBigNumber.ch"
        #endif
    #endif

    #include "set.ch"
    #include "fileio.ch"
    #include "tbignthread.ch"
    #include "tbignmessage.ch"
    
    #ifdef __ADVPL__
        #xtranslate hb_bLen([<prm,...>])        => Len([<prm>])
        #xtranslate tBIGNaLen([<prm,...>])      => Len([<prm>])
        #xtranslate hb_mutexCreate()            => ThreadID()
        #xtranslate hb_mutexLock([<prm,...>])   => AllWaysTrue([<prm>])
        #xtranslate hb_mutexUnLock([<prm,...>]) => AllWaysTrue([<prm>])
        #xtranslate method <methodName> SETGET  => method <methodName>
    #else 
        #ifdef __HARBOUR__
            #xtranslate Left([<prm,...>])    => hb_bLeft([<prm>])
            #xtranslate Right([<prm,...>])   => hb_bRight([<prm>])
            #xtranslate SubStr([<prm,...>])  => hb_bSubStr([<prm>])
            #xtranslate AT([<prm,...>])      => hb_bAT([<prm>])
        #endif
    #endif

    #define MAX_DECIMAL_PRECISION    99999999999999999999999999999 //99.999.999.999.999.999.999.999.999.999

#endif /*_TBigNumber_CH*/
