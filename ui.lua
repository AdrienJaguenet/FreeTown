local button_bg = love.graphics.newImage('resources/gfx/button.png')

yui.debug_draw = true

function loadUI()
	yui.UI.registerEvents()
	ui = {
		fonts = {
			default = love.graphics.newFont('resources/fonts/VCR_OSD_MONO_1.001.ttf', 24),
		},
		top_info = yui.View(0, 0, love.graphics.getWidth(), love.graphics.getHeight(),{
			yui.Flow({
				name = 'top_bar',
				yui.Label({text = settings.VERSION}),
				right = {
					yui.Label({name = 'fps_label', text = 'FPS'}),
				},
			}),
		}),
		main_view = yui.View(0, love.graphics.getHeight() - 40, love.graphics.getWidth(), 40, {
			yui.Flow({
				toolButton('info', 'info'),
				toolButton('road', 'road_horizontal'),
				toolButton('farm', 'farm'),
				toolButton('chimney', 'chimney'),
				toolButton('house', 'house')
			})
		}),
		building_view = yui.View(love.graphics.getWidth() / 4, love.graphics.getHeight() / 4,
		                         love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, {
			yui.Flow({
				yui.Label({name = 'title', text = 'Building name'}),
				right = {
					yui.ImageButton({
						name = 'closeButton',
						image = love.graphics.newImage('resources/gfx/button_close.png'),
						onClick = function(button)
							building_selected = false
						end}),
				}
			}),
			background = {0.5, 0.5, 0.25}
		})
	}
end

function getFPSLabel()
	return ui.top_info.top_bar.right[1]
end

function toolButton(name, img_name)
	local canvas = love.graphics.newCanvas(button_bg:getWidth(), button_bg:getHeight())
	local img = love.graphics.newImage('resources/gfx/'..img_name..'.png')
	love.graphics.setCanvas(canvas)
	love.graphics.draw(button_bg)
	love.graphics.draw(img, (button_bg:getWidth() - img:getWidth()) / 2, (button_bg:getHeight() - 38 - img:getHeight()) / 2)
	love.graphics.setCanvas()
	return yui.ImageButton({
		image = love.graphics.newImage(canvas:newImageData()),
		button = name,
		onClick = function(button)
			current_tool = name
		end
	})
end

