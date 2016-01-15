TARGET = gtkad

SOURCES = vector2d drawable point line canvas regularpolygon shapedialog mainview main
PKGS = gee-0.8 gtk+-3.0

RES = resources.xml
UI = $(shell sed -n 's/\s*<file.*>\(.*\)<\/file>/\1/p' ${RESDIR}/${RES})

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
    WRES = ${RESDIR}/${TARGET}.rc
else    
    EXEEXT = 
endif

OBJECTS = $(addsuffix .o,${SOURCES}) ${RES:.xml=.o} ${WRES:.rc=_win.o}
CCODE = $(addsuffix .c,${SOURCES}) ${RES:.xml=.c}

all: ${TARGET}${EXEEXT}

clean: clean_obj clean_tmp

clean_obj:
	@${RM} ${TARGET} ${OBJDIR}/*.o

clean_tmp:
	@${RM} ${TMPDIR}/*.c ${TMPDIR}/*.h ${TMPDIR}/*.vapi

obj: $(addprefix ${OBJDIR}/,${OBJECTS})

tmp: $(addprefix ${TMPDIR}/,${CCODE})

%/:
	@echo "MKDIR $(@:/=)"
	@mkdir -p $@

${RESDIR}/${RES}: $(addprefix ${RESDIR}/,${UI})
	@touch $@

${TMPDIR}/%.c: ${SRCDIR}/%.vala | ${TMPDIR}/
	@echo 'VALAC $(subst ${TMPDIR}/,,$(@:.c=))'
	@${VALAC} -C $< ${VALAOPTS} -b ${SRCDIR} -d ${TMPDIR} \
        $(addprefix --pkg ,$(shell echo ${SOURCES} | sed -e 's~$(subst ${SRCDIR}/,,$(<:.vala=))\b.*~~')) \
        --internal-vapi=$(subst ${SRCDIR}/,,$(<:.vala=.vapi)) \
        --header=$(subst ${SRCDIR}/,${TMPDIR}/,$(<:.vala=.h)) \
        --internal-header=$(subst ${SRCDIR}/,${TMPDIR}/,$(<:.vala=_internal.h))

${OBJDIR}/%.o: ${TMPDIR}/%.c | ${OBJDIR}/
	@echo 'CC    $(subst ${OBJDIR}/,,$(@:.o=))'
	@${CC} -o $@ -c $< ${CFLAGS}

${TMPDIR}/${RES:.xml=.c}: ${RESDIR}/${RES} | ${TMPDIR}/
	@echo 'RES   $(subst ${TMPDIR}/,,$(@:.c=))'
	@glib-compile-resources $< --sourcedir=${RESDIR} --target=$@ --c-name _ui --generate-source

${WRES:.rc=_win.o}: ${RESDIR}/${WRES} | ${OBJDIR}/
	@echo 'WRES  $(subst ${OBJDIR}/,,$(@:.o=))'
	@${WINDRES} $< $@

.SECONDARY: ${TMPDIR}/ ${OBJDIR}/

${TARGET}${EXEEXT}: $(addprefix ${OBJDIR}/,${OBJECTS})
	@echo 'LD    $(@:${EXEEXT}=)'
	@${CC} -o $@ $^ ${LDFLAGS}
