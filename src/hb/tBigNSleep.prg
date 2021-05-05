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
