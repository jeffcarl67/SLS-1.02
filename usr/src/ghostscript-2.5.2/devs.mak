#    Copyright (C) 1989, 1992 Aladdin Enterprises.  All rights reserved.
#    Distributed by Free Software Foundation, Inc.
#
# This file is part of Ghostscript.
#
# Ghostscript is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY.  No author or distributor accepts responsibility
# to anyone for the consequences of using it or for whether it serves any
# particular purpose or works at all, unless he says so in writing.  Refer
# to the Ghostscript General Public License for full details.
#
# Everyone is granted permission to copy, modify and redistribute
# Ghostscript, but only under the conditions described in the Ghostscript
# General Public License.  A copy of this license is supposed to have been
# given to you along with Ghostscript so you can know your rights and
# responsibilities.  It should be in a file named COPYING.  Among other
# things, the copyright notice and this notice must be preserved on all
# copies.

# makefile for Ghostscript device drivers.

# -------------------------------- Catalog ------------------------------- #

# It is possible to build Ghostscript with an arbitrary collection of
# device drivers, although some drivers are supported only on a subset
# of the target platforms.  The currently available drivers are:

# Displays:
#   MS-DOS EGA and VGA:
#	ega	EGA (640x350, 16-color)
#	vga	VGA (640x480, 16-color)
#   MS-DOS SuperVGA:
# +	atiw	ATI Wonder SuperVGA, 256-color modes
# *	mdb10	EIZO MDB-10 (1024 x 768)
#	s3vga	SuperVGA with S3 86C911 chip (e.g., Diamond Stealth board)
#	tseng	SuperVGA using Tseng Labs ET3000/4000 chips, 256-color modes
#	tseng16  Tseng Labs SuperVGA in 800x600, 16-color mode (256K memory)
# +	tvga	Trident SuperVGA, 256-color modes
# +	tvga16	Trident SuperVGA in 800x600, 16-color mode (256K memory)
#   ****** NOTE: The vesa device does not work with the Watcom (32-bit MS-DOS)
#   ****** compiler or executable.
#	vesa	SuperVGA with VESA standard API driver
#   MS-DOS other:
#	bgi	Borland Graphics Interface (CGA and Hercules)
#	mswin	Microsoft Windows 3.0, 3.1
# *	pe	Private Eye
#   Unix and VMS:
# *	att3b1	AT&T 3b1/Unixpc monochrome display   [3b1 only]
# *	sonyfb	Sony Microsystems monochrome display   [Sony only]
# *	sunview  SunView window system   [SunOS only]
#	x11	X Windows version 11, release >=3   [Unix and VMS only]
# Printers:
#	bj10e	Canon BubbleJet BJ10e
# *	cdeskjet  H-P DeskJet 500C with 1 bit/pixel color
# *	cdjcolor  H-P DeskJet 500C with 24 bit/pixel color and
#		high-quality color (Floyd-Steinberg) dithering
# *	cdjmono  H-P DeskJet 500C printing black only
# +	deskjet  H-P DeskJet and DeskJet Plus
# *	dfaxhigh  DigiBoard, Inc.'s DigiFAX software format (high resolution)
# *	dfaxlow  DigiFAX low (normal) resolution
#	djet500  H-P DeskJet 500
# *	djet500c  H-P DeskJet 500C
#	epson	Epson-compatible dot matrix printers (9- or 24-pin)
# +	eps9high  Epson-compatible 9-pin, interleaved lines
#		(triple resolution)
# *	epsonc	Epson LQ-2550 and Fujitsu 3400/2400/1200 color printers
# +	laserjet  H-P LaserJet
# *	la50	DEC LA50 printer
# *	la75	DEC LA75 printer
# *	lbp8	Canon LBP-8II laser printer
# *	ln03	DEC LN03 printer
# *	lj250	DEC LJ250 Companion color printer
# +	ljet2p	H-P LaserJet IId/IIp/III* with TIFF compression
# +	ljet3	H-P LaserJet III* with Delta Row compression
# +	ljetplus  H-P LaserJet Plus
# *	necp6	NEC P6/P6+/P60 printers at 360 x 360 DPI resolution
# *	nwp533  Sony Microsystems NWP533 laser printer   [Sony only]
#	paintjet  H-P PaintJet color printer
# *	pjetxl	H-P PaintJet XL color printer
# *	r4081	Ricoh 4081 laser printer
# *	tek4696  Tektronix 4695/4696 inkjet plotter
# *	trufax	TruFax facsimile driver  [Unix only]
# File formats and others:
#	bit	A plain "bit bucket" device
#	gifmono	Monochrome GIF file format
#	gif8	8-bit color GIF file format
#	pcxmono	Monochrome PCX file format
#	pcx16	Older color PCX file format (EGA/VGA, 16-color)
#	pcx256	Newer color PCX file format (256-color)
#	pbm	Portable Bitmap (plain format)
#	pbmraw	Portable Bitmap (raw format)
#	pgm	Portable Graymap (plain format)
#	pgmraw	Portable Graymap (raw format)
#	ppm	Portable Pixmap (plain format)
#	ppmraw	Portable Pixmap (raw format)

# User-contributed drivers marked with * require hardware or software
# that is not available to Aladdin Enterprises.  Please contact the
# original contributors, not Aladdin Enterprises, if you have questions.
# Contact information appears in the driver entry below.
#
# Drivers marked with a + are maintained by Aladdin Enterprises with
# the assistance of users, since Aladdin Enterprises doesn't have access to
# the hardware for these either.

# If you add drivers, it would be nice if you kept each list
# in alphabetical order.

# Each platform-specific makefile contains a line of the form
#	DEVICE_DEVS=<dev1>.dev ... <devn>.dev
# where dev1 ... devn are the devices to be included in the build.
# You may edit this line to select any desired set of devices.
# dev1 will be used as the default device (unless overridden from
# the command line with -sDEVICE=xxx, of course.)  If you can't fit all the
# devices on a single line, you may add lines defining
#	DEVICE_DEVS2=<dev21>.dev ... <dev2n>.dev
#	DEVICE_DEVS3=<dev31>.dev ... <dev3n>.dev
# etc. up to DEVICE_DEVS5.
# Don't use continuation lines, since this may break the MS-DOS command
# processor.

# ---------------------------- End of catalog ---------------------------- #

# If you want to add a new device driver, the examples below should be
# enough of a guide to the correct form for the makefile rules.

# All device drivers depend on the following:
GDEV=$(AK) echogs$(XE) $(gserrors_h) $(gx_h) $(gxdevice_h)

# Define the header files for device drivers.  Every header file used by
# more than one device driver must be listed here.
gdevpccm_h=gdevpccm.h
gdevpcfb_h=gdevpcfb.h
gdevpcl_h=gdevpcl.h
gdevsvga_h=gdevsvga.h
gdevx_h=gdevx.h

###### ------------------- MS-DOS display devices ------------------- ######

# There are really only two drivers: an EGA/VGA driver (4 bit-planes,
# plane-addressed) and a SuperVGA driver (8 bit-planes, byte addressed).

### ----------------------- EGA and VGA displays ----------------------- ###

gdevegaa.$(OBJ): gdevegaa.asm

ETEST=ega.$(OBJ) $(ega_) gdevpcfb.$(OBJ) gdevegaa.$(OBJ)
ega.exe: $(ETEST) libc$(MM).tr
	$(COMPDIR)\tlink /v $(LIBDIR)\c0$(MM) @ega.tr @libc$(MM).tr

ega.$(OBJ): ega.c $(GDEV)
	$(CCC) -v ega.c

# The shared MS-DOS makefile defines PCFBASM as either gdevegaa.$(OBJ)
# or an empty string.

EGAVGA=gdevpcfb.$(OBJ) $(PCFBASM)

gdevpcfb.$(OBJ): gdevpcfb.c $(GDEV) $(MAKEFILE) $(dos__h) $(gdevpcfb_h)
	$(CCD) -DUSE_ASM=0$(USE_ASM) gdevpcfb.c

# The EGA/VGA family includes: EGA, VGA, and MDB-10, and the
# Tseng ET3000/4000 and Trident SuperVGA in 16-color mode.

ega.dev: $(EGAVGA)
	$(SHP)gssetdev ega $(EGAVGA)

vga.dev: $(EGAVGA)
	$(SHP)gssetdev vga $(EGAVGA)

mdb10.dev: $(EGAVGA)
	$(SHP)gssetdev mdb10 $(EGAVGA)

tseng16.dev: $(EGAVGA)
	$(SHP)gssetdev tseng16 $(EGAVGA)

tvga16.dev: $(EGAVGA)
	$(SHP)gssetdev tvga16 $(EGAVGA)

### ------------------------- SuperVGA displays ------------------------ ###

SVGA=gdevsvga.$(OBJ) $(PCFBASM)

gdevsvga.$(OBJ): gdevsvga.c $(GDEV) $(MAKEFILE) $(dos__h) $(gdevpcfb_h) $(gdevsvga_h)
	$(CCD) -DUSE_ASM=0$(USE_ASM) gdevsvga.c

# The SuperVGA family includes: ATI Wonder, S3, Trident, Tseng ET3000/4000,
# and VESA.

atiw.dev: $(SVGA)
	$(SHP)gssetdev atiw $(SVGA)

tseng.dev: $(SVGA)
	$(SHP)gssetdev tseng $(SVGA)

tvga.dev: $(SVGA)
	$(SHP)gssetdev tvga $(SVGA)

vesa.dev: $(SVGA)
	$(SHP)gssetdev vesa $(SVGA)

# The S3 driver doesn't share much code with the others.

s3vga_=$(SVGA) gdevs3ga.$(OBJ)
s3vga.dev: $(s3vga_)
	$(SHP)gssetdev s3vga $(s3vga_)

gdevs3ga.$(OBJ): gdevsvga.c $(GDEV) $(MAKEFILE) $(gdevpcfb_h) $(gdevsvga_h)
	$(CCD) gdevs3ga.c

### ------------ The BGI (Borland Graphics Interface) device ----------- ###

# We should use an implicit rule for running bgiobj,
# but a bug in Borland's `make' utility makes this not work.

cga.$(OBJ): $(BGIDIR)\cga.bgi
	$(BGIDIR)\bgiobj $(BGIDIR)\$&

egavga.$(OBJ): $(BGIDIR)\egavga.bgi
	$(BGIDIR)\bgiobj $(BGIDIR)\$&

herc.$(OBJ): $(BGIDIR)\herc.bgi
	$(BGIDIR)\bgiobj $(BGIDIR)\$&

# Include egavga.$(OBJ) for debugging only.
bgi_=gdevbgi.$(OBJ) cga.$(OBJ) herc.$(OBJ)
bgi.dev: $(bgi_)
	$(SHP)gssetdev bgi $(bgi_)
	$(SHP)gsaddmod bgi -lib $(LIBDIR)\graphics

gdevbgi.$(OBJ): gdevbgi.c $(GDEV) $(MAKEFILE)
	$(CCC) -DBGI_LIB=$(QQ)$(BGIDIR)$(QQ) gdevbgi.c

###### ------------------- The Private Eye display ------------------- ######
### Note: this driver was contributed by a user:                          ###
###   please contact narf@media-lab.media.mit.edu if you have questions.  ###

pe_=gdevpe.$(OBJ)
pe.dev: $(pe_)
	$(SHP)gssetdev pe $(pe_)

gdevpe.$(OBJ): gdevpe.c $(GDEV)

###### ----------------- The MS-Windows 3.n display ------------------ ######

mswin_=gdevmswn.$(OBJ)
mswin.dev: $(mswin_)
	$(SHP)gssetdev mswin $(mswin_)

gdevmswn.$(OBJ): gdevmswn.c $(GDEV) $(gp_h) $(gpcheck_h)

###### ----------- The AT&T 3b1 Unixpc monochrome display ------------ ######

att3b1_=gdev3b1.$(OBJ)
att3b1.dev: $(att3b1_)
	$(SHP)gssetdev att3b1 $(att3b1_)

gdev3b1.$(OBJ): gdev3b1.c

###### --------------- Memory-buffered printer devices --------------- ######

PDEVH=$(GDEV) $(gdevprn_h)

gdevprn.$(OBJ): gdevprn.c $(PDEVH) $(gp_h) $(gsprops_h)

### ----------------- The Canon BubbleJet BJ10e device ----------------- ###

bj10e_=gdevbj10.$(OBJ) gdevprn.$(OBJ)
bj10e.dev: $(bj10e_)
	$(SHP)gssetdev bj10e $(bj10e_)

gdevbj10.$(OBJ): gdevbj10.c $(PDEVH)

### -------------------------- The DigiFAX device ----------------------- ###
###    This driver outputs images in a format suitable for use with       ###
###    DigiBoard, Inc.'s DigiFAX software.  Use -sDEVICE=dfaxhigh for     ###
###    high resolution output, -sDEVICE=dfaxlow for normal output.        ###
### Note: this driver was contributed by a user: please contact           ###
###       Rick Richardson (rick@digibd.com) if you have questions.        ###

digifax_=gdevdfax.$(OBJ) gdevprn.$(OBJ)
dfaxhigh.dev: $(digifax_)
	$(SHP)gssetdev dfaxhigh $(digifax_)

dfaxlow.dev: $(digifax_)
	$(SHP)gssetdev dfaxlow $(digifax_)

gdevdfax.$(OBJ): gdevdfax.c $(GDEV) $(gdevprn_h) gdevdfg3.h

### ----------- The H-P DeskJet and LaserJet printer devices ----------- ###

### These are essentially the same device.
### You can make A4 paper the default: see below.
### NOTE: printing at full resolution (300 DPI) requires a printer
###   with at least 1.5 Mb of memory.  150 DPI only requires .5 Mb.

HPPCL=gdevprn.$(OBJ) gdevpcl.$(OBJ)
HPMONO=gdevdjet.$(OBJ) $(HPPCL)

gdevpcl.$(OBJ): gdevpcl.c $(PDEVH) $(gdevpcl_h)

# To make A4 paper the default, change the second line below this to
#	$(CCC) -DA4 gdevdjet.c
gdevdjet.$(OBJ): gdevdjet.c $(PDEVH) $(gdevpcl_h)
	$(CCC) gdevdjet.c

deskjet.dev: $(HPMONO)
	$(SHP)gssetdev deskjet $(HPMONO)

djet500.dev: $(HPMONO)
	$(SHP)gssetdev djet500 $(HPMONO)

laserjet.dev: $(HPMONO)
	$(SHP)gssetdev laserjet $(HPMONO)

ljetplus.dev: $(HPMONO)
	$(SHP)gssetdev ljetplus $(HPMONO)

### Selecting ljet2p provides TIFF (mode 2) compression on LaserJet III,
### IIIp, IIId, IIIsi, IId, and IIp. 

ljet2p.dev: $(HPMONO)
	$(SHP)gssetdev ljet2p $(HPMONO)

### Selecting ljet3 provides Delta Row (mode 3) compression on LaserJet III,
### IIIp, IIId, IIIsi.

ljet3.dev: $(HPMONO)
	$(SHP)gssetdev ljet3 $(HPMONO)

### ------------ The H-P DeskJet 500C color printer device -------------- ###
### Note: there are two different 500C drivers, both contributed by users.###
###   If you have questions about the djet500c driver,                    ###
###       please contact AKayser@et.tudelft.nl.                           ###
###   If you have questions about the cdeskjet/cdjcolor/cdjmono drivers,  ###
###       please contact g.cameron@biomed.abdn.ac.uk.                     ###

cdeskjet_=gdevcdj.$(OBJ) $(HPPCL)

cdeskjet.dev: $(cdeskjet_)
	$(SHP)gssetdev cdeskjet $(cdeskjet_)

cdjcolor.dev: $(cdeskjet_)
	$(SHP)gssetdev cdjcolor $(cdeskjet_)

cdjmono.dev: $(cdeskjet_)
	$(SHP)gssetdev cdjmono $(cdeskjet_)

# To make A4 paper the default, change the second line below this to
#	$(CCC) -DA4 gdevdjet.c
gdevcdj.$(OBJ): gdevcdj.c $(PDEVH) $(gdevpcl_h)
	$(CCC) gdevcdj.c

djet500c_=gdevdjtc.$(OBJ) $(HPPCL)
djet500c.dev: $(djet500c_)
	$(SHP)gssetdev djet500c $(djet500c_)

gdevdjtc.$(OBJ): gdevdjtc.c $(PDEVH) $(gdevpcl_h)

### ----------------- The generic Epson printer device ----------------- ###

epson_=gdevepsn.$(OBJ) gdevprn.$(OBJ)

epson.dev: $(epson_)
	$(SHP)gssetdev epson $(epson_)

eps9high.dev: $(epson_)
	$(SHP)gssetdev eps9high $(epson_)

gdevepsn.$(OBJ): gdevepsn.c $(PDEVH) devs.mak

### -------------- The Epson LQ-2550 color printer device -------------- ###
### Note: this driver was contributed by users: please contact           ###
###       Dave St. Clair (dave@exlog.com) if you have questions.         ###

epsonc_=gdevepsc.$(OBJ) gdevprn.$(OBJ)
epsonc.dev: $(epsonc_)
	$(SHP)gssetdev epsonc $(epsonc_)

gdevepsc.$(OBJ): gdevepsc.c $(PDEVH) devs.mak

### ------------ The H-P PaintJet color printer device ----------------- ###
### Note: this driver also supports the DEC LJ250 color printer, which   ###
###       has a PaintJet-compatible mode, and the PaintJet XL.           ###
### If you have questions about the XL, please contact Rob Reiss         ###
###       (rob@moray.berkeley.edu).                                      ###

PJET=gdevpjet.$(OBJ) $(HPPCL)

gdevpjet.$(OBJ): gdevpjet.c $(PDEVH) $(gdevpcl_h)

lj250.dev: $(PJET)
	$(SHP)gssetdev lj250 $(PJET)

paintjet.dev: $(PJET)
	$(SHP)gssetdev paintjet $(PJET)

pjetxl.dev: $(PJET)
	$(SHP)gssetdev pjetxl $(PJET)

### ----------------- The Canon LBP-8II printer device ----------------- ###
### Note: this driver was contributed by users: please contact           ###
###       Tom Quinn (trq@prg.oxford.ac.uk) if you have questions.        ###
### Note that the standard paper size for this driver is the European    ###
###   A4 size, not the American 8.5" x 11" size.                         ###

lbp8_=gdevlbp8.$(OBJ) gdevprn.$(OBJ)
lbp8.dev: $(lbp8_)
	$(SHP)gssetdev lbp8 $(lbp8_)

gdevlbp8.$(OBJ): gdevlbp8.c $(PDEVH)

### -------------- The DEC LN03/LA50/LA75 printer devices -------------- ###
### Note: this driver was contributed by users: please contact           ###
###       Ulrich Mueller (ulm@vsnhd1.cern.ch) if you have questions.     ###
### A more general sixel driver is available from                        ###
###       Ian MacPhedran (macphed@dvinci.USask.CA).                      ###

ln03_=gdevln03.$(OBJ) gdevprn.$(OBJ)
ln03.dev: $(ln03_)
	$(SHP)gssetdev ln03 $(ln03_)

la50.dev: $(ln03_)
	$(SHP)gssetdev la50 $(ln03_)

la75.dev: $(ln03_)
	$(SHP)gssetdev la75 $(ln03_)

gdevln03.$(OBJ): gdevln03.c $(PDEVH)

### --------------------- The NEC P6 family devices -------------------- ###

necp6_=gdevnp6.$(OBJ) gdevprn.$(OBJ)
necp6.dev: $(necp6_)
	$(SHP)gssetdev necp6 $(necp6_)

gdevnp6.$(OBJ): gdevnp6.c $(PDEVH)

### ------------- The Ricoh 4081 laser printer device ------------------ ###
### Note: this driver was contributed by users:                          ###
###       please contact kdw@oasis.icl.co.uk if you have questions.      ###

r4081_=gdev4081.$(OBJ) gdevprn.$(OBJ)
r4081.dev: $(r4081_)
	$(SHP)gssetdev r4081 $(r4081_)

gdev4081.$(OBJ): gdev4081.c $(PDEVH)

###### ------------------------ Sony devices ------------------------ ######
### Note: these drivers were contributed by users: please contact        ###
###       Mike Smolenski (mike@intertech.com) if you have questions.     ###

### ------------------- Sony NeWS frame buffer device ------------------ ###

sonyfb_=gdevsnfb.$(OBJ) gdevprn.$(OBJ)
sonyfb.dev: $(sonyfb_)
	$(SHP)gssetdev sonyfb $(sonyfb_)

gdevsnfb.$(OBJ): gdevsnfb.c $(PDEVH)

### -------------------- Sony NWP533 printer device -------------------- ###

nwp533_=gdevn533.$(OBJ) gdevprn.$(OBJ)
nwp533.dev: $(nwp533_)
	$(SHP)gssetdev nwp533 $(nwp533_)

gdevn533.$(OBJ): gdevn533.c $(PDEVH)

###### --------------------- The SunView device --------------------- ######
### Note: this driver is maintained by a user: if you have questions,    ###
###       please contact Andreas Stolcke (stolcke@icsi.berkeley.edu).    ###

sunview_=gdevsun.$(OBJ)
sunview.dev: $(sunview_)
	$(SHP)gssetdev sunview $(sunview_)
	$(SHP)gsaddmod sunview -lib suntool sunwindow pixrect

gdevsun.$(OBJ): gdevsun.c $(GDEV) $(arch_h)

### -------------------- Tektronix ink-jet printers -------------------- ###
### Note: this driver was contributed by a user: please contact          ###
###       Karsten Spang (spang@nbivax.nbi.dk) if you have questions.     ###

tek4696_=gdevtknk.$(OBJ) gdevprn.$(OBJ)
tek4696.dev: $(tek4696_)
	$(SHP)gssetdev tek4696 $(tek4696_)

gdevtknk.$(OBJ): gdevtknk.c $(PDEVH)

### ----------------- The TruFax facsimile device ---------------------- ###
### Note: this driver was contributed by users: please contact           ###
###       Neil Ostroff (nao@maestro.bellcore.com) if you have questions. ###
### Note that the driver requires a file encode_l.o supplied by the      ###
###   makers of the TruFax product.                                      ###

trufax_=gdevtrfx.$(OBJ) gdevprn.$(OBJ) encode_l.$(OBJ)
trufax.dev: $(trufax_)
	$(SHP)gssetdev trufax $(trufax_)

gdevtrfx.$(OBJ): gdevtrfx.c $(GDEV)

###### ----------------------- The X11 device ----------------------- ######

# Aladdin Enterprises does not support Ghostview.  For more information
# about Ghostview, please contact Tim Theisen (ghostview@cs.wisc.edu).

x11_=gdevx.$(OBJ) gdevxini.$(OBJ)
x11.dev: $(x11_)
	$(SHP)gssetdev x11 $(x11_)
	$(SHP)gsaddmod x11 -lib X11

# See the main makefile for the definition of XINCLUDE.
GDEVX=$(GDEV) x_.h gdevx.h $(MAKEFILE)
gdevx.$(OBJ): gdevx.c $(GDEVX) $(gserrors_h) $(gsprops_h) $(gsutil_h)
	$(CCC) $(XINCLUDE) gdevx.c

gdevxini.$(OBJ): gdevxini.c $(GDEVX)
	$(CCC) $(XINCLUDE) gdevxini.c

### ---------------------- The bit bucket device ----------------------- ###

bit_=gdevbit.$(OBJ) gdevprn.$(OBJ)
bit.dev: $(bit_)
	$(SHP)gssetdev bit $(bit_)

gdevbit.$(OBJ): gdevbit.c $(PDEVH)

###### ----------------------- PC file formats ---------------------- ######

gdevpccm.$(OBJ): gdevpccm.c $(AK) \
  $(gs_h) $(gsmatrix_h) $(gxdevice_h) $(gdevpccm_h)

### ------------------------- GIF file formats ------------------------- ###

GIF=gdevgif.$(OBJ) gdevpccm.$(OBJ) gdevprn.$(OBJ)

gdevgif.$(OBJ): gdevgif.c $(PDEVH) $(gdevpccm_h)

gifmono.dev: $(GIF)
	$(SHP)gssetdev gifmono $(GIF)

gif8.dev: $(GIF)
	$(SHP)gssetdev gif8 $(GIF)

### ------------------------- PCX file formats ------------------------- ###

PCX=gdevpcx.$(OBJ) gdevpccm.$(OBJ) gdevprn.$(OBJ)

gdevpcx.$(OBJ): gdevpcx.c $(PDEVH) $(gdevpccm_h)

pcxmono.dev: $(PCX)
	$(SHP)gssetdev pcxmono $(PCX)

pcx16.dev: $(PCX)
	$(SHP)gssetdev pcx16 $(PCX)

pcx256.dev: $(PCX)
	$(SHP)gssetdev pcx256 $(PCX)

###### ------------------- Portable Bitmap devices ------------------ ######
### For more information, see the pbm(5), pgm(5), and ppm(5) man pages.  ###

PXM=gdevpbm.$(OBJ) gdevprn.$(OBJ)

gdevpbm.$(OBJ): gdevpbm.c $(PDEVH) $(gxlum_h)

### Portable Bitmap (PBM, plain or raw format, magic numbers "P1" or "P4")

pbm.dev: $(PXM)
	$(SHP)gssetdev pbm $(PXM)

pbmraw.dev: $(PXM)
	$(SHP)gssetdev pbmraw $(PXM)

### Portable Graymap (PGM, plain or raw format, magic numbers "P2" or "P5")

pgm.dev: $(PXM)
	$(SHP)gssetdev pgm $(PXM)

pgmraw.dev: $(PXM)
	$(SHP)gssetdev pgmraw $(PXM)

### Portable Pixmap (PPM, plain or raw format, magic numbers "P3" or "P6")

ppm.dev: $(PXM)
	$(SHP)gssetdev ppm $(PXM)

ppmraw.dev: $(PXM)
	$(SHP)gssetdev ppmraw $(PXM)
