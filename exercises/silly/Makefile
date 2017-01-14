INCLUDES = -I. -I$(KDIR)/include
KBUILD_CFLAGS += -g

all: kernel_modules

MODNAME := sillymod-event
obj-m	:= $(MODNAME).o

KVERS  := $(shell uname -r)
KDIR   := /lib/modules/$(KVERS)/build
PWD    := $(shell pwd)

CFLAGS_sillymod-event.o = -I$(src)

%.ko: %.o
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) $@

kernel_modules:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

modules_install: all
	install -m 644 $(MODNAME).ko /lib/modules/$(KVERS)/kernel/drivers/$(MODNAME).ko
	/sbin/depmod -a

install:	modules_install

uninstall:
	$(RM) /lib/modules/$(KVERS)/kernel/drivers/$(MODNAME).ko
	/sbin/depmod -a

clean:
	$(RM) *.o *~ *.ko *.mod.c .*.o.cmd .*.ko.cmd
	$(RM) -r .tmp_versions
	$(RM) modules.order  Module.symvers
