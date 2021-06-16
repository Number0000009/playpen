#include "systemc.h"

SC_MODULE(adder)					// module (class) declaration
{
	sc_in<int> a, b;				// ports
	sc_out<int> sum;

	void do_add()					// process
	{
		sum.write(a.read() + b.read());		// or just sum = a + b
	}

	SC_CTOR(adder)					// constructor
	{
		SC_METHOD(do_add);			// register do_add to kernel
		sensitive << a << b;			// sensitivity list of do_add
	}
};

int sc_main(int argc, char *argv[])
{
	sc_signal<int> a{"IN1"};
	sc_signal<int> b{"IN2"};
	sc_signal<int> sum{"SUM"};

	adder add("ADDER");
	add.a(a);
	add.b(b);
	add.sum(sum);

	a = 0x42;
	b = 0x01;

	sc_start(1, sc_time_unit::SC_NS);

	std::cout << sum << std::endl;

	assert(sum == 0x43);

	return 0;
}
