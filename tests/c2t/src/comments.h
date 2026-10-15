/* comments.h -- every comment shape c2t converts. */
#ifndef COMMENTS_H
#define COMMENTS_H

// a line comment
/// a doc line comment
/* a block */   /* and a second on the same line */

/**
 * A multi-line doc block. It quotes tiko's own delimiters, '/ and /',
 * which must not open or close a tiko comment.
 */

/* a block comment that starts here
   and ends on the declaration's line */ int after_comment;

int trailing; // a trailing comment goes into the quote
// a line comment spliced \
   onto the next line

#endif
