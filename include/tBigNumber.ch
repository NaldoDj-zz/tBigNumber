#ifndef _TBigNumber_CH

    #define _TBigNumber_CH

    #include "tBigndef.ch"
    #ifdef __PROTHEUS__
        #include "pt_tBigNumber.ch"
    #else
        #ifdef __HARBOUR__
            #include "hb_tBigNumber.ch"
        #endif
    #endif
    #include "set.ch"
    #include "fileio.ch"
    #include "tbignthread.ch"

    #define MAX_DECIMAL_PRECISION    99999999999999999999999999999 //99.999.999.999.999.999.999.999.999.999

#endif /*_TBigNumber_CH*/