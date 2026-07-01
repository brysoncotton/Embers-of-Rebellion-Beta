function simple_power(base, exponent)
	if exponent == 0 then
		return 1
	end

	local result = 1

	for i = 1, exponent do
		result = result * base
	end

	return result
end

function factorial(n)
	if n == 0 then
		return 1
	else
		return n * factorial(n - 1)
	end
end

function exp_approx(a, N)
	local result = 0

	for k = 0, N do
		result = result + simple_power(a, k) / factorial(k)
	end

	return result
end

function ln_approx(x)
	local gamma = 0.5772156649 -- Euler-Mascheroni constant
	local result = 0

	for n = 1, x do
		result = result + 1 / n
	end

	return -gamma + result
end

function power(base, exponent)
	if base < 10 then
		scaled_approx = 1/4 * ln_approx(simple_power(base, 4))
	else
		scaled_approx = ln_approx(base)
	end
	return exp_approx(exponent * scaled_approx, 20)
end

-- returns the probability curve for an event that will occur
-- 50% of the time at mean_time, and tends towards 100% chance
-- at infinite time. 
-- check_time is the number of time units between each roll
-- e.g. once per cycle = 1 if mean_time is in cycles
function MeanTimeToHappenChance(check_time, mean_time)
	if check_time / mean_time > 9 then
		return 1 - 1 / simple_power(2, check_time / mean_time)
	else
		return 1 - power(2, -check_time / mean_time)
	end
end

-- Feed in a table of integers, return an index proportional to the ration of the integer vs the sum of integers
-- e.g. {3, 2, 1} will return 1 50% of the time, 2 33% of the time, and 3 17% of the time
function WeightedRandomIndex(weights)
	local running_sum = 0
	for index, weight in ipairs(weights) do
		weights[index] = weight + running_sum
		running_sum = weights[index]
	end
	
	local pick = GameRandom.Free_Random(1, running_sum)
	for index, weight in ipairs(weights) do
		if pick <= weight then
			return index
		end
	end
end
