TARGET = gtkad

SOURCES = vector2d drawable point line canvas regularpolygon shapedialog mainview main
PKGS = gee-0.8 gtk+-3.0

RES = resources.xml

SRCDIR = src
RESDIR = res
TMPDIR = tmp
OBJDIR = obj

CFLAGS = -w -I${TMPDIR} `pkg-config --cflags ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0`
LDFLAGS = -lm `pkg-config --libs ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0`
VALAOPTS = --vapidir=${TMPDIR} $(addprefix --pkg ,${PKGS}) --target-glib=2.38 --gresources ${RESDIR}/${RES}

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

OBJECTS = $(addsuffix .o,${SOURCES}) ${RES:.xml=.o} ${WRES:.rc=_win.o}

all: mkdir ${TARGET}${EXEEXT}

mkdir:
	@mkdir -pv ${OBJDIR} ${TMPDIR}

clean: clean_obj clean_tmp

clean_obj:
	@${RM} ${TARGET} ${OBJDIR}/*.o

clean_tmp:
	@${RM} ${TMPDIR}/*.c ${TMPDIR}/*.h ${TMPDIR}/*.vapi

${TMPDIR}/%.c: ${SRCDIR}/%.vala
	@echo 'VALAC $<'
	@${VALAC} -C $< ${VALAOPTS} $(addprefix --pkg ,$(shell echo ${SOURCES} | \
        sed -e 's~$(subst ${SRCDIR}/,,$(<:.vala=))\b.*~~')) \
        --internal-vapi=$(subst ${SRCDIR}/,${TMPDIR}/,$(<:.vala=.vapi)) \
        --header=$(subst ${SRCDIR}/,${TMPDIR}/,$(<:.vala=.h)) \
        --internal-header=$(subst ${SRCDIR}/,${TMPDIR}/,$(<:.vala=_internal.h))
	@mv $(<:.vala=.c) $@

${OBJDIR}/%.o: ${TMPDIR}/%.c
	@echo 'CC    $<'
	@${CC} -o $@ -c $< ${CFLAGS}

${TMPDIR}/${RES:.xml=.c}: ${RESDIR}/${RES}
	@echo 'RES   $<'
	@glib-compile-resources ${RESDIR}/${RES} --sourcedir=${RESDIR} --target=$@ --c-name _ui --generate-source

${OBJDIR}/${WRES:.rc=_win.o}: ${RESDIR}/${WRES}
	@echo 'RES   $<'
	@${WINDRES} $< $@

.SECONDARY: $(addprefix ${TMPDIR}/,$(addsuffix .c,${SOURCES}))

${TARGET}${EXEEXT}: $(addprefix ${OBJDIR}/,${OBJECTS})
	@echo 'LD    $@'
	@${CC} -o $@ $^ ${LDFLAGS}
