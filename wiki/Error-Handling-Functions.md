[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Error Handling Functions**

# Error Handling Functions

Statements and procedures that provide runtime error-handling capabilities.

Description

These statements and procedures provide ways of dealing with runtime errors. Specific modules, procedures and source code lines can be retrieved, and error handlers can be set up.

**Determining Errors**

Procedures that retrieve information about an error.

**Handling Errors**

Statements that allow handling of errors.

***Determining Errors***

**[Erl](Erl)**

Gets the line in source code where the error occurred.

**[Erfn](Erfn)**

Gets the name of the function where the error occurred.

**[Ermn](Ermn)**

Gets the name of the source file where the error occurred.

**[Err](Err)**

Gets the error number of the last error that occurred.

**[Error](Error)**

Generates an error using an error number.

***Handling Errors***

**[On Error](On-Error)**

Sets a global error handler using a label.

**[On Local Error](Local)**

Sets a local error handler using a label.

**[Resume](Resume)**

Resumes execution at the line where the error occurred.

**[Resume Next](Resume-Next)**

Resumes execution at the line after where the error occurred.

See also

- [Error Handling](Error-Handling)

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
