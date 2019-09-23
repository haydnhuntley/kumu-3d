# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<
	rm -f $@.deps

.PHONY: all

all: aBracingPost.stl            \
	 azsmzPlate.stl			     \
	 carriage4Outside.stl        \
	 carriage4.stl				 \
	 carriageOutside.stl         \
	 carriage.stl				 \
	 copperPipeBearingHolder.stl \
	 copperPipeSpoolHolder.stl   \
	 e3dWedge.stl                \
	 effector.stl                \
     flyingExtruderSuspender.stl \
	 fusePlugHolder.stl			 \
	 glassHolder.stl			 \
	 keyBakLifter.stl			 \
	 lowerFrame.stl              \
     powerSupplyHolders.stl      \
	 upperFrame.stl              \
	 upperFrame9mm.stl           \
     zProbe.stl					 \
     zProbeVolcano.stl			 \
	 smoothieboardPlate.stl		 \
	 mksSbasePlate.stl
	 

lowerFrame.stl:    vertex.scad
upperFrame.stl:    vertex.scad
upperFrame9mm.stl: vertex.scad

.PHONY: clean

clean:
	rm -f *.stl *.stl.deps
