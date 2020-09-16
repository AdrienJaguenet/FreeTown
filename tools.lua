current_tool = 'info'

function buildTool(name)
	return {
		hoverTile = name,
		use = function(i, j)
			local tile = map:GetTile(i, j)
			tile.building = Building:New(name, i, j)
			sfx.build:play()

		end,
		canUse = function(i, j)
			local tile = map:GetTile(i, j)
			return (tile.type == 'grass' or tile.type == 'trees') -- check terrain type
			   and (resources.workers - resources.used_workers > 0) -- enough workers
			   and map:IsAdjacentTo(i, j, function(t) return t.type == 'road' end) -- must be next to a road
			   and not tile.building -- cannot build over an existing building
		end
	}
end

function drawTool(i, j, tool)
	local color = {}
	if tool.canUse(i, j) then
		color = {.25, .75, .25}
	else
		color = {.75, .25, .25}
	end
	Tile:new(tool.hoverTile):draw(i, j, {color = color})
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
		if map:GetTile(i, j).building then
				building_selected = map:GetTile(i, j).building
			else
				building_selected = nil
			end
		end,
		canUse = function() return true end
	},
	['destroy'] = {
		hoverTile = 'tile_select',
		use = function(i, j)
			local tile = map:GetTile(i, j)
			if tile.building then
				tile.building:Destroy()
				tile.building = nil
			elseif tile.type ~= 'grass' then
				tile.type = 'grass'
			end
		end,
		canUse = function(i, j)
			return true
		end
	},
}

tools['road'].use = function(i, j)
	local tile = map:GetTile(i, j)
	tile.type = 'road'
	sfx.build:play()
end

tools['road'].canUse = function(i, j)
	local tile = map:GetTile(i, j)
	return (tile.type == 'grass' or tile.type == 'trees') -- check terrain type
end

