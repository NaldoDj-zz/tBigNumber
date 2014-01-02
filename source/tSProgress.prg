#IFDEF PROTHEUS
	#DEFINE __PROTHEUS__
	#include "protheus.ch"
#ELSE
	#IFDEF __HARBOUR__
		#include "hbclass.ch"
	#ENDIF
#ENDIF
#include "tBigNumber.ch"
/*
	Class		: tSProgress
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 29/12/2013
	Descricao   : Instancia um novo objeto do tipo tSProgress
	Sintaxe     : tSProgress():New(cProgress,cToken) -> self
*/
CLASS tSProgress

#IFNDEF __PROTHEUS__	
	PROTECTED:
#ENDIF	
	
	DATA aProgress	AS ARRAY INIT Array(0)
	
	DATA nMax		AS NUMERIC INIT 0
	DATA nProgress	AS NUMERIC INIT 0
	
#IFNDEF __PROTHEUS__
	EXPORTED:
#ENDIF

	METHOD New(cProgress,cToken)  CONSTRUCTOR
	METHOD ClassName()
	METHOD Eval(cMethod,uPar01)
	METHOD Progress()
	METHOD Increment(cAlign)
	METHOD Decrement(cAlign)
	METHOD SetProgress(cProgress,cToken)

ENDCLASS

METHOD New(cProgress,cToken) CLASS tSProgress
	self:SetProgress(@cProgress,@cToken)
Return(self)

METHOD SetProgress(cProgress,cToken) CLASS tSProgress
	Local lMacro
	DEFAULT cProgress	:= "-;\;|;/"
	DEFAULT cToken		:= ";"	
	lMacro := (SubStr(cProgress,1,1)=="&")
	IF (lMacro)
		cProgress		:= SubStr(cProgress,2)
		cProgress		:= &(cProgress)
	EndIF
	self:aProgress		:= _StrToKArr(@cProgress,@cToken)
	self:nMax			:= Len(self:aProgress)
	self:nProgress		:= 0
Return(self)

METHOD ClassName() CLASS tSProgress
Return("TSPROGEESS")

METHOD Eval(cMethod,uPar01) CLASS tSProgress
	Local cEval
	DEFAULT cMethod := "PROGRESS"
	DO CASE
	CASE (cMethod=="PROGRESS")
		cEval := self:Progress()
	CASE (cMethod=="INCREMENT")
		cEval := self:Increment(@uPar01)
	CASE (cMethod=="DECREMENT")
		cEval := self:Decrement(@uPar01)
	OTHERWISE
		cEval := self:Progress()	
	ENDCASE
Return(cEval)

METHOD Progress() CLASS tSProgress
Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])

METHOD Increment(cAlign) CLASS tSProgress
	Local cPADFunc  := "PAD"
	Local cProgress := ""
	Local nProgress
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	For nProgress := 1 To self:nProgress
		cProgress += self:aProgress[nProgress]
	Next nProgress
	DEFAULT cAlign := "R" //L,C,R
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

METHOD Decrement(cAlign) CLASS tSProgress
	Local cPADFunc  := "PAD"
	Local cProgress := ""
	Local nProgress
	IF (--self:nProgress<=0)
		self:nProgress := self:nMax
	EndIF
	For nProgress := self:nMax To self:nProgress STEP (-1)
		cProgress += self:aProgress[nProgress]
	Next nProgress
	DEFAULT cAlign := "L" //L,C,R
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Static Function _StrToKArr(cStr,cToken)
	Local cDToken
	DEFAULT cStr   := ""
	DEFAULT cToken := ";"
	cDToken := (cToken+cToken)
	While (cDToken$cStr)
		cStr := StrTran(cStr,cDToken,cToken+" "+cToken)
	End While
#IFDEF PROTHEUS
Return(StrToKArr(cStr,cToken))
#ELSE
Return(hb_aTokens(cStr,cToken))
#ENDIF