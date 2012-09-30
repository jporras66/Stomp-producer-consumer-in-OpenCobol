#
all: cobexamples
#
clean:
	cd asc2ebc  ; make clean
	cd brkmng   ; make clean
	cd brkcob   ; make clean 
	rm -f $(APL)/data/*.out $(APL)/data/*.err 
cobexamples:
	cd asc2ebc  ; make all
	cd brkmng   ; make all
	cd brkcob   ; make all 
