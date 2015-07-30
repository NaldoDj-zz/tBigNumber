#ifndef _hb_tBigNtst_CH

    #define _hb_tBigNtst_CH

    #ifdef __PLATFORM__WINDOWS
       #if !defined( __HBSCRIPT__HBSHELL )
          ANNOUNCE HB_GTSYS
          REQUEST HB_GT_WVT_DEFAULT
       #endif
       #define THREAD_GT "WVT"
    #else
       REQUEST HB_GT_STD_DEFAULT
       #define THREAD_GT "XWC"
    #endif  

    #undef __HBSHELL_USR_DEF_GT
    
    #if defined( __HBSCRIPT__HBSHELL )
        #if defined( __PLATFORM__WINDOWS )
            #define HBSHELL_GTSELECT "GTWVT"
            #define __HBSHELL_USR_DEF_GT 1
        #elif defined( __PLATFORM__UNIX )
            #define HBSHELL_GTSELECT "GTXWC"
            #define __HBSHELL_USR_DEF_GT 2
        #endif
        
    #endif
        
#endif
