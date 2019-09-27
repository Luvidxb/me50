--[[
	GD50
	Match-3 Remake

	-- BeginGameState Class --

	Author: Colton Ogden
	cogden@cs50.harvard.edu

	Represents the state the game is in right before we start playing;
	should fade in, display a drop-down "Level X" message, then transition
	to the PlayState, where we can finally use player input.
]]

BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()

    
	self.transitionAlpha = 255

	
	self.levelLabelY = -64
end

function BeginGameState:enter(def)

	
	self.level = def.level

	
	self.board = Board(GRID_START_X, GRID_START_Y, self.level)

	
	Timer.tween(1, {
		[self] = {transitionAlpha = 0}
	})

	
	:finish(function()
		Timer.tween(0.25, {
			[self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
		})

	
		:finish(function()
			Timer.after(1.5, function()

				
				Timer.tween(0.25, {
					[self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
				})

				
				:finish(function()
					gStateMachine:change('play', {
						level = self.level,
						board = self.board
					})
				end)
			end)
		end)
	end)
end

function BeginGameState:update(dt)
	Timer.update(dt)
	self.board:update(dt)
end

function BeginGameState:render()

	self.board:render()

	love.graphics.setColor(95, 205, 228, 200)
	love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf('Level ' .. tostring(self.level),
		0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

	
	love.graphics.setColor(255, 255, 255, self.transitionAlpha)
	love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
