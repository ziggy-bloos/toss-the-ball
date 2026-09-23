-- Copyright (c) 2026 ZiggyBloos | ZLIB LICENSE, See LICENSE.txt for details

local cam = {scale = 1, offX = 0, offY = 0}

local isTouchDown = false
local mute = false
local showKeybindsPopup = false

local gameState = 1 --0=over, 1=start, 2=pause

local score = 0
local bounceTimer = 0

local function changeGameState(reset, target)
	if gameState == target then
		gameState = reset
	else
		gameState = target
	end
end

local function loadHighscore()
	local data = love.filesystem.read("highscore.txt")
	return tonumber(data) or 0
end

local highscore = loadHighscore()

local function saveHighscore()
	if score > highscore then
		love.filesystem.write("highscore.txt", tostring(score))
	end
end

local plr = { x=300 }
local ball = { x=400, y=300, r=0, spd=1000 }

local bounceSfx

function ball.bounce()
	if not mute then
		if bounceTimer == 0 then
			bounceSfx:seek(0)
			bounceSfx:setPitch(math.random(80, 120) / 50)
			bounceSfx:play()
		end
	end
	ball.r = ball.r + math.pi
end

local btns = {}
local function drawBtn(text, x, y, w, h)
	love.graphics.setColor(1, 1, 1, .5)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(text, x, y + h/5, w, "center")
end

function love.load()
	math.randomseed(os.time())
	love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	bounceSfx = love.audio.newSource("assets/bounce.wav", "static")
	btns = {
		{text="I I",x=750,y=10,w=40,h=25,func=function()
			changeGameState(1, 2)
		end},
		{text="f1",x=750,y=45,w=40,h=25,func=function()
			if showKeybindsPopup == false then
				showKeybindsPopup = true
			else showKeybindsPopup = false end
		end},
		{text="r", x=750, y=80, w=40, h=25, func=function() gameState = 0 end},
		{text="x", x=750, y=115, w=40, h=25, func=function() love.event.quit(0) end},
		{text="m", x=750, y=150, w=40, h=25, func=function()
			if mute == false then
				mute = true
			else mute = false end
		end},
	}
end

function love.resize(scrW, scrH)
	cam.scale = math.min(scrW / 800, scrH / 600)
	cam.offX = (scrW - 800 * cam.scale) / 2
	cam.offY = (scrH - 600 * cam.scale) / 2
end

function love.update(dt)
	if gameState ~= 2 then
		if isTouchDown then
			local mX, mY = love.mouse.getPosition()
			mX = (mX - cam.offX) / cam.scale
			mY = (mY - cam.offY) / cam.scale

			plr.x = mX - 100
			if plr.x < 0 then
				plr.x = 0
			elseif plr.x > 600 then
				plr.x = 600
			end
		end

		ball.x = ball.x + math.cos(ball.r) * ball.spd * dt
		ball.y = ball.y + math.sin(ball.r) * ball.spd * dt
		ball.r = ball.r + 1 * dt
		if ball.x <= 30 or ball.x >= 770 or ball.y <= 30 then
			ball.bounce()
			bounceTimer = 0.1
		end
		if ball.y > 680 then
			gameState = 0
		end
		if ball.x > plr.x and ball.x < plr.x + 200 and ball.y < 532 and ball.y > 500 then
			ball.bounce()
			if bounceTimer == 0 then
				score = score + 1
			end
			bounceTimer = 0.1
		end

		bounceTimer = bounceTimer - dt
		if bounceTimer < 0 then
			bounceTimer = 0
		end
		if bounceTimer > 0 then
			ball.r = ball.r - 1 * dt
		end
	end

	if gameState == 0 then
		saveHighscore()
		highscore = loadHighscore()
		score = 0 ball.x=400 ball.y=300 ball.r=math.random(0, 2*math.pi)
		gameState = 1
	end

	if mute then
		btns[5].text = "!m"
	else
		btns[5].text = "m"
	end
end

function love.keypressed(key)
	if key == "f11" then
		fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen)
	end
	if key == "x" then
		love.event.quit(0)
	end
	if key == "space" then
		changeGameState(1, 2)
	end
	if key == "r" then
		gameState = 0
	end
	if key == "f1" then
		showKeybindsPopup = true
	end
	if key == "m" then
		if mute == false then
			mute = true
		else mute = false end
	end
end

function love.keyreleased(key)
	if key == "f1" then
		showKeybindsPopup = false
	end
end

function love.mousepressed(x, y, btn)
	if btn ~= 1 then return end

	isTouchDown = true
	local x = (x - cam.offX) / cam.scale
	local y = (y - cam.offY) / cam.scale
	for _, btn in ipairs(btns) do
		if x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h then
			btn.func()
		end
	end
end

function love.mousereleased()
	isTouchDown = false
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(cam.offX, cam.offY)
	love.graphics.scale(cam.scale, cam.scale)

	love.graphics.setColor(.08, .08, .08)
	love.graphics.rectangle("fill", 0, 0, 800, 600)

	love.graphics.setColor(.9, .9, .9)
	love.graphics.rectangle("fill", plr.x, 500, 200, 32)
	love.graphics.circle("fill", ball.x, ball.y, 28, 28)

	if gameState == 2 then
		love.graphics.setColor(0, 0, 0, .5)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("PAUSED", 382, 300)
	end

	if showKeybindsPopup then
		love.graphics.setColor(1, 1, 1, .5)
		love.graphics.rectangle("fill", 290, 10, 200, 100)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("'x' to QUIT\n'space' to PAUSE\n'f11' to toggle FULLSCREEN\n'r' to RESET\n'f1' to view KEYBINDS\n'm' to MUTE or UNMUTE", 300, 18)
	end

	love.graphics.setColor(1, 1, 1, .5)
	love.graphics.print(score.."\t|\t"..highscore, 10, 10)

	for _, btn in ipairs(btns) do
		drawBtn(btn.text, btn.x, btn.y, btn.w, btn.h)
	end

	love.graphics.pop()
end

function love.quit()
	gameState = 0
	saveHighscore()
end
