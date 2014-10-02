#include "tbigndef.ch"
procedure tBigNSleep(nSleep)
    #ifdef __PROTHEUS__
        sleep(nSleep*1000)
    #else
        Local nTime
        nTime := (hb_MilliSeconds()+(nSleep*1000))
        while (hb_MilliSeconds()<nTime)
        end while
    #endif
Return