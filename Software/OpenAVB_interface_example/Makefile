# Really simple
# Fixing up the location of OpenAVB may be necessary
OPENAVB_DIR=../../../Open-AVB-main
GPTP_LINUX_DIR=$(OPENAVB_DIR)/daemons/gptp/linux/src
GPTP_COMMON_DIR=$(OPENAVB_DIR)/daemons/gptp/common

.PHONY: all
all: example

example: example.cpp
	g++ -o example example.cpp -I$(GPTP_LINUX_DIR) -I$(GPTP_COMMON_DIR) \
	-lrt
