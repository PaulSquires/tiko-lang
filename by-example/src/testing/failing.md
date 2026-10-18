# A failing test

A test earns its keep the day it fails. Here `WordCount` counts the spaces
instead of the words, and the test catches it:

```tiko
{{#include ../../examples/testing/failing.tiko}}
```

**Output**

```text
{{#include ../../examples/testing/failing.out}}
```

The program exits with code 1.

Each failed assertion is printed before the summary with three things you need
to find it: the file and line, the test's full name (`TESTS.WORDS.COUNTS_WORDS`,
the suite and test in capitals), and the assertion as it was written. The first
check passed, because the empty string has no spaces either; the other two
failed.

The summary's `Failed` column is the number of failed assertions, not of
failed tests, and `run_tests` returns `false` when it is anything but zero.
That is why the exit code is 1: a build script that runs the tests stops here.

Write the test that shows a bug before you fix the bug. When the test passes,
you know the fix works, and the test stays to make sure the bug does not come
back.

### Activities

1. Fix `WordCount` (count the starts of words, not the spaces) and run the
   tests again.
2. Add `CU_ASSERT_EQUAL( WordCount( "two  spaces" ), 2 )` and check that your
   fix handles it.
