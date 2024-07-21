SRC = src/hxluasimdjson.cpp src/simdjson.cpp
INCLUDE = -I$(LUA_INCDIR)
LIBS_PATH = -L$(LUA_LIBDIR)
LIBS = -lpthread -llua
FLAGS = -std=c++11 -Wall $(LIBFLAG) $(CFLAGS)

ifeq ($(OS),Windows_NT)
	LIBEXT = dll
	CP = copy
	INST_LIBDIR_CORRECT=$(subst /,\,$(INST_LIBDIR))
else
	UNAME := $(shell uname -s)
	ifeq ($(findstring MINGW,$(UNAME)),MINGW)
		LIBEXT = dll
	else ifeq ($(findstring CYGWIN,$(UNAME)),CYGWIN)
		LIBEXT = dll
	else
		LIBEXT = so
	endif
	CP = cp
	INST_LIBDIR_CORRECT=INST_LIBDIR
endif

TARGET = simdjson.$(LIBEXT)

all: $(TARGET)

$(TARGET):
	$(CXX) $(SRC) $(FLAGS) $(INCLUDE) $(LIBS_PATH) $(LIBS) -o $@

clean:
	rm *.$(LIBEXT)

install: $(TARGET)
	$(CP) $(TARGET) $(INST_LIBDIR_CORRECT)
