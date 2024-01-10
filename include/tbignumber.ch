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

#ifndef _TBigNumber_CH

    #define _TBigNumber_CH

    #ifndef _hb_TBigNDef_CH
        #include "tbigNDef.ch"
    #endif

    #ifdef __ADVPL__
        #include "pt_tBigNumber.ch"
    #else
        #ifdef __HARBOUR__
            #include "hb_tBigNumber.ch"
        #endif
    #endif

    #include "set.ch"
    #include "fileio.ch"
    #include "tbignthread.ch"
    #include "tbignmessage.ch"

    #define MAX_DECIMAL_PRECISION    99999999999999999999999999999 //99.999.999.999.999.999.999.999.999.999

#endif /*_TBigNumber_CH*/
