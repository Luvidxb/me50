--[[
	GD50
	Breakout Remake

	-- PlayState Class --

	Author: Colton Ogden
	cogden@cs50.harvard.edu

	Represents the state of the game in which we are actively playing;
	player should control the paddle, with the ball actively bouncing between
	the bricks, walls, and the paddle. If the ball goes below the paddle, then
	the player should lose one point of health and be taken either to the Game
	Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
	We initialize what's in our PlayState via a state table that we pass between
	states as we go from playing to serving.
]]
function PlayState:enter(params)
	self.paddle = params.paddle
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.highScores = params.highScores

	self.balls = {params.ball}
	self.ballCount = 1
	self.level = params.level
	self.recoverPoints = params.recoverPoints
	self.numLockedBricks = params.numLockedBricks

	
	self.powerupTimer = 1

	
	self.hasKeyPowerup = false

	
	self.balls[1].dx = math.random(-200, 200)
	self.balls[1].dy = math.random(-50, -100)

	
	self.powerups = {}

end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds['pause']:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds['pause']:play()
		return
	end

	
	if self.powerupTimer >= 0 then
		self.powerupTimer = self.powerupTimer - dt
	else
		p = Powerup(
			
			math.random(
				
			0,
		
				VIRTUAL_WIDTH - 16
			),

			
			self.paddle.y - 100,

		
			(self.numLockedBricks > 0) and (not self.hasKeyPowerup)
		)
		table.insert(self.powerups, p)
		self.powerupTimer = 12
	end

	self.paddle:update(dt)

	
	for k, powerup in pairs(self.powerups) do
		powerup:update(dt)
		if powerup:collides(self.paddle) then
		
			if powerup.type == 1 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 2 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 3 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 4 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 5 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 6 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 7 then
				-- Spawn 2 extra balls
				self:powerUp7()
			elseif powerup.type == 8 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 9 then
				-- Replace with unique effect
				self:powerUp7()
			elseif powerup.type == 10 then
				self.hasKeyPowerup = true
				gSounds['powerup']:play()
			end
			table.remove(self.powerups, k)
		end
	end


	for k, ball in pairs(self.balls) do

		ball:update(dt)

		if ball:collides(self.paddle) then

			ball.y = self.paddle.y - 8
			ball.dy = -ball.dy

			if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))

			elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
			end

			gSounds['paddle-hit']:play()
		end

		for i, brick in pairs(self.bricks) do

			
			if brick.inPlay and ball:collides(brick) then

				
				local brickUnlocked = false
				if brick.locked == true and self.hasKeyPowerup then
					self.score = self.score + 1000
					brickUnlocked = true
				elseif brick.locked == true then

				else
					self.score = self.score + (brick.tier * 200 + brick.color * 25)
				end

				
				brick:hit(self.hasKeyPowerup)
				if brickUnlocked then
					self.hasKeyPowerup = false
					self.numLockedBricks = self.numLockedBricks - 1
				end

				
				if self.score > self.recoverPoints then
					
					self.health = math.min(4, self.health + 1)

					
					if self.paddle.size < 4 then
						self.paddle:resize(self.paddle.size + 1)
					end

					
					self.recoverPoints = math.min(100000, self.recoverPoints * 2)

					
					gSounds['recover']:play()
				end

				
				if self:checkVictory() then
					gSounds['victory']:play()

					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						ball = ball,
						recoverPoints = self.recoverPoints
					})
				end

				
				if ball.x + 2 < brick.x and ball.dx > 0 then

					
					ball.dx = -ball.dx
					ball.x = brick.x - 8

				
				elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

					
					ball.dx = -ball.dx
					ball.x = brick.x + 32

				
				elseif ball.y < brick.y then

					
					ball.dy = -ball.dy
					ball.y = brick.y - 8

				
				else

					
					ball.dy = -ball.dy
					ball.y = brick.y + 16
				end

				
				break
			end
		end

		
		if ball.y >= VIRTUAL_HEIGHT then
			if self.ballCount <= 1 then
				self.health = self.health - 1
				gSounds['hurt']:play()

				
				if self.paddle.size > 1 then
					self.paddle:resize(self.paddle.size - 1)
				end

				if self.health == 0 then
					gStateMachine:change('game-over', {
						score = self.score,
						highScores = self.highScores
					})
				else
					gStateMachine:change('serve', {
						paddle = self.paddle,
						bricks = self.bricks,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						level = self.level,
						recoverPoints = self.recoverPoints
					})
				end
			else
				table.remove(self.balls, k)
				self.ballCount = self.ballCount - 1
			end
		end
	end

	
	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end

	
end

function PlayState:render()
	
	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	
	for k, brick in pairs(self.bricks) do
		brick:renderParticles()
	end

	self.paddle:render()

	
	for k, powerup in pairs(self.powerups) do
		powerup:render()
	end

	for k, ball in pairs(self.balls) do
		ball:render()
	end

	renderScore(self.score)
	renderHealth(self.health)
	Powerup.renderBar(self.hasKeyPowerup)

	
	if self.paused then
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end

function PlayState:checkVictory()
	for k, brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end

	return true
end


function PlayState:powerUp7()
	
	ball1 = Ball(math.random(7))
	ball2 = Ball(math.random(7))
	ball3 = Ball(math.random(7))
	ball4= Ball(math.random(7))
	ball5= Ball(math.random(7))
	ball6= Ball(math.random(7))
	ball7= Ball(math.random(7))

	ball1.x = self.balls[1].x
	ball2.x = self.balls[1].x
	ball3.x = self.balls[1].x
	ball4.x = self.balls[1].x
	ball5.x = self.balls[1].x
	ball6.x = self.balls[1].x
	ball7.x = self.balls[1].x


	ball1.y = self.balls[1].y
	ball2.y = self.balls[1].y
	ball3.y = self.balls[1].y
	ball4.y = self.balls[1].y
	ball5.y = self.balls[1].y
	ball6.y = self.balls[1].y
	ball7.y = self.balls[1].y


	ball1.dx = self.balls[1].dx
	ball2.dx = self.balls[1].dx
	ball3.dx = self.balls[1].dx
	ball4.dx = self.balls[1].dx
	ball5.dx = self.balls[1].dx
	ball6.dx = self.balls[1].dx
	ball7.dx = self.balls[1].dx


	ball1.dy = -math.abs(self.balls[1].dy / 2)
	ball2.dy = -math.abs(self.balls[1].dy / 4)
	ball3.dy = -math.abs(self.balls[1].dy / 6)
	ball4.dy = -math.abs(self.balls[1].dy / 8)
	ball5.dy = -math.abs(self.balls[1].dy / 10)
	ball6.dy = -math.abs(self.balls[1].dy / 12)
	ball7.dy = -math.abs(self.balls[1].dy / 14)


	table.insert(self.balls, ball1)
	table.insert(self.balls, ball2)
	table.insert(self.balls, ball3)
	table.insert(self.balls, ball4)
	table.insert(self.balls, ball5)
	table.insert(self.balls, ball6)
	table.insert(self.balls, ball7)
	

	self.ballCount = self.ballCount + 7

	gSounds['powerup']:play()
end
