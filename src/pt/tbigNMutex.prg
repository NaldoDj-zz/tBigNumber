#include "tBigNumber.ch"

static s__aMTXKey      AS ARRAY
static s__aMTXPrcExc    AS ARRAY
static s__aMTXSControl  AS ARRAY

/*
    class:tBigNMutex
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNMutex
    Sintaxe:tBigNMutex():New()-> self
*/
Class tBigNMutex
    
    data cExt
    data cMutex    
    data cMTXKey
    data cMTXPath
    data cHdlPath
    data cHdlFile

    data lLockByName
    
    data nSize
    data nSeep
    data nHdlFile
    data nAttempts

    method function New(cMutex,cMTXKey,lLockByName,lMTXCreate) cONSTRUCtoR /*(/!\)*/
    
    method function MTXKey()
    method function MTXCreate(cMTXKey,lInc,nSize)
    method function MTXFControl(cHdlFile,nHdlFile,lfClose,lExclusive)
    method function MTXSControl(cHdlFile,lfClose,lExclusive)
    method function MTXPrcExc(cProcA,cProcB,lfClose)
    
    method function MTXKillApp(cHdlFile,lForce)
    
    method procedure Clear()
    
endClass

user function tBigNMutex(cMutex,cMTXKey,lLockByName,lMTXCreate)
return(tBigNMutex():New(@cMutex,@cMTXKey,@lLockByName,@lMTXCreate))

method function New(cMutex,cMTXKey,lLockByName,lMTXCreate) class tBigNMutex
    self:cMTXPath:="\mtx\"
    if .not.(lIsDir(self:cMTXPath))
        MakeDir(self:cMTXPath)
    endif
    self:cHdlPath:=self:cMTXPath
    PARAMTYPE 1 VAR cMutex      AS CHARACTER OPTIONAL
    PARAMTYPE 2 VAR cMTXKey     AS CHARACTER OPTIONAL DEFAULT self:MTXKey()
    PARAMTYPE 3 VAR lLockByName AS LOGICAL   OPTIONAL DEFAULT .F.
    PARAMTYPE 4 VAR lMTXCreate  AS LOGICAL   OPTIONAL DEFAULT .T.
    self:cMTXKey:=cMTXKey
    self:cHdlPath+=self:cMTXKey+"\"
    if .not.(lIsDir(self:cHdlPath))
        MakeDir(self:cHdlPath)
    endif
    self:nHdlFile:=-1
    self:cMutex:=cMutex
    self:nSeep:=100
    self:nAttempts:=10
    self:lLockByName:=lLockByName
    if (lMTXCreate)
        cMutex:=self:MTXCreate(@self:cMTXKey,Empty(self:cMutex),@self:nSize)
    endif
return(self)

method function MTXKey() class tBigNMutex
return(self:MTXCreate("",.T.,3))

method function MTXCreate(cMTXKey,lInc,nSize) class tBigNMutex
    
    local aFiles        AS ARRAY VALUE Array(0)
    
    local cFile         AS CHARACTER
    local cHdlFile      AS CHARACTER
    local cHdlPath      AS CHARACTER VALUE self:cHdlPath
    local cMTXSMPR      AS CHARACTER
    local cMTXSMPF      AS CHARACTER
    local cProcName     AS CHARACTER
    
    local nKey          AS NUMBER
    local nFile         AS NUMBER
    local nFiles        AS NUMBER
    local nAttemp       AS NUMBER
    local nHdlFile      AS NUMBER

    local lHdlControl  AS LOGICAL
    
    cProcName:=ProcName()

    PARAMTYPE 1 VAR cMTXKey AS CHARACTER OPTIONAL DEFAULT self:cMTXKey
    PARAMTYPE 2 VAR nSize   AS NUMBER    OPTIONAL DEFAULT if(.not.(Empty(cMTXKey)),Len(cMTXKey),10)
    PARAMTYPE 3 VAR lInc    AS LOGICAL   OPTIONAL DEFAULT ((.T.).and.(.not.(Empty(self:cMutex)))) 

    if .not.(valType(s__aMTXKey)=="A")
        s__aMTXKey:=Array(0)
    endif

    nKey:=aScan(s__aMTXKey,{|e|e[1]==cMTXKey})
    if (nKey==0)
        self:cExt:=("."+Lower(cMTXKey+if(Empty(cMTXKey),"","-")+cProcName))
        aAdd(s__aMTXKey,{cMTXKey,nSize,self:cExt,cHdlPath})
        nKey:=Len(s__aMTXKey)
        if .not.(lIsDir(cHdlPath))
            MakeDir(cHdlPath)
        endif
        if .not.(Empty(cMTXKey))
            cFile:=s__aMTXKey[nKey][4]
            cFile+=s__aMTXKey[nKey][1]
             cFile+=s__aMTXKey[nKey][3]
              self:MTXSControl(cFile,.F.,.F.)
        endif
    endif
    nSize:=s__aMTXKey[nKey][2]
    self:cExt:=s__aMTXKey[nKey][3]
    cHdlPath:=s__aMTXKey[nKey][4]
    if .not.(lIsDir(cHdlPath))
        MakeDir(cHdlPath)
    endif
    
    if (self:lLockByName)
        while .not.(mtxLockByName(self:cExt))
            if (++nAttemp>self:nAttempts)
                UserException("Impossivel Obter Semaforo em "+cProcName)
            endif
            Sleep(self:nSleep)
        end while
    endif
    
    lInc:=(lInc.or.Empty(self:cMutex))
    
    if (lInc)
        cMTXSMPR:=Replicate("0",nSize)
        self:cMutex:=cMTXSMPR
    else
        cMTXSMPR:=self:cMutex
    endif
    
    nFiles:=aDir(cHdlPath+"*"+self:cExt,@aFiles)
    
    for nFile:=1 to nFiles
        cFile:=Lower(aFiles[nFile])
        cHdlFile:=(cHdlPath+cFile)
        if (File(cHdlFile))
            cMTXSMPF:=Upper(StrTran(cFile,self:cExt,""))
            if (lInc)
                cMTXSMPR:=if((cMTXSMPR>cMTXSMPF),cMTXSMPR,cMTXSMPF)
            endif
        endif
    next nFile
    
    if (lInc)
        cMTXSMPR:=__Soma1(cMTXSMPR)
        while File(cHdlPath+cMTXSMPR+self:cExt)
            cMTXSMPR:=__Soma1(cMTXSMPR)
        end while
    endif    
    
    self:cMutex:=cMTXSMPR

    cHdlFile:=(cHdlPath+cMTXSMPR+self:cExt)
    
    self:cHdlFile:=cHdlFile
    
    lHdlControl:=self:MTXFControl(@cHdlFile,@nHdlFile,.F.,.F.)

    self:cHdlFile:=cHdlFile
    self:nHdlFile:=nHdlFile
    
    if .not.(lHdlControl)
        if (self:lLockByName)
            mtxUnLockByName(self:cExt)
        endif    
        UserException("Impossivel Obter Semaforo para "+s__aMTXKey[nKey][1])
    endif
    
    fClose(nHdlFile)

    if (self:lLockByName)
        mtxUnLockByName(self:cExt)
    endif

return(cMTXSMPR)

method function MTXFControl(cHdlFile,nHdlFile,lfClose,lExclusive) class tBigNMutex

    local cSPDrive AS CHARACTER
    local cSPPath  AS CHARACTER
    local cSPFile  AS CHARACTER
    local cSPExt   AS CHARACTER

    local cHdlPath AS CHARACTER VALUE self:cHdlPath

    local lFile        AS LOGICAL VALUE .F.
    local lLockByName  AS LOGICAL VALUE .F.
    local lfoExclusive AS LOGICAL VALUE .T.
    
    local nAttempt AS NUMBER VALUE 0
    
    PARAMTYPE 1 VAR cHdlFile    AS CHARACTER OPTIONAL DEFAULT self:cHdlFile
    PARAMTYPE 2 VAR nHdlFile    AS NUMBER    OPTIONAL DEFAULT -1
    PARAMTYPE 3 VAR lfClose     AS LOGICAL   OPTIONAL DEFAULT .T.
    PARAMTYPE 4 VAR lExclusive  AS LOGICAL   OPTIONAL DEFAULT .F.

    SplitPath(cHdlFile,@cSPDrive,@cSPPath,@cSPFile,@cSPExt)

    ASSIGN cHdlFile:=cHdlPath
    ASSIGN cHdlFile+=cSPFile
    ASSIGN cHdlFile+=cSPExt
    
    ASSIGN self:cHdlFile:=cHdlFile

    if .not.(File(cHdlFile))
        if (self:lLockByName)
            while .not.(lLockByName:=mtxLockByName(cHdlFile))
                if (++nAttempt>self:nAttempts)
                    exit
                endif
                Sleep(self:nSleep)
                if File(cHdlFile)
                    exit
                endif
            end while
        else
            ASSIGN lLockByName:=.T.
        endif
        if (lLockByName)
            if .not.(File(cHdlFile))
                nHdlFile:=fCreate(cHdlFile)
                //-------------------------------------------------------------------
                // Por Padrao, libera o Bloqueio. Quem desejar o bloqueio deverá ser explicito. Ex.: MTXSControl
                fClose(nHdlFile)
                if (lfClose)
                    nHdlFile:=-1
                endif
                if (lExclusive)
                    nHdlFile:=fOpen(cHdlFile,FO_EXCLUSIVE)
                    lfoExclusive:=(fError()==0)
                endif
                self:nHdlFile:=nHdlFile
            endif
            if (self:lLockByName)
                mtxUnLockByName(cHdlFile)
            endif
        endif
    endif

    lFile:=(File(cHdlFile).and.(lfoExclusive))

    if .not.(lFile)
        //-------------------------------------------------------------------
        // "Impossivel Criar: "
        OutPutMessage("["+"Impossivel Criar: "+cHdlFile+"]")
    endif

Return(lFile)

method function MTXSControl(cHdlFile,lfClose,lExclusive) class tBigNMutex

    local lMTXSControl  AS LOGICAL VALUE .F.

    local nAT           AS NUMBER
    
    local nHdlFile      AS NUMBER
    
    IF .not.(valType(s__aMTXSControl)=="A")
        s__aMTXSControl:=Array(0)
    EndIF

    PARAMTYPE 1 VAR cHdlFile    AS CHARACTER OPTIONAL DEFAULT self:cHdlFile
    PARAMTYPE 2 VAR lfClose     AS LOGICAL   OPTIONAL DEFAULT .F.
    PARAMTYPE 3 VAR lExclusive  AS LOGICAL   OPTIONAL DEFAULT .T.
    
    ASSIGN cHdlFile:=Lower(cHdlFile)

    nAT:=aScan(s__aMTXSControl,{|e|e[1]==cHdlFile})
    if (nAT==0)
        aAdd(s__aMTXSControl,{cHdlFile,-1})
        ASSIGN nAT:=Len(s__aMTXSControl)
    endif

    ASSIGN cHdlFile:=s__aMTXSControl[nAT][1]
    ASSIGN nHdlFile:=s__aMTXSControl[nAT][2]
    
    ASSIGN lMTXSControl:=self:MTXFControl(@cHdlFile,@nHdlFile,@lfClose,@lExclusive)

    if .not.(s__aMTXSControl[nAT][1]==cHdlFile)
        s__aMTXSControl[nAT][1]:=cHdlFile
    endif                         

    if .not.(s__aMTXSControl[nAT][2]==nHdlFile)
        s__aMTXSControl[nAT][2]:=nHdlFile
    endif
    
    if (lExclusive)
        if (self:lLockByName)
            ASSIGN lMTXSControl:=mtxLockByName(cHdlFile)
        endif
    endif    

    if (lfClose)
        if (lMTXSControl)
            if (nHdlFile>=0)
                fClose(nHdlFile)
            endif
            fErase(cHdlFile)
            ASSIGN lMTXSControl:=.not.(File(cHdlFile))
            if (lMTXSControl)
                if (self:lLockByName)
                    mtxUnLockByName(cHdlFile)
                endif
                aDel(s__aMTXSControl,nAT)
                aSize(s__aMTXSControl,Len(s__aMTXSControl)-1)
            endif
        endif
    endif
    
Return(lMTXSControl)

method function MTXPrcExc(cProcA,cProcB,lfClose) class tBigNMutex
    
    local cProcName     AS CHARACTER   
    
    local cGlbValPA     AS CHARACTER
    local cGlbVarPA     AS CHARACTER
    local cFileProcA    AS CHARACTER
    
    local cGlbValPB     AS CHARACTER
    local cGlbVarPB     AS CHARACTER
    local cFileProcB    AS CHARACTER    

    local lMTXPrcExc    AS LOGICAL VALUE .F.

    local nAttempt      AS NUMBER
    
    local nATProcA      AS NUMBER
    local nFileProcA    AS NUMBER

    local nATProcB      AS NUMBER
    local nFileProcB    AS NUMBER
 
    IF .not.(valType(s__aMTXPrcExc)=="A")
        s__aMTXPrcExc:=Array(0)
    EndIF

    cProcName:=ProcName()

    PARAMTYPE 1 VAR cProcA  AS CHARACTER
    PARAMTYPE 2 VAR cProcB  AS CHARACTER
    PARAMTYPE 3 VAR lfClose AS LOGICAL    OPTIONAL DEFAULT .F.
    
    begin sequence

        if (self:lLockByName)
            while .not.(mtxLockByName(cProcName))
                if (++nAttempt>self:nAttempts)
                    break
                endif
                Sleep(self:nSleep)
            end while
        endif
    
        ASSIGN cProcA:=Lower(cProcA)
        ASSIGN cGlbVarPA:=cProcName+cProcA
        ASSIGN cGlbValPA:=xGetGlbValue(cGlbVarPA)
        
        if Empty(cGlbValPA)
            xPutGlbValue(cGlbVarPA,".F.")
            ASSIGN cGlbValPA:=xGetGlbValue(cGlbVarPA)
        endif
    
        ASSIGN cProcB:=Lower(cProcB)
        ASSIGN cGlbVarPB:=cProcName+cProcB
        ASSIGN cGlbValPB:=xGetGlbValue(cGlbVarPB)
        
        if Empty(cGlbValPB)
            xPutGlbValue(cGlbVarPB,".F.")
            ASSIGN cGlbValPB:=xGetGlbValue(cGlbVarPB)
        endif

        if .not.(lfClose)
            ASSIGN cGlbValPA:=if(Empty(cGlbValPA),".F.",cGlbValPA)
            ASSIGN cGlbValPB:=if(Empty(cGlbValPB),".F.",cGlbValPB)
            ASSIGN lMTXPrcExc:=(&cGlbValPA.and.(.not.(&cGlbValPB)))
            if (lMTXPrcExc)
                break
            endif
        endif
        
        ASSIGN nATProcA:=aScan(s__aMTXPrcExc,{|e|e[1]==cProcA.and.e[2]==cProcB})
        if (nATProcA==0)
            aAdd(s__aMTXPrcExc,{cProcA,cProcB,cProcA+"-"+cProcB+".lck",-1})
            ASSIGN nATProcA:=Len(s__aMTXPrcExc)
        endif
        
        ASSIGN nATProcB:=aScan(s__aMTXPrcExc,{|e|e[1]==cProcB.and.e[2]==cProcA})
        if (nATProcB==0)
            aAdd(s__aMTXPrcExc,{cProcB,cProcA,cProcB+"-"+cProcA+".lck",-1})
            ASSIGN nATProcB:=Len(s__aMTXPrcExc)
        endif
        
        ASSIGN cFileProcA:=s__aMTXPrcExc[nATProcA][3]
        ASSIGN nFileProcA:=s__aMTXPrcExc[nATProcA][4]
            
        ASSIGN lMTXPrcExc:=self:MTXFControl(@cFileProcA,@nFileProcA,@lfClose)
        
        if .not.(s__aMTXPrcExc[nATProcA][3]==cFileProcA)
            s__aMTXPrcExc[nATProcA][3]:=cFileProcA
        endif    
        
        if .not.(s__aMTXPrcExc[nATProcA][4]==nFileProcA)
            s__aMTXPrcExc[nATProcA][4]:=nFileProcA
        endif

        ASSIGN cFileProcB:=s__aMTXPrcExc[nATProcB][3]
        ASSIGN nFileProcB:=s__aMTXPrcExc[nATProcB][4]

        if (lMTXPrcExc)
            ASSIGN lMTXPrcExc:=self:MTXFControl(@cFileProcB,@nFileProcB,@lfClose)
            if .not.(s__aMTXPrcExc[nATProcB][3]==cFileProcB)
                s__aMTXPrcExc[nATProcB][3]:=cFileProcB
            endif    
            if .not.(s__aMTXPrcExc[nATProcB][4]==nFileProcB)
                s__aMTXPrcExc[nATProcB][4]:=nFileProcB
            endif
            if (lMTXPrcExc)
                if (nFileProcB>=0)
                    fClose(nFileProcB)
                endif
                fErase(cFileProcB)
                lMTXPrcExc:=((nFileProcB>=0).and..not.(File(cFileProcB)))
                xPutGlbValue(cGlbVarPA,cValtoChar(lMTXPrcExc))
            endif        
        endif
        
        if ((lfClose).or.(.not.(lMTXPrcExc)))
            if (nFileProcA>=0)
                fClose(nFileProcA)
            endif
            fErase(cFileProcA)
            lMTXPrcExc:=.not.(File(cFileProcA))
            if (lMTXPrcExc)
                aDel(s__aMTXPrcExc,nATProcA)
                aSize(s__aMTXPrcExc,Len(s__aMTXPrcExc)-1)
                if (nFileProcB>=0)
                    fClose(nFileProcB)
                endif
                fErase(cFileProcB)
                nATProcB:=aScan(s__aMTXPrcExc,{|e|e[1]==cProcB.and.e[2]==cProcA})
                if (nATProcB>0)
                    aDel(s__aMTXPrcExc,nATProcB)
                    aSize(s__aMTXPrcExc,Len(s__aMTXPrcExc)-1)
                endif
                xPutGlbValue(cGlbVarPA,".F.")
            endif
            if .not.(lfClose)
                lMTXPrcExc:=.F.
                if .not.(lMTXPrcExc)
                    xPutGlbValue(cGlbVarPA,".F.")
                endif
            else
                xClearGlbValue(cGlbVarPA)
                xClearGlbValue(cGlbVarPB)
            endif
        endif

    end sequence

    if (self:lLockByName)
        mtxUnLockByName(cProcName)
    endif

Return(lMTXPrcExc)

method function MTXKillApp(cHdlFile,lForce) class tBigNMutex
    
    local cSPDrive      AS CHARACTER
    local cSPPath       AS CHARACTER
    local cSPFile       AS CHARACTER
    local cSPExt        AS CHARACTER
    
    local cHdlPath      AS CHARACTER VALUE self:cHdlPath
    
    local lKillApp      AS LOGICAL
    
    PARAMTYPE 1 VAR cHdlFile AS CHARACTER OPTIONAL DEFAULT self:cHdlFile
    PARAMTYPE 2 VAR lForce   AS LOGICAL   OPTIONAL DEFAULT .F.
    
    SplitPath(cHdlFile,@cSPDrive,@cSPPath,@cSPFile,@cSPExt)
    
    ASSIGN cHdlFile:=cHdlPath
    ASSIGN cHdlFile+=cSPFile
    ASSIGN cHdlFile+=cSPExt

    if (lForce)
        fErase(cHdlFile)
    endif
    
    ASSIGN lKillApp:=if((.not.(File(cHdlFile)).or.lForce),(KillApp(.T.),.T.),KillApp())

Return(lKillApp)

method procedure Clear() class tBigNMutex
    local aFiles    AS ARRAY
    local cFile     AS CHARACTER
    local nFile     AS NUMBER
    local nFiles    AS NUMBER VALUE aDir(self:cHdlPath+"*"+self:cExt,@aFiles)    
    local nfHandle  AS NUMBER
    for nFile:=1 to nFiles
        cFile:=Lower(aFiles[nFile])
        cFile:=(self:cHdlPath+cFile)
        if (File(cFile))
            fErase(cFile)
        endif
    next nFile
    aSize(aFiles,0)
    if .not.(Empty(s__aMTXSControl))
        nFiles:=Len(s__aMTXSControl)
        while ((nFile:=aScan(s__aMTXSControl,{|e|self:cExt$e[1]}))>0)
            cFile:=Lower(s__aMTXSControl[nFile][1])
            nfHandle:=s__aMTXSControl[nFile][2]
            if .not.(nfHandle=-1)
                fClose(nfHandle)
            endif
            if (File(cFile))
                fErase(cFile)
            endif
            aSize(aDel(s__aMTXSControl,nFile),--nFiles)
        end while
    endif
    nFile:=aScan(s__aMTXKey,{|e|e[1]==self:cMTXKey})
    if (nFile>0)
        cFile:=s__aMTXKey[nFile][4]
        cFile+=s__aMTXKey[nFile][1]
        cFile+=s__aMTXKey[nFile][3]
        if File(cFile)
            fErase(cFile)
        endif
        if lIsDir(s__aMTXKey[nFile][4])
            DirRemove(s__aMTXKey[nFile][4])
        endif
        aSize(aDel(s__aMTXKey,nFile),(Len(s__aMTXKey)-1))
        nFile:=aScan(s__aMTXKey,{|e|e[1]==""})
        if (nFile>0)
            cFile:=s__aMTXKey[nFile][4]
            cFile+=self:cMTXKey
            cFile+=s__aMTXKey[nFile][3]
            if File(cFile)
                fErase(cFile)
            endif
        endif
        if lIsDir(self:cMTXKey)
            DirRemove(self:cMTXKey)
        endif
    endif
return

static function mtxLockByName(cName)
    if .not.(Type("cEmpAnt")=="C")
        Private cEmpAnt:=""
    endif
    if .not.(Type("cFilAnt")=="C")
        Private cFilAnt:=""
    endif
return(LockByName(cName))

static function mtxUnLockByName(cName)
    if .not.(Type("cEmpAnt")=="C")
        Private cEmpAnt:=""
    endif
    if .not.(Type("cFilAnt")=="C")
        Private cFilAnt:=""
    endif
return(UnLockByName(cName))

#include "paramtypex.ch"
#include "tBiGNCommon.prg"
