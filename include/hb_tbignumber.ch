/*
 * Copyright 2011-2024 Marinaldo de Jesus (blacktdn.com.br)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 * (or visit their website at https://www.gnu.org/licenses/).
 *
 */

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

        #if defined(__PLATFORM__CYGWIN) .AND. !defined(__PTCOMPAT__) //TODO: Remover teste quando resolver diferencas encontradas nesta plataforma.
            #define __PTCOMPAT__ //Forco o modo de Compatibilidade com o Protheus
        #endif

        #ifndef MTX_KEY
            #define MTX_KEY
        #endif

        #ifndef CRLF
            #define CRLF hb_eol()
        #endif

    #endif

#endif /*_hb_TBigNumber_CH*/
