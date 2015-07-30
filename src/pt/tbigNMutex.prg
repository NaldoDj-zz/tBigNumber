#include "tBigNumber.ch"

static s__cMTXID

Class tBigNMutex

    data cEnvSrv
    
    data lUseEnvSrv
    data lUseThreadID
    data lRandomize
    
    data nMaxThreadID
    data nMaxReplicate
    data nMaxRandomize
    
    method function New() CONSTRUCTOR /*(/!\)*/
    
    method function MutexCreate()
    
EndClass

user function tBigNMutex()
return(tBigNMutex():New())

method function new() class tBigNMutex
    self:lUseEnvSrv:=.F.
    self:lUseThreadID:=.F.
    self:lRandomize:=.T.
    self:nMaxThreadID:=10
    self:nMaxReplicate:=3
    self:nMaxRandomize:=10
return(self)

method function MutexCreate() class tBigNMutex

    local cMutex  AS CHARACTER VALUE "MTX"
    
    DEFAULT ASSIGN s__cMTXID:=Replicate("0",self:nMaxReplicate)

    ASSIGN s__cMTXID:=__Soma1(s__cMTXID)

    if (self:lUseEnvSrv)
        DEFAULT self:cEnvSrv:=GetEnvServer()
        ASSIGN cMutex+=if(.not.(Empty(cMutex)),"_","")
        ASSIGN cMutex+=self:cEnvSrv
    endif

    if (self:lUseThreadID)
        ASSIGN cMutex+=if(.not.(Empty(cMutex)),"_","")
        ASSIGN cMutex+=StrZero(ThreadID(),self:nMaxThreadID)
    endif

    ASSIGN cMutex+=if(.not.(Empty(cMutex)),"_","")
    if (s__cMTXID>=Replicate("Z",self:nMaxReplicate))
        ASSIGN s__cMTXID:=Replicate("0",self:nMaxReplicate)
        ASSIGN s__cMTXID:=__Soma1(s__cMTXID)
    endif
    ASSIGN cMutex+=s__cMTXID

    if (self:lRandomize)
        ASSIGN cMutex+=if(.not.(Empty(cMutex)),"_","")
        ASSIGN cMutex+=StrZero(Randomize(1,self:nMaxRandomize),Len(NToS(self:nMaxRandomize)))
    endif

return(cMutex)

#include "paramtypex.ch"
