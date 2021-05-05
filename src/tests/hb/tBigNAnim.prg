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
