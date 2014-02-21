#ifndef _hb_TBigNumber_CH

    #define _hb_TBigNumber_CH

    #ifdef __HARBOUR__
        #include "common.ch"
        #include "hbclass.ch"
        #include "hbthread.ch"
*       #include "hbCompat.ch"
        #ifdef TBN_DBFILE
            #ifndef TBN_MEMIO
                REQUEST DBFCDX , DBFFPT
            #ELSE
                #require "hbmemio"
                REQUEST HB_MEMIO
            #endif
        #endif

        #ifndef __XHARBOUR__
            #include "xhb.ch" //add xHarbour emulation to Harbour
        #endif
        
        #xtranslate tbNCurrentFolder() => (hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir())

        #xcommand DEFAULT =>

        /* Default parameters management */
        #xtranslate DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        iif( <uVar1> == NIL , hb_Default(@<uVar1>,<uVal1>) , );
                        [; iif( <uVarN> == NIL , hb_Default(@<uVarN>,<uValN>) , ) ]
		

		/* TODO: Remover quando solucionar problema da divisao em C */
		#if defined(__ARCH64BIT__)
	    	#ifndef __PTCOMPAT__
	    		#define __PTCOMPAT__
	    	#endif	
		#endif
		
        #ifndef CRLF
            #define CRLF hb_eol()
        #endif
    
    #endif
    
#endif