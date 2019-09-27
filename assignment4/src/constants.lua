


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144


TILE_SIZE = 16


SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE


CAMERA_SPEED = 100


BACKGROUND_SCROLL_SPEED = 10


TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4


TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10


TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18


TOPPER_SETS = TOPPER_SETS_WIDE * TOPPER_SETS_TALL
TILE_SETS = TILE_SETS_WIDE * TILE_SETS_TALL


PLAYER_WALK_SPEED = 60
PLAYER_RUN_SPEED = 90


PLAYER_JUMP_VELOCITY = -155


SNAIL_MOVE_SPEED = 10

SNAIL_TURN_LAG = 1


TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3


COLLIDABLE_TILES = {
	TILE_ID_GROUND
}


BUSH_IDS = {
	1, 2, 5, 6, 7
}

COIN_IDS = {
	1, 2, 3
}

CRATES = {
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
}

GEMS = {
	1, 2, 3, 4, 5, 6, 7, 8
}

JUMP_BLOCKS = {}


FLAGS = {
	1, 2, 3, 4
}

POLES = {
	1, 2, 3, 4, 5, 6
}


PLAYER_LEFT = 'a'
PLAYER_RIGHT = 'd'
PLAYER_JUMP = 'space'
PLAYER_RUN = 'lshift'

for i = 1, 30 do
	table.insert(JUMP_BLOCKS, i)
end