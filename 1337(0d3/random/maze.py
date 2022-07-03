#!/usr/bin/env python3

import random

for i in range(40):
	for j in range(40):
		print(random.choice(["/", "\\"]), end='')

	print()
