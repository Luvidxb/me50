

StartState = Class{__includes = BaseState}

function StartState:init()

end

function StartState:enter(params)

end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 1, -1, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    -- love.graphics.setFont(gFonts['gothic-medium'])
    -- love.graphics.printf('Legend of', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    -- love.graphics.setFont(gFonts['gothic-large'])
    -- love.graphics.printf('50', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.printf('Legend of ZELDA', 2, VIRTUAL_HEIGHT / 5 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175, 53, 42, 255)
    love.graphics.printf('Legend of ZELDA', 0, VIRTUAL_HEIGHT / 5 - 32, VIRTUAL_WIDTH-6, 'center')

    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.setFont(gFonts['zelda-tiny'])
    love.graphics.printf('Except not really', 7 , VIRTUAL_HEIGHT/1.16 -32, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf('Except not really', 5, VIRTUAL_HEIGHT /1.16 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter', 7, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH+5, 'center')
    
end