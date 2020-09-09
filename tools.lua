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
		use = showTileInfo 
	}
}

