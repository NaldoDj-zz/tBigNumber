#ifndef _tBigNtst_CH

    #define _tBigNtst_CH

    #ifdef PROTHEUS
        #ifndef __PROTHEUS__
            #define __PROTHEUS__        
        #endif
        #include "pt_tBigNtst.ch"
    #else
        #ifdef __HARBOUR__
            #include "hb_tBigNtst.ch"
        #endif
    #endif

#endif