current_tool = 'info'

function buildTool(name)
	return {
		use = function(i, j)
			map[i][j].type = name
		end
	}
end

tools = {
	['road'] = buildTool('road'),
	['chimney'] = buildTool('chimney'),
	['house'] = buildTool('house'),
	['farm'] = buildTool('farm'),
	['info'] = {
		use = function(i, j) 
			if map[i][j].type == 'farm' then
				building_selected = true
			else
				building_selected = false
			end
		end
	}
}

