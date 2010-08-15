# Makefile for ATmegaBOOT
# E.Lins, 18.7.2005
# Modified to support Beacon2 by sarahemm - 2010-08-07
# $Id$


# program name should not be changed...
PROGRAM    = ATmegaBOOT_644P

# enter the target CPU frequency
AVR_FREQ   = 4000000L

MCU_TARGET = atmega644p
LDSECTION  = --section-start=.text=0xF800

OBJ        = $(PROGRAM).o
OPTIMIZE   = -O2

DEFS       = 
LIBS       = 

#CC         = avr-gcc
CC         = avr-gcc-3.4.6 


# Override is only needed by avr-lib build system.

override CFLAGS        = -g -Wall $(OPTIMIZE) -mmcu=$(MCU_TARGET) -DF_CPU=$(AVR_FREQ) $(DEFS)
override LDFLAGS       = -Wl,$(LDSECTION)
#override LDFLAGS       = -Wl,-Map,$(PROGRAM).map,$(LDSECTION)

OBJCOPY        = avr-objcopy
OBJDUMP        = avr-objdump

all: CFLAGS += '-DMAX_TIME_COUNT=8000000L>>1' -DADABOOT
all: $(PROGRAM).hex

$(PROGRAM).hex: $(PROGRAM).elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
	
$(PROGRAM).elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
	
$(OBJ): ATmegaBOOT.c
	$(CC) $(CFLAGS) $(LDFLAGS) -c -g -O2 -Wall -mmcu=$(MCU_TARGET) ATmegaBOOT.c -o $(PROGRAM).o

%.lst: %.elf
	$(OBJDUMP) -h -S $< > $@

%.srec: %.elf
	$(OBJCOPY) -j .text -j .data -O srec $< $@

%.bin: %.elf
	$(OBJCOPY) -j .text -j .data -O binary $< $@

clean:
	rm -rf *.o *.elf *.lst *.map *.sym *.lss *.eep *.srec *.bin *.hex
	
