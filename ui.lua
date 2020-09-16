local ui = {}

local button_bg = love.graphics.newImage('resources/gfx/gui/button.png')

function ui.draw()
	ui.getFPSLabel():setText(love.timer.getFPS()..' FPS')
	ui.getDateLabel():setText(os.date("%d.%m.%Y", date))
	ui.getResourceLabel('workers'):setText('workers: '..resources.workers - resources.used_workers..'/'..resources.workers)
	ui.getResourceLabel('power'):setText('power: '..resources.power)
	ui.getResourceLabel('food'):setText('food: '..resources.food)

	ui.views.top_info:draw()
	ui.views.main_view:draw()

	if building_selected then
		ui.views.building_view:draw()
		ui.getAssignedWorkersLabel():setText(building_selected.workers)
		ui.getBuildingNameLabel():setText(building_selected.proto.name)
	end
end

function ui.update(dt)
	yui.update({ui.top_bar, ui.main_view, ui.building_view})
	ui.views.main_view:update(dt)
	ui.views.top_info:update(dt)
	if building_selected then
		ui.views.building_view:update(dt)
	end
end

function ui.initialize()
	yui = require('libs.yaoui.yaoui')
	yui.debug_draw = true
	yui.Theme.open_sans_regular = 'resources/fonts/propaganda.ttf'
	yui.Theme.open_sans_light = 'resources/fonts/propaganda.ttf'
	yui.Theme.open_sans_bold = 'resources/fonts/propaganda.ttf'
	yui.Theme.open_sans_semibold = 'resources/fonts/propaganda.ttf'
	yui.UI.registerEvents()
	ui.views = {
		top_info = yui.View(0, 0, love.graphics.getWidth(), love.graphics.getHeight(),{
			yui.Stack({
				yui.Flow({
					name = 'top_bar',
					yui.Label({text = settings.VERSION}),
					yui.Label({name = 'date', text = '##/##/####'}),
					right = {
						yui.Label({name = 'fps_label', text = '### FPS'}),
					},
				}),
				yui.Flow({
					name = 'resources',
					yui.Label({name='workers', text = 'workers: #####/#####'}),
					yui.Label({name='food', text = 'food: #####/#####'}),
					yui.Label({name='power', text = 'power: #####/#####'})
				})
			})
		}),
		main_view = yui.View(0, love.graphics.getHeight() - 40, love.graphics.getWidth(), 40, {
			yui.Flow({
				ui.toolButton('info'),
				ui.toolButton('road'),
				ui.toolButton('chimney'),
				ui.toolButton('house'),
				ui.toolButton('destroy'), 
			})
		}),
		building_view = yui.View(love.graphics.getWidth() / 4, love.graphics.getHeight() / 4,
		                         love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, {
			yui.Stack({
				yui.Flow({
					name = 'window_header',
					yui.Label({name = 'title', text = 'Building name'}),
					right = {
						yui.ImageButton({
							name = 'closeButton',
							image = love.graphics.newImage('resources/gfx/gui/button_close.png'),
							onClick = function(button)
								building_selected = nil 
							end}),
					}
				}),
				yui.Stack({
					name = 'window_body',
					ui.NumericField('workers')
				})
			}),
			background = {0.5, 0.5, 0.25}
		})
	}
end

function ui.NumericField(name)
	return yui.Flow({
		name = name,
		yui.Label({text = name..': '}),
		yui.Button({name = 'decrease_button', icon = 'fa-minus', onClick = function(object)
			if building_selected.workers > 0 then
				building_selected.workers = building_selected.workers - 1
				resources.used_workers = resources.used_workers - 1
			end
		end}),
		yui.Label({name = 'value', text = '#####'}),
		yui.Button({name = 'increase_button', icon = 'fa-plus', onClick = function(object)
			if resources.workers > resources.used_workers then
				building_selected.workers = building_selected.workers + 1
				resources.used_workers = resources.used_workers + 1
			end
		end}),
	})
end

function ui.getFPSLabel()
	return ui.views.top_info[1].top_bar.right[1]
end

function ui.getResourceLabel(res)
	return ui.views.top_info[1].resources[res]
end

function ui.getAssignedWorkersLabel(res)
	return ui.views.building_view[1].window_body.workers.value
end

function ui.getBuildingNameLabel()
	return ui.views.building_view[1].window_header.title
end

function ui.getDateLabel()
	return ui.views.top_info[1].top_bar.date
end

function ui.toolButton(name)
	local canvas = love.graphics.newCanvas(button_bg:getWidth(), button_bg:getHeight())
	local img = love.graphics.newImage('resources/gfx/gui/'..name..'.png')
	
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

return ui