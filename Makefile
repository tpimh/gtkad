TARGET = gtkad

SOURCES = vector2d drawable point line canvas regularpolygon shapedialog mainview main
PKGS = gee-0.8 gtk+-3.0

RES = resources.xml
UI = mainview.ui shapedialog.ui options.ui

CFLAGS = -w -I. `pkg-config --cflags ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0`
LDFLAGS = -lm `pkg-config --libs ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0`
VALAOPTS = --vapidir="." $(addprefix --pkg ,${PKGS}) --target-glib=2.38 --gresources ${RES}

VALAC = valac
CC = gcc
RM = rm -vf

ifeq ($(OS),Windows_NT)
    EXEEXT = .exe
    LDFLAGS += -Wl,--export-all-symbols -mwindows
    WINDRES = windres
    WRES = ${TARGET}.rc
else
    EXEEXT = 
endif

all: ${TARGET}${EXEEXT}

clean:
	@${RM} ${TARGET} ${WRES:.rc=_res.o} *~ *.o *.c *.h *.H *.vapi

%.c: %.vala
	@echo 'VALAC $<'
	@${VALAC} -C $< ${VALAOPTS} $(addprefix --pkg ,$(shell echo ${SOURCES} | sed -e 's~$(<:.vala=)\b.*~~')) \
        --internal-vapi=$(<:.vala=.vapi) --header=$(<:.vala=.H) --internal-header=$(<:.vala=.h)

%.o:%.c
	@echo 'CC    $<'
	@${CC} -o $@ -c $< ${CFLAGS}

${RES:.xml=.c}: ${RES} ${UI}
	@echo 'RES   $^'
	@glib-compile-resources ${RES} --target=$@ --sourcedir=$(srcdir) --c-name _ui --generate-source

${WRES:.rc=_res.o}: ${WRES}
	@echo 'RES   $<'
	@${WINDRES} $< $@

.SECONDARY: $(addsuffix .c,${SOURCES})

${TARGET}${EXEEXT}: $(addsuffix .o,${SOURCES}) ${RES:.xml=.o} ${WRES:.rc=_res.o}
	@echo 'LD    $@'
	@${CC} -o $@ $^ ${LDFLAGS}
