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

#ifndef _hb_tBigNtst_CH

    #define _hb_tBigNtst_CH

    #ifdef __PLATFORM__WINDOWS
       #if !defined( __HBSCRIPT__HBSHELL )
          ANNOUNCE HB_GTSYS
          REQUEST HB_GT_WVT_DEFAULT
       #endif
       #define THREAD_GT "WVT"
    #else
       REQUEST HB_GT_STD_DEFAULT
       #define THREAD_GT "XWC"
    #endif

    #undef __HBSHELL_USR_DEF_GT

    #if defined( __HBSCRIPT__HBSHELL )
        #if defined( __PLATFORM__WINDOWS )
            #define HBSHELL_GTSELECT "GTWVT"
            #define __HBSHELL_USR_DEF_GT 1
        #elif defined( __PLATFORM__UNIX )
            #define HBSHELL_GTSELECT "GTXWC"
            #define __HBSHELL_USR_DEF_GT 2
        #endif
    #endif

#endif
