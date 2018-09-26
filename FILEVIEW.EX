without type_check
include graphics.e
include mouse2.e
include font.e
include file.e
include image.e

atom key, get_button,fileview_number,selete,draw_all,drive,back_dir,same_dir
back_dir=0
same_dir=0
draw_all=0
get_button=0
sequence fileview_info,new_dir
new_dir={}
drive=0
selete=1
fileview_number=1
fileview_info={}
sequence file_names, file_images,image_1
image_1={}
file_images={}
file_names={"EX","TXT","BMP","F","back"}

object bitmap
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])
bitmap=read_bitmap("exe.bmp")
file_images=append(file_images,bitmap[2])

bitmap=read_bitmap("exe2.bmp")
image_1=bitmap[2]
sequence temp_dir
temp_dir=current_dir()

if graphics_mode(259) then
end if

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

global function remove_line(sequence string, atom line)
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

function add_line(sequence string, atom line)
sequence temp
temp={}
  for i=1 to length(string) do
     if i=line then
     temp=append(temp,string[i])
     temp=append(temp,"")
     else
     temp=append(temp,string[i])
     end if
  end for
return temp
end function

function back_dir1()
sequence temp, info, name
atom pos
info={}
name=""
temp=current_dir()&{92}
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

procedure fileview()
atom x,y,width,height,draw,sel,image_width,image_height,number1,number2,init
atom temp_x,temp_y,temp_width,ok,last,timer1,t,pressed,sel_x,sel_y,sel_mx,sel_my
atom timer2
sequence string,sel_name
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

      if get_button=mb_right_up then
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
                        system("copy /b "&sel_name&" "&current_dir()&string[j][1..k-1],2)
                        system("del "&sel_name,2)
                        rectangle(1,1,800,600,-1,1)
                        same_dir=1
                      else
                        system("copy /b "&sel_name&" "&current_dir()&{92}&string[j][1..k-1],2)
                        system("del "&sel_name,2)
                        rectangle(1,1,800,600,-1,1)
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
             if sel_y<y+2 then
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
             if sel_y>y+height-20 then
             if number1<length(string)-((image_height*image_width)+image_width) then
             number1+=image_width
             number2-=image_width
             sel_y=height-20
             timer2=time()+.30
             draw=1
             else
             if number2>0 then
             last=number2
             number1+=number2
             number2=0
             sel_y=height-20
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
                   elsif compare(file_names[l],"back")=0 then
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
                     new_dir=string[j]
                   elsif compare(file_names[l],"back")=0 then
                     back_dir=1
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


     if init=1 then
       if length(string)>image_height*image_width then
         number2=length(string)-image_height*image_width
       end if
       init=0
     end if

     if key=328 then
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
     end if

     if key=336 then
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
     end if

     if draw=1 then
       temp_x=0
       temp_y=0
       temp_width=0
       ok=0
       rectangle(x,y,x+width,y+height,-1,1)
       rectangle(x,y,x+width,y+height,0,0)
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
     temp_x=0
     temp_y=0
     ok=0
     temp_width=0
  end for
end procedure

atom test
sequence d,line1
procedure init()
test=0
d={}
line1={}

  d = dir(current_dir())
  for i=1 to length(d) do
  test= compare(d[i][2],"d") 
  if test!=0 then
  line1=append(line1,d[i][1])
  end if
  end for

  test=0
  d={}

  d = dir(current_dir())
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
   line1=prepend(line1,"back.back")

end procedure
init()
fileview_number+=1
fileview_info=append(fileview_info,{10,10,300,200,line1,1,0,1,0,1,0,0,0,"",0,0,0,0,0,fileview_number})
rectangle(1,1,800,600,-1,1)


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


function next_dir()
sequence temp, info
atom pos
info={}
temp=current_dir()&{92}
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
  return current_dir()&new_dir
end if
drive=0
return current_dir()&"\\"&new_dir
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
fileview()
if back_dir=1 then
   if chdir(back_dir1())=1 then
     back_dir=0
     init()
     fileview_info[1][5]=line1
     fileview_info[1][6]=1
     fileview_info[1][7]=0
     fileview_info[1][8]=1
     fileview_info[1][9]=0
     fileview_info[1][10]=1
     fileview_info[1][11]=0
    end if
end if
if same_dir=1 then
  init()
  fileview_info[1][5]=line1
  fileview_info[1][6]=1
  fileview_info[1][7]=0
  fileview_info[1][8]=1
  fileview_info[1][9]=0
  fileview_info[1][10]=1
  fileview_info[1][11]=0
  same_dir=0
end if
if length(new_dir)>0 then
  for i=1 to length(new_dir) do
     if new_dir[i]='.' then
       new_dir=new_dir[1..i-1]
       exit
     end if
  end for
    if chdir(next_dir())=1 then
      new_dir={}
      init()
     fileview_info[1][5]=line1
     fileview_info[1][6]=1
     fileview_info[1][7]=0
     fileview_info[1][8]=1
     fileview_info[1][9]=0
     fileview_info[1][10]=1
     fileview_info[1][11]=0
    end if
end if
end while

if chdir(temp_dir)=1 then
end if

