--[[
    GD50
    Breakout Remake

    -- Brick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

Brick = Class{}

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}


function Brick:init(x, y, locked)
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1
    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    
    -- used to determine whether this brick should be rendered
    self.inPlay = true

    -- particle system belonging to the brick, emitted on hit

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 512)

    self.locked = locked

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function Brick:hit(haskey)
    if haskey and self.locked then


        self.psystem:setParticleLifetime(1, 3)
        self.psystem:setAreaSpread('normal', 15, 15)
        self.psystem:setColors(
            255,
            255,
            0,
            55,
            255,
            255,
            0,
            0
        )
        self.psystem:emit(1024)

        self.psystem:setParticleLifetime(0.5, 1)


        gSounds['brick-hit-2']:stop()
        gSounds['brick-hit-2']:play()
        self.locked = false

    elseif self.locked then
        gSounds['wall-hit']:play()
    else
        self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        55 * (self.tier + 1),
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(64)
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
       
       
       
        if self.tier > 0 then
            if self.color == 1 then
                self.tier = self.tier - 1
                self.color = 5
            else
                self.color = self.color - 1
            end
        else
            -- if we're in the first tier and the base color, remove brick from play
            if self.color == 1 then
                self.inPlay = false
            else
                self.color = self.color - 1
            end
        end
        if not self.inPlay then
            gSounds['brick-hit-1']:stop()
            gSounds['brick-hit-1']:play()
           
        end
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay and self.locked then
        love.graphics.draw(gTextures['main'],
        gFrames['bricks'][22],
        self.x, self.y) 

    elseif self.inPlay then
        love.graphics.draw(gTextures['main'],
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
            self.x, self.y)
    end
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end