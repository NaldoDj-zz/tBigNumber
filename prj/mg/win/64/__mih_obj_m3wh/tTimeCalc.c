/*
 * Harbour 3.2.0dev (r1409231118)
 * MinGW GNU C 4.9.1 (64-bit)
 * Generated C source from "D:\GitHub\tbigNumber\src\tTimeCalc.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TTIMECALC );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TTIMECALC_NEW );
HB_FUNC_STATIC( TTIMECALC_CLASSNAME );
HB_FUNC_STATIC( TTIMECALC_HMSTOTIME );
HB_FUNC_STATIC( TTIMECALC_SECSTOHMS );
HB_FUNC_STATIC( TTIMECALC_SECSTOTIME );
HB_FUNC_STATIC( TTIMECALC_TIMETOSECS );
HB_FUNC_STATIC( TTIMECALC_SECSTOHRS );
HB_FUNC_STATIC( TTIMECALC_HRSTOSECS );
HB_FUNC_STATIC( TTIMECALC_SECSTOMIN );
HB_FUNC_STATIC( TTIMECALC_MINTOSECS );
HB_FUNC_STATIC( TTIMECALC_INCTIME );
HB_FUNC_STATIC( TTIMECALC_DECTIME );
HB_FUNC_STATIC( TTIMECALC_TIME2NEXTDAY );
HB_FUNC_STATIC( TTIMECALC_EXTRACTTIME );
HB_FUNC_STATIC( TTIMECALC_MEDIUMTIME );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( HB_DEFAULT );
HB_FUNC_EXTERN( HB_NTOS );
HB_FUNC_EXTERN( STRZERO );
HB_FUNC_EXTERN( VAL );
HB_FUNC_EXTERN( MAX );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( INT );
HB_FUNC_EXTERN( MOD );
HB_FUNC_EXTERN( AT );
HB_FUNC_EXTERN( SUBSTR );
HB_FUNC_EXTERN( XHB_LIB );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TTIMECALC )
{ "TTIMECALC", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TTIMECALC_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_NEW )}, NULL },
{ "TTIMECALC_CLASSNAME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_CLASSNAME )}, NULL },
{ "TTIMECALC_HMSTOTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_HMSTOTIME )}, NULL },
{ "TTIMECALC_SECSTOHMS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_SECSTOHMS )}, NULL },
{ "TTIMECALC_SECSTOTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_SECSTOTIME )}, NULL },
{ "TTIMECALC_TIMETOSECS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_TIMETOSECS )}, NULL },
{ "TTIMECALC_SECSTOHRS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_SECSTOHRS )}, NULL },
{ "TTIMECALC_HRSTOSECS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_HRSTOSECS )}, NULL },
{ "TTIMECALC_SECSTOMIN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_SECSTOMIN )}, NULL },
{ "TTIMECALC_MINTOSECS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_MINTOSECS )}, NULL },
{ "TTIMECALC_INCTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_INCTIME )}, NULL },
{ "TTIMECALC_DECTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_DECTIME )}, NULL },
{ "TTIMECALC_TIME2NEXTDAY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_TIME2NEXTDAY )}, NULL },
{ "TTIMECALC_EXTRACTTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_EXTRACTTIME )}, NULL },
{ "TTIMECALC_MEDIUMTIME", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TTIMECALC_MEDIUMTIME )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_DEFAULT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_DEFAULT )}, NULL },
{ "HB_NTOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_NTOS )}, NULL },
{ "STRZERO", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRZERO )}, NULL },
{ "VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( VAL )}, NULL },
{ "MAX", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAX )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "SECSTOHRS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SECSTOMIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HRSTOSECS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MINTOSECS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INT", {HB_FS_PUBLIC}, {HB_FUNCNAME( INT )}, NULL },
{ "MOD", {HB_FS_PUBLIC}, {HB_FUNCNAME( MOD )}, NULL },
{ "SECSTOHMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HMSTOTIME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXTRACTTIME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SECSTOTIME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DECTIME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AT", {HB_FS_PUBLIC}, {HB_FUNCNAME( AT )}, NULL },
{ "SUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SUBSTR )}, NULL },
{ "TIMETOSECS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "XHB_LIB", {HB_FS_PUBLIC}, {HB_FUNCNAME( XHB_LIB )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TTIMECALC, "D:\\GitHub\\tbigNumber\\src\\tTimeCalc.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TTIMECALC
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TTIMECALC )
   #include "hbiniseg.h"
#endif

HB_FUNC( TTIMECALC )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,47,0,36,10,0,103,1,0,100,8,
		29,110,2,176,1,0,104,1,0,12,1,29,99,2,
		166,37,2,0,122,80,1,48,2,0,176,3,0,12,
		0,106,10,116,84,105,109,101,67,97,108,99,0,108,
		4,4,1,0,108,0,112,3,80,2,36,12,0,122,
		80,1,36,14,0,48,5,0,95,2,106,4,78,101,
		119,0,108,6,95,1,92,8,72,121,72,121,72,112,
		3,73,36,15,0,48,5,0,95,2,106,10,67,108,
		97,115,115,78,97,109,101,0,108,7,95,1,121,72,
		121,72,121,72,112,3,73,36,16,0,48,5,0,95,
		2,106,10,72,77,83,84,111,84,105,109,101,0,108,
		8,95,1,121,72,121,72,121,72,112,3,73,36,17,
		0,48,5,0,95,2,106,10,83,101,99,115,84,111,
		72,77,83,0,108,9,95,1,121,72,121,72,121,72,
		112,3,73,36,18,0,48,5,0,95,2,106,11,83,
		101,99,115,84,111,84,105,109,101,0,108,10,95,1,
		121,72,121,72,121,72,112,3,73,36,19,0,48,5,
		0,95,2,106,11,84,105,109,101,84,111,83,101,99,
		115,0,108,11,95,1,121,72,121,72,121,72,112,3,
		73,36,20,0,48,5,0,95,2,106,10,83,101,99,
		115,84,111,72,114,115,0,108,12,95,1,121,72,121,
		72,121,72,112,3,73,36,21,0,48,5,0,95,2,
		106,10,72,114,115,84,111,83,101,99,115,0,108,13,
		95,1,121,72,121,72,121,72,112,3,73,36,22,0,
		48,5,0,95,2,106,10,83,101,99,115,84,111,77,
		105,110,0,108,14,95,1,121,72,121,72,121,72,112,
		3,73,36,23,0,48,5,0,95,2,106,10,77,105,
		110,84,111,83,101,99,115,0,108,15,95,1,121,72,
		121,72,121,72,112,3,73,36,24,0,48,5,0,95,
		2,106,8,73,110,99,84,105,109,101,0,108,16,95,
		1,121,72,121,72,121,72,112,3,73,36,25,0,48,
		5,0,95,2,106,8,68,101,99,84,105,109,101,0,
		108,17,95,1,121,72,121,72,121,72,112,3,73,36,
		26,0,48,5,0,95,2,106,13,84,105,109,101,50,
		78,101,120,116,68,97,121,0,108,18,95,1,121,72,
		121,72,121,72,112,3,73,36,27,0,48,5,0,95,
		2,106,12,69,120,116,114,97,99,116,84,105,109,101,
		0,108,19,95,1,121,72,121,72,121,72,112,3,73,
		36,28,0,48,5,0,95,2,106,11,77,101,100,105,
		117,109,84,105,109,101,0,108,20,95,1,121,72,121,
		72,121,72,112,3,73,36,29,0,48,21,0,95,2,
		112,0,73,167,14,0,0,176,22,0,104,1,0,95,
		2,20,2,168,48,23,0,95,2,112,0,80,3,176,
		24,0,95,3,106,10,73,110,105,116,67,108,97,115,
		115,0,12,2,28,12,48,25,0,95,3,164,146,1,
		0,73,95,3,110,7,48,23,0,103,1,0,112,0,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,32,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_CLASSNAME )
{
	static const HB_BYTE pcode[] =
	{
		36,35,0,106,10,84,84,73,77,69,67,65,76,67,
		0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_HMSTOTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,41,0,95,1,100,8,28,11,176,26,
		0,96,1,0,121,20,2,36,42,0,95,2,100,8,
		28,11,176,26,0,96,2,0,121,20,2,36,43,0,
		95,3,100,8,28,11,176,26,0,96,3,0,121,20,
		2,36,45,0,176,27,0,95,1,12,1,80,4,36,
		46,0,176,28,0,176,29,0,95,4,12,1,176,30,
		0,176,31,0,95,4,12,1,92,2,12,2,12,2,
		80,4,36,47,0,96,4,0,106,2,58,0,135,36,
		48,0,96,4,0,176,28,0,176,29,0,176,27,0,
		95,2,12,1,12,1,92,2,12,2,135,36,49,0,
		96,4,0,106,2,58,0,135,36,50,0,96,4,0,
		176,28,0,176,29,0,176,27,0,95,3,12,1,12,
		1,92,2,12,2,135,36,52,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_SECSTOHMS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,5,36,56,0,121,80,6,36,58,0,95,1,
		100,8,28,11,176,26,0,96,1,0,121,20,2,36,
		59,0,95,5,100,8,28,14,176,26,0,96,5,0,
		106,2,72,0,20,2,36,61,0,48,32,0,102,95,
		1,112,1,80,2,36,62,0,48,33,0,102,95,1,
		112,1,80,3,36,63,0,48,34,0,102,95,2,112,
		1,48,35,0,102,95,3,112,1,72,80,4,36,64,
		0,95,1,95,4,49,80,4,36,65,0,176,36,0,
		95,4,12,1,80,4,36,66,0,176,37,0,95,4,
		92,60,12,2,80,4,36,68,0,95,5,106,3,72,
		104,0,24,28,11,36,69,0,95,2,80,6,25,44,
		36,70,0,95,5,106,3,77,109,0,24,28,11,36,
		71,0,95,3,80,6,25,22,36,72,0,95,5,106,
		3,83,115,0,24,28,9,36,73,0,95,4,80,6,
		36,76,0,95,6,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_SECSTOTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,82,0,48,38,0,102,95,1,96,2,
		0,96,3,0,96,4,0,112,4,73,36,83,0,48,
		39,0,102,95,2,95,3,95,4,112,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_TIMETOSECS )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,91,0,95,1,100,8,28,21,176,26,
		0,96,1,0,106,9,48,48,58,48,48,58,48,48,
		0,20,2,36,93,0,48,40,0,102,95,1,96,2,
		0,96,3,0,96,4,0,112,4,73,36,95,0,96,
		3,0,95,2,92,60,65,135,36,96,0,96,4,0,
		95,3,92,60,65,135,36,98,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_SECSTOHRS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,102,0,95,1,93,16,14,18,80,2,
		36,103,0,176,36,0,95,2,12,1,80,2,36,104,
		0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_HRSTOSECS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,107,0,95,1,93,16,14,65,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_SECSTOMIN )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,111,0,95,1,92,60,18,80,2,36,
		112,0,176,36,0,95,2,12,1,80,2,36,113,0,
		176,37,0,95,2,92,60,12,2,80,2,36,114,0,
		95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_MINTOSECS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,117,0,95,1,92,60,65,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_INCTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,3,4,36,125,0,95,2,100,8,28,11,176,26,
		0,96,2,0,121,20,2,36,126,0,95,3,100,8,
		28,11,176,26,0,96,3,0,121,20,2,36,127,0,
		95,4,100,8,28,11,176,26,0,96,4,0,121,20,
		2,36,129,0,48,40,0,102,95,1,96,7,0,96,
		6,0,96,5,0,112,4,73,36,131,0,96,7,0,
		95,2,135,36,132,0,96,6,0,95,3,135,36,133,
		0,96,5,0,95,4,135,36,134,0,48,34,0,102,
		95,7,112,1,48,35,0,102,95,6,112,1,72,95,
		5,72,80,5,36,136,0,48,41,0,102,95,5,112,
		1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_DECTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,3,4,36,144,0,95,2,100,8,28,11,176,26,
		0,96,2,0,121,20,2,36,145,0,95,3,100,8,
		28,11,176,26,0,96,3,0,121,20,2,36,146,0,
		95,4,100,8,28,11,176,26,0,96,4,0,121,20,
		2,36,148,0,48,40,0,102,95,1,96,7,0,96,
		6,0,96,5,0,112,4,73,36,150,0,96,7,0,
		95,2,136,36,151,0,96,6,0,95,3,136,36,152,
		0,96,5,0,95,4,136,36,153,0,48,34,0,102,
		95,7,112,1,48,35,0,102,95,6,112,1,72,95,
		5,72,80,5,36,155,0,48,41,0,102,95,5,112,
		1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_TIME2NEXTDAY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,158,0,176,29,0,95,1,12,1,92,
		24,16,28,25,36,159,0,48,42,0,102,95,1,92,
		24,112,2,80,1,36,160,0,174,2,0,25,220,36,
		162,0,95,1,95,2,4,2,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_EXTRACTTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,2,5,36,166,0,121,80,6,36,170,0,95,1,
		100,8,28,21,176,26,0,96,1,0,106,9,48,48,
		58,48,48,58,48,48,0,20,2,36,171,0,95,5,
		100,8,28,14,176,26,0,96,5,0,106,2,72,0,
		20,2,36,173,0,176,43,0,106,2,58,0,95,1,
		12,2,80,7,36,175,0,95,7,121,8,28,29,36,
		176,0,176,29,0,95,1,12,1,80,2,36,177,0,
		121,80,3,36,178,0,121,80,4,26,129,0,36,180,
		0,176,29,0,176,44,0,95,1,122,95,7,122,49,
		12,3,12,1,80,2,36,181,0,176,44,0,95,1,
		95,7,122,72,12,2,80,1,36,182,0,176,43,0,
		106,2,58,0,95,1,12,2,80,7,36,183,0,95,
		7,121,8,28,22,36,184,0,176,29,0,95,1,12,
		1,80,3,36,185,0,121,80,4,25,45,36,187,0,
		176,29,0,176,44,0,95,1,122,95,7,122,49,12,
		3,12,1,80,3,36,188,0,176,29,0,176,44,0,
		95,1,95,7,122,72,12,2,12,1,80,4,36,192,
		0,95,5,106,3,72,104,0,24,28,11,36,193,0,
		95,2,80,6,25,44,36,194,0,95,5,106,3,77,
		109,0,24,28,11,36,195,0,95,3,80,6,25,22,
		36,196,0,95,5,106,3,83,115,0,24,28,9,36,
		197,0,95,4,80,6,36,200,0,95,6,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TTIMECALC_MEDIUMTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,4,3,36,204,0,106,13,48,48,58,48,48,58,
		48,48,58,48,48,48,0,80,4,36,210,0,95,2,
		100,8,28,11,176,26,0,96,2,0,121,20,2,36,
		212,0,95,2,121,15,28,82,36,214,0,48,45,0,
		102,95,1,112,1,80,5,36,215,0,95,5,95,2,
		18,80,5,36,216,0,176,36,0,95,5,12,1,80,
		6,36,218,0,95,5,95,6,49,80,7,36,219,0,
		96,7,0,93,232,3,137,36,220,0,176,36,0,95,
		7,12,1,80,7,36,222,0,48,41,0,102,95,6,
		112,1,80,4,36,226,0,95,3,100,8,28,11,176,
		26,0,96,3,0,120,20,2,36,227,0,95,3,28,
		53,36,228,0,95,7,100,8,28,11,176,26,0,96,
		7,0,121,20,2,36,229,0,96,4,0,106,2,58,
		0,176,28,0,95,7,95,7,93,231,3,15,28,6,
		92,4,25,4,92,3,12,2,72,135,36,232,0,95,
		4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,47,0,1,0,7
	};

	hb_vmExecute( pcode, symbols );
}

