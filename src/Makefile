# Makefile to compile and download a simple Verilog program

DEVICE=xc3s100e-4-vq100
default: clock.bin

clock.ngc: clock.v
	echo "run -ifn clock.v -ifmt Verilog -ofn clock -fsm_extract no -optimize_primitives NO -equivalent_register_removal NO -p \
	$(DEVICE) -opt_mode Speed -opt_level 1 -top top" | xst

clock.ngd: clock.ngc clock.ucf
	ngdbuild -p $(DEVICE) -uc clock.ucf clock.ngc

clock.ncd: clock.ngd
	map -k 6 -detail -pr b clock.ngd

clock.pcf: clock.ngd
	map -k 6 -detail -pr b clock.ngd

parout.ncd: clock.ncd
	par -w clock.ncd parout.ncd clock.pcf

clock.bit: parout.ncd
	bitgen -w -g CRC:Enable -g StartUpClk:CClk -g Compress \
	parout.ncd clock.bit clock.pcf

clock.bin: clock.bit
	promgen -w -p bin -o clock.bin -u 0 clock.bit

install: clock.bin
	stty --file=/dev/ttyUSB0 -opost  # We want raw output
	cat clock.bin > /dev/ttyUSB0

clean:
	rm -rf clock.bgn clock.bin clock.bit clock.bld \
	clock.drc clock.map clock_map.xrpt clock.mrp \
	clock.ncd clock.ngc clock.ngd clock_ngdbuild.xrpt \
	clock.ngm clock_par.xrpt clock.pcf clock.prm \
	clock_summary.xml clock_usage.xml clock_xst.xrpt \
	netlist.lst parout.ncd parout.pad parout_pad.csv \
	parout_pad.txt parout.par parout.ptwx parout.unroutes \
	parout.xpi xlnx_auto_0.ise xlnx_auto_0_xdb xst

test:
	cat /dev/ttyUSB0
