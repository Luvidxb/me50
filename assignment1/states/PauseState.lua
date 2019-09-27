PauseState = Class{___includes = BaseState}

function PauseState:init()
	self.image = love.graphics.newImage('pause.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

end


function PauseState:update(dt)
if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
gStateMachine:change('play', {bird = self.bird, pair = self.pipePairs, score = self.score})
end
end

function PauseState:render()
 	for k, pair in pairs(self.pipePairs) do
 		pair:render() 
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
	self.bird:render()

	love.graphics.draw(self.image, VIRTUAL_WIDTH / 2 - (self.width / 2), VIRTUAL_HEIGHT / 2 - (self.height / 2))
end

function PauseState:enter(params)
self.bird = params.bird
self.pipePairs = params.pair
self.score = params.score
sounds['music']:pause()
scrolling = false

end

function PauseState:exit()
scrolling = true
sounds['music']:play()
end
