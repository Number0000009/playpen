#!/bin/bash

MODEL=fast_model_AEMv8A.exe
WORKDIR=$(builtin cd $(dirname $0) && pwd)
IMAGE=${WORKDIR}/main

${MODEL} \
	-S -V -R \
	-C bp.secure_memory=false \
	-C bp.pl011_uart0.uart_enable=true \
	-C bp.pl011_uart1.uart_enable=false \
	-C bp.refcounter.non_arch_start_at_default=true \
	-a cluster0.cpu0=${IMAGE} \
	-C bp.terminal_0.start_port=31337 \
	-C bp.terminal_1.start_port=31337 \
	-C bp.terminal_2.start_port=31337 \
	-C bp.terminal_3.start_port=31337 \
	--plugin plugins/Linux64_GCC-4.8/TarmacTraceV8.so
