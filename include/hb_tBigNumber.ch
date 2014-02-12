#IFNDEF _hb_TBigNumber_CH

    #DEFINE _hb_TBigNumber_CH

    #IFDEF __HARBOUR__
        #INCLUDE "common.ch"
        #INCLUDE "hbclass.ch"
        #INCLUDE "hbthread.ch"
*        #INCLUDE "hbCompat.ch"
        #IFDEF TBN_DBFILE
            #IFNDEF TBN_MEMIO
                REQUEST DBFCDX , DBFFPT
            #ELSE
                #require "hbmemio"
                REQUEST HB_MEMIO
            #ENDIF
        #ENDIF

        #IFNDEF __XHARBOUR__
            #INCLUDE "xhb.ch" //add xHarbour emulation to Harbour
        #ENDIF
        
        #xtranslate tbNCurrentFolder() => (hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir())

        #xcommand DEFAULT =>

        /* Default parameters management */
        #xtranslate DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        iif( <uVar1> == NIL , hb_Default(@<uVar1>,<uVal1>) , );
                        [; iif( <uVarN> == NIL , hb_Default(@<uVarN>,<uValN>) , ) ]
		

		/*
			TODO: Remover quando atualizar a plataforma
		*/
		//#if defined(__ARCH64BIT__).or.defined(__PLATFORM__WINCE)
		#if defined(__PLATFORM__WINCE)
			#xtranslate hb_BPeek(<c>,<p>)          => Asc(SubStr(<c>,<p>,1))
			#xtranslate hb_BCode(<c>)              => Asc(<c>)
			#xtranslate hb_BChar(<n>)              => Chr(<n>)
			#xtranslate hb_BLen(<c>)               => Len(<c>)
			#xtranslate hb_BSubStr(<c>,<p>[,<l>])  => SubStr(<c>,<p>,<l>)
			#xtranslate hb_BLeft(<c>,<l>)          => Left(<c>,<l>)
			#xtranslate hb_BRight(<c>,<l>)         => Right(<c>,<l>)
			#xtranslate hb_BStrTran(<c>,<s>[,<r>]) => StrTran(<c>,<s>,<r>)
			#xtranslate hb_IsFunction(<c>)         => (Type(<c>+"()")=="UI")
		#endif
		
        #IFNDEF CRLF
            #DEFINE CRLF hb_eol()
        #ENDIF
    
    #ENDIF
    
#ENDIF