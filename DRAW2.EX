-----------------------------------------------------------
-- drawing for children version 0.1 AM 2;12 time 14/12/05 
-----------------------------------------------------------
without type_check
without warning
include graphics.e
include image.e
include font.e
include get.e
include mouse2.e

if graphics_mode(258) then
end if

procedure line(atom x,atom y,atom xx,atom yy,atom color)
  draw_line(color, {{x, y}, {xx, yy}})
end procedure

procedure rectangle(atom x,atom y,atom xx,atom yy,atom color,atom sel)
  polygon(color, sel, {{x, y}, {xx, y}, {xx, yy},{x,yy}})
end procedure

sequence button_info,button_image_info
integer button_number,button_image_number
button_info={}
button_number=0
button_image_info={}
button_image_number=0

constant BUTTON_X=1
constant BUTTON_Y=2
constant BUTTON_WIDTH=3
constant BUTTON_SEL=4
constant BUTTON_NAME=5
constant BUTTON_DRAW=6
constant BUTTON_ID=7

constant BUTTON_IMAGE_X=1
constant BUTTON_IMAGE_Y=2
constant BUTTON_IMAGE_SEL=3
constant BUTTON_IMAGE_IMAGES=4
constant BUTTON_IMAGE_DRAW=5
constant BUTTON_IMAGE_ID=6

function create(sequence string)
  if equal(string[1],"button")=1 then
    button_number+=1
    button_info=append(button_info,{string[2],string[3],0,0,string[4],1,button_number})
    return button_number
  end if
  if equal(string[1],"button_image")=1 then
    button_image_number+=1
    button_image_info=append(button_image_info,{string[2],string[3],0,string[4],1,button_image_number})
    return button_image_number
  end if
end function

procedure draw_all()
  for i=1 to length(button_info) do
     button_info[i][BUTTON_DRAW]=1
  end for
end procedure

function on_click(sequence string)
  if equal(string[1],"button")=1 then
    for i=1 to length(button_info) do
       if button_info[i][BUTTON_ID]=string[2] then
         if button_info[i][BUTTON_SEL]=1 then
           button_info[i][BUTTON_SEL]=0
           return 1
         else
           return 0
         end if
       end if
    end for
  end if
end function

procedure button_dos()
integer x,y,width,sel,draw
sequence name
  for i=1 to length(button_info) do
     x=button_info[i][BUTTON_X]
     y=button_info[i][BUTTON_Y]
     width=button_info[i][BUTTON_WIDTH]
     sel=button_info[i][BUTTON_SEL]
     name=button_info[i][BUTTON_NAME]
     draw=button_info[i][BUTTON_DRAW]
     width=length(name)
     width+=2
     width=width*8
     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+18 then
       line(x,y,x+width,y,-1)
       line(x,y,x,y+18,-1)
       line(x,y+18,x+width,y+18,7)
       line(x+width,y,x+width,y+18,7)
     else
       line(x,y,x+width,y,7)
       line(x,y,x,y+18,7)
       line(x,y+18,x+width,y+18,-1)
       line(x+width,y,x+width,y+18,-1)
     end if
     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+18 and mouse_button=mb_left then
       sel=1
       mouse_button=0
     end if
     if draw=1 then
      line(x,y,x+width,y,7)
      line(x,y+18,x+width,y+18,-1)
      line(x,y,x,y+18,7)
      line(x+width,y,x+width,y+18,-1)
      rectangle(x+1,y+1,x+width-1,y+17,7,1)
      draw_text({x+8,y+1},name,0,7,0)
      draw=0
     end if
     button_info[i][BUTTON_WIDTH]=width
     button_info[i][BUTTON_SEL]=sel
     button_info[i][BUTTON_DRAW]=draw
  end for
end procedure

procedure button_image_dos()
integer x,y,sel,draw,width,height
atom timer
sequence images
timer=0
  for i=1 to length(button_image_info) do
     x=button_image_info[i][BUTTON_IMAGE_X]
     y=button_image_info[i][BUTTON_IMAGE_Y]
     sel=button_image_info[i][BUTTON_IMAGE_SEL]
     images=button_image_info[i][BUTTON_IMAGE_IMAGES]
     draw=button_image_info[i][BUTTON_IMAGE_DRAW]
     width=length(images[1][1])
     height=length(images[1])

     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+height then
     else
     end if
     if mouse_x>x and mouse_x< x+width and mouse_y>y and mouse_y<y+height and mouse_button=mb_left then
       display_image({x,y},images[2])
       timer=time()+.20
       while 1 do
         if time()>timer then
           exit
         end if
       end while
       display_image({x,y},images[1])
       sel=1
       mouse_button=0
     end if
     if draw=1 then
      display_image({x,y},images[1])
      draw=0
     end if
     button_image_info[i][BUTTON_IMAGE_SEL]=sel
     button_image_info[i][BUTTON_IMAGE_DRAW]=draw
  end for
end procedure


function file_read(sequence string)
sequence buffer
object line
integer fn
fn = open(string, "r")
 if fn = -1 then
 end if
buffer = {}
while 1 do
 line = gets(fn)
 if atom(line) then
  exit   
 end if
 line=line[1..length(line)-1]
 buffer = append(buffer, line)
end while
close(fn)
return buffer
end function

function make_image(sequence data)
sequence image
integer pos1
image={}
pos1=1
   for i=1 to length(data) do
      image=append(image,{})
      pos1=1
      for j=1 to length(data[i]) do
         if data[i][j]!='"' then
           if data[i][j]='A' then
             image[i]&=10
           elsif data[i][j]='B' then
             image[i]&=11
           elsif data[i][j]='C' then
             image[i]&=12
           elsif data[i][j]='D' then
             image[i]&=13
           elsif data[i][j]='E' then
             image[i]&=14
           elsif data[i][j]='F' then
             image[i]&=-1
           else
           image[i]&=data[i][j]
           end if
         end if
      end for
   end for
return image
end function

sequence image
image={}

procedure load_images(sequence string)
  sequence temp,file_data,info
  integer pos
  pos=1
  info={}
  temp=file_read(string)
  file_data={}
  for i=1 to length(temp)-1 do
     if temp[i][1]!='"' then
         for j=1 to length(temp[i]) do
           if temp[i][j]=',' then
             info=append(info,temp[i][1..j-1])
             info=append(info,temp[i][j+1..length(temp[i])])
             exit
           end if
         end for
         for j=i+1 to length(temp)-1 do
           if temp[j][1]!='"' or j=length(temp)-1 then
             if j=length(temp)-1 then
               pos=j+1
               exit
             else
             pos=j-1
             exit
             end if
           end if
         end for
         file_data=append(file_data,{temp[i+1..pos],info})
         info={}
     end if
  end for
  temp={}
  for i=1 to length(file_data) do
    image=append(image,{make_image(file_data[i][1]),file_data[i][2]})
  end for
end procedure


integer key, t_x,t_y,x1,y1, zoom_x,zoom_y,t_c,grid2
integer width_p,height_p,color,color2,grid
integer draw, mode
atom temp_x,temp_y
sequence s
sequence temp_image
integer click,l_x,l_y,button,soid
sequence temp_line
temp_image={}
for i=1 to 32 do
  temp_image=append(temp_image,repeat(0,32))
end for
zoom_x=10
zoom_y=10
t_x=1
t_y=1
t_c=0
x1=1
y1=1
width_p=32
height_p=32
color=-1
color2=0
grid=3
grid2=1
s={}
temp_x=0
temp_y=0
draw=0
click=0
mode=1
l_x=1
l_y=1
temp_line={}
button=0
soid=1

procedure cls()
  clear_screen()
  draw_all()
end procedure

procedure new()
  position(2,2)
  width_p= prompt_number("What is width_p of the image enter number between 0 50? ", {0, 50})
  height_p= prompt_number("What is height_p of image enter number between 0 50? ", {0, 50})
  cls()
  temp_image={}
  for i=1 to height_p do
    temp_image=append(temp_image,repeat(0,width_p))
  end for
zoom_x=6
zoom_y=6
t_x=1
t_y=1
t_c=0
x1=1
y1=1
color=-1
color2=0
grid2=1
grid=3
s={}
temp_x=0
temp_y=0
draw=0
click=0
mode=1
l_x=1
l_y=1
temp_line={}
button=0
soid=1
end procedure

procedure draw_pos(integer pos1, integer pos2,integer all)
for y=1 to height_p do
   for x=1 to width_p do
      if x=pos1 and y=pos2 then
        rectangle(zoom_x*t_x,zoom_y*t_y,zoom_x*(t_x+1),zoom_y*(t_y+1),t_c,1)
        if zoom_x>=grid then
          if grid2=1 then
          rectangle(zoom_x*t_x,zoom_y*t_y,zoom_x*(t_x+1),zoom_y*(t_y+1),8,0)
          end if
        end if
        rectangle(zoom_x*x,zoom_y*y,zoom_x*(x+1),zoom_y*(y+1),color,1)
        if zoom_x>=grid then
          if grid2=1 then
          rectangle(zoom_x*x,zoom_y*y,zoom_x*(x+1),zoom_y*(y+1),-1,0)
          end if
        end if
      else
        if all=1 then
          rectangle(zoom_x*x,zoom_y*y,zoom_x*(x+1),zoom_y*(y+1),temp_image[y][x],1)
        if zoom_x>=grid then
          if grid2 =1 then
          rectangle(zoom_x*x,zoom_y*y,zoom_x*(x+1),zoom_y*(y+1),8,0)
          end if
        end if
        end if
      end if
   end for
end for
end procedure

procedure draw_mouse2()
  if temp_x!=mouse_x or temp_y!=mouse_y then
    display_image({temp_x,temp_y},s)
    s=save_image({mouse_x,mouse_y},{mouse_x+5,mouse_y+5})
    rectangle(mouse_x,mouse_y,mouse_x+5,mouse_y+5,RED,1)
    temp_x=mouse_x
    temp_y=mouse_y
  end if
end procedure

procedure draw_mouse()
  x1=floor(mouse_x/zoom_x)
  y1=floor(mouse_y/zoom_y)
  if x1>=1 and x1<=width_p and y1>=1 and y1<=height_p then
    if mouse_button=mb_right and mode>=2 then
      if click=0 then
        button=2
        draw=1
        mouse_button=0
        l_x=x1
        l_y=y1
        temp_line=temp_image
        click+=1
      elsif click=1 then
        if button=1 then
          temp_image=temp_line
          draw_pos(x1,y1,1)
        end if
        mouse_button=0
        click=0
      end if
    end if
    if mouse_button=mb_left and mode>=2 then
      if click=0 then
        button=1
        draw=1
        mouse_button=0
        l_x=x1
        l_y=y1
        temp_line=temp_image
        click+=1
      elsif click=1 then
        if button=2 then
          temp_image=temp_line
          draw_pos(x1,y1,1)
        end if
        mouse_button=0
        click=0
      end if
    end if
    if mouse_button=mb_left and mode=1 then
      temp_image[y1][x1]=color
      draw=1
      mouse_button=0
    end if
    if mouse_button=mb_right and mode=1 then
      temp_image[y1][x1]=color2
      draw=2
      mouse_button=0
    end if
    if t_x!=x1 or t_y!=y1 then
      draw_text({300,580},"x "&sprint(x1)&"   ",-1,0,0)
      draw_text({360,580},"y "&sprint(y1)&"   ",-1,0,0)
      if draw=0 then
        t_c=temp_image[t_y][t_x]
      elsif draw=1 then
        t_c=color
        draw=0
      elsif draw=2 then
        t_c=color2
        draw=0
      end if
      draw_pos(x1,y1,0)
      if mode=1 then
      elsif mode=2 and click=1 then
        temp_image=temp_line
        display_image({30,30},temp_image)
        if button=1 then
        line(29+l_x,29+l_y,29+x1,29+y1,color)
        elsif button=2 then
        line(29+l_x,29+l_y,29+x1,29+y1,color2)
        end if
        for i=1 to height_p do
          for j=1 to width_p do
            temp_image[i][j]=get_pixel({29+j,29+i})
          end for
        end for
        draw_pos(x1,y1,1)
      elsif mode=3 and click=1 then
        temp_image=temp_line
        display_image({30,30},temp_image)
        if button=1 then
          rectangle(29+l_x,29+l_y,29+x1,29+y1,color,soid)
        elsif button=2 then
          rectangle(29+l_x,29+l_y,29+x1,29+y1,color2,soid)
        end if
        for i=1 to height_p do
          for j=1 to width_p do
            temp_image[i][j]=get_pixel({29+j,29+i})
          end for
        end for
        draw_pos(x1,y1,1)
      elsif mode=4 and click=1 then
        temp_image=temp_line
        display_image({30,30},temp_image)
        if button=1 then
          ellipse(color,soid,{29+l_x,29+l_y} ,{29+x1,29+y1})
        elsif button=2 then
          ellipse(color2,soid,{29+l_x,29+l_y} ,{29+x1,29+y1})
        end if
        for i=1 to height_p do
          for j=1 to width_p do
            temp_image[i][j]=get_pixel({29+j,29+i})
          end for
        end for
        draw_pos(x1,y1,1)
      end if
      t_x=x1
      t_y=y1
    end if
  else
    draw_mouse2()
  end if
end procedure

procedure draw_colors(integer xx, integer yy)
  for i=-1 to 14 do
     rectangle(xx+15*(i+2),yy,xx+15*(i+3),yy+15,i,1)
  end for
   if mode=1 then
     draw_text({300,560},"Pen      ",-1,0,0)
   elsif mode=2 then
     draw_text({300,560},"line     ",-1,0,0)
   elsif mode=3 then
     draw_text({300,560},"rectangle",-1,0,0)
   elsif mode=4 then
     draw_text({300,560},"cir      ",-1,0,0)
   end if
   draw_text({420,560},"zoom "&sprint(zoom_x),-1,0,0)
   draw_text({520,560},"width "&sprint(width_p)&" height "&sprint(height_p),-1,0,0)
   draw_text({420,580},"soid "&sprint(soid),-1,0,0)
   draw_text({520,580},"grid "&sprint(grid2),-1,0,0)
   draw_text({300,580},"x "&sprint(x1)&"   ",-1,0,0)
   draw_text({360,580},"y "&sprint(y1)&"   ",-1,0,0)
end procedure

procedure sel_color(integer xx, integer yy)
  for i=-1 to 14 do
    if mouse_x>=xx+15*(i+2) and mouse_x<=xx+15*(i+3) and mouse_y>=yy and mouse_y<=yy+15 and mouse_button=mb_left then
      color=i
      mouse_button=0
      rectangle(xx+15,yy-25,xx+30,yy-10,color,1)
      rectangle(xx+30,yy-25,xx+45,yy-10,color2,1)
      rectangle(xx+15,yy-25,xx+30,yy-10,-1,0)
      rectangle(xx+30,yy-25,xx+45,yy-10,-1,0)
      exit
    end if
    if mouse_x>=xx+15*(i+2) and mouse_x<=xx+15*(i+3) and mouse_y>=yy and mouse_y<=yy+15 and mouse_button=mb_right then
      color2=i
      mouse_button=0
      rectangle(xx+15,yy-25,xx+30,yy-10,color,1)
      rectangle(xx+30,yy-25,xx+45,yy-10,color2,1)
      rectangle(xx+15,yy-25,xx+30,yy-10,-1,0)
      rectangle(xx+30,yy-25,xx+45,yy-10,-1,0)
      exit
    end if
  end for
end procedure

function file_exsist(sequence string)
atom fn
fn = open(string, "r")
if fn = -1 then
  return 0
else
  return 1
close(fn)
end if
end function

procedure open_pic()
integer format
sequence file, ima
format=0
  position(2,2)
  if compare(prompt_string("Do You Want To Open A Image Yes or NO? "),"y") =0 then
  file = prompt_string("Enter A File Name? ")
    if file_exsist(file)=1 then
      for i=1 to length(file) do
         if file[i]='.' then
           if equal(file[i+1..length(file)],"bmp")=1 then
             format=1
           elsif equal(file[i+1..length(file)],"pic")=1 then
             format=2
           end if
           exit
         end if
      end for
       if format=1 then
         ima=read_bitmap(file)
         temp_image=ima[2]
       elsif format=2 then
         image={}
         load_images(file)
         temp_image=image[1][1]
       end if
       height_p=length(temp_image)
       zoom_x=6
       zoom_y=6
       width_p=length(temp_image[1])
       t_x=1
       t_y=1
       t_c=0
       x1=1
       y1=1
       color=-1
    else
      puts(1,"\n image not found")
      sleep(2)
    end if
  end if
end procedure

procedure write_pic(sequence file_name, sequence pic)
integer fn,width,height
sequence bmp_image
bmp_image={}
width=length(pic[1])
height=length(pic)
  for i=1 to height do
    bmp_image=append(bmp_image,repeat(0,width))
  end for
  for i=1 to length(pic) do
    for j=1 to length(pic[i]) do
       if pic[i][j]=10 then
         bmp_image[i][j]='A'
       elsif pic[i][j]=11 then
         bmp_image[i][j]='B'
       elsif pic[i][j]=12 then
         bmp_image[i][j]='C'
       elsif pic[i][j]=13 then
         bmp_image[i][j]='D'
       elsif pic[i][j]=14 then
         bmp_image[i][j]='E'
       elsif pic[i][j]=-1 then
         bmp_image[i][j]='F'
       elsif pic[i][j]=15 then
         bmp_image[i][j]='F'
       else
        bmp_image[i][j]=pic[i][j]
       end if
    end for
  end for
fn = open(file_name, "w")
if fn = -1 then
end if
print(fn,width)
puts(fn,",")
print(fn,height)
puts(fn,"\n")
 for i=1 to height do
    puts(fn,'"')
    for j=1 to width do
       if bmp_image[i][j]>=0 and bmp_image[i][j]<=9 then
         print(fn,bmp_image[i][j])
       else
         puts(fn,bmp_image[i][j])
       end if
       if j=width and i!=height then
         puts(fn,'"'&"\n")
       end if
       if j=width and i=height then
         puts(fn,'"')
       end if
    end for
 end for
close(fn)
end procedure

procedure save()
integer err,format
sequence file
format=0
  position(2,2)
  if compare(prompt_string("Do You Want To Save Image Yes or NO? "),"y") =0 then
    file = prompt_string("Enter A File Name? ")
    for i=1 to length(file) do
       if file[i]='.' then
         if equal(file[i+1..length(file)],"bmp")=1 then
           format=1
         elsif equal(file[i+1..length(file)],"pic")=1 then
           format=2
         end if
         exit
       end if
    end for
    if format=1 then
      cls()
      display_image({1,1},temp_image)
      err=save_screen({{1,1},{width_p, height_p}},file)
    elsif format=2 then
     write_pic(file,temp_image)
    else
      puts(1,"\n could not save")
      sleep(2)
    end if
  end if
end procedure

draw_pos(1,1,1)
draw_colors(0,560)

integer button1,button2,button3,button4,button5,button6,button7,button8,button9
button1=create({"button",550,20,"zoom (-)"})
button2=create({"button",550,50,"zoom (+)"})
button3=create({"button",550,80,"mode (m)"})
button4=create({"button",550,110,"new  (n)"})
button5=create({"button",550,140,"open (o)"})
button6=create({"button",550,170,"save (s)"})
button7=create({"button",550,260,"exit (e)"})
button8=create({"button",550,200,"soid (f)"})
button9=create({"button",550,230,"grid (g)"})
integer button10,button11,button12
button10=create({"button",650,20,"rotate (r)"})
button11=create({"button",650,50,"filp v (v)"})
button12=create({"button",650,80,"filp h (h)"})

procedure row()
sequence temp
integer l
l=0
  temp=temp_image
  l=height_p
  for i=1 to height_p do
     for j=1 to width_p do
        temp_image[l][j]=temp[j][i]
     end for
    l-=1
  end for
end procedure

procedure flip_h()
  for i=1 to length(temp_image) do
     temp_image[i]=reverse(temp_image[i])
  end for
end procedure

procedure flip_v()
temp_image=reverse(temp_image)
end procedure

procedure keys()
  if key='v' then
    flip_v()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='h' then
    flip_h()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='r' then
    row()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='+' then
    if zoom_x*height_p<500 then
    zoom_x+=1
    zoom_y+=1
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
    end if
  end if
  if key='-' then
    if zoom_x>1 then
    zoom_x-=1
    zoom_y-=1
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
    end if
  end if
  if key='m' then
    mode+=1
    if mode=5 then
      mode=1
    end if
    draw_colors(0,560)
  end if
  if key='f' then
    if soid=0 then
      soid=1
    else
      soid=0
    end if
    draw_colors(0,560)
  end if
  if key='n' then
    position(2,2)
    if compare(prompt_string("Start New Image Yes or NO? "),"y") =0 then
      new()
    end if
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='s' then
    save()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='o' then
    open_pic()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='e' then
    position(2,2)
    if compare(prompt_string("Do You Want To Exit Yes or NO? "),"y") =0 then
      position(1,1)
      clear_screen()
      if graphics_mode(18) then
      end if
      abort(0)
    end if
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if key='g' then
    if grid2=0 then
      grid2=1
    else
      grid2=0
    end if
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
end procedure

procedure commands()
  if on_click({"button",button1})=1 then
    if zoom_x>1 then
    zoom_x-=1
    zoom_y-=1
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
    end if
  end if
  if on_click({"button",button2})=1 then
    if zoom_x*height_p<500 then
    zoom_x+=1
    zoom_y+=1
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
    end if
  end if
  if on_click({"button",button3})=1 then
    mode+=1
    if mode=5 then
      mode=1
    end if
    draw_colors(0,560)
  end if
  if on_click({"button",button4})=1 then
    position(2,2)
    if compare(prompt_string("Start New Image Yes or NO? "),"y") =0 then
      new()
    end if
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button5})=1 then
    open_pic()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button6})=1 then
    save()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button7})=1 then
    position(2,2)
    if compare(prompt_string("Do You Want To Exit Yes or NO? "),"y") =0 then
      position(1,1)
      clear_screen()
      if graphics_mode(18) then
      end if
      abort(0)
    end if
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button8})=1 then
    if soid=0 then
      soid=1
    else
      soid=0
    end if
    draw_colors(0,560)
  end if
  if on_click({"button",button9})=1 then
    if grid2=0 then
      grid2=1
    else
      grid2=0
    end if
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button10})=1 then
    row()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button11})=1 then
    flip_v()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
  if on_click({"button",button12})=1 then
    flip_h()
    cls()
    draw_colors(0,560)
    draw_pos(x1,y1,1)
  end if
end procedure

integer bm1,bm2,bm3,bm4
image={}
load_images("a_up.pic")
bm1=create({"button_image",600,400,{image[1][1],image[2][1]}})
image={}
load_images("a_l.pic")
bm2=create({"button_image",576,424,{image[1][1],image[2][1]}})
image={}
load_images("a_d.pic")
bm3=create({"button_image",600,424,{image[1][1],image[2][1]}})
image={}
load_images("a_r.pic")
bm4=create({"button_image",624,424,{image[1][1],image[2][1]}})

image={}
load_images("aa.pic")
temp_image=image[1][1]
height_p=length(temp_image)
zoom_x=6
zoom_y=6
width_p=length(temp_image[1])
t_x=1
t_y=1
t_c=0
x1=1
y1=1
color=-1
cls()
draw_pos(1,1,1)
draw_colors(0,560)

while 1 do
key=get_key()
if key != -1 then
 keys()
 if key=27 then
  exit
 end if
end if
mouse()
draw_mouse()
sel_color(0,560)
button_dos()
button_image_dos()
commands()
end while
