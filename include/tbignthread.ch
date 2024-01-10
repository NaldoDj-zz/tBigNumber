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

#ifndef _hb_TBigNThread_CH
    #define _hb_TBigNThread_CH
    #ifndef _hb_TBigNDef_CH
        #include "tbigNDef.ch"
    #endif
    //-------------------------------------------------------------------------------------
    /* Thread Control */
    #define TH_MTX 1
    #define TH_NUM 2
    #define TH_EXE 3
    #define TH_RES 4
    #define TH_END 5
#ifdef __ADVPL__
    #define TH_ERR 6
    #define TH_MSG 7
    #define TH_STK 8
    #define TH_GLB 9
    #define TH_HDL 10
    #define TH_KEY 11
    #define SIZ_TH 11
    #ifndef HB_THREAD_CH_
        #define HB_THREAD_CH_
        #define HB_THREAD_INHERIT_PUBLIC    1
        #define HB_THREAD_INHERIT_PRIVATE   2
        #define HB_THREAD_INHERIT_MEMVARS   3
        #define HB_THREAD_MEMVARS_COPY      4
    #endif ///* HB_THREAD_CH_ */
#else //__HARBOUR__
    #define SIZ_TH 5
#endif //__ADVPL__

#endif /*_hb_TBigNThread_CH*/
