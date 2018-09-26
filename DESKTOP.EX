without type_check
include graphics.e
include mouse2.e
include font.e
include image.e
include file.e

atom key,get_button,window_number,selete,draw_all,tollbar_number
atom fileview_number,back_dir1
atom next_dir1,drive,same_dir
same_dir=0
sequence window_info,toolbar_info,fileview_info,dir_name
next_dir1=0
back_dir1=0
dir_name={}
drive=0
draw_all=0
toolbar_info={}
tollbar_number=1
get_button=0
selete=1
window_number=1
window_info={}

fileview_number=1
fileview_info={}
sequence file_names, file_images,image_1
image_1={}
file_images={}
file_names={"EX","TXT","BMP","F","EXE","E","BAT","DOC"}

object bitmap
bitmap=read_bitmap("ex.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("text.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("bmp.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("dir.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("e.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("bat.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("text.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe2.bmp")
image_1=bitmap[2]

function gaz_sort(sequence x)
integer n, mid
sequence merged, a, b
n = length(x)
if n = 0 or n = 1 then
return x  -- trivial case
end if
mid = floor(n/2)
a = gaz_sort(x[1..mid])       -- sort first half of x
b = gaz_sort(x[mid+1..n])     -- sort second half of x
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

constant WINDOW_X=1
constant WINDOW_Y=2
constant WINDOW_WIDTH=3
constant WINDOW_HEIGHT=4
constant WINDOW_BAR_TEXT=5
constant WINDOW_DRAW=6
constant WINDOW_MODE=7
constant WINDOW_TEMP=8
constant WINDOW_TEMP_X=9
constant WINDOW_TEMP_Y=10
constant WINDOW_TEMP_MX=11
constant WINDOW_TEMP_MY=12
constant WINDOW_WORK=13
constant WINDOW_BACKGROUND_COLOR=14
constant WINDOW_ID=15

constant WINDOW_SELETE_COLOR=9
constant WINDOW_DESELETE_COLOR=7

if graphics_mode(259) then
end if

procedure line(atom x, atom y, atom xx, atom yy, atom color)
if color=-1 then
  color=15
end if
draw_line(color,{{x,y},{xx,yy}})
end procedure


procedure rectangle(atom x,atom y,atom xx,atom yy,atom color,atom sel)
if color=-1 then
  color=15
end if
polygon(color, sel, {{x, y}, {xx, y}, {xx, yy},{x,yy}})
end procedure

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

procedure selete_window(atom id)
sequence temp
temp={}
for i=1 to length(window_info) do
if window_info[i][WINDOW_ID]=id then
temp=window_info[i]
window_info=remove_line(window_info,i)
exit
end if
end for
window_info=append(window_info,temp)
end procedure

global procedure draw_all_windows(atom id)
selete_window(id)
rectangle(1,1,800,600,-1,1)
for i=1 to length(window_info) do
window_info[i][WINDOW_DRAW]=1
end for
for i=1 to length(toolbar_info) do
toolbar_info[i][7]=1
end for
for i=1 to length(fileview_info) do
fileview_info[i][6]=1
end for
end procedure

function on_click_window_bar(atom xx, atom yy)
atom x,y,width,mode
mode=0
for i=1 to length(window_info) do
   x=window_info[i][WINDOW_X]
   y=window_info[i][WINDOW_Y]
   width=window_info[i][WINDOW_WIDTH]
   if i=length(window_info) then
   mode=1
   end if
   if mode=1 then
   if xx>x and xx<x+width and yy>y and yy<y+20 then
   return 1
   end if
   end if
  end for
return 0
end function

function mouse_over_window(atom xx, atom yy)
atom x,y,width,mode,height
mode=0
  for i=1 to length(window_info) do
  x=window_info[i][WINDOW_X]
  y=window_info[i][WINDOW_Y]
  width=window_info[i][WINDOW_WIDTH]
  height=window_info[i][WINDOW_HEIGHT]
  if i=length(window_info) then
  mode=1
  end if
  if mode=1 then
  if xx>x and xx<x+width and yy>y and yy<y+height then
  return 1
  end if
  end if
  end for
return 0
end function

function clear(atom xx, atom yy, atom id)
atom x,y,width,height
sequence info
info={}
  for i=1 to length(window_info) do
     x=window_info[i][WINDOW_X]
     y=window_info[i][WINDOW_Y]+20
     width=window_info[i][WINDOW_WIDTH]
     height=window_info[i][WINDOW_HEIGHT]
     if id!=window_info[i][WINDOW_ID] then
     if xx<x then
     info=append(info,1)
     elsif xx>x+width then
     info=append(info,1)
     elsif yy<y then
     info=append(info,1)
     elsif yy>y+height-20 then
     info=append(info,1)
     else
     info=append(info,0)
     end if
     end if
  end for
  if length(info)>0 then
  for i=1 to length(info) do
  if info[i]=0 then
  return 0
  end if
  end for
  return 1
  else
  return 0
  end if
end function

procedure fileview(atom id)
atom x,y,width,height,draw,sel,image_width,image_height,number1,number2,init
atom temp_x,temp_y,temp_width,ok,last,timer1,t,pressed,sel_x,sel_y,sel_mx,sel_my
atom timer2,mode,window_id
sequence string,sel_name,path
temp_x=0
temp_y=0
t=0
temp_width=0
ok=0
  for i=1 to length(fileview_info)  do
     x=fileview_info[i][1]
     y=fileview_info[i][2]
     width=fileview_info[i][3]
     height=fileview_info[i][4]
     image_width=width/100
     image_height=height/50
     string=fileview_info[i][5]
     draw=fileview_info[i][6]
     sel=fileview_info[i][7]
     number1=fileview_info[i][8]
     number2=fileview_info[i][9]
     init=fileview_info[i][10]
     last=fileview_info[i][11]
     timer1=fileview_info[i][12]
     pressed=fileview_info[i][13]
     sel_name=fileview_info[i][14]
     sel_x=fileview_info[i][15]
     sel_y=fileview_info[i][16]
     sel_mx=fileview_info[i][17]
     sel_my=fileview_info[i][18]
     timer2=fileview_info[i][19]
     mode=fileview_info[i][20]
     path=fileview_info[i][21]
     window_id=fileview_info[i][22]

     if init=1 then
     if length(string)>image_height*image_width then
     number2=length(string)-image_height*image_width
     end if
     init=0
     end if


     if window_id=id then
     for j=1 to length(window_info) do
     if window_info[j][WINDOW_ID]=id then
     x+=window_info[j][WINDOW_X]
     y+=window_info[j][WINDOW_Y]+20
     if j=length(window_info) then
     mode=1
     else
     mode=0
     end if
     if x>window_info[j][WINDOW_X]+window_info[j][WINDOW_WIDTH]-width then
     draw=0
     mode=0
     end if
     if x<window_info[j][WINDOW_X] then
     draw=0
     mode=0
     end if
     if y+height>window_info[j][WINDOW_Y]+window_info[j][WINDOW_HEIGHT] then
     draw=0
     mode=0
     end if
     if y<window_info[j][WINDOW_Y] then
     draw=0
     mode=0
     end if
     end if
     end for
     if mode=1 then
      if get_button=mb_right_up and pressed>0 then
      pressed=0
      draw=1
      for j=number1 to length(string)-number2 do
      for k=1 to length(string[j]) do
      if string[j][k]='.' then
      ok=1
      for l=1 to length(file_names) do
      if compare(string[j][k..length(string[j])],"."&file_names[l])=0 then
      temp_width=(length(string[j]))*8
      temp_width=temp_width/4
      if mouse_x>x+2+temp_x+25 and mouse_x<x+2+temp_x+50 and mouse_y>y+2+temp_y and mouse_y<y+2+temp_y+25 then
      if compare(file_names[l],"F")=0 then
        if drive =1 then
          system("copy /b "&path&sel_name&" "&path&string[j][1..k-1],2)
          system("del "&path&sel_name,2)
          --rectangle(1,1,800,600,-1,1)
          puts(1,"copy /b "&path&sel_name&" "&path&string[j][1..k-1])
          same_dir=1
          else
          system("copy /b "&path&{92}&sel_name&" "&path&{92}&string[j][1..k-1],2)
          system("del "&path&{92}&sel_name,2)
          --rectangle(1,1,800,600,-1,1)
          same_dir=1
        end if
      end if
      end if
      end if
      end for
      end if
      end for
      if ok=1 then
      temp_x+=100
      temp_width=0
      if temp_x>width-100 then
      temp_x=0
      temp_y+=50
      end if
      ok=0
      end if
      end for
      temp_x=0
      temp_y=0
      t=0
      temp_width=0
      ok=0
      end if
     if pressed=1 then
     if sel_mx!=mouse_x or sel_my!=mouse_y then
     sel_mx=mouse_x
     sel_my=mouse_y
     pressed=2
     end if
     end if
     if pressed=2 then
     pressed=1
     sel_x=mouse_x
     sel_y=mouse_y
     if sel_x<x or sel_x>x+width-length(sel_name)*8 or sel_y<y+2 or sel_y>y+height-20 then
     --move up
     t=time()
     if timer2<t then
     if sel_y<y+2 and sel_x>x and sel_x<x+width-length(sel_name)*8 then
     if last>0 then
     number1-=last
     number2+=last
     sel_y=y+2
     timer2=time()+.30
     draw=1
     last=0
     else
     if number1>1 then
     number1-=image_width
     number2+=image_width
     sel_y=y+2
     timer2=time()+.30
     draw=1
     end if
     end if
     end if
     end if
     -- move down
     if timer2<t then
     if sel_y>y+height-20 and sel_x>x and sel_x<x+width-length(sel_name)*8 then
     if number1<length(string)-((image_height*image_width)+image_width) then
     number1+=image_width
     number2-=image_width
     sel_y=y+height-20
     timer2=time()+.30
     draw=1
     else
     if number2>0 then
     last=number2
     number1+=number2
     number2=0
     sel_y=y+height-20
     timer2=time()+.30
     draw=1
     end if
     end if
     end if
     end if
     else
     draw=1
     end if
     end if
      for j=number1 to length(string)-number2 do
      for k=1 to length(string[j]) do
      if string[j][k]='.' then
      for l=1 to length(file_names) do
      if compare(string[j][k..length(string[j])],"."&file_names[l])=0 then
      temp_width=(length(string[j]))*8
      temp_width=temp_width/4
      if mouse_x>x+2+temp_x+25 and mouse_x<x+2+temp_x+50 and mouse_y>y+2+temp_y and mouse_y<y+2+temp_y+25 and mouse_button=mb_right then
      if j=sel then
      if pressed=0 then
      if compare(file_names[l],"F")=0 then
      else
      sel_name=string[j]
      pressed=1
      mouse_button=0
      end if
      end if
      end if
      end if
      if mouse_x>x+2+temp_x+25 and mouse_x<x+2+temp_x+50 and mouse_y>y+2+temp_y and mouse_y<y+2+temp_y+25 and mouse_button=mb_left then
      t=time()
      if j=sel then
      if timer1>t then
      if compare(file_names[l],"F")=0 then
      -- next_dir
        next_dir1=fileview_info[i][23]
        dir_name=string[j][1..k-1]
        mouse_button=0
      -- 
      else
      end if
      timer1=0
      else
      timer1=time()+.30
      end if
      mouse_button=0
      else
      if timer1=0 then
      timer1=time()+.30
      else
      timer1=time()+.30
      end if
      sel=j
      draw=1
      end if
      mouse_button=0
      end if
      temp_x+=100
      temp_width=0
      if temp_x>width-100 then
      temp_x=0
      temp_y+=50
      end if
      ok=1
      exit
      end if
      end for
      if ok=0 then
      temp_width=(length(string[j]))*8
      temp_width=temp_width/4
      if mouse_x>x+2+temp_x+25 and mouse_x<x+2+temp_x+50 and mouse_y>y+2+temp_y and mouse_y<y+2+temp_y+25 and mouse_button=mb_right then
      if j=sel then
      if pressed=0 then
      sel_name=string[j]
      pressed=1
      mouse_button=0
      end if
      end if
      end if
      if mouse_x>x+2+temp_x+25 and mouse_x<x+2+temp_x+50 and mouse_y>y+2+temp_y and mouse_y<y+2+temp_y+25 and mouse_button=mb_left then
      sel=j
      draw=1
      mouse_button=0
      end if
      temp_x+=100
      temp_width=0
      if temp_x>width-100 then
      temp_x=0
      temp_y+=50
      end if
      else
      ok=0
      end if
      end if
      end for
      end for

     if mouse_x>x+width and mouse_x<x+width+10 and mouse_y>y and mouse_y<y+12 and mouse_button=mb_left then
     if last>0 then
     number1-=last
     number2+=last
     draw=1
     last=0
     else
     if number1>1 then
     number1-=image_width
     number2+=image_width
     draw=1
     end if
     end if
     mouse_button=0
     end if
     --
     if mouse_x>x+width and mouse_x<x+width+10 and mouse_y>y+height-12 and mouse_y<y+height and mouse_button=mb_left then
       if number1<length(string)-((image_height*image_width)+image_width) then
       number1+=image_width
       number2-=image_width
       draw=1
       else
        if number2>0 then
        last=number2
        number1+=number2
        number2=0
        draw=1
        end if
       end if
        mouse_button=0
     end if
     end if

     if draw=1 then
     temp_x=0
     temp_y=0
     temp_width=0
     ok=0
     rectangle(x,y,x+width,y+height,-1,1)
     rectangle(x,y,x+width,y+height,0,0)
     rectangle(x+width,y,x+width+12,y+height,-1,1)
     rectangle(x+width,y,x+width+12,y+height,0,0)
     --up
     rectangle(x+width,y,x+width+10,y+12,7,1)
     rectangle(x+width,y,x+width+11,y+13,0,0)
     line(x+width+5,y+1,x+width+5,y+1,0)
     line(x+width+4,y+2,x+width+6,y+2,0)
     line(x+width+3,y+3,x+width+7,y+3,0)
     line(x+width+2,y+4,x+width+8,y+4,0)

     --down
     rectangle(x+width,y+height,x+width+10,y+height-12,7,1)
     rectangle(x+width,y+height,x+width+11,y+height-13,0,0)
     line(x+width+2,y+height-4,x+width+8,y+height-4,0)
     line(x+width+3,y+height-3,x+width+7,y+height-3,0)
     line(x+width+4,y+height-2,x+width+6,y+height-2,0)
     line(x+width+5,y+height-1,x+width+5,y+height-1,0)
     for j=number1 to length(string)-number2 do
     for k=1 to length(string[j]) do
     if string[j][k]='.' then
     for l=1 to length(file_names) do
     if compare(string[j][k..length(string[j])],"."&file_names[l])=0 then
     string[j]=string[j][1..k-1]
     temp_width=(length(string[j]))*8
     temp_width=temp_width/4
     if j=sel then
     display_image({x+2+temp_x+25,y+2+temp_y},file_images[l])
     draw_text({x+2+temp_x+25-temp_width,y+26+temp_y},string[j],RED,-1,0)
     else
     display_image({x+2+temp_x+25,y+2+temp_y},file_images[l])
     draw_text({x+2+temp_x+25-temp_width,y+26+temp_y},string[j],0,-1,0)
     end if
     temp_x+=100
     temp_width=0
     if temp_x>width-100 then
     temp_x=0
     temp_y+=50
     end if
     ok=1
     exit
     end if
     end for
     if ok=0 then
     temp_width=(length(string[j]))*8
     temp_width=temp_width/4
     if j=sel then
     display_image({x+2+temp_x+25,y+2+temp_y},image_1)
     draw_text({x+2+temp_x+25-temp_width,y+26+temp_y},string[j],RED,-1,0)
     else
     display_image({x+2+temp_x+25,y+2+temp_y},image_1)
     draw_text({x+2+temp_x+25-temp_width,y+26+temp_y},string[j],0,-1,0)
     end if
     temp_x+=100
     temp_width=0
     if temp_x>width-100 then
     temp_x=0
     temp_y+=50
     end if
     else
     ok=0
     end if
     exit
     end if
     end for
     end for
     if pressed=1 then
     draw_text({sel_x,sel_y},sel_name,RED,-1,0)
     end if
     draw=0
     end if
     end if
     fileview_info[i][6]=draw
     fileview_info[i][7]=sel
     fileview_info[i][8]=number1
     fileview_info[i][9]=number2
     fileview_info[i][10]=init
     fileview_info[i][11]=last
     fileview_info[i][12]=timer1
     fileview_info[i][13]=pressed
     fileview_info[i][14]=sel_name
     fileview_info[i][15]=sel_x
     fileview_info[i][16]=sel_y
     fileview_info[i][17]=sel_mx
     fileview_info[i][18]=sel_my
     fileview_info[i][19]=timer2
     fileview_info[i][21]=path
     temp_x=0
     temp_y=0
     ok=0
     temp_width=0
  end for
end procedure

function on_click(sequence string)
  if compare(string[1],"toolbar")=0 then
    for i=1 to length(toolbar_info) do
       if toolbar_info[i][11]=string[2] then
         if toolbar_info[i][9]=string[3] then
           toolbar_info[i][9]=0
           mouse_button=0
           return 1
         else
          return 0
         end if
       end if
    end for
  end if
return 0
end function

procedure toolbar(atom id)
atom x,y,width,height,sel,window_id,draw,mode,temp_x,sel2
sequence string
temp_x=0
  for i=1 to length(toolbar_info)  do

     x=toolbar_info[i][1]
     y=toolbar_info[i][2]
     width=toolbar_info[i][3]
     height=toolbar_info[i][4]
     sel=toolbar_info[i][5]
     string=toolbar_info[i][6]
     draw=toolbar_info[i][7]
     mode=toolbar_info[i][8]
     sel2=window_info[i][9]
     window_id=toolbar_info[i][10]

     if window_id=id then
     for j=1 to length(window_info) do
     if window_info[j][WINDOW_ID]=id then
     x+=window_info[j][WINDOW_X]
     y+=window_info[j][WINDOW_Y]+20
     width=window_info[j][WINDOW_WIDTH]-1
     height=30
     if j=length(window_info) then
     mode=1
     else
     mode=0
     end if
     if x>window_info[j][WINDOW_X]+window_info[j][WINDOW_WIDTH]-width then
     draw=0
     mode=0
     end if
     if x<window_info[j][WINDOW_X] then
     draw=0
     mode=0
     end if
     if y+height>window_info[j][WINDOW_Y]+window_info[j][WINDOW_HEIGHT] then
     draw=0
     mode=0
     end if
     if y<window_info[j][WINDOW_Y] then
     draw=0
     mode=0
     end if
     end if
     end for
     if mode=1 then
       for j=1 to length(string) do
          if mouse_x>x+2+temp_x+(20*(j-1)) and mouse_x<x+2+temp_x+(20*j) and mouse_y>y+2 and mouse_y<y+27 and mouse_button=mb_left then
            sel2=j
            mouse_button=0
          end if
          if mouse_x>x+2+temp_x+(20*(j-1)) and mouse_x<x+2+temp_x+(20*j) and mouse_y>y+2 and mouse_y<y+27 then
            if sel!=j then
              sel=j
              draw=1
            end if
          else
          if sel>0 and sel=j then
           sel=0
           draw=1
          end if
          end if
          temp_x+=10
       end for
       temp_x=0
     end if
     if draw=1 then
       rectangle(x,y,x+width,y+height,7,1)
       for j=1 to length(string) do
          if j=sel then
            display_image({x+2+temp_x+(20*(j-1)),y+2},string[j][2])
          else
            display_image({x+2+temp_x+(20*(j-1)),y+2},string[j][1])
          end if
         temp_x+=10
       end for
       draw=0
       temp_x=0
     end if
     end if
    toolbar_info[i][5]=sel
    toolbar_info[i][7]=draw
    toolbar_info[i][8]=mode
    toolbar_info[i][9]=sel2
  end for
end procedure

procedure window()
atom x,y,width,height,draw,mode,work,temp,temp_x,temp_y,temp_m_x,temp_m_y
atom background_color
sequence window_name
  for i=1 to length(window_info) do
     x=window_info[i][WINDOW_X]
     y=window_info[i][WINDOW_Y]
     width=window_info[i][WINDOW_WIDTH]
     height=window_info[i][WINDOW_HEIGHT]
     window_name=window_info[i][WINDOW_BAR_TEXT]
     draw=window_info[i][WINDOW_DRAW]
     mode=window_info[i][WINDOW_MODE]
     temp=window_info[i][WINDOW_TEMP]
     temp_x=window_info[i][WINDOW_TEMP_X]
     temp_y=window_info[i][WINDOW_TEMP_Y]
     temp_m_x=window_info[i][WINDOW_TEMP_MX]
     temp_m_y=window_info[i][WINDOW_TEMP_MY]
     work=window_info[i][WINDOW_WORK]
     background_color=window_info[i][WINDOW_BACKGROUND_COLOR]
     if work=1 then
     if i=length(window_info) then
     mode=1
     else
     mode=0
     end if
     if get_button=3 then
     temp=0
     mouse_button=0
     end if
     if mode=0 then
     if mouse_x>x and mouse_x<x+width and mouse_y>y and mouse_y<y+height and mouse_button=mb_left then
     if clear(mouse_x,mouse_y,window_info[i][WINDOW_ID])=1 and on_click_window_bar(mouse_x,mouse_y)=0 then
     draw_all=window_info[i][WINDOW_ID]
     end if
     if mouse_y>y and mouse_y<y+20 then
     if mouse_over_window(mouse_x,mouse_y)=0 then
     draw_all=window_info[i][WINDOW_ID]
     temp=1
     temp_x=mouse_x-x
     temp_y=mouse_y-y
     temp_m_x=mouse_x
     temp_m_y=mouse_y
     end if
     end if
     end if
     else
     if mouse_x>x and mouse_x<x+width-16 and mouse_y>y and mouse_y<y+20 and mouse_button=mb_left and temp=0 then
     draw_all=window_info[i][WINDOW_ID]
     temp=1
     temp_x=mouse_x-x
     temp_y=mouse_y-y
     temp_m_x=mouse_x
     temp_m_y=mouse_y
     mouse_button=0
     end if
     if temp=1 then
     if temp_m_x!=mouse_x or temp_m_y!=mouse_y then
     temp_m_x=mouse_x
     temp_m_y=mouse_y
     temp=2
     end if
     end if
     if temp=2 then
     window_info[i][WINDOW_X]=mouse_x-temp_x
     window_info[i][WINDOW_Y]=mouse_y-temp_y
     temp=1
     draw_all=window_info[i][WINDOW_ID]
     end if
     end if
     if draw=1 then
     if mode=1 then
     rectangle(x,y,x+width,y+20,WINDOW_SELETE_COLOR,1)
     rectangle(x,y,x+width,y+20,0,0)
     draw_text({x+2,y+2},window_name,0,WINDOW_SELETE_COLOR,0)
     else
     rectangle(x,y,x+width,y+20,WINDOW_DESELETE_COLOR,1)
     rectangle(x,y,x+width,y+20,0,0)
     draw_text({x+2,y+2},window_name,0,WINDOW_DESELETE_COLOR,0)
     end if
     if mode=3 then
     rectangle(x+width-16,y+2,x+width-2,y+18,7,1)
     rectangle(x+width-16,y+2,x+width-2,y+18,0,0)
     line(x+width-4,y+4,x+width-14,y+16,0)
     line(x+width-14,y+4,x+width-4,y+16,0)
     end if  
     rectangle(x,y+20,x+width,y+height,background_color,1)
     rectangle(x,y+20,x+width,y+height,0,0)
     draw=0
     end if
     toolbar(window_info[i][WINDOW_ID])
     fileview(window_info[i][WINDOW_ID])

     end if
     window_info[i][WINDOW_DRAW]=draw
     window_info[i][WINDOW_TEMP]=temp
     window_info[i][WINDOW_TEMP_X]=temp_x
     window_info[i][WINDOW_TEMP_Y]=temp_y
     window_info[i][WINDOW_TEMP_MX]=temp_m_x
     window_info[i][WINDOW_TEMP_MY]=temp_m_y
     window_info[i][WINDOW_WORK]=work
     window_info[i][WINDOW_BACKGROUND_COLOR]=background_color
  end for
end procedure

atom test
sequence d,line1
procedure init(sequence path)
test=0
d={}
line1={}

  d = dir(path)
  for i=1 to length(d) do
  test= compare(d[i][2],"d") 
  if test!=0 then
  line1=append(line1,d[i][1])
  end if
  end for

  test=0
  d={}

  d = dir(path)
  for i=1 to length(d) do
  test= compare(d[i][2],"d") 
  if test=0 then
    if compare(d[i][1],".")=0 or compare(d[i][1],"..")=0  then
    else
    line1=append(line1,d[i][1]&".F")
    end if
  end if
  end for

   line1=gaz_sort(line1)

end procedure
init("c:\\")

window_info=append(window_info,{10,10,330,260,"window1",1,1,0,0,0,0,0,1,-1,window_number})
window_number+=1
window_info=append(window_info,{400,10,330,260,"window2",1,1,0,0,0,0,0,1,-1,window_number})
fileview_number+=1
fileview_info=append(fileview_info,{2,33,300,200,line1,1,0,1,0,1,0,0,0,"",0,0,0,0,0,0,current_dir(),1,fileview_number})
fileview_number+=1
fileview_info=append(fileview_info,{2,33,300,200,line1,1,0,1,0,1,0,0,0,"",0,0,0,0,0,0,current_dir(),2,fileview_number})

rectangle(1,1,800,600,-1,1)

object bitmap2
sequence image
image={}
bitmap=read_bitmap("back.bmp")
bitmap2=read_bitmap("back1.bmp")
image=append(image,{bitmap[2],bitmap2[2]})
bitmap=read_bitmap("forward.bmp")
bitmap2=read_bitmap("forward1.bmp")
--image=append(image,{bitmap[2],bitmap2[2]})

toolbar_info=append(toolbar_info,{1,1,0,0,0,image,1,0,0,1,tollbar_number})
tollbar_number+=1

toolbar_info=append(toolbar_info,{1,1,0,0,0,image,1,0,0,2,tollbar_number})
tollbar_number+=1

atom temp_x,temp_y
sequence s
s={}
temp_x=0
temp_y=0
procedure draw_mouse()
  if temp_x!=mouse_x or temp_y!=mouse_y then
    display_image({temp_x,temp_y},s)
    s=save_image({mouse_x,mouse_y},{mouse_x+5,mouse_y+5})
    rectangle(mouse_x,mouse_y,mouse_x+5,mouse_y+5,RED,1)
    temp_x=mouse_x
    temp_y=mouse_y
  end if
end procedure

function back_dir(sequence path)
sequence temp, info, name
atom pos
info={}
name=""
temp=path&{92}
pos=1
for i=1 to length(temp) do
   if temp[i]=92 then
     info=append(info,temp[pos..i])
     pos=i+1
   end if
end for
if length(info)=2 then
  drive=1
  return info[1]
end if
for i=1 to length(info)-1 do
   name&=info[i]
end for
drive=0
return name[1..length(name)-1]
end function


function next_dir(sequence path)
sequence temp, info
atom pos
info={}
temp=path&{92}
pos=1
for i=1 to length(temp) do
   if temp[i]=92 then
     info=append(info,temp[pos..i])
     pos=i+1
   end if
end for
for i=1 to length(info) do
   if info[i][1]=92 then
     info=remove_line(info,i)
   end if
end for
if length(info)=1 then
  drive=0
  return path&dir_name
end if
drive=0
return path&"\\"&dir_name
end function

while 1 do
key=get_key()
if key != -1 then
 if key=27 then
  exit
 end if
end if
mouse()
draw_mouse()
get_button=mouse_button
if draw_all>0 then
draw_all_windows(draw_all)
draw_all=0
end if
window()
if next_dir1>0 then
  for i=1 to length(fileview_info) do
    if fileview_info[i][23]=next_dir1 then
     fileview_info[i][21]=next_dir(fileview_info[i][21])
     init(fileview_info[i][21])
     fileview_info[i][5]=line1
     fileview_info[i][6]=1
     fileview_info[i][7]=0
     fileview_info[i][8]=1
     fileview_info[i][9]=0
     fileview_info[i][10]=1
     fileview_info[i][11]=0
     next_dir1=0
     dir_name={}
     exit
    end if
  end for
end if
if on_click({"toolbar",1,1})=1 then
  for i=1 to length(fileview_info) do
    if fileview_info[i][22]=toolbar_info[1][10] then
     fileview_info[i][21]=back_dir(fileview_info[i][21])
     init(fileview_info[i][21])
     fileview_info[i][5]=line1
     fileview_info[i][6]=1
     fileview_info[i][7]=0
     fileview_info[i][8]=1
     fileview_info[i][9]=0
     fileview_info[i][10]=1
     fileview_info[i][11]=0
     exit
    end if
  end for
end if
if on_click({"toolbar",2,1})=1 then
  for i=1 to length(fileview_info) do
    if fileview_info[i][22]=toolbar_info[2][10] then
     fileview_info[i][21]=back_dir(fileview_info[i][21])
     init(fileview_info[i][21])
     fileview_info[i][5]=line1
     fileview_info[i][6]=1
     fileview_info[i][7]=0
     fileview_info[i][8]=1
     fileview_info[i][9]=0
     fileview_info[i][10]=1
     fileview_info[i][11]=0
     exit
    end if
  end for
end if
end while
