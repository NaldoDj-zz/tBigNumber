#ifdef __HARBOUR__

    /* Keeping it tidy */
    #pragma -w3
    #pragma -es2
    /* Optimizations */
    #pragma -km+
    #pragma -ko+
    /* Force HB_MT */
    #require "hbvmmt"
    request HB_MT

    /*
        About:C(++) tBigNumber functions
        Author:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Date:04/02/2013
        Description:tBig'C(++)'Number Optimizations (?) functions
    */

    #pragma BEGINDUMP

        #include <string>
        #include <limits>
        #include <cstring>
        #include <sstream>

        #include <stdio.h>
        #include <string.h>
        #include <hbapi.h>
        #include <hbdefs.h>
        #include <hbstack.h>
        #include <hbapiitm.h>

        #include <hbmather.h>
        #include <hbapierr.h>

        #include <..\include\c\try_throw_catch.h>

        #ifdef _MSC_VER
            #define _CRT_SECURE_NO_WARNINGS
            #pragma warning(disable:4996)
        #endif

        #define DO_PAD_PADLEFT   0
        #define DO_PAD_PADRIGHT  1

        #define DO_REMOVE_REMALL    0
        #define DO_REMOVE_REMLEFT   1
        #define DO_REMOVE_REMRIGHT  2

        typedef struct{
            char * cMultM;
            char * cMultP;
        } stBIGNeMult,* ptBIGNeMult;

        typedef struct{
            char * cDivQ;
            char * cDivR;
        } stBIGNeDiv,* ptBIGNeDiv;

        static char * do_pad( int iSwitch, const char * pcString, HB_SIZE nRetLen , const char cFill );
        static char * tBIGNPadL(const char * szItem,HB_SIZE nLen,const char * szPad);
        static char * tBIGNPadR(const char * szItem,HB_SIZE nLen,const char * szPad);
        static char * do_remove( int iSwitch, const char * pcString, const HB_SIZE sStrLen, const char * cSearch );
        /*static char * remAll( const char * pcString, const HB_SIZE sStrLen, const char * cSearch );*/
        static char * remLeft( const char * pcString, const HB_SIZE sStrLen, const char * cSearch );
        /*static char * remRight( const char * pcString, const HB_SIZE sStrLen, const char * cSearch );*/
        static char * tBIGNReverse(const char * szF,const HB_SIZE s);
        static char * tBIGNAdd(const char * a,const char * b,HB_MAXINT n,const HB_SIZE y,const HB_MAXINT nB);
        static char * tBigNiADD(char * sN, HB_MAXINT a,const HB_MAXINT isN,const HB_MAXINT nB);
        static char * tBIGNSub(const char * a,const char * b,HB_MAXINT n,const HB_SIZE y,const HB_MAXINT nB);
        static char * tBigNiSUB(char * sN,const HB_MAXINT s,const HB_MAXINT isN,const HB_MAXINT nB);
        static char * tBIGNMult(const char * pValue1,const char * pValue2,HB_SIZE n,const HB_SIZE y,const HB_MAXINT nB);
        static char * tBigNPower(const char * szBas,const char * szExp,HB_SIZE * p,HB_SIZE y,const HB_MAXINT nB);
        static void tBIGNegMult(const char * pN,const char * pD,HB_MAXINT n,const HB_MAXINT nB,ptBIGNeMult pegMult);
        static char * tBigN2Mult(char * sN,const HB_MAXINT isN,const HB_MAXINT nB);
        static char * tBigNiMult(char * sN,const HB_MAXINT m,const HB_SIZE isN,const HB_MAXINT nB);
        static void tBIGNegDiv(const char * pN,const char * pD,HB_MAXINT n,const HB_MAXINT nB,ptBIGNeDiv pegDiv);
        static void tBIGNecDiv(const char * pA,const char * pB,HB_MAXINT ipN,const HB_MAXINT nB,ptBIGNeDiv pecDiv);
        static HB_MAXINT tBIGNGCD(HB_MAXINT u,HB_MAXINT v);
        static HB_MAXINT tBIGNLCM(HB_MAXINT x,HB_MAXINT y);
        static HB_MAXINT tBIGNFI(HB_MAXINT n);

        template <typename tTO_STRING>
        static std::string to_string(tTO_STRING const& value){
            std::stringstream sstr;
            sstr.precision(std::numeric_limits<long double>::digits10+100);
            sstr<<std::fixed<<value;
            return sstr.str();
        }

        static char * do_pad( int iSwitch, const char * pcString, HB_SIZE nRetLen , const char cFill )
        {

              char * pcRet, * pc;

              HB_SIZE sStrLen = ( HB_SIZE ) strlen( pcString );
              HB_SIZE sRetLen = ( HB_SIZE ) nRetLen;

              pcRet = ( char * ) hb_xgrab( ( HB_SIZE )sRetLen + 1 );

              if( iSwitch == DO_PAD_PADLEFT )
              {
                 if( sRetLen > sStrLen )
                 {
                    /* fill with cFill */
                    for( pc = pcRet; pc < pcRet + ( sRetLen - sStrLen ); pc++ )
                       *pc = cFill;
                    hb_xmemcpy( pcRet + ( sRetLen - sStrLen ), pcString, sStrLen );
                 }
                 else
                    hb_xmemcpy( pcRet, pcString + ( sStrLen - sRetLen ), sRetLen );
              }
              else
              {
                 hb_xmemcpy( pcRet, pcString, ( sRetLen < sStrLen ? sRetLen : sStrLen ) );
                 if( sRetLen > sStrLen )
                 {
                    /* fill with cFill */
                    for( pc = pcRet + sStrLen; pc < pcRet + sRetLen; pc++ )
                       *pc = cFill;
                 }
              }
              pcRet[( sRetLen > sStrLen ? sRetLen : sStrLen )]=HB_CHAR_EOS;
              return pcRet;
        }

        static char * tBIGNPadL(const char * szItem,HB_SIZE nLen, const char * szPad){
            HB_TRACE(HB_TR_DEBUG,("tBIGNPadL(%s,%" HB_PFS "u,%s)",szItem,nLen,szPad));
            return do_pad( DO_PAD_PADLEFT , szItem, nLen , *szPad );
        }

        HB_FUNC_STATIC( TBIGNPADL ){
            const char * szItem=hb_parc(1);
            HB_SIZE nLen=(HB_SIZE)hb_parns(2);
            const char * szPad=hb_parc(3);
            char * szRet=tBIGNPadL(szItem,nLen,szPad);
            #if 0
                hb_retclen(szRet,( HB_SIZE )nLen);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(szRet,( HB_SIZE )nLen);
            #endif
        }

        static char * tBIGNPadR(const char * szItem,HB_SIZE nLen, const char * szPad){
            HB_TRACE(HB_TR_DEBUG,("tBIGNPadR(%s,%" HB_PFS "u,%s)",szItem,nLen,szPad));
            return do_pad( DO_PAD_PADRIGHT , szItem, nLen , *szPad );
        }

        HB_FUNC_STATIC( TBIGNPADR ){
            const char * szItem=hb_parc(1);
            HB_SIZE nLen=(HB_SIZE)hb_parns(2);
            const char * szPad=hb_parc(3);
            char * szRet=tBIGNPadR(szItem,nLen,szPad);
            #if 0
                hb_retclen(szRet,( HB_SIZE )nLen);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(szRet,( HB_SIZE )nLen);
            #endif
        }


        static char * do_remove( int iSwitch, const char * pcString, const HB_SIZE sStrLen, const char * cSearch )
        {

              const char * pcTmp;
              const char * pc;
              HB_SIZE sRetLen;

              sRetLen = sStrLen;
              pcTmp = pcString;

              if( iSwitch != DO_REMOVE_REMRIGHT )
              {
                 while( ( *pcTmp == *cSearch ) && ( pcTmp < pcString + sStrLen ) )
                 {
                    pcTmp++;
                    sRetLen--;
                 }
              }

              if( iSwitch != DO_REMOVE_REMLEFT )
              {
                 pc = pcString + sStrLen - 1;
                 while( ( *pc == *cSearch ) && ( pc >= pcTmp ) )
                 {
                    pc--;
                    sRetLen--;
                 }
              }

              if( sRetLen == 0 )
                 return tBIGNPadL("0",1,"0");
              else
              {
                  char * pcRet=(char*)hb_xgrab(( HB_SIZE )sRetLen+1);
                  hb_xmemcpy(pcRet,pcTmp,sRetLen);
                  pcRet[sRetLen]=HB_CHAR_EOS;
                  return pcRet;
              }
        }


        /*static char * remAll( const char * pcString, const HB_SIZE sStrLen, const char * cSearch )
        {
           return do_remove( DO_REMOVE_REMALL, pcString, sStrLen, cSearch );
        }*/

        static char * remLeft( const char * pcString, const HB_SIZE sStrLen, const char * cSearch )
        {
           return do_remove( DO_REMOVE_REMLEFT, pcString, sStrLen, cSearch );
        }

        /*static char * remRight( const char * pcString, const HB_SIZE sStrLen, const char * cSearch )
        {
           return do_remove( DO_REMOVE_REMRIGHT, pcString, sStrLen, cSearch );
        }*/

        static char * tBIGNReverse(const char * szF,const HB_SIZE s){
            HB_TRACE(HB_TR_DEBUG,("tBIGNReverse(%s,%" HB_PFS "u)",szF,s));
            HB_SIZE f=s;
            HB_SIZE t=0;
            char * szT=(char*)hb_xgrab(( HB_SIZE )s+1);
            for(;f;){
                szT[t++]=szF[--f];
            }
            szT[t]=HB_CHAR_EOS;
            return szT;
        }

        HB_FUNC_STATIC( TBIGNREVERSE ){
            const char * szF=hb_parc(1);
            const HB_SIZE s=(HB_SIZE)hb_parnint(2);
            char * szR=tBIGNReverse(szF,s);
            #if 0
                hb_retclen(szR,( HB_SIZE )s);
                hb_xfree(szR);
            #else
                hb_retclen_buffer(szR,( HB_SIZE )s);
            #endif
        }

        static char * tBIGNAdd(const char * a,const char * b,HB_MAXINT n,const HB_SIZE y,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBIGNAdd(%s,%s,%" PFHL "d,%" HB_PFS "u,%" PFHL "d)",a,b,n,y,nB));
            char * c=(char*)hb_xgrab(( HB_SIZE )y+1);
            HB_SIZE k=y-1;
            HB_MAXINT v=0;
            HB_MAXINT v1;
            c[y]=HB_CHAR_EOS;
            while (--n>=0){
                v+=(*(&a[n])-'0')+(*(&b[n])-'0');
                if ( v>=nB ){
                    v-=nB;
                    v1=1;
                }
                else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                c[k]="0123456789"[v];
                /* TODO: Rever este conceito */
                c[k-1]="0123456789"[v1];
                v=v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNADD ){
            const char * a=hb_parc(1);
            const char * b=hb_parc(2);
            HB_MAXINT n=(HB_MAXINT)hb_parnint(3);
            const HB_SIZE y=(HB_SIZE)(hb_parnint(4)+1);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(5);
            char * szRet=tBIGNAdd(a,b,n,y,nB);
            #if 0
                hb_retclen(szRet,( HB_SIZE )y);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(szRet,( HB_SIZE )y);
            #endif
        }

        static char * tBigNiADD(char * sN, HB_MAXINT a,const HB_MAXINT isN,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBigNiADD(%s%" PFHL "d,%" PFHL "d,%" PFHL "d)",sN,a,isN,nB));
            HB_BOOL bAdd=HB_TRUE;
            HB_MAXINT v;
            HB_MAXINT v1=0;
            HB_MAXINT i=isN;
            sN[i]=HB_CHAR_EOS;
            while(--i>=0){
                v=(*(&sN[i])-'0');
                if (bAdd){
                    v+=a;
                    bAdd=HB_FALSE;
                }
                v+=v1;
                if ( v>=nB ){
                    v-=nB;
                    v1=1;
                }
                else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                sN[i]="0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }

        HB_FUNC_STATIC( TBIGNIADD ){
            HB_MAXINT n=(HB_MAXINT)(hb_parclen(1)+1);
            char * szRet=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            HB_MAXINT a=(HB_MAXINT)hb_parnint(2);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(3);
            #if 0
                hb_retclen(tBigNiADD(szRet,a,n,nB),( HB_SIZE )n);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(tBigNiADD(szRet,a,n,nB),( HB_SIZE )n);
            #endif
        }

        HB_FUNC_STATIC( TBIGNLADD ){
            hb_retnint((HB_MAXINT)hb_parnint(1)+(HB_MAXINT)hb_parnint(2));
        }

        static char * tBIGNSub(const char * a,const char * b,HB_MAXINT n,const HB_SIZE y,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBIGNSub(%s,%s,%" PFHL "d,%" HB_PFS "u,%" PFHL "d)",a,b,n,y,nB));
            char * c=(char*)hb_xgrab(( HB_SIZE )y+1);
            HB_SIZE k=y-1;
            HB_MAXINT v=0;
            HB_MAXINT v1;
            c[y]=HB_CHAR_EOS;
            while (--n>=0){
                v+=(*(&a[n])-'0')-(*(&b[n])-'0');
                if ( v<0 ){
                    v+=nB;
                    v1=-1;
                }
                else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                c[k]="0123456789"[v];
                /* TODO: Rever este conceito */
                c[k-1]="0123456789"[v1];
                v=v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNSUB ){
            const char * a=hb_parc(1);
            const char * b=hb_parc(2);
            HB_MAXINT n=(HB_MAXINT)hb_parnint(3);
            const HB_SIZE y=(HB_SIZE)n;
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(4);
            char * szRet=tBIGNSub(a,b,n,y,nB);
            #if 0
                hb_retclen_buffer(szRet,( HB_SIZE )y);
            #else
                hb_retclen(szRet,( HB_SIZE )y);
                hb_xfree(szRet);
            #endif
        }

        static char * tBigNiSUB(char * sN,const HB_MAXINT s,const HB_MAXINT isN,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBigNiSUB(%s,%" PFHL "d,%" PFHL "d,%" PFHL "d)",sN,s,isN,nB));
            HB_BOOL bSub=HB_TRUE;
            HB_MAXINT v;
            HB_MAXINT v1=0;
            HB_MAXINT i=isN;
            while(--i>=0){
                v=(*(&sN[i])-'0');
                if (bSub){
                    v-=s;
                    bSub=HB_FALSE;
                }
                v+=v1;
                if ( v<0 ){
                    v+=nB;
                    v1=-1;
                }
                else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                sN[i]="0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }

        HB_FUNC_STATIC( TBIGNISUB ){
            HB_MAXINT n=(HB_MAXINT)(hb_parclen(1));
            char * szRet=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            HB_MAXINT s=(HB_MAXINT)hb_parnint(2);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(3);
            #if 0
                hb_retclen(tBigNiSUB(szRet,s,n,nB),( HB_SIZE )n);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(tBigNiSUB(szRet,s,n,nB),( HB_SIZE )n);
            #endif
        }

        HB_FUNC_STATIC( TBIGNLSUB ){
            hb_retnint((HB_MAXINT)hb_parnint(1)-(HB_MAXINT)hb_parnint(2));
        }

        static char * tBIGNMult(const char * pValue1,const char * pValue2,HB_SIZE n,const HB_SIZE y,const HB_MAXINT nB){

            HB_TRACE(HB_TR_DEBUG,("tBIGNMult(%s,%s,%" HB_PFS "u,%" HB_PFS "u,%" PFHL "d)",pValue1,pValue2,n,y,nB));

            char * a=tBIGNReverse(pValue1,n);
            char * b=tBIGNReverse(pValue2,n);
            char * c=tBIGNPadL("0",y,"0");

            HB_SIZE i=0;
            HB_SIZE k=0;
            HB_SIZE l=1;
            HB_SIZE s;
            HB_SIZE j;

            HB_MAXINT v=0;
            HB_MAXINT v1;

            n-=1;

            while (i<=n){
                s=0;
                j=i;
                while (s<=i){
                    v+=(*(&a[s++])-'0')*(*(&b[j--])-'0');
                }
                if (v>=nB){
                    v1=v/nB;
                    v%=nB;
                }else{
                    v1=0;
                };
                /* TODO: Rever este conceito */
                c[k]="0123456789"[v];
                /* TODO: Rever este conceito */
                c[k+1]="0123456789"[v1];
                v=v1;
                k++;
                i++;
            }

            while (l<=n){
                s=n;
                j=l;
                while (s>=l){
                    v+=(*(&a[s--])-'0')*(*(&b[j++])-'0');
                }
                if (v>=nB){
                    v1=v/nB;
                    v%=nB;
                }else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                c[k]="0123456789"[v];
                /* TODO: Rever este conceito */
                c[k+1]="0123456789"[v1];
                v=v1;
                if (++k>=y){
                    break;
                }
                l++;
            }

            const char *tmp=tBIGNReverse(c,y);

            hb_xfree(a);
            hb_xfree(b);
            hb_xfree(c);

            char * r=remLeft(tmp,y,"0");

            return r;
        }

        HB_FUNC_STATIC( TBIGNMULT ){
            const char * pValue1=hb_parc(1);
            const char * pValue2=hb_parc(2);
            HB_SIZE n=(HB_SIZE)hb_parnint(3);
            HB_SIZE y=(HB_SIZE)(hb_parnint(4)*2);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(5);
            char * szRet=tBIGNMult(pValue1,pValue2,n,y,nB);
            #if 0               
                n=( HB_SIZE )strlen(szRet);
                hb_retclen_buffer(szRet,( HB_SIZE )n);
            #else
                #if 0
                    n=( HB_SIZE )strlen(szRet);
                    hb_retclen(szRet,( HB_SIZE )n);
                    hb_xfree(szRet);
                #else
                    #if 0
                        hb_retc_buffer(szRet);
                    #else
                        hb_retc(szRet);
                        hb_xfree(szRet);
                    #endif
                #endif
            #endif
        }
        
        static char * tBigNPower(const char * szBas,const char * szExp,HB_SIZE * p,HB_SIZE y,const HB_MAXINT nB){

            HB_SIZE n=*p;
            HB_SIZE k=n;
            
            HB_TRACE(HB_TR_DEBUG,("tBigNPower(%s,%s,%" HB_PFS "u,%" HB_PFS "u,%" PFHL "d)",szBas,szExp,n,y,nB));
            
            char * szInd=hb_strdup(szExp);
            char * szRet=hb_strdup(szBas);
            char * szPow=hb_strdup(szBas);
            char * szOne=tBIGNPadL("1",n,"0");
            
            int iCmp=hb_strnicmp(szInd,szOne,n);            
            
            while (iCmp&&iCmp>0)
            {
                    HB_SIZE t=n;
                    const char * pow=tBIGNMult(szRet,szPow,n,y,nB);
                    n=(HB_SIZE)strlen(pow);
                    if (!(n==t))
                    {
                        hb_xfree(szRet);
                        szRet=tBIGNPadL(pow,n,"0");
                        hb_xfree(szPow);
                        szPow=tBIGNPadL(szBas,n,"0");
                    }
                    else
                    {
                       hb_xmemcpy(szRet,pow,n);
                    }
                    t=k;
                    const char * tmp=tBigNiSUB(szInd,1,k,nB);
                    szInd=remLeft(tmp,k,"0");
                    k=(HB_SIZE)strlen(szInd);
                    if (!(k==t))
                    {
                        hb_xfree(szOne);
                        szOne=tBIGNPadL("1",k,"0");
                    }
                    iCmp=hb_strnicmp(szInd,szOne,k);
                    if (iCmp<=0){
                        break;
                    }
                    y=(n*2);
            }

            hb_xfree(szPow);
            hb_xfree(szInd);
            hb_xfree(szOne);

            *p=n;
            
        return szRet;
        
        }

        HB_FUNC_STATIC( TBIGNPOWER ){
            const char * szBas=hb_parc(1);
            const char * szExp=hb_parc(2);
            HB_SIZE n=(HB_SIZE)hb_parnint(3);
            HB_SIZE y=(HB_SIZE)(hb_parnint(4)*2);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(5);
            char * szRet=tBigNPower(szBas,szExp,&n,y,nB);
            #if 0               
                hb_retclen_buffer(szRet,n);
            #else
                #if 0
                    hb_retclen(szRet,n);
                    hb_xfree(szRet);
                #else
                    #if 0
                        hb_retc_buffer(szRet);
                    #else
                        hb_retc(szRet);
                        hb_xfree(szRet);
                    #endif
                #endif
            #endif
        }

       static void tBIGNegMult(const char * pN,const char * pD,HB_MAXINT n,const HB_MAXINT nB,ptBIGNeMult pegMult){

            HB_TRACE(HB_TR_DEBUG,("tBIGNegMult(%s,%s,%" PFHL "d,%" PFHL "d,%p)",pN,pD,n,nB,pegMult));

            HB_MAXINT szptBIGNeMult=sizeof(ptBIGNeMult*);
            HB_MAXINT szstBIGNeMult=sizeof(stBIGNeMult);

            ptBIGNeMult *peMTArr=(ptBIGNeMult*)hb_xgrab(( HB_SIZE )szptBIGNeMult);
            ptBIGNeMult pegMultTmp=(ptBIGNeMult)hb_xgrab(( HB_SIZE )szstBIGNeMult);

            char * Tmp=tBIGNPadL("1",( HB_SIZE )n,"0");
            pegMultTmp->cMultM=hb_strdup(Tmp);
            hb_xfree(Tmp);

            pegMultTmp->cMultP=hb_strdup(pD);

            Tmp=tBIGNPadL("0",( HB_SIZE )n,"0");
            pegMult->cMultM=hb_strdup(Tmp);
            pegMult->cMultP=hb_strdup(Tmp);
            hb_xfree(Tmp);

            HB_MAXINT nI=0;

            do {

                peMTArr=(ptBIGNeMult*)hb_xrealloc(peMTArr,(( HB_SIZE )nI+1)*( HB_SIZE )szptBIGNeMult);
                peMTArr[nI]=(ptBIGNeMult)hb_xgrab(( HB_SIZE )szstBIGNeMult);

                peMTArr[nI]->cMultM=hb_strdup(pegMultTmp->cMultM);
                peMTArr[nI]->cMultP=hb_strdup(pegMultTmp->cMultP);

                char * tmp=tBIGNAdd(pegMultTmp->cMultM,pegMultTmp->cMultM,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegMultTmp->cMultM,tmp,( HB_SIZE )n);
                hb_xfree(tmp);

                tmp=tBIGNAdd(pegMultTmp->cMultP,pegMultTmp->cMultP,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegMultTmp->cMultP,tmp,( HB_SIZE )n);
                hb_xfree(tmp);

                if (memcmp(pegMultTmp->cMultM,pN,( HB_SIZE )n)==1){
                    break;
                }

                ++nI;

            } while (HB_TRUE);

            hb_xfree(pegMultTmp->cMultM);
            hb_xfree(pegMultTmp->cMultP);

            HB_MAXINT nF=nI;

            do {

                pegMultTmp->cMultM=tBIGNAdd(pegMult->cMultM,peMTArr[nI]->cMultM,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,( HB_SIZE )n);
                hb_xfree(pegMultTmp->cMultM);

                pegMultTmp->cMultP=tBIGNAdd(pegMult->cMultP,peMTArr[nI]->cMultP,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,( HB_SIZE )n);
                hb_xfree(pegMultTmp->cMultP);

                int iCmp=memcmp(pegMult->cMultM,pN,( HB_SIZE )n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){

                            pegMultTmp->cMultM=tBIGNSub(pegMult->cMultM,peMTArr[nI]->cMultM,n,( HB_SIZE )n,nB);
                            hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,( HB_SIZE )n);
                            hb_xfree(pegMultTmp->cMultM);

                            pegMultTmp->cMultP=tBIGNSub(pegMult->cMultP,peMTArr[nI]->cMultP,n,( HB_SIZE )n,nB);
                            hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,( HB_SIZE )n);
                            hb_xfree(pegMultTmp->cMultP);

                    }
                }

            } while (--nI>=0);

            for(nI=nF;nI>=0;nI--){
                hb_xfree(peMTArr[nI]->cMultM);
                hb_xfree(peMTArr[nI]->cMultP);
                hb_xfree(peMTArr[nI]);
            }
            hb_xfree(peMTArr);
            *peMTArr=NULL;
            peMTArr=NULL;

            hb_xfree(pegMultTmp);

        }

        HB_FUNC_STATIC( TBIGNEGMULT ){

            HB_MAXINT n=(HB_MAXINT)(hb_parnint(3)*2);
            char * pN=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            char * pD=tBIGNPadL(hb_parc(2),( HB_SIZE )n,"0");
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(4);

            ptBIGNeMult pegMult=(ptBIGNeMult)hb_xgrab(( HB_SIZE )sizeof(stBIGNeMult));

            tBIGNegMult(pN,pD,n,nB,pegMult);

            #if 0
                hb_retclen(pegMult->cMultP,( HB_SIZE )n);
            #else
                hb_retclen_buffer(hb_strdup(pegMult->cMultP),( HB_SIZE )n);
            #endif

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegMult->cMultM);
            hb_xfree(pegMult->cMultP);
            hb_xfree(pegMult);
        }

        static char * tBigN2Mult(char * sN,const HB_MAXINT isN,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBigN2Mult(%s,%" PFHL "d,%" PFHL "d)",sN,isN,nB));
            HB_MAXINT v;
            HB_MAXINT v1=0;
            HB_MAXINT i=isN;
            while(--i>=0){
                v=(*(&sN[i])-'0');
                v<<=1;
                v+=v1;
                if (v>=nB){
                    v1=v/nB;
                    v%=nB;
                }else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                sN[i]="0123456789"[v];
            }
            return sN;
        }

        HB_FUNC_STATIC( TBIGN2MULT ){
            HB_MAXINT n=(HB_MAXINT)(hb_parclen(1)+1);
            char * szRet=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(2);
            #if 0
                hb_retclen(tBigN2Mult(szRet,n,nB),( HB_SIZE )n);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(tBigN2Mult(szRet,n,nB),( HB_SIZE )n);
            #endif
        }

        static char * tBigNiMult(char * sN,const HB_MAXINT m,const HB_SIZE isN,const HB_MAXINT nB){
            HB_TRACE(HB_TR_DEBUG,("tBigNiMult(%s,%" PFHL "d,%" HB_PFS "u,%" PFHL "d)",sN,m,isN,nB));
            HB_MAXINT v;
            HB_MAXINT v1=0;
            HB_MAXINT i=isN;
            sN[i]=HB_CHAR_EOS;
            while(--i>=0){
                v=(*(&sN[i])-'0');
                v*=m;
                v+=v1;
                if (v>=nB){
                    v1=v/nB;
                    v%=nB;
                }else{
                    v1=0;
                }
                /* TODO: Rever este conceito */
                sN[i]="0123456789"[v];
            }
            return sN;
        }

        HB_FUNC_STATIC( TBIGNIMULT ){
            HB_SIZE n=(HB_SIZE)(hb_parclen(1)*2);
            char * szRet=tBIGNPadL(hb_parc(1),n,"0");
            HB_MAXINT m=(HB_MAXINT)hb_parnint(2);
            const HB_MAXINT nB=(HB_MAXINT)hb_parnint(3);
            #if 0
                hb_retclen(tBigNiMult(szRet,m,n,nB),( HB_SIZE )n);
                hb_xfree(szRet);
            #else
                hb_retclen_buffer(tBigNiMult(szRet,m,n,nB),( HB_SIZE )n);
            #endif
        }

        HB_FUNC_STATIC( TBIGNLMULT ){
            hb_retnint((HB_MAXINT)hb_parnint(1)*(HB_MAXINT)hb_parnint(2));
        }

        static void tBIGNegDiv(const char * pN,const char * pD,HB_MAXINT n,const HB_MAXINT nB,ptBIGNeDiv pegDiv){

            HB_TRACE(HB_TR_DEBUG,("tBIGNegDiv(%s,%s,%" PFHL "d,%" PFHL "d,%p)",pN,pD,n,nB,pegDiv));

            HB_MAXINT szptBIGNeDiv=sizeof(ptBIGNeDiv*);
            HB_MAXINT szstBIGNeDiv=sizeof(stBIGNeDiv);

            ptBIGNeDiv *peDVArr=(ptBIGNeDiv*)hb_xgrab(( HB_SIZE )szptBIGNeDiv);
            ptBIGNeDiv pegDivTmp=(ptBIGNeDiv)hb_xgrab(( HB_SIZE )szstBIGNeDiv);

            char * Tmp=tBIGNPadL("1",( HB_SIZE )n,"0");
            pegDivTmp->cDivQ=hb_strdup(Tmp);
            hb_xfree(Tmp);

            pegDivTmp->cDivR=hb_strdup(pD);

            HB_MAXINT nI=0;

            do {

                peDVArr=(ptBIGNeDiv*)hb_xrealloc(peDVArr,(( HB_SIZE )nI+1)*( HB_SIZE )szptBIGNeDiv);
                peDVArr[nI]=(ptBIGNeDiv)hb_xgrab(( HB_SIZE )szstBIGNeDiv);

                peDVArr[nI]->cDivQ=hb_strdup(pegDivTmp->cDivQ);
                peDVArr[nI]->cDivR=hb_strdup(pegDivTmp->cDivR);

                char * tmp=tBIGNAdd(pegDivTmp->cDivQ,pegDivTmp->cDivQ,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegDivTmp->cDivQ,tmp,( HB_SIZE )n);
                hb_xfree(tmp);

                tmp=tBIGNAdd(pegDivTmp->cDivR,pegDivTmp->cDivR,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegDivTmp->cDivR,tmp,( HB_SIZE )n);
                hb_xfree(tmp);

                if (memcmp(pegDivTmp->cDivR,pN,( HB_SIZE )n)==1){
                    break;
                }

                ++nI;

            } while (HB_TRUE);

            hb_xfree(pegDivTmp->cDivQ);
            hb_xfree(pegDivTmp->cDivR);

            HB_MAXINT nF=nI;

            Tmp=tBIGNPadL("0",( HB_SIZE )n,"0");
            pegDiv->cDivQ=hb_strdup(Tmp);
            pegDiv->cDivR=hb_strdup(Tmp);
            hb_xfree(Tmp);

            do {

                pegDivTmp->cDivQ=tBIGNAdd(pegDiv->cDivQ,peDVArr[nI]->cDivQ,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,( HB_SIZE )n);
                hb_xfree(pegDivTmp->cDivQ);

                pegDivTmp->cDivR=tBIGNAdd(pegDiv->cDivR,peDVArr[nI]->cDivR,n,( HB_SIZE )n,nB);
                hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,( HB_SIZE )n);
                hb_xfree(pegDivTmp->cDivR);

                int iCmp=memcmp(pegDiv->cDivR,pN,( HB_SIZE )n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){

                            pegDivTmp->cDivQ=tBIGNSub(pegDiv->cDivQ,peDVArr[nI]->cDivQ,n,( HB_SIZE )n,nB);
                            hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,( HB_SIZE )n);
                            hb_xfree(pegDivTmp->cDivQ);

                            pegDivTmp->cDivR=tBIGNSub(pegDiv->cDivR,peDVArr[nI]->cDivR,n,( HB_SIZE )n,nB);
                            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,( HB_SIZE )n);
                            hb_xfree(pegDivTmp->cDivR);

                    }
                }

            } while (--nI>=0);

            for(nI=nF;nI>=0;nI--){
                hb_xfree(peDVArr[nI]->cDivQ);
                hb_xfree(peDVArr[nI]->cDivR);
                hb_xfree(peDVArr[nI]);
            }
            hb_xfree(peDVArr);
            *peDVArr=NULL;
            peDVArr=NULL;

            pegDivTmp->cDivR=tBIGNSub(pN,pegDiv->cDivR,n,( HB_SIZE )n,nB);
            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,( HB_SIZE )n);
            hb_xfree(pegDivTmp->cDivR);
            hb_xfree(pegDivTmp);

        }

        HB_FUNC_STATIC( TBIGNEGDIV ){

            HB_MAXINT n=(HB_MAXINT)(hb_parnint(4)+1);
            char * pN=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            char * pD=tBIGNPadL(hb_parc(2),( HB_SIZE )n,"0");
            ptBIGNeDiv pegDiv=(ptBIGNeDiv)hb_xgrab(( HB_SIZE )sizeof(stBIGNeDiv));
            int iCmp=memcmp(pN,pD,( HB_SIZE )n);

            switch(iCmp){
                case -1:{
                    pegDiv->cDivQ=tBIGNPadL("0",( HB_SIZE )n,"0");
                    pegDiv->cDivR=hb_strdup(pN);
                    break;
                }
                case 0:{
                    pegDiv->cDivQ=tBIGNPadL("1",( HB_SIZE )n,"0");
                    pegDiv->cDivR=tBIGNPadL("0",( HB_SIZE )n,"0");
                    break;
                }
                default:{
                    const HB_MAXINT nB=(HB_MAXINT)hb_parnint(5);
                    tBIGNegDiv(pN,pD,n,nB,pegDiv);
                }
            }

            #if 0
                hb_retclen(pegDiv->cDivQ,( HB_SIZE )n);
                hb_storclen(pegDiv->cDivR,( HB_SIZE )n,3);
            #else
                hb_retclen_buffer(hb_strdup(pegDiv->cDivQ),( HB_SIZE )n);
                hb_storclen_buffer(hb_strdup(pegDiv->cDivR),( HB_SIZE )n,3);
            #endif

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegDiv->cDivR);
            hb_xfree(pegDiv->cDivQ);
            hb_xfree(pegDiv);
        }

        static void tBIGNecDiv(const char * pA,const char * pB,HB_MAXINT ipN,const HB_MAXINT nB,ptBIGNeDiv pecDiv){

            HB_TRACE(HB_TR_DEBUG,("tBIGNecDiv(%s,%s,%" PFHL "d,%" PFHL "d,%p)",pA,pB,ipN,nB,pecDiv));

            HB_MAXINT n=0;

            pecDiv->cDivR=hb_strdup(pA);
            char * aux=hb_strdup(pB);

            HB_MAXINT v1;

            ptBIGNeDiv  pecDivTmp=(ptBIGNeDiv)hb_xgrab(( HB_SIZE )sizeof(stBIGNeDiv));

            HB_MAXINT szHB_MAXINT=sizeof(HB_MAXINT);
            HB_MAXINT snHB_MAXINT=ipN*szHB_MAXINT;

            HB_MAXINT *ipA=(HB_MAXINT*)hb_xgrab(( HB_SIZE )snHB_MAXINT);
            HB_MAXINT *iaux=(HB_MAXINT*)hb_xgrab(( HB_SIZE )snHB_MAXINT);

            HB_MAXINT i=ipN;
            while(--i>=0){
                ipA[i]=(*(&pecDiv->cDivR[i])-'0');
                iaux[i]=(*(&aux[i])-'0');
            }

            while (memcmp(iaux,ipA,( HB_SIZE )ipN)<=0){
                n++;
                v1=0;
                i=ipN;
                while(--i>=0){
                    iaux[i]<<=1;
                    iaux[i]+=v1;
                    if (iaux[i]>=nB){
                        v1=iaux[i]/nB;
                        iaux[i]%=nB;
                    }else{
                        v1=0;
                    }
                }
            }

            hb_xfree(ipA);
            ipA=NULL;

            i=ipN;
            while(--i>=0){
                /* TODO: Rever este conceito */
                aux[i]="0123456789"[iaux[i]];
            }

            hb_xfree(iaux);
            iaux=NULL;

            HB_MAXINT *idivQ=(HB_MAXINT*)calloc(( HB_SIZE )ipN,( HB_SIZE )szHB_MAXINT);
            char * sN2=tBIGNPadL("2",( HB_SIZE )ipN,"0");

            while (n--){
                tBIGNegDiv(aux,sN2,ipN,nB,pecDivTmp);
                hb_xmemcpy(aux,pecDivTmp->cDivQ,( HB_SIZE )ipN);
                hb_xfree(pecDivTmp->cDivQ);
                hb_xfree(pecDivTmp->cDivR);
                v1=0;
                i=ipN;
                while(--i>=0){
                    idivQ[i]<<=1;
                    idivQ[i]+=v1;
                    if (idivQ[i]>=nB){
                        v1=idivQ[i]/nB;
                        idivQ[i]%=nB;
                    }else{
                        v1=0;
                    }
                }
                if (memcmp(pecDiv->cDivR,aux,( HB_SIZE )ipN)>=0){
                    char * tmp=tBIGNSub(pecDiv->cDivR,aux,ipN,( HB_SIZE )ipN,nB);
                    hb_xmemcpy(pecDiv->cDivR,tmp,( HB_SIZE )ipN);
                    hb_xfree(tmp);
                    v1=0;
                    i=ipN;
                    HB_BOOL bAdd=HB_TRUE;
                    while(--i>=0){
                        if (bAdd){
                            idivQ[i]++;
                            bAdd=HB_FALSE;
                        }
                        idivQ[i]+=v1;
                        if (idivQ[i]>=nB){
                            idivQ[i]-=nB;
                            v1=1;
                        }else{
                            v1=0;
                        }
                    }
                }
            }

            hb_xfree(aux);
            hb_xfree(sN2);
            hb_xfree(pecDivTmp);

            pecDiv->cDivQ=(char*)hb_xgrab(( HB_SIZE )ipN+1);

            i=ipN;
            while(--i>=0){
                /* TODO: Rever este conceito */
                pecDiv->cDivQ[i]="0123456789"[idivQ[i]];
            }

            free(idivQ);
            idivQ=NULL;

        }

        HB_FUNC_STATIC( TBIGNECDIV ){

            HB_MAXINT n=(HB_MAXINT)(hb_parnint(4)+1);
            char * pN=tBIGNPadL(hb_parc(1),( HB_SIZE )n,"0");
            char * pD=tBIGNPadL(hb_parc(2),( HB_SIZE )n,"0");
            ptBIGNeDiv pecDiv=(ptBIGNeDiv)hb_xgrab(( HB_SIZE )sizeof(stBIGNeDiv));
            int iCmp=memcmp(pN,pD,( HB_SIZE )n);

            switch(iCmp){
                case -1:{
                    pecDiv->cDivQ=tBIGNPadL("0",( HB_SIZE )n,"0");
                    pecDiv->cDivR=hb_strdup(pN);
                    break;
                }
                case 0:{
                    pecDiv->cDivQ=tBIGNPadL("1",( HB_SIZE )n,"0");
                    pecDiv->cDivR=tBIGNPadL("0",( HB_SIZE )n,"0");
                    break;
                }
                default:{
                    const HB_MAXINT nB=(HB_MAXINT)hb_parnint(5);
                    tBIGNecDiv(pN,pD,n,nB,pecDiv);
                }
            }

            #if 0
                hb_retclen(pecDiv->cDivQ,( HB_SIZE )n);
                hb_storclen(pecDiv->cDivR,( HB_SIZE )n,3);
            #else
                hb_retclen_buffer(hb_strdup(pecDiv->cDivQ),( HB_SIZE )n);
                hb_storclen_buffer(hb_strdup(pecDiv->cDivR),( HB_SIZE )n,3);
            #endif

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pecDiv->cDivR);
            hb_xfree(pecDiv->cDivQ);
            hb_xfree(pecDiv);
        }

        /*
        static HB_MAXINT tBIGNGCD(HB_MAXINT x,HB_MAXINT y){
            HB_TRACE(HB_TR_DEBUG,("tBIGNGCD(%" PFHL "d,%" PFHL "d)",x,y));
            HB_MAXINT nGCD=x;
            x=HB_MAX(y,nGCD);
            y=HB_MIN(nGCD,y);
            if (y==0){
               nGCD=x;
            } else {
                  nGCD=y;
                  while (HB_TRUE){
                      if ((y=(x%y))==0){
                          break;
                      }
                      x=nGCD;
                      nGCD=y;
                  }
            }
            return nGCD;
        }*/

        /*http://en.wikipedia.org/wiki/Binary_GCD_algorithm*/
        static HB_MAXINT tBIGNGCD(HB_MAXINT u,HB_MAXINT v){

          HB_TRACE(HB_TR_DEBUG,("tBIGNGCD(%" PFHL "d,%" PFHL "d)",u,v));

          int shift;


          /* GCD(0,v)==v; GCD(u,0)==u,GCD(0,0)==0 */
          if (u==0) return v;
          if (v==0) return u;

          /* Let shift:=lg K,where K is the greatest power of 2
                dividing both u and v. */
          for (shift=0; ((u|v)&1)==0;++shift){
                 u>>=1;
                 v>>=1;
          }

          while ((u&1)==0)
            u>>=1;

          /* From here on,u is always odd. */
          do {
               /* remove all factors of 2 in v -- they are not common */
               /*   note: v is not zero,so while will terminate */
               while ((v&1)==0)  /* Loop X */
                   v>>=1;

               /* Now u and v are both odd. Swap if necessary so u<=v,
                  then set v=v-u (which is even). for bignums,the
                  swapping is just pointer movement,and the subtraction
                  can be done in-place. */
               if (u> v) {
                 HB_MAXINT t=v; v=u; u=t;}/*Swap u and v.*/
               v=v-u;                        /*Here v>=u.*/
             } while (v!=0);

          /* restore common factors of 2 */
          return u<<shift;
        }

        HB_FUNC_STATIC( TBIGNGCD ){
            hb_retnint(tBIGNGCD((HB_MAXINT)hb_parnint(1),(HB_MAXINT)hb_parnint(2)));
        }

        /*
        static HB_MAXINT tBIGNLCM(HB_MAXINT x,HB_MAXINT y){

            HB_TRACE(HB_TR_DEBUG,("tBIGNLCM(%" PFHL "d,%" PFHL "d)",x,y));

            HB_MAXINT nLCM=1;
            HB_MAXINT i=2;

            HB_BOOL lMx;
            HB_BOOL lMy;

            while (HB_TRUE){
                lMx=((x%i)==0);
                lMy=((y%i)==0);
                while (lMx||lMy){
                    nLCM*=i;
                    if (lMx){
                        x/=i;
                        lMx=((x%i)==0);
                    }
                    if (lMy){
                        y/=i;
                        lMy=((y%i)==0);
                    }
                }
                if ((x==1)&&(y==1)){
                    break;
                }
                ++i;
            }

            return nLCM;

        }
        */

        static HB_MAXINT tBIGNLCM(HB_MAXINT x,HB_MAXINT y){
            HB_TRACE(HB_TR_DEBUG,("tBIGNLCM(%" PFHL "d,%" PFHL "d)",x,y));
            return ((y/tBIGNGCD(x,y))*x);
        }

        HB_FUNC_STATIC( TBIGNLCM ){
            hb_retnint(tBIGNLCM((HB_MAXINT)hb_parnint(1),(HB_MAXINT)hb_parnint(2)));
        }

        static HB_MAXINT tBIGNFI(HB_MAXINT n){
            HB_TRACE(HB_TR_DEBUG,("tBIGNFI(%" PFHL "d)",n));
            HB_MAXINT i;
            HB_MAXINT fi=n;
            for(i=2;((i*i)<=n);i++){
                if ((n%i)==0){
                    fi-=fi/i;
                }
                while ((n%i)==0){
                    n/=i;
                }
            }
               if (n>1){
                   fi-=fi/n;
               }
               return fi;
        }

        HB_FUNC_STATIC( TBIGNFI ){
            hb_retnint(tBIGNFI((HB_MAXINT)hb_parnint(1)));
        }

        HB_FUNC_STATIC( TBIGNALEN ){
           hb_retns(hb_arrayLen(hb_param(1,HB_IT_ARRAY)));
        }

        HB_FUNC_STATIC( TBIGNMEMCMP ){
           hb_retnint(memcmp(hb_parc(1),hb_parc(2),hb_parclen(1)));
        }

        HB_FUNC_STATIC( TBIGNMAX ){
           hb_retnint(HB_MAX(hb_parnint(1),hb_parnint(2)));
        }

        HB_FUNC_STATIC( TBIGNMIN ){
           hb_retnint(HB_MIN(hb_parnint(1),hb_parnint(2)));
        }

        HB_FUNC_STATIC( TBIGNNORMALIZE ){

            HB_SIZE nInt1=(HB_SIZE)hb_parnint(2);
            HB_SIZE nInt2=(HB_SIZE)hb_parnint(7);
            HB_SIZE nPadL=HB_MAX(nInt1,nInt2);

            HB_SIZE nDec1=(HB_SIZE)hb_parnint(4);
            HB_SIZE nDec2=(HB_SIZE)hb_parnint(9);
            HB_SIZE nPadR=HB_MAX(nDec1,nDec2);

            HB_BOOL lPadL=nPadL!=nInt1;
            HB_BOOL lPadR=nPadR!=nDec1;

            char * tmpPad;

            if (lPadL||lPadR){
                if (lPadL){
                    tmpPad=tBIGNPadL(hb_parc(1),nPadL,"0");
                    #if 0
                        hb_storclen(tmpPad,nPadL,1);
                        hb_xfree(tmpPad);
                        hb_stornint(nPadL,2);
                    #else
                        if( hb_storclen_buffer( tmpPad, nPadL, 1 ) )
                        {
                            hb_stornint(nPadL,2);
                        }
                        else{
                            hb_xfree( tmpPad );
                            lPadL=HB_FALSE;
                            lPadR=HB_FALSE;
                        }
                    #endif
                }
                if (lPadR){
                    tmpPad=tBIGNPadR(hb_parc(3),nPadR,"0");
                    #if 0
                        hb_storclen(tmpPad,nPadR,3);
                        hb_xfree(tmpPad);
                        hb_stornint(nPadR,4);
                    #else
                        if( hb_storclen_buffer( tmpPad, nPadR, 3 ) )
                        {
                            hb_stornint(nPadR,4);
                        }
                        else{
                            hb_xfree( tmpPad );
                            lPadL=HB_FALSE;
                            lPadR=HB_FALSE;
                        }
                    #endif
                }
                if (lPadL||lPadR){
                    hb_stornint(nPadL+nPadR,5);
                }
            }

            lPadL=nPadL!=nInt2;
            lPadR=nPadR!=nDec2;

            if (lPadL||lPadR){
                if (lPadL){
                    tmpPad=tBIGNPadL(hb_parc(6),nPadL,"0");
                    #if 0
                        hb_storclen(tmpPad,nPadL,6);
                        hb_xfree(tmpPad);
                        hb_stornint(nPadL,7);
                    #else
                            if( hb_storclen_buffer( tmpPad, nPadL, 6 ) )
                            {
                                hb_stornint(nPadL,7);
                            }
                            else{
                                hb_xfree( tmpPad );
                                lPadL=HB_FALSE;
                                lPadR=HB_FALSE;
                            }
                    #endif
                }
                if (lPadR){
                    tmpPad=tBIGNPadR(hb_parc(8),nPadR,"0");
                    #if 0
                        hb_storclen(tmpPad,nPadR,8);
                        hb_xfree(tmpPad);
                        hb_stornint(nPadR,9);
                    #else
                            if( hb_storclen_buffer( tmpPad, nPadR, 8 ) )
                            {
                                hb_stornint(nPadR,9);
                            }
                            else{
                                hb_xfree( tmpPad );
                                lPadL=HB_FALSE;
                                lPadR=HB_FALSE;
                            }
                    #endif
                }
                if (lPadL||lPadR){
                    hb_stornint(nPadL+nPadR,10);
                }
            }

        }

        HB_FUNC_STATIC( TBIGNSQRT )
        {
           if (HB_ISCHAR(1))
           {
              HB_MATH_EXCEPTION hb_exc;
              long double ldResult;
              long double ldArg=strtold(hb_parc(1),NULL);
              if (ldArg<=0)
              {
                std::string str=to_string(0.0);
                char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                std::strcpy(cstr,str.c_str());
                #if 0
                    hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                    hb_xfree(cstr);
                #else
                    hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                #endif
              }
              else
              {
                    hb_mathResetError(&hb_exc);
                    ldResult=sqrtl(ldArg);
                    if( hb_mathGetError(&hb_exc,"SQRTL",(double)ldArg,0.0,(double)ldResult))
                    {
                        std::string str=to_string(0.0);
                        char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                        std::strcpy(cstr,str.c_str());
                        #if 0
                            hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                            hb_xfree(cstr);
                        #else
                            hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                        #endif
                    }
                    else
                    {
                        std::string str=to_string(ldResult);
                        char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                        std::strcpy(cstr,str.c_str());
                        #if 0
                            hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                            hb_xfree(cstr);
                        #else
                            hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                        #endif
                    }
              }
           }
           else
           {
                std::string str=to_string(0.0);
                char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                std::strcpy(cstr,str.c_str());
                #if 0
                    hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                    hb_xfree(cstr);
                #else
                    hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                #endif
            }
        }

        HB_FUNC_STATIC( TBIGNLOG )
        {
           if (HB_ISCHAR(1)&HB_ISCHAR(2))
           {
                HB_MATH_EXCEPTION hb_exc;
                long double ldResult;
                long double ldArgN=strtold(hb_parc(1),NULL);
                long double ldArgB=strtold(hb_parc(2),NULL);
                hb_mathResetError(&hb_exc);
                ldResult=(log10l(ldArgN)/log10l(ldArgB));
                if( hb_mathGetError(&hb_exc,"LOG10L",(double)ldArgN,(double)ldArgB,(double)ldResult))
                {
                    std::string str=to_string(0.0);
                    char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                    std::strcpy(cstr,str.c_str());
                    #if 0
                        hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                        hb_xfree(cstr);
                    #else
                        hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                    #endif
                }
                else
                {
                    std::string str=to_string(ldResult);
                    if (str.find("inf")!=std::string::npos||str.find("nan")!=std::string::npos)
                    {
                        str=to_string(0.0);
                    }
                    char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                    std::strcpy(cstr,str.c_str());
                    #if 0
                        hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                        hb_xfree(cstr);
                    #else
                        hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                    #endif
                }
           }
           else
           {
                std::string str=to_string(0.0);
                char * cstr=(char*)hb_xgrab(( HB_SIZE )str.length()+1);
                std::strcpy(cstr,str.c_str());
                #if 0
                    hb_retclen(cstr,( HB_SIZE )strlen(cstr));
                    hb_xfree(cstr);
                #else
                    hb_retclen_buffer(cstr,( HB_SIZE )strlen(cstr));
                #endif
            }
        }

    #pragma ENDDUMP

#endif /*__HARBOUR__*/
