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

#include "tbigndef.ch"
procedure tBigNSleep(nSleep)
    #ifdef __PROTHEUS__
        sleep(nSleep*1000)
    #else
        tBigNIdleSleep(nSleep)
    #endif
Return
#ifdef __HARBOUR__
    /* warning: 'void hb_FUN_...()'  defined but not used [-Wunused-function]...*/
    static function __Dummy(lDummy)
        lDummy:=.F.
        if (lDummy)
            __Dummy()
            TBIGNIDLESTATE()
            TBIGNIDLESTATE()
            TBIGNIDLERESET()
            TBIGNIDLEADD()
            TBIGNIDLEDEL()
            TBIGNRELEASECPU()
        endif
    return(.F.)
    #include "../src/hb/c/tbigNidle.c"
#endif // __HARBOUR__
