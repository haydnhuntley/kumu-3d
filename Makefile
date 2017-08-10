# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<
	rm -f $@.deps

.PHONY: all

all: lowerFrame.stl              \
	 upperFrame.stl              \
	 upperFrame9mm.stl           \
	 carriage.stl				 \
	 carriageOutside.stl         \
	 glassHolder.stl			 \
	 azsmzPlate.stl			     \
	 smoothieboardPlate.stl		 \
	 mksSbasePlate.stl			 \
	 aBracingPost.stl            \
	 fusePlugHolder.stl			 \
	 copperPipeBearingHolder.stl \
	 copperPipeSpoolHolder.stl   \
     powerSupplyHolders.stl      \
	 e3dWedge.stl                \
     beltLocks9mm.stl

lowerFrame.stl: vertex.scad
upperFrame.stl: vertex.scad
upperFrame9.stl: vertex.scad

.PHONY: clean

clean:
	rm -f *.stl *.stl.deps
