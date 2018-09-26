without type_check
include graphics.e
include machine.e
include get.e
include image.e

if graphics_mode(18) then
end if
atom key, line_number, can,err_line
err_line=0
key=0
can=0
line_number=1
sequence commands, var_goto, var_info, var_bitmap, var_string, var_array_info
sequence string_array_info
string_array_info={}
var_array_info={}
var_string={}
var_goto={}
commands={}
var_info={}
var_bitmap={}
-----------------------
--core system
-----------------------
procedure err(sequence msg)
bk_color(BLACK)
clear_screen()
position(1,1)
puts(1,"err on line ")
print(1,err_line)
puts(1,"\n"&msg&"\n")
abort(1)
end procedure

procedure goto(sequence name)
atom can
can=0
for i=1 to length(var_goto) do
if compare(var_goto[i][1],name)=0 then
line_number=var_goto[i][2] 
can=1
end if
end for
if can=0 then
  err("goto lable '"&name&"' dose not exists")
end if
end procedure

function real2(sequence a)
sequence pos
atom var, var2, var3, var4, var5
var=0
var2=0
var3=0
var4=0
var5=0
pos={}
for i=1 to length(a) do
if a[i]='0' then
pos=append(pos,0)
elsif a[i]='1' then
pos=append(pos,1)
elsif a[i]='2' then
pos=append(pos,2)
elsif a[i]='3' then
pos=append(pos,3)
elsif a[i]='4' then
pos=append(pos,4)
elsif a[i]='5' then
pos=append(pos,5)
elsif a[i]='6' then
pos=append(pos,6)
elsif a[i]='7' then
pos=append(pos,7)
elsif a[i]='8' then
pos=append(pos,8)
elsif a[i]='9' then
pos=append(pos,9)
end if
end for
if length(pos)=1 then
var=pos[1]
elsif length(pos)=2 then
var=10*pos[1]
var+=pos[2]
elsif length(pos)=3 then
var2=100*pos[1]
var3=10*pos[2]
var=var2+var3
var+=pos[3]
elsif length(pos)=4 then
var2=1000*pos[1]
var3=100*pos[2]
var4=10*pos[3]
var=var2+var3+var4
var+=pos[4]
elsif length(pos)=5 then
var2=10000*pos[1]
var3=1000*pos[2]
var4=100*pos[3]
var5=10*pos[4]
var=var2+var3+var4+var5
var+=pos[5]
end if
return var
end function
--------------------------
--var system  integer string
--------------------------
procedure add_var(sequence name, atom v)
for i=1 to length(var_info) do
if compare(var_info[i][1],name) =0 then
err("var "&name&" all ready exists")
end if
end for
var_info=append(var_info,{name,v})
end procedure

procedure add_var_array(sequence name, atom size, atom v)
sequence temp
temp={}
for i=1 to length(var_array_info) do
if compare(var_array_info[i][1],name) =0 then
err("in array var "&name&" all ready exists")
end if
end for
for i=1 to size do
temp=append(temp,v)
end for
var_array_info=append(var_array_info,{name,temp})
end procedure

procedure add_string(sequence name, sequence string)
for i=1 to length(var_string) do
if compare(var_string[i][1],name) =0 then
err("string "&name&" all ready exists")
end if
end for
var_string=append(var_string,{name,string})
end procedure

procedure add_string_array(sequence name,atom p, sequence string)
sequence temp
temp={}
for i=1 to length(var_string) do
  if compare(var_string[i][1],name) =0 then
    err("in array string "&name&" all ready exists")
  end if
end for
for i=1 to p do
temp=append(temp,string)
end for
string_array_info=append(string_array_info,{name,temp})
end procedure

procedure set_var(sequence name, atom v)
atom can
can=0
for i=1 to length(var_info) do
if compare(var_info[i][1],name) =0 then
var_info[i][2]=v
can=1
end if
end for
if can=0 then
  err("in set var var dose not exits "&name)
end if
end procedure

procedure set_var_array(sequence name, atom p, atom v)
atom can
can=0
for i=1 to length(var_array_info) do
if compare(var_array_info[i][1],name) =0 then
var_array_info[i][2][p]=v
can=1
end if
end for
if can=0 then
  err("in set var array var dose not exits "&name)
end if
end procedure

procedure set_string(sequence name, sequence string)
atom can
can=0
for i=1 to length(var_string) do
if compare(var_string[i][1],name) =0 then
var_string[i][2]=string
can=1
end if
end for
if can=0 then
  err("in set string string dose not exists "&name)
end if
end procedure

procedure set_string_array(sequence name, atom p, sequence string)
atom can
can=0
for i=1 to length(string_array_info) do
if compare(string_array_info[i][1],name) =0 then
string_array_info[i][2][p]=string
can=1
end if
end for
if can=0 then
  err("in set string array var dose not exits "&name)
end if
end procedure

procedure plus_var(sequence name1, atom b)
atom a, can
can=0
for i=1 to length(var_info) do
if compare(var_info[i][1],name1) =0 then
a=var_info[i][2]
a+=b
var_info[i][2]=a
can=1
end if
end for
if can=0 then
  err("in plus var var dose not exists "&name1)
end if
end procedure

procedure plus_var_array(sequence name1,atom p, atom b)
atom a, can
can=0
for i=1 to length(var_array_info) do
if compare(var_array_info[i][1],name1) =0 then
a=var_array_info[i][2][p]
a+=b
var_array_info[i][2][p]=a
can=1
end if
end for
if can=0 then
  err("in plus_var_array varb dose not exists "&name1)
end if
end procedure

procedure times_var(sequence name1, atom b)
atom a, can, c
can=0
for i=1 to length(var_info) do
if compare(var_info[i][1],name1) =0 then
a=var_info[i][2]
c=a*b
var_info[i][2]=c
can=1
end if
end for
if can=0 then
  err("in times var var dose not exists "&name1)
end if
end procedure

procedure plus_string(sequence name,sequence string)
atom can
sequence a
can=0
for i=1 to length(var_string) do
if compare(var_string[i][1],name) =0 then
a=var_string[i][2]
a&=string
var_string[i][2]=a
can=1
end if
end for
if can=0 then
  err("in plus string string dose noy exists "&name)
end if
end procedure

procedure min_var(sequence name1, atom b)
atom a, can
can=0
for i=1 to length(var_info) do
if compare(var_info[i][1],name1) =0 then
a=var_info[i][2]
a-=b
var_info[i][2]=a
can=1
end if
end for
if can=0 then
  err("in min var var dose not exitst "&name1)
end if
end procedure

procedure min_var_array(sequence name1,atom p, atom b)
atom a, can
can=0
for i=1 to length(var_array_info) do
if compare(var_array_info[i][1],name1) =0 then
a=var_array_info[i][2][p]
a-=b
var_array_info[i][2][p]=a
can=1
end if
end for
if can=0 then
  err("in min_var_array varb dose not exists "&name1)
end if
end procedure

procedure string_length(sequence name, sequence name1)
atom can, can2, size
can=0
can2=0
for i=1 to length(var_string) do
if compare(var_string[i][1],name) =0 then
size=length(var_string[i][2])
can=1
end if
end for
if can=0 then
  err("in string length string dose not exists "&name)
end if
for i=1 to length(var_info) do
if compare(var_info[i][1],name1) =0 then
var_info[i][2]=size
can2=1
end if
end for
if can2=0 then
  err("in string length var dose not exists "&name1)
end if
end procedure

procedure string_insert(sequence name, atom pos, sequence insert2, sequence string2)
sequence a,b
atom insert
atom can
insert=insert2[1]
can=0
for i=1 to length(var_string) do
 if compare(var_string[i][1],name) =0 then
   if length(string2)>0 then
   a=string2[1..pos]
   b=string2[pos+1..length(string2)]
   string2=a&insert&b
   var_string[i][2]=string2
   end if
   if length(string2)=0 then
   var_string[i][2]=string2&insert
   end if
   can=1
 end if
end for
if can=0 then
  err("in string_insert string dose noy exists "&name)
end if
end procedure

procedure string_remove(sequence name, atom pos, sequence string2)
sequence temp
atom can,pos1
can=0
temp=""
for i=1 to length(var_string) do
   if compare(var_string[i][1],name) =0 then
     for j=1 to length(string2) do
        if pos!=j then
          temp&=string2[j]
         end if
     end for
    pos1=i
    can=1
   end if
end for
if can=0 then
  err("in string_remove string dose noy exists "&name)
end if
string2=temp
var_string[pos1][2]=string2
end procedure

function if_string_char(sequence name, sequence string, atom pos, sequence goto_name)
atom can
sequence text
can=0
for i=1 to length(var_string) do
if compare(var_string[i][1],name) =0 then
text=var_string[i][2]
can=1
end if
end for
if can=0 then
  err("in if_string_char string dose not exists "&name)
end if
if pos<=0 then
  err("in if_string_char pos is 0 our smallhere")
end if
for i=pos to pos+1 do
   if compare(string[1],text[i])=0 then
     goto(goto_name)
     return 1
    else
     return -1
    end if
end for
end function

function if_vars_same(atom m, atom a, atom b, sequence name3)
if m=1 then
if a=b then
goto(name3)
return 1
else
return -1
end if
elsif m=2 then
if a!=b then
goto(name3)
return 1
else
return -1
end if
elsif m=3 then
if a>=b then
goto(name3)
return 1
else
return -1
end if
elsif m=4 then
if a<=b then
goto(name3)
return 1
else
return -1
end if
elsif m=5 then
if a>b then
goto(name3)
return 1
else
return -1
end if
elsif m=6 then
if a<b then
goto(name3)
return 1
else
return -1
end if
end if
err("dont no in if_var")
end function

function if_string(atom m, sequence string, sequence string1, sequence goto_name)
if m=1 then
  if compare(string,string1)=0 then
    goto(goto_name)
    return 1
  else
  return -1
  end if
end if
err("dont no in if_sting")
end function
--------------------------
-- draw system
--------------------------
procedure draw_var(atom x, atom y, atom text)
position(y,x)
print(1,text)
end procedure

procedure draw_string(atom x, atom y, sequence text)
position(y,x)
puts(1,text)
end procedure

procedure draw_line2(atom x, atom y, atom xx, atom yy, atom color)
draw_line(color,{{x,y},{xx,yy}})
end procedure

procedure draw_rectangle(atom x, atom y, atom xx, atom yy, atom color, atom fill)
polygon(color, fill, {{x, y}, {xx, y}, {xx, yy},{x,yy}})
end procedure
---------------------------
--bitmap system
---------------------------
procedure load_pic(sequence pic_name, sequence name)
object x
sequence image
for i=1 to length(var_bitmap) do
if compare(var_bitmap[i][1],name) =0 then
err("bitmap "&name&" all ready exists")
end if
end for
x = read_bitmap(pic_name)
image=x[2]
var_bitmap=append(var_bitmap,{name,image})
end procedure

procedure draw_pic(sequence name, atom x, atom y)
atom can
can=0
for i=1 to length(var_bitmap) do
if compare(var_bitmap[i][1],name) =0 then
  display_image({x,y},var_bitmap[i][2])
  can=1
end if
end for
if can=0 then
  err("in draw pic pic dose not exits "&name)
end if
end procedure
---------------------------
--input system
---------------------------
function if_key(atom keys, sequence name)
if key !=-1 then
if keys=key then
goto(name)
return 1
end if
end if
return -1
end function

procedure keyborad_string(sequence name)
atom can
can=0
if key != -1 then
 if key >2 and key <256 then
   if key!=128 and key!=64 and key!=27 and key!=16 and key!=13 and key!=8 and key!=4 then
     for i=1 to length(var_string) do
     if compare(var_string[i][1],name) =0 then
     var_string[i][2]&=key
     can=1
     end if
     end for
     if can=0 then
     err("in keyborad_string string dose not exists "&name)
     end if
   end if
 end if
end if
end procedure

procedure wait_in()
while 1 do
key=get_key()
   if key!=-1 then
     if key=27 then
     abort(0)
     end if
     exit
   end if
end while
end procedure

procedure get_in(sequence name)
atom can
can=0
if key!=-1 then
for i=1 to length(var_info) do
if compare(var_info[i][1],name) =0 then
var_info[i][2]=key
can=1
end if
end for
if can=0 then
  err("in get key var dose not exits "&name)
end if
end if
end procedure
--------------------------
--load file and run commands system
--------------------------
function read_file(sequence string)
sequence buffer
object line
integer fn
fn = open(string, "rb")
if fn = -1 then
end if
buffer = {}
while 1 do
line = gets(fn)
if atom(line) then
exit   
end if
buffer = append(buffer, line)
end while
return buffer
end function

sequence file_name, file_text
file_name="1.txt"
file_text=read_file(file_name)
for i=1 to length(file_text) do
for j=1 to length(file_text[i]) do
if file_text[i][j]=10 then
file_text[i][j]=0
end if
if file_text[i][j]=13 then
file_text[i][j]=32
end if
end for
end for   

procedure run(sequence string)
atom pos
sequence command
pos=1
command={}
for i=1 to length(string) do
for j=1 to length(string[i]) do
if string[i][j]=32 then
command=append(command, string[i][pos..j-1])
pos=j+1
end if
end for
commands=append(commands,command)
command={}
pos=1
end for
for i=1 to length(commands) do
if compare(commands[i][1],"lable")=0 then
var_goto=append(var_goto,{commands[i][2],i})
end if
end for
end procedure

function cheek_var2(sequence string)
sequence info, name, name2
sequence pos,pos1,true
atom time
true={}
time=0
pos={}
pos1={}
name2={}
name={}
info={{0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0}}
for i=1 to length(string) do
   for j=1 to length(var_info) do
      if compare(var_info[j][1],string[i])=0 then
        info[i][1]=var_info[j][2]
        info[i][2]=1 
       end if
    end for
   if info[i][2]=0 then
     info[i][1]=real2(string[i])
   end if
end for

for i=1 to length(string) do
   for j=1 to length(string[i]) do
      if string[i][j]=91 then
        pos=append(pos,j)
        pos1=append(pos1,i)
        time+=1
      end if
      if string[i][j]=93 then
        name=append(name, string[i][pos[time]+1..j-1])
        name2=append(name2, string[i][1..pos[time]-1])
      end if
   end for
end for
for i=1 to length(name2) do
   for j=1 to length(var_array_info) do
     if compare(var_array_info[j][1],name2[i])=0 then
       for l=1 to length(var_info) do
             if compare(var_info[l][1],name[i])=0 then
               info[pos1[i]][1]=var_array_info[j][2][var_info[l][2]]
               info[pos1[i]][2]=1
               true=append(true,name[i])
             end if
       end for
     end if
   end for
end for
for i=1 to length(name2) do
   for j=1 to length(var_array_info) do
     if compare(var_array_info[j][1],name2[i])=0 then
       if info[pos1[i]][2]=0 then
       info[pos1[i]][1]=var_array_info[j][2][real2(name[i])]
       info[pos1[i]][2]=0
       end if
     end if
   end for
end for
return info
end function

function cheek_string(sequence string)
sequence info, name, name2
sequence pos,pos1,true
atom time
true={}
time=0
pos={}
pos1={}
name2={}
name={}
info={{"",0},
      {"",0},
      {"",0},
      {"",0},
      {"",0},
      {"",0}}
for i=1 to length(string) do
   for j=1 to length(var_string) do
      if compare(var_string[j][1],string[i])=0 then
        info[i][1]=var_string[j][2]
        info[i][2]=1 
      end if
   end for
   if info[i][2]=0 then
   info[i][1]=string[i]
   end if
end for
for i=1 to length(string) do
   for j=1 to length(string[i]) do
      if string[i][j]=91 then
        pos=append(pos,j)
        pos1=append(pos1,i)
        time+=1
      end if
      if string[i][j]=93 then
        name=append(name, string[i][pos[time]+1..j-1])
        name2=append(name2, string[i][1..pos[time]-1])
      end if
   end for
end for
for i=1 to length(name2) do
   for j=1 to length(string_array_info) do
     if compare(string_array_info[j][1],name2[i])=0 then
       for l=1 to length(var_info) do
             if compare(var_info[l][1],name[i])=0 then
               info[pos1[i]][1]=string_array_info[j][2][var_info[l][2]]
               info[pos1[i]][2]=1
               true=append(true,name[i])
             end if
       end for
     end if
   end for
end for
for i=1 to length(name2) do
   for j=1 to length(string_array_info) do
     if compare(string_array_info[j][1],name2[i])=0 then
       if info[pos1[i]][2]=0 then
       info[pos1[i]][1]=string_array_info[j][2][real2(name[i])]
       info[pos1[i]][2]=0
       end if
     end if
   end for
end for
return info
end function

procedure run_commands()
atom gaz
sequence info, info_string
gaz=0
can=0
for i=line_number to length(commands) do
err_line=i
--------------------
--var
--------------------
if compare(commands[i][1],"add_var")=0 then
info=cheek_var2({"",commands[i][3]})
add_var(commands[i][2],info[2][1])
end if
if compare(commands[i][1],"set_var")=0 then
info=cheek_var2({"",commands[i][3]})
set_var(commands[i][2],info[2][1])
end if
if compare(commands[i][1],"plus_var")=0 then
info=cheek_var2({"",commands[i][3]})
plus_var(commands[i][2],info[2][1])
end if
if compare(commands[i][1],"times_var")=0 then
info=cheek_var2({"",commands[i][3]})
times_var(commands[i][2],info[2][1])
end if
if compare(commands[i][1],"min_var")=0 then
info=cheek_var2({"",commands[i][3]})
min_var(commands[i][2],info[2][1])
end if
-----------------------
--var arrary
-----------------------
if compare(commands[i][1],"add_var_array")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4]})
add_var_array(commands[i][2],info[2][1],info[3][1])
end if
if compare(commands[i][1],"set_var_array")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4]})
set_var_array(commands[i][2],info[2][1],info[3][1])
end if
if compare(commands[i][1],"plus_var_array")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4]})
plus_var_array(commands[i][2],info[2][1],info[3][1])
end if
if compare(commands[i][1],"min_var_array")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4]})
min_var_array(commands[i][2],info[2][1],info[3][1])
end if
----------------------------
--string
----------------------------
if compare(commands[i][1],"add_string")=0 then
info=cheek_var2({"",""})
info_string=cheek_string({"",commands[i][3]})
add_string(commands[i][2],info_string[2][1])
end if
if compare(commands[i][1],"set_string")=0 then
info=cheek_var2({"",""})
info_string=cheek_string({"",commands[i][3]})
set_string(commands[i][2],info_string[2][1])
end if
if compare(commands[i][1],"plus_string")=0 then
info=cheek_var2({"",""})
info_string=cheek_string({"",commands[i][3]})
plus_string(commands[i][2],info_string[2][1])
end if
-------------------------------
--string array
-------------------------------
if compare(commands[i][1],"add_string_array")=0 then
info=cheek_var2({"",commands[i][3],""})
info_string=cheek_string({"","",commands[i][4]})
add_string_array(commands[i][2],info[2][1],commands[i][4])
end if
if compare(commands[i][1],"set_string_array")=0 then
info=cheek_var2({"",commands[i][3],""})
info_string=cheek_string({"","",commands[i][4]})
set_string_array(commands[i][2],info[2][1],info_string[3][1])
end if
----------------------------------
--draw
----------------------------------
if compare(commands[i][1],"draw_string")=0 then
info=cheek_var2({commands[i][2],commands[i][3],""})
info_string=cheek_string({"","",commands[i][4]})
draw_string(info[1][1],info[2][1],info_string[3][1])
end if
if compare(commands[i][1],"draw_line")=0 then
info=cheek_var2({commands[i][2],commands[i][3],commands[i][4],commands[i][5],commands[i][6]})
draw_line2(info[1][1],info[2][1],info[3][1],info[4][1],info[5][1])
end if
if compare(commands[i][1],"draw_rectangle")=0 then
info=cheek_var2({commands[i][2],commands[i][3],commands[i][4],commands[i][5],commands[i][6],commands[i][7]})
draw_rectangle(info[1][1],info[2][1],info[3][1],info[4][1],info[5][1],info[6][1])
end if
if compare(commands[i][1],"draw_var")=0 then
info=cheek_var2({commands[i][2],commands[i][3],commands[i][4]})
draw_var(info[1][1],info[2][1],info[3][1])
end if
if compare(commands[i][1],"cls")=0 then
clear_screen()
end if
if compare(commands[i][1],"bc")=0 then
info=cheek_var2({commands[i][2]})
bk_color(info[1][1])
end if
if compare(commands[i][1],"fc")=0 then
info=cheek_var2({commands[i][2]})
text_color(info[1][1])
end if
---------------------------------
--bitmap
---------------------------------
if compare(commands[i][1],"load_pic")=0 then
info_string=cheek_string({commands[i][2],""})
load_pic(info_string[1][1],commands[i][3])
end if
if compare(commands[i][1],"draw_pic")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4]})
draw_pic(commands[i][2],info[2][1],info[3][1])
end if
----------------------------------
--user input
----------------------------------
if compare(commands[i][1],"keyborad_string")=0 then
keyborad_string(commands[i][2])
end if
if compare(commands[i][1],"get_key")=0 then
get_in(commands[i][2])
end if
if compare(commands[i][1],"wait_key")=0 then
wait_in()
end if
--------------------------------
--string function
--------------------------------
if compare(commands[i][1],"string_insert")=0 then
info=cheek_var2({"",commands[i][3],commands[i][4],""})
info_string=cheek_string({"","",commands[i][4],commands[i][5]})
string_insert(commands[i][2],info[2][1],info_string[3][1],info_string[4][1])
end if
if compare(commands[i][1],"string_remove")=0 then
info=cheek_var2({"",commands[i][3],""})
info_string=cheek_string({"","",commands[i][4]})
string_remove(commands[i][2],info[2][1],info_string[3][1])
end if
if compare(commands[i][1],"string_length")=0 then
string_length(commands[i][2],commands[i][3])
end if
-----------------------------------
--if then goto
----------------------------------
if compare(commands[i][1],"if_key")=0 then
info=cheek_var2({commands[i][2],""})
gaz= if_key(info[1][1],commands[i][3])
if gaz=1 then
can=1
exit
end if 
end if
if compare(commands[i][1],"if_var")=0 then
info=cheek_var2({commands[i][2],commands[i][3],commands[i][4],""})
gaz=if_vars_same(info[1][1],info[2][1],info[3][1],commands[i][5])
if gaz=1 then
can=1
exit
end if 
end if
if compare(commands[i][1],"if_string")=0 then
info=cheek_var2({commands[i][2],"","",""})
info_string=cheek_string({"",commands[i][3],commands[i][4],""})
gaz=if_string(info[1][1],info_string[2][1],info_string[3][1],commands[i][5])
if gaz=1 then
can=1
exit
end if 
end if
if compare(commands[i][1],"if_string_char")=0 then
info=cheek_var2({"","",commands[i][4],""})
info_string=cheek_string({"",commands[i][3],"",""})
gaz=if_string_char(commands[i][2],info_string[2][1],info[3][1],commands[i][5])
if gaz=1 then
can=1
exit
end if 
end if
------------------------------------
--mise
------------------------------------
if compare(commands[i][1],"exit")=0 then
bk_color(BLACK)
clear_screen()
abort(0)
end if
if compare(commands[i][1],"goto")=0 then
goto(commands[i][2])
can=1
exit
end if
end for
end procedure

run(file_text)
run_commands()

while 1 do
key=get_key()
if key != -1 then
 if key=27 then
  exit
 end if
end if
if can=1 then
run_commands()
end if
end while
if graphics_mode(18) then
end if
bk_color(BLACK)
clear_screen()
