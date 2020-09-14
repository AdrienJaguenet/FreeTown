current_tool = 'info'

function buildTool(name)
	return {
		hoverTile = name,
		use = function(i, j)
			map[i][j].type = name
		end,
		canUse = function(i, j)
			return map[i][j].type == 'grass'
		end
	}
end

tools = {
	['road'] = buildTool('road'),
	['chimney'] = buildTool('chimney'),
	['house'] = buildTool('house'),
	['farm'] = buildTool('farm'),
	['info'] = {
		hoverTile = 'tile_select',
		use = function(i, j) 
			if map[i][j].type == 'farm' then
				building_selected = true
			else
				building_selected = false
			end
		end,
		canUse = function() return true end
	}
}

