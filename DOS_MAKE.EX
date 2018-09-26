without type_check
include graphics.e
include mouse2.e
include image.e
include font.e
include file.e
include get.e
include machine.e

atom key, listview_number, button_number, picview_number
sequence vc, listview_info, button_info, picview_info
if graphics_mode(18) then
end if
vc=video_config()
listview_info={}
button_info={}
picview_info={}
listview_number=0
button_number=0
picview_number=0
constant screen_width=vc[5]
constant screen_height=vc[6]

sequence string_number
string_number={"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37",
"38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62"}

function string(atom n)
if n>60 then
  puts(1,"wrong in string")
  abort(0)
end if
for i=0 to 60 do
   if i=n then
     return string_number[i+1]
   end if
end for
return "0"
end function

procedure rectangle(atom x,atom y,atom xx,atom yy,atom color,atom sel)
polygon(color, sel, {{x, y}, {xx, y}, {xx, yy},{x,yy}})
end procedure

function merge_sort(sequence x)
integer n, mid
sequence merged, a, b
n = length(x)
if n = 0 or n = 1 then
return x  -- trivial case
end if
mid = floor(n/2)
a = merge_sort(x[1..mid])       -- sort first half of x
b = merge_sort(x[mid+1..n])     -- sort second half of x
merged = {}
while length(a) > 0 and length(b) > 0 do
if compare(a[1], b[1]) < 0 then
merged = append(merged, a[1])
a = a[2..length(a)]
else
merged = append(merged, b[1])
b = b[2..length(b)]
end if
end while
return merged & a & b  -- merged data plus leftovers
end function

function create_ex(sequence string)
  if compare(string[1],"listview")=0 then
    listview_number+=1
    listview_info=append(listview_info,{string[2],string[3],string[4],0,1,0,string[5],1,0,0,listview_number})
    return listview_number
  end if
  if compare(string[1],"button")=0 then
    button_number+=1
    button_info=append(button_info,{string[2],string[3],string[4],0,1,0,button_number})
    return button_number
  end if
  if compare(string[1],"picview")=0 then
    picview_number+=1
    picview_info=append(picview_info,{string[2],string[3],string[4],1,1,string[5],picview_number})
    return picview_number
  end if
end function

function get_text(sequence string)
  if compare(string[1],"listview")=0 then
    for i=1 to length(listview_info) do
       if listview_info[i][11]=string[2] then
         if listview_info[i][10]=0 then
           return ""
         else
           return listview_info[i][7][listview_info[i][10]]
         end if
       end if
    end for
  end if
end function

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

procedure add_image(sequence string)
  if compare(string[1],"picview")=0 then
    for i=1 to length(picview_info) do
       if picview_info[i][7]=string[2] then
         picview_info[i][3]=append(picview_info[i][3],string[3])
         picview_info[i][6]=append(picview_info[i][6],string[4])
       end if
    end for
  end if
end procedure

function get_sel(sequence string)
  if compare(string[1],"picview")=0 then
    for i=1 to length(picview_info) do
       if picview_info[i][7]=string[2] then
         return picview_info[i][5]
       end if
    end for
  end if
end function

procedure set_sel(sequence string)
  if compare(string[1],"picview")=0 then
    for i=1 to length(picview_info) do
       if picview_info[i][7]=string[2] then
         picview_info[i][5]=string[3]
       end if
    end for
  end if
end procedure


procedure delete_image(sequence string)
  if compare(string[1],"picview")=0 then
    for i=1 to length(picview_info) do
       if picview_info[i][7]=string[2] then
         picview_info[i][3]=remove_line(picview_info[i][3],string[3])
         picview_info[i][6]=remove_line(picview_info[i][6],string[3])
       end if
    end for
  end if
end procedure

procedure delete(sequence string)
  if compare(string[1],"button")=0 then
    for i=1 to length(button_info) do
       if button_info[i][7]=string[2] then
         button_info=remove_line(button_info,i)
         exit
       end if
    end for
  end if
  if compare(string[1],"picview")=0 then
    for i=1 to length(picview_info) do
         if picview_info[i][7]=string[2] then
           picview_info=remove_line(picview_info,i)
         exit
       end if
    end for
  end if
  if compare(string[1],"listview")=0 then
    for i=1 to length(listview_info) do
       if listview_info[i][11]=string[2] then
         listview_info=remove_line(listview_info,i)
         exit
       end if
    end for
  end if

end procedure

global function if_sel(sequence string)
  if compare(string[1],"button")=0 then
    for i=1 to length(button_info) do
       if button_info[i][7]=string[2] then
         if button_info[i][6]=1 then
           button_info[i][6]=0
           return 1
         else
           return 0
         end if
       end if
    end for
  end if
end function

procedure draw_button()
atom x,y,width,init,sel
sequence name
  for i=1 to length(button_info) do
     name=button_info[i][1]
     x=button_info[i][2]
     y=button_info[i][3]
     width=length(name)
     init=button_info[i][5]
     sel=button_info[i][6]
     width+=2
     width=width*8
     if init=1 then
     rectangle(x,y,x+width,y+18,0,0)
     rectangle(x+1,y+1,x+width-1,y+17,GRAY,1)
     draw_text({x+8,y+1},name,BLACK,-1,0)
     init=0
     end if
     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+18 then
       rectangle(x+6,y+1,x+width-6,y+17,0,0)
     else
       rectangle(x+6,y+1,x+width-6,y+17,GRAY,0)
     end if
     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+18 and mouse_button=mb_left then
       sel=1
     end if
      button_info[i][5]=init
      button_info[i][6]=sel
  end for
end procedure

procedure listview()
atom x, y , width, height, number1, number2, init, color, can, sel
sequence string
  for i=1 to length(listview_info) do
     x=listview_info[i][1]
     y=listview_info[i][2]
     width=listview_info[i][3]
     height=100 --height
     number1=listview_info[i][5]
     number2=listview_info[i][6]
     string=listview_info[i][7]
     init=listview_info[i][8]
     can=listview_info[i][9]
     sel=listview_info[i][10]
     if init=1 then
       if length(string)>6 then
         number2=length(string)-6
         can=1
       end if
     -- box color white
     rectangle(x,y,x+width,y+height,7,1)
     -- out line color black
     rectangle(x,y,x+width,y+height,0,0)
       if can=1 then
         rectangle(x+width+1,y,x+width+10,y+height,GRAY,1)
         rectangle(x+width+1,y,x+width+10,y+10,0,1)
         rectangle(x+width+1,y+height-10,x+width+10,y+height,0,1)
       end if
       init=0
     end if
     --scrol text
     if mouse_x>x+width+1 and mouse_x<x+width+10 and mouse_y>y and mouse_y<y+10 and number1>1 and mouse_button=mb_left then
       rectangle(x+1,y+1,x+width-1,y+height-1,7,1)
       number1-=1
       number2+=1
     end if
     if mouse_x>x+width+1 and mouse_x<x+width+10 and mouse_y>y+height-10 and mouse_y<y+height and number2>0 and mouse_button=mb_left then
        rectangle(x+1,y+1,x+width-1,y+height-1,7,1)
        number1+=1
        number2-=1
     end if
     -- drawing text
     for j=number1 to length(string)-number2 do
        color=7
        if mouse_x>x and mouse_x<x+width and mouse_y>y+(16*(j-number1)) and mouse_y<y+(16*(j-number1))+16 and mouse_button=mb_left then
          sel=j
        end if
        if j=sel then
          color=1
        end if
        draw_text({x+2,y+2+(16*(j-number1))},string[j],BLACK,color,0)
     end for
     listview_info[i][5]=number1
     listview_info[i][6]=number2
     listview_info[i][8]=init
     listview_info[i][9]=can
     listview_info[i][10]=sel
  end for
end procedure

procedure picview()
atom x,y, init, number1, width, height
sequence image, name
for i=1 to length(picview_info) do
   width=40
   height=40
   x=picview_info[i][1]
   y=picview_info[i][2]
   image=picview_info[i][3]
   init=picview_info[i][4]
   number1=picview_info[i][5]
   name=picview_info[i][6]
   if init=1 then
     -- box color
     rectangle(x,y,x+width,y+height,7,1)
     -- out line color
     rectangle(x,y,x+width,y+height,0,0)
     --
     rectangle(x+width+1,y,x+width+10,y+height,GRAY,1)
     rectangle(x+width+1,y,x+width+10,y+10,0,1)
     rectangle(x+width+1,y+height-10,x+width+10,y+height,0,1)
     -- name window
     rectangle(x,y+height,x+width+50,y+height+22,0,0)
     init=0
   end if
   if mouse_x>x+width+1 and mouse_x<x+width+10 and mouse_y>y and mouse_y<y+10 and number1>1 and mouse_button=mb_left then
     rectangle(x+1,y+1,x+width-1,y+height-1,7,1)
     rectangle(x+1,y+height+2,x+width+49,y+height+21,7,1)
     number1-=1
   end if
   if mouse_x>x+width+1 and mouse_x<x+width+10 and mouse_y>y+height-10 and mouse_y<y+height and number1<length(image) and mouse_button=mb_left then
     rectangle(x+1,y+1,x+width-1,y+height-1,7,1)
     rectangle(x+1,y+height+2,x+width+49,y+height+21,7,1)
     number1+=1
   end if
   if length(image)>0 then
     display_image({x+4,y+4},image[number1])
     draw_text({x+3,y+height+4},name[number1],BLACK,7,0)
   end if
   picview_info[i][4]=init
   picview_info[i][5]=number1
end for
end procedure

procedure draw_window(atom x, atom y, atom width, atom height,atom color, sequence name)
     rectangle(x,y,x+width,y+height,BLACK,0)
     rectangle(x+1,y+1,x+width-1,y+18,BLUE,1)
     rectangle(x+1,y+19,x+width-1,y+height-1,color,1)
     draw_text({x+4,y+2},name,BLACK,-1,0)
end procedure

procedure draw_game_maker()
  draw_window(0,0,screen_width,screen_height,7,"dos game maker version 1 made by gaz")
end procedure

function get_file(sequence text, sequence name)
atom listview1, button1, button2
sequence d, line, temp, text2
atom test
temp={}
d=""
line=""
d = dir(current_dir())
for i=1 to length(d) do
  test= compare(d[i][2],"d") 
  if test != 0 then
   line= append(line,d[i][1])
  end if
end for
for i=1 to length(line) do
   for j=1 to length(line[i]) do
      if line[i][j]='.' then
        if compare(line[i][j..length(line[i])],"."&name)=0 then
          temp=append(temp,line[i])
        end if
      end if
   end for
end for
line=temp
line=merge_sort(line)
  -- box color blue
  rectangle(180,180,460,340,1,1)
  -- out line black
  rectangle(180,180,460,340,0,0)
  -- top bar 
  rectangle(180,180,460,200,3,1)
  -- text in top bar
  draw_text({182,182},text,BLACK,-1,0)
listview1=create_ex({"listview",190,210,100,line})
button1=create_ex({"button","Open",190,320})
button2=create_ex({"button","Cancle",300,320})
while 1 do
mouse()
listview()
draw_button()
if if_sel({"button",button1})=1 then
  text2= get_text({"listview",listview1})
  delete({"button",button1})
  delete({"button",button2})
  delete({"listview",listview1})
  rectangle(180,180,460,340,7,1)
  return text2
end if
if if_sel({"button",button2})=1 then
  delete({"button",button1})
  delete({"button",button2})
  delete({"listview",listview1})
  rectangle(180,180,460,340,7,1)
  return ""
end if
end while
end function

atom picview1, button1, button2

picview1=create_ex({"picview",10,30,"",""})
button1=create_ex({"button","add sprite",10,95})
button2=create_ex({"button","delete sprite",2,115})

procedure sprite_editer()
--atom picview1, button1, button2
sequence name
object bitmap
-- add image
if if_sel({"button",button1})=1 then
  name=get_file("get sprite","BMP")
  if length(name)>0 then
    bitmap=read_bitmap(name)
    add_image({"picview",picview1,bitmap[2],name})
  end if
end if
-- delete image
if if_sel({"button",button2}) =1 then
   delete_image({"picview",picview1,get_sel({"picview",picview1})})
   if get_sel({"picview",picview1}) >1 then
     set_sel({"picview",picview1,get_sel({"picview",picview1})-1})
   end if
   rectangle(10+1,30+1,10+40-1,30+40-1,7,1)
   rectangle(10+1,30+40+2,10+40+49,30+40+21,7,1)
end if
end procedure
-------------------------
----adding and delteting and editing objects
-------------------------
atom object_picview1, object_button1, object_button2, object_button3, number, object_number
sequence default_image, object_info
object bitmap
bitmap=read_bitmap("object.bmp")
default_image=bitmap[2]
object_info={}
object_number=0
object_picview1=create_ex({"picview",10,150,"",""})
object_button1=create_ex({"button","add object",10,215})
object_button2=create_ex({"button","delete object",2,235})
object_button3=create_ex({"button","edit object",10,255})
number=0

procedure object_editer()
-- add object 
if if_sel({"button",object_button1})=1 then
  add_image({"picview",object_picview1,default_image,"object"&string(number)})
  object_info=append(object_info,{"object"&string(number),object_number})
  object_number+=1
  number+=1
end if
-- delete object
if if_sel({"button",object_button2})=1 then
   if length(object_info)>0 then
   delete_image({"picview",object_picview1,get_sel({"picview",object_picview1})})
   if get_sel({"picview",object_picview1}) >1 then
     set_sel({"picview",object_picview1,get_sel({"picview",object_picview1})-1})
   end if
   if length(object_info)>1 then
   object_info=remove_line(object_info,get_sel({"picview",object_picview1})+1)
   else
   object_info=remove_line(object_info,get_sel({"picview",object_picview1}))
   end if
   rectangle(10+1,150+1,10+40-1,150+40-1,7,1)
   rectangle(10+1,150+40+2,10+40+49,150+40+21,7,1)
   end if
end if
-- edit object
if if_sel({"button",object_button3})=1 then

end if

end procedure

draw_game_maker()

while 1 do
key=get_key()
if key != -1 then
 if key=27 then
  exit
 end if
end if
mouse()
picview()
draw_button()
listview()
sprite_editer()
object_editer()
end while

if graphics_mode(18) then
end if
--?object_info
