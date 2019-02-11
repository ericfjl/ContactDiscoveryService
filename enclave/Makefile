srcdir = src
includedir = include
libdir = lib
patchdir = patches
resourcedir = ../service/src/main/resources

export NAME := sabd

JDK_HOME ?= $(dir $(word 1,$(wildcard /usr/lib/jvm/*/include)))
export JDK_HOME

DOCKER ?= docker

LLVM_BOLT ?= bolt/build/bin/llvm-bolt
BOLT_DIR   = bolt

CFLAGS = \
	-m64 -O2 -ggdb -march=skylake -pipe \
	-std=c11 -D_DEFAULT_SOURCE \
	-fstack-protector \
	-Wall -Werror=all -Wextra -Wno-unused-parameter -Wno-missing-field-initializers \
	-I$(includedir) -I$(includedir)/bearssl -I$(SGX_INCLUDEDIR)

TEST_CFLAGS += $(CFLAGS) \
	-DUNIT_TESTING -fsanitize=undefined

ifdef SPECTRE_HARDEN
ENCLAVE_NAME		:= lib$(NAME)_enclave.hardened
else
ENCLAVE_NAME		:= lib$(NAME)_enclave
endif
TARGET			:= $(ENCLAVE_NAME).unsigned.so
UNSTRIPPED_TARGET	:= lib$(NAME)_enclave.unstripped.so

SIGNDATA		:= $(ENCLAVE_NAME).signdata
MRENCLAVE		:= $(ENCLAVE_NAME).mrenclave
SIGNED_TARGET		:= $(ENCLAVE_NAME).signed.so
ENCLAVE_CONFIG		:= $(ENCLAVE_NAME).config.xml

DEBUG_ENCLAVE_NAME	:= $(ENCLAVE_NAME).debug
DEBUG_SIGNDATA		:= $(DEBUG_ENCLAVE_NAME).signdata
DEBUG_SIGNED_TARGET	:= $(DEBUG_ENCLAVE_NAME).so
DEBUG_ENCLAVE_CONFIG	:= $(DEBUG_ENCLAVE_NAME).config.xml

TEST_SABD_TARGET	:= sabd-enclave-test
TEST_SGXSD_TARGET	:= sgxsd-enclave-test

BEARSSL_SOURCES := \
	   $(srcdir)/bearssl/gcm.c $(srcdir)/bearssl/ghash_pclmul.c \
	   $(srcdir)/bearssl/sha2small.c $(srcdir)/bearssl/dec32be.c $(srcdir)/bearssl/enc32be.c \
	   $(srcdir)/bearssl/aes_x86ni_ctr.c $(srcdir)/bearssl/aes_x86ni.c
BEARSSL_OBJECTS := $(BEARSSL_SOURCES:.c=.o)

SOURCES := $(srcdir)/sabd-enclave.c.s $(srcdir)/sgxsd-enclave.c $(srcdir)/curve25519-donna-c64.c $(BEARSSL_SOURCES) \
	   $(srcdir)/sgx-tcrypto-stub.c
OBJECTS := $(patsubst %.s,%.o,$(SOURCES:.c=.o))

TEST_SABD_SOURCES := $(srcdir)/sabd-enclave.c $(srcdir)/sabd-enclave-test.c $(srcdir)/cmockery.c
TEST_SABD_OBJECTS := $(TEST_SABD_SOURCES:.c=.o)

TEST_SGXSD_SOURCES := $(srcdir)/sgxsd-enclave.c $(srcdir)/curve25519-donna-c64.c $(srcdir)/sgxsd-enclave-test.c $(srcdir)/cmockery.c
TEST_SGXSD_OBJECTS := $(TEST_SGXSD_SOURCES:.c=.o)

TEST_LDFLAGS += $(TEST_CFLAGS)

.PHONY: default docker-install all test debug signed jni-static jni debuild debuild-target debrebuild docker edger8r clean
default: docker-install

include sgx_enclave.mk

docker-install: docker
	$(MAKE) install

all: $(TARGET) jni $(srcdir)/sabd-enclave.c.s $(SIGNDATA) $(MRENCLAVE) debug test

test: $(TEST_SABD_TARGET) $(TEST_SGXSD_TARGET)
	./$(TEST_SABD_TARGET)
	./$(TEST_SGXSD_TARGET)

benchmark: $(TEST_SABD_TARGET)
	./$(TEST_SABD_TARGET) --benchmark

debug: $(TARGET) $(DEBUG_SIGNED_TARGET)

sign: $(SIGNED_TARGET)

install: jni $(DEBUG_SIGNED_TARGET) $(MRENCLAVE)
	mkdir -p $(resourcedir)/enclave
	cp jni/lib$(NAME)-jni.so $(resourcedir)/enclave-jni.so
	cp $(DEBUG_SIGNED_TARGET) $(resourcedir)/enclave/$$(cat $(MRENCLAVE)).so
	cp $(SIGNDATA) signdata/$$(cat $(MRENCLAVE)).signdata
	if [ -e $(SIGNED_TARGET) ]; then cp $(SIGNED_TARGET) $(resourcedir)/enclave/$$(cat $(MRENCLAVE)).so; fi

jni-static:
	$(MAKE) -C jni static

jni: $(SGX_LIBDIR)/lib$(SGX_URTS_LIB).so
	$(MAKE) -C jni

debuild:
	env -u LANG LC_ALL=C $(if $(SPECTRE_HARDEN),SPECTRE_HARDEN=$(SPECTRE_HARDEN)) debuild --preserve-envvar SPECTRE_HARDEN --no-lintian --build=binary -uc -us -j1
	mv ../*.buildinfo debian/buildinfo
	mv ../*.deb debian/
debuild-target: all

debrebuild: docker/debrebuild.pl
	-@if perl docker/debrebuild.pl debian/buildinfo docker; then \
		echo; echo Updated docker/build-deps, docker/sources.list, and debian/buildinfo. Please check them in if modified.; \
	else \
		echo; echo Failed to update docker/build-deps and docker/sources.list from debian/buildinfo. Continuing build anyway...; \
	fi

docker: clean
	$(DOCKER) build -t whispersystems/contactdiscovery-enclave:1.0 .
	$(DOCKER) run --rm --volume $(CURDIR):/home/signal/enclave --workdir /home/signal/enclave \
		--user $$(id -u):$$(id -g) \
		whispersystems/contactdiscovery-enclave:1.0 \
		env HOME=/home/signal make SGX_MODE=$(SGX_MODE) $(if $(SPECTRE_HARDEN),SPECTRE_HARDEN=$(SPECTRE_HARDEN)) debuild debrebuild jni

edger8r: $(includedir)/sabd_enclave.edl | $(SGX_EDGER8R)
	 $(SGX_EDGER8R) --untrusted --untrusted-dir jni/src \
			--trusted --trusted-dir $(srcdir) \
			--search-path $(SGX_INCLUDEDIR) \
			$(includedir)/sabd_enclave.edl

clean:
	rm -f	$(TARGET) $(UNSTRIPPED_TARGET) \
		$(SIGNDATA) $(MRENCLAVE) $(SIGNED_TARGET) \
		$(DEBUG_ENCLAVE_NAME).key $(DEBUG_ENCLAVE_NAME).pub $(DEBUG_ENCLAVE_NAME).sig \
		$(DEBUG_SIGNDATA) $(DEBUG_SIGNED_TARGET) \
		$(OBJECTS) lib/libsgx_*.a lib/libselib.a \
		$(TEST_SABD_TARGET) $(TEST_SABD_OBJECTS) $(TEST_SGXSD_TARGET) $(TEST_SGXSD_OBJECTS)
	-make -C jni clean
	-$(SGX_SDK_MAKE) -C $(SGX_SDK_SOURCE_DIR) clean

$(BEARSSL_OBJECTS): $(wildcard $(includedir)/bearssl/%.h)
$(OBJECTS): $(includedir)/sabd.h $(includedir)/sgxsd.h $(includedir)/sgxsd-enclave.h | $(SGX_INCLUDEDIR)

%.c.s: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -S -ggdb0 -fverbose-asm -o $@ $<

$(UNSTRIPPED_TARGET): $(OBJECTS)

$(TEST_SABD_TARGET): CFLAGS := $(TEST_CFLAGS)
$(TEST_SABD_TARGET): $(TEST_SABD_SOURCES) $(includedir)/cmockery.h
	$(CC) -o $@ $(TEST_SABD_SOURCES) $(TEST_LDFLAGS)

$(TEST_SGXSD_TARGET): CFLAGS := $(TEST_CFLAGS)
$(TEST_SGXSD_TARGET): $(TEST_SGXSD_SOURCES) $(includedir)/cmockery.h
	$(CC) -o $@ $(TEST_SGXSD_SOURCES) $(TEST_LDFLAGS)

#
# BOLT
#

llvm-bolt: $(LLVM_BOLT)
$(LLVM_BOLT):
	-rm -r $(BOLT_DIR)
	@mkdir -p $(BOLT_DIR)
	@( cd $(BOLT_DIR) && \
	   wget -O - https://github.com/llvm-mirror/llvm/archive/f137ed238db11440f03083b1c88b7ffc0f4af65e.tar.gz | tar zxf - && \
	   mv llvm-f137ed238db11440f03083b1c88b7ffc0f4af65e llvm && \
	   cd llvm/tools && \
	   wget -O - https://github.com/facebookincubator/BOLT/archive/471e5fc4a6734869bee50b6f2430c30d8a155e9d.tar.gz | tar zxf - && \
	   mv BOLT-471e5fc4a6734869bee50b6f2430c30d8a155e9d llvm-bolt && \
	   cd .. && \
	   patch -p 1 < tools/llvm-bolt/llvm.patch )
	patch -d $(BOLT_DIR)/llvm/tools/llvm-bolt -p 1 < $(patchdir)/llvm-bolt.lfences.patch
	@( cd $(BOLT_DIR) && \
	   mkdir build && cd build && \
	   cmake -G Ninja ../llvm -DLLVM_TARGETS_TO_BUILD="X86;AArch64" -DCMAKE_BUILD_TYPE=Release && \
	   ninja )
