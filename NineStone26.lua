
local ui = require "ui"
local audio = require "audio"
require "canvas"

local stones = {}
local position = {}
stones.board = {[1]="Empty", [2]="Empty", [3]="Empty",
					[4]="Empty", [5]="Empty", [6]="Empty",
					[7]="Empty", [8]="Empty", [9]="Empty",
					[10]="Empty", [11]="Empty", [12]="Empty",
					[13]="Empty", [14]="Empty", [15]="Empty",
					[16]="Empty", [17]="Empty", [18]="Empty",
					[19]="Empty", [20]="Empty", [21]="Empty",
					[22]="Empty", [23]="Empty", [24]="Empty"
				}
stones.home = {}
stones.home.human = {[1]="Red", [2]="Red", [3]="Red",
					[4]="Red", [5]="Red", [6]="Red",
					[7]="Red", [8]="Red", [9]="Red"
					}
stones.home.computer = {[1]="Black", [2]="Black", [3]="Black",
					[4]="Black", [5]="Black", [6]="Black",
					[7]="Black", [8]="Black", [9]="Black"
					}
 position.board = {[1]={x=163,y=62}, [2]={x=434,y=62}, [3]={x=704,y=62},
				[4]={x=248,y=148}, [5]={x=434,y=148}, [6]={x=622,y=148},
				[7]={x=332,y=234}, [8]={x=434,y=234}, [9]={x=538,y=234},
				[10]={x=163,y=340}, [11]={x=248,y=340}, [12]={x=332,y=340},
				[13]={x=538,y=340}, [14]={x=622,y=340}, [15]={x=704,y=340},
				[16]={x=332,y=444}, [17]={x=434,y=444}, [18]={x=538,y=444},
				[19]={x=248,y=532}, [20]={x=434,y=532}, [21]={x=622,y=532},
				[22]={x=163,y=618}, [23]={x=434,y=618}, [24]={x=704,y=618}
				}
position.home = {}
position.home.human = {[1]= {x=787,y=268}, [2]={x=834,y=268}, [3]={x=787,y=314}, [4]={x=834,y=314},
						[5]={x=787,y=360}, [6]={x=834,y=360}, [7]={x=787,y=402}, [8]={x=834,y=402},
						[9]={x=811,y=444}
						}
position.home.computer = {[1]={x=38,y=268}, [2]={x=84,y=268}, [3]={x=38,y=314}, [4]={x=84,y=314},
						[5]={x=38,y=360}, [6]={x=84,y=360}, [7]={x=38,y=402}, [8]={x=84,y=402},
						[9]={x=61,y=444}
						}

local tripleControl = {[1]={1,2,3}, [2]={4,5,6}, [3]={7,8,9},
						[4]={10,11,12}, [5]={13,14,15}, [6]={16,17,18},
						[7]={19,20,21}, [8]={22,23,24}, [9]={1,10,22},
						[10]={4,11,19}, [11]={7,12,16}, [12]={2,5,8},
						[13]={17,20,23}, [14]={9,13,18}, [15]={6,14,21},
						[16]={3,15,24}
				}
local lControl = {[1]={10,1,2}, [2]={2,3,15}, [3]={15,24,23},
				[4]={23,22,10}, [5]={11,4,5}, [6]={5,6,14},
				[7]={14,21,20}, [8]={20,19,11}, [9]={12,7,8},
				[10]={8,9,13}, [11]={13,18,17}, [12]={17,16,12},
				[13]={10,11,4}, [14]={10,11,19}, [15]={2,5,4},
				[16]={2,5,6}, [17]={15,14,6}, [18]={15,14,21},
				[19]={23,20,19}, [20]={23,20,21}, [21]={11,12,7},
				[22]={11,12,16}, [23]={5,8,7}, [24]={5,8,9},
				[25]={14,13,9}, [26]={14,13,18}, [27]={20,17,18},
				[28]={20,17,16}
				} 
local moveControl = {[1]={2,10}, [2]={1,3,5}, [3]={2,15},
						[4]={5,11}, [5]={2,4,6,8}, [6]={5,14},
						[7]={8,12}, [8]={5,7,9}, [9]={8,13},
						[10]={1,11,22}, [11]={4,10,12,19}, [12]={7,11,16},
						[13]={9,14,18}, [14]={6,13,15,21}, [15]={3,14,24},
						[16]={12,17}, [17]={16,18,20}, [18]={13,17},
						[19]={11,20}, [20]={17,19,21,23}, [21]={14,20},
						[22]={10,23}, [23]={20,22,24}, [24]={15,23}
					}
local unControl = {}
-- local modeHumanMove= "off"  -- modlar hangi yerden hangi oyuncunun o anda oynadığını on/off şeklinde tutar.
-- local modeHumanHome= "off"
-- local modeHumanBoard= "off"
-- local modeComputerMove= "off"
-- local modeComputerHome= "off"
-- local modeComputerBoard= "off"
local modeHome = "Off"
local modeClick= "Off"	 -- mouse click yapıldıkça on/off olur bir nevi bayrak görevi görür
local tempPlayer = {"Computer", "Human"}
local modePlayer = tempPlayer[math.random(1,2)]	-- 1= Computer, 2=Human
modePlayer = "Human" --TEMP !!! it will be remove
local startPlayerName = modePlayer  -- Oyuna ilk kim başladı
local modeRemove = "Off"

local music = "Off"
local mousePosX = 0
local mousePosY = 0
local difficulty = "Easy"	 -- "Easy" "Medium" "Hard" 
local movedCounter = 0  -- oyun kaçıncı eli oynuyor
local info = "" -- Oyunda yanlış yapılan yada yapılması gereken bilgisini verir 
--local animationX = -50
--local animationY = -50

local win = ui.Window("Nine Stone     https://www.luart.org", "fixed", 870, 680)
win.x = 10
win.y = 10
win.cursor = "hand"

local soundMusic = audio.Sound("Media/Classic.mp3")
local soundClick = audio.Sound("Media/Click.mp3")
local soundWrong = audio.Sound("Media/Wrong.wav")

local tuval = ui.Canvas(win, 0, 0, win.width, win.height)
tuval.bgcolor = 0x001993 --0x000000FF
tuval.align = "all"
tuval.font = "Comic Sans MS"
tuval.fontsize = 16

local imgBoard = tuval:Image("Media/Board.png")
local imgBlack = tuval:Image("Media/Black.png")
local imgRed = tuval:Image("Media/Red.png")
local imgSoundOff = tuval:Image("Media/CheckBoxNO.png")
local imgSoundOn = tuval:Image("Media/CheckBoxOKEY.png")

win:show()

local lastIndex = nil -- Bir önce oynanan kırmızı taşın indexini tutar
local counter = 0  -- son kırmızı taş stoktan alındığğnda  bir kereliğine oyunun ikinci safhasına girmemesi için
	
function tuval:onClick(_xClick, _yClick) --Clicking on the stone, it will be captured
	info = ""
	if (modePlayer == "Human") and  (modeClick == "Off")  and (modeRemove == "Off") then --Oynayan Human ise Taşa tıkladıksa
		if #position.home.human > 0 then  --Stoktaki taşlar hala duruyorsa Stoktan taş almaya müsade et
			getHome(_xClick, _yClick)
		else  --Stoktaki taşlar bittiyse boarddan taş almaya müsade et
			getStone(_xClick, _yClick)	
		end		
	end
	
	if (modePlayer == "Human") and  (modeClick == "On")  and (modeRemove == "Off") then  --Oynayan Human ise Taş zaten tıklanıp mousedeyse
		if (#position.home.human >= 0 ) and (counter == 0) then
			modeHome = "On"
			putStone(_xClick, _yClick)			
		else			
			modeHome = "Off"
			putStone(_xClick, _yClick)
		end
	end
	if (modePlayer == "Human") and  (modeClick == "Off")  and (modeRemove == "On") then
		getRemove(_xClick, _yClick)
	end

	if (_xClick > 840) and (_xClick <  (840 + 16)) and (_yClick > 18) and (_yClick < (18 + 16)) then -- Musik on/off
		if music == "Off" then
			music = "On"
			soundMusic:play()
		elseif music == "On" then
			music = "Off"
			soundMusic:stop()
		end
	end
	
	if movedCounter == 0 then -- Zorluk derecesi
		if (_xClick > 780) and (_xClick <  (780 + 16)) and (_yClick > 50) and (_yClick < (50 + 16)) then
			difficulty = "Easy"
		elseif (_xClick > 780) and (_xClick <  (780 + 16)) and (_yClick > 75) and (_yClick < (75 + 16)) then
			difficulty = "Medium"
		elseif (_xClick > 780) and (_xClick <  (780 + 16)) and (_yClick > 100) and (_yClick < (100 + 16)) then
			difficulty = "Hard"
		end
	end
	
end

function tuval:onHover(_xHover, _yHover)
	mousePosX = _xHover - 18
	mousePosY = _yHover - 18
end

function resim()
	tuval:begin()
	tuval:clear()
	
	imgBoard:draw(0,0)
	
	for i=1, #position.home.computer do
		imgBlack:draw(position.home.computer[i].x-18, position.home.computer[i].y-18)
	end
	
	for i=1, #position.home.human do
		imgRed:draw(position.home.human[i].x-18, position.home.human[i].y-18)
	end
	
	for i=1, #stones.board do  --Put the stone on Board
		if stones.board[i] == "Red" then
			imgRed:draw(position.board[i].x-18, position.board[i].y-18)
		elseif stones.board[i] == "Black" then
			imgBlack:draw(position.board[i].x-18, position.board[i].y-18)
		end
	end

	if modeClick == "On" then  --Mouse get Stone together move
		imgRed:draw(mousePosX, mousePosY)
	end

	if music == "Off" then
		imgSoundOff:draw(840, 18)		
	else
		imgSoundOn:draw(840, 18)		
	end	
	
	tuval:print(info, 350, 265, 0x0000CCFF)
	tuval:line(350, 295, 520, 295,0x0000CCFF, 1)
	tuval:print("Difficulty: "..difficulty, 380, 300)
	tuval:print("Player: "..modePlayer, 380, 330)
	tuval:print("Moved: "..movedCounter, 380, 360)
	tuval:print("Music On/Off", 720, 15)
	
	if movedCounter == 0 then  -- Sadece açılışta bir kere gösterilir
		tuval:print("Easy", 800, 45)
		tuval:print("Medium", 800, 70)
		tuval:print("Hard", 800, 95)
		if difficulty == "Easy" then
			imgSoundOn:draw(780, 50)
			imgSoundOff:draw(780, 75)
			imgSoundOff:draw(780, 100)
		elseif difficulty == "Medium" then
			imgSoundOff:draw(780, 50)
			imgSoundOn:draw(780, 75)
			imgSoundOff:draw(780, 100)
		elseif difficulty == "Hard" then
			imgSoundOff:draw(780, 50)
			imgSoundOff:draw(780, 75)
			imgSoundOn:draw(780, 100)
		end	
	end

	--imgBlack:draw(animationX, animationY) 
		
	tuval:flip()
	
	if modePlayer == "Computer" then
		ui.update(10) --1000 yapacağız
		AI()
	end
end

-- function Animation(_to)
	-- local fromX = position.home.computer[1].x
	-- local fromY = position.home.computer[1].y
	-- table.remove(position.home.computer, 1)
	
	-- local dX = position.board[_to].x - fromX
	-- local dY = position.board[_to].y - fromY

-- print(dX)
	-- for i=1, 100 do
		-- animationY = math.floor(((dX * position.board[_to].y) - (dY * position.board[_to].x) + (i + fromX)*dY) / dX)
		-- imgBlack:draw(animationX, animationY) 
	-- end
	-- animationX = -50
	-- animationY = -50
-- end

function getHome(_x, _y) --Stokta taşlar bitmemişse
	for i=1, #position.home.human do
		if (_x > position.home.human[i].x-18) and (_x < position.home.human[i].x + 18) and (_y > position.home.human[i].y-18) and (_y < position.home.human[i].y + 18) then
			_x = _x +18
			_y = _y +18
			modeClick = "On"
			soundClick:play()
			table.remove(position.home.human, i)
			lastIndex = i
			break			
		end				
	end
end

function putStone(_x, _y)	--Stoktaki taşlardan alıp koy	-- putStonesInStock(_x, _y)	
	if modeHome == "On" then
		for i=1, #position.board do
			if (_x > position.board[i].x-18) and (_x < position.board[i].x + 18) and (_y > position.board[i].y-18) and (_y < position.board[i].y + 18) then
				_x = _x +18
				_y = _y +18
				if stones.board[i] == "Empty" then
					stones.board[i] = "Red"
					modeClick = "Off"				
					movedCounter = movedCounter + 1
					soundClick:play()
					local tempTriple = destroyStone("Red")  -- 3lü yanyana/üstüste taş varmı kırmızıda kontrol et  --DENEME!!!!!
					if tempTriple == true then --DENEME!!!!!
						info = "Destroye a Black Stone!"  --DENEME!!!!!
						modeRemove = "On"
						if #position.home.human == 0 then
							counter = 1
						end	
						break
					else
						modePlayer = "Computer"
					end
					if #position.home.human == 0 then
						counter = 1
					end				
					break
				else
					soundWrong:play()
				end				
			end
		end
	else
		for i=1, #position.board do
			if (_x > position.board[i].x-18) and (_x < position.board[i].x + 18) and (_y > position.board[i].y-18) and (_y < position.board[i].y + 18) then	
				for j= 1, #moveControl[lastIndex] do --Alınan taşın sağ-sol-yukarı-aşağısı kaç tane kadar kontrol
					if i == moveControl[lastIndex][j] then --Konulan taş alınan taşın sağ-sol-yukarı-aşağısındaysa
						_x = _x +18
						_y = _y +18
						if stones.board[i] == "Empty" then
							stones.board[i] = "Red"
							modeClick = "Off"
							modePlayer = "Computer"
							movedCounter = movedCounter + 1
						else
							soundWrong:play()
							stones.board[lastIndex]= "Red"
							modeClick = "Off"
						end
						soundClick:play()					
						break
					end
				end	
			end
		end		
	end
end

function getStone(_x, _y) -- Stoktaki taşlar bitmiş ve oyun oynama evresi başlamışsa
	for i=1, #position.board do
		if (_x > position.board[i].x-18) and (_x < position.board[i].x + 18) and (_y > position.board[i].y - 18) and (_y < position.board[i].y + 18 ) and (stones.board[i] == "Red") then
			_x = _x +18
			_y = _y +18
			modeClick = "On"
			soundClick:play()
			stones.board[i] = "Empty"
			lastIndex = i
			break			
		end
	end
end


function destroyStone(_colour) --YENİ !!!!!!
	local tempTable={}	
	for i=1, #tripleControl do
		local tempCounter = 0
		for j=1 , #tripleControl[i] do			
			if stones.board[tripleControl[i][j]] == _colour then
				tempCounter = tempCounter + 1
			end						
		end	
		if tempCounter == 3 then  -- Eğer 3 Siyah taş yanyana/üst üste gelmişse 
			table.insert(tempTable, i)  --DENEME!!!!!
		end
	end
	
	for i=1, #tempTable then --DENEME!!!!!
		local temp1= false --DENEME!!!!!
		for j=1, #unControl then	 --DENEME!!!!!		
			if tempTable[i] == unControl[j] then --DENEME!!!!!
				temp1 = true	 --DENEME!!!!!			
			end --DENEME!!!!!
		end --DENEME!!!!!
		if temp1 == true then --DENEME!!!!!
			table.insert(unControl, i) --DENEME!!!!!
		end --DENEME!!!!!
	end --DENEME!!!!!
	
	return true  --DENEME!!!!!
	--------
end

function getRemove(_x, _y) -- Taş yeme modumuz
	for i=1, #position.board do
		if (_x > position.board[i].x-18) and (_x < position.board[i].x + 18) and (_y > position.board[i].y - 18) and (_y < position.board[i].y + 18 ) and (stones.board[i] == "Black") then
			_x = _x +18
			_y = _y +18	
			modeClick = "On"			
			soundClick:play()
			stones.board[i] = "Empty"
			lastIndex = i
			modeClick = "Off"
			modeRemove = "Off"
			modePlayer = "Computer"
			break			
		end
	end	
end

function AI_Easy()
	local temp
	repeat
		temp = math.random(1, 24)
	until stones.board[temp] == "Empty"
	return temp	
end

function AI_Medium()
	local temp
	for i=1, #tripleControl do
		local tempCounter = 0
		for j=1 , #tripleControl[i] do			
			if stones.board[tripleControl[i][j]] == "Red" then
				tempCounter = tempCounter + 1
			end						
		end
		if tempCounter == 2 then					
			for j=1 , #tripleControl[i] do
				if stones.board[tripleControl[i][j]] == "Empty" then
					temp = tripleControl[i][j]
					return temp
				end						
			end	
		end
	end
	temp = 0
	return temp
end

function AI_Hard()
	local temp 
	for i=1, #lControl do
		local tempCounter = 0
		for j=1 , #lControl[i] do
			if stones.board[lControl[i][j]] == "Red" then
				tempCounter = tempCounter + 1
			end						
		end
		if tempCounter == 2 then					
			for j=1 , #lControl[i] do
				if stones.board[lControl[i][j]] == "Empty" then
					temp = lControl[i][j]
					return temp
				end						
			end	
		end
	end
	temp = 0
	return temp
end

function AI()
	if #position.home.computer > 0 then -- Eğer Stokta taş varsa bunları yap
		if startPlayerName == "Human" then --Eğer oyuna ilk başlayan Human ise o zaman Savunma oyna
			local temp
			if difficulty == "Easy" then -- Eğer zorluk "Easy" ise
				temp = AI_Easy()				
			elseif difficulty == "Medium" then -- Eğer zorluk "Medium" ise
				temp = AI_Medium()
				if temp == 0 then
					temp = AI_Easy()  --Eğer ü bişey yoksa tesadüfen bul
				end
			elseif difficulty == "Hard" then  -- Eğer zorluk "Hard" ise
				temp = AI_Hard()
				if temp == 0 then
					temp = AI_Medium()  --Eğer triplede bişey yoksa Mediumu kontrol et
					if temp == 0 then
						temp = AI_Easy() --Eğer triplede bişey yoksa tesadüfen bul
					end
				end	
			end
			
			table.remove(position.home.computer, 1) -- Düzeltilecek !!! remove() den kurtul emty yap
			--Animation(temp)
			stones.board[temp] = "Black"
						
		end
	end	
	modePlayer = "Human"
	movedCounter = movedCounter + 1
end


repeat
	resim()
	ui.update()
until not win.visible

