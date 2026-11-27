/* contcomment.h -- a function-like macro with comments on its continuation lines: brotli's
   BROTLI_DECODER_ERROR_CODES_LIST, an X-macro the enum below is written with. */
#define CC_CODES_LIST(CODE, SEP)       \
  CODE(_, NO_ERROR, 0) SEP             \
  /* the result values */              \
  CODE(_, SUCCESS, 1) SEP              \
                                       \
  /* errors */                         \
  CODE(_ERROR_, BAD_INPUT, -1)

#define CC_ENUM_ITEM_(PREFIX, NAME, CODE) CC ## PREFIX ## NAME = CODE
#define CC_COMMA_ ,
typedef enum {
  CC_CODES_LIST(CC_ENUM_ITEM_, CC_COMMA_)
} CcCode;
#undef CC_ENUM_ITEM_
#undef CC_COMMA_

int cc_last(void);  /* the line after the macro is still a declaration */
