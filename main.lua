settings = {
	MAP_SIZE = 15
}

Tile = {}
function Tile:new(t)
end

function createMap()
	map = {}
	for i=1,settings.MAP_SIZE do
		map[i] = {}
		for j=1,settings.MAP_SIZE do
			map[i][j] = Tile:new()
		end
	end
end

function love.load()
	gfx = {	
		tiles = {
			grass = love.graphics.newImage('resources/gfx/grass.png')
		}
	}
end
