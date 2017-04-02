# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<
	rm -f $@.deps

.PHONY: all

all: lowerFrame.stl              \
	 upperFrame.stl              \
	 carriage.stl				 \
	 glassHolder.stl			 \
	 azsmzPlate.stl			     \
	 smoothieboardPlate.stl		 \
	 mksSbasePlate.stl			 \
	 aBracingPost.stl            \
	 fusePlugHolder.stl			 \
	 copperPipeBearingHolder.stl \
	 copperPipeSpoolHolder.stl   \
	 e3dWedge.stl

.PHONY: clean

clean:
	rm -f *.stl *.stl.deps
