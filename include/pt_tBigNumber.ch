#ifndef _pt_TBigNumber_CH

    #define _pt_TBigNumber_CH

    #ifdef __PROTHEUS__
    
    	#ifndef __PTCOMPAT__
    		#define __PTCOMPAT__
    	#endif	

        #include "protheus.ch"

        #xtranslate thread static      => static
        #xtranslate hb_ntos([<n,...>]) => LTrim(Str([<n>]))
        #xtranslate user procedure     => user function

        #xcommand DEFAULT =>
        /* Default parameters management */
        #xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                    => ;
                    <uVar1> := iif( <uVar1> == NIL, <uVal1>, <uVar1> ) ;
                    [; <uVarN> := iif( <uVarN> == NIL, <uValN>, <uVarN> ) ]


        #ifndef CRLF
            #define CRLF CHR(13)+CHR(10)
        #endif
    
    #endif
    
#endif