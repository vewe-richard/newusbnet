
# Comment/uncomment the following line to enable/disable debugging
#DEBUG = y


ifeq ($(DEBUG),y)
  DEBFLAGS = -O -g -DSCULLC_DEBUG # "-O" is needed to expand inlines
else
  DEBFLAGS = -O2
endif

LDDINC=$(PWD)/../include
EXTRA_CFLAGS += $(DEBFLAGS) -I$(LDDINC)

TARGET = scullc

ifneq ($(KERNELRELEASE),)

scullc-objs := newusbnet_main.o

obj-m	:= scullc.o

else

#KERNELDIR ?= /lib/modules/$(shell uname -r)/build
KERNELDIR ?= /home/richard/work/knet/linux-stable
PWD       := $(shell pwd)

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

endif


install:
	install -d $(INSTALLDIR)
	install -c $(TARGET).o $(INSTALLDIR)

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.mod modules.order *.symvers 


depend .depend dep:
	$(CC) $(EXTRA_CFLAGS) -M *.c > .depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif
