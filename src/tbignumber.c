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
        About       : C(++) tBigNumber functions
        Author      : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Date        : 04/02/2013
        Description : tBig'C(++)'Number Optimizations (?) functions
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

        template <typename TO_STRING>
        std::string to_string(TO_STRING const& value){
            std::stringstream sstr;
            sstr.precision(std::numeric_limits<long double>::digits10+1);
            sstr << std::fixed << value;
            return sstr.str();
        }
        
        typedef struct{
            char * cMultM;
            char * cMultP;
        } stBIGNeMult,* ptBIGNeMult;
        
        typedef struct{
            char * cDivQ;
            char * cDivR;
        } stBIGNeDiv,* ptBIGNeDiv;

        static char * TBIGNReplicate(const char * szText,HB_ISIZ nTimes);
        static char * tBIGNPadL(const char * szItem,HB_ISIZ nLen,const char * szPad);
        static char * tBIGNPadR(const char * szItem,HB_ISIZ nLen,const char * szPad);
        static char * tBIGNReverse(const char * szF,const HB_SIZE s);
        static char * tBIGNAdd(const char * a,const char * b,int n,const HB_SIZE y,const HB_MAXUINT nB);
        static char * tBigNiADD(char * sN, HB_MAXUINT a,const int isN,const HB_MAXUINT nB);
        static char * tBIGNSub(const char * a,const char * b,int n,const HB_SIZE y,const HB_MAXUINT nB);        
        static char * tBigNiSUB(char * sN,const HB_MAXUINT s,const int isN,const HB_MAXUINT nB); 
        static char * tBIGNMult(const char * a,const char * b,HB_SIZE n,const HB_SIZE y,const HB_MAXUINT nB);
        static void tBIGNegMult(const char * pN,const char * pD,int n,const HB_MAXUINT nB,ptBIGNeMult pegMult);        
        static char * tBigN2Mult(char * sN,const int isN,const HB_MAXUINT nB);
        static char * tBigNiMult(char * sN,const HB_MAXUINT m,const HB_SIZE isN,const HB_MAXUINT nB);
        static void tBIGNegDiv(const char * pN,const char * pD,int n,const HB_MAXUINT nB,ptBIGNeDiv pegDiv);        
        static void tBIGNecDiv(const char * pA,const char * pB,int ipN,const HB_MAXUINT nB,ptBIGNeDiv pecDiv);        
        static HB_MAXUINT tBIGNGCD(HB_MAXUINT u,HB_MAXUINT v);
        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x,HB_MAXUINT y);
        static HB_MAXUINT tBIGNFI(HB_MAXUINT n);

        static char * TBIGNReplicate(const char * szText,HB_ISIZ nTimes){
            HB_SIZE nLen    = strlen(szText);       
            HB_ISIZ nRLen   = (nLen*nTimes);
            char * szResult = (char*)hb_xgrab(nRLen+1);
            char * szPtr    = szResult;
            HB_ISIZ n;
            for(n=0;n<nTimes;++n)
            {
                hb_xmemcpy(szPtr,szText,nLen);
                szPtr+=nLen;
            }
            return szResult;
        }

        static char * tBIGNPadL(const char * szItem,HB_ISIZ nLen,const char * szPad){
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%*.*s%s",padLen,padLen,padding,szItem);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }

        HB_FUNC_STATIC( TBIGNPADL ){      
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadL(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNPadR(const char * szItem,HB_ISIZ nLen,const char * szPad){    
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%s%*.*s",szItem,padLen,padLen,padding);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }
       
        HB_FUNC_STATIC( TBIGNPADR ){
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadR(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNReverse(const char * szF,const HB_SIZE s){
            HB_SIZE f  = s;
            HB_SIZE t  = 0;
            char * szT = (char*)hb_xgrab(s+1);
            for(;f;){
                szT[t++]=szF[--f];
            }
            szT[t]=szF[t];
            return szT;
        }

        HB_FUNC_STATIC( TBIGNREVERSE ){
            const char * szF = hb_parc(1);
            const HB_SIZE s  = (HB_SIZE)hb_parnint(2);
            char * szR       = tBIGNReverse(szF,s);
            hb_retclen(szR,s);
            hb_xfree(szR);
        }

        static char * tBIGNAdd(const char * a,const char * b,int n,const HB_SIZE y,const HB_MAXUINT nB){    
            char * c         = (char*)hb_xgrab(y+1);
            HB_SIZE k        = y-1;
            HB_MAXUINT v     = 0;
            HB_MAXUINT v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')+(*(&b[n])-'0');
                if ( v>=nB ){
                    v  -= nB;
                    v1 = 1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v];
                c[k-1] = "0123456789"[v1];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNADD ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = (HB_SIZE)(hb_parnint(4)+1);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNAdd(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
        
        static char * tBigNiADD(char * sN, HB_MAXUINT a,const int isN,const HB_MAXUINT nB){
            HB_BOOL bAdd  = HB_TRUE;
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i         = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                if (bAdd){
                    v    += a;
                    bAdd =  HB_FALSE;
                }    
                v += v1;
                if ( v>=nB ){
                    v  -= nB;
                    v1 = 1;
                }    
                else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNIADD ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)+1);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            HB_MAXUINT a        = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiADD(szRet,a,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLADD ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)+(HB_MAXUINT)hb_parnint(2));
        }
   
        static char * tBIGNSub(const char * a,const char * b,int n,const HB_SIZE y,const HB_MAXUINT nB){
            char * c      = (char*)hb_xgrab(y+1);
            HB_SIZE k     = y-1;
            int v         = 0;
            int v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')-(*(&b[n])-'0');
                if ( v<0 ){
                    v+=nB;
                    v1 = -1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v];
                c[k-1] = "0123456789"[v1];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNSUB ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = n;
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            char * szRet        = tBIGNSub(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
        
        static char * tBigNiSUB(char * sN,const HB_MAXUINT s,const int isN,const HB_MAXUINT nB){
            HB_BOOL bSub  = HB_TRUE;
            int v;
            int v1        = 0;
            int i         = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                if (bSub){
                    v    -= s;
                    bSub =  HB_FALSE;
                }                
                v += v1;
                if ( v<0 ){
                    v+=nB;
                    v1 = -1;
                }    
                else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNISUB ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1));
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            int s               = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiSUB(szRet,s,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLSUB ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)-(HB_MAXUINT)hb_parnint(2));
        }
 
        static char * tBIGNMult(const char * a,const char * b,HB_SIZE n,const HB_SIZE y,const HB_MAXUINT nB){
            
            char * c     = (char*)hb_xgrab(y+1);
            
            HB_SIZE i    = 0;
            HB_SIZE k    = 0;
            HB_SIZE l    = 1;
            HB_SIZE s;
            HB_SIZE j;
            
            HB_MAXUINT v = 0;
            HB_MAXUINT v1;
            
            n-=1;
            
            while (i<=n){
                s = 0;
                j = i;
                while (s<=i){
                    v+=(*(&a[s++])-'0')*(*(&b[j--])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
               }else{
                    v1 = 0;
                 };
                c[k]   = "0123456789"[v];
                c[k+1] = "0123456789"[v1];
                v = v1;
                k++;
                i++;
            }
        
            while (l<=n){
                s = n;
                j = l;
                while (s>=l){
                    v+=(*(&a[s--])-'0')*(*(&b[j++])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
                }else{
                    v1     = 0;                    
                }
                c[k]   = "0123456789"[v];
                c[k+1] = "0123456789"[v1];
                v = v1;
                if (++k>=y){
                    break;
                }
                l++;
            }        
            
            char * r = tBIGNReverse(c,y);
            hb_xfree(c);
    
            return r;
        }
    
        HB_FUNC_STATIC( TBIGNMULT ){
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            char * a            = tBIGNReverse(hb_parc(1),n);
            char * b            = tBIGNReverse(hb_parc(2),n);
            const HB_SIZE y     = (HB_SIZE)(hb_parnint(4)*2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNMult(a,b,n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(a);
            hb_xfree(b);
            hb_xfree(szRet);
        }

        static void tBIGNegMult(const char * pN,const char * pD,int n,const HB_MAXUINT nB,ptBIGNeMult pegMult){
    
            HB_MAXUINT szptBIGNeMult = sizeof(ptBIGNeMult*);
            HB_MAXUINT szstBIGNeMult = sizeof(stBIGNeMult);            
            
            ptBIGNeMult *peMTArr     = (ptBIGNeMult*)hb_xgrab(szptBIGNeMult);        
            ptBIGNeMult pegMultTmp   = (ptBIGNeMult)hb_xgrab(szstBIGNeMult);
            
            char * Tmp               = tBIGNPadL("1",n,"0");
            pegMultTmp->cMultM       = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegMultTmp->cMultP       = hb_strdup(pD);
    
            Tmp                      = tBIGNPadL("0",n,"0");
            pegMult->cMultM          = hb_strdup(Tmp);
            pegMult->cMultP          = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            int nI                   = 0;

            do {
            
                peMTArr     = (ptBIGNeMult*)hb_xrealloc(peMTArr,(nI+1)*szptBIGNeMult);
                peMTArr[nI] = (ptBIGNeMult)hb_xgrab(szstBIGNeMult);
                
                peMTArr[nI]->cMultM = hb_strdup(pegMultTmp->cMultM);
                peMTArr[nI]->cMultP = hb_strdup(pegMultTmp->cMultP);  

                char * tmp = tBIGNAdd(pegMultTmp->cMultM,pegMultTmp->cMultM,n,n,nB);
                hb_xmemcpy(pegMultTmp->cMultM,tmp,n);
                hb_xfree(tmp);
                    
                tmp        = tBIGNAdd(pegMultTmp->cMultP,pegMultTmp->cMultP,n,n,nB);                
                hb_xmemcpy(pegMultTmp->cMultP,tmp,n);
                hb_xfree(tmp);
                
                if (memcmp(pegMultTmp->cMultM,pN,n)==1){
                    break;
                }
                
                ++nI;

            } while (HB_TRUE);
            
            hb_xfree(pegMultTmp->cMultM);
            hb_xfree(pegMultTmp->cMultP);
            
            int nF = nI;

            do {
               
                pegMultTmp->cMultM = tBIGNAdd(pegMult->cMultM,peMTArr[nI]->cMultM,n,n,nB);
                hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                hb_xfree(pegMultTmp->cMultM);
    
                pegMultTmp->cMultP = tBIGNAdd(pegMult->cMultP,peMTArr[nI]->cMultP,n,n,nB);
                hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
                hb_xfree(pegMultTmp->cMultP);
                
                int iCmp = memcmp(pegMult->cMultM,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegMultTmp->cMultM = tBIGNSub(pegMult->cMultM,peMTArr[nI]->cMultM,n,n,nB);
                            hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                            hb_xfree(pegMultTmp->cMultM);
    
                            pegMultTmp->cMultP = tBIGNSub(pegMult->cMultP,peMTArr[nI]->cMultP,n,n,nB);
                            hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
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
            peMTArr = NULL;

            hb_xfree(pegMultTmp);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGMULT ){
            
            HB_SIZE n           = (HB_SIZE)(hb_parnint(3)*2);            
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            
            ptBIGNeMult pegMult = (ptBIGNeMult)hb_xgrab(sizeof(stBIGNeMult));
            
            tBIGNegMult(pN,pD,(int)n,nB,pegMult);
        
            hb_retclen(pegMult->cMultP,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegMult->cMultM);
            hb_xfree(pegMult->cMultP);
            hb_xfree(pegMult);
        }
        
        static char * tBigN2Mult(char * sN,const int isN,const HB_MAXUINT nB){
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                v <<= 1;
                v += v1;
                if (v>=nB){
                    v1 = v/nB;
                    v  %= nB;
                }else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGN2MULT ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)+1);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(2);
            hb_retclen(tBigN2Mult(szRet,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        static char * tBigNiMult(char * sN,const HB_MAXUINT m,const HB_SIZE isN,const HB_MAXUINT nB){
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                v *= m;
                v += v1;
                if (v>=nB){
                    v1 = v/nB;
                    v  %= nB;
                }else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNIMULT ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)*2);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            HB_MAXUINT m        = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiMult(szRet,m,n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLMULT ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)*(HB_MAXUINT)hb_parnint(2));
        }

        static void tBIGNegDiv(const char * pN,const char * pD,int n,const HB_MAXUINT nB,ptBIGNeDiv pegDiv){
    
            HB_MAXUINT szptBIGNeDiv = sizeof(ptBIGNeDiv*);
            HB_MAXUINT szstBIGNeDiv = sizeof(stBIGNeDiv);
    
            ptBIGNeDiv *peDVArr     = (ptBIGNeDiv*)hb_xgrab(szptBIGNeDiv);
            ptBIGNeDiv pegDivTmp    = (ptBIGNeDiv)hb_xgrab(szstBIGNeDiv);
            
            char * Tmp              = tBIGNPadL("1",n,"0");
            pegDivTmp->cDivQ        = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegDivTmp->cDivR        = hb_strdup(pD);
            
            int nI = 0;
 
            do {

                peDVArr     = (ptBIGNeDiv*)hb_xrealloc(peDVArr,(nI+1)*szptBIGNeDiv);
                peDVArr[nI] = (ptBIGNeDiv)hb_xgrab(szstBIGNeDiv);
                
                peDVArr[nI]->cDivQ = hb_strdup(pegDivTmp->cDivQ);
                peDVArr[nI]->cDivR = hb_strdup(pegDivTmp->cDivR);  

                char * tmp = tBIGNAdd(pegDivTmp->cDivQ,pegDivTmp->cDivQ,n,n,nB);
                hb_xmemcpy(pegDivTmp->cDivQ,tmp,n);
                hb_xfree(tmp);
                    
                tmp        = tBIGNAdd(pegDivTmp->cDivR,pegDivTmp->cDivR,n,n,nB);
                hb_xmemcpy(pegDivTmp->cDivR,tmp,n);
                hb_xfree(tmp);

                if (memcmp(pegDivTmp->cDivR,pN,n)==1){
                    break;
                }
                
                ++nI;

            } while (HB_TRUE);
  
            hb_xfree(pegDivTmp->cDivQ);
            hb_xfree(pegDivTmp->cDivR);

            int nF = nI;
  
            Tmp                     = tBIGNPadL("0",n,"0");
            pegDiv->cDivQ           = hb_strdup(Tmp);
            pegDiv->cDivR           = hb_strdup(Tmp);
            hb_xfree(Tmp);
  
            do {
                
                pegDivTmp->cDivQ = tBIGNAdd(pegDiv->cDivQ,peDVArr[nI]->cDivQ,n,n,nB);
                hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                hb_xfree(pegDivTmp->cDivQ);
    
                pegDivTmp->cDivR = tBIGNAdd(pegDiv->cDivR,peDVArr[nI]->cDivR,n,n,nB);
                hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
                hb_xfree(pegDivTmp->cDivR);
                
                int iCmp = memcmp(pegDiv->cDivR,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegDivTmp->cDivQ = tBIGNSub(pegDiv->cDivQ,peDVArr[nI]->cDivQ,n,n,nB);
                            hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                            hb_xfree(pegDivTmp->cDivQ);
    
                            pegDivTmp->cDivR = tBIGNSub(pegDiv->cDivR,peDVArr[nI]->cDivR,n,n,nB);
                            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
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
            peDVArr = NULL;
   
            pegDivTmp->cDivR = tBIGNSub(pN,pegDiv->cDivR,n,n,nB);
            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
            hb_xfree(pegDivTmp->cDivR);
            hb_xfree(pegDivTmp);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGDIV ){
 
            HB_SIZE n           = (HB_SIZE)(hb_parnint(4)+1); 
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            ptBIGNeDiv pegDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            int iCmp            = memcmp(pN,pD,n);
          
            switch(iCmp){
                case -1:{
                    pegDiv->cDivQ = tBIGNPadL("0",n,"0");
                    pegDiv->cDivR = hb_strdup(pN);
                    break;
                }
                case 0:{
                    pegDiv->cDivQ = tBIGNPadL("1",n,"0");
                    pegDiv->cDivR = tBIGNPadL("0",n,"0");
                    break;
                }
                default:{
                    const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
                    tBIGNegDiv(pN,pD,(int)n,nB,pegDiv);
                }
            }
            
            hb_storclen(pegDiv->cDivR,n,3);
            hb_retclen(pegDiv->cDivQ,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegDiv->cDivR);
            hb_xfree(pegDiv->cDivQ);
            hb_xfree(pegDiv);
        }
        
        static void tBIGNecDiv(const char * pA,const char * pB,int ipN,const HB_MAXUINT nB,ptBIGNeDiv pecDiv){
            
            int n                   = 0;
            
            pecDiv->cDivR           = hb_strdup(pA);
            char * aux              = hb_strdup(pB);
             
            HB_MAXUINT v1;
          
            ptBIGNeDiv  pecDivTmp   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));

            HB_MAXUINT szHB_MAXUINT = sizeof(HB_MAXUINT);
            HB_MAXUINT snHB_MAXUINT = ipN*szHB_MAXUINT;
            
            HB_MAXUINT *ipA         = (HB_MAXUINT*)hb_xgrab(snHB_MAXUINT);
            HB_MAXUINT *iaux        = (HB_MAXUINT*)hb_xgrab(snHB_MAXUINT);
                        
            int i = ipN;
            while(--i>=0){
                ipA[i]  = (*(&pecDiv->cDivR[i])-'0');
                iaux[i] = (*(&aux[i])-'0');
            }
 
            while (memcmp(iaux,ipA,ipN)<=0){
                n++;
                v1 = 0;
                i = ipN;
                while(--i>=0){
                    iaux[i] <<= 1;
                    iaux[i] += v1;
                    if (iaux[i]>=nB){
                        v1 = iaux[i]/nB;
                        iaux[i] %= nB;
                    }else{
                        v1 = 0;
                    }
                }
            }

            hb_xfree(ipA);
            ipA = NULL;
 
            i = ipN;
            while(--i>=0){
                aux[i]   = "0123456789"[iaux[i]];
            }
            
            hb_xfree(iaux);
            iaux = NULL;
            
            HB_MAXUINT *idivQ = (HB_MAXUINT*)calloc(ipN,szHB_MAXUINT);
            char * sN2        = tBIGNPadL("2",ipN,"0");
 
            while (n--){            
                tBIGNegDiv(aux,sN2,ipN,nB,pecDivTmp);
                hb_xmemcpy(aux,pecDivTmp->cDivQ,ipN);
                hb_xfree(pecDivTmp->cDivQ);
                hb_xfree(pecDivTmp->cDivR);    
                v1 = 0;
                i = ipN;
                while(--i>=0){
                    idivQ[i] <<= 1;
                    idivQ[i] += v1;
                    if (idivQ[i]>=nB){
                        v1 = idivQ[i]/nB;
                        idivQ[i] %= nB;
                    }else{
                        v1 = 0;
                    }
                }
                if (memcmp(pecDiv->cDivR,aux,ipN)>=0){
                    char * tmp = tBIGNSub(pecDiv->cDivR,aux,ipN,ipN,nB);
                    hb_xmemcpy(pecDiv->cDivR,tmp,ipN);
                    hb_xfree(tmp);
                    v1 = 0;
                    i  = ipN;
                    HB_BOOL bAdd = HB_TRUE;
                    while(--i>=0){
                        if (bAdd){
                            idivQ[i]++;
                            bAdd = HB_FALSE;
                        }    
                        idivQ[i] += v1;
                        if (idivQ[i]>=nB){
                            idivQ[i] -= nB;
                            v1 = 1;
                        }else{
                            v1 = 0;
                        }
                    } 
                }
            }
            
            hb_xfree(aux);
            hb_xfree(sN2);
            hb_xfree(pecDivTmp);
            
            pecDiv->cDivQ = (char*)hb_xgrab(ipN+1);

            i = ipN;
            while(--i>=0){
                pecDiv->cDivQ[i] = "0123456789"[idivQ[i]];
            }
            
            free(idivQ);
            idivQ = NULL;
            
        }
        
        HB_FUNC_STATIC( TBIGNECDIV ){
            
            HB_SIZE n           = (HB_SIZE)(hb_parnint(4)+1);
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            ptBIGNeDiv pecDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            int iCmp            = memcmp(pN,pD,n);
          
            switch(iCmp){
                case -1:{
                    pecDiv->cDivQ = tBIGNPadL("0",n,"0");
                    pecDiv->cDivR = hb_strdup(pN);
                    break;
                }
                case 0:{
                    pecDiv->cDivQ = tBIGNPadL("1",n,"0");
                    pecDiv->cDivR = tBIGNPadL("0",n,"0");
                    break;
                }
                default:{
                    const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
                    tBIGNecDiv(pN,pD,(int)n,nB,pecDiv);
                }
            }
            
            hb_storclen(pecDiv->cDivR,n,3);
            hb_retclen(pecDiv->cDivQ,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pecDiv->cDivR);
            hb_xfree(pecDiv->cDivQ);
            hb_xfree(pecDiv);
        }
                
        /*
        static HB_MAXUINT tBIGNGCD(HB_MAXUINT x,HB_MAXUINT y){
            HB_MAXUINT nGCD = x;  
            x = HB_MAX(y,nGCD);
            y = HB_MIN(nGCD,y);
            if (y==0){
               nGCD = x;
            } else {
                  nGCD = y;
                  while (HB_TRUE){
                      if ((y=(x%y))==0){
                          break;
                      }
                      x    = nGCD;
                      nGCD = y;
                  }
            }
            return nGCD;
        }*/
        
        //http://en.wikipedia.org/wiki/Binary_GCD_algorithm
        static HB_MAXUINT tBIGNGCD(HB_MAXUINT u,HB_MAXUINT v){
          int shift;
         
          /* GCD(0,v) == v; GCD(u,0) == u,GCD(0,0) == 0 */
          if (u == 0) return v;
          if (v == 0) return u;
         
          /* Let shift:=lg K,where K is the greatest power of 2
                dividing both u and v. */
          for (shift = 0; ((u | v) & 1) == 0; ++shift) {
                 u >>= 1;
                 v >>= 1;
          }
         
          while ((u & 1) == 0)
            u >>= 1;
         
          /* From here on,u is always odd. */
          do {
               /* remove all factors of 2 in v -- they are not common */
               /*   note: v is not zero,so while will terminate */
               while ((v & 1) == 0)  /* Loop X */
                   v >>= 1;
         
               /* Now u and v are both odd. Swap if necessary so u <= v,
                  then set v = v - u (which is even). for bignums,the
                  swapping is just pointer movement,and the subtraction
                  can be done in-place. */
               if (u > v) {
                 unsigned int t = v; v = u; u = t;}  // Swap u and v.
               v = v - u;                            // Here v >= u.
             } while (v != 0);
         
          /* restore common factors of 2 */
          return u << shift;
        }

        HB_FUNC_STATIC( TBIGNGCD ){
            hb_retnint(tBIGNGCD((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        /*
        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x,HB_MAXUINT y){
             
            HB_MAXUINT nLCM = 1;
            HB_MAXUINT i    = 2;
        
            HB_BOOL lMx;
            HB_BOOL lMy;
        
            while (HB_TRUE){
                lMx = ((x%i)==0);
                lMy = ((y%i)==0);
                while (lMx||lMy){
                    nLCM *= i;
                    if (lMx){
                        x   /= i;
                        lMx = ((x%i)==0);
                    }
                    if (lMy){
                        y   /= i;
                        lMy = ((y%i)==0);
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

        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x,HB_MAXUINT y){
            return ((y/tBIGNGCD(x,y))*x);
        }    
        
        HB_FUNC_STATIC( TBIGNLCM ){
            hb_retnint(tBIGNLCM((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        static HB_MAXUINT tBIGNFI(HB_MAXUINT n){
            HB_MAXUINT i;
            HB_MAXUINT fi = n;
            for(i=2;((i*i)<=n);i++){
                if ((n%i)==0){
                    fi -= fi/i;
                }    
                while ((n%i)==0){
                    n /= i;
                }    
            } 
               if (n>1){
                   fi -= fi/n;
               }     
               return fi; 
        }
        
        HB_FUNC_STATIC( TBIGNFI ){
            hb_retnint(tBIGNFI((HB_MAXUINT)hb_parnint(1)));
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
            
            HB_SIZE nInt1 = (HB_SIZE)hb_parnint(2);
            HB_SIZE nInt2 = (HB_SIZE)hb_parnint(7);
            HB_SIZE nPadL = HB_MAX(nInt1,nInt2);
 
            HB_SIZE nDec1 = (HB_SIZE)hb_parnint(4);
            HB_SIZE nDec2 = (HB_SIZE)hb_parnint(9);            
            HB_SIZE nPadR = HB_MAX(nDec1,nDec2);
    
            HB_BOOL lPadL = nPadL!=nInt1;
            HB_BOOL lPadR = nPadR!=nDec1;
        
            char * tmpPad;
    
            if (lPadL || lPadR){
                if (lPadL){
                    tmpPad = tBIGNPadL(hb_parc(1),nPadL,"0");
                    hb_storclen(tmpPad,nPadL,1);
                    hb_stornint(nPadL,2);
                    hb_xfree(tmpPad);
                }
                if (lPadR){
                    tmpPad = tBIGNPadR(hb_parc(3),nPadR,"0");
                    hb_storclen(tmpPad,nPadR,3);
                    hb_stornint(nPadR,4);
                    hb_xfree(tmpPad);
                }
                hb_stornint(nPadL+nPadR,5);
            }

            lPadL = nPadL!=nInt2;
            lPadR = nPadR!=nDec2;
           
            if (lPadL || lPadR){
                if (lPadL){
                    tmpPad = tBIGNPadL(hb_parc(6),nPadL,"0");
                    hb_storclen(tmpPad,nPadL,6);
                    hb_stornint(nPadL,7);
                    hb_xfree(tmpPad);
                }
                if (lPadR){
                    tmpPad = tBIGNPadR(hb_parc(8),nPadR,"0");
                    hb_storclen(tmpPad,nPadR,8);
                    hb_stornint(nPadR,9);
                    hb_xfree(tmpPad);
                }
                hb_stornint(nPadL+nPadR,10);
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
                 char * cstr=(char*)hb_xgrab(str.length()+1);
                 std::strcpy(cstr,str.c_str());
                 hb_retclen(cstr,strlen(cstr));
                 hb_xfree(cstr);
              } 
              else
              {
                 hb_mathResetError(&hb_exc);
                 ldResult=sqrtl(ldArg);
                 if( hb_mathGetError(&hb_exc,"SQRTL",ldArg,0.0,ldResult))
                 {
                    std::string str=to_string(0.0);
                    char * cstr=(char*)hb_xgrab(str.length()+1);
                    std::strcpy(cstr,str.c_str());
                    hb_retclen(cstr,strlen(cstr));
                    hb_xfree(cstr);
                 } 
                 else
                 { 
                    std::string str=to_string(ldResult);
                    char * cstr=(char*)hb_xgrab(str.length()+1);
                    std::strcpy(cstr,str.c_str());
                    hb_retclen(cstr,strlen(cstr));
                    hb_xfree(cstr);
                 }
              }
           }
           else 
           {
                std::string str=to_string(0.0);
                char * cstr=(char*)hb_xgrab(str.length()+1);
                std::strcpy(cstr,str.c_str());
                hb_retclen(cstr,strlen(cstr));
                hb_xfree(cstr);
            }
        }       
        
    #pragma ENDDUMP

#endif // __HARBOUR__