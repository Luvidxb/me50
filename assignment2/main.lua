--[[
	GD50
	Breakout Remake

	Author: Colton Ogden
	cogden@cs50.harvard.edu

	Originally developed by Atari in 1976. An effective evolution of
	Pong, Breakout ditched the two-player mechanic in favor of a single-
	player game where the player, still controlling a paddle, was tasked
	with eliminating a screen full of differently placed bricks of varying
	values by deflecting a ball back at them.

	This version is built to more closely resemble the NES than
	the original Pong machines or the Atari 2600 in terms of
	resolution, though in widescreen (16:9) so it looks nicer on
	modern systems.

	Credit for graphics (amazing work!):
	https://opengameart.org/users/buch

	Credit for music (great loop):
	http://freesound.org/people/joshuaempyre/sounds/251461/
	http://www.soundcloud.com/empyreanma
]]

require 'src/Dependencies'


function love.load()
	
	love.graphics.setDefaultFilter('nearest', 'nearest')

	
	math.randomseed(os.time())

	
	love.window.setTitle('Breakout')

	
	gFonts = {
		['small'] = love.graphics.newFont('fonts/font.ttf', 8),
		['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
		['large'] = love.graphics.newFont('fonts/font.ttf', 32)
	}
	love.graphics.setFont(gFonts['small'])

	
	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}


	gFrames = {
		
		['powerups'] = GenerateQuadsPowerups(gTextures['main']),
		['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
		['paddles'] = GenerateQuadsPaddles(gTextures['main']),
		['balls'] = GenerateQuadsBalls(gTextures['main']),
		['bricks'] = GenerateQuadsBricks(gTextures['main']),
		['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
	}


	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})


	gSounds = {
		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
		['score'] = love.audio.newSource('sounds/score.wav'),
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
		['confirm'] = love.audio.newSource('sounds/confirm.wav'),
		['select'] = love.audio.newSource('sounds/select.wav'),
		['no-select'] = love.audio.newSource('sounds/no-select.wav'),
		['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav'),
		['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav'),
		['victory'] = love.audio.newSource('sounds/victory.wav'),
		['recover'] = love.audio.newSource('sounds/recover.wav'),
		['high-score'] = love.audio.newSource('sounds/high_score.wav'),
		['pause'] = love.audio.newSource('sounds/pause.wav'),
		['powerup'] = love.audio.newSource('sounds/powerup.mp3'),

		['music'] = love.audio.newSource('sounds/music8d.mp3')
	}

	
	gStateMachine = StateMachine {
		['start'] = function() return StartState() end,
		['play'] = function() return PlayState() end,
		['serve'] = function() return ServeState() end,
		['game-over'] = function() return GameOverState() end,
		['victory'] = function() return VictoryState() end,
		['high-scores'] = function() return HighScoreState() end,
		['enter-high-score'] = function() return EnterHighScoreState() end,
		['paddle-select'] = function() return PaddleSelectState() end
	}
	gStateMachine:change('start', {
		highScores = loadHighScores()
	})

	
	gSounds['music']:play()
	gSounds['music']:setLooping(true)

	
	love.keyboard.keysPressed = {}
end


function love.resize(w, h)
	push:resize(w, h)
end


function love.update(dt)
	
	gStateMachine:update(dt)

	
	love.keyboard.keysPressed = {}
end

--[[
	A callback that processes key strokes as they happen, just the once.
	Does not account for keys that are held down, which is handled by a
	separate function (`love.keyboard.isDown`). Useful for when we want
	things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
	
	love.keyboard.keysPressed[key] = true
end

--[[
	A custom function that will let us test for individual keystrokes outside
	of the default `love.keypressed` callback, since we can't call that logic
	elsewhere by default.
]]
function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

--[[
	Called each frame after update; is responsible simply for
	drawing all of our game objects and more to the screen.
]]
function love.draw()
	
	push:apply('start')


	local backgroundWidth = gTextures['background']:getWidth()
	local backgroundHeight = gTextures['background']:getHeight()

	love.graphics.draw(gTextures['background'],
		
		0, 0,
		
		0,
	
		VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))


	gStateMachine:render()

	
	displayFPS()

	push:apply('end')
end

--[[
	Loads high scores from a .lst file, saved in LÖVE2D's default save directory in a subfolder
	called 'breakout'.
]]
function loadHighScores()
	love.filesystem.setIdentity('breakout')

	
	if not love.filesystem.exists('breakout.lst') then
		local scores = ''
		for i = 10, 1, -1 do
			scores = scores .. 'CTO\n'
			scores = scores .. tostring(i * 1000) .. '\n'
		end

		love.filesystem.write('breakout.lst', scores)
	end

	
	local name = true
	local currentName = nil
	local counter = 1

	
	local scores = {}

	for i = 1, 10 do
		
		scores[i] = {
			name = nil,
			score = nil
		}
	end

	
	for line in love.filesystem.lines('breakout.lst') do
		if name then
			scores[counter].name = string.sub(line, 1, 3)
		else
			scores[counter].score = tonumber(line)
			counter = counter + 1
		end

		
		name = not name
	end

	return scores
end

--[[
	Renders hearts based on how much health the player has. First renders
	full hearts, then empty hearts for however much health we're missing.
]]
function renderHealth(health)
	
	local healthX = VIRTUAL_WIDTH - 100

	
	for i = 1, health do
		love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
		healthX = healthX + 11
	end

	
	for i = 1, 3 - health do
		love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
		healthX = healthX + 11
	end
end

--[[
	Renders the current FPS.
]]
function displayFPS()
	
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

--[[
	Simply renders the player's score at the top right, with left-side padding
	for the score number.
]]
function renderScore(score)
	love.graphics.setFont(gFonts['small'])
	love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
	love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end
