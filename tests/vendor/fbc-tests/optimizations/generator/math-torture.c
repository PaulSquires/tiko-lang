typedef   signed char       int8;
typedef unsigned char      uint8;
typedef   signed short      int16;
typedef unsigned short     uint16;
typedef   signed int        int32;
typedef unsigned int       uint32;
typedef   signed long long  int64;
typedef unsigned long long uint64;
typedef struct { char *data; int64 len; int64 size; } FBSTRING;
typedef struct { uint16 *data; int64 len; int64 size; } FBUSTRING;
typedef int8 boolean;
struct $7ASTNODE;
struct $7ASTNODE {
	int64 ID;
	int64 OP;
	FBSTRING VARNAME;
	int64 VALUE;
	struct $7ASTNODE* L;
	struct $7ASTNODE* R;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $7ASTNODE ) == 64 );
struct $11OPERANDDATA {
	char VARNAME[32];
	int64 VALUE;
};
__FB_STATIC_ASSERT( sizeof( struct $11OPERANDDATA ) == 40 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $8FBARRAY1IcE {
	char* DATA;
	char* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IcE ) == 72 );
#define fb_D2L( value ) ((int64)__builtin_nearbyint( value ))
int32 fb_FileOpen( FBSTRING*, uint32, uint32, uint32, int32, int32 );
int32 fb_FileClose( int32 );
int32 fb_FileFree( void );
void* calloc( uint64, uint64 );
void free( void* );
void fb_PrintVoid( int32, int32 );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrConcatAssign( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAllocTempResult( FBSTRING* );
FBSTRING* fb_StrAllocTempDescZ( char* );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
FBSTRING* fb_LongintToStr( int64 );
FBSTRING* fb_StrFill2( int64, FBSTRING* );
int64 fb_StrLen( void*, int64 );
void fb_End( int32 );
FBSTRING* fb_ExePath( void );
static void fb_ctor__mathztorture( void ) __attribute__(( constructor ));
static void _ZN7ASTNODEaSERKS_( struct $7ASTNODE*, struct $7ASTNODE* );
struct $7ASTNODE* ASTNEW( int64 );
struct $7ASTNODE* ASTNEWCONST( int64 );
struct $7ASTNODE* ASTNEWVAR( FBSTRING*, int64 );
struct $7ASTNODE* ASTNEWOPERAND( int64 );
struct $7ASTNODE* ASTNEWBOP( int64, struct $7ASTNODE*, struct $7ASTNODE* );
void ASTDELETE( struct $7ASTNODE* );
FBSTRING* ASTASSTRING( struct $7ASTNODE* );
int64 ASTCOUNTPUREBOPS( struct $7ASTNODE*, int64 );
int64 ASTCOUNTVAR( struct $7ASTNODE*, FBSTRING* );
int64 ASTCOUNTCONST( struct $7ASTNODE*, int64 );
int64 ASTCOUNTDEADBOPS( struct $7ASTNODE* );
int64 ASTISGOODTESTCASE( struct $7ASTNODE* );
void EMITLINE( FBSTRING* );
void EMITINDENT( void );
void EMITUNINDENT( void );
void EMITASSERTEQUAL( FBSTRING*, int64 );
void EMITBEGIN( void );
void EMITEND( void );
void EMITTEST( struct $7ASTNODE* );
static struct $11OPERANDDATA POSSIBLEOPERANDS$[4] = { { "a", 1ll }, { "b", 2ll }, { "", -2ll }, { "", -1ll } };
struct $8CTXSTUFF {
	char FILENAME[256];
	int64 FNUM;
	int64 INDENT;
	int64 TESTCOUNT;
	int64 FILECOUNT;
	int64 TOTALCOUNT;
	int64 COUNT;
	int64 PERCENT;
};
__FB_STATIC_ASSERT( sizeof( struct $8CTXSTUFF ) == 312 );
static struct $8CTXSTUFF CTX$;

struct $7ASTNODE* ASTNEW( int64 ID$1 )
{
	struct $7ASTNODE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$10:;
	struct $7ASTNODE* N$1;
	void* vr$1 = calloc( 64ull, 1ull );
	N$1 = (struct $7ASTNODE*)vr$1;
	*(int64*)N$1 = ID$1;
	fb$result$1 = N$1;
	label$11:;
	return fb$result$1;
}

struct $7ASTNODE* ASTNEWCONST( int64 VALUE$1 )
{
	struct $7ASTNODE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$12:;
	struct $7ASTNODE* N$1;
	struct $7ASTNODE* vr$1 = ASTNEW( 1ll );
	N$1 = vr$1;
	*(int64*)((uint8*)N$1 + 40ll) = VALUE$1;
	fb$result$1 = N$1;
	label$13:;
	return fb$result$1;
}

struct $7ASTNODE* ASTNEWVAR( FBSTRING* VARNAME$1, int64 VALUE$1 )
{
	struct $7ASTNODE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$14:;
	struct $7ASTNODE* N$1;
	struct $7ASTNODE* vr$1 = ASTNEW( 0ll );
	N$1 = vr$1;
	fb_StrAssign( (void*)((uint8*)N$1 + 16ll), -1ll, (void*)VARNAME$1, -1ll, 0 );
	*(int64*)((uint8*)N$1 + 40ll) = VALUE$1;
	fb$result$1 = N$1;
	label$15:;
	return fb$result$1;
}

struct $7ASTNODE* ASTNEWOPERAND( int64 I$1 )
{
	struct $7ASTNODE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$16:;
	int64 vr$3 = fb_StrLen( (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$1 * 40ll)), 32ll );
	if( vr$3 <= 0ll) goto label$19;
	{
		FBSTRING TMP$7$2;
		__builtin_memset( &TMP$7$2, 0, 24ll );
		fb_StrAssign( (void*)&TMP$7$2, -1ll, (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$1 * 40ll)), 32ll, 0 );
		struct $7ASTNODE* vr$10 = ASTNEWVAR( &TMP$7$2, *(int64*)(((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$1 * 40ll)) + 32ll) );
		fb_StrAssign( (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$1 * 40ll)), 32ll, (void*)&TMP$7$2, -1ll, 0 );
		fb$result$1 = vr$10;
		fb_StrDelete( (FBSTRING*)&TMP$7$2 );
	}
	goto label$18;
	label$19:;
	{
		struct $7ASTNODE* vr$16 = ASTNEWCONST( *(int64*)(((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$1 * 40ll)) + 32ll) );
		fb$result$1 = vr$16;
	}
	label$18:;
	label$17:;
	return fb$result$1;
}

struct $7ASTNODE* ASTNEWBOP( int64 OP$1, struct $7ASTNODE* L$1, struct $7ASTNODE* R$1 )
{
	struct $7ASTNODE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$20:;
	struct $7ASTNODE* N$1;
	struct $7ASTNODE* vr$1 = ASTNEW( 2ll );
	N$1 = vr$1;
	*(int64*)((uint8*)N$1 + 8ll) = OP$1;
	*(struct $7ASTNODE**)((uint8*)N$1 + 48ll) = L$1;
	*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) = R$1;
	{
		if( OP$1 != 0ll) goto label$23;
		label$24:;
		{
			*(int64*)((uint8*)N$1 + 40ll) = *(int64*)((uint8*)L$1 + 40ll) + *(int64*)((uint8*)R$1 + 40ll);
		}
		goto label$22;
		label$23:;
		if( OP$1 != 1ll) goto label$25;
		label$26:;
		{
			*(int64*)((uint8*)N$1 + 40ll) = *(int64*)((uint8*)L$1 + 40ll) - *(int64*)((uint8*)R$1 + 40ll);
		}
		goto label$22;
		label$25:;
		if( OP$1 != 2ll) goto label$27;
		label$28:;
		{
			*(int64*)((uint8*)N$1 + 40ll) = *(int64*)((uint8*)L$1 + 40ll) * *(int64*)((uint8*)R$1 + 40ll);
		}
		goto label$22;
		label$27:;
		{
		}
		label$29:;
		label$22:;
	}
	fb$result$1 = N$1;
	label$21:;
	return fb$result$1;
}

void ASTDELETE( struct $7ASTNODE* N$1 )
{
	label$30:;
	if( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll) == (struct $7ASTNODE*)0ull) goto label$33;
	{
		ASTDELETE( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll) );
	}
	label$33:;
	label$32:;
	if( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll) == (struct $7ASTNODE*)0ull) goto label$35;
	{
		ASTDELETE( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll) );
	}
	label$35:;
	label$34:;
	fb_StrAssign( (void*)((uint8*)N$1 + 16ll), -1ll, (void*)"", 1ll, 0 );
	free( (void*)N$1 );
	label$31:;
}

FBSTRING* ASTASSTRING( struct $7ASTNODE* N$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$36:;
	static char OPTEXT$1[3][4] = { " + ", " - ", " * " };
	static struct $8FBARRAY1IcE tmp$8$1 = { (char*)OPTEXT$1, (char*)OPTEXT$1, 12ll, 4ll, 1ll, 49ll, { { 3ll, 0ll, 2ll } } };
	FBSTRING S$1;
	__builtin_memset( &S$1, 0, 24ll );
	{
		int64 TMP$12$2;
		TMP$12$2 = *(int64*)N$1;
		if( TMP$12$2 != 0ll) goto label$39;
		label$40:;
		{
			FBSTRING TMP$13$3;
			__builtin_memset( &TMP$13$3, 0, 24ll );
			FBSTRING* vr$8 = fb_StrConcat( &TMP$13$3, (void*)&S$1, -1ll, (void*)((uint8*)N$1 + 16ll), -1ll );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$8, -1ll, 0 );
		}
		goto label$38;
		label$39:;
		if( TMP$12$2 != 1ll) goto label$41;
		label$42:;
		{
			FBSTRING TMP$14$3;
			FBSTRING* vr$11 = fb_LongintToStr( *(int64*)((uint8*)N$1 + 40ll) );
			__builtin_memset( &TMP$14$3, 0, 24ll );
			FBSTRING* vr$15 = fb_StrConcat( &TMP$14$3, (void*)&S$1, -1ll, (void*)vr$11, -1ll );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$15, -1ll, 0 );
		}
		goto label$38;
		label$41:;
		if( TMP$12$2 != 2ll) goto label$43;
		label$44:;
		{
			FBSTRING TMP$16$3;
			FBSTRING TMP$17$3;
			FBSTRING TMP$18$3;
			fb_StrConcatAssign( (void*)&S$1, -1ll, (void*)"(", 2ll, 0 );
			FBSTRING* vr$19 = ASTASSTRING( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll) );
			__builtin_memset( &TMP$16$3, 0, 24ll );
			FBSTRING* vr$23 = fb_StrConcat( &TMP$16$3, (void*)&S$1, -1ll, (void*)vr$19, -1ll );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$23, -1ll, 0 );
			__builtin_memset( &TMP$17$3, 0, 24ll );
			FBSTRING* vr$31 = fb_StrConcat( &TMP$17$3, (void*)&S$1, -1ll, (void*)((int64)(char*)OPTEXT$1 + (*(int64*)((uint8*)N$1 + 8ll) << (2ll & 63ll))), 4ll );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$31, -1ll, 0 );
			FBSTRING* vr$34 = ASTASSTRING( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll) );
			__builtin_memset( &TMP$18$3, 0, 24ll );
			FBSTRING* vr$38 = fb_StrConcat( &TMP$18$3, (void*)&S$1, -1ll, (void*)vr$34, -1ll );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$38, -1ll, 0 );
			fb_StrConcatAssign( (void*)&S$1, -1ll, (void*)")", 2ll, 0 );
		}
		label$43:;
		label$38:;
	}
	fb_StrAssign( (void*)&fb$result$1, -1ll, (void*)&S$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&S$1 );
	label$37:;
	FBSTRING* vr$45 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$45;
}

int64 ASTCOUNTPUREBOPS( struct $7ASTNODE* N$1, int64 LEAFID$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$45:;
	if( *(int64*)N$1 != 2ll) goto label$48;
	{
		if( ((int64)-(*(int64*)*(struct $7ASTNODE**)((uint8*)N$1 + 48ll) == LEAFID$1) & (int64)-(*(int64*)*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) == LEAFID$1)) == 0ll) goto label$50;
		{
			fb$result$1 = 1ll;
		}
		goto label$49;
		label$50:;
		{
			int64 vr$10 = ASTCOUNTPUREBOPS( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll), LEAFID$1 );
			int64 vr$12 = ASTCOUNTPUREBOPS( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll), LEAFID$1 );
			fb$result$1 = vr$10 + vr$12;
		}
		label$49:;
	}
	goto label$47;
	label$48:;
	{
		fb$result$1 = 0ll;
	}
	label$47:;
	label$46:;
	return fb$result$1;
}

int64 ASTCOUNTVAR( struct $7ASTNODE* N$1, FBSTRING* VARNAME$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$51:;
	{
		int64 TMP$20$2;
		TMP$20$2 = *(int64*)N$1;
		if( TMP$20$2 != 0ll) goto label$54;
		label$55:;
		{
			int32 vr$4 = fb_StrCompare( (void*)((uint8*)N$1 + 16ll), -1ll, (void*)VARNAME$1, -1ll );
			if( (int64)vr$4 != 0ll) goto label$57;
			{
				fb$result$1 = 1ll;
			}
			goto label$56;
			label$57:;
			{
				fb$result$1 = 0ll;
			}
			label$56:;
		}
		goto label$53;
		label$54:;
		if( TMP$20$2 != 2ll) goto label$58;
		label$59:;
		{
			int64 vr$7 = ASTCOUNTVAR( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll), VARNAME$1 );
			int64 vr$9 = ASTCOUNTVAR( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll), VARNAME$1 );
			fb$result$1 = vr$7 + vr$9;
		}
		goto label$53;
		label$58:;
		{
			fb$result$1 = 0ll;
		}
		label$60:;
		label$53:;
	}
	label$52:;
	return fb$result$1;
}

int64 ASTCOUNTCONST( struct $7ASTNODE* N$1, int64 VALUE$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$61:;
	{
		int64 TMP$21$2;
		TMP$21$2 = *(int64*)N$1;
		if( TMP$21$2 != 1ll) goto label$64;
		label$65:;
		{
			if( *(int64*)((uint8*)N$1 + 40ll) != VALUE$1) goto label$67;
			{
				fb$result$1 = 1ll;
			}
			goto label$66;
			label$67:;
			{
				fb$result$1 = 0ll;
			}
			label$66:;
		}
		goto label$63;
		label$64:;
		if( TMP$21$2 != 2ll) goto label$68;
		label$69:;
		{
			int64 vr$4 = ASTCOUNTCONST( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll), VALUE$1 );
			int64 vr$6 = ASTCOUNTCONST( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll), VALUE$1 );
			fb$result$1 = vr$4 + vr$6;
		}
		goto label$63;
		label$68:;
		{
			fb$result$1 = 0ll;
		}
		label$70:;
		label$63:;
	}
	label$62:;
	return fb$result$1;
}

int64 ASTCOUNTDEADBOPS( struct $7ASTNODE* N$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$71:;
	int64 COUNT$1;
	COUNT$1 = 0ll;
	if( *(int64*)N$1 != 2ll) goto label$74;
	{
		{
			int64 TMP$22$3;
			TMP$22$3 = *(int64*)((uint8*)N$1 + 8ll);
			if( TMP$22$3 != 0ll) goto label$76;
			label$77:;
			{
				if( *(int64*)*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) != 1ll) goto label$79;
				{
					if( *(int64*)((uint8*)*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) + 40ll) != 0ll) goto label$81;
					{
						COUNT$1 = COUNT$1 + 1ll;
					}
					label$81:;
					label$80:;
				}
				label$79:;
				label$78:;
			}
			goto label$75;
			label$76:;
			if( TMP$22$3 != 2ll) goto label$82;
			label$83:;
			{
				if( *(int64*)*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) != 1ll) goto label$85;
				{
					if( *(int64*)((uint8*)*(struct $7ASTNODE**)((uint8*)N$1 + 56ll) + 40ll) != 1ll) goto label$87;
					{
						COUNT$1 = COUNT$1 + 1ll;
					}
					label$87:;
					label$86:;
				}
				label$85:;
				label$84:;
			}
			label$82:;
			label$75:;
		}
		int64 vr$14 = ASTCOUNTDEADBOPS( *(struct $7ASTNODE**)((uint8*)N$1 + 48ll) );
		COUNT$1 = COUNT$1 + vr$14;
		int64 vr$17 = ASTCOUNTDEADBOPS( *(struct $7ASTNODE**)((uint8*)N$1 + 56ll) );
		COUNT$1 = COUNT$1 + vr$17;
	}
	label$74:;
	label$73:;
	fb$result$1 = COUNT$1;
	label$72:;
	return fb$result$1;
}

int64 ASTISGOODTESTCASE( struct $7ASTNODE* AST$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$88:;
	fb$result$1 = 0ll;
	int64 vr$1 = ASTCOUNTPUREBOPS( AST$1, 1ll );
	if( vr$1 <= 0ll) goto label$91;
	{
		goto label$89;
	}
	label$91:;
	label$90:;
	int64 vr$2 = ASTCOUNTPUREBOPS( AST$1, 0ll );
	if( vr$2 <= 0ll) goto label$93;
	{
		goto label$89;
	}
	label$93:;
	label$92:;
	int64 vr$3 = ASTCOUNTDEADBOPS( AST$1 );
	if( vr$3 <= 0ll) goto label$95;
	{
		goto label$89;
	}
	label$95:;
	label$94:;
	{
		int64 I$2;
		I$2 = 0ll;
		label$99:;
		{
			int64 vr$6 = fb_StrLen( (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)), 32ll );
			if( vr$6 <= 0ll) goto label$101;
			{
				FBSTRING TMP$23$4;
				int64 TMP$24$4;
				__builtin_memset( &TMP$23$4, 0, 24ll );
				fb_StrAssign( (void*)&TMP$23$4, -1ll, (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)), 32ll, 0 );
				int64 vr$12 = ASTCOUNTVAR( AST$1, &TMP$23$4 );
				fb_StrAssign( (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)), 32ll, (void*)&TMP$23$4, -1ll, 0 );
				TMP$24$4 = (int64)-(vr$12 > 1ll);
				fb_StrDelete( (FBSTRING*)&TMP$23$4 );
				if( TMP$24$4 == 0ll) goto label$103;
				{
					goto label$89;
				}
				label$103:;
				label$102:;
			}
			goto label$100;
			label$101:;
			{
				int64 vr$19 = ASTCOUNTCONST( AST$1, *(int64*)(((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)) + 32ll) );
				if( vr$19 <= 2ll) goto label$105;
				{
					goto label$89;
				}
				label$105:;
				label$104:;
			}
			label$100:;
		}
		label$97:;
		I$2 = I$2 + 1ll;
		label$96:;
		if( I$2 <= 3ll) goto label$99;
		label$98:;
	}
	fb$result$1 = -1ll;
	label$89:;
	return fb$result$1;
}

void EMITLINE( FBSTRING* S$1 )
{
	int64 TMP$25$1;
	FBSTRING TMP$27$1;
	label$106:;
	TMP$25$1 = *(int64*)((uint8*)&CTX$ + 256ll);
	FBSTRING* vr$0 = fb_StrAllocTempDescZEx( (char*)"\x09", 1ll );
	FBSTRING* vr$1 = fb_StrFill2( *(int64*)((uint8*)&CTX$ + 264ll), (FBSTRING*)vr$0 );
	__builtin_memset( &TMP$27$1, 0, 24ll );
	FBSTRING* vr$4 = fb_StrConcat( &TMP$27$1, (void*)vr$1, -1ll, (void*)S$1, -1ll );
	fb_PrintString( (int32)TMP$25$1, (FBSTRING*)vr$4, 1 );
	label$107:;
}

void EMITINDENT( void )
{
	label$108:;
	*(int64*)((uint8*)&CTX$ + 264ll) = *(int64*)((uint8*)&CTX$ + 264ll) + 1ll;
	label$109:;
}

void EMITUNINDENT( void )
{
	label$110:;
	*(int64*)((uint8*)&CTX$ + 264ll) = *(int64*)((uint8*)&CTX$ + 264ll) + -1ll;
	label$111:;
}

void EMITASSERTEQUAL( FBSTRING* EXPR$1, int64 VALUE$1 )
{
	FBSTRING TMP$31$1;
	FBSTRING TMP$32$1;
	FBSTRING TMP$33$1;
	FBSTRING TMP$34$1;
	FBSTRING TMP$35$1;
	label$112:;
	__builtin_memset( &TMP$35$1, 0, 24ll );
	FBSTRING* vr$1 = fb_LongintToStr( VALUE$1 );
	__builtin_memset( &TMP$31$1, 0, 24ll );
	FBSTRING* vr$4 = fb_StrConcat( &TMP$31$1, (void*)"t( ", 4ll, (void*)EXPR$1, -1ll );
	__builtin_memset( &TMP$32$1, 0, 24ll );
	FBSTRING* vr$7 = fb_StrConcat( &TMP$32$1, (void*)vr$4, -1ll, (void*)" = ", 4ll );
	__builtin_memset( &TMP$33$1, 0, 24ll );
	FBSTRING* vr$10 = fb_StrConcat( &TMP$33$1, (void*)vr$7, -1ll, (void*)vr$1, -1ll );
	__builtin_memset( &TMP$34$1, 0, 24ll );
	FBSTRING* vr$13 = fb_StrConcat( &TMP$34$1, (void*)vr$10, -1ll, (void*)" )", 3ll );
	fb_StrAssign( (void*)&TMP$35$1, -1ll, (void*)vr$13, -1ll, 0 );
	EMITLINE( &TMP$35$1 );
	fb_StrDelete( (FBSTRING*)&TMP$35$1 );
	label$113:;
}

void EMITBEGIN( void )
{
	FBSTRING TMP$38$1;
	FBSTRING TMP$39$1;
	FBSTRING TMP$52$1;
	FBSTRING TMP$53$1;
	FBSTRING TMP$55$1;
	FBSTRING TMP$56$1;
	FBSTRING TMP$58$1;
	FBSTRING TMP$59$1;
	FBSTRING TMP$60$1;
	FBSTRING TMP$61$1;
	FBSTRING TMP$63$1;
	FBSTRING TMP$64$1;
	FBSTRING TMP$65$1;
	FBSTRING TMP$67$1;
	label$114:;
	FBSTRING FILENAME$1;
	__builtin_memset( &FILENAME$1, 0, 24ll );
	FBSTRING* vr$1 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 280ll) );
	__builtin_memset( &TMP$38$1, 0, 24ll );
	FBSTRING* vr$4 = fb_StrConcat( &TMP$38$1, (void*)"math-torture-", 14ll, (void*)vr$1, -1ll );
	__builtin_memset( &TMP$39$1, 0, 24ll );
	FBSTRING* vr$7 = fb_StrConcat( &TMP$39$1, (void*)vr$4, -1ll, (void*)".bas", 5ll );
	fb_StrAssign( (void*)&CTX$, 256ll, (void*)vr$7, -1ll, 0 );
	int32 vr$9 = fb_FileFree(  );
	*(int64*)((uint8*)&CTX$ + 256ll) = (int64)vr$9;
	FBSTRING* vr$12 = fb_StrAllocTempDescZ( (char*)&CTX$ );
	fb_PrintString( 0, (FBSTRING*)vr$12, 0 );
	FBSTRING* vr$13 = fb_ExePath(  );
	fb_StrAssign( (void*)&FILENAME$1, -1ll, (void*)vr$13, -1ll, 0 );
	fb_StrConcatAssign( (void*)&FILENAME$1, -1ll, (void*)"/../", 5ll, 0 );
	fb_StrConcatAssign( (void*)&FILENAME$1, -1ll, (void*)&CTX$, 256ll, 0 );
	int32 vr$20 = fb_FileOpen( (FBSTRING*)&FILENAME$1, 3u, 0u, 0u, (int32)*(int64*)((uint8*)&CTX$ + 256ll), 0 );
	if( (int64)vr$20 == 0ll) goto label$117;
	{
		FBSTRING TMP$43$2;
		FBSTRING TMP$44$2;
		__builtin_memset( &TMP$43$2, 0, 24ll );
		FBSTRING* vr$25 = fb_StrConcat( &TMP$43$2, (void*)"could not open file: '", 23ll, (void*)&FILENAME$1, -1ll );
		__builtin_memset( &TMP$44$2, 0, 24ll );
		FBSTRING* vr$28 = fb_StrConcat( &TMP$44$2, (void*)vr$25, -1ll, (void*)"'", 2ll );
		fb_PrintString( 0, (FBSTRING*)vr$28, 1 );
		fb_End( 1 );
	}
	label$117:;
	label$116:;
	__builtin_memset( &TMP$52$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$52$1, -1ll, (void*)"'' Automatically generated by tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cgenerator\x5Cmath-torture.bas, 2026-08-28", 106ll, 0 );
	EMITLINE( &TMP$52$1 );
	fb_StrDelete( (FBSTRING*)&TMP$52$1 );
	__builtin_memset( &TMP$53$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$53$1, -1ll, (void*)"", 1ll, 0 );
	EMITLINE( &TMP$53$1 );
	fb_StrDelete( (FBSTRING*)&TMP$53$1 );
	__builtin_memset( &TMP$55$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$55$1, -1ll, (void*)"#include \x22" "fbcunit.bi\x22", 22ll, 0 );
	EMITLINE( &TMP$55$1 );
	fb_StrDelete( (FBSTRING*)&TMP$55$1 );
	__builtin_memset( &TMP$56$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$56$1, -1ll, (void*)"", 1ll, 0 );
	EMITLINE( &TMP$56$1 );
	fb_StrDelete( (FBSTRING*)&TMP$56$1 );
	__builtin_memset( &TMP$60$1, 0, 24ll );
	FBSTRING* vr$46 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 280ll) );
	__builtin_memset( &TMP$58$1, 0, 24ll );
	FBSTRING* vr$49 = fb_StrConcat( &TMP$58$1, (void*)"SUITE( fbc_tests.optimizations.math_torture_", 45ll, (void*)vr$46, -1ll );
	__builtin_memset( &TMP$59$1, 0, 24ll );
	FBSTRING* vr$52 = fb_StrConcat( &TMP$59$1, (void*)vr$49, -1ll, (void*)" )", 3ll );
	fb_StrAssign( (void*)&TMP$60$1, -1ll, (void*)vr$52, -1ll, 0 );
	EMITLINE( &TMP$60$1 );
	fb_StrDelete( (FBSTRING*)&TMP$60$1 );
	__builtin_memset( &TMP$61$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$61$1, -1ll, (void*)"", 1ll, 0 );
	EMITLINE( &TMP$61$1 );
	fb_StrDelete( (FBSTRING*)&TMP$61$1 );
	EMITINDENT(  );
	__builtin_memset( &TMP$65$1, 0, 24ll );
	FBSTRING* vr$61 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 280ll) );
	__builtin_memset( &TMP$63$1, 0, 24ll );
	FBSTRING* vr$64 = fb_StrConcat( &TMP$63$1, (void*)"TEST( test", 11ll, (void*)vr$61, -1ll );
	__builtin_memset( &TMP$64$1, 0, 24ll );
	FBSTRING* vr$67 = fb_StrConcat( &TMP$64$1, (void*)vr$64, -1ll, (void*)" )", 3ll );
	fb_StrAssign( (void*)&TMP$65$1, -1ll, (void*)vr$67, -1ll, 0 );
	EMITLINE( &TMP$65$1 );
	fb_StrDelete( (FBSTRING*)&TMP$65$1 );
	EMITINDENT(  );
	__builtin_memset( &TMP$67$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$67$1, -1ll, (void*)"#define t( x ) CU_ASSERT( x )", 30ll, 0 );
	EMITLINE( &TMP$67$1 );
	fb_StrDelete( (FBSTRING*)&TMP$67$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$121:;
		{
			int64 vr$77 = fb_StrLen( (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)), 32ll );
			if( vr$77 <= 0ll) goto label$123;
			{
				FBSTRING TMP$69$4;
				FBSTRING TMP$70$4;
				FBSTRING TMP$71$4;
				FBSTRING TMP$72$4;
				__builtin_memset( &TMP$72$4, 0, 24ll );
				FBSTRING* vr$80 = fb_LongintToStr( *(int64*)(((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)) + 32ll) );
				__builtin_memset( &TMP$69$4, 0, 24ll );
				FBSTRING* vr$85 = fb_StrConcat( &TMP$69$4, (void*)"dim as integer ", 16ll, (void*)((int64)(struct $11OPERANDDATA*)POSSIBLEOPERANDS$ + (I$2 * 40ll)), 32ll );
				__builtin_memset( &TMP$70$4, 0, 24ll );
				FBSTRING* vr$88 = fb_StrConcat( &TMP$70$4, (void*)vr$85, -1ll, (void*)" = ", 4ll );
				__builtin_memset( &TMP$71$4, 0, 24ll );
				FBSTRING* vr$91 = fb_StrConcat( &TMP$71$4, (void*)vr$88, -1ll, (void*)vr$80, -1ll );
				fb_StrAssign( (void*)&TMP$72$4, -1ll, (void*)vr$91, -1ll, 0 );
				EMITLINE( &TMP$72$4 );
				fb_StrDelete( (FBSTRING*)&TMP$72$4 );
			}
			label$123:;
			label$122:;
		}
		label$119:;
		I$2 = I$2 + 1ll;
		label$118:;
		if( I$2 <= 3ll) goto label$121;
		label$120:;
	}
	fb_StrDelete( (FBSTRING*)&FILENAME$1 );
	label$115:;
}

void EMITEND( void )
{
	FBSTRING TMP$74$1;
	FBSTRING TMP$75$1;
	FBSTRING TMP$77$1;
	FBSTRING TMP$81$1;
	FBSTRING TMP$82$1;
	FBSTRING TMP$83$1;
	FBSTRING TMP$84$1;
	FBSTRING TMP$85$1;
	label$124:;
	EMITUNINDENT(  );
	__builtin_memset( &TMP$74$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$74$1, -1ll, (void*)"END_TEST", 9ll, 0 );
	EMITLINE( &TMP$74$1 );
	fb_StrDelete( (FBSTRING*)&TMP$74$1 );
	EMITUNINDENT(  );
	__builtin_memset( &TMP$75$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$75$1, -1ll, (void*)"", 1ll, 0 );
	EMITLINE( &TMP$75$1 );
	fb_StrDelete( (FBSTRING*)&TMP$75$1 );
	__builtin_memset( &TMP$77$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$77$1, -1ll, (void*)"END_SUITE", 10ll, 0 );
	EMITLINE( &TMP$77$1 );
	fb_StrDelete( (FBSTRING*)&TMP$77$1 );
	fb_FileClose( (int32)*(int64*)((uint8*)&CTX$ + 256ll) );
	fb_StrAssign( (void*)&CTX$, 256ll, (void*)"", 1ll, 0 );
	*(int64*)((uint8*)&CTX$ + 256ll) = 0ll;
	fb_PrintVoid( 0, 2 );
	FBSTRING* vr$14 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 304ll) );
	FBSTRING* vr$15 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 288ll) );
	FBSTRING* vr$16 = fb_LongintToStr( *(int64*)((uint8*)&CTX$ + 296ll) );
	__builtin_memset( &TMP$81$1, 0, 24ll );
	FBSTRING* vr$19 = fb_StrConcat( &TMP$81$1, (void*)vr$16, -1ll, (void*)"/", 2ll );
	__builtin_memset( &TMP$82$1, 0, 24ll );
	FBSTRING* vr$22 = fb_StrConcat( &TMP$82$1, (void*)vr$19, -1ll, (void*)vr$15, -1ll );
	__builtin_memset( &TMP$83$1, 0, 24ll );
	FBSTRING* vr$25 = fb_StrConcat( &TMP$83$1, (void*)vr$22, -1ll, (void*)" (", 3ll );
	__builtin_memset( &TMP$84$1, 0, 24ll );
	FBSTRING* vr$28 = fb_StrConcat( &TMP$84$1, (void*)vr$25, -1ll, (void*)vr$14, -1ll );
	__builtin_memset( &TMP$85$1, 0, 24ll );
	FBSTRING* vr$31 = fb_StrConcat( &TMP$85$1, (void*)vr$28, -1ll, (void*)"%)", 3ll );
	fb_PrintString( 0, (FBSTRING*)vr$31, 1 );
	*(int64*)((uint8*)&CTX$ + 280ll) = *(int64*)((uint8*)&CTX$ + 280ll) + 1ll;
	*(int64*)((uint8*)&CTX$ + 272ll) = 0ll;
	label$125:;
}

void EMITTEST( struct $7ASTNODE* AST$1 )
{
	label$126:;
	int64 VALUE$1;
	int64 vr$0 = ASTISGOODTESTCASE( AST$1 );
	if( vr$0 == 0ll) goto label$129;
	{
		FBSTRING TMP$86$2;
		if( *(int64*)((uint8*)&CTX$ + 272ll) < 2048ll) goto label$131;
		{
			EMITEND(  );
			EMITBEGIN(  );
		}
		label$131:;
		label$130:;
		VALUE$1 = *(int64*)((uint8*)AST$1 + 40ll);
		__builtin_memset( &TMP$86$2, 0, 24ll );
		FBSTRING* vr$4 = ASTASSTRING( AST$1 );
		fb_StrAssign( (void*)&TMP$86$2, -1ll, (void*)vr$4, -1ll, 0 );
		EMITASSERTEQUAL( &TMP$86$2, *(int64*)((uint8*)AST$1 + 40ll) );
		fb_StrDelete( (FBSTRING*)&TMP$86$2 );
		*(int64*)((uint8*)&CTX$ + 272ll) = *(int64*)((uint8*)&CTX$ + 272ll) + 1ll;
	}
	label$129:;
	label$128:;
	ASTDELETE( AST$1 );
	label$127:;
}

__attribute__(( constructor )) static void fb_ctor__mathztorture( void )
{
	label$0:;
	*(int64*)((uint8*)&CTX$ + 288ll) = 82944ll;
	EMITBEGIN(  );
	{
		int64 OP1$1;
		OP1$1 = 0ll;
		label$135:;
		{
			{
				int64 OP2$3;
				OP2$3 = 0ll;
				label$139:;
				{
					{
						int64 OP3$5;
						OP3$5 = 0ll;
						label$143:;
						{
							{
								int64 OPZ$7;
								OPZ$7 = 0ll;
								label$147:;
								{
									{
										int64 OPERANDA$9;
										OPERANDA$9 = 0ll;
										label$151:;
										{
											{
												int64 OPERANDB$11;
												OPERANDB$11 = 0ll;
												label$155:;
												{
													{
														int64 OPERANDC$13;
														OPERANDC$13 = 0ll;
														label$159:;
														{
															{
																int64 OPERANDD$15;
																OPERANDD$15 = 0ll;
																label$163:;
																{
																	{
																		int64 OPERANDZ$17;
																		OPERANDZ$17 = 0ll;
																		label$167:;
																		{
																			*(int64*)((uint8*)&CTX$ + 296ll) = *(int64*)((uint8*)&CTX$ + 296ll) + 1ll;
																			*(int64*)((uint8*)&CTX$ + 304ll) = fb_D2L( __builtin_floor( ((0x1.9p+6 / (double)*(int64*)((uint8*)&CTX$ + 288ll)) * (double)*(int64*)((uint8*)&CTX$ + 296ll)) ) );
																			struct $7ASTNODE* vr$7 = ASTNEWOPERAND( OPERANDD$15 );
																			struct $7ASTNODE* vr$8 = ASTNEWOPERAND( OPERANDC$13 );
																			struct $7ASTNODE* vr$9 = ASTNEWOPERAND( OPERANDB$11 );
																			struct $7ASTNODE* vr$10 = ASTNEWOPERAND( OPERANDA$9 );
																			struct $7ASTNODE* vr$11 = ASTNEWBOP( OP1$1, vr$10, vr$9 );
																			struct $7ASTNODE* vr$12 = ASTNEWBOP( OP2$3, vr$11, vr$8 );
																			struct $7ASTNODE* vr$13 = ASTNEWBOP( OP3$5, vr$12, vr$7 );
																			struct $7ASTNODE* vr$14 = ASTNEWOPERAND( OPERANDZ$17 );
																			struct $7ASTNODE* vr$15 = ASTNEWBOP( OPZ$7, vr$14, vr$13 );
																			EMITTEST( vr$15 );
																			struct $7ASTNODE* vr$16 = ASTNEWOPERAND( OPERANDD$15 );
																			struct $7ASTNODE* vr$17 = ASTNEWOPERAND( OPERANDC$13 );
																			struct $7ASTNODE* vr$18 = ASTNEWBOP( OP3$5, vr$17, vr$16 );
																			struct $7ASTNODE* vr$19 = ASTNEWOPERAND( OPERANDB$11 );
																			struct $7ASTNODE* vr$20 = ASTNEWBOP( OP2$3, vr$19, vr$18 );
																			struct $7ASTNODE* vr$21 = ASTNEWOPERAND( OPERANDA$9 );
																			struct $7ASTNODE* vr$22 = ASTNEWBOP( OP1$1, vr$21, vr$20 );
																			struct $7ASTNODE* vr$23 = ASTNEWOPERAND( OPERANDZ$17 );
																			struct $7ASTNODE* vr$24 = ASTNEWBOP( OPZ$7, vr$23, vr$22 );
																			EMITTEST( vr$24 );
																		}
																		label$165:;
																		OPERANDZ$17 = OPERANDZ$17 + 1ll;
																		label$164:;
																		if( OPERANDZ$17 <= 3ll) goto label$167;
																		label$166:;
																	}
																}
																label$161:;
																OPERANDD$15 = OPERANDD$15 + 1ll;
																label$160:;
																if( OPERANDD$15 <= 3ll) goto label$163;
																label$162:;
															}
														}
														label$157:;
														OPERANDC$13 = OPERANDC$13 + 1ll;
														label$156:;
														if( OPERANDC$13 <= 3ll) goto label$159;
														label$158:;
													}
												}
												label$153:;
												OPERANDB$11 = OPERANDB$11 + 1ll;
												label$152:;
												if( OPERANDB$11 <= 3ll) goto label$155;
												label$154:;
											}
										}
										label$149:;
										OPERANDA$9 = OPERANDA$9 + 1ll;
										label$148:;
										if( OPERANDA$9 <= 3ll) goto label$151;
										label$150:;
									}
								}
								label$145:;
								OPZ$7 = OPZ$7 + 1ll;
								label$144:;
								if( OPZ$7 <= 2ll) goto label$147;
								label$146:;
							}
						}
						label$141:;
						OP3$5 = OP3$5 + 1ll;
						label$140:;
						if( OP3$5 <= 2ll) goto label$143;
						label$142:;
					}
				}
				label$137:;
				OP2$3 = OP2$3 + 1ll;
				label$136:;
				if( OP2$3 <= 2ll) goto label$139;
				label$138:;
			}
		}
		label$133:;
		OP1$1 = OP1$1 + 1ll;
		label$132:;
		if( OP1$1 <= 2ll) goto label$135;
		label$134:;
	}
	EMITEND(  );
	label$1:;
}

static void _ZN7ASTNODEaSERKS_( struct $7ASTNODE* THIS$1, struct $7ASTNODE* __FB_RHS__$1 )
{
	label$4:;
	*(int64*)THIS$1 = *(int64*)__FB_RHS__$1;
	*(int64*)((uint8*)THIS$1 + 8ll) = *(int64*)((uint8*)__FB_RHS__$1 + 8ll);
	fb_StrAssign( (void*)((uint8*)THIS$1 + 16ll), -1ll, (void*)((uint8*)__FB_RHS__$1 + 16ll), -1ll, 0 );
	*(int64*)((uint8*)THIS$1 + 40ll) = *(int64*)((uint8*)__FB_RHS__$1 + 40ll);
	*(struct $7ASTNODE**)((uint8*)THIS$1 + 48ll) = *(struct $7ASTNODE**)((uint8*)__FB_RHS__$1 + 48ll);
	*(struct $7ASTNODE**)((uint8*)THIS$1 + 56ll) = *(struct $7ASTNODE**)((uint8*)__FB_RHS__$1 + 56ll);
	label$5:;
}
