#include "tBigNDef.ch"

#ifdef PROTHEUS
    #ifndef __ADVPL__
        #define __ADVPL__
    #endif
    #include "protheus.ch"
#else
    #ifdef __HARBOUR__
        #include "hbclass.ch"
    #endif
#endif

#include "fileio.ch"
#include "directry.ch"
#include "tBigNumber.ch"

THREAD Static s_aPTables    AS ARRAY
THREAD Static s_nPTables    AS NUMERIC

THREAD Static s_oIPfRead    AS OBJECT
THREAD Static s_nIPfRead    AS NUMERIC
THREAD Static s_aIPLRead    AS ARRAY

THREAD Static s_oNPfRead    AS OBJECT
THREAD Static s_nNPfRead    AS NUMERIC
THREAD Static s_aNPLRead    AS ARRAY

//--------------------------------------------------------------------------------------------------------
    /*
        Class:tPrime
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Instancia um novo objeto do tipo tPrime
        Sintaxe:tPrime():New() -> self
        Obs.:Obter os Numeros Primos a Partir das Tabelas de Numeros Primos
                       fornecidas por primes.utm.edu (http://primes.utm.edu/lists/small/millions/)
        TODO:Implementar primesieve
                       http://sweet.ua.pt/tos/software/prime_sieve.html#p
                       https://code.google.com/p/primesieve/
    */
//--------------------------------------------------------------------------------------------------------
CLASS tPrime

    DATA cPrime     AS CHARACTER
    DATA cFPrime    AS CHARACTER
    DATA cLPrime    AS CHARACTER

    DATA nSize      AS NUMERIC

    #ifdef __HARBOUR__
        Method New(cPath AS CHARACTER,nLocal AS NUMERIC) CONSTRUCTOR
    #else /*__ADVPL__*/
        Method New(cPath,nLocal) CONSTRUCTOR
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method ClassName()
    #else /*__ADVPL__*/
        Method ClassName()
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method IsPrime(cN AS CHARACTER,lForce AS LOGICAL)
    #else /*__ADVPL__*/
        Method IsPrime(cN,lForce)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method IsPReset()
    #else /*__ADVPL__*/
        Method IsPReset()
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method NextPrime(cN AS CHARACTER,lForce AS LOGICAL)
    #else /*__ADVPL__*/
        Method NextPrime(cN,lForce)
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method NextPReset()
    #else /*__ADVPL__*/
        Method NextPReset()
    #endif /*__HARBOUR__*/

    #ifdef __HARBOUR__
        Method ResetAll()
    #else /*__ADVPL__*/
        Method ResetAll()
    #endif /*__HARBOUR__*/

ENDCLASS

//--------------------------------------------------------------------------------------------------------
    /*
        Function:tPrime():New
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Instancia um novo Objeto tPrime
        Sintaxe:tPrime():New() -> self
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __ADVPL__
    Function u_tPrime(cPath AS CHARACTER)
        Return(tPrime():New(cPath))
    /*Function u_tPrime*/
#endif

//--------------------------------------------------------------------------------------------------------
    /*
        Method:New
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:CONSTRUCTOR
        Sintaxe:tPrime():New(cPath) -> self
        ref.: https://primes.utm.edu/lists/small/
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method New(cPath AS CHARACTER,nLocal AS NUMERIC) CLASS tPrime
#else /*__ADVPL__*/
    Method New(cPath,nLocal) CLASS tPrime
#endif /*__HARBOUR__*/
        Local aLine     AS ARRAY
        Local aFiles    AS ARRAY

        Local bSPTables AS BLOCK

        Local cLine     AS CHARACTER
        Local cFile     AS CHARACTER

        Local cFPrime   AS CHARACTER
        Local cLPrime   AS CHARACTER

        Local nSize     AS NUMERIC
        Local nLine     AS NUMERIC
        Local nFile     AS NUMERIC
        Local nFiles    AS NUMERIC

        Local ofRead    AS OBJECT

        #ifdef __ADVPL__
            PARAMETER cPath     AS CHARACTER
            PARAMETER nLocal    AS NUMERIC
        #endif /*__ADVPL__*/

        DEFAULT s_aPTables:=Array(0)

        IF Empty(s_aPTables)
            self:nSize:=10
            #ifdef __HARBOUR__
                DEFAULT cPath:=hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir()+hb_ps()+"PrimesTables"+hb_ps()+"txt"+hb_ps()
            #else /*__ADVPL__*/
                DEFAULT cPath:="\PrimesTables\txt\"
            #endif
            aFiles:=Directory(cPath+"prime*.txt")
            nFiles:=Len(aFiles)
            nSize:=10
            ofRead:=tfRead():New()
            For nFile:=1 To nFiles
                cFile:=cPath+aFiles[nFile][F_NAME]
                nLine:=0
                ofRead:Open(cFile,NIL,nLocal)
                ofRead:ReadLine()
                While ofRead:MoreToRead()
                    cLine:=ofRead:ReadLine()
                    IF Empty(cLine)
                        Loop
                    EndIF
                    nLine:=Max(nLine,Len(cLine))
                    While "  "$cLine
                        cLine:=StrTran(cLine,"  "," ")
                    End While
                    While SubStr(cLine,1,1)==" "
                        cLine:=SubStr(cLine,2)
                    End While
                    While SubStr(cLine,-1)==" "
                        cLine:=SubStr(cLine,1,Len(cLine)-1)
                    End While
                    #ifdef __HARBOUR__
                         aLine:=hb_ATokens(cLine," ")
                    #else /*__ADVPL__*/
                         aLine:=StrTokArr2(cLine," ")
                    #endif /*__HARBOUR__*/
                    cFPrime:=aLine[1]
                    nSize:=Max(Len(cFPrime),nSize)
                    cFPrime:=PadL(cFPrime,nSize)
                    EXIT
                End While
                ofRead:Seek(-nLine,FS_END)
                While ofRead:MoreToRead()
                    cLine:=ofRead:ReadLine()
                    IF Empty(cLine)
                        Loop
                    EndIF
                    nLine:=Max(nLine,Len(cLine))
                    While "  "$cLine
                        cLine:=StrTran(cLine,"  "," ")
                    End While
                    While SubStr(cLine,1,1)==" "
                        cLine:=SubStr(cLine,2)
                    End While
                    While SubStr(cLine,-1)==" "
                        cLine:=SubStr(cLine,1,Len(cLine)-1)
                    End While
                    #ifdef __HARBOUR__
                         aLine:=hb_ATokens(cLine," ")
                    #else /*__ADVPL__*/
                         aLine:=StrTokArr2(cLine," ")
                    #endif /*__HARBOUR__*/
                    cLPrime:=aLine[Len(aLine)]
                    nSize:=Max(Len(cFPrime),nSize)
                    cLPrime:=PadL(cLPrime,nSize)
                    EXIT
                End While
                ofRead:Close(.T.)
                aAdd(s_aPTables,{cFile,cFPrime,cLPrime,nLine})
            Next nFile

            nFiles:=Len(s_aPTables)
            IF nFiles>0
                IF nSize>self:nSize
                    self:nSize:=nSize
                    For nFile:=1 To nFiles
                        s_aPTables[nFile][2]:=PadL(s_aPTables[nFile][2],nSize)
                        s_aPTables[nFile][3]:=PadL(s_aPTables[nFile][3],nSize)
                    Next nFile
                EndIF
                #ifdef __HARBOUR__
                    bSPTables:={|x AS ARRAY,y AS ARRAY|x[2]<y[2]}
                #else /*__ADVPL__*/
                    bSPTables:={|x,y|x[2]<y[2]}
                #endif /*__HARBOUR__*/
                aSort(s_aPTables,NIL,NIL,bSPTables)
                self:cFPrime:=s_aPTables[1][2]
                self:cLPrime:=s_aPTables[nFiles][3]
            EndIF

            s_nPTables:=nFiles

        Else

            nFiles:=s_nPTables
            IF nFiles>0
                self:cFPrime:=s_aPTables[1][2]
                self:cLPrime:=s_aPTables[nFiles][3]
                self:nSize:=Len(self:cLPrime)
            EndIF

        EndIF

        self:cPrime:=""

        IF self:cFPrime==NIL
            self:cFPrime:=""
        EndIF

        IF self:cLPrime==NIL
            self:cLPrime:=""
        EndIF

        IF self:nSize==NIL
            self:nSize:=Len(self:cLPrime)
        EndIF

        Return(self)
/*Method New*/

//--------------------------------------------------------------------------------------------------------
    /*
        Method:ClassName
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:ClassName
        Sintaxe:tPrime():ClassName() -> cClassName
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method ClassName() CLASS tPrime
#else /*__ADVPL__*/
    Method ClassName() CLASS tPrime
#endif /*__HARBOUR__*/
    Return("TPRIME")
/*Method ClassName*/

//--------------------------------------------------------------------------------------------------------
    /*
        Method:IsPrime
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Verifica se o Numero passado por Parametro consta nas Tabelas de Numeros Primo
        Sintaxe:tPrime():IsPrime(cN,lForce) -> lPrime
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method IsPrime(cN AS CHARACTER,lForce AS LOGICAL) CLASS tPrime
#else /*__ADVPL__*/
    Method IsPrime(cN,lForce) CLASS tPrime
#endif /*__HARBOUR__*/

        Local aLine     AS ARRAY

        Local bSPTables AS BLOCK
        Local bSIPLRead AS BLOCK
        Local bLineAddN AS BLOCK
        Local bLineFeqN AS BLOCK
        Local bLineFgtN AS BLOCK

        Local cLine     AS CHARACTER

        Local lPrime    AS LOGICAL

        Local nPrime    AS NUMERIC
        Local nTable    AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER cN        AS CHARACTER
            PARAMETER lForce    AS LOGICAL
        #endif /*__ADVPL__*/

        BEGIN SEQUENCE

            IF Empty(s_aPTables)
                BREAK
            EndIF

            DEFAULT cN:=self:cPrime
            cN:=PadL(cN,self:nSize)

            #ifdef __HARBOUR__
                bSPTables:={|x AS ARRAY|cN>=x[2].and.cN<=x[3]}
            #else /*__ADVPL__*/
                bSPTables:={|x|cN>=x[2].and.cN<=x[3]}
            #endif /*__HARBOUR__*/

            nTable:=aScan(s_aPTables,bSPTables)

            IF nTable==0
                BREAK
            ENDIF

            DEFAULT s_oIPfRead:=tfRead():New()
            DEFAULT s_aIPLRead:=Array(0)

            DEFAULT lForce:=.F.
            IF (lForce)
                Self:IsPReset()
            EndIF

            IF .NOT.(s_nIPfRead==nTable)
                Self:IsPReset()
                s_nIPfRead:=nTable
                s_oIPfRead:Close(.T.)
                s_oIPfRead:Open(s_aPTables[nTable][1])
                s_oIPfRead:nReadSize:=MIN(65535,(s_aPTables[nTable][4]+2)*64)
                s_oIPfRead:ReadLine()
            EndIF

            #ifdef __HARBOUR__
                bSIPLRead:={|x AS CHARACTER|PadL(x,self:nSize)==cN}
            #else /*__ADVPL__*/
                bSIPLRead:={|x AS CHARACTER|PadL(x,self:nSize)==cN}
            #endif /*__HARBOUR__*/

            nPrime:=aScan(s_aIPLRead,bSIPLRead)
            IF (lPrime:=nPrime>0)
                BREAK
            EndIF

            #ifdef __HARBOUR__
                bLineFeqN:={|x AS CHARACTER|PadL(x,self:nSize)==cN}
                bLineFgtN:={|x AS CHARACTER|PadL(x,self:nSize)>cN}
            #else /*__ADVPL__*/
                bLineFeqN:={|x|PadL(x,self:nSize)==cN}
                bLineFgtN:={|x|PadL(x,self:nSize)>cN}
            #endif /*__HARBOUR__*/

            While s_oIPfRead:MoreToRead()
                cLine:=s_oIPfRead:ReadLine()
                IF Empty(cLine)
                    Loop
                EndIF
                While "  "$cLine
                    cLine:=StrTran(cLine,"  "," ")
                End While
                While SubStr(cLine,1,1)==" "
                    cLine:=SubStr(cLine,2)
                End While
                While SubStr(cLine,-1)==" "
                    cLine:=SubStr(cLine,1,Len(cLine)-1)
                End While
                #ifdef __HARBOUR__
                     aLine:=hb_ATokens(cLine," ")
                #else /*__ADVPL__*/
                    aLine:=StrTokArr2(cLine," ")
                #endif
                nPrime:=aScan(aLine,bLineFeqN)
                IF (lPrime:=nPrime>0)
                    EXIT
                EndIF
                IF aScan(aLine,bLineFgtN)>0
                    EXIT
                EndIF
            End While

            aSize(s_aIPLRead,0)

            IF .NOT.(Empty(aLine))
                #ifdef __HARBOUR__
                    bLineAddN:={|x AS CHARACTER|aAdd(s_aIPLRead,x)}
                #else /*__ADVPL__*/
                    bLineAddN:={|x|aAdd(s_aIPLRead,x)}
                #endif /*__HARBOUR__*/
                aEval(aLine,bLineAddN)
                aSize(aLine,0)
            EndIF

        END SEQUENCE

        DEFAULT lPrime:=.F.

        Return(lPrime)
/*Method IsPrime*/

//-------------------------------------------------------------------------------------------------------
    /*
        Method:IsPReset
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Reset IsPrime Cache
        Sintaxe:tPrime():IsPReset() -> .T.
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method IsPReset() CLASS tPrime
#else /*__ADVPL__*/
    Method IsPReset() CLASS tPrime
#endif /*__HARBOUR__*/
        s_nIPfRead:=NIL
        IF .NOT.(s_aIPLRead==NIL)
            aSize(s_aIPLRead,0)
        EndIF
        Return(.T.)
/*Method IsPReset*/

//--------------------------------------------------------------------------------------------------------
    /*
        Method:NextPrime
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Obtem o Proximo Numero da Tabela de Numeros Primos
        Sintaxe:tPrime():NextPrime(cN,lForce) -> lPrime
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method NextPrime(cN AS CHARACTER,lForce AS LOGICAL) CLASS tPrime
#else /*__ADVPL__*/
    Method NextPrime(cN,lForce) CLASS tPrime
#endif /*__HARBOUR__*/

        Local aLine     AS ARRAY

        Local bSPTables AS BLOCK
        Local bSNPLRead AS BLOCK
        lOCAL bLinefgtN AS BLOCK

        Local cLine     AS CHARACTER
        Local cPrime    AS CHARACTER

        Local lPrime    AS LOGICAL

        Local nPrime    AS NUMERIC
        Local nTable    AS NUMERIC

        #ifdef __ADVPL__
            PARAMETER cN        AS CHARACTER
            PARAMETER lForce    AS LOGICAL
        #endif /*__ADVPL__*/

        BEGIN SEQUENCE

            IF Empty(s_aPTables)
                BREAK
            EndIF

            DEFAULT cN:=self:cPrime
            cN:=PadL(cN,self:nSize)
            self:cPrime:=cN

            IF Empty(cN)
                nTable:=1
            Else
                #ifdef __HARBOUR__
                    bSPTables:={|x AS ARRAY|cN>=x[2].and.cN<=x[3]}
                #else /*__ADVPL__*/
                    bSPTables:={|x|cN>=x[2].and.cN<=x[3]}
                #endif  /*__HARBOUR__*/
                nTable:=aScan(s_aPTables,bSPTables)
            EndIF

            IF nTable==0
                BREAK
            ENDIF

            DEFAULT s_oNPfRead:=tfRead():New()
            DEFAULT s_aNPLRead:=Array(0)

            DEFAULT lForce:=.F.
            IF (lForce)
                Self:NextPReset()
            EndIF

            IF .NOT.(s_nNPfRead==nTable)
                Self:NextPReset()
                s_nNPfRead:=nTable
                s_oNPfRead:Close(.T.)
                s_oNPfRead:Open(s_aPTables[nTable][1])
                s_oNPfRead:nReadSize:=MIN(65535,(s_aPTables[nTable][4]+2)*64)
                s_oNPfRead:ReadLine()
            EndIF

            #ifdef __HARBOUR__
                bSNPLRead:={|x AS CHARACTER|(cPrime:=PadL(x,self:nSize))>cN}
                bLinefgtN:=bSNPLRead
            #else /*__ADVPL__*/
                bSNPLRead:={|x|(cPrime:=PadL(x,self:nSize))>cN}
                bLinefgtN:=bSNPLRead
            #endif /*__HARBOUR__*/

            nPrime:=aScan(s_aNPLRead,bSNPLRead)
            IF (lPrime:=nPrime>0)
                self:cPrime:=cPrime
                BREAK
            EndIF

            While s_oNPfRead:MoreToRead()
                cLine:=s_oNPfRead:ReadLine()
                IF Empty(cLine)
                    Loop
                EndIF
                While "  "$cLine
                    cLine:=StrTran(cLine,"  "," ")
                End While
                While SubStr(cLine,1,1)==" "
                    cLine:=SubStr(cLine,2)
                End While
                While SubStr(cLine,-1)==" "
                    cLine:=SubStr(cLine,1,Len(cLine)-1)
                End While
                #ifdef __HARBOUR__
                     aLine:=hb_ATokens(cLine," ")
                #else /*__ADVPL__*/
                    aLine:=StrTokArr2(cLine," ")
                #endif
                nPrime:=aScan(aLine,bLinefgtN)
                IF (lPrime:=nPrime>0)
                    EXIT
                EndIF
            End While

            aSize(s_aNPLRead,0)

            IF .NOT.(Empty(aLine))
                aEval(aLine,{|x|aAdd(s_aNPLRead,x)})
                aSize(aLine,0)
            EndIF

            DEFAULT cPrime:=""
            self:cPrime:=cPrime

        END SEQUENCE

        DEFAULT lPrime:=.F.

        Return(lPrime)
/*Method NextPrime*/

//--------------------------------------------------------------------------------------------------------
    /*
        Method:NextPReset
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Reset NextPrime Cache
        Sintaxe:tPrime():NextPReset() -> .T.
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method NextPReset() CLASS tPrime
#else /*__ADVPL__*/
    Method NextPReset() CLASS tPrime
#endif /*__HARBOUR__*/
        s_nNPfRead:=0
        IF .NOT.(s_aNPLRead==NIL)
            aSize(s_aNPLRead,0)
        EndIF
        Return(.T.)
/*Method NextPReset*/

//--------------------------------------------------------------------------------------------------------
    /*
        Method:ResetAll
        Autor:Marinaldo de Jesus [ http://www.blacktdn.com.br ]
        Data:16/03/2013
        Descricao:Reset All Cache
        Sintaxe:tPrime():ResetAll() -> .T.
    */
//--------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
    Method ResetAll() CLASS tPrime
#else /*__ADVPL__*/
    Method ResetAll() CLASS tPrime
#endif /*__HARBOUR__*/
        s_nPTables:=0
        IF .NOT.(s_aPTables==NIL)
            aSize(s_aPTables,0)
        EndIF
        Self:IsPReset()
        Self:NextPReset()
        Return(.T.)
/*Method ResetAll*/
