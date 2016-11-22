#ifndef _hb_TBigNDef_CH

    #define _hb_TBigNDef_CH

    #ifdef PROTHEUS
        #ifndef __PROTHEUS__
            #define __PROTHEUS__
            #ifndef __PTCOMPAT__
                #define __PTCOMPAT__
            #endif
        #endif
    #else
        #ifndef __HARBOUR__
            #define __HARBOUR__
        #endif
        /* by default create __MT__ version */
        #ifndef __MT__
            #define __MT__
        #endif
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
