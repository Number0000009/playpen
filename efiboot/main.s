/*
Workflow:

% hdiutil attach ./disk.img
% cp ~/efiboot/boot.bin /Volumes/UNTITLED
% hdiutil eject /dev/disk4
% qemu-system-aarch64 -M virt -m 1G -cpu cortex-a72 -bios QEMU_EFI.fd -nographic -serial telnet::4444,server -drive if=none,file=disk.img,id=hd0 -device virtio-blk-device,drive=hd0 -nic user,model=virtio-net-pci -s

or

% emu-system-aarch64 -M virt -m 1G -cpu cortex-a72 -bios QEMU_EFI.fd -kernel boot.bin -serial mon:stdio -nographic -s
*/

.arch armv8-a

	UART_BASE = 0x09000000		// QEMU UART BASE
//	UART_BASE = 0x2a400000		// N1SDP UART BASE

	SEGMENT_ALIGN = 0x1000

	PECOFF_FILE_ALIGNMENT = 0x200

	PE_MAGIC = 0x00004550				// "PE\0\0"

	LINUX_EFISTUB_MAJOR_VERSION = 1
	LINUX_EFISTUB_MINOR_VERSION = 0

	PE_OPT_MAGIC_PE32PLUS = 0x020b

	IMAGE_FILE_MACHINE_ARM64 = 0xaa64
	IMAGE_FILE_EXECUTABLE_IMAGE = 0x0002
	IMAGE_FILE_LINE_NUMS_STRIPPED = 0x0004
	IMAGE_FILE_DEBUG_STRIPPED = 0x0200

	IMAGE_SUBSYSTEM_EFI_APPLICATION = 10

	IMAGE_SCN_CNT_CODE = 0x00000020			// .text
	IMAGE_SCN_CNT_INITIALIZED_DATA = 0x00000040	// .data
	IMAGE_SCN_CNT_UNINITIALIZED_DATA = 0x00000080	// .bss
	IMAGE_SCN_MEM_EXECUTE = 0x20000000		// executable
	IMAGE_SCN_MEM_READ = 0x40000000			// readable
	IMAGE_SCN_MEM_WRITE = 0x80000000		// writeable
	IMAGE_SCN_MEM_NOT_CACHED = 0x04000000		// cannot be cached
	IMAGE_SCN_MEM_NOT_PAGED = 0x08000000		//not pageable

	/*
	 * Emit a 64-bit absolute little endian symbol reference in a way that
	 * ensures that it will be resolved at build time, even when building a
	 * PIE binary. This requires cooperation from the linker script, which
	 * must emit the lo32/hi32 halves individually.
	 */
//	.macro	le64sym, sym
//	.long	\sym\()_lo32
//	.long	\sym\()_hi32
//	.endm

	.macro	ldr64, reg, imm64
	movz	\reg, (\imm64 & 0x000000000000ffff) >> 0
	movk	\reg, (\imm64 & 0xffff000000000000) >> 48, lsl #16
	movk	\reg, (\imm64 & 0x0000ffff00000000) >> 32, lsl #32
	movk	\reg, (\imm64 & 0x00000000ffff0000) >> 16, lsl #48
	.endm

.align	2
.text

.section .efi_header
._head:

// "MZ"
	ccmp	x18, #0, #0xd, pl

	b	start

	.quad	0					// Image load offset from start of RAM, LE

//	le64sym	image_size_le				// Effective size of image, LE
//	le64sym	image_flags_le				// Informative flags, LE

//	.quad	0xffff
	.quad	0
	.quad	0

	.quad	0					// Reserved
	.quad	0					// Reserved
	.quad	0					// Reserved

	.ascii	"ARM\x64"

	.long	.pe_header_offset			// Offset to the PE header

// PE Header

	.set	.pe_header_offset, . - ._head

	.long	PE_MAGIC
	.short	IMAGE_FILE_MACHINE_ARM64

	.short	.section_count				// Number of sections

	.long	0					// Time and date stamp
	.long	0					// Pointer to symbol table
	.long	0					// Number of symbols

	.short	.section_table - .optional_header	// Size of optional header

	.short	IMAGE_FILE_DEBUG_STRIPPED | IMAGE_FILE_EXECUTABLE_IMAGE | IMAGE_FILE_LINE_NUMS_STRIPPED

.optional_header:
	.short	PE_OPT_MAGIC_PE32PLUS			// PE32+ format
	.byte	0x02					// MajorLinkerVersion
	.byte	0x14					// MinorLinkerVersion
//	.long	__initdata_begin - .efi_header_end	// SizeOfCode
//	.long	_end - start				// SizeOfCode
	.long	0

	.long	0					// SizeOfInitializedData
	.long	0					// SizeOfUninitializedData
//	.long	_end - start				// SizeOfInitializedData
//	.long	_end - start				// SizeOfUninitializedtData

//	.long	__efistub_efi_pe_entry - ._head		// AddressOfEntryPoint
//	.long	start - ._head				// AddressOfEntryPoint
	.long	start

//	.long	.efi_header_end - ._head		// BaseOfCode
	.long	0					// BaseOfCode

	.quad	0					// ImageBase
	.long	SEGMENT_ALIGN				// SectionAlignment
	.long	PECOFF_FILE_ALIGNMENT			// FileAlignment
	.short	0					// MajorOperatingSystemVersion
	.short	0					// MinorOperatingSystemVersion
	.short	LINUX_EFISTUB_MAJOR_VERSION		// MajorImageVersion
	.short	LINUX_EFISTUB_MINOR_VERSION		// MinorImageVersion
	.short	0					// MajorSubsystemVersion
	.short	0					// MinorSubsystemVersion
	.long	0						// Win32VersionValue

//	.long	_end - ._head				// SizeOfImage
//	.long	_end - ._head + start - ._head		// ???
//	.long	start - ._head				// ???
//	.long	0x2000
//	.long	.efi_header_end - ._head + (.section_count * SEGMENT_ALIGN)	// header_size + number of 0x1000 bytes pages
	.long	0x1000 + 0x50000

	// Everything before the kernel image is considered part of the header
	.long	.efi_header_end - ._head		// SizeOfHeaders
	.long	0					// CheckSum
	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
	.short	0					// DllCharacteristics
	.quad	0					// SizeOfStackReserve
	.quad	0					// SizeOfStackCommit
	.quad	0					// SizeOfHeapReserve
	.quad	0					// SizeOfHeapCommit
	.long	0					// LoaderFlags
	.long	(.section_table - .) / 8		// NumberOfRvaAndSizes

	.quad	0					// ExportTable
	.quad	0					// ImportTable
	.quad	0					// ResourceTable
	.quad	0					// ExceptionTable
	.quad	0					// CertificationTable
	.quad	0					// BaseRelocationTable

.section_table:
	.ascii	".text\0\0\0"
/*
	.long	__initdata_begin - .efi_header_end	// Virtual size
	.long	.efi_header_end - ._head		// Virtual address
	.long	__initdata_begin - .efi_header_end	// Size of raw data
	.long	.efi_header_end - ._head		// Pointer to raw data
*/
/*
	.long	4					// Virtual size
	.long	start - ._head				// Virtual address

	.long	4					// Size of raw data
	.long	start - ._head				// Pointer to raw data
*/
//	.long	_end - start				// Virtual size
	.long	50*0x1000
	.long	start - ._head				// Virtual address

	.long	_end - start				// Size of raw data
	.long	start - ._head				// Pointer to raw data
//	.long	0x30000
//	.long	start - ._head
//	.long	0x30000
//	.long	start - ._head

	.long	0					// Pointer to relocations
	.long	0					// Pointer to line numbers
	.short	0					// Number of relocations
	.short	0					// Number of line numbers

	.long	IMAGE_SCN_CNT_CODE | IMAGE_SCN_MEM_READ | IMAGE_SCN_MEM_EXECUTE	// Characteristics

	.set	.section_count, (. - .section_table) / 40

	.balign	SEGMENT_ALIGN
.efi_header_end:

	.set	.pe_header_offset, 0x0

//.align	2
.global	start

//.text

//__initdata_begin:

	EL1 = (1 << 2)
	EL2 = (2 << 2)

start:
// mask DAIF- interrupts
	msr	DAIFSet, #0b1111

// here we have in x0 pointer to DTB
// and in x1 pointer to efi_system_table

	// Turn off dcache and MMU
	mrs	x2, CurrentEL
	cmp	x2, #EL2
	b.ne	start_in_el1

	mrs	x2, sctlr_el2
	bic	x2, x2, #1 << 0			// reset SCTLR.M
	bic	x2, x2, #1 << 2			// reset SCTLR.C
	msr	sctlr_el2, x2
	isb
	b	start_in_el2

start_in_el1:
	mrs	x2, sctlr_el1
	bic	x2, x2, #1 << 0			// reset SCTLR.M
	bic	x2, x2, #1 << 2			// reset SCTLR.C
	msr	sctlr_el1, x2
	isb

start_in_el2:
	mov	x2, UART_BASE

.wait_fr:
	ldrb	w3, [x2, #0x18]
	ands	w3, w3, #(1<<7)
	b.eq	.wait_fr

	mov	w3, #'*'
	strb	w3, [x2, #0x0]

/*
typedef	struct {
	u64 signature;
	u32 revision;
	u32 headersize;
	u32 crc32;
	u32 reserved;
} efi_table_hdr_t;

typedef union {
	struct {
		efi_table_hdr_t hdr;
		unsigned long fw_vendor;
		u32 fw_revision;
		unsigned long con_in_handle;
		efi_simple_text_input_protocol_t *con_in;
		unsigned long con_out_handle;
		efi_simple_text_output_protocol_t *con_out;
		unsigned long stderr_handle;
		unsigned long stderr;
		efi_runtime_services_t *runtime;
		efi_boot_services_t *boottime;
		unsigned long nr_tables;
		unsigned long tables;
	};
	efi_system_table_32_t mixed_mode;
} efi_system_table_t;

typedef union {
	struct {
		efi_guid_t guid;
		void *table;
	};
	efi_config_table_32_t mixed_mode;
} efi_config_table_t;
*/

// here x1 - EFI_SYSTEM_TABLE

// check for EFI_SYSTEM_TABLE signature
	ldr64	x3, 0x2049595354534249		// "IBI SYST"
	ldr	x4, [x1]
	cmp	x3, x4
	b.ne	.EFI_not_found

// nr_tables
	efi_system_table_nr_tables_offset = 8+4+4+4+4 + 8+4+8+8+8+8+8+8+8+8 +(4) // TODO: why +4???
	efi_system_table_tables_offset = efi_system_table_nr_tables_offset + 8

	ldr	x2, [x1, #efi_system_table_nr_tables_offset]

// find_system_table:
//	efi_acpi_20_table_guid = { 0x8868e871, 0xe4f1, 0x11d3, {0xbc, 0x22, 0x0, 0x80, 0xc7, 0x3c, 0x88, 0x81 }}

	ldr	x1, [x1, #efi_system_table_tables_offset]

.EFI_find_system_table:
	ldr64	x3, 0x8868e4f111d3e871
	ldr	x4, [x1], #8			// efi_acpi_20_table_guid_hi
	cmp	x3, x4
	b.ne	.EFI_system_table_not_found_guid_hi

	ldr64	x3, 0x80003cc7818822bc
	ldr	x4, [x1], #8			// efi_acpi_20_table_guid_lo
	cmp	x3, x4
	b.eq	.EFI_system_table_found

.EFI_system_table_not_found_guid_hi:

	add	x1, x1, #(8 + 8)		// guid_hi + void *
	sub	x2, x2, #1
	cbnz	x2, .EFI_find_system_table

.EFI_not_found:
	mov	x2, xzr
	b	.no_efi

.EFI_system_table_found:
	ldr	x2, [x1]			// RSDP

.no_efi:
	mov	x1, xzr
	mov	x3, xzr

// unmask DAIF- interrupts
//	msr	DAIFClr, #0b1111

// disable virtual timer
	msr	CNTV_CTL_EL0, x3

	b	.continue

	.balign	SEGMENT_ALIGN
.continue:
	.incbin	"kernel.bin"
