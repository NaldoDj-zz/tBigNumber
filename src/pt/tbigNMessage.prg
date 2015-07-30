    #include "tBigNumber.ch"

#define MSG_CONOUT      1//:Mensagem via ConOut
#define MSG_ALERT       2//:Mensagem via MsgAlert
#define MSG_INFO        3//:Mensagem via MsgInfo
#define MSG_STOP        4//:Mensagem via MsgStop
#define MSG_INTERNAL    5//:Mensagem via PTInternal
#define MSG_HELP        6//:Mensagem via Help
#define MSG_LOG         7//:Mensagem via LOG

Class tBigNMessage
    
    data cOwner
    data nOutPut
    
    method function New(nOutPut) CONSTRUCTOR /*(/!\)*/
    
    method function OutPutMessage(xOutPut,nOutPut)
    method function ToInternal(cOutInternal)
    
EndClass

user function tBigNMessage(nOutPut)
    PARAMTYPE 1 VAR nOutPut AS NUMBER OPTIONAL DEFAULT MSG_CONOUT
return(tBigNMessage():New(nOutPut))

method function new(nOutPut) class tBigNMessage
    PARAMTYPE 1 VAR nOutPut AS NUMBER OPTIONAL DEFAULT MSG_CONOUT
    self:cOwner:="MSG"
    self:nOutPut:=nOutPut
return(self)

method function OutPutMessage(xOutPut,nOutPut) class tBigNMessage 

    local cCRLF      AS CHARACTER
    local cType      AS CHARACTER VALUE valType(xOutPut)
    local cOutPut    AS CHARACTER VALUE ""
    local cProcName  AS CHARACTER VALUE ProcName(1)
    local cProcName1 AS CHARACTER VALUE ProcName(2)

    PARAMTYPE 1 VAR xOutPut AS ARRAY,BLOCK,CHARACTER,DATE,NUMBER,LOGICAL,UNDEFINED
    PARAMTYPE 2 VAR nOutPut AS NUMBER OPTIONAL DEFAULT MSG_CONOUT
 
    try exception
    
        if .not.(nOutPut==MSG_LOG)
            if (cType=="A")
                ASSIGN cCRLF:=CRLF
                aEval(xOutPut,{|x|if((valType(x)=="C"),cOutPut+=(xOutPut[x]+cCRLF),cOutPut+=OutPutMessage(x,0))}) 
            else
                do case
                case (cType=="B")
                    cOutPut:=OutPutMessage(Eval(xOutPut),0)
                case (cType=="O")
                    cOutPut:=OutPutMessage(ClassDataArr(cType,.T.),0)
                otherwise
                    cOutPut:=cValToChar(xOutPut)
                endcase                
            endif
            cOutPut:="["+self:cOwner+"]["+cProcName1+"]["+NToS(ProcLine(1))+"]["+DToS(MsDate())+"]["+Time()+"][MSG]"+cOutPut
        endif
    
        if (nOutPut==MSG_CONOUT)
            ConOut(cOutPut)
        elseIF (nOutPut==MSG_ALERT)
            ApMsgAlert(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_INFO)
            APMsgInfo(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_STOP)
            APMsgStop(cOutPut,cProcName1)
        elseIF (nOutPut==MSG_INTERNAL)
            self:ToInternal(cOutPut)
        elseIF (nOutPut==MSG_HELP)
            Help("",1,cProcName,NIL,OemToAnsi(cOutPut),1,0)
        elseIF (nOutPut==MSG_LOG)
            if (valType(xOutPut)=="A")
                //TODO: Implementar
                ConOut(cOutPut)
            endif
        endif

    catch exception
    
        cOutPut:="[OutPutMessage: ERROR]"
        ConOut(cOutPut)
        
    end exception
        
Return(cOutPut)

method function ToInternal(cOutInternal) class tBigNMessage
    PARAMTYPE 1 VAR cOutInternal AS CHARACTER OPTIONAL DEFAULT ""
    PTInternal(1,cOutInternal)
    #IFDEF TOP
        TCInternal(1,cOutInternal)    
    #ENDIF
Return(cOutInternal)

#include "tryexception.ch"
#include "paramtypex.ch"
