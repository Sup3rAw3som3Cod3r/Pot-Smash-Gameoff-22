pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-------fix spritesheet!!!!!!!

menuitem(1,"reset data",function()
for i=0,63 do
	dset(i,0)
end
run()
end)

menuitem(2,"view items",function()
	load("achivement_tracker.p8","back to game")

end)



function _init()
 t=0
 shake=0
 
 dpal=explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14")
 
 mystreak=0
 
 
 perkdata()
 
 dirx=explodeval("-1,1,0,0,1,1,-1,-1")
 diry=explodeval("0,0,-1,1,-1,1,1,-1")
 
 itm_name=explode("food 1,food 2,food 3,food 4,food 5,food 6,food 7,useless food,rock,dart,shuriken,dagger,torch,extra clip")
 itm_type=explode("fud,fud,fud,fud,fud,fud,fud,fud,thr,thr,thr,thr,tor,clp")
 itm_stat1=explodeval("1,2,3,4,5,6,7,8,1,2,3,4,1,1")
 itm_stat2=explodeval("0,0,0,0,0,0,0,0,0,0,0,0,0,0")
 itm_minf=explodeval("1,1,1,1,1,1,1,9,1,2,3,4,1,1")
 itm_maxf=explodeval("9,9,9,9,9,9,9,9,4,6,7,9,9,9")
 itm_desc=explode(" heals, heals a lot, increases hp, stuns, is cursed, is blessed, is poisoned,tastes good,deals 1 damage,deals 2 damage,deals 3 damage,deals 4 damage,lights up the area,reloads 5 ammo")
	itm_use={}

 mob_name=explode("player,slime,melt,shoggoth,mantis-man,giant scorpion,ghost,golem,drake")
 mob_ani=explodeval("240,192,196,200,204,208,212,216,220")
 mob_atk=explodeval("1,1,2,1,2,3,3,5,5")
 mob_hp=explodeval("5,1,2,3,3,4,5,14,8")
-- mob_los=explodeval("4,4,4,4,4,4,4,4,4")
 mob_minf=explodeval("0,1,2,3,4,5,6,7,8")
 mob_maxf=explodeval("0,3,4,5,6,7,8,8,8")
 mob_spec=explode(",,,plant,plant,stun,ghost,slow,")

 crv_sig=explodeval("255,214,124,179,233")
 crv_msk=explodeval("0,9,3,12,6")

 free_sig=explodeval("0,0,0,0,16,64,32,128,161,104,84,146")
 free_msk=explodeval("8,4,2,1,6,12,9,3,10,5,10,5")

 wall_sig=explodeval("251,233,253,84,146,80,16,144,112,208,241,248,210,177,212,178,179,0,124,104,161,64,240,128,224,176,242,244,116,232,120,225,247,214,254,192,48,96,32,160,245,250,243,249,246,252")
 wall_msk=explodeval("0,6,0,11,13,11,15,13,3,9,0,0,9,12,9,12,12,15,3,7,14,15,0,15,6,12,0,0,3,6,3,6,0,9,0,15,15,7,15,14,0,0,0,0,0,0")

 debug={}
 startgame()
end

function _update60()
 t+=1
 _upd()
 dofloats()
 dohpwind()
end

function _draw()
 doshake()
 _drw()
 drawind()
 drawlogo()
 --fadeperc=0
 checkfade()
 --★
 cursor(4,4)
 color(8)
 for txt in all(debug) do
  print(txt)
 end
end

function startgame()
 perkdata()
 poke(0x3101,194)
 music(0)
 tani=0
 fadeperc=1
 buttbuff=-1
 
 ammo=5
 mammo=5
 
	rdmg=2
	 
	alperks={}
	for i=1,#perks do
		add(alperks,perks[i])
	end
	 
 myperks={}
 
 for i=1,#itm_name do
 	itm_use[i]=0
 end
 
 logo_t=240
 logo_y=35
 
 skipai=true
 win=false
 winfloor=10
 --★
 mob={}
 dmob={}
 p_mob=addmob(1,1,1)
 
 p_t=0
 
 inv={}
 makeipool()
 foodnames()
-- takeitem(13)
 
 wind={}
 float={}

 talkwind=nil
 perkwind=nil
 hpwind=addwind(5,5,36,19,{})
 
 thrdx,thrdy=0,-1
 
 _upd=update_game
 _drw=draw_game
 
 st_steps,st_kills,st_meals,st_killer=0,0,0,""

 
 vx,vy={},{}

 
 genfloor(0)
-- perkwin()
 
end

function vases()
	for x=0,15 do
		for y=0,15 do
			if fget(mget(x,y),7) then
				add(vx,x)
				add(vy,y)
			end
		end
	end
--	debug[1]=#vx
end
-->8
--updates
function update_game()
--	debug=alperks
--	debug=myperks
 if talkwind then
 	if curwind==talkwind then
	 	if btnp(2) or btnp(3) then
	 		talkwind.cur=(talkwind.cur==2) and 3 or 2
			end
 	end
  if getbutt()==5 then
  	if curwind==talkwind then
   	takeperk(sub(talkwind.txt[talkwind.cur],1,1))
  	end
   sfx(53)
   talkwind.dur=0
   talkwind=nil
  end
 else
  dobuttbuff()
  dobutt(buttbuff)
  buttbuff=-1
 end
end

function update_inv()
 --inventory
 if move_mnu(curwind) and curwind==invwind then
  showhint()
 end
 if btnp(4) then
  sfx(53)
  if curwind==invwind then
   _upd=update_game
   invwind.dur=0
   statwind.dur=0
   pwind.dur=0
   if hintwind then
    hintwind.dur=0
   end
  --★
  elseif curwind==usewind then
   usewind.dur=0
   curwind=invwind
  end
 elseif btnp(5) then
  sfx(54)
  if curwind==invwind and invwind.cur!=2 then
   showuse()
   --★
  elseif curwind==usewind then
   -- use window confirm 
   triguse() 
  end
 end
 
end

function update_throw()
 local b=getbutt()
 if b>=0 and  b<=3 then
  thrdx=dirx[b+1]
  thrdy=diry[b+1]
 end
 if b==4 then
  _upd=update_game
 elseif b==5 then
  throw()
 end
end

function move_mnu(wnd)
 local moved=false
 if btnp(2) then
  sfx(56)
  wnd.cur-=1
  moved=true
 elseif btnp(3) then
  sfx(56)
  wnd.cur+=1
  moved=true
 end
 wnd.cur=(wnd.cur-1)%#wnd.txt+1
 return moved
end


function update_pturn()
 dobuttbuff()
 p_t=min(p_t+0.125,1)
 
 if p_mob.mov then
  p_mob:mov()
 end
 
 if p_t==1 then
  _upd=update_game
  if trig_step() then return end
				
  if checkend() and not skipai then
   doai()
  end
  skipai=false
 end
end

function update_aiturn()
 dobuttbuff()
 p_t=min(p_t+0.125,1)
 for m in all(mob) do
  if m!=p_mob and m.mov then
   m:mov()
  end
 end
 if p_t==1 then
  _upd=update_game
  if checkend() then
   if p_mob.stun then
    p_mob.stun=false
    doai()
   end
  end
 end
end

function update_gover()
 if btnp(❎) then
  sfx(54)
  fadeout()
  startgame()
 end
end

function dobuttbuff()
 if buttbuff==-1 then
  buttbuff=getbutt()
 end
end

function getbutt()
 for i=0,5 do
  if btnp(i) then
   return i
  end
 end
 return -1
end

function dobutt(butt)
 if butt<0 then return end
 if logo_t>0 then logo_t=0 end
 if butt<4 then
  moveplayer(dirx[butt+1],diry[butt+1])
 elseif butt==5 then
  showinv()
  sfx(54)
-- elseif butt==4 then
  --win=true
  --p_mob.hp=0
  --st_killer="slime"
  --genfloor(floor+1)
  --prettywalls()
 end
end
-->8
--draws
function draw_game()
 cls(0)
 if fadeperc==1 then return end
 animap()
 
 local cl1,cl2,cl3=
 explodeval("5,5,5,1,1,3,3,4,4,2,2"),
 explodeval("13,13,13,13,13,11,11,9,9,8,8"),
 explodeval("6,6,6,12,12,10,10,10,10,14,14")
 
 local fnum=floor+1
 local c1,c2,c3=cl1[fnum],cl2[fnum],cl3[fnum]
 
-- debug[1]=cl1[4]

 pal(5,c1)
 pal(13,c2)
 pal(6,c3)
 map()
 pal()
 for m in all(dmob) do
  if sin(time()*8)>0 or m==p_mob then
   drawmob(m)
  end
  m.dur-=1
  if m.dur<=0 and m!=p_mob then
   del(dmob,m)
  end
 end
 
 for i=#mob,1,-1 do
  drawmob(mob[i])
 end
 
 if _upd==update_throw then
  --★
  local tx,ty=throwtile()
  local lx1,ly1=p_mob.x*8+3+thrdx*4,p_mob.y*8+3+thrdy*4
  local lx2,ly2=mid(0,tx*8+3,127),mid(0,ty*8+3,127)
  rectfill(lx1+thrdy,ly1+thrdx,lx2-thrdy,ly2-thrdx,0)
  
  local thrani,mb=flr(t/7)%2==0,getmob(tx,ty)
  if thrani then
   fillp(0b1010010110100101)
  else
   fillp(0b0101101001011010)
  end
  line(lx1,ly1,lx2,ly2,7)
  fillp()
  oprint8("+",lx2-1,ly2-2,7,0)
  
  if mb and thrani then
   mb.flash=1
  end
 end 
 
 for x=0,15 do
  for y=0,15 do
   if fog[x][y]==1 then
    rectfill2(x*8,y*8,8,8,0)
   end
  end
 end
  
 for f in all(float) do
  oprint8(f.txt,f.x,f.y,f.c,0)
 end
 if floor==0 then
 	for i=1,#unlockperks do
 		local t,c1,c2="-",8,6
 		if dget(i)==1 then
 			t,c1,c2="<",11,5
			end
 		oprint8(unlockperks[i]..t,100,8*i,c1,c2)
 		oprint8("streak:"..mystreak,10,110,7,5)
		end
 end

end

function drawlogo()
 if logo_y>-24 then
  logo_t-=1
  if logo_t<=0 then
   logo_y+=logo_t/20
  end
  palt(12,true)
  palt(0,false)
  spr(144,7,logo_y,14,3)
  palt()
  oprint8("the quest for destruction",13,logo_y+20,7,0)
 end
end

function drawmob(m)
 local col=10
 if m.flash>0 then
  m.flash-=1
  col=7
 end
 drawspr(getframe(m.ani),m.x*8+m.ox,m.y*8+m.oy,col,m.flp)
end

--[[function draw_gover()
 cls(2)
 print("y ded",50,50,7)
end
function draw_win()
 cls(2)
 print("u win",50,50,7)
end]]--

function draw_gover()
 cls(1)
 palt(12,true)
 palt(0,false)
 spr(gover_spr,gover_x,30,gover_w,2)
 if not win then
  print("killed by a "..st_killer,28,43,6,0)
 end
 palt()
 color(6)
 cursor(40,56)
 if not win then
  print("floor: "..floor)
 end
 print("steps: "..st_steps)
 print("kills: "..st_kills)
 print("meals: "..st_meals) 

 oprint8("press ❎",46,90,5+abs(sin(time()/3)*2),0)
end

function animap()
 tani+=1
 if (tani<15) return
 tani=0
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==64 or tle==66 then
    tle+=1
   elseif tle==65 or tle==67 then
    tle-=1
   end
   mset(x,y,tle)
  end
 end
end

-->8
--tools

function apal(c)
	for i=0,15 do
		pal(i,c)
	end
end

function getframe(ani)
 return ani[flr(t/15)%#ani+1]
end

function drawspr(_spr,_x,_y,_c,_flip)
-- palt(0,false)
 apal(0)
 
 clip(_x,_y,8,8)
 
 for i=1,8 do
 	local dx,dy=_x+dirx[i],_y+diry[i]
	 spr(_spr,dx,dy,1,1,_flip)
 end
 pal()
-- pal(6,_c)
 spr(_spr,_x,_y,1,1,_flip)
-- pal()
 clip()
end

function rectfill2(_x,_y,_w,_h,_c)
 --★
 rectfill(_x,_y,_x+max(_w-1,0),_y+max(_h-1,0),_c)
end

function oprint8(_t,_x,_y,_c,_c2)
 for i=1,8 do
  print(_t,_x+dirx[i],_y+diry[i],_c2)
 end 
 print(_t,_x,_y,_c)
end

function dist(fx,fy,tx,ty)
 local dx,dy=fx-tx,fy-ty
 return sqrt(dx*dx+dy*dy)
end

function dofade()
 local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
 for j=1,15 do
  col = j
  kmax=flr((p+j*1.46)/22)
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

function checkfade()
 if fadeperc>0 then
  fadeperc=max(fadeperc-0.04,0)
  dofade()
 end
end

function wait(_wait)
 repeat
  _wait-=1
  flip()
 until _wait<0
end

function fadeout(spd,_wait)
 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 wait(_wait)
end

function blankmap(_dflt)
 local ret={} 
 if (_dflt==nil) _dflt=0
 
 for x=0,15 do
  ret[x]={}
  for y=0,15 do
   ret[x][y]=_dflt
  end
 end
 return ret
end

function getrnd(arr)
 return arr[1+flr(rnd(#arr))]
end

function copymap(x,y)
 local tle
 for _x=0,15 do
  for _y=0,15 do
   tle=mget(_x+x,_y+y)
   mset(_x,_y,tle)
   if tle==15 then
    p_mob.x,p_mob.y=_x,_y
   end
  end
 end
end

function explode(s)
 local retval,lastpos={},1
 for i=1,#s do
  if sub(s,i,i)=="," then
   add(retval,sub(s, lastpos, i-1))
   i+=1
   lastpos=i
  end
 end
 add(retval,sub(s,lastpos,#s))
 return retval
end

function explodeval(_arr)
 return toval(explode(_arr))
end

function toval(_arr)
 local _retarr={}
 for _i in all(_arr) do
  add(_retarr,flr(tonum(_i)))
 end
 return _retarr
end

function doshake()
 local shakex,shakey=16-rnd(32),16-rnd(32)
 camera(shakex*shake,shakey*shake)
 shake*=0.95
 if (shake<0.05) shake=0
end
-->8
--gameplay

function moveplayer(dx,dy)
 local destx,desty=p_mob.x+dx,p_mob.y+dy
 local tle=mget(destx,desty)
  
 if iswalkable(destx,desty,"checkmobs") then
  sfx(63)
  mobwalk(p_mob,dx,dy)
  st_steps+=1
  if chance("▒",.01) then
  	healmob(p_mob,1)
  end
  if st_steps>999 then
  	achieve("▒")
  end
  p_t=0
  _upd=update_pturn
 else
  --not walkable
  mobbump(p_mob,dx,dy)
  p_t=0
  _upd=update_pturn
  
  local px,py=p_mob.x,p_mob.y
  
  local mob=getmob(destx,desty)
  if mob then
   sfx(58)   
   if hasperk("✽") then
   	spbonk(px,py,true)
   else
    hitmob(p_mob,mob)
   end
  else
   if fget(tle,1) then
    
    if hasperk("✽") and fget(tle,5) then
    	spbonk(px,py,true)
    else
     trig_bump(tle,destx,desty)
    end
   else
    skipai=true
    --mset(destx,desty,1)
   end
  end
 end
 unfog()
end

function trig_bump(tle,destx,desty)
 if fget(tle,7) then
  --vase
  sfx(59)
  if ammo<mammo and chance(hasperk("◆") and .15 or 0.05)then
  	ammo+=1
  end
  if #vx>0 then
   mset(destx,desty,76)
  	del(vx,destx)
  	del(vy,desty)
  	if #vx<=0 then
  		mset(destx,desty,14)
			end
  end
  if rnd(3)<1 and floor>0 then
   if rnd(5)<1 then
    addmob(getrnd(mobpool),destx,desty)
    sfx(60)
   else
    if freeinvslot()==0 then
     showmsg("inventory full",120)
     sfx(60)
    else
     sfx(61)
     local itm=getrnd(fipool_com)
     takeitem(itm)
     showmsg(itm_name[itm].."!",60)
    end
   end
  end
 elseif tle==10 then
  --chest
  if freeinvslot()==0 then
   showmsg("inventory full",120)
   skipai=true
   sfx(60)
  else
   local itm=getrnd(fipool_com)
   sfx(61)
   mset(destx,desty,9)
   if tle==10 then
    takeitem(itm)
    showmsg(itm_name[itm].."!",60)
   end
  end
 elseif tle==12 then
  perkwin()
  sfx(61)
  mset(destx,desty,11)
 elseif tle==13 then
  --door
  sfx(62)
  mset(destx,desty,62)
 elseif tle==6 then
  --stone tablet
  if floor==0 then
   sfx(54)
   showtalk(explode(" welcome to porklike!,, climb this sausage, tower to obtain the, ultimate power of, the golden kielbasa, "))
  end
 elseif tle==110 then
  --kielbasa
  win=true
  streak(true)
 end
end

function trig_step()
 local tle=mget(p_mob.x,p_mob.y)

 if tle==14 then
  sfx(55)
  p_mob.bless=hasperk("😐") and 1 or 0
  fadeout()
  genfloor(floor+1)
  floormsg()
 	local funl=explode("∧,✽,★,◆,♪")
  if floor%2==0 then
  	achieve(funl[flr(floor/2)])
  end
  return true
 end
 return false
end

function getmob(x,y)
 for m in all(mob) do
  if m.x==x and m.y==y then
   return m
  end
 end
 return false
end

function iswalkable(x,y,mode)
 local mode = mode or "test"
 
 --sight
 if inbounds(x,y) then
  local tle=mget(x,y)
  if mode=="sight" then
   return not fget(tle,2)
  else
   if not fget(tle,0) then
    if mode=="checkmobs" then
     return not getmob(x,y)
    end
    return true
   end
  end
 end
 return false
end

function inbounds(x,y)
 return not (x<0 or y<0 or x>15 or y>15)
end

function hitmob(atkm,defm,rawdmg)
 local dmg= atkm and atkm.atk or rawdmg
 
 --add curse/bless
 if defm.bless<0 then
  dmg*=2
 elseif defm.bless>0 then
  dmg=flr(dmg/2)
 elseif defm==p_mob and chance("▥",.1) then
 	addfloat("blocked",defm.x*8-16,defm.y*8,6)
 	return
 end
 defm.bless=0
 
 
 local def=defm.defmin+flr(rnd(defm.defmax-defm.defmin+1))
 dmg-=min(def,dmg)
 --dmg=max(0,dmg)
 
 defm.hp-=dmg
 defm.flash=10
 
 addfloat("-"..dmg,defm.x*8,defm.y*8,8)
 
 shake=defm==p_mob and 0.08 or 0.04
 
 if defm.hp<=0 then
  if defm!=p_mob then 
   st_kills+=1
   if st_kills>=50 then
   	achieve("ˇ")
   end
   if chance("ˇ",.1) then
   	healmob(p_mob,1)
   end
  	if chance("⌂",.25) then
   	ammo=min(ammo+1,mammo)
   end
  else
  	if atkm!=nil then
    st_killer=atkm.name
   end
  end

  add(dmob,defm)
  del(mob,defm)
  defm.dur=10
 end
end

function healmob(mb,hp)
 hp=min(mb.hpmax-mb.hp,hp)
 mb.hp+=hp
 mb.flash=10
 
 addfloat("+"..hp,mb.x*8,mb.y*8,11)
 sfx(51)
end

function stunmob(mb)
 mb.stun=true
 mb.flash=10
 addfloat("stun",mb.x*8-3,mb.y*8,7)
 sfx(51)
end

function blessmob(mb,val)
 mb.bless=mid(-1,1,mb.bless+val)
 mb.flash=10
 
 local txt="bless"
 if val<0 then txt="curse" end
 
 addfloat(txt,mb.x*8-6,mb.y*8,7)
 
 if mb.spec=="ghost" and val>0 then
  add(dmob,mb)
  del(mob,mb)
  mb.dur=10
  achieve("😐")
 end
 sfx(51)
end

function checkend()
 if win then
  music(24)
  gover_spr,gover_x,gover_w=112,15,13
  showgover()
  return false
 elseif p_mob.hp<=0 then
  music(22)  
  streak(false)
  gover_spr,gover_x,gover_w=80,28,9
  showgover()
  return false
 end
 return true
end

function showgover()
 wind,_upd,_drw={},update_gover,draw_gover
 fadeout(0.02)
end

function los(x1,y1,x2,y2)
 local frst,sx,sy,dx,dy=true
 --★
 if dist(x1,y1,x2,y2)==1 then return true end
 if y1>y2 then
  x1,x2,y1,y2=x2,x1,y2,y1
 end
 sy,dy=1,y2-y1

 if x1<x2 then
  sx,dx=1,x2-x1
 else
  sx,dx=-1,x1-x2
 end
 
 local err,e2=dx-dy
 
 while not(x1==x2 and y1==y2) do
  if not frst and iswalkable(x1,y1,"sight")==false then return false end
  e2,frst=err+err,false
  if e2>-dy then
   err-=dy
   x1+=sx
  end
  if e2<dx then 
   err+=dx
   y1+=sy
  end
 end
 return true 
end

function unfog()
 local px,py=p_mob.x,p_mob.y
 for x=0,15 do
  for y=0,15 do 
   --★
   if fog[x][y]==1 and dist(px,py,x,y)<=p_mob.los and los(px,py,x,y) then
    unfogtile(x,y)
   end
  end
 end
end

function unfogtile(x,y)
 fog[x][y]=0
 if iswalkable(x,y,"sight") then
  for i=1,4 do
   local tx,ty=x+dirx[i],y+diry[i]
   if inbounds(tx,ty) and not iswalkable(tx,ty) then
    fog[tx][ty]=0
   end
  end  
 end
end

function calcdist(tx,ty)
 local cand,step,candnew={},0
 distmap=blankmap(-1)
 add(cand,{x=tx,y=ty})
 distmap[tx][ty]=0
 repeat
  step+=1
  candnew={} 
  for c in all(cand) do
   for d=1,4 do
    local dx=c.x+dirx[d]
    local dy=c.y+diry[d]
    if inbounds(dx,dy) and distmap[dx][dy]==-1 then
     distmap[dx][dy]=step
     if iswalkable(dx,dy) then
      add(candnew,{x=dx,y=dy})
     end
    end
   end
  end
  cand=candnew
 until #cand==0
end

--function updatestats()
-- local atk,dmin,dmax=1,0,0
-- 
--
---- if eqp then
----  dmin+=itm_stat1[eqp]
----  dmax+=itm_stat2[eqp]
---- end
--
---- p_mob.atk=atk
-- p_mob.defmin=dmin
-- p_mob.defmax=dmax 
--end

function eat(itm,mb)
 local effect=itm_stat1[itm]
 
 if not itm_known[itm] then
  showmsg(itm_name[itm]..itm_desc[itm],120)
  itm_known[itm]=true
 end  
 
 if mb==p_mob then 
 	st_meals+=1
 	if st_meals>30 then
	  achieve("⌂")
		end
 end
 
 if effect==1 then
  --heal
  healmob(mb,1)
 elseif effect==2 then
  --heal a lot
  healmob(mb,3)
 elseif effect==3 then
  --plus maxhp
  mb.hpmax+=1
  if p_mob.hpmax>=8 then
   achieve("♥")
  end
  healmob(mb,1)
 elseif effect==4 then
  --stun
  stunmob(mb)
 elseif effect==5 then
  --curse
  blessmob(mb,-1)
 elseif effect==6 then  
  --bless
  blessmob(mb,1)
 elseif effect==7 then
  local d=1
  if mb.spec=="poison" then
  	d=2
  end
 	hitmob(nil,mb,d) 	
	 if p_mob.hp<=0 then
  	st_killer="poison"
  end
 end
end

function bonk(tx,ty,slap)
	local mb=getmob(tx,ty)
	local tle=mget(tx,ty)
	if mb then
		hitmob(nil,mb,rdmg)
	elseif fget(tle,5) then
		if hasperk("∧") or slap then
 		trig_bump(tle,tx,ty)
		end
	end
end

function spbonk(tx,ty,slap)
	for i=1,4 do
	 bonk(tx+dirx[i],ty+diry[i],slap)
	end
end

function throw()
 local itm,tx,ty=inv[thrslt],throwtile()
 sfx(52)

 if inbounds(tx,ty) then
  local mb=getmob(tx,ty)
  if thrslt==-1 and ammo>0 then
--   stop()
			local tle=mget(tx,ty)
			
			if mb then
				hitmob(nil,mb,slap and p_mob.atk or rdmg)
			elseif fget(tle,7) then
--				stop()
				if hasperk("∧") then
 				trig_bump(tle,tx,ty)
 			end
			end
			if not(chance("♪",.15)) then
			 ammo-=1
			end
			if hasperk("★") then
				spbonk(tx,ty)
			end
  else
  if mb then
   if itm_type[itm]=="fud" then
    eat(itm,mb)
   else
    hitmob(nil,mb,itm_stat1[itm])
    sfx(58)
   end
  end
  end
 end
 mobbump(p_mob,thrdx,thrdy)
 
 inv[thrslt]=nil
 p_t=0
 _upd=update_pturn
end

function throwtile()
 local tx,ty=p_mob.x,p_mob.y
 repeat
  tx+=thrdx
  ty+=thrdy
 until not iswalkable(tx,ty,"checkmobs")
 return tx,ty
end
-->8
--ui

function addwind(_x,_y,_w,_h,_txt)
 local w={x=_x,
          y=_y,
          w=_w,
          h=_h,
          txt=_txt}
 add(wind,w)
 return w
end

function drawind()
 for w in all(wind) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill2(wx,wy,ww,wh,0)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,6)
  wx+=4
  wy+=4
  clip(wx,wy,ww-8,wh-8)
  if w.cur then
   wx+=6
  end
  for i=1,#w.txt do
   local txt,c=w.txt[i],6
   if w.col and w.col[i] then
    c=w.col[i]
   end
   print(txt,wx,wy,c)
   if i==w.cur then
    spr(255,wx-5+sin(time()),wy)
   end
   wy+=6
  end
  clip()
 
  if w.dur then
   w.dur-=1
   if w.dur<=0 then
    local dif=w.h/4
    w.y+=dif/2
    w.h-=dif
    if w.h<3 then
     del(wind,w)
    end
   end
  else
   if w.butt then
    oprint8("❎",wx+ww-15,wy-1+sin(time()),6,0)
   end
  end
 end
end

function showmsg(txt,dur)
 local wid=(#txt+2)*4+7
 local w=addwind(63-wid/2,40,wid,13,{" "..txt})
 w.dur=dur
end

function showtalk(txt)
 talkwind=addwind(16,50,94,#txt*6+7,txt)
 talkwind.butt=true
-- 	debug=talkwind.txt

end

function addfloat(_txt,_x,_y,_c)
 add(float,{txt=_txt,x=_x,y=_y,c=_c,ty=_y-10,t=0})
end

function dofloats()
 for f in all(float) do
  f.y+=(f.ty-f.y)/10
  f.t+=1
  if f.t>70 then
   del(float,f)
  end
 end
end

function dohpwind()
 hpwind.txt[1]="♥"..p_mob.hp.."/"..p_mob.hpmax
 hpwind.txt[2]="●"..ammo.."/"..mammo
 local hpy=5
 if p_mob.y<8 then
  hpy=110
 end
 hpwind.y+=(hpy-hpwind.y)/5
end

function showinv()
 local txt,col,itm,eqt={},{}
 _upd=update_inv
 
 add(txt,"gun")
 add(col,6)
 

 add(txt,"………………")
 add(col,5)
 for i=1,6 do
  itm=inv[i]
  if itm then
   add(txt,itm_name[itm])
   add(col,6)
  else
   add(txt,"...")
   add(col,5)
  end
 end
 

 invwind=addwind(5,17,84,58,txt)
 invwind.cur=2
 invwind.col=col


 txt="  ok  "
 if p_mob.bless<0 then
  txt="curse "
 elseif p_mob.bless>0 then
  txt="bless "
 end
   
 statwind=addwind(5,5,92,13,{txt.."m:"..p_mob.atk.." r:"..rdmg.." def:"..p_mob.defmin.."-"..p_mob.defmax})
	pwind=addwind(90,18,16,70,myperks)
 curwind=invwind
end

function showuse()
 local itm=inv[invwind.cur-2]
 if itm==nil and invwind.cur!=1 then return end
 local typ,txt=itm_type[itm],{}
 
 if invwind.cur==1 then
 	typ="gun"
 end
 
-- if typ=="arm" and invwind.cur>3 then
--  add(txt,"equip")
-- end
 if typ=="fud" then
  add(txt,"eat")
 end
 if typ=="thr" or typ=="fud" then
  add(txt,"throw")
 elseif typ=="tor" then
 	add(txt,"light")
 elseif typ=="clp" then
 	add(txt,"reload")
 elseif typ=="gun"  then
 	add(txt,"shoot")
 end
-- stop(typ)
 if typ!="gun" then
  add(txt,"trash")
 end

 usewind=addwind(84,invwind.cur*6+11,36,7+#txt*6,txt)
 usewind.cur=1
 curwind=usewind 
end

function triguse()
 local verb,i,back=usewind.txt[usewind.cur],invwind.cur,true
 local itm=i==2 and eqp or inv[i-2]
 
 if verb!="trash" and itm!=nil then
 	itm_use[itm]+=1
 	if itm_use[12]>=3 then
 		achieve("█")
 	elseif itm_use[13]>=3 then
 		achieve("●")
		end
 end
 
 if verb=="trash" then
--  if i==2 then
--   eqp=nil
--  else
   inv[i-2]=nil
--  end
-- elseif verb=="equip" then
--  inv[i-]=eqp
--  eqp=itm
 elseif verb=="light" then
 	fog,inv[i-2],back=blankmap(0),nil,true
 	
 elseif verb=="reload" then
 	ammo,inv[i-2]=min(ammo+5,mammo),nil
 	
 elseif verb=="eat" then
  eat(itm,p_mob)
  _upd,inv[i-2],p_mob.mov,p_t,back=update_pturn,nil,nil,0,false
 elseif verb=="throw" or verb=="shoot" then
  _upd,thrslt,back=update_throw,i-2,false
 end
 
-- updatestats()
 usewind.dur=0
 
 if back then
  del(wind,invwind)
  del(wind,statwind)
  del(wind,pwind)
  showinv()
  invwind.cur=i
  showhint()
 else
  invwind.dur=0
  statwind.dur=0
  pwind.dur=0
  if hintwind then
   hintwind.dur=0
  end
 end
end

function floormsg()
 showmsg("floor "..floor,120)
end

function showhint()
 if hintwind then
  hintwind.dur=0
  hintwind=nil
 end
 
 if invwind.cur>2 then
  local itm=inv[invwind.cur-2]
  
  local txt=nil
  if itm and itm_type[itm]=="fud" then
   txt=itm_known[itm] and itm_name[itm]..itm_desc[itm] or "???"
--   hintwind=addwind(5,78,#txt*4+7,13,{txt})
  elseif itm then
   txt=itm_desc[itm]
   
  end
  if txt!=nil then
  	hintwind=addwind(5,78,#txt*4+7,13,{txt})
 	end
 end
 
end

function perkwin()
	local p1,p2=0,0
	
	repeat
		p1,p2=getrnd(alperks),getrnd(alperks)
	until p1!=p2
	
	p1=p1.." "..perkdsc[findperk(p1)]
	p2=p2.." "..perkdsc[findperk(p2)]
	
	showtalk({"choose a perk",p1,p2})
	talkwind.cur=2
	curwind=talkwind
end
-->8
--mobs and items

function addmob(typ,mx,my)
 local m={
  x=mx,
  y=my,
  ox=0,
  oy=0,
  flp=false,
  ani={},
  flash=0,
  stun=false,
  bless=0,
  charge=1,
  lastmoved=false,
  spec=mob_spec[typ],
  hp=mob_hp[typ],
  hpmax=mob_hp[typ],
  atk=mob_atk[typ],
  defmin=0,
  defmax=0,
--  los=mob_los[typ],
  los=4,
  task=ai_wait,
  name=mob_name[typ]
 }
 for i=0,3 do
  add(m.ani,mob_ani[typ]+i)
 end
 add(mob,m)
 return m
end

function mobwalk(mb,dx,dy)
 mb.x+=dx --?
 mb.y+=dy

 mobflip(mb,dx)
 mb.sox,mb.soy=-dx*8,-dy*8
 mb.ox,mb.oy=mb.sox,mb.soy
 mb.mov=mov_walk
end

function mobbump(mb,dx,dy)
 mobflip(mb,dx)
 mb.sox,mb.soy=dx*8,dy*8
 mb.ox,mb.oy=0,0
 mb.mov=mov_bump
end

function mobflip(mb,dx)
 mb.flp = dx==0 and mb.flp or dx<0
end


function mov_walk(self)
 local tme=1-p_t 
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function mov_bump(self)
 --★ 
 local tme= p_t>0.5 and 1-p_t or p_t
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function doai()
 local moving=false
 for m in all(mob) do
  if m!=p_mob then
   m.mov=nil
   if m.stun then
    m.stun=false
   else
    m.lastmoved=m.task(m)
    moving=m.lastmoved or moving
   end
  end
 end
 if moving then
  _upd=update_aiturn
  p_t=0
 else
  p_mob.stun=false
 end
end

function ai_wait(m)
 if cansee(m,p_mob) then
  --aggro
  m.task=ai_attac
  m.tx,m.ty=p_mob.x,p_mob.y
  addfloat("!",m.x*8+2,m.y*8,8)
 end
 return false
end

function ai_attac(m)  
 if dist(m.x,m.y,p_mob.x,p_mob.y)==1 then
  --attack player
  local dx,dy=p_mob.x-m.x,p_mob.y-m.y
  mobbump(m,dx,dy)
  if m.spec=="stun" and m.charge>0 then
   stunmob(p_mob)
   m.charge-=1
  elseif m.spec=="ghost" and m.charge>0 then
   hitmob(m,p_mob)
   blessmob(p_mob,-1)
   m.charge-=1   
  else
   hitmob(m,p_mob)
  end
  sfx(57)
  return true
 else
  --move to player
  if cansee(m,p_mob) then
   m.tx,m.ty=p_mob.x,p_mob.y
  end
  
  if m.x==m.tx and m.y==m.ty then
   --de aggro
   m.task=ai_wait
   addfloat("?",m.x*8+2,m.y*8,12)
  else
   if m.spec=="slow" and m.lastmoved then
    return false
   end
   local bdst,cand=999,{}
   calcdist(m.tx,m.ty)
   for i=1,4 do
    local dx,dy=dirx[i],diry[i]
    local tx,ty=m.x+dx,m.y+dy
    if iswalkable(tx,ty,"checkmobs") then
     local dst=distmap[tx][ty]
     if dst<bdst then
      cand={}
      bdst=dst
     end
     if dst==bdst then
      add(cand,i)
     end
    end
   end
   if #cand>0 then
    local c=getrnd(cand)
    mobwalk(m,dirx[c],diry[c])
    return true
   end 
   --todo: re-aquire target?
  end
 end
 return false
end

function cansee(m1,m2)
 return dist(m1.x,m1.y,m2.x,m2.y)<=m1.los and los(m1.x,m1.y,m2.x,m2.y)
end

function spawnmobs()
 
 mobpool={}
 for i=2,#mob_name do
  if (mob_minf[i]<=floor and mob_maxf[i]>=floor) or floor==winfloor-1 then
   add(mobpool,i)
  end
 end
 
 if #mobpool==0 then return end
 
 local minmons=explodeval("3,5,7,9,10,11,12,13")
 local maxmons=explodeval("6,10,14,18,20,22,24,26")
 
 local placed,rpot=0,{}
 
 for r in all(rooms) do
  add(rpot,r)
 end
 
 repeat
  local r=getrnd(rpot)
  placed+=infestroom(r)
  del(rpot,r)
 until #rpot==0 or placed>maxmons[floor]
 
 if placed<minmons[floor] then
  repeat
   local x,y
   repeat
    x,y=flr(rnd(16)),flr(rnd(16))
   until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
   addmob(getrnd(mobpool),x,y)
   placed+=1
  until placed>=minmons[floor]
 end
end

function infestroom(r)
 if r.nospawn then return 0 end
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
  addmob(getrnd(mobpool),x,y)
 end
 return target
end

-------------------------
-- items
-------------------------

function takeitem(itm)
 local i=freeinvslot()
 if i==0 then return false end
 inv[i]=itm
 return true
end

function freeinvslot()
 for i=1,6 do
  if not inv[i] then
   return i
  end
 end
 return 0
end

function makeipool()
-- ipool_rar={}
 ipool_com={}
 
 for i=1,#itm_name do
  local t=itm_type[i]
--  if t=="arm" then
--   add(ipool_rar,i)
--  else
   add(ipool_com,i)  
--  end
 end
end

function makefipool()
-- fipool_rar={}
 fipool_com={}
 
-- for i in all(ipool_rar) do
--  if itm_minf[i]<=floor
--   and itm_maxf[i]>=floor then
--   add(fipool_rar,i)
--  end
-- end
 for i in all(ipool_com) do
  if itm_minf[i]<=floor 
   and itm_maxf[i]>=floor then
   add(fipool_com,i)
  end
 end
end

--function getitm_rar()
-- if #fipool_rar>0 then
--  local itm=getrnd(fipool_rar)
--  del(fipool_rar,itm)
--  del(ipool_rar,itm)
--  return itm
-- else
--  return getrnd(fipool_com)
-- end
--end

function foodnames()
 local fud,fu=explode("potion,meat,flask,fruit,fungus,weeds,berries,chicken,mushroom,bottle,vial,food,cheese,bread")
 local adj,ad=explode("strange,red,blue,green,yellow,purple,orange,glowing,creepy,moldy,slimey,suspicious,cold,hot,hypnotic,mysterious,generic,ordinry") 

 itm_known={}
 for i=1,#itm_name do
  if itm_type[i]=="fud" then
   fu,ad=getrnd(fud),getrnd(adj)
   del(fud,fu)
   del(adj,ad)
   itm_name[i]=ad.." "..fu
   itm_known[i]=false
  end
 end
end
-->8
--gen

function genfloor(f)
 floor=f
 makefipool()
 mob={}
 add(mob,p_mob)
 fog=blankmap(0)
 if floor==1 then 
  st_steps=0
  poke(0x3101,66)
 end
 if floor==0 then  
  copymap(16,0)
 elseif floor==winfloor-1 then
 	copymap(64,0)
 	addmob(8,1,1)
 	addmob(8,1,14)
 	addmob(8,14,1)
 	addmob(8,14,14)
 	
 elseif floor==winfloor then
  copymap(32,0)
 else
  fog=blankmap(1)
  mapgen()
  
  if hasperk("█") then
  for x=0,15 do
  	for y=0,15 do
  		if fget(mget(x,y),6) then
  			unfogtile(x,y)
				end
			end
  end
  end
  
  
  unfog()
 end
  vases()

end


function mapgen()
 
 --todo
 --entry not in an alcove? 
	
 repeat
  copymap(48,0)
  rooms={}
  roomap=blankmap(0)
  doors={}
  genrooms()
  mazeworm() 
  placeflags()
  carvedoors()
 until #flaglib==1
 
 carvescuts()
 startend()
 fillends()
 prettywalls()

 installdoors()
 
 spawnchests()
 spawnmobs()
 decorooms()
end

----------------
-- rooms
----------------

function genrooms()
 -- tweak dis
 local fmax,rmax=5,4 --5,4?
 local mw,mh=10,10 --5,5?
 
 repeat
  local r=rndroom(mw,mh)
  if placeroom(r) then
   if #rooms==1 then
    mw/=2
    mh/=2
   end
   rmax-=1
  else
   fmax-=1
   --★
   if r.w>r.h then
    mw=max(mw-1,3)
   else
    mh=max(mh-1,3)
   end
  end
 until fmax<=0 or rmax<=0
end

function rndroom(mw,mh)
 --clamp max area
 local _w=3+flr(rnd(mw-2))
 mh=mid(35/_w,3,mh)
 local _h=3+flr(rnd(mh-2))
 return {
  x=0,
  y=0,
  w=_w,
  h=_h
 }
end

function placeroom(r)
 local cand,c={}
 
 for _x=0,16-r.w do
  for _y=0,16-r.h do
   if doesroomfit(r,_x,_y) then
    add(cand,{x=_x,y=_y})
   end
  end
 end
 
 if #cand==0 then return false end
 
 c=getrnd(cand)
 r.x=c.x
 r.y=c.y
 add(rooms,r) 
 for _x=0,r.w-1 do
  for _y=0,r.h-1 do
   mset(_x+r.x,_y+r.y,1)
   roomap[_x+r.x][_y+r.y]=#rooms
  end
 end
 return true
end

function doesroomfit(r,x,y)
 for _x=-1,r.w do
  for _y=-1,r.h do
   if iswalkable(_x+x,_y+y) then
    return false
   end
  end
 end
 
 return true
end

----------------
-- maze
----------------

function mazeworm()
 repeat
  local cand={}
  for _x=0,15 do
   for _y=0,15 do
    if cancarve(_x,_y,false) and not nexttoroom(_x,_y) then
     add(cand,{x=_x,y=_y})
    end
   end
  end
 
  if #cand>0 then
   local c=getrnd(cand)
   digworm(c.x,c.y)
  end
 until #cand<=1
end

function digworm(x,y)
 local dr,stp=1+flr(rnd(4)),0
 
 repeat
  mset(x,y,1)
  if not cancarve(x+dirx[dr],y+diry[dr],false) or (rnd()<0.5 and stp>2) then
   stp=0
   local cand={}
   for i=1,4 do
    if cancarve(x+dirx[i],y+diry[i],false) then
     add(cand,i)
    end
   end
   if #cand==0 then
    dr=8
   else
    dr=getrnd(cand)
   end
  end
  x+=dirx[dr]
  y+=diry[dr]
  stp+=1
 until dr==8 
end

function cancarve(x,y,walk)
 if not inbounds(x,y) then return false end
 local walk= walk==nil and iswalkable(x,y) or walk
 
 if iswalkable(x,y)==walk then
  return sigarray(getsig(x,y),crv_sig,crv_msk)!=0
 end
 return false
end

function bcomp(sig,match,mask)
 local mask=mask and mask or 0
 return bor(sig,mask)==bor(match,mask)
end

function getsig(x,y)
 local sig,digit=0
 for i=1,8 do
  local dx,dy=x+dirx[i],y+diry[i]
  --★
  if iswalkable(dx,dy) then
   digit=0
  else
   digit=1
  end
  sig=bor(sig,shl(digit,8-i))
 end
 return sig
end

function sigarray(sig,arr,marr)
 for i=1,#arr do
  if bcomp(sig,arr[i],marr[i]) then 
   return i
  end
 end
 return 0
end


----------------
-- doorways
----------------

function placeflags()
 local curf=1
 flags,flaglib=blankmap(0),{}
 for _x=0,15 do
  for _y=0,15 do
   if iswalkable(_x,_y) and flags[_x][_y]==0 then
    growflag(_x,_y,curf)
    add(flaglib,curf)
    curf+=1
   end
  end
 end
end

function growflag(_x,_y,flg)
 local cand,candnew={{x=_x,y=_y}}
 flags[_x][_y]=flg
 repeat
  candnew={}
  for c in all(cand) do
   for d=1,4 do
    local dx,dy=c.x+dirx[d],c.y+diry[d]
    if iswalkable(dx,dy) and flags[dx][dy]!=flg then
     flags[dx][dy]=flg
     add(candnew,{x=dx,y=dy})
    end
   end
  end
  cand=candnew
 until #cand==0
end

function carvedoors()
 local x1,y1,x2,y2,found,_f1,_f2,drs=1,1,1,1
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     _f1=flags[x1][y1]
     _f2=flags[x2][y2]
     if found and _f1!=_f2 then
      add(drs,{x=_x,y=_y,f1=_f1,f2=_f2})
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   --★
   add(doors,d)
   mset(d.x,d.y,1)
   growflag(d.x,d.y,d.f1)
   del(flaglib,d.f2)
  end
 until #drs==0
end

function carvescuts()
 local x1,y1,x2,y2,cut,found,drs=1,1,1,1,0
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     if found then
      calcdist(x1,y1)
      if distmap[x2][y2]>20 then
       add(drs,{x=_x,y=_y})
      end
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   add(doors,d)
   mset(d.x,d.y,1)
   cut+=1
  end
 until #drs==0 or cut>=3
end

function fillends()
 local filled,tle
 repeat
  filled=false
  for _x=0,15 do
   for _y=0,15 do
    tle=mget(_x,_y)
    --★
    if cancarve(_x,_y,true) and tle!=14 and tle!=15 then
     filled=true
     mset(_x,_y,2)
    end
   end
  end
 until not filled
end

function isdoor(x,y)
 local sig=getsig(x,y)
 if bcomp(sig,0b11000000,0b00001111) or bcomp(sig,0b00110000,0b00001111) then
  return nexttoroom(x,y)
 end
 return false
end

function nexttoroom(x,y,dirs)
 local dirs = dirs or 4
 for i=1,dirs do
  if inbounds(x+dirx[i],y+diry[i]) and 
     roomap[x+dirx[i]][y+diry[i]]!=0 then
   return true
  end
 end
 return false
end

function installdoors()
 for d in all(doors) do
  local dx,dy=d.x,d.y
  if (mget(dx,dy)==1 
   or mget(dx,dy)==4)
   and isdoor(dx,dy) 
   and not next2tile(dx,dy,13) then
   
   mset(dx,dy,13)
  end
 end
end

----------------
-- decoration
----------------

function startend()
 local high,low,px,py,ex,ey=0,9999
 repeat
  px,py=flr(rnd(16)),flr(rnd(16))
 until iswalkable(px,py)
 calcdist(px,py)
 --★
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if iswalkable(x,y) and tmp>high then
    px,py,high=x,y,tmp
   end
  end
 end 
 calcdist(px,py)
 high=0
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>high and cancarve(x,y) then
    ex,ey,high=x,y,tmp
   end
  end
 end
-- mset(ex,ey,8)
 
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 then
    local score=starscore(x,y)
    tmp=tmp-score
    if tmp<low and score>=0 then
     px,py,low=x,y,tmp
    end
   end
  end
 end
 
 if roomap[px][py]>0 then
  rooms[roomap[px][py]].nospawn=true
 end
 mset(px,py,15)
 p_mob.x,p_mob.y=px,py
end

function starscore(x,y)
 if roomap[x][y]==0 then
  if nexttoroom(x,y,8) then return -1 end
  if freestanding(x,y)>0 then
   return 5
  else
   if (cancarve(x,y)) return 0
  end
 else
  local scr=freestanding(x,y)
  if scr>0 then
   return scr<=8 and 3 or 0
  end
 end
 return -1
end

function next2tile(_x,_y,tle)
 for i=1,4 do
  if inbounds(_x+dirx[i],_y+diry[i]) and mget(_x+dirx[i],_y+diry[i])==tle then
   return true
  end
 end
 return false
end

function prettywalls()
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==2 then
    local ntle=sigarray(getsig(x,y),wall_sig,wall_msk)
    tle = ntle==0 and 3 or 15+ntle
    mset(x,y,tle)
   elseif tle==1 then
    if not iswalkable(x,y-1) then
     mset(x,y,4)
    end
   end
  end
 end
end

function decorooms()
 tarr_dirt=explodeval("1,74,75,76")
 tarr_farn=explodeval("1,70,70,70,71,71,71,72,73,74")
 tarr_vase=explodeval("1,1,7,8,89,90,91,92,105,106,107,108")
 local funcs,func,rpot={
  deco_dirt,
  deco_torch,
  deco_carpet,
  deco_farn,
  deco_vase
 },deco_vase,{}

 for r in all(rooms) do
  add(rpot,r)
 end

 repeat
  local r=getrnd(rpot)
  del(rpot,r)
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  func=getrnd(funcs)
 until #rpot==0
end

function deco_torch(r,tx,ty,x,y)
 if rnd(3)>1 and y%2==1 and not next2tile(tx,ty,13) then
  if x==0 then
   mset(tx,ty,64)
  elseif x==r.w-1 then
   mset(tx,ty,66)
  end
 end
end

function deco_carpet(r,tx,ty,x,y)
 deco_torch(r,tx,ty,x,y)
 if x>0 and y>0 and x<r.w-1 and y<r.h-1 then
  mset(tx,ty,68)
 end
end

function deco_dirt(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_dirt))
end

function deco_farn(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_farn))
end

function deco_vase(r,tx,ty,x,y)
 if iswalkable(tx,ty,"checkmobs") and 
    not next2tile(tx,ty,13) and
    not bcomp(getsig(tx,ty),0,0b00001111) then
   
  mset(tx,ty,getrnd(tarr_vase))
 end
end

function spawnchests()
 local chestdice,rpot,rare,place=explodeval("0,1,1,1,2,3"),{},true
 place=getrnd(chestdice)
 
 for r in all(rooms) do
  add(rpot,r)
 end
 
 while place>0 and #rpot>0 do
  local r=getrnd(rpot)
  placechest(r,rare)
  rare=rnd()<.25
  place-=1
  del(rpot,r)
 end
end

function placechest(r,rare)
 local x,y
 repeat
  x=r.x+flr(rnd(r.w-2))+1
  y=r.y+flr(rnd(r.h-2))+1
 until mget(x,y)==1
 mset(x,y,rare and 12 or 10)
end

function freestanding(x,y)
 return sigarray(getsig(x,y),free_sig,free_msk)
end
-->8
--perks

function takeperk(perk)
--	debug[1]=perk
--	stop(perk)
	if perk=="░" then rdmg+=1 end
	if perk=="…" then p_mob.atk+=1 end
	if perk=="▤" then p_mob.atk+=1 rdmg+=1 end
	if perk=="●" then mammo+=5 ammo+=5 end
	if perk=="♥" then p_mob.hpmax+=3 p_mob.hp+=3 end
	if perk=="☉" then p_mob.los+=2 end
	if perk=="웃" then 
		if p_mob.defmin<p_mob.defmax and rnd()<0.5 then
			p_mob.defmin+=1
		end
		p_mob.defmax+=1
	end
		
	add(myperks,perk)
	if contains(oneperks,perk) then
 	del(alperks,perk)
	end
	
	if p_mob.atk>=3 and rdmg>=4 then
		achieve("▤")
	end
	if p_mob.defmax>=3 then
		achieve("▥")
	end

end

function contains(arr,obj)
	if #arr<=0 then return false end
	for i=1,#arr do
		if arr[i]==obj then
			return true
		end
	end
	return false
end

function find(arr,obj)
		if #arr<=0 then return false end
	for i=1,#arr do
		if arr[i]==obj then
			return i
		end
	end
end

function hasperk(perk)
	return contains(myperks,perk)
end

function findperk(perk)
	
	return find(perks,perk)
end

function chance(perk,chance)
	return hasperk(perk) and rnd()<chance
end
-->8
--unlocks

cartdata("gameoff22_nostone")


function loaddata()
	if dget(0)==0 then
		dset(0,1)
	end
	for i=1,#unlockperks do
		if dget(i)==1 then
			add(perks,unlockperks[i])
			add(perkdsc,unlockdesc[i])
		end
	end
end


function achieve(a)
	local n=find(unlockperks,a)
	if dget(n)!=1 then
 	dset(n,1)
 	showmsg("unlocked:"..unlockperks[n].." ",120)
 	wind[#wind].y=100
 end
end

function perkdata()
	unlockperks=explode("♥,█,●,ˇ,▤,♪,∧,✽,★,◆,⌂,😐,▒,▥")
 unlockdesc=explode("+3 hp,map,+5 ammo, heal on kill,+1 all dmg,conserve ammo,shatter shots,spin attack,bullets burst,reload faster,gain ammo on kill,start blessed,free move chance,ignore some dmg")

 
 perks=explode("웃,☉,…,░")
 oneperks=explode("ˇ,☉,█,∧,★,✽,♪,◆")
 perkdsc=explode("+1 armor,+2 vision range,+1 melee dmg,+1 gun dmg")
 
 loaddata()
 mystreak=dget(63)
end

function streak(win)
	if win then
		mystreak+=1
	else
		mystreak=0
	end
	dset(63,mystreak)
end
-->8
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
__gfx__
000000000000000000000000000000000000000000000000aaaaaaaa009940000094400000000000000000000000000000999900505555050000000000000000
00000000000000006660ddd0000000006660555066605550aaaaaaaa0900040009000400066666600999999066666666909999090000000000dddd0000000000
007007000000000000000000000000000000000000000000a000000a090004000900040006000060090000906000000690999909504444050d5555d000555500
0007700000000000d05550dd00000000d06660ddd00000dd00aa0a0000994000909940400600006009099090600000069000000900444400d511115d05555550
000770000000000000000000000000000000000000000000a000000a09004400990044400666666009900990600000069009900950444405d100001d05555550
0070070000050000ddd06660000000000005000060000060a0a0aa0a099944000999440000000000000000006666666699900999004444000d0000d000555500
000000000000000000000000000000000000000000000000a000000a0094400000944000066666600444444000000000000000005044440500dddd0000000000
0000000000000000d06660550000000000000000506660ddaaaaaaaa000000000000000000000000000000006666666644444444000000000000000000000000
00000000000000000000000006666666666666600666666606666660666666606d5005d666666666000005d66d50000066666666000005d6666666666d5005d6
00000000000000000000000066dddddddddddd66666ddddd66dddd66ddddd6666d5005dddddddddd000005dddd500000dddddddd000005d6dddddddddd5005d6
0000000000000000000000006dd5555555555dd666d555556dd55dd655555d666d50005555555555000000555500000055555555000005d655555555550005d6
0000000000000000000000006d500000000005d66d5000006d5005d6000005d66d50000000000000000000000000000000000000000005d600000000000005d6
0000000000000000000000006d500000000005d66d5000006d5005d6000005d66d50000000000000000000000000000000000000000005d600000000000005d6
0000005555555555550000006d500000000005d66d5000556d5005d6550005d66d50005555000055550000555500005500000055550005d655000000000005d6
000005dddddddddddd5000006d500000000005d66d5005dd6d5005d6dd5005d66d5005dddd5005dddd5005dddd5005dd000005dddd5005d6dd500000000005d6
000005d6666666666d5000006d500000000005d66d5005d66d5005d66d5005d66d5005d66d5005d66d5005d66d5005d6000005d66d5005d66d500000000005d6
000005d6066666606d5000006d500000000005d6066666666d5005d6666666606d5005d66d5005d66d5005d66d5005d66d5005d66d5000006d500000000005d6
000005d666dddd666d5000006d500000000005d666dddddddd5005dddddddd66dd5005dddd5005d6dd5005dddd5005dd6d5005dddd5000006d500000000005dd
000005d66dd55dd66d5000006d500000000005d66dd555555500005555555dd655000055550005d655000055550000556d500055550000006d50000000000055
000005d66d5005d66d5000006d500000000005d66d50000000000000000005d600000000000005d600000000000000006d500000000000006d50000000000000
000005d66d5005d66d5000006d500000000005d66d50000000000000000005d600000000000005d600000000000000006d500000000000006d50000000000000
000005d66dd55dd66d5000006dd5555555555dd66dd555555500005555555dd655555555550005d600000055550000006d500000555555556d50005555555555
000005d666dddd666d50000066dddddddddddd6666dddddddd5005dddddddd66dddddddddd5005d6000005dddd5000006d500000dddddddd6d5005dddddddddd
000005d6066666606d5000000666666666666660066666666d5005d666666660666666666d5005d6000005d66d5000006d500000666666666d5005d666666666
000005d6666666666d500000666666666d5005d66d5005d66d5005d66d5005d6000005d66d500000000005d6000000006d5005d66d5000005055550588000088
000005dddddddddddd500000dddddddd6d5005d66d5005dd6d5005d6dd5005d6000005dddd500000000005dd00000000dd5005dddd5000000000000080000008
000000555555555555000000555555556d5005d66d5000556d5005d6550005d60000005555000000000000550000000055000055550000005000000500000000
000000000000000000000000000000006d5005d66d5000006d5005d6000005d60000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000006d5005d66d5000006d5005d6000005d60000000000000000000000000000000000000000000000005000000500000000
000000000000000000000000555555556d5005d666d555556dd55dd655555d665500000000000055000000555500005500000000550000000000000000000000
000000000000000000000000dddddddd6d5005d6666ddddd66dddd66ddddd666dd500000000005dd000005dddd5005dd00000000dd5000005000000580000008
000000000000000000000000666666666d5005d60666666606666660666666606d500000000005d6000005d66d5005d6000000006d5000000000000088000088
09000000000000000000090000000000000000000000000000000000000bb0000000000000000000000000000000000000000000000000000000000000000000
90000000090000000000009000000900101010106660555000300b00000000b00300003003030030005000000000004000900000000000000000000000000000
a9000000a9000000000009a0000009a00000000000000000000300000bb003000300003003000000000005000040099000000400000000000000000000000000
0000000000000000000000000000000010101010d06660dd0b030000bb3030000003000000003000000000000000000004000000000000000000000000000000
440000004400000000000440000004400000000000000000000030b0000030b00003030000003030000000000000000000099000000000000000000000000000
00050000000500000005000000050000101010101010101000b03000000300000303030003000030000500000099004000900400000000000000000000000000
40000000400000000000004000000040000000000000000000003000000300000300000003030030000000000994400000444000000000000aa9999000000000
00000000000000000000000000000000101010101010101000000000000000000000000000000000000000000000000000000000000000000aa9999000000000
c000000000000ccccccccccccccccccc0000000000cccccccccccccccccccc0000cccccc099400000094400000000000000000000000000aa000000990000000
c088880088880ccccccccccccccccccc08888888800ccccccccccccccccccc0880cccccc900040000900040000994000009440000000000aa000000990000000
c00880000880000000000000000000cc0088000088000000000000000000cc0880cccccc900040000900040009000400090004000000000aa000000990000000
cc0088008800888880088880088880ccc0880cc0088008888880888888800c0880cccccc099400009099404009000400090004000000000aa000000990000000
ccc008888008800088008800008800ccc0880ccc00880088008008800088000880cccccc9004400099004440009940009099404000000aa00aaaa99009900000
cccc0888808800c00880880cc0880cccc0880cccc088008800000880cc08800880cccccc9994400009994400090044009900444000000aa00aaaa99009900000
cccc008800880ccc0880880cc0880cccc0880cccc0880088880c0880cc08800880cccccc0944000000944000099944000999440000000aaaa000099999900000
ccccc08800880ccc0880880cc0880cccc0880ccc00880088000c0880cc08800880cccccc0000000000000000009440000094400000000aaaa000099999900000
ccccc088008800c00880880000880cccc0880cc00880008800000880cc08800880cccccc000000000000000000099400000944000000000aaaaaa99990000000
cccc0088000880008800088008800ccc0088000088000088008008800088000000cccccc000994000009440000900040009000400000000aaaaaa99990000000
cccc088880008888800c00888800cccc08888888800c08888880888888800c0880cccccc00900040009000400090004000900040000000000aa9999000000000
cccc000000c0000000ccc000000ccccc0000000000cc0000000000000000cc0000cccccc00900040009000400009940009099404000000000aa9999000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00099400090994040090044009900444000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00900440099004440099944000999440000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00999440009994400009440000094400000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00094400000944000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000
ccccccc0000ccccccccccccccccccccccc0000c00000ccc0000ccccc0000cccccccccccccccccccccccccccccccc0000cccccccc000000000000000000000000
ccccccc0bb0ccccccccccccccccccccccc0bb0c0bbb0ccc0bb0cccc00bb000cccccccccccccccccccccccccccccc0bb0cccccccc000000000000000000000000
ccccc000bb000ccccccccc0000cccccccc0bb000bbb0cc00bb0cccc0bbbbb0000000000c0000cccccccccccccc000bb000cccccc000000000000000000000000
ccccc0bbbbbb0ccccccccc0bb0cccccccc0bb00bbb00cc0bbb0ccc00bbbbbb00bbbbbb000bb0ccc0000ccccccc0bbbbbb0cccccc000000000000000000000000
c00000bbbbbb00000ccccc0bb0cccccccc00000bbb0c000bb000000bbb00bb00bbbbbbb00bb000c0bb0ccc00000bbbbbb00000cc000000000000000000000000
c0bbbbbbbbbbbbbb0ccccc0bb00cccccccccc00bb00c0bbbbbbbbb0bb000bb00bb000bb00bbbb0c0bb0ccc0bbbbbbbbbbbbbb0cc000000000000000000000000
c0bbbbbbbbbbbbbb0ccccc0bbb0cc0000c0000bbb0cc0bbbbbbbbb0bb00bbb00bb0c000000bbb000bb0ccc0bbbbbbbbbbbbbb0cc000000000000000000000000
c000bbbbbbbbbb000ccccc00bb00c0bb0c0bb0bbb0cc0000bbbbb00bb00bbb00bb0cccccc0bbbbbbbb0ccc000bbbbbbbbbb000cc000000000000000000000000
ccc0bbbbbbbbbb0cccccccc0bbb0c0bb0c0bb00bb0ccccc0bb00000bb0bbb000bb0cccccc000bbbbb00ccccc0bbbbbbbbbb0cccc000000000000000000000000
ccc0bb000000bb0cccccccc00bb000bb0c0bb00bb0000000bb0ccc0bbbbb00c0000cccccccc000bbb0cccccc0bb000000bb0cccc000000000000000000000000
ccc0bb0cccc0bb0ccccccccc0bbb0bbb0c0bb00bbb0bbb00bb0ccc0bbbb00ccccccccccccccc00bb00cccccc0bb0cccc0bb0cccc000000000000000000000000
ccc0000cccc0000ccccccccc00bb0bb00c0bb00bbbbbbb00000ccc00bb00cccccccccccccccc0bbb0ccccccc0000cccc0000cccc000000000000000000000000
ccccccccccccccccccccccccc0bbbbb0cc0bb0000bbb000cccccccc0000ccccccccccccccccc0bb00ccccccccccccccccccccccc000000000000000000000000
ccccccccccccccccccccccccc00bbb00cc0bb0cc00000ccccccccccccccccccccccccccccccc0bb0cccccccccccccccccccccccc000000000000000000000000
cccccccccccccccccccccccccc00000ccc0000cccccccccccccccccccccccccccccccccccccc0000cccccccccccccccccccccccc000000000000000000000000
c0000000000000ccc0cc0000000000cc00000000000ccc0000000000000000000000000000000000000000000000000000000000000000cc0000000000000000
00000000000000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000000000
00eeeeeeeeeee0000c0000e0eeeee0000eeee0eee0000000eeeeeee00eeeeee0eeeeeeee0000eeeeee0eeeeeee00eeeee0eee0ee0000e00c0000000000000000
000eeeeeeeeee0000000eee0eeeeeee000e000000eeee000000000000eeeee000eee0000000000000e0eeeeee000eeee00000000eee0000c0000000000000000
c00000eee0000ee0000000e00000eeee0000eee000eee00000eee0000eee0000000eee00ccc000eee0000eee0000eee0000000e0000e000c0000000000000000
cc0000ee0000000000ee0000000000eee000eee0000eee0000eee000e000000c000eee00cccc00eee00000000000ee000000e0e00000000c0000000000000000
cccc00e0000000000000000000000000e000eee000000e000000000000000cccc00eee00cccc00eee0000eee00ee0000cc00e0e00000000c0000000000000000
cccc00e000000e0e000000000000000000000000000ee00000eee0000000000000000000cccc00eee0000eee0eee000ccc00e0e0000000cc0000000000000000
cccc00e000000e000ee00000000ee00e000000000000000000000000000000000000000000000000e0000000000000cccc00e0ee0e000ccc0000000000000000
cccc00e000000e000e0e00000000000000000000000000000000000000ccccccc00eee00cc00000000000eeeee000ccccc00e0e000e00ccc0000000000000000
cccc000ee0e0e00000ee0000000000000000e0000000000000000000000000000000000000cc00eee0000eeeeee000cccc00e00000e00ccc0000000000000000
cccc000ee0ee00000eee0000000e000e0000000eeeee000c00e00ee000000ccc000eee00cccc00ee00000eeeeeee000ccc0000e0000000cc0000000000000000
cccc000ee00000000ee000000000000e000000e00eeee000000ee0eeee0000000000000000000000e000000000000000c000e0e00000000c0000000000000000
cccc000ee000000000000000000000eee00000000000000000eee00000000000000eee00c000000ee0000eee00eeee000c00ee000000e00c0000000000000000
ccc000e0e000000000000000000000eee000eee0000eeee0000000000eee000000000000000e00eee0000eee000ee0000000ee000000e00c0000000000000000
cc0000e0e0000ccc000eeee00000eeee0000eee00000eeee00eee000000000000000000000ee00000000000000000eee0000eee00000e00c0000000000000000
c000eeee000000cc0000eeeeeeeeeee0000eeeee00000eeeeeeeeee000eeeeee00eeeee000000eeeeee0eeeeee000eeee0000eeeeee0e00c0000000000000000
c00eeeeeeeee00cccc0000eeeeeee00000eeeeeee00000eeeeeeeeee0000eeee0eeeeeeeeeee0eeeeee0eeeeeee0000eeeeee000ee00e00c0000000000000000
c0000000000000ccccc000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000c0000000000000000
cc00000000000cccccccc000000000ccc000000000ccc000000000000cc000000000000000000000000000000000cc0000000000000000cc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
0000000000000000000000000000000000000a000000000000a000000000000000000000000b000b0000000000bb00bb00033b0000033b0000033b0000033b00
0000000000ccc000000000000000000000aa0090000aa0000900aa0000aa000000bb00bb000b000b00bb00bb0b000b00003b8b00003b8b00003b8b00003b8b00
00ccc0000c7ccc0000ccc0000000000000a99090a099a00009099a0000a990a00b000b0000b000b00b000b000b000b0003bbb00003bbb00003bbb03303bbb033
0c7ccc000c7cc1000c7ccc000cccccc009989900909800a000998990a008909000b3b0b000bb30b000b3b0b000b3b0b003bbb33303bbb33303bbb30303bbb303
c7ccccc00cccc100c7ccccc0c77ccccc9009890009899900009890090999890003c33b0b03333b0b0333cb0b03c3cb0b03bbb30300bb030303b0b30000bb0300
ccccc1100ccc1100ccccc110ccccccc1a0989000099890000009890a009899000333c30303c3c30303c3330b033c33035305b00005b00000530bb00005b00000
011111000011100001111100011111100098890000988900009889000988900003c33330033c33300333c3b00333333005505500005500000050550000550000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000999000000077000000000000000000000000000000000000000000000ddd000000000000e8880000e8880000e8888e00e88800
00999900000000000099990009900b000007777000007700000000000000770000000000000ddd0000dd5555000ddd00000e888e000e808e000e8088000e808e
099000b00099999b049000b00900000000070700000777700000770000077770000ddd0000dd555500d5550500dd555500e8888800e8888800e8880000e88888
044400000444000004440000044400000707777700070700000777700007070000dd555500d555050dd5555500d5550500080000000800000008000000080000
004444000044440000444400004444000777770707077777000707000707777700d555050dd555550d5555000dd5555500008200020082000000820002008200
0d0440dd0d0440dd0d0440dd0d0440dd007770000777770707077777077777070dd555550d5555000d5555550d55550000008820020088200000882002008820
0d0d0dd00d0d0dd00d0d0dd00d0d0dd0000000000077700007777707007770000d5555000d5555550d5505050d55555502288200008882000228820000888200
00000000000000000000000000000000000000000000000000777000000000000d5555550d5505050d5550000d55050500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d0d0000000000000d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000
000d0d0000dddd00000d0d0000dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000
00dddd00000e0eee00dddd00000e0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077700000
000e0eee000eeeee000e0eee000eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000
0d0eeeee00d00000000eeeee0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000
dd0000000dd0dd000dd00000dd0ddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd0ddd0e0dd0dd000dd0dd00dd0ddd0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e00e00000ee00000e00e00000ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
00004545004503a3a30123010327020045454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545000000000000000004040000000000010101000000000000000000a3a3a3a3010101000000000000000000a3a3a3a301030100000000000000000000000000000300
000000000000000000000000000000000000001038b0ffffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020203030303030303030303030303030303030303030303030303030303030303030202020202020202020202020202020210111111111111111111111111111112000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020f0101010d01010707020801c00e0203030303030303030303030303030303030000000000000000000000000000030202020202020202020202020202020220010808010108080808010108080122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010101070201010707020101c0c00203030303030303030303030303030303030000001011111111111200000000030202020202020202020202020202020220070101010101010101010101010822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010802080101010201010101020303031011113b113b11111203030303030000002002020202022200000000030202020202020202020202020202020220080108070108070808010708010822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010108020801010802070701010203030320020536083605022203030303030000002002050205022200000003030202020202020202020202020202020220010107070107080708010708010122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020101010102020d0202020202020d0203030320040402440204042203030303030000002004040404042200000003030202020202020202020202020202020220010101010101010101010101010122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02080101080201010102010d01010102030303204a01444444014b22030303030303000020014d4e4f012200000003030202020202020202020202020202020220080108080108080808010808010722000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0208010808020101010201020d020202030303204001440c44014322030303030303000020015d5e5f012200000003030202020202020202020202020202020220070108070107080f08010707010822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020d02020201c001020102c0c00802030303204801444444010122030303030303000020016d6e6f012200000000030202020202020202020202020202020220080107070108080807010808010822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010101010d0101010201020101010203030320070101010101082203030303030000002001010101012200000000030202020202020202020202020202020220070108080107070708010808010722000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d02020202020101010201020101010203030320080701010107072203030303030000003014010101133200000000030202020202020202020202020202020220010101010101010101010101010122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102020d02020201020101010203030330313114011331313203030303030000000020010f01220000000003030202020202020202020202020202020220010108080107070708010808010122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010101020101010102010d010a0102030303030303200f2203030303030303030000000030313131320000000003030202020202020202020202020202020220070108070108080708010807010822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010102010c01c0020102c001010203030303030330313203030303030303030000000000000000000000000000030202020202020202020202020202020220080101010101010101010101010722000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010d01c001010d01020101070203030303030303030303030303030303030000000000000000000000000000030202020202020202020202020202020220010708010108070708010108080122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020203030303030303030303030303030303030303030303030303030303030303030202020202020202020202020202020230313131313131313131313131313132000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011600000217502705021150200002135000000210402104021250000002105000000215500000000000211401175017050111500105011350010500105001050112500105001050010501135001000000000000
01160000215101d510195251a535215351d520195151a5152151221515215252252521525215150e51511515205141c510195251c535205351c520195151c5152051220515205252152520525205150d51510515
0116000000000215101d510195151a515215151d510195151a5152151221515215152251521515215150e51511515205141c510195151c515205151c510195151c5152051220515205152151520515205150d515
01160000150051d00515015150151a0251a0151d0151d015220252201521025210151d0251d0151502515015140201402214025140151400514004140050d000100140c0100d0201003014030150201401210015
011600000217502705021150200002135000000000000000021250000000000000000215500000000000211405175001050511500105051350010500105001050512500105001050010505135000000000000000
01160000215141d510195251a525215251d520195151a5152151221515215202252021525215150e52511515205141d5101852519525205251d520185151951520512205151c5201d52020525205151052511515
0116000000000215141d510195151a515215151d510195151a5152151221515215102251021515215150e51511515205141d5101851519515205151d510185151951520512205151c5101d510205152051510515
01160000000002000015015150151a0251a0151d0251d015220252201521015210151d0251d01526015260152502025012250152501518000000000000000000100000d02011030140401505014040190301d010
011600000717502005071150200007135000000000000000071250000000000000000715500000000000711403175001050311500105031350010500105001050312500105001050010503155000000000000000
01160000091750200509115020000913500000000000000009125000000000000000091550000000000091140a175001050a115001050a1250010504105001050a125001050910500105041350c1000912500100
01160000225121f5201a5251f515225251f5201a5151f515215122151222525215251f5251f5150e52513515225141f5101b5251f525225251f5201b5151f515215122151222525215251f5251f5150f52513515
01160000215141c510195251d515215251c520195151d5152151222510215201f51021512215150d52510515205141d5101a52516515205151d5201a5151651520522205151d515205251f5251d5151c52519515
0116000000000225121f5101a5151f515225151f5101a5151f515215122151222515215151f5151f5150e51513515225141f5101b5151f515225151f5101b5151f515215122151222515215151f5151f5150f515
0116000000000215141c510195151d515215151c510195151d5152151222510215101f51021510215150d51510515205141d5101a51516515205151d5101a5152051520510205151d515205151f5151d5151c515
01160000000000000022015220151f0251f0151a0151a01522025220151f0151f01519020190221a0251a0151f0201f0221f0151f01518000000000000000000000000f010130201603015030160321502013015
011600001902519015220252201521015210151c0251c015220252201521025210151c0221c0151d0251d01520020200222001520015110051a0151d015220152601226012280102601625010250122501025015
011600000217509035110150203502135090351101502104021250000002105000000212511035110150211401175080351001501035011350803510015001050112500105001050010501135100351001500000
0116000002175090351101502035021350903511015021040212500000021050000002155110351101502114051750c0351401505035051350c03514015001050512500105001050010505135140351401500000
01160000071750e0351601507035071350e0351601502104071250000002105000000715516035160150711403175160351301503035031351603513015001050312500105001050010503135160351601500000
0116000009175100351101509035091351003511015021040912500000021050000009155100350d015091140a17510035110150a0350a1351003511015001050a12500105001050010509135150350d01509020
0116000002215020451a7051a7050e70511705117050e7050e71511725117250e7250e53511535115450e12501215010451a6001a70001205012051a3001a2001071514725147251072510535155351554514515
0116000002215020451a7051a7050e70511705117050e7050e71511725117250e7250e53511535115450e12505215050451a6001a70001205012051a3001a2001171514725147251172511535195351954518515
0116000007215070451a7051a7050e70511705117050e705137151672516725137251353516535165451312503215030451a6001a70001205012051a3001a2001371516725167250d7250f535165351654513515
0116000009215090451a7051a7050e70511705117050e7050d715157251572510725115351653516545157250a2150a0451a6001a70001205012051a3001a2000e71510725117250e7250d5350e5351154510515
0116000021005210051d00515015150151a0151a0151d0151d015220152201521015210151d0151d01515015150151401014012140151401518000000000000000000100100c0100d01010010140101501014010
0116000000000000002000015015150151a0151a0151d0151d015220152201521015210151d0151a01526015260152501019015190151900518000000000000000000000000d0101101014010150101401019010
0116000000000000000000022015220151f0151f0151a0151a01522015220151f0151f01519010190121a0151a0151f0101f012130151300518000000000000000000000000f0101301016010150101601215010
01160000190051901519015220152201521015210151c0151c015220152201521015210151c0121c0151d0151d015200102001220015200051d0051a015220152901029012260102801628010280122801528005
01160000097140e720117300e730097250e7251173502735057240e725117350e735097450e7401174002740087400d740107200d720087350d7351072501725047240d725107250d725087350d7301074001740
01160000097240e720117300e730097450e745117350e735117240e725117350e735097450e740117400e740087400d740117200d720087350d735117250d725117240d725117250d725087350d730117400d740
011600000a7240e720137300e7300a7450e745137350e735137240e725137350e7350a7450e740137400e7400a7400f740137200f7200a7350f735137250f725137240f725137250f7250a7350f730137400f740
0116000010724097201073009730107450974510735097351072409725107350973510745097401074009740117400e740117200e720117350e735117250e725117240e725117250e725097350d730107400d740
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0113000029700297002670026700257002570022700227000000026700217000e7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300000255011555165501555016555115550d5500a5500e5500e5520e5520e5521400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300001170015700197001a700117001670019700197001a7001a70025700257002570025700257002570025700197021970219702000000000000000000000000000000000000000000000000000000000000
001300000d2200c2200b220154000000000000000000000029720287302672626745287402173029720217322673026732267350210526702267020e705021050000000000000000000000000000000000000000
0113000000000000000000000000000000000000000000000e1100d1200a1300e1350d135091000a120091300e1220e1200e1200e1000e1020e10200000000000000000000000000000000000000000000000000
0113000000000000000000000000000000000000000000000a14300000000000a060090600a000090000900002072020720207202005020020200500000000000000000000000000000000000000000000000000
011200001b0001f0002200023000220001f0002000022000230002700023000200001f000200001f0001b0001f00022000200002200023000270001d000200001f0001f0001f0001f00000000000000000000000
011200001f5001f5001b5001b50022500225002350023500225002250020500205001f5001f500205002050022500225002350023500255002550023500235002250022500225002250000000000000000000000
01120000030000300003000130000700007000080000800008000170000b0000b0000a0000a0000a0000f00003000030000800008000080001100005000050000300003000030000300003000030000300000000
011200001e0201e0201e032210401a0401e0401f0301f0321f0301f0301e0201e0201f0201f020210302103022030220322902029020290222902228020280202602026020260222602200000000000000000000
011200001a7041a70415534155301a5321a5301c5401c5401c5451a540155401554516532165301a5301a5351f5401f54522544225402254222545215341f5301e5441e5401e5421e54500000000000000000000
01120000110250e000120351500015045150000e0550e00512045150051503515005130251500516035260051a0452100513045210051604526005100251f0050e0500e0520e0520e0500c000000000000000000
0002000031530315302d500315003b5303b5302e5000050031530315302e5002d50039530395302d5000050031530315303153031530315203152000500005000050000500005000050000500005000050000500
000100003101031010300102f0102d0202c0202a02028030270302503023050210501e0501d0501b05018050160501405012050120301103011010110100e0100b01007010000000000000000000000000000000
00010000240102e0202b0202602021010210101a01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000024010337203372033720277103a7103a71000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000096201163005620056150160000600006001160011600116001160001620006200a6100a6050a6000a6000f6000f6000f6000f6000060000600026100261002615016000160005600056000160001600
00010000145201a520015000150001500015000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000211102114015140271300f6300f6101c610196001761016600156100f6000c61009600076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001b61006540065401963018630116100e6100c610096100861000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001f5302b5302e5302e5303250032500395002751027510285102a510005000050000500275102951029510005000050000500005002451024510245102751029510005000050000500005000050000500
0001000024030240301c0301c0302a2302823025210212101e2101b2101b21016210112100d2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100020000200
0001000024030240301c0301c03039010390103a0103001030010300102d010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000210302703025040230301a030190100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000d720137200d7100c40031200312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00424344
01 00031843
00 04071947
00 080e1a4e
00 090f1b4f
00 10010243
00 11050647
00 120a0c4e
00 130b0d4f
00 001c0344
00 041d0744
00 081e0e44
00 091f0f44
00 00145c44
00 04155d44
00 08165e44
02 13175f44
00 41424344
00 41424344
00 41424344
00 41424344
00 68696744
04 2a2b2c44
00 6d6e6f44
04 30313244

