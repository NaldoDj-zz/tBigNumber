/*
 * Harbour 3.2.0dev (r1409231118)
 * MinGW GNU C 4.9.1 (64-bit)
 * Generated C source from "D:\GitHub\tbigNumber\src\__ptPITthD.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC_STATIC( __PITTHD );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit___PTPITTHD )
{ "__PITTHD", {HB_FS_STATIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( __PITTHD )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit___PTPITTHD, "D:\\GitHub\\tbigNumber\\src\\__ptPITthD.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit___PTPITTHD
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit___PTPITTHD )
   #include "hbiniseg.h"
#endif

HB_FUNC_STATIC( __PITTHD )
{
	static const HB_BYTE pcode[] =
	{
		116,1,0,36,140,0,103,1,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,1,0,1,0,116,1,0,105,18,39,51,46,49,
		52,49,53,57,50,54,53,51,53,56,57,55,57,51,
		50,51,56,52,54,50,54,52,51,51,56,51,50,55,
		57,53,48,50,56,56,52,49,57,55,49,54,57,51,
		57,57,51,55,53,49,48,53,56,50,48,57,55,52,
		57,52,52,53,57,50,51,48,55,56,49,54,52,48,
		54,50,56,54,50,48,56,57,57,56,54,50,56,48,
		51,52,56,50,53,51,52,50,49,49,55,48,54,55,
		57,56,50,49,52,56,48,56,54,53,49,51,50,56,
		50,51,48,54,54,52,55,48,57,51,56,52,52,54,
		48,57,53,53,48,53,56,50,50,51,49,55,50,53,
		51,53,57,52,48,56,49,50,56,52,56,49,49,49,
		55,52,53,48,50,56,52,49,48,50,55,48,49,57,
		51,56,53,50,49,49,48,53,53,53,57,54,52,52,
		54,50,50,57,52,56,57,53,52,57,51,48,51,56,
		49,57,54,52,52,50,56,56,49,48,57,55,53,54,
		54,53,57,51,51,52,52,54,49,50,56,52,55,53,
		54,52,56,50,51,51,55,56,54,55,56,51,49,54,
		53,50,55,49,50,48,49,57,48,57,49,52,53,54,
		52,56,53,54,54,57,50,51,52,54,48,51,52,56,
		54,49,48,52,53,52,51,50,54,54,52,56,50,49,
		51,51,57,51,54,48,55,50,54,48,50,52,57,49,
		52,49,50,55,51,55,50,52,53,56,55,48,48,54,
		54,48,54,51,49,53,53,56,56,49,55,52,56,56,
		49,53,50,48,57,50,48,57,54,50,56,50,57,50,
		53,52,48,57,49,55,49,53,51,54,52,51,54,55,
		56,57,50,53,57,48,51,54,48,48,49,49,51,51,
		48,53,51,48,53,52,56,56,50,48,52,54,54,53,
		50,49,51,56,52,49,52,54,57,53,49,57,52,49,
		53,49,49,54,48,57,52,51,51,48,53,55,50,55,
		48,51,54,53,55,53,57,53,57,49,57,53,51,48,
		57,50,49,56,54,49,49,55,51,56,49,57,51,50,
		54,49,49,55,57,51,49,48,53,49,49,56,53,52,
		56,48,55,52,52,54,50,51,55,57,57,54,50,55,
		52,57,53,54,55,51,53,49,56,56,53,55,53,50,
		55,50,52,56,57,49,50,50,55,57,51,56,49,56,
		51,48,49,49,57,52,57,49,50,57,56,51,51,54,
		55,51,51,54,50,52,52,48,54,53,54,54,52,51,
		48,56,54,48,50,49,51,57,52,57,52,54,51,57,
		53,50,50,52,55,51,55,49,57,48,55,48,50,49,
		55,57,56,54,48,57,52,51,55,48,50,55,55,48,
		53,51,57,50,49,55,49,55,54,50,57,51,49,55,
		54,55,53,50,51,56,52,54,55,52,56,49,56,52,
		54,55,54,54,57,52,48,53,49,51,50,48,48,48,
		53,54,56,49,50,55,49,52,53,50,54,51,53,54,
		48,56,50,55,55,56,53,55,55,49,51,52,50,55,
		53,55,55,56,57,54,48,57,49,55,51,54,51,55,
		49,55,56,55,50,49,52,54,56,52,52,48,57,48,
		49,50,50,52,57,53,51,52,51,48,49,52,54,53,
		52,57,53,56,53,51,55,49,48,53,48,55,57,50,
		50,55,57,54,56,57,50,53,56,57,50,51,53,52,
		50,48,49,57,57,53,54,49,49,50,49,50,57,48,
		50,49,57,54,48,56,54,52,48,51,52,52,49,56,
		49,53,57,56,49,51,54,50,57,55,55,52,55,55,
		49,51,48,57,57,54,48,53,49,56,55,48,55,50,
		49,49,51,52,57,57,57,57,57,57,56,51,55,50,
		57,55,56,48,52,57,57,53,49,48,53,57,55,51,
		49,55,51,50,56,49,54,48,57,54,51,49,56,53,
		57,53,48,50,52,52,53,57,52,53,53,51,52,54,
		57,48,56,51,48,50,54,52,50,53,50,50,51,48,
		56,50,53,51,51,52,52,54,56,53,48,51,53,50,
		54,49,57,51,49,49,56,56,49,55,49,48,49,48,
		48,48,51,49,51,55,56,51,56,55,53,50,56,56,
		54,53,56,55,53,51,51,50,48,56,51,56,49,52,
		50,48,54,49,55,49,55,55,54,54,57,49,52,55,
		51,48,51,53,57,56,50,53,51,52,57,48,52,50,
		56,55,53,53,52,54,56,55,51,49,49,53,57,53,
		54,50,56,54,51,56,56,50,51,53,51,55,56,55,
		53,57,51,55,53,49,57,53,55,55,56,49,56,53,
		55,55,56,48,53,51,50,49,55,49,50,50,54,56,
		48,54,54,49,51,48,48,49,57,50,55,56,55,54,
		54,49,49,49,57,53,57,48,57,50,49,54,52,50,
		48,49,57,56,57,51,56,48,57,53,50,53,55,50,
		48,49,48,54,53,52,56,53,56,54,51,50,55,56,
		56,54,53,57,51,54,49,53,51,51,56,49,56,50,
		55,57,54,56,50,51,48,51,48,49,57,53,50,48,
		51,53,51,48,49,56,53,50,57,54,56,57,57,53,
		55,55,51,54,50,50,53,57,57,52,49,51,56,57,
		49,50,52,57,55,50,49,55,55,53,50,56,51,52,
		55,57,49,51,49,53,49,53,53,55,52,56,53,55,
		50,52,50,52,53,52,49,53,48,54,57,53,57,53,
		48,56,50,57,53,51,51,49,49,54,56,54,49,55,
		50,55,56,53,53,56,56,57,48,55,53,48,57,56,
		51,56,49,55,53,52,54,51,55,52,54,52,57,51,
		57,51,49,57,50,53,53,48,54,48,52,48,48,57,
		50,55,55,48,49,54,55,49,49,51,57,48,48,57,
		56,52,56,56,50,52,48,49,50,56,53,56,51,54,
		49,54,48,51,53,54,51,55,48,55,54,54,48,49,
		48,52,55,49,48,49,56,49,57,52,50,57,53,53,
		53,57,54,49,57,56,57,52,54,55,54,55,56,51,
		55,52,52,57,52,52,56,50,53,53,51,55,57,55,
		55,52,55,50,54,56,52,55,49,48,52,48,52,55,
		53,51,52,54,52,54,50,48,56,48,52,54,54,56,
		52,50,53,57,48,54,57,52,57,49,50,57,51,51,
		49,51,54,55,55,48,50,56,57,56,57,49,53,50,
		49,48,52,55,53,50,49,54,50,48,53,54,57,54,
		54,48,50,52,48,53,56,48,51,56,49,53,48,49,
		57,51,53,49,49,50,53,51,51,56,50,52,51,48,
		48,51,53,53,56,55,54,52,48,50,52,55,52,57,
		54,52,55,51,50,54,51,57,49,52,49,57,57,50,
		55,50,54,48,52,50,54,57,57,50,50,55,57,54,
		55,56,50,51,53,52,55,56,49,54,51,54,48,48,
		57,51,52,49,55,50,49,54,52,49,50,49,57,57,
		50,52,53,56,54,51,49,53,48,51,48,50,56,54,
		49,56,50,57,55,52,53,53,53,55,48,54,55,52,
		57,56,51,56,53,48,53,52,57,52,53,56,56,53,
		56,54,57,50,54,57,57,53,54,57,48,57,50,55,
		50,49,48,55,57,55,53,48,57,51,48,50,57,53,
		53,51,50,49,49,54,53,51,52,52,57,56,55,50,
		48,50,55,53,53,57,54,48,50,51,54,52,56,48,
		54,54,53,52,57,57,49,49,57,56,56,49,56,51,
		52,55,57,55,55,53,51,53,54,54,51,54,57,56,
		48,55,52,50,54,53,52,50,53,50,55,56,54,50,
		53,53,49,56,49,56,52,49,55,53,55,52,54,55,
		50,56,57,48,57,55,55,55,55,50,55,57,51,56,
		48,48,48,56,49,54,52,55,48,54,48,48,49,54,
		49,52,53,50,52,57,49,57,50,49,55,51,50,49,
		55,50,49,52,55,55,50,51,53,48,49,52,49,52,
		52,49,57,55,51,53,54,56,53,52,56,49,54,49,
		51,54,49,49,53,55,51,53,50,53,53,50,49,51,
		51,52,55,53,55,52,49,56,52,57,52,54,56,52,
		51,56,53,50,51,51,50,51,57,48,55,51,57,52,
		49,52,51,51,51,52,53,52,55,55,54,50,52,49,
		54,56,54,50,53,49,56,57,56,51,53,54,57,52,
		56,53,53,54,50,48,57,57,50,49,57,50,50,50,
		49,56,52,50,55,50,53,53,48,50,53,52,50,53,
		54,56,56,55,54,55,49,55,57,48,52,57,52,54,
		48,49,54,53,51,52,54,54,56,48,52,57,56,56,
		54,50,55,50,51,50,55,57,49,55,56,54,48,56,
		53,55,56,52,51,56,51,56,50,55,57,54,55,57,
		55,54,54,56,49,52,53,52,49,48,48,57,53,51,
		56,56,51,55,56,54,51,54,48,57,53,48,54,56,
		48,48,54,52,50,50,53,49,50,53,50,48,53,49,
		49,55,51,57,50,57,56,52,56,57,54,48,56,52,
		49,50,56,52,56,56,54,50,54,57,52,53,54,48,
		52,50,52,49,57,54,53,50,56,53,48,50,50,50,
		49,48,54,54,49,49,56,54,51,48,54,55,52,52,
		50,55,56,54,50,50,48,51,57,49,57,52,57,52,
		53,48,52,55,49,50,51,55,49,51,55,56,54,57,
		54,48,57,53,54,51,54,52,51,55,49,57,49,55,
		50,56,55,52,54,55,55,54,52,54,53,55,53,55,
		51,57,54,50,52,49,51,56,57,48,56,54,53,56,
		51,50,54,52,53,57,57,53,56,49,51,51,57,48,
		52,55,56,48,50,55,53,57,48,48,57,57,52,54,
		53,55,54,52,48,55,56,57,53,49,50,54,57,52,
		54,56,51,57,56,51,53,50,53,57,53,55,48,57,
		56,50,53,56,50,50,54,50,48,53,50,50,52,56,
		57,52,48,55,55,50,54,55,49,57,52,55,56,50,
		54,56,52,56,50,54,48,49,52,55,54,57,57,48,
		57,48,50,54,52,48,49,51,54,51,57,52,52,51,
		55,52,53,53,51,48,53,48,54,56,50,48,51,52,
		57,54,50,53,50,52,53,49,55,52,57,51,57,57,
		54,53,49,52,51,49,52,50,57,56,48,57,49,57,
		48,54,53,57,50,53,48,57,51,55,50,50,49,54,
		57,54,52,54,49,53,49,53,55,48,57,56,53,56,
		51,56,55,52,49,48,53,57,55,56,56,53,57,53,
		57,55,55,50,57,55,53,52,57,56,57,51,48,49,
		54,49,55,53,51,57,50,56,52,54,56,49,51,56,
		50,54,56,54,56,51,56,54,56,57,52,50,55,55,
		52,49,53,53,57,57,49,56,53,53,57,50,53,50,
		52,53,57,53,51,57,53,57,52,51,49,48,52,57,
		57,55,50,53,50,52,54,56,48,56,52,53,57,56,
		55,50,55,51,54,52,52,54,57,53,56,52,56,54,
		53,51,56,51,54,55,51,54,50,50,50,54,50,54,
		48,57,57,49,50,52,54,48,56,48,53,49,50,52,
		51,56,56,52,51,57,48,52,53,49,50,52,52,49,
		51,54,53,52,57,55,54,50,55,56,48,55,57,55,
		55,49,53,54,57,49,52,51,53,57,57,55,55,48,
		48,49,50,57,54,49,54,48,56,57,52,52,49,54,
		57,52,56,54,56,53,53,53,56,52,56,52,48,54,
		51,53,51,52,50,50,48,55,50,50,50,53,56,50,
		56,52,56,56,54,52,56,49,53,56,52,53,54,48,
		50,56,53,48,54,48,49,54,56,52,50,55,51,57,
		52,53,50,50,54,55,52,54,55,54,55,56,56,57,
		53,50,53,50,49,51,56,53,50,50,53,52,57,57,
		53,52,54,54,54,55,50,55,56,50,51,57,56,54,
		52,53,54,53,57,54,49,49,54,51,53,52,56,56,
		54,50,51,48,53,55,55,52,53,54,52,57,56,48,
		51,53,53,57,51,54,51,52,53,54,56,49,55,52,
		51,50,52,49,49,50,53,49,53,48,55,54,48,54,
		57,52,55,57,52,53,49,48,57,54,53,57,54,48,
		57,52,48,50,53,50,50,56,56,55,57,55,49,48,
		56,57,51,49,52,53,54,54,57,49,51,54,56,54,
		55,50,50,56,55,52,56,57,52,48,53,54,48,49,
		48,49,53,48,51,51,48,56,54,49,55,57,50,56,
		54,56,48,57,50,48,56,55,52,55,54,48,57,49,
		55,56,50,52,57,51,56,53,56,57,48,48,57,55,
		49,52,57,48,57,54,55,53,57,56,53,50,54,49,
		51,54,53,53,52,57,55,56,49,56,57,51,49,50,
		57,55,56,52,56,50,49,54,56,50,57,57,56,57,
		52,56,55,50,50,54,53,56,56,48,52,56,53,55,
		53,54,52,48,49,52,50,55,48,52,55,55,53,53,
		53,49,51,50,51,55,57,54,52,49,52,53,49,53,
		50,51,55,52,54,50,51,52,51,54,52,53,52,50,
		56,53,56,52,52,52,55,57,53,50,54,53,56,54,
		55,56,50,49,48,53,49,49,52,49,51,53,52,55,
		51,53,55,51,57,53,50,51,49,49,51,52,50,55,
		49,54,54,49,48,50,49,51,53,57,54,57,53,51,
		54,50,51,49,52,52,50,57,53,50,52,56,52,57,
		51,55,49,56,55,49,49,48,49,52,53,55,54,53,
		52,48,51,53,57,48,50,55,57,57,51,52,52,48,
		51,55,52,50,48,48,55,51,49,48,53,55,56,53,
		51,57,48,54,50,49,57,56,51,56,55,52,52,55,
		56,48,56,52,55,56,52,56,57,54,56,51,51,50,
		49,52,52,53,55,49,51,56,54,56,55,53,49,57,
		52,51,53,48,54,52,51,48,50,49,56,52,53,51,
		49,57,49,48,52,56,52,56,49,48,48,53,51,55,
		48,54,49,52,54,56,48,54,55,52,57,49,57,50,
		55,56,49,57,49,49,57,55,57,51,57,57,53,50,
		48,54,49,52,49,57,54,54,51,52,50,56,55,53,
		52,52,52,48,54,52,51,55,52,53,49,50,51,55,
		49,56,49,57,50,49,55,57,57,57,56,51,57,49,
		48,49,53,57,49,57,53,54,49,56,49,52,54,55,
		53,49,52,50,54,57,49,50,51,57,55,52,56,57,
		52,48,57,48,55,49,56,54,52,57,52,50,51,49,
		57,54,49,53,54,55,57,52,53,50,48,56,48,57,
		53,49,52,54,53,53,48,50,50,53,50,51,49,54,
		48,51,56,56,49,57,51,48,49,52,50,48,57,51,
		55,54,50,49,51,55,56,53,53,57,53,54,54,51,
		56,57,51,55,55,56,55,48,56,51,48,51,57,48,
		54,57,55,57,50,48,55,55,51,52,54,55,50,50,
		49,56,50,53,54,50,53,57,57,54,54,49,53,48,
		49,52,50,49,53,48,51,48,54,56,48,51,56,52,
		52,55,55,51,52,53,52,57,50,48,50,54,48,53,
		52,49,52,54,54,53,57,50,53,50,48,49,52,57,
		55,52,52,50,56,53,48,55,51,50,53,49,56,54,
		54,54,48,48,50,49,51,50,52,51,52,48,56,56,
		49,57,48,55,49,48,52,56,54,51,51,49,55,51,
		52,54,52,57,54,53,49,52,53,51,57,48,53,55,
		57,54,50,54,56,53,54,49,48,48,53,53,48,56,
		49,48,54,54,53,56,55,57,54,57,57,56,49,54,
		51,53,55,52,55,51,54,51,56,52,48,53,50,53,
		55,49,52,53,57,49,48,50,56,57,55,48,54,52,
		49,52,48,49,49,48,57,55,49,50,48,54,50,56,
		48,52,51,57,48,51,57,55,53,57,53,49,53,54,
		55,55,49,53,55,55,48,48,52,50,48,51,51,55,
		56,54,57,57,51,54,48,48,55,50,51,48,53,53,
		56,55,54,51,49,55,54,51,53,57,52,50,49,56,
		55,51,49,50,53,49,52,55,49,50,48,53,51,50,
		57,50,56,49,57,49,56,50,54,49,56,54,49,50,
		53,56,54,55,51,50,49,53,55,57,49,57,56,52,
		49,52,56,52,56,56,50,57,49,54,52,52,55,48,
		54,48,57,53,55,53,50,55,48,54,57,53,55,50,
		50,48,57,49,55,53,54,55,49,49,54,55,50,50,
		57,49,48,57,56,49,54,57,48,57,49,53,50,56,
		48,49,55,51,53,48,54,55,49,50,55,52,56,53,
		56,51,50,50,50,56,55,49,56,51,53,50,48,57,
		51,53,51,57,54,53,55,50,53,49,50,49,48,56,
		51,53,55,57,49,53,49,51,54,57,56,56,50,48,
		57,49,52,52,52,50,49,48,48,54,55,53,49,48,
		51,51,52,54,55,49,49,48,51,49,52,49,50,54,
		55,49,49,49,51,54,57,57,48,56,54,53,56,53,
		49,54,51,57,56,51,49,53,48,49,57,55,48,49,
		54,53,49,53,49,49,54,56,53,49,55,49,52,51,
		55,54,53,55,54,49,56,51,53,49,53,53,54,53,
		48,56,56,52,57,48,57,57,56,57,56,53,57,57,
		56,50,51,56,55,51,52,53,53,50,56,51,51,49,
		54,51,53,53,48,55,54,52,55,57,49,56,53,51,
		53,56,57,51,50,50,54,49,56,53,52,56,57,54,
		51,50,49,51,50,57,51,51,48,56,57,56,53,55,
		48,54,52,50,48,52,54,55,53,50,53,57,48,55,
		48,57,49,53,52,56,49,52,49,54,53,52,57,56,
		53,57,52,54,49,54,51,55,49,56,48,50,55,48,
		57,56,49,57,57,52,51,48,57,57,50,52,52,56,
		56,57,53,55,53,55,49,50,56,50,56,57,48,53,
		57,50,51,50,51,51,50,54,48,57,55,50,57,57,
		55,49,50,48,56,52,52,51,51,53,55,51,50,54,
		53,52,56,57,51,56,50,51,57,49,49,57,51,50,
		53,57,55,52,54,51,54,54,55,51,48,53,56,51,
		54,48,52,49,52,50,56,49,51,56,56,51,48,51,
		50,48,51,56,50,52,57,48,51,55,53,56,57,56,
		53,50,52,51,55,52,52,49,55,48,50,57,49,51,
		50,55,54,53,54,49,56,48,57,51,55,55,51,52,
		52,52,48,51,48,55,48,55,52,54,57,50,49,49,
		50,48,49,57,49,51,48,50,48,51,51,48,51,56,
		48,49,57,55,54,50,49,49,48,49,49,48,48,52,
		52,57,50,57,51,50,49,53,49,54,48,56,52,50,
		52,52,52,56,53,57,54,51,55,54,54,57,56,51,
		56,57,53,50,50,56,54,56,52,55,56,51,49,50,
		51,53,53,50,54,53,56,50,49,51,49,52,52,57,
		53,55,54,56,53,55,50,54,50,52,51,51,52,52,
		49,56,57,51,48,51,57,54,56,54,52,50,54,50,
		52,51,52,49,48,55,55,51,50,50,54,57,55,56,
		48,50,56,48,55,51,49,56,57,49,53,52,52,49,
		49,48,49,48,52,52,54,56,50,51,50,53,50,55,
		49,54,50,48,49,48,53,50,54,53,50,50,55,50,
		49,49,49,54,54,48,51,57,54,54,54,53,53,55,
		51,48,57,50,53,52,55,49,49,48,53,53,55,56,
		53,51,55,54,51,52,54,54,56,50,48,54,53,51,
		49,48,57,56,57,54,53,50,54,57,49,56,54,50,
		48,53,54,52,55,54,57,51,49,50,53,55,48,53,
		56,54,51,53,54,54,50,48,49,56,53,53,56,49,
		48,48,55,50,57,51,54,48,54,53,57,56,55,54,
		52,56,54,49,49,55,57,49,48,52,53,51,51,52,
		56,56,53,48,51,52,54,49,49,51,54,53,55,54,
		56,54,55,53,51,50,52,57,52,52,49,54,54,56,
		48,51,57,54,50,54,53,55,57,55,56,55,55,49,
		56,53,53,54,48,56,52,53,53,50,57,54,53,52,
		49,50,54,54,53,52,48,56,53,51,48,54,49,52,
		51,52,52,52,51,49,56,53,56,54,55,54,57,55,
		53,49,52,53,54,54,49,52,48,54,56,48,48,55,
		48,48,50,51,55,56,55,55,54,53,57,49,51,52,
		52,48,49,55,49,50,55,52,57,52,55,48,52,50,
		48,53,54,50,50,51,48,53,51,56,57,57,52,53,
		54,49,51,49,52,48,55,49,49,50,55,48,48,48,
		52,48,55,56,53,52,55,51,51,50,54,57,57,51,
		57,48,56,49,52,53,52,54,54,52,54,52,53,56,
		56,48,55,57,55,50,55,48,56,50,54,54,56,51,
		48,54,51,52,51,50,56,53,56,55,56,53,54,57,
		56,51,48,53,50,51,53,56,48,56,57,51,51,48,
		54,53,55,53,55,52,48,54,55,57,53,52,53,55,
		49,54,51,55,55,53,50,53,52,50,48,50,49,49,
		52,57,53,53,55,54,49,53,56,49,52,48,48,50,
		53,48,49,50,54,50,50,56,53,57,52,49,51,48,
		50,49,54,52,55,49,53,53,48,57,55,57,50,53,
		57,50,51,48,57,57,48,55,57,54,53,52,55,51,
		55,54,49,50,53,53,49,55,54,53,54,55,53,49,
		51,53,55,53,49,55,56,50,57,54,54,54,52,53,
		52,55,55,57,49,55,52,53,48,49,49,50,57,57,
		54,49,52,56,57,48,51,48,52,54,51,57,57,52,
		55,49,51,50,57,54,50,49,48,55,51,52,48,52,
		51,55,53,49,56,57,53,55,51,53,57,54,49,52,
		53,56,57,48,49,57,51,56,57,55,49,51,49,49,
		49,55,57,48,52,50,57,55,56,50,56,53,54,52,
		55,53,48,51,50,48,51,49,57,56,54,57,49,53,
		49,52,48,50,56,55,48,56,48,56,53,57,57,48,
		52,56,48,49,48,57,52,49,50,49,52,55,50,50,
		49,51,49,55,57,52,55,54,52,55,55,55,50,54,
		50,50,52,49,52,50,53,52,56,53,52,53,52,48,
		51,51,50,49,53,55,49,56,53,51,48,54,49,52,
		50,50,56,56,49,51,55,53,56,53,48,52,51,48,
		54,51,51,50,49,55,53,49,56,50,57,55,57,56,
		54,54,50,50,51,55,49,55,50,49,53,57,49,54,
		48,55,55,49,54,54,57,50,53,52,55,52,56,55,
		51,56,57,56,54,54,53,52,57,52,57,52,53,48,
		49,49,52,54,53,52,48,54,50,56,52,51,51,54,
		54,51,57,51,55,57,48,48,51,57,55,54,57,50,
		54,53,54,55,50,49,52,54,51,56,53,51,48,54,
		55,51,54,48,57,54,53,55,49,50,48,57,49,56,
		48,55,54,51,56,51,50,55,49,54,54,52,49,54,
		50,55,52,56,56,56,56,48,48,55,56,54,57,50,
		53,54,48,50,57,48,50,50,56,52,55,50,49,48,
		52,48,51,49,55,50,49,49,56,54,48,56,50,48,
		52,49,57,48,48,48,52,50,50,57,54,54,49,55,
		49,49,57,54,51,55,55,57,50,49,51,51,55,53,
		55,53,49,49,52,57,53,57,53,48,49,53,54,54,
		48,52,57,54,51,49,56,54,50,57,52,55,50,54,
		53,52,55,51,54,52,50,53,50,51,48,56,49,55,
		55,48,51,54,55,53,49,53,57,48,54,55,51,53,
		48,50,51,53,48,55,50,56,51,53,52,48,53,54,
		55,48,52,48,51,56,54,55,52,51,53,49,51,54,
		50,50,50,50,52,55,55,49,53,56,57,49,53,48,
		52,57,53,51,48,57,56,52,52,52,56,57,51,51,
		51,48,57,54,51,52,48,56,55,56,48,55,54,57,
		51,50,53,57,57,51,57,55,56,48,53,52,49,57,
		51,52,49,52,52,55,51,55,55,52,52,49,56,52,
		50,54,51,49,50,57,56,54,48,56,48,57,57,56,
		56,56,54,56,55,52,49,51,50,54,48,52,55,50,
		49,53,54,57,53,49,54,50,51,57,54,53,56,54,
		52,53,55,51,48,50,49,54,51,49,53,57,56,49,
		57,51,49,57,53,49,54,55,51,53,51,56,49,50,
		57,55,52,49,54,55,55,50,57,52,55,56,54,55,
		50,52,50,50,57,50,52,54,53,52,51,54,54,56,
		48,48,57,56,48,54,55,54,57,50,56,50,51,56,
		50,56,48,54,56,57,57,54,52,48,48,52,56,50,
		52,51,53,52,48,51,55,48,49,52,49,54,51,49,
		52,57,54,53,56,57,55,57,52,48,57,50,52,51,
		50,51,55,56,57,54,57,48,55,48,54,57,55,55,
		57,52,50,50,51,54,50,53,48,56,50,50,49,54,
		56,56,57,53,55,51,56,51,55,57,56,54,50,51,
		48,48,49,53,57,51,55,55,54,52,55,49,54,53,
		49,50,50,56,57,51,53,55,56,54,48,49,53,56,
		56,49,54,49,55,53,53,55,56,50,57,55,51,53,
		50,51,51,52,52,54,48,52,50,56,49,53,49,50,
		54,50,55,50,48,51,55,51,52,51,49,52,54,53,
		51,49,57,55,55,55,55,52,49,54,48,51,49,57,
		57,48,54,54,53,53,52,49,56,55,54,51,57,55,
		57,50,57,51,51,52,52,49,57,53,50,49,53,52,
		49,51,52,49,56,57,57,52,56,53,52,52,52,55,
		51,52,53,54,55,51,56,51,49,54,50,52,57,57,
		51,52,49,57,49,51,49,56,49,52,56,48,57,50,
		55,55,55,55,49,48,51,56,54,51,56,55,55,51,
		52,51,49,55,55,50,48,55,53,52,53,54,53,52,
		53,51,50,50,48,55,55,55,48,57,50,49,50,48,
		49,57,48,53,49,54,54,48,57,54,50,56,48,52,
		57,48,57,50,54,51,54,48,49,57,55,53,57,56,
		56,50,56,49,54,49,51,51,50,51,49,54,54,54,
		51,54,53,50,56,54,49,57,51,50,54,54,56,54,
		51,51,54,48,54,50,55,51,53,54,55,54,51,48,
		51,53,52,52,55,55,54,50,56,48,51,53,48,52,
		53,48,55,55,55,50,51,53,53,52,55,49,48,53,
		56,53,57,53,52,56,55,48,50,55,57,48,56,49,
		52,51,53,54,50,52,48,49,52,53,49,55,49,56,
		48,54,50,52,54,52,51,54,50,54,55,57,52,53,
		54,49,50,55,53,51,49,56,49,51,52,48,55,56,
		51,51,48,51,51,54,50,53,52,50,51,50,55,56,
		51,57,52,52,57,55,53,51,56,50,52,51,55,50,
		48,53,56,51,53,51,49,49,52,55,55,49,49,57,
		57,50,54,48,54,51,56,49,51,51,52,54,55,55,
		54,56,55,57,54,57,53,57,55,48,51,48,57,56,
		51,51,57,49,51,48,55,55,49,48,57,56,55,48,
		52,48,56,53,57,49,51,51,55,52,54,52,49,52,
		52,50,56,50,50,55,55,50,54,51,52,54,53,57,
		52,55,48,52,55,52,53,56,55,56,52,55,55,56,
		55,50,48,49,57,50,55,55,49,53,50,56,48,55,
		51,49,55,54,55,57,48,55,55,48,55,49,53,55,
		50,49,51,52,52,52,55,51,48,54,48,53,55,48,
		48,55,51,51,52,57,50,52,51,54,57,51,49,49,
		51,56,51,53,48,52,57,51,49,54,51,49,50,56,
		52,48,52,50,53,49,50,49,57,50,53,54,53,49,
		55,57,56,48,54,57,52,49,49,51,53,50,56,48,
		49,51,49,52,55,48,49,51,48,52,55,56,49,54,
		52,51,55,56,56,53,49,56,53,50,57,48,57,50,
		56,53,52,53,50,48,49,49,54,53,56,51,57,51,
		52,49,57,54,53,54,50,49,51,52,57,49,52,51,
		52,49,53,57,53,54,50,53,56,54,53,56,54,53,
		53,55,48,53,53,50,54,57,48,52,57,54,53,50,
		48,57,56,53,56,48,51,51,56,53,48,55,50,50,
		52,50,54,52,56,50,57,51,57,55,50,56,53,56,
		52,55,56,51,49,54,51,48,53,55,55,55,55,53,
		54,48,54,56,56,56,55,54,52,52,54,50,52,56,
		50,52,54,56,53,55,57,50,54,48,51,57,53,51,
		53,50,55,55,51,52,56,48,51,48,52,56,48,50,
		57,48,48,53,56,55,54,48,55,53,56,50,53,49,
		48,52,55,52,55,48,57,49,54,52,51,57,54,49,
		51,54,50,54,55,54,48,52,52,57,50,53,54,50,
		55,52,50,48,52,50,48,56,51,50,48,56,53,54,
		54,49,49,57,48,54,50,53,52,53,52,51,51,55,
		50,49,51,49,53,51,53,57,53,56,52,53,48,54,
		56,55,55,50,52,54,48,50,57,48,49,54,49,56,
		55,54,54,55,57,53,50,52,48,54,49,54,51,52,
		50,53,50,50,53,55,55,49,57,53,52,50,57,49,
		54,50,57,57,49,57,51,48,54,52,53,53,51,55,
		55,57,57,49,52,48,51,55,51,52,48,52,51,50,
		56,55,53,50,54,50,56,56,56,57,54,51,57,57,
		53,56,55,57,52,55,53,55,50,57,49,55,52,54,
		52,50,54,51,53,55,52,53,53,50,53,52,48,55,
		57,48,57,49,52,53,49,51,53,55,49,49,49,51,
		54,57,52,49,48,57,49,49,57,51,57,51,50,53,
		49,57,49,48,55,54,48,50,48,56,50,53,50,48,
		50,54,49,56,55,57,56,53,51,49,56,56,55,55,
		48,53,56,52,50,57,55,50,53,57,49,54,55,55,
		56,49,51,49,52,57,54,57,57,48,48,57,48,49,
		57,50,49,49,54,57,55,49,55,51,55,50,55,56,
		52,55,54,56,52,55,50,54,56,54,48,56,52,57,
		48,48,51,51,55,55,48,50,52,50,52,50,57,49,
		54,53,49,51,48,48,53,48,48,53,49,54,56,51,
		50,51,51,54,52,51,53,48,51,56,57,53,49,55,
		48,50,57,56,57,51,57,50,50,51,51,52,53,49,
		55,50,50,48,49,51,56,49,50,56,48,54,57,54,
		53,48,49,49,55,56,52,52,48,56,55,52,53,49,
		57,54,48,49,50,49,50,50,56,53,57,57,51,55,
		49,54,50,51,49,51,48,49,55,49,49,52,52,52,
		56,52,54,52,48,57,48,51,56,57,48,54,52,52,
		57,53,52,52,52,48,48,54,49,57,56,54,57,48,
		55,53,52,56,53,49,54,48,50,54,51,50,55,53,
		48,53,50,57,56,51,52,57,49,56,55,52,48,55,
		56,54,54,56,48,56,56,49,56,51,51,56,53,49,
		48,50,50,56,51,51,52,53,48,56,53,48,52,56,
		54,48,56,50,53,48,51,57,51,48,50,49,51,51,
		50,49,57,55,49,53,53,49,56,52,51,48,54,51,
		53,52,53,53,48,48,55,54,54,56,50,56,50,57,
		52,57,51,48,52,49,51,55,55,54,53,53,50,55,
		57,51,57,55,53,49,55,53,52,54,49,51,57,53,
		51,57,56,52,54,56,51,51,57,51,54,51,56,51,
		48,52,55,52,54,49,49,57,57,54,54,53,51,56,
		53,56,49,53,51,56,52,50,48,53,54,56,53,51,
		51,56,54,50,49,56,54,55,50,53,50,51,51,52,
		48,50,56,51,48,56,55,49,49,50,51,50,56,50,
		55,56,57,50,49,50,53,48,55,55,49,50,54,50,
		57,52,54,51,50,50,57,53,54,51,57,56,57,56,
		57,56,57,51,53,56,50,49,49,54,55,52,53,54,
		50,55,48,49,48,50,49,56,51,53,54,52,54,50,
		50,48,49,51,52,57,54,55,49,53,49,56,56,49,
		57,48,57,55,51,48,51,56,49,49,57,56,48,48,
		52,57,55,51,52,48,55,50,51,57,54,49,48,51,
		54,56,53,52,48,54,54,52,51,49,57,51,57,53,
		48,57,55,57,48,49,57,48,54,57,57,54,51,57,
		53,53,50,52,53,51,48,48,53,52,53,48,53,56,
		48,54,56,53,53,48,49,57,53,54,55,51,48,50,
		50,57,50,49,57,49,51,57,51,51,57,49,56,53,
		54,56,48,51,52,52,57,48,51,57,56,50,48,53,
		57,53,53,49,48,48,50,50,54,51,53,51,53,51,
		54,49,57,50,48,52,49,57,57,52,55,52,53,53,
		51,56,53,57,51,56,49,48,50,51,52,51,57,53,
		53,52,52,57,53,57,55,55,56,51,55,55,57,48,
		50,51,55,52,50,49,54,49,55,50,55,49,49,49,
		55,50,51,54,52,51,52,51,53,52,51,57,52,55,
		56,50,50,49,56,49,56,53,50,56,54,50,52,48,
		56,53,49,52,48,48,54,54,54,48,52,52,51,51,
		50,53,56,56,56,53,54,57,56,54,55,48,53,52,
		51,49,53,52,55,48,54,57,54,53,55,52,55,52,
		53,56,53,53,48,51,51,50,51,50,51,51,52,50,
		49,48,55,51,48,49,53,52,53,57,52,48,53,49,
		54,53,53,51,55,57,48,54,56,54,54,50,55,51,
		51,51,55,57,57,53,56,53,49,49,53,54,50,53,
		55,56,52,51,50,50,57,56,56,50,55,51,55,50,
		51,49,57,56,57,56,55,53,55,49,52,49,53,57,
		53,55,56,49,49,49,57,54,51,53,56,51,51,48,
		48,53,57,52,48,56,55,51,48,54,56,49,50,49,
		54,48,50,56,55,54,52,57,54,50,56,54,55,52,
		52,54,48,52,55,55,52,54,52,57,49,53,57,57,
		53,48,53,52,57,55,51,55,52,50,53,54,50,54,
		57,48,49,48,52,57,48,51,55,55,56,49,57,56,
		54,56,51,53,57,51,56,49,52,54,53,55,52,49,
		50,54,56,48,52,57,50,53,54,52,56,55,57,56,
		53,53,54,49,52,53,51,55,50,51,52,55,56,54,
		55,51,51,48,51,57,48,52,54,56,56,51,56,51,
		52,51,54,51,52,54,53,53,51,55,57,52,57,56,
		54,52,49,57,50,55,48,53,54,51,56,55,50,57,
		51,49,55,52,56,55,50,51,51,50,48,56,51,55,
		54,48,49,49,50,51,48,50,57,57,49,49,51,54,
		55,57,51,56,54,50,55,48,56,57,52,51,56,55,
		57,57,51,54,50,48,49,54,50,57,53,49,53,52,
		49,51,51,55,49,52,50,52,56,57,50,56,51,48,
		55,50,50,48,49,50,54,57,48,49,52,55,53,52,
		54,54,56,52,55,54,53,51,53,55,54,49,54,52,
		55,55,51,55,57,52,54,55,53,50,48,48,52,57,
		48,55,53,55,49,53,53,53,50,55,56,49,57,54,
		53,51,54,50,49,51,50,51,57,50,54,52,48,54,
		49,54,48,49,51,54,51,53,56,49,53,53,57,48,
		55,52,50,50,48,50,48,50,48,51,49,56,55,50,
		55,55,54,48,53,50,55,55,50,49,57,48,48,53,
		53,54,49,52,56,52,50,53,53,53,49,56,55,57,
		50,53,51,48,51,52,51,53,49,51,57,56,52,52,
		50,53,51,50,50,51,52,49,53,55,54,50,51,51,
		54,49,48,54,52,50,53,48,54,51,57,48,52,57,
		55,53,48,48,56,54,53,54,50,55,49,48,57,53,
		51,53,57,49,57,52,54,53,56,57,55,53,49,52,
		49,51,49,48,51,52,56,50,50,55,54,57,51,48,
		54,50,52,55,52,51,53,51,54,51,50,53,54,57,
		49,54,48,55,56,49,53,52,55,56,49,56,49,49,
		53,50,56,52,51,54,54,55,57,53,55,48,54,49,
		49,48,56,54,49,53,51,51,49,53,48,52,52,53,
		50,49,50,55,52,55,51,57,50,52,53,52,52,57,
		52,53,52,50,51,54,56,50,56,56,54,48,54,49,
		51,52,48,56,52,49,52,56,54,51,55,55,54,55,
		48,48,57,54,49,50,48,55,49,53,49,50,52,57,
		49,52,48,52,51,48,50,55,50,53,51,56,54,48,
		55,54,52,56,50,51,54,51,52,49,52,51,51,52,
		54,50,51,53,49,56,57,55,53,55,54,54,52,53,
		50,49,54,52,49,51,55,54,55,57,54,57,48,51,
		49,52,57,53,48,49,57,49,48,56,53,55,53,57,
		56,52,52,50,51,57,49,57,56,54,50,57,49,54,
		52,50,49,57,51,57,57,52,57,48,55,50,51,54,
		50,51,52,54,52,54,56,52,52,49,49,55,51,57,
		52,48,51,50,54,53,57,49,56,52,48,52,52,51,
		55,56,48,53,49,51,51,51,56,57,52,53,50,53,
		55,52,50,51,57,57,53,48,56,50,57,54,53,57,
		49,50,50,56,53,48,56,53,53,53,56,50,49,53,
		55,50,53,48,51,49,48,55,49,50,53,55,48,49,
		50,54,54,56,51,48,50,52,48,50,57,50,57,53,
		50,53,50,50,48,49,49,56,55,50,54,55,54,55,
		53,54,50,50,48,52,49,53,52,50,48,53,49,54,
		49,56,52,49,54,51,52,56,52,55,53,54,53,49,
		54,57,57,57,56,49,49,54,49,52,49,48,49,48,
		48,50,57,57,54,48,55,56,51,56,54,57,48,57,
		50,57,49,54,48,51,48,50,56,56,52,48,48,50,
		54,57,49,48,52,49,52,48,55,57,50,56,56,54,
		50,49,53,48,55,56,52,50,52,53,49,54,55,48,
		57,48,56,55,48,48,48,54,57,57,50,56,50,49,
		50,48,54,54,48,52,49,56,51,55,49,56,48,54,
		53,51,53,53,54,55,50,53,50,53,51,50,53,54,
		55,53,51,50,56,54,49,50,57,49,48,52,50,52,
		56,55,55,54,49,56,50,53,56,50,57,55,54,53,
		49,53,55,57,53,57,56,52,55,48,51,53,54,50,
		50,50,54,50,57,51,52,56,54,48,48,51,52,49,
		53,56,55,50,50,57,56,48,53,51,52,57,56,57,
		54,53,48,50,50,54,50,57,49,55,52,56,55,56,
		56,50,48,50,55,51,52,50,48,57,50,50,50,50,
		52,53,51,51,57,56,53,54,50,54,52,55,54,54,
		57,49,52,57,48,53,53,54,50,56,52,50,53,48,
		51,57,49,50,55,53,55,55,49,48,50,56,52,48,
		50,55,57,57,56,48,54,54,51,54,53,56,50,53,
		52,56,56,57,50,54,52,56,56,48,50,53,52,53,
		54,54,49,48,49,55,50,57,54,55,48,50,54,54,
		52,48,55,54,53,53,57,48,52,50,57,48,57,57,
		52,53,54,56,49,53,48,54,53,50,54,53,51,48,
		53,51,55,49,56,50,57,52,49,50,55,48,51,51,
		54,57,51,49,51,55,56,53,49,55,56,54,48,57,
		48,52,48,55,48,56,54,54,55,49,49,52,57,54,
		53,53,56,51,52,51,52,51,52,55,54,57,51,51,
		56,53,55,56,49,55,49,49,51,56,54,52,53,53,
		56,55,51,54,55,56,49,50,51,48,49,52,53,56,
		55,54,56,55,49,50,54,54,48,51,52,56,57,49,
		51,57,48,57,53,54,50,48,48,57,57,51,57,51,
		54,49,48,51,49,48,50,57,49,54,49,54,49,53,
		50,56,56,49,51,56,52,51,55,57,48,57,57,48,
		52,50,51,49,55,52,55,51,51,54,51,57,52,56,
		48,52,53,55,53,57,51,49,52,57,51,49,52,48,
		53,50,57,55,54,51,52,55,53,55,52,56,49,49,
		57,51,53,54,55,48,57,49,49,48,49,51,55,55,
		53,49,55,50,49,48,48,56,48,51,49,53,53,57,
		48,50,52,56,53,51,48,57,48,54,54,57,50,48,
		51,55,54,55,49,57,50,50,48,51,51,50,50,57,
		48,57,52,51,51,52,54,55,54,56,53,49,52,50,
		50,49,52,52,55,55,51,55,57,51,57,51,55,53,
		49,55,48,51,52,52,51,54,54,49,57,57,49,48,
		52,48,51,51,55,53,49,49,49,55,51,53,52,55,
		49,57,49,56,53,53,48,52,54,52,52,57,48,50,
		54,51,54,53,53,49,50,56,49,54,50,50,56,56,
		50,52,52,54,50,53,55,53,57,49,54,51,51,51,
		48,51,57,49,48,55,50,50,53,51,56,51,55,52,
		50,49,56,50,49,52,48,56,56,51,53,48,56,54,
		53,55,51,57,49,55,55,49,53,48,57,54,56,50,
		56,56,55,52,55,56,50,54,53,54,57,57,53,57,
		57,53,55,52,52,57,48,54,54,49,55,53,56,51,
		52,52,49,51,55,53,50,50,51,57,55,48,57,54,
		56,51,52,48,56,48,48,53,51,53,53,57,56,52,
		57,49,55,53,52,49,55,51,56,49,56,56,51,57,
		57,57,52,52,54,57,55,52,56,54,55,54,50,54,
		53,53,49,54,53,56,50,55,54,53,56,52,56,51,
		53,56,56,52,53,51,49,52,50,55,55,53,54,56,
		55,57,48,48,50,57,48,57,53,49,55,48,50,56,
		51,53,50,57,55,49,54,51,52,52,53,54,50,49,
		50,57,54,52,48,52,51,53,50,51,49,49,55,54,
		48,48,54,54,53,49,48,49,50,52,49,50,48,48,
		54,53,57,55,53,53,56,53,49,50,55,54,49,55,
		56,53,56,51,56,50,57,50,48,52,49,57,55,52,
		56,52,52,50,51,54,48,56,48,48,55,49,57,51,
		48,52,53,55,54,49,56,57,51,50,51,52,57,50,
		50,57,50,55,57,54,53,48,49,57,56,55,53,49,
		56,55,50,49,50,55,50,54,55,53,48,55,57,56,
		49,50,53,53,52,55,48,57,53,56,57,48,52,53,
		53,54,51,53,55,57,50,49,50,50,49,48,51,51,
		51,52,54,54,57,55,52,57,57,50,51,53,54,51,
		48,50,53,52,57,52,55,56,48,50,52,57,48,49,
		49,52,49,57,53,50,49,50,51,56,50,56,49,53,
		51,48,57,49,49,52,48,55,57,48,55,51,56,54,
		48,50,53,49,53,50,50,55,52,50,57,57,53,56,
		49,56,48,55,50,52,55,49,54,50,53,57,49,54,
		54,56,53,52,53,49,51,51,51,49,50,51,57,52,
		56,48,52,57,52,55,48,55,57,49,49,57,49,53,
		51,50,54,55,51,52,51,48,50,56,50,52,52,49,
		56,54,48,52,49,52,50,54,51,54,51,57,53,52,
		56,48,48,48,52,52,56,48,48,50,54,55,48,52,
		57,54,50,52,56,50,48,49,55,57,50,56,57,54,
		52,55,54,54,57,55,53,56,51,49,56,51,50,55,
		49,51,49,52,50,53,49,55,48,50,57,54,57,50,
		51,52,56,56,57,54,50,55,54,54,56,52,52,48,
		51,50,51,50,54,48,57,50,55,53,50,52,57,54,
		48,51,53,55,57,57,54,52,54,57,50,53,54,53,
		48,52,57,51,54,56,49,56,51,54,48,57,48,48,
		51,50,51,56,48,57,50,57,51,52,53,57,53,56,
		56,57,55,48,54,57,53,51,54,53,51,52,57,52,
		48,54,48,51,52,48,50,49,54,54,53,52,52,51,
		55,53,53,56,57,48,48,52,53,54,51,50,56,56,
		50,50,53,48,53,52,53,50,53,53,54,52,48,53,
		54,52,52,56,50,52,54,53,49,53,49,56,55,53,
		52,55,49,49,57,54,50,49,56,52,52,51,57,54,
		53,56,50,53,51,51,55,53,52,51,56,56,53,54,
		57,48,57,52,49,49,51,48,51,49,53,48,57,53,
		50,54,49,55,57,51,55,56,48,48,50,57,55,52,
		49,50,48,55,54,54,53,49,52,55,57,51,57,52,
		50,53,57,48,50,57,56,57,54,57,53,57,52,54,
		57,57,53,53,54,53,55,54,49,50,49,56,54,53,
		54,49,57,54,55,51,51,55,56,54,50,51,54,50,
		53,54,49,50,53,50,49,54,51,50,48,56,54,50,
		56,54,57,50,50,50,49,48,51,50,55,52,56,56,
		57,50,49,56,54,53,52,51,54,52,56,48,50,50,
		57,54,55,56,48,55,48,53,55,54,53,54,49,53,
		49,52,52,54,51,50,48,52,54,57,50,55,57,48,
		54,56,50,49,50,48,55,51,56,56,51,55,55,56,
		49,52,50,51,51,53,54,50,56,50,51,54,48,56,
		57,54,51,50,48,56,48,54,56,50,50,50,52,54,
		56,48,49,50,50,52,56,50,54,49,49,55,55,49,
		56,53,56,57,54,51,56,49,52,48,57,49,56,51,
		57,48,51,54,55,51,54,55,50,50,50,48,56,56,
		56,51,50,49,53,49,51,55,53,53,54,48,48,51,
		55,50,55,57,56,51,57,52,48,48,52,49,53,50,
		57,55,48,48,50,56,55,56,51,48,55,54,54,55,
		48,57,52,52,52,55,52,53,54,48,49,51,52,53,
		53,54,52,49,55,50,53,52,51,55,48,57,48,54,
		57,55,57,51,57,54,49,50,50,53,55,49,52,50,
		57,56,57,52,54,55,49,53,52,51,53,55,56,52,
		54,56,55,56,56,54,49,52,52,52,53,56,49,50,
		51,49,52,53,57,51,53,55,49,57,56,52,57,50,
		50,53,50,56,52,55,49,54,48,53,48,52,57,50,
		50,49,50,52,50,52,55,48,49,52,49,50,49,52,
		55,56,48,53,55,51,52,53,53,49,48,53,48,48,
		56,48,49,57,48,56,54,57,57,54,48,51,51,48,
		50,55,54,51,52,55,56,55,48,56,49,48,56,49,
		55,53,52,53,48,49,49,57,51,48,55,49,52,49,
		50,50,51,51,57,48,56,54,54,51,57,51,56,51,
		51,57,53,50,57,52,50,53,55,56,54,57,48,53,
		48,55,54,52,51,49,48,48,54,51,56,51,53,49,
		57,56,51,52,51,56,57,51,52,49,53,57,54,49,
		51,49,56,53,52,51,52,55,53,52,54,52,57,53,
		53,54,57,55,56,49,48,51,56,50,57,51,48,57,
		55,49,54,52,54,53,49,52,51,56,52,48,55,48,
		48,55,48,55,51,54,48,52,49,49,50,51,55,51,
		53,57,57,56,52,51,52,53,50,50,53,49,54,49,
		48,53,48,55,48,50,55,48,53,54,50,51,53,50,
		54,54,48,49,50,55,54,52,56,52,56,51,48,56,
		52,48,55,54,49,49,56,51,48,49,51,48,53,50,
		55,57,51,50,48,53,52,50,55,52,54,50,56,54,
		53,52,48,51,54,48,51,54,55,52,53,51,50,56,
		54,53,49,48,53,55,48,54,53,56,55,52,56,56,
		50,50,53,54,57,56,49,53,55,57,51,54,55,56,
		57,55,54,54,57,55,52,50,50,48,53,55,53,48,
		53,57,54,56,51,52,52,48,56,54,57,55,51,53,
		48,50,48,49,52,49,48,50,48,54,55,50,51,53,
		56,53,48,50,48,48,55,50,52,53,50,50,53,54,
		51,50,54,53,49,51,52,49,48,53,53,57,50,52,
		48,49,57,48,50,55,52,50,49,54,50,52,56,52,
		51,57,49,52,48,51,53,57,57,56,57,53,51,53,
		51,57,52,53,57,48,57,52,52,48,55,48,52,54,
		57,49,50,48,57,49,52,48,57,51,56,55,48,48,
		49,50,54,52,53,54,48,48,49,54,50,51,55,52,
		50,56,56,48,50,49,48,57,50,55,54,52,53,55,
		57,51,49,48,54,53,55,57,50,50,57,53,53,50,
		52,57,56,56,55,50,55,53,56,52,54,49,48,49,
		50,54,52,56,51,54,57,57,57,56,57,50,50,53,
		54,57,53,57,54,56,56,49,53,57,50,48,53,54,
		48,48,49,48,49,54,53,53,50,53,54,51,55,53,
		54,56,0,82,1,0,7
	};

	hb_vmExecute( pcode, symbols );
}

