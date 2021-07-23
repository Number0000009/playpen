/*
Daily Coding Problem: Problem #53 [Medium]

Implement a queue using two stacks. Recall that a queue is a FIFO (first-in,
first-out) data structure with the following methods: enqueue, which inserts an
element into the queue, and dequeue, which removes it.
*/

#include <stack>
#include <array>
#include <iostream>
#include <optional>

template<typename T>
class queue
{
private:
	std::stack<T> stack;

public:
	auto enqueue(T&& d) -> void
	{
		stack.push(d);
	}

	auto dequeue() -> std::optional<T>
	{
		std::stack<T> temporary_stack;
		T element;

		if (stack.empty()) {
			return std::nullopt;
		}

		/* Flip stack */
		while (!stack.empty()) {
			element = stack.top();
			stack.pop();
			temporary_stack.push(element);
		}

		/* Remove first element of the new stack */
		/* (i.e. remove last element of the initial stack) */
		temporary_stack.pop();

		/* Flip the new stack again */
		while (!temporary_stack.empty()) {
			stack.push(temporary_stack.top());
			temporary_stack.pop();
		}

		return element;
	}

	auto print() -> void
	{
		auto temporary_stack {stack};

		while (!temporary_stack.empty()) {
			auto element {temporary_stack.top()};

			temporary_stack.pop();
			std::cout << element << std::endl;
		}
	}
};

int main()
{
	/* Should succeed */
	{
		queue<int> q;
		std::array<int, 3> check {41, 42, 43};

		bool passed {true};

		for (auto&& i : check) {
			q.enqueue(std::forward<int>(i));
		}

		std::cout << "Initial stack " << std::endl;
		q.print();

		std::cout << "Dequing..." << std::endl;

		for (auto&& i : check) {
			auto elem {q.dequeue()};
			std::cout << elem.value() << std::endl;

			if (elem != i) {
				passed = false;
				std::cerr << "Mismatch " << elem.value() << " and " << i << std::endl;
			}
		}
		std::cout << (passed ? "PASSED" : "FAILED") << std::endl;
	}

	/* Should error with std::nullopt elem and continue */
	{
		queue<int> q;
		std::array<int, 3> check {44, 45, 46};

		bool passed1 {true};
		bool passed2 {false};

		for (auto&& i : check) {
			q.enqueue(std::forward<int>(i));
		}

		std::cout << "Initial stack " << std::endl;
		q.print();

		std::cout << "Dequing..." << std::endl;

		for (auto&& i : check) {
			auto elem {q.dequeue()};
			std::cout << *elem << std::endl;

			if (!elem || elem != i) {
				passed1 = false;
				std::cerr << "Mismatch " << *elem << " and " << i << std::endl;
			}
		}

		auto elem {q.dequeue()};
		std::cout << *elem << std::endl;
		if (!elem) {
			passed2 = true;
		}

		std::cout << ((passed1 && passed2) ? "PASSED" : "FAILED") << std::endl;
	}

	/* Should succeed */
	{
		int check_constant {777};

		queue<int> q;
		q.enqueue(std::forward<int>(check_constant));

		bool passed {true};

		auto elem {q.dequeue()};
		std::cout << elem.value() << std::endl;

		if (elem != check_constant) {
			passed = false;
			std::cerr << "Mismatch " << elem.value() << " and " << check_constant << std::endl;
		}
		std::cout << (passed ? "PASSED" : "FAILED") << std::endl;
	}

	/* Should error with std::nullopt elem and continue */
	{
		queue<int> q;
		bool passed {false};

		auto elem {q.dequeue()};
		std::cout << *elem << std::endl;

		if (!elem) {
			passed = true;
		}
		std::cout << (passed ? "PASSED" : "FAILED") << std::endl;
	}

	/* Should fail */
	{
		queue<int> q;
		std::optional<int> elem {-42};
		bool passed {false};

		elem = q.dequeue();

		if (elem != -42) {
			passed = true;
		}
		std::cout << (passed ? "PASSED" : "FAILED") << std::endl;
	}
}
