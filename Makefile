TARGET = gtkad

SOURCES = vector2d drawable point line canvas regularpolygon shapedialog mainview main
PKGS = gee-0.8 gtk+-3.0

SRCDIR = src
RESDIR = res
TMPDIR = tmp
OBJDIR = obj

RES = ${RESDIR}/resources.xml
RESC = $(subst ${RESDIR}/,${TMPDIR}/,${RES:.xml=.c})
RESOBJ = $(subst ${RESDIR}/,${OBJDIR}/,${RES:.xml=.o})
UI = $(shell sed -n 's~\s*<file.*>\(.*\)<\/file>~\1~p' ${RES})

VALAC = valac
CC = gcc
RM = rm -vf

ifeq ($(OS),Windows_NT)
    EXEEXT = .exe
    WLDFLAGS = -Wl,--export-all-symbols -mwindows
    WINDRES = windres
    WRES = ${RESDIR}/${TARGET}.rc
    WRESOBJ = $(subst ${RESDIR}/,${OBJDIR}/,${WRES:.rc=_win.o})
else
    EXEEXT = 
    WLDFLAGS = 
    WINDRES = 
    WRES = 
    WRESOBJ = 
endif

OBJECTS = $(addprefix ${OBJDIR}/,$(addsuffix .o,${SOURCES})) ${RESOBJ} ${WRESOBJ}
CCODE = $(addprefix ${TMPDIR}/,$(addsuffix .c,${SOURCES})) ${RESC}

CFLAGS = -w -I${TMPDIR} `pkg-config --cflags ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0`
LDFLAGS = -lm `pkg-config --libs ${PKGS} glib-2.0 gobject-2.0 gmodule-export-2.0` ${WLDFLAGS}
VALAOPTS = --vapidir=${TMPDIR} $(addprefix --pkg ,${PKGS}) --target-glib=2.38 --gresources ${RES}

all: ${TARGET}${EXEEXT}

clean: clean_obj clean_tmp

clean_obj:
	@${RM} ${TARGET}${EXEEXT} ${OBJDIR}/*.o

clean_tmp:
	@${RM} ${TMPDIR}/*.c ${TMPDIR}/*.h ${TMPDIR}/*.vapi

obj: ${OBJECTS}

tmp: ${CCODE}

%/:
	@echo "MKDIR $(@:/=)"
	@mkdir -p $@

${RES}: $(addprefix ${RESDIR}/,${UI})
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

${RESC}: ${RES} | ${TMPDIR}/
	@echo 'RES   $(subst ${TMPDIR}/,,$(@:.c=))'
	@glib-compile-resources $< --sourcedir=${RESDIR} --target=$@ --c-name _ui --generate-source

${WRESOBJ}: ${WRES} | ${OBJDIR}/
	@echo 'WRES  $(subst ${OBJDIR}/,,$(@:.o=))'
	@${WINDRES} $< $@

.SECONDARY: ${TMPDIR}/ ${OBJDIR}/

${TARGET}${EXEEXT}: ${OBJECTS}
	@echo 'LD    $(@:${EXEEXT}=)'
	@${CC} -o $@ $^ ${LDFLAGS}
