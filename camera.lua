Camera = {}
Camera.__index = Camera

function Camera:new()
	local this = {	
		x = 0,
		y = 0,
		zoom = 2,
		currShakeAmount = 0,
		shakeThreshold = 0.2,
		shakeDamping = 20,
		offset = {x = 0, y = 0}
	}
	setmetatable(this, Camera)
	return this
end

function handleMovement(dt)
    local mx = love.mouse.getX()
	local my = love.mouse.getY()
	if mx < love.graphics.getWidth() / 100 then
		camera.x = camera.x + settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	elseif mx > 99 * love.graphics.getWidth() / 100 then
		camera.x = camera.x - settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	end

	if my < love.graphics.getHeight() / 100 then
		camera.y = camera.y + settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	elseif my > 99 * love.graphics.getHeight() / 100 then
		camera.y = camera.y - settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	end
end

function Camera:Update(dt)
    handleMovement(dt)
    self.offset = {x = love.math.random(-1, 1) * self.currShakeAmount, y = love.math.random(-1, 1) * self.currShakeAmount}
    if camera.currShakeAmount > self.shakeThreshold then
        self.currShakeAmount = self.currShakeAmount - self.currShakeAmount * self.shakeDamping * dt
    else
        self.currShakeAmount = 0
    end
end

function Camera:CenterOnMouse()
	local x, y = love.mouse.getPosition()
	local width, height = love.graphics.getDimensions()

	self.x = self.x - (x - width / 2) / self.zoom
	self.y = self.y - (y - height / 2) / self.zoom

love.mouse.setPosition( width/2, height/2 )
end


function Camera:Zoom(factor, isox, isoy)
	self.zoom = self.zoom * factor
	self:CenterOnMouse()
end

function Camera:Shake(amount)
    self.currShakeAmount = amount
end

