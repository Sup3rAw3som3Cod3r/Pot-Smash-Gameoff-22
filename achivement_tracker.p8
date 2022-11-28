pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
cartdata("gameoff22_nostone")


menuitem(1,"reset data",function()
for i=0,63 do
	dset(i,0)
end
run()
end)

function _init()
	dirx={-1,1,0,0,1,1,-1,-1}
 diry={0,0,-1,1,-1,1,1,-1}
 
 items=split([[웃,☉,…,░,♥,█,●,ˇ,▤,♪,∧,✽,★,◆,⌂,😐,▒,▥]])

	itn=1
	data()
end

function _update60()
	if btnp(⬆️) then
		itn-=1
		
	end
	if btnp(⬇️) then
		itn+=1
	end
	itn=loop(itn,#items)
end


function _draw()
	cls(1)
	
	for i=-3,3 do
		print_itm(itn+i,5,60+(i*12),i==0)
	end
	
	if efx[itn]!=nil then
	 
	 
	 if itn>4 and dget(itn-4)==0 then
			print_itm(itn,60,30)
		 print("locked:",50,40)
		 print(cnd[itn-4],48,50)
		else
			print_itm(itn,60,30)
	  print(efx[itn],48,50)
	  if itn>4 then
	  print("unlocked by:",50,80)
		 print(cnd[itn-4],48,90)
		 end
  end
	end
end

function print_itm(n,x,y,cur)
 c1,c2=11,3
 n=loop(n,#items)
 if n>4 then
 	if dget(n-4)==0 then
 		c1,c2=8,2
		end
 end
 txt=n
 txt=items[n] or ""
-- txt=txt..n
 if cur then
 	txt="> "..txt
 else
 	txt="  "..txt
 end
 
	oprint8(txt,x,y,c1,c2)
	
end

function loop(v,mx)
	if v>mx then
		return v-mx
	end
	if v<1 then
		return v+mx
	end
	return v
end


function data()
nme={}

efx=split([[+1 armor
,+2 vision range
,+1 melee damage
,+1 ranged damage
,+3 max health
,reveal level walls
,+5 max ammo
,10% chance to heal
1 hp when you kill
an enemy
,+1 melee damage
and +1 ranged damage
,15% chance to not
consume ammo when
shooting
,bullets break pots 
and open doors and
small chests
,melee attacks hit
in a + shape
,bullets hit in a
+ shape
,3x chance to get
ammo when breaking
a pot
,25% chance to gain
ammo when you kill
an enemy
,you start every
floor blessed
,1% chance to heal
1 hp every step you
take
,10% chance to ignore
damage]])

cnd=split([[
have 8 or more hp
in 1 run
,use 3 torches in
1 run
,use 3 clips in 
1 run
,get 30 kills in 1
run
,take 2 melee damage
and 2 range damage ups
in 1 run
,win a run
,reach floor 2
,reach floor 4
,reach floor 6
,reach floor 8
,eat 30 food items in 
one run
,save a cursed soul
,take 1 thousand 
steps in 1 run
,take 3 armor 
upgrades in 1
run]])
end

--unlock conditions

--[[
♥ - +3 max hp
have 8+ max hp in 1 run

█ - map
use 3 torches in 1 run

● - +5 max ammo
use 3 clips in 1 run

ˇ - 10% chance to heal on enemy kill
get 30 kills in 1 run

▤ - all dmg +1
take 2 melee and 2 ranged dmg ups

♪ - 15% chance to not consume ammo
win a run

∧ - bullets break pots
reach floor 2

✽ - melee hits in a +
reach floor 4

★ - bullets hit in a +
reach floor 6

◆ - always gain ammo on pot break
reach floor 8

⌂ - 25% chance to gain ammo on enemy kill
eat 30 food in 1 run

😐 - start floors blessed
kill a ghost by blessing it

▒ - 1% chance to heal on movement
take 1k steps in 1 run

▥ - 10% chance to block dmg
take 3 armor in 1 run


--unlocked by default
웃 -armor up
☉ -vision range up
… -melee dmg up
░ -range dmg up

]]

-->8


function oprint8(_t,_x,_y,_c,_c2)
 for i=1,8 do
  print(_t,_x+dirx[i],_y+diry[i],_c2)
 end 
 print(_t,_x,_y,_c)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
