# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<
	rm -f $@.deps

.PHONY: all

all: copperPipeBearingHolder.stl \
	 copperPipeSpoolHolder.stl   \
	 lowerFrame.stl

.PHONY: clean

clean:
	rm -f *.stl *.stl.deps
