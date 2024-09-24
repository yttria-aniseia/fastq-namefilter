prefix=/usr/local
exec_prefix=$(prefix)
bindir=$(exec_prefix)/bin

SRC=./src
BIN=./bin
BIN_STATIC=$(BIN)/x86_64
NAME=fastq-namefilter
CXX=g++
INC_DIRS := $(shell find 3rdparty -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))
LIB=-lpthread

CPPFLAGS := $(INC_FLAGS) -O3 -Wextra -Wall -Wconversion -std=c++17 -mtune=native
CPPFLAGS_STATIC := $(CPPFLAGS) -static -fdata-sections -ffunction-sections -Wl,--gc-sections -s -march=x86-64 -mtune=generic
INSTALL=install
INSTALL_PROGRAM=$(INSTALL)

.PHONY: all static clean
all: fastq-namefilter
static: fastq-namefilter-static

$(SRC)/%.o: %.c
	$(CXX) $(CPPFLAGS) -c -o $(SRC)/$@ $^

fastq-namefilter: $(SRC)/fastq-namefilter.o
	mkdir -p $(BIN)
	$(CXX) $(CPPFLAGS) -o$(BIN)/$@ $^ $(LIB)
fastq-namefilter-static: $(SRC)/fastq-namefilter.o
	$(MAKE) BIN='$(BIN_STATIC)' CFLAGS='$(CPPFLAGS_STATIC)'\
		fastq-namefilter $(LIB)

install: $(BIN)/$(NAME) installdirs
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
install-strip:
	$(MAKE) INSTALL_PROGRAM='$(INSTALL_PROGRAM) -s' \
		install
installdirs:
	mkdir -p $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(NAME)

clean:
	rm -f $(SRC)/*.o
	rm -rf $(BIN)/fastq-namefilter
