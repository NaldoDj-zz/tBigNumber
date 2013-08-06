#pragma BEGINDUMP

	#include <math.h>
	#include "hbapi.h"

	float Q_rsqrt( float number , int nIt );
	
	/*
	** float q_rsqrt( float number ) Fast SQRT From QUAKE III on q_math.c
	*/
	float Q_rsqrt( float number, int nIt ) {
		
		int x;
		long i;
		float x2, y;
		const float threehalfs = 1.5F;
	 
		x2 = number * 0.5F;
		y  = number;
		i  = * ( long * ) &y;     		// evil floating point bit level hacking
		i  = 0x5f3759df - ( i >> 1 );	// what the fuck?
		y  = * ( float * ) &i;

		for ( x = 1 ; x <= nIt ; ++x )
		{		
			/* This line can be repeated arbitrarily many times to increase accuracy */
			y  = y * ( threehalfs - ( x2 * y * y ) );
		}	
	 
		return y;
	}

	HB_FUNC ( HB_Q_SQRT )
	{
		float t = hb_parnd(1);
		int   i = hb_parni(2);
		
		hb_retnd( Q_rsqrt(t,i) );
	}

#pragma ENDDUMP	