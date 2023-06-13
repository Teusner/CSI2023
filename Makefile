# Directory configuration
BUILD_DIR = build
ABSTRACT_DIR = abstract
PRESENTATION_DIR = presentation
ARTICLE_DIR = article
IMGS_DIR = imgs
VIDEOS_DIR = videos

# Directory path combining
ABSTRACT_BUILD_DIR = $(BUILD_DIR)/$(ABSTRACT_DIR)
PRESENTATION_BUILD_DIR = $(BUILD_DIR)/$(PRESENTATION_DIR)
ARTICLE_BUILD_DIR = $(BUILD_DIR)/$(ARTICLE_DIR)
IMGS_BUILD_DIR = $(BUILD_DIR)/$(IMGS_DIR)

# TEX sources
TEX_SRCS := $(wildcard */*.tex)

# Directory guard
dir_guard = @mkdir -p $(@D)

# All recipe
all: presentation

### Numeric reports
$(ABSTRACT_BUILD_DIR)/abstract.pdf: src/abstract.tex
	$(dir_guard)
	latexmk -pdf -shell-escape -output-directory=$(ABSTRACT_BUILD_DIR) $<

presentation: videos $(PRESENTATION_BUILD_DIR)/presentation.pdf

$(PRESENTATION_BUILD_DIR)/presentation.pdf: src/presentation.tex
	$(dir_guard)
	latexmk -pdfxe -shell-escape -output-directory=$(PRESENTATION_BUILD_DIR) $<

# Videos
VIDEOS_SOURCES = $(wildcard videos/*.mkv)
VIDEOS_NAMES = $(VIDEOS_SOURCES:videos/%.mkv=%.mkv)
VIDEOS_THUMBNAIL = $(VIDEOS_SOURCES:videos/%.mkv=%.png)
videos: $(addprefix $(PRESENTATION_BUILD_DIR)/, ${VIDEOS_NAMES}) $(addprefix $(IMGS_BUILD_DIR)/videos/, ${VIDEOS_THUMBNAIL})

$(PRESENTATION_BUILD_DIR)/%.mkv : videos/%.mkv
	$(dir_guard)
	ln $< $@

$(IMGS_BUILD_DIR)/videos/%.png : videos/%.mkv
	$(dir_guard)
	ffmpeg -i $< -ss 00:00:45.000 -vframes 1 $@

# Clean recipe
clean:
	rm -rf $(BUILD_DIR)