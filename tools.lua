current_tool = 'info'

function buildTool(name)
	return {
		hoverTile = name,
		use = function(i, j)
			local tile = map[i][j]
			tile.building = Building:New(name, i, j)
			sfx.build:play()

		end,
		canUse = function(i, j)
			return map[i][j].type == 'grass' or map[i][j].type == 'trees' and resources.workers - resources.used_workers > 0
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
	end),
	['info'] = {
		hoverTile = 'tile_select',
		use = function(i, j) 
			if map[i][j].type == 'farm' then
				building_selected = map[i][j]
			else
				building_selected = nil
			end
		end,
		canUse = function() return true end
	}
}

tools['house'].canUse = function(i, j)
	return map[i][j].type == 'grass'
end

tools['road'].use = function(i, j)
	local tile = map[i][j]
	tile.type = 'road'
	sfx.build:play()
end

