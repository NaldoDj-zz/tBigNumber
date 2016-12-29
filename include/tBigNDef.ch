#ifndef _hb_TBigNDef_CH

    #define _hb_TBigNDef_CH

    #ifdef TOTVS
        #ifndef PROTHEUS
            #define PROTHEUS
        #endif
    #endif    
   
    #ifdef PROTHEUS
        #ifndef __ADVPL__
            #define __ADVPL__
            //--------------------------------------------------------------------------------------------------------
            //TODO: Begin -> Remover #xcommand e xtranslate abaixo quando Tipagem 100% OK
            //--------------------------------------------------------------------------------------------------------
                #xtranslate PARAMTYPE <nParam> VAR <xVar> AS <xType,...> =>
                #xtranslate PARAMETER <xVar> AS <xType> =>
            //--------------------------------------------------------------------------------------------------------
                #xtranslate local    <xVar> as <xType>    => local    <xVar>
                #xtranslate static   <xVar> as <xType>    => static   <xVar>
                #xtranslate public   <xVar> as <xType>    => public   <xVar>
                #xtranslate private  <xVar> as <xType>    => private  <xVar>
            //--------------------------------------------------------------------------------------------------------
                #xtranslate AS <\xType\> =>
            //--------------------------------------------------------------------------------------------------------
            // #xtranslate function <xFun> as <xType>    => function <xFun>
            //--------------------------------------------------------------------------------------------------------
            //TODO: End   -> Remover #xcommand e xtranslate acima  quando Tipagem 100% OK
            //--------------------------------------------------------------------------------------------------------
        #endif
        #ifndef __PTCOMPAT__
            #define __PTCOMPAT__
        #endif
        #xtranslate hb_ntos( <n> ) => LTrim( Str( <n> ) )
        #xtranslate hb_bLen([<prm,...>])        => Len([<prm>])
        #xtranslate tBIGNaLen([<prm,...>])      => Len([<prm>])
        #xtranslate hb_mutexCreate()            => ThreadID()
        #xtranslate hb_mutexLock([<prm,...>])   => AllWaysTrue([<prm>])
        #xtranslate hb_mutexUnLock([<prm,...>]) => AllWaysTrue([<prm>])
        #xtranslate method <methodName> SETGET  => method <methodName>
    #else
        #ifndef __HARBOUR__
            #define __HARBOUR__
        #endif
        /* by default create __MT__ version */
        #ifndef __MT__
            #define __MT__
        #endif
        #include "hbserial.ch"
        #xtranslate Left([<prm,...>])    => hb_bLeft([<prm>])
        #xtranslate Right([<prm,...>])   => hb_bRight([<prm>])
        #xtranslate SubStr([<prm,...>])  => hb_bSubStr([<prm>])
        #xtranslate AT([<prm,...>])      => hb_bAT([<prm>])
    #endif

    #ifndef SYMBOL_UNUSED
        #define SYMBOL_UNUSED( symbol ) ( symbol := ( symbol ) )
    #endif

    #define OPERATOR_ADD            { '+' , 'add' }
    #define OPERATOR_SUBTRACT       { '-' , 'sub' }
    #define OPERATOR_MULTIPLY       { '*' , 'x' , 'mult' }
    #define OPERATOR_DIVIDE         { '/' , ':' , 'div'  }
    #define OPERATOR_POW            { '^' , '**' , 'xx' , 'pow' }
    #define OPERATOR_MOD            { '%' , 'mod' }
    #define OPERATOR_EXP            { 'exp' }
    #define OPERATOR_SQRT           { 'sqrt' }
    #define OPERATOR_ROOT           { 'root' }

    #define OPERATORS               {;
                                        OPERATOR_ADD,      ;
                                        OPERATOR_SUBTRACT, ;
                                        OPERATOR_MULTIPLY, ;
                                        OPERATOR_DIVIDE,   ;
                                        OPERATOR_POW,      ;
                                        OPERATOR_MOD,      ;
                                        OPERATOR_EXP,      ;
                                        OPERATOR_SQRT,     ;
                                        OPERATOR_ROOT,     ;
                                    }
    #ifdef __HARBOUR__
        #xcommand DEFAULT =>
        //-------------------------------------------------------------------------------------
        /* Default parameters management */
        #xtranslate DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        iif( <uVar1> == NIL , hb_Default(@<uVar1>,<uVal1>) , );
                        [; iif( <uVarN> == NIL , hb_Default(@<uVarN>,<uValN>) , ) ]
    #endif

#endif /*_hb_TBigNDef_CH*/
