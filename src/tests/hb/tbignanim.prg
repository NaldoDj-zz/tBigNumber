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

static function GetBigNAnim()
    local cCR:=Chr(13)
    local cLF:=Chr(10)
    local cEoL:=hb_EoL()
    local aAnim:=Array(0)
    aAdd(aAnim,aSwimming())
    aAdd(aAnim,aBasketball())
    aAdd(aAnim,aBicycling())
    aAdd(aAnim,aMacarena())
    aAdd(aAnim,aBaseball())
    aAdd(aAnim,aStationTraffic())
    aEval(aAnim,{|s,n|s:=StrTran(StrTran(StrTran(s,cCR,""),cLF,""),cEoL,""),aAnim[n]:=s})
return(aAnim)
static function aSwimming()
    /* http://www.incredibleart.org/links/ascii.html (ASCII Animated Art by Joan Stark) */
#pragma __streaminclude "../src/tests/hb/ASCII.art/Swimming.ASCII.art"|return(%s)
static function aBasketball()
    /* http://shanx.com/ascii/basketball */
#pragma __streaminclude "../src/tests/hb/ASCII.art/Basketball.ASCII.art"|return(%s)
static function aBicycling()
    /* http://shanx.com/ascii/bicycle-race */
#pragma __streaminclude "../src/tests/hb/ASCII.art/Bicycling.ASCII.art"|return(%s)
static function aMacarena()
    /* http://shanx.com/ascii/macarena */
#pragma __streaminclude "../src/tests/hb/ASCII.art/Macarena.ASCII.art"|return(%s)
static function aBaseball()
    /*Baseball, by Joan G. Stark: http://www.retrojunkie.com/asciiart/ani/misc/baseball.htm */
#pragma __streaminclude "../src/tests/hb/ASCII.art/Baseball.ASCII.art"|return(%s)
static function aStationTraffic()
    /* http://www.ascii-art.de/ascii/anim/station_anim.shtml */
#pragma __streaminclude "../src/tests/hb/ASCII.art/StationTraffic.ASCII.art"|return(%s)
