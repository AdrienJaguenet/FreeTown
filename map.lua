Map = {}
Map.__index = Map

function Map:new(size)
	local this = {
		size = size,
		tiles = {}
	}
	setmetatable(this, Map)
	this:Generate()
	return this
end

function Map:Generate()
	for i=1,self.size do
		self.tiles[i] = {}
		for j=1,self.size do
			local t = 'grass'
			if math.random(1,5) < 4 then
				t = 'trees'
			end
			self.tiles[i][j] = Tile:new(t)
		end
	end
	local sx = math.random(1, self.size)
	for i=1,self.size do
		self.tiles[sx][i].type = 'river'
		if math.random(1, 3) == 1 then
			sx = math.max(1, sx - 1)
			self.tiles[sx][i].type = 'river'
		elseif math.random(1, 3) == 1 then
			sx = math.min(self.size, sx + 1)
			self.tiles[sx][i].type = 'river'
		end
	end
end

function Map:GetTile(x, y)
	local row = self.tiles[x]
	if row then
		return self.tiles[x][y]
	end
end

function Map:GetMooreNeighbourhood(x, y) -- returns {N, S, W, E}
	return
		self:GetTile(x, y - 1), -- N
		self:GetTile(x, y + 1), -- S
		self:GetTile(x - 1, y), -- W
		self:GetTile(x - 1, y) -- E
end

-- tells whether a tile is adjacent to another tile that follows an arbitrary criterion
function Map:IsAdjacentTo(x, y, fn) 
	local north, south, east, west = self:GetMooreNeighbourhood(x, y)
	return (north and fn(north)) or
	       (south and fn(south)) or
		   (west and fn(west)) or
		   (east and fn(east))
end

function Map:Update(dt)
	for i=1,self.size do
		for j=1, self.size do
			local tile = self:GetTile(i, j)
			local total_fields = 0
			if tile.building then
				tile.building:Update(dt)
			end
		end
	end
end

function Map:Draw(hover_coords)
	local tool = tools[current_tool]
	-- for every layer
	for layer=1,2 do
		-- draw the upper half
		for i=1,self.size do
			for j=1,i do
				local x = self.size - i + j
				local y = j
				local tile = self:GetTile(x, y)
				tile:draw(x, y, {layer = layer})
				if tile.building then
					tile.building:Draw(layer)
				end	
				if hover_coords.x == x and hover_coords.y == y then
					-- draw the hover
					drawTool(x, y, tool)
				end
			end
		end
		-- draw the lower half 
		for i=settings.MAP_SIZE,1,-1 do
			for j=1,i do
				local x = j
				local y = self.size - i + j
				local tile = self:GetTile(x, y)
				tile:draw(x, y, {layer = layer})
				if tile.building then
					tile.building:Draw(layer)
				end
				if hover_coords.x == x and hover_coords.y == y then
					-- draw the hover
					drawTool(x, y, tool)
				end
			end
		end
	end

end



map = Map:new(settings.MAP_SIZE)

