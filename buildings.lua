Building = {}
Building.__index = Building
Building.protos = {}

function Building:FindAllTilesAround(radius, fn)
	local tiles = {}
	for x=self.x-radius,self.x+radius do
		for y=self.y-radius,self.y+radius do
			local ftile = map:GetTile(x, y)
			if ftile and fn(ftile) then
				table.insert(tiles, ftile)
			end
		end
	end
	return tiles
end


function Building:CountTilesAround(radius, fn)
	return #self:FindAllTilesAround(radius, fn)
end

function Building:SelectRandomTile(radius, fn)
	local tiles = self:FindAllTilesAround(radius, fn)
	local t = tiles[math.random(#tiles)]
	return t 
end

function Building:New(t, x, y)
	if not Building.protos[t] then
		error('Tried to instantiate a building with type \"'..t..'\"')
	end
	local self = {
		proto = Building.protos[t],
		x = x,
		y = y,
		internal_counter = 0,
		workers = 0
	}
	self.proto.OnCreate(self)
	setmetatable(self, Building)
	return self
end

function Building:GetSprite()
	return self.proto.gfx
end

function Building:Draw(layer)
	local draw_origin = utils.iso2screen(self.x, self.y)
	local layer = layer or #self.proto.gfx.layers
	local sprite = self.proto.gfx.layers[layer]
	if not sprite then return end
	draw_origin.y = draw_origin.y - sprite.extra_height * camera.zoom
	love.graphics.draw(sprite.tilemap, sprite.quad, (draw_origin.x + camera.offset.x), (draw_origin.y + camera.offset.y), 
		0, camera.zoom, camera.zoom)
end

function Building:Update(dt)
	self.internal_counter = self.internal_counter + dt
	return self.proto.OnUpdate(self, dt)
end

function Building:Destroy()
	return self.proto.OnDestroy(self)
end

function register_protobuilding(name, def)
	local proto = {
		name = name,
		gfx = def.gfx,
		OnUpdate = def.OnUpdate or function(building, dt)
		end,
		OnCreate = def.OnCreate or function(building)
		end,
		OnDestroy = def.OnDestroy or function(building)
			resources.used_workers = resources.used_workers - building.workers
		end
	}
	Building.protos[name] = proto
end

register_protobuilding('house', {
	gfx = gfx.tiles.house,
	OnCreate = function(building)
		resources.workers = resources.workers + 1
	end,
	OnUpdate = function(house)
		if house.internal_counter > 0.1 then
			house.internal_counter = house.internal_counter - 0.1
		else
			return
		end
		resources.food = resources.food - 1
	end,
	OnDestroy = function(building)
		resources.workers = resources.workers - 1
	end
})

register_protobuilding('chimney', {
	gfx = gfx.tiles.chimney,
	OnCreate = function(chimney)
		resources.used_workers = resources.used_workers + 1
		chimney.workers = 1
	end,
	OnUpdate = function(chimney, dt)
		if chimney.internal_counter > 0.1  then
			chimney.internal_counter = chimney.internal_counter - 0.1
		else
			return
		end
		for i=0, chimney.workers do
			local ftile = chimney:SelectRandomTile(2, function(t) return t.type == 'trees' end)
			if ftile and (ftile.type == 'trees') then
				ftile.type = 'grass'
				resources.power = resources.power + 2
			end
		end
	end
})

