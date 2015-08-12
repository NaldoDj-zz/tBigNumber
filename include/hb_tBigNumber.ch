#ifndef _hb_TBigNumber_CH

    #define _hb_TBigNumber_CH

    #ifdef __HARBOUR__
        #include "common.ch"
        #include "hbclass.ch"
        #include "hbthread.ch"
*       #include "hbcompat.ch"
        #ifdef TBN_DBFILE
            #ifndef TBN_MEMIO
                request DBFCDX , DBFFPT
            #else
                #require "hbmemio"
                request HB_MEMIO
            #endif
        #endif

        #ifndef __XHARBOUR__
            #include "xhb.ch" //add xHarbour emulation to Harbour
        #endif
        
        #xtranslate tbNCurrentFolder() => (hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir())

        #if defined(__PLATFORM__CYGWIN) //TODO: Remover teste quando resolver diferencas encontradas nesta plataforma.
            #define __PTCOMPAT__        //Forco o modo de Compatibilidade com o Protheus
        #endif

        #ifndef CRLF
            #define CRLF hb_eol()
        #endif

    #endif
    
#endif /*_hb_TBigNumber_CH*/
