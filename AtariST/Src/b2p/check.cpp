#include <cstdio>
#include <cassert>

struct table_entry {
	uint16_t plane[4];
};

struct tbl {
	struct table_entry entries[16];
};

struct tbl table[16];

int main()
{
	FILE *f = fopen("table.bin", "rb");
	assert(f);

	size_t size = fread(table, 1, 2048, f);
	fclose(f);

	for (size_t i = 0; i < 16; ++i) {
// x86 is littleENDIAN, but data is BIGendian!!!
		printf("%.4x", table[1].entries[i].plane[0]);
		printf("%.4x", table[1].entries[i].plane[1]);
		printf("%.4x", table[1].entries[i].plane[2]);
		printf("%.4x\n", table[1].entries[i].plane[3]);
	}
}
