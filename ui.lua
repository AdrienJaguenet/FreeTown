local button_bg = love.graphics.newImage('resources/gfx/button.png')

function loadUI()
	yui.UI.registerEvents()
	ui = {
		fonts = {
			default = love.graphics.newFont('resources/fonts/VCR_OSD_MONO_1.001.ttf', 24),
		},
		main_view = yui.View(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), {
			yui.Stack({
				name = 'main_stack',
				yui.Flow({
					name = 'top_bar',
					yui.Label({text = settings.VERSION}),
					right = {
						yui.Label({name = 'fps_label', text = 'FPS'})
					}
				}),
				toolButton('info', 'info'),
				bottom = yui.Flow({
					toolButton('road', 'road_horizontal'),
					toolButton('farm', 'farm'),
					toolButton('chimney', 'chimney'),
					toolButton('house', 'house')
				})
			})
		})
	}
end

function getFPSLabel()
	return ui.main_view.main_stack.top_bar.right[1]
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

