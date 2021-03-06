include graphics.e
include image.e
include font.e
include misc.e
include get.e
include file.e
include wildcard.e
include database.e

sequence image_player, map, item_list, event_list, image
atom temp_pos1, temp_pos2, money, mode, item_pos1, item_pos2, item_sel
atom key, line, row, screen_pos1, screen_pos2, player_line, player_row
object bitmap
bitmap=read_bitmap("player.bmp")
image_player=bitmap[2]
line=4
row=4 
player_line=4
player_row=4
screen_pos1=1
screen_pos2=1
item_list={}
event_list={}
image={}
temp_pos1=1
temp_pos2=1
money=0
mode=1
item_pos1=1
item_pos2=0
item_sel=1

if db_open("map", DB_LOCK_NO) != DB_OK then
  if db_create("map", DB_LOCK_NO) != DB_OK then
    puts(1,"err")
  end if
  if db_create_table("file") != DB_OK then
    puts(1,"err")
  end if
  if db_create_table("image") != DB_OK then
    puts(1,"err")
  end if
end if

if db_select_table("image") != DB_OK then
  puts(1,"err")
end if
for rec=1 to db_table_size() do
image=append(image,db_record_data(rec))
end for
if db_select_table("file") != DB_OK then
  puts(1,"err")
end if

function remove_line(sequence string, atom line)
sequence temp
temp={}
  for i=1 to length(string) do
     if i=line then
     else
     temp=append(temp,string[i])
     end if
  end for
return temp
end function

function transparent(sequence image, atom color)
 for i=1 to length(image) do
    for j=1 to length(image[i]) do
       if image[i][j]= color then
         image[i][j]=-1
       end if
    end for
 end for
return image
end function
image_player=transparent(image_player,WHITE)

if db_open("map", DB_LOCK_NO) != DB_OK then
  if db_create("map", DB_LOCK_NO) != DB_OK then
    puts(1,"err")
  end if
  if db_create_table("file") != DB_OK then
    puts(1,"err")
  end if
end if
if db_select_table("file") != DB_OK then
  puts(1,"err")
end if

procedure read_map(sequence key)
atom f
f = db_find_key(key)
if f >= 1 then
map=db_record_data(f)
end if
end procedure

read_map("gaz")--prompt_string("Enter Map? "))

procedure rectangle(atom x,atom y,atom xx,atom yy,atom color,atom sel)
polygon(color, sel, {{x, y}, {xx, y}, {xx, yy},{x,yy}})
end procedure

if graphics_mode(13) then
end if

procedure draw()
  for i=screen_pos2 to 9+screen_pos2  do
     for j=screen_pos1 to 15+screen_pos1 do
        if map[i][j][1]=0 then
          display_image({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},image[1])
        end if
        if map[i][j][1]=1 then
          display_image({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},image[2])
        end if
        if map[i][j][1]=2 then
          display_image({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},image[3])
        end if
        if map[i][j][1]=3 then
          display_image({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},image[4])
        end if
        if map[i][j][1]=4 then
          display_image({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},image[5])
         end if
        if map[i][j][2]>0 then
--        draw_text({(20*(j-screen_pos1+1))-20,(20*(i-screen_pos2+1))-20},sprint(map[i][j][2]),RED,-1,0)
        end if
     end for
  end for
end procedure

procedure draw_player()
for i=1 to length(image_player) do
   for j=1 to length(image_player[i]) do
      if image_player[i][j]=-1 then
      else
      pixel(image_player[i][j],{20*(player_row-screen_pos1+1)+j-20,20*(player_line-screen_pos2+1)+i-20})
      end if
   end for
end for
end procedure

procedure draw_pos()
draw()
draw_player()
end procedure

draw_pos()
draw_player()

procedure show_item_list()
  rectangle(50,50,270,130,14,1)
  rectangle(55,55,265,125,15,1)
  for i=item_pos1 to length(item_list)-item_pos2 do
     draw_text({60,46+16*(i-item_pos1+1)},item_list[i][1],1,15,0)
  end for
end procedure

procedure add_item(sequence item)
  item_list=append(item_list,item)
end procedure

procedure delete_item(sequence name)
  for i=1 to length(item_list) do
     if compare(item_list[i][1],name)=0 then
       item_list=remove_line(item_list,i)
     end if
  end for
end procedure

function item_exsits(sequence name)
  for i=1 to length(item_list) do
     if compare(item_list[i][1],name)=0 then
       return 1
     end if
  end for
return 0
end function

procedure show_msg(sequence msg)
atom len, number, number2
number=1
number2=0
len=length(msg)
if len>4 then
  number2=len-4
end if
key=-1
rectangle(50,50,270,130,14,1)
rectangle(55,55,265,125,15,1)
if number2>0 then
for j=1 to number2/4+2 do
  rectangle(55,55,265,125,15,1)
  for i=number to len-number2 do
  draw_text({60,46+16*(i-number+1)},msg[i],1,15,0)
  end for
number+=4
if number>len then
  number=len+1
end if
number2-=4
if number2<0 then
number2=0
end if
while 1 do
 key=get_key()
 if key!=-1 then
 if key=13 then
   exit
 end if
 end if
end while
end for
else
rectangle(55,55,265,125,15,1)
for i=number to len-number2 do
draw_text({60,46+16*(i-number+1)},msg[i],1,15,0)
end for
while 1 do
 key=get_key()
 if key!=-1 then
 if key=13 then
   exit
 end if
 end if
end while
end if
draw_pos()
key=-1
end procedure

for i=1 to 99 do
event_list=append(event_list,0)
end for

procedure event()
atom id
id=map[line][row][2]
if id=1 then
  show_msg({"This is my house i have ",
            "bin in my house for days  ",
            "iam going out for some  ",
            "air i think it migth be ",
            "a good ider to take a ",
            "walk to see the sites"})
end if
if id=2 then
  if event_list[id]=0 then
  if item_exsits("blue key")=1 then
    show_msg({"you open the door and",
              "you see a bag of money ",
              "floor thats all",
                "aaa"})
   delete_item("blue key")
   event_list[id]=1
   else
    show_msg({"the door is locked you",
              "need a blue key to open",
              "the door"})
   end if
   end if
end if
if id=3 then
    add_item({"blue key",0})
    show_msg({"you have found a blue",
              "key you pick it up"})
    map[line][row][1]=0
    map[line][row][2]=0
    draw_pos()
end if
end procedure

procedure move_player()
--grass
if map[line][row][1]=0 then
  player_line=line
  player_row=row
  draw_pos()
  if map[line][row][2]>0 then
    event()
  end if
--house
elsif map[line][row][1]=2 then
  player_line=line
  player_row=row
  draw_pos()
  if map[line][row][2]>0 then
    event()
  end if
-- blue key
elsif map[line][row][1]=4 then
  player_line=line
  player_row=row
  draw_pos()
  if map[line][row][2]>0 then
    event()
  end if
--tree
elsif map[line][row][1]=999 then
--water
elsif map[line][row][1]=999 then
else
row=player_row
line=player_line
screen_pos1=temp_pos1
screen_pos2=temp_pos2
end if
end procedure

while 1 do
key=get_key()
if key != -1 then
 if key=27 then
 exit
 end if

 if key=331 then
 if mode=1 then
   if row>1 then
   if row-screen_pos1=8 then
   temp_pos1=screen_pos1
   temp_pos2=screen_pos2
   screen_pos1-=1
   if screen_pos1<1 then
   screen_pos1=1
   end if
   row-=1
   move_player()
   else
   row-=1
   move_player()
   end if
   end if

 end if
 end if

 if key=333 then
 if mode=1 then
   if row<length(map[line]) then
   if row-screen_pos1=8 then
   temp_pos1=screen_pos1
   temp_pos2=screen_pos2
   screen_pos1+=1
   if screen_pos1>length(map[line])-16 then
   screen_pos1=length(map[line])-15
   end if
   row+=1
   move_player()
   else
   row+=1
   move_player()
   end if
   end if

 end if
 end if

 if key=328 then
 if mode=1 then
   if line>1 then
   if line-screen_pos2=5 then
   temp_pos2=screen_pos2
   temp_pos1=screen_pos1
   screen_pos2-=1
   if screen_pos2<1 then
   screen_pos2=1
   end if
   line-=1
   move_player()
   else
   line-=1
   move_player()
   end if
   end if

 end if
 end if

 if key=336 then
 if mode=1 then
   if line<length(map) then
   if line-screen_pos2=5 then
   temp_pos2=screen_pos2
   temp_pos1=screen_pos1
   screen_pos2+=1
   if screen_pos2>length(map)-10 then
   screen_pos2=length(map)-9
   end if
   line+=1
   move_player()
   else
   line+=1
   move_player()
   end if
   end if

 end if
 end if

end if
end while

if graphics_mode(18) then
end if
