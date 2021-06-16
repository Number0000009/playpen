# NOTE: It's crucial to use the same standard as SystemC was build with!!!
g++ ./first_counter_tb.cpp -lsystemc -L ../systemc-2.3.3/build/src/ -I ../systemc-2.3.3/src/ -std=c++17
