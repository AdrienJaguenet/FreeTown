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
			local tile = getTile(i, j)
			return (tile.type == 'grass' or tile.type == 'trees') -- check terrain type
			   and (resources.workers - resources.used_workers > 0) -- enough workers
			   and isAdjacentTo(i, j, function(t) return t.type == 'road' end)
		end
	}
end

tools = {
	['road'] = buildTool('road'),
	['chimney'] = buildTool('chimney'),
	['house'] = buildTool('house', function(tile)
		resources.workers = resources.workers + 1
	end),
	['info'] = {
		hoverTile = 'tile_select',
		use = function(i, j) 
			if map[i][j].building then
				building_selected = map[i][j].building
			else
				building_selected = nil
			end
		end,
		canUse = function() return true end
	},
	['destroy'] = {
		hoverTile = 'tile_select',
		use = function(i, j)
			if map[i][j].building then
				map[i][j].building:Destroy()
				map[i][j].building = nil
			elseif map[i][j].type ~= 'grass' then
				map[i][j].type = 'grass'
			end
		end,
		canUse = function(i, j)
			return true
		end
	},
}

tools['road'].use = function(i, j)
	local tile = map[i][j]
	tile.type = 'road'
	sfx.build:play()
end

tools['road'].canUse = function(i, j)
	local tile = getTile(i, j)
	return (tile.type == 'grass' or tile.type == 'trees') -- check terrain type
end

