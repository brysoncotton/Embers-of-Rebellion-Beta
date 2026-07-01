require("PGDebug")
require("deepcore/std/class")

RandomDistribution = class()

function RandomDistribution:new()
	self.weighted_table = {}
	self.weight_table_length = 0
	self.cumulative_table = {}
	self.max_weight = 1
end
	
function RandomDistribution:Sample()
	local index = nil
	
	if table.getn(self.cumulative_table) == 0 then
		self.cumulative_table[1] = self.weighted_table[1][2]
		
		if self.weight_table_length > 1 then
			for i=2,self.weight_table_length do
				self.cumulative_table[i] = self.cumulative_table[i - 1] + self.weighted_table[i][2]
				self.max_weight = self.cumulative_table[i]
			end
		end
	end
	
	local sample = GameRandom.Free_Random(0, 100) / 100 * self.max_weight
	
	--DebugPrintTable(self.cumulative_table)
	
	--DebugMessage("%s -- sampling distribution up to max weight %s with random number %s", tostring(Script), tostring(self.max_weight), tostring(sample))
	
	for i, entry in ipairs(self.cumulative_table) do
		if entry >= sample then
			index = i
			break
		end
	end
	
	--DebugMessage("%s -- returning object at index %s", tostring(Script), tostring(index))
	
	return self.weighted_table[index][1]
end

function RandomDistribution:Insert(object, weight)
	if self.weighted_table then
		table.insert(self.weighted_table, {object, weight})
	else
		self.weighted_table[1] = {{object, weight}}
	end
	self.cumulative_table = {}
	self.weight_table_length = table.getn(self.weighted_table)
end

return RandomDistribution