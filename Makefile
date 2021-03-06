#OBJ_DIR = ./
HEADERS = Variant.h \
		  split.h \
		  join.h
SOURCES = Variant.cpp \
		  split.cpp
OBJECTS= $(SOURCES:.cpp=.o)

# TODO
#vcfstats.cpp

BIN_SOURCES = vcfecho.cpp \
			  vcfaltcount.cpp \
			  vcfhetcount.cpp \
			  vcffilter.cpp \
			  vcf2tsv.cpp \
			  vcfgenotypes.cpp \
			  vcfannotategenotypes.cpp \
			  vcfcommonsamples.cpp \
			  vcfgenotypecompare.cpp \
			  vcffixup.cpp \
			  vcfclassify.cpp \
			  vcfsamplediff.cpp \
			  vcfremoveaberrantgenotypes.cpp \
			  vcfrandom.cpp \
			  vcfparsealts.cpp \
			  vcfstats.cpp \
			  vcfflatten.cpp

BINS = $(BIN_SOURCES:.cpp=)

TABIX = tabixpp/tabix.o

SMITHWATERMAN = smithwaterman/SmithWatermanGotoh.o

INCLUDES = -lm -lz -L. -Ltabixpp/ -ltabix

all: $(OBJECTS) $(BINS)

CXX = g++
CXXFLAGS = -O3

gprof:
	$(MAKE) CXXFLAGS="$(CXXFLAGS) -pg" all

$(OBJECTS): $(SOURCES) $(HEADERS) $(TABIX)
	$(CXX) -c -o $@ $(*F).cpp  $(INCLUDES) $(LDFLAGS) $(CXXFLAGS)

$(TABIX):
	cd tabixpp && $(MAKE)

$(SMITHWATERMAN):
	cd smithwaterman && $(MAKE)

$(BINS): $(BIN_SOURCES) $(OBJECTS) $(SMITHWATERMAN)
	$(CXX) $(OBJECTS) $(SMITHWATERMAN) tabixpp/tabix.o tabixpp/bgzf.o $@.cpp -o $@ $(INCLUDES) $(LDFLAGS) $(CXXFLAGS)

clean:
	rm -f $(BINS) $(OBJECTS)
	cd tabixpp && make clean
	cd smithwaterman && make clean

.PHONY: clean all
