#ifndef _hb_TBigNThread_CH
    #define _hb_TBigNThread_CH
    #ifndef _hb_TBigNDef_CH
        #include "tbigNDef.ch"
    #endif
    //-------------------------------------------------------------------------------------
    /* Thread Control */
    #define TH_MTX 1
    #define TH_NUM 2
    #define TH_EXE 3
    #define TH_RES 4
    #define TH_END 5
#ifdef __PROTHEUS__
    #define TH_ERR 6
    #define TH_MSG 7
    #define TH_STK 8
    #define TH_GLB 9
    #define TH_HDL 10
    #define TH_KEY 11
    #define SIZ_TH 11
#else //__HARBOUR__
    #define SIZ_TH 5
#endif //__PROTHEUS__

#endif /*_hb_TBigNThread_CH*/
