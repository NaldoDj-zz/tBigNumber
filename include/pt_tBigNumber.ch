#ifndef _pt_TBigNumber_CH

    #define _pt_TBigNumber_CH   

    #ifdef __PROTHEUS__

        #include "totvs.ch"

        #xtranslate thread static        => static
        #xtranslate hb_ntos([<n,...>])   => LTrim(Str([<n>]))
        #xtranslate NToS([<n,...>])      => LTrim(Str([<n>]))
        #xtranslate user procedure       => user function
        #xcommand user procedure <p>     => procedure u_<p>
        #xtranslate user procedure <p>   => procedure u_<p>
        #xcommand method function <m>    => method <m>
        #xtranslate method function <m>  => method <m>
        #xcommand method procedure <m>   => method <m>
        #xtranslate method procedure <m> => method <m>

        #ifndef MTX_KEY
            #define MTX_KEY NToS(ThreadID())
        #endif
        
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
    
#endif /*_pt_TBigNumber_CH*/
