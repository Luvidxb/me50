--[[
	GD50
	Breakout Remake

	-- Ball Class --

	Author: Kurt Yilmaz
	kurtyilmaz@ufl.edu

	Assignment 2.1

	"Add a Powerup class to the game that spawns a powerup (images located at the bottom of the sprite sheet in the distribution code).
	This Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and gradually descend toward the player.
	Once collided with the Paddle, two more Balls should spawn and behave identically to the original, including all collision and scoring points for the player.
	Once the player wins and proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again.""
]]



Powerup = Class{}

function Powerup:init(x, y, keyValid)
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.width = 16
	self.height = 16
	
	if keyValid then
		self.type = 10
	else
		self.type = math.random(1, 9)
	end
	self.collided = false

	self.blinkTimer = 0
	self.startupTimer = 0
	self.visible = true

end

function Powerup:update(dt)
	if self.startupTimer < 3.4285 then
		self.startupTimer = self.startupTimer + dt
		self.blinkTimer = self.blinkTimer + dt
		
		if self.blinkTimer > 0.4285 then
			self.blinkTimer = self.blinkTimer - 0.4285
			self.visible = not self.visible
		end
	else
		self.y = self.y + 1
	end
end

function Powerup:collides(target)
	
	if self.x > target.x + target.width or target.x > self.x + self.width then
		return false
	end

	
	if self.y > target.y + target.height or target.y > self.y + self.height then
		return false
	end


	return true
end

function Powerup:render()
	if self.visible then
		love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type], self.x, self.y)
	end
end


function Powerup.renderBar(key)
	local x = 4
	local y = VIRTUAL_HEIGHT - 20
	if key then
		love.graphics.draw(gTextures['main'], gFrames['powerups'][10], x, y)
		x = x + 16
	end

end
