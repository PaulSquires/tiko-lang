# Created by DepGen.py. To recreate, run DepGen.py.
$(DIR_O)/Lexilla.o: \
	../src/Lexilla.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../lexlib/LexerModule.h \
	../lexlib/CatalogueModules.h
$(DIR_O)/Accessor.o: \
	../lexlib/Accessor.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/PropSetSimple.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h
$(DIR_O)/CharacterCategory.o: \
	../lexlib/CharacterCategory.cxx \
	../lexlib/CharacterCategory.h
$(DIR_O)/CharacterSet.o: \
	../lexlib/CharacterSet.cxx \
	../lexlib/CharacterSet.h
$(DIR_O)/DefaultLexer.o: \
	../lexlib/DefaultLexer.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/PropSetSimple.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/LexerModule.h \
	../lexlib/DefaultLexer.h
$(DIR_O)/InList.o: \
	../lexlib/InList.cxx \
	../lexlib/InList.h \
	../lexlib/CharacterSet.h
$(DIR_O)/LexAccessor.o: \
	../lexlib/LexAccessor.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../lexlib/LexAccessor.h \
	../lexlib/CharacterSet.h
$(DIR_O)/LexerBase.o: \
	../lexlib/LexerBase.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/PropSetSimple.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/LexerModule.h \
	../lexlib/LexerBase.h
$(DIR_O)/LexerModule.o: \
	../lexlib/LexerModule.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/PropSetSimple.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/LexerModule.h \
	../lexlib/LexerBase.h \
	../lexlib/LexerSimple.h
$(DIR_O)/LexerSimple.o: \
	../lexlib/LexerSimple.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/PropSetSimple.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/LexerModule.h \
	../lexlib/LexerBase.h \
	../lexlib/LexerSimple.h
$(DIR_O)/PropSetSimple.o: \
	../lexlib/PropSetSimple.cxx \
	../lexlib/PropSetSimple.h
$(DIR_O)/StyleContext.o: \
	../lexlib/StyleContext.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/StyleContext.h \
	../lexlib/CharacterSet.h
$(DIR_O)/WordList.o: \
	../lexlib/WordList.cxx \
	../lexlib/WordList.h \
	../lexlib/CharacterSet.h
$(DIR_O)/LexTiko.o: \
	../lexers/LexTiko.cxx \
	../../scintilla/include/ILexer.h \
	../../scintilla/include/Sci_Position.h \
	../../scintilla/include/Scintilla.h \
	../include/SciLexer.h \
	../lexlib/WordList.h \
	../lexlib/LexAccessor.h \
	../lexlib/Accessor.h \
	../lexlib/StyleContext.h \
	../lexlib/CharacterSet.h \
	../lexlib/LexerModule.h \
	../lexlib/OptionSet.h \
	../lexlib/DefaultLexer.h
