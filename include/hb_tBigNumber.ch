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

        #xcommand DEFAULT =>
        //-------------------------------------------------------------------------------------
        /* Default parameters management */
        #xtranslate DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        iif( <uVar1> == NIL , hb_Default(@<uVar1>,<uVal1>) , );
                        [; iif( <uVarN> == NIL , hb_Default(@<uVarN>,<uValN>) , ) ]
        
        #ifndef CRLF
            #define CRLF hb_eol()
        #endif
        
        //-------------------------------------------------------------------------------------
        /* Thread Control */
        #define TH_MTX 1
        #define TH_NUM 2
        #define TH_EXE 3
        #define TH_RES 4
        #define TH_END 5
        #define SIZ_TH 5

    #endif
    
#endif