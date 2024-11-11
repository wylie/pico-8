pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--trapped in the tunnels
--a maze game by wylie and oslo 

--function reset()
	--cam_x=20
	--cam_y=118
	--finished=false
--end

function _init()
 --variables
 --sprites
 maze_spr=0
 user_spr=2
 torch_spr=18
 name_spr=64
 chest_spr=17
 --positioning
 cam_x=20
 cam_y=118
 --cam_y=18
 chest_loc={{x=20,y=17},{x=20,y=87},{x=20,y=27},{x=20,y=47}}
 --other variables
 score=0
 timing=0.25
 torch_anim_time=0
 torch_anim_wait=.05
 finished=false

	--reset()
 --chest_loc={{x=20,y=87},{x=10,y=17},{x=50,y=27},{x=60,y=47}}
end

function _update60()
	--animate player
	for i=0,4 do --count up
		if btn(i) then
			user_spr += timing
			if user_spr > 4 then user_spr = 0 end
		end
	end	
	--move
	user_move()

	poop=mget(cam_x,cam_y)
	return fget(poop,0)
end

function random_num_gen()
 sum_num=flr(rnd(4))
 print(sum_num,12)
 print("boom",0,0,7)
end

function fin(finished)
	if finished then
	 print("huzzah",cam_x+10,cam_y,13)
	end
end

function _draw()
	cls()
	map(0,0,0,0,128,128)
	camera(cam_x-64,cam_y-64)
	--chest
 chest()
 --shadows & text
 overlay()
	--player
 user()
 --finished
	fin(finished)
end
-->8
--user

--torch animating
function torch_animate()
	if time() - torch_anim_time > torch_anim_wait then
		torch_spr+=1
		torch_anim_time=time()
		if torch_spr > 20 then
			torch_spr=18
		end
	end
  spr(torch_spr,cam_x+4,cam_y-1)
end

--display character
function user_show()
	spr(16,cam_x,cam_y+1)
	spr(user_spr,cam_x,cam_y)
end

--move the character
function user_move()
	local old_x=cam_x
	local old_y=cam_y

	if btn(0) then cam_x-=.75 end
	if btn(1) then cam_x+=.75 end
	if btn(2) then cam_y-=.75 end
	if btn(3) then cam_y+=.75 end

	if hitwall(cam_x,cam_y) then
		cam_x=old_x
	end
	if hitwall(cam_x,cam_y) then
		cam_y=old_y
	end
end

--bundle user
function user()
 user_show()
 torch_animate()
end
-->8
--user collision

function hitwall(_x,_y)
	if (checkspot(_x,_y,0))
	or (checkspot(_x+7,_y,0))
	or (checkspot(_x,_y+7,0)) 
	or (checkspot(_x+7,_y+8,0)) then
		return true
	end
	return false
end

--check the character position
function checkspot(_x,_y,_flag)
	local tilex=flr(_x/8)
	local tiley=flr(_y/8)
	local tile=mget(tilex,tiley)
	return fget(tile,_flag)
end
-->8
--chest

--chest spawn
function chest_spawn_var(score,_loc)
	local_score=score+1
 --print(_loc[local_score].x,cam_x+10,cam_y+10,8)
 --print(_loc[local_score].y,cam_x+10,cam_y+16,8)
 chest_spawn_x=_loc[local_score].x
 chest_spawn_y=_loc[local_score].y
	spr(chest_spr,chest_spawn_x,chest_spawn_y)
end

function chest_spawn_loc(chest_spr,chest_spawn_x,chest_spawn_y)
	--spr(chest_spr,chest_spawn_x,chest_spawn_y)
end

--chest respawn
function chest_respawn(finished,chest_loc)
	if finished then
		spr(chest_spr,chest_loc[chest_spawn].x,chest_loc[chest_spawn].y)
	else
  spr(chest_spr,chest_loc[chest_spawn].x,chest_loc[chest_spawn].y)
  score+=1
 end					
end

--chest found
function chest_found(_x,_y)
	if chest_spawn_y+4>=cam_y-8
	and chest_spawn_y+4>=cam_y
	and chest_spawn_x+4>=cam_x
	and chest_spawn_x+4>=cam_x-8 then
  score+=1
		finished=true
		score_update(score)
	end
end

--bundle chest
function chest()
	chest_spawn_var(score,chest_loc)
	chest_spawn_loc(chest_spr,chest_spawn_x,chest_spawn_y)
	chest_found(cam_x,cam_y)
end
-->8
--overlays

--big shadow blocks
function shadows_block()
	sspr(32,24,8,8,cam_x-14,cam_y+100,-60,-200)
	sspr(32,24,8,8,cam_x-14,cam_y-15,100,-100)
	sspr(32,24,8,8,cam_x+23,cam_y+75,100,-100)
	sspr(32,24,8,8,cam_x-15,cam_y+23,38,100)
end

--shadow corners
function shadows_corners()
	spr(48,cam_x-15,cam_y-15)
	spr(49,cam_x+15,cam_y-15)
	spr(50,cam_x+15,cam_y+15)
	spr(51,cam_x-15,cam_y+15)
end

--shadow fade
function shadows_fade()
	spr(32,cam_x-0,cam_y+15)
	spr(32,cam_x-8,cam_y+15)
	spr(32,cam_x+8,cam_y+15)
	spr(32,cam_x,cam_y-15,1,1,false,true)
	spr(32,cam_x-8,cam_y-15,1,1,false,true)
	spr(32,cam_x+8,cam_y-15,1,1,false,true)
	spr(33,cam_x+15,cam_y,1,1,true,false)
	spr(33,cam_x+15,cam_y,1,1,true,false)
	spr(33,cam_x+15,cam_y-8,1,1,true,false)
	spr(33,cam_x+15,cam_y+8,1,1,true,false)
	spr(33,cam_x-14,cam_y,1,1)
	spr(33,cam_x-14,cam_y-8,1,1)
	spr(33,cam_x-14,cam_y+8,1,1)
end

--update the score
function score_update(score)
	score+=1
	score_display(score)
end

--display the score
function score_display(score_new)
	spr(chest_spr,cam_x-4,cam_y+25)
	print("="..score_new,cam_x+4,cam_y+27,6)
end

--game name
function text_overlay()
 spr(64,cam_x-30,cam_y-50, 8, 3)
 spr(72,cam_x-4,cam_y+45, 8, 3)
	--score
 --score_display()
end

--bundle overlay
function overlay()
 shadows_block()
 shadows_corners()
 shadows_fade()
 text_overlay()
end
__gfx__
0000000000000000000000000000000000000000333b333366666666666666666666666644444444444444444444444444444444000000000000000000000000
00111100001111000011110000111100001111003b333b3362222222222222222222222664444454444444464445444444445444000000000000000000000000
001a4a00001a4a00001a4a00001a4a00001a4a003333333362444444444444444444444662444444444445464444444444444444000000000000000000000000
00444400004444000044440000444400004444003333333b62444454444444544454444662444444445444464444444444444444000000000000000000000000
04cccc4004cccc4004cccc4004cccc4004cccc4033333b3362454444454444444444444662444444444444464444444445444444000000000000000000000000
00cccc0000cccc0000cccc0000cccc0000cccc00b333333362444444444444444444454662454444444444464544454444444444000000000000000000000000
008888000888880000888800008888800088880033b3333362444444444454444544444662444444444454464444444444444544000000000000000000000000
0080080000000800008008000080000000800800333333b362445444444444444444444662444444444444464444444662444444000000000000000000000000
00000000000000000000000000000000000000000000000062444444444444444444444644444444624444464444444662444444000000000000000000000000
00000000000110000000000000000000000000000000000062445444454444444454444664544446624454464544444422444444000000000000000000000000
00000000001aa1000000000000000000000000000000000062444444444444444444444662444446624444464444444444445444000000000000000000000000
0001100001999910000a000000090000000800000000000062444444444445444444454662444446624445464444445444444444000000000000000000000000
011111101aaaaaa10005000000050000000500000000000062444454444444444444444662444446624444464444444444444444000000000000000000000000
111111111aa99aa10000000000000000000000000000000062444444444444444444444662444446624444464444444445444444000000000000000000000000
011111101aaaaaa10000000000000000000000000000000062454444444544444544444662444546624544464454444444444454000000000000000000000000
00011000011111100000000000000000000000000000000062444444444444444444444662444446444444444444444444444444000000000000000000000000
00000000100000000000000000000000000000000000000062444444444444444444444600000000000000000000000000000000000000000000000000000000
00000000100100000000000000000000000000000000000066666666666666666666666600000000000000000000000000000000000000000000000000000000
00000000010000000000000000000000000000000000000065555555555555555555555600000000000000000000000000000000000000000000000000000000
00010000100010000000000000000000000000000000000061515151515151515151515600000000000000000000000000000000000000000000000000000000
00000010101000000000000000000000000000000000000065555555555555555555555600000000000000000000000000000000000000000000000000000000
10001000100000000000000000000000000000000000000065151515151515151515151600000000000000000000000000000000000000000000000000000000
00100010010100000000000000000000000000000000000065555555555555555555555600000000000000000000000000000000000000000000000000000000
11011101100000000000000000000000000000000000000066666666666666666666666600000000000000000000000000000000000000000000000000000000
111111111111111100000001100000001111111100000000000000000000000000000000000000000000000000

