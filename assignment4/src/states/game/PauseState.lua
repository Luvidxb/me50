PauseState = Class{__includes = BaseState}

function PauseState:init()
	self.image = love.graphics.newImage('pause.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
    gStateMachine:change('play')
    end
end

function PauseState:render()
   love.graphics.draw(self.image, VIRTUAL_WIDTH / 2 - (self.width / 2), VIRTUAL_HEIGHT / 2 - (self.height / 2))
end


function PauseState:enter()
        PLAYER_WALK_SPEED = 0
        PLAYER_RUN_SPEED = 0
        PLAYER_JUMP_VELOCITY = 0
        SNAIL_MOVE_SPEED = 00
        SNAIL_TURN_LAG = 0
        gSounds['play-bg']:pause()
end

function PauseState:exit()
        PLAYER_WALK_SPEED = 60
        PLAYER_RUN_SPEED = 90
        PLAYER_JUMP_VELOCITY = -155
        SNAIL_MOVE_SPEED = 10
        SNAIL_TURN_LAG = 1
        gSounds['play-bg']:play()
end