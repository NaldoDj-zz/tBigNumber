#include "error.ch"
#include "hbmemory.ch"
#include "tBigNumber.ch"

/*----------------------------------------------------------------------------
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with
   this software; see the file COPYING. If not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
   visit the web site http://www.gnu.org/).

   As a special exception, you have permission for additional uses of the text
   contained in this release of Harbour Minigui.

   The exception is that, if you link the Harbour Minigui library with other
   files to produce an executable, this does not by itself cause the resulting
   executable to be covered by the GNU General Public License.
   Your use of that executable is in no way restricted on account of linking the
   Harbour-Minigui library code into it.

   Parts of this project are based upon:

   "Harbour GUI framework for Win32"
   Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
   Copyright 2001 Antonio Linares <alinares@fivetech.com>
   www - http://harbour-project.org

	"MINIGUI - Harbour Win32 GUI library source code"
	Copyright 2002-2010 Roberto Lopez <harbourminigui@gmail.com>
	http://harbourminigui.googlepages.com/

	"Harbour Project"
	Copyright 1999-2013, http://harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
	Copyright 2001-2009 Alexander S.Kresin <alex@belacy.belgorod.su>
---------------------------------------------------------------------------*/

Static __cErrorLogFile

Procedure ErrorSys
    Local cPathErr := tbNCurrentFolder()+hb_ps()+"tbigN_err"+hb_ps()
    Local cFileErr := cPathErr+"tbNErrorLog.html"
    SetErrorLogFile(cFileErr)
    ErrorBlock({|oError|DefError(oError)})
    MakeDir(cPathErr)    
    #ifndef __XHARBOUR__
    	Set(_SET_HBOUTLOG,cPathErr+"tbN.Log")
    	Set(_SET_HBOUTLOGINFO,"tBigNumber")
    #endif
Return

Procedure SetErrorLogFile(cFile)
    __cErrorLogFile := cFile
Return

Function GetErrorLogFile()
Return(__cErrorLogFile)

Function Build_Mode()
Return(IF(hb_mtvm()," (MT)","")+IF(Memory(HB_MEM_USEDMAX)!=0," (FMSTAT)",""))

Static Function DefError(oError)
    
    Local cText
    Local cHtmText

    Local n
    Local nfHtmFile

    // By default,division by zero results in zero
    IF oError:genCode == EG_ZERODIV .AND. oError:canSubstitute
        Return(0)
    ENDIF

    // By default,retry on RDD lock error failure
    IF oError:genCode == EG_LOCK .AND. oError:canRetry
        Return(.T.)
    ENDIF

    // Set NetErr() of there was a database open error
    IF oError:genCode == EG_OPEN .AND. oError:osCode == 32 .AND. oError:canDefault
        NetErr(.T.)
        Return(.F.)
    ENDIF

    // Set NetErr() if there was a lock error on dbAppend()
    IF oError:genCode == EG_APPENDLOCK .AND. oError:canDefault
        NetErr(.T.)
        Return(.F.)
    ENDIF

  	nfHtmFile	:= Html_ErrorLog()
    cText 		:= ErrorMessage(oError)

    Html_LineText(nfHtmFile,'<p class="updated">Date: '+DToC(Date())+"  "+"Time: "+Time())
    Html_LineText(nfHtmFile,cText+"</p>")
    cText += CRLF+CRLF

    n := 1
    WHILE !Empty(ProcName(++n))
        cHtmText := "Called from "+ProcName(n)+"("+hb_ntos(ProcLine(n))+")" +CRLF
        cText += cHtmText
        Html_LineText(nfHtmFile,cHtmText)
    ENDDO

    Html_Line(nfHtmFile)
    Html_End(nfHtmFile)

    hb_threadTerminateAll()

    CLEAR SCREEN
    ? cText
    QUIT

Return(.F.)

Static Function ErrorMessage(oError)

    // start error message
    Local cMessage := (IF(oError:severity>ES_WARNING,"Error","Warning")+" ")

    // add subsystem name if available
    IF ISCHARACTER(oError:subsystem)
        cMessage += oError:subsystem()
    ELSE
        cMessage += "???"
    ENDIF

    // add subsystem's error code if available
    IF ISNUMBER(oError:subCode)
        cMessage += "/"+hb_ntos(oError:subCode)
    ELSE
        cMessage += "/???"
    ENDIF

    // add error description if available
    IF ISCHARACTER(oError:description)
        cMessage += "  "+oError:description
    ENDIF

    // add either filename or operation
    DO CASE
    CASE !Empty(oError:filename)
        cMessage += ": "+oError:filename
    CASE !Empty(oError:operation)
        cMessage += ": "+oError:operation
    ENDCASE

    // add OS error code if available
    IF !Empty(oError:osCode)
        cMessage += " (DOS Error "+hb_ntos(oError:osCode)+")"
    ENDIF

Return(cMessage)

Static Function HTML_ERRORLOG()

    Local nfHtmFile
    Local cErrorLogFile := GetErrorLogFile()

    IF .NOT.File(cErrorLogFile)
		nfHtmFile := Html_Ini(cErrorLogFile,"Harbour tBigNumber Errorlog File")
		IF nfHtmFile>0
    		Html_Line(nfHtmFile)
        ENDIF
  	ELSE
    	nfHtmFile := FOpen(cErrorLogFile,2)
    	IF nfHtmFile>0
    		FSeek(nfHtmFile,0,2)  // End Of File
    	ENDIF
    ENDIF
    
Return(nfHtmFile)

Static Function HTML_INI(cFile,cTitle)

    Local nfHtmFile
    Local cStyle  := "<style> "     +;
        "body{ "                    +;
        "font-family: sans-serif;"  +;
        "background-color: #ffffff;"+;
        "font-size: 75%;"           +;
        "color: #000000;"           +;
        "}"                         +;
        "h1{"                       +;
        "font-family: sans-serif;"  +;
        "font-size: 150%;"          +;
        "color: #0000cc;"           +;
        "font-weight: bold;"        +;
        "background-color: #f0f0f0;"+;
        "}"                         +;
        ".updated{"                 +;
        "font-family: sans-serif;"  +;
        "color: #cc0000;"           +;
        "font-size: 110%;"          +;
        "}"                         +;
        ".normaltext{"              +;
        "font-family: sans-serif;"  +;
        "font-size: 100%;"          +;
        "color: #000000;"           +;
        "font-weight: normal;"      +;
        "text-transform: none;"     +;
        "text-decoration: none;"    +;
        "}"                         +;
        "</style>"
	nfHtmFile := FCreate(cFile)
    IF FError() != 0
    	Return(-1)
    ENDIF
    fWrite(nfHtmFile,"<HTML><HEAD><TITLE>"+cTitle+"</TITLE></HEAD>"+cStyle+"<BODY>"+Chr(13)+Chr(10))
    fWrite(nfHtmFile,'<H1 Align=Center>'+cTitle+'<br>'+GetHbVersion()+'</H1><BR>'+Chr(13)+Chr(10))
Return(nfHtmFile)

Static Procedure HTML_LINETEXT(nfHtmFile,cText)
    IF nfHtmFile>0
        fWrite(nfHtmFile,RTrim(cText)+"<BR>"+Chr(13)+Chr(10))
    ENDIF
Return

Static Procedure HTML_LINE(nfHtmFile)
    IF nfHtmFile>0
        fWrite(nfHtmFile,"<HR>"+Chr(13)+Chr(10))
    ENDIF
Return

Static Procedure HTML_END(nfHtmFile)
    IF nfHtmFile>0
        fWrite(nfHtmFile,"</BODY></HTML>")
        FClose(nfHtmFile)
    ENDIF
Return

Static Function GetHbVersion()
Return("tBigNumber :"+Version()+Build_Mode()+","+OS())