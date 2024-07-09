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

#ifndef _pt_TBigNumber_CH

    #define _pt_TBigNumber_CH

    #ifdef __ADVPL__

        #include "totvs.ch"

        #xtranslate thread static        => static
        #xtranslate hb_ntos([<n,...>])   => LTrim(Str([<n>]))
        #xtranslate hb_ntoc( <n> )       => LTrim( Str( <n> ) )
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
