FILE_SIZE_LIMIT_MB = 25
LARGE_FILES := $(shell find . -type f -size +$(FILE_SIZE_LIMIT_MB)M -not -path "./.git/*")

LARGE_FILES_GZ := $(addsuffix .gz, $(LARGE_FILES))

ARCHIVES := $(shell find . -type f -name "*.gz")
ARCHIVE_SOURCES := $(basename $(ARCHIVES))

.PHONY: clean
clean:
	echo "clean"



.PHONY: verify
verify:
	echo "verify"



$(LARGE_FILES_GZ): %.gz: %
	@if [ $(suffix $<) == ".gz" ]; then\
		echo "Warning: $< is already compressed. Skipping...";\
	else\
		gzip $< > /dev/null &&\
		echo "$< -> $@";\
	fi

# This target compresses all files larger than 25 MB
.PHONY: compress
compress: $(LARGE_FILES_GZ)
	@echo "Files larger than $(FILE_SIZE_LIMIT_MB) MBytes are compressed!"



$(ARCHIVE_SOURCES): %: %.gz
	@gzip -d $< &&\
	echo "$< -> $@"

.PHONY: uncompress
uncompress: $(ARCHIVE_SOURCES)
	@echo "All files are uncompressed!"
