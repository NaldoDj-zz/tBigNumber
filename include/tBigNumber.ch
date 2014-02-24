#ifndef _TBigNumber_CH

    #define _TBigNumber_CH

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

    #ifdef PROTHEUS
        #define __PROTHEUS__        
        #include "pt_tBigNumber.ch"
    #ELSE
        #ifdef __HARBOUR__
            #include "hb_tBigNumber.ch"
        #endif
    #endif

    #include "set.ch"
    #include "fileio.ch"

    #define MAX_DECIMAL_PRECISION    999999999999999 //999.999.999.999.999

    /* by default create ST version */
    #ifndef __ST__
        #ifndef __MT__
          #define __ST__
       #endif
    #endif

    #ifndef SYMBOL_UNUSED
        #define SYMBOL_UNUSED( symbol ) ( symbol := ( symbol ) )
    #endif

#endif