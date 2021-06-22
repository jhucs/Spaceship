-------------------------------
NombreArtista="Juanito Perez"
NombreEmpresa="Square Enix"

-------------------------------
screen={x=240,y=130}
player={x=120,y=120}
PlayerShoots={}
Stars={}
Enemies={}
PowerUp={}
ta=0
tb=0
tc=0
td=0
t=0
spt=100
PlayerState=1
GameState=0
TitleColor=0
ScoreHUD=0



local rand, floor = math.random, math.floor

function Shoot()
	table.insert( PlayerShoots, {player.x+8,player.y+8}) 
end

function Control()
		if btn(2)then 
            player.x=player.x-2
        end
        if btn(3) then 
            player.x=player.x+2
        end
        if btnp(4) then 
            Shoot()
        end
end

function SpriteStars()
	ta=ta+1
	
	if (ta>20) then
		aux = floor(rand(0,3))
		table.insert( Stars, {floor(rand(0,screen.x)),-4,12+aux,(1+aux)/2}) 
		ta=0
	end

	for key, item in pairs(Stars) do
    	circ(item[1], item[2], 1, item[3])
    	item[2] = item[2]+item[4]
	end
	
end

function SpriteBonus()
	tc=tc+1
	
	if (tc>200) then
		table.insert( PowerUp, {floor(rand(40,screen.x-40)),-18})
		tc=0
	end

	for key, item in pairs(PowerUp) do
    	spr(6, item[1], item[2], 0, 1, 0, 0, 2, 2)
    	item[2] = item[2]+1
	end
	
end

function SpriteEnemies()
	tb=tb+1

	if (tb>spt) then
		aux = floor(rand(1,2))
		offset = rand(0,60)
		table.insert( Enemies, {floor(rand(40,screen.x-40)),-18,aux*2,0.5,offset,0})
		tb=0
	end

	for key, item in pairs(Enemies) do
		item[6] = item[1]+(math.cos((t/20)+item[5])*25)
    	spr(item[3], item[6], item[2], 0, 1, 0, 0, 2, 2)
    	item[2] = item[2]+item[4]
	end

end


function SpritePlayer()

	if PlayerState==1 then
		for key, item in pairs(PlayerShoots) do
			item[2] = item[2]-4
	    	circb(item[1], item[2], 3, 12)
	    	circ(item[1], item[2], 2, 3)
		end

		spr(0, player.x, player.y, 0, 1, 0, 0, 2, 2)
	end

end

function ColliderCheck()
	for keye, enemy in pairs(Enemies) do
		for keys, shoot in pairs(PlayerShoots) do
			if math.abs((enemy[6]+7)-shoot[1])<8 and math.abs((enemy[2]+7)-shoot[2])<8 then
				table.remove(Enemies,keye)
				table.remove(PlayerShoots,keys)
				ScoreHUD=ScoreHUD+150
			end
		end

		if math.abs((enemy[6]+7)-player.x)<8 and math.abs((enemy[2]+7)-player.y)<8 then
				table.remove(Enemies,keye)
				PlayerState=0
		end

	end

	for keyp, pw in pairs(PowerUp) do
		if math.abs((pw[1]+7)-player.x)<10 and math.abs((pw[2]+7)-player.y)<10 then
			table.remove(PowerUp,keyp)
			ScoreHUD=ScoreHUD+2000
		end

	end

end

function HUD()
	print( "Score: " .. ScoreHUD , 5, 0, 12, 0, 1)
end

function Title()
	print("SpaceShip", screen.x/2, screen.y/2 - 20, TitleColor, 0, 2)
	print( "by " .. NombreEmpresa , screen.x/2, screen.y/2 , TitleColor, 0, 1)
    print( NombreArtista , 5, 0, TitleColor, 0, 1)
    print("Lian Grandon", 5, 8, TitleColor, 0, 1)

    print("Press Z to play", screen.x/2 - 44, screen.y - 8, TitleColor, 0, 1)
end

function Adaptative()
	td=td+1
	if td>200 and spt>20 then
		td=0
		spt=spt-5
	end
end

function TIC()
	t=t+1
    cls()
    SpriteStars()
    
    if GameState==0 then
    	Title()
    	if (t>15) then
    		TitleColor = 15
    	end

    	if (t>20) then
    		TitleColor = 14
    	end

    	if (t>25) then
    		TitleColor = 13
    	end

    	if btnp(4) then 
            t=0
            GameState=1
        end
    end

    if GameState==1 then
    	Title()
    	if (t>10) then
    		TitleColor = 13
    	end

    	if (t>15) then
    		TitleColor = 14
    	end

    	if (t>20) then
    		TitleColor = 15
    	end

    	if (t>25) then
    		GameState = 1
    		t=0
            GameState=2
    	end
    end

    if GameState==2 then
    	Control()
    	SpritePlayer()
    	SpriteEnemies()
    	SpriteBonus()
    	ColliderCheck()
    	HUD()
    	Adaptative()
    end
end
-------------------------------
