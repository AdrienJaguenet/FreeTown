current_tool = 'info'

function buildTool(name, onPlace)
	return {
		hoverTile = name,
		use = function(i, j)
			local tile = map[i][j]
			tile.type = name
			if onPlace then
				onPlace(tile)
			end

		end,
		canUse = function(i, j)
			return map[i][j].type == 'grass'
		end
	}
end

tools = {
	['road'] = buildTool('road'),
	['chimney'] = buildTool('chimney'),
	['house'] = buildTool('house', function(tile)
		resources.workers = resources.workers + 1
	end),
	['farm'] = buildTool('farm', function(tile)
		resources.used_workers = resources.used_workers - tile.workers
		tile.workers = 1
		resources.used_workers = resources.used_workers - 1
	end),
	['info'] = {
		hoverTile = 'tile_select',
		use = function(i, j) 
			if map[i][j].type == 'farm' then
				building_selected = map[i][j]
			else
				building_selected = false
			end
		end,
		canUse = function() return true end
	}
}

