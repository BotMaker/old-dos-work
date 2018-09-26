without type_check
include graphics.e
include machine.e
include get.e

if graphics_mode(18) then
end if

sequence file_name, file_text

sequence commands, var_info, string_info, sys, list_procedure,var_goto
var_goto={}
list_procedure={"draw_line","if_var","while"}
commands={}
var_info={}
string_info={}
sys={}
atom key, err_line, line_number, can
can=1
err_line=0
line_number=1
key=0

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

file_name="1.txt"
file_text=read_file(file_name)

function if_string(sequence string)
   if string[1]>= 65 and string[1]<=122 or string[1] =34 then
     return 1
   end if
return 0
end function

function string_remove(sequence string, atom chr)
sequence temp, temp2
for i=1 to length(string) do
   if string[i]=chr then
     temp=string[1..i-1]
     temp2=string[i+1..length(string)]
     string=temp&temp2
     return string
   end if
end for
return string
end function

procedure run(sequence string)
sequence temp
temp={}
--removes all the chrs 32 13 10
for i=1 to length(string) do
   for k=1 to length(string[i]) do
      for j=1 to length(string[i]) do
         if string[i][j]=32 then
           string[i]=string_remove(string[i],32)
           exit
         end if
         if string[i][j]=13 then
           string[i]=string_remove(string[i],13)
           exit
         end if
         if string[i][j]=10 then
           string[i]=string_remove(string[i],10)
           exit
         end if
      end for
   end for
end for
sys=string
end procedure

procedure err(sequence msg)
bk_color(BLACK)
clear_screen()
position(1,1)
puts(1,"err on line ")
print(1,err_line)
puts(1,"\n"&msg[1]&"\n")
position(4,1)
puts(1,"in command ")
position(5,1)
puts(1,"\n"&msg[2]&"\n")
abort(1)
end procedure

function real(sequence a)
sequence pos
atom var, var2, var3, var4, var5
var=0
var2=0
var3=0
var4=0
var5=0
pos={}
if atom(a) then
  return a
end if
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
  err({"goto lable "&name&" dose not exists","goto"})
end if
end procedure


--------------------------
--var system  
--------------------------
procedure add_var(sequence name, atom v)
for i=1 to length(var_info) do
if compare(var_info[i][1],name) =0 then
err({"var "&name&" all ready exists","add_var"})
end if
end for
var_info=append(var_info,{name,v})
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
  err({"var dose not exits "&name,"set_var"})
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
  err({"var dose not exists "&name1,"plus_var"})
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
  err({"var dose not exitst "&name1,"min_var"})
end if
end procedure

procedure add_string(sequence name, sequence string)
for i=1 to length(string_info) do
if compare(string_info[i][1],name) =0 then
err({"string "&name&" all ready exists","add_string"})
end if
end for
string_info=append(string_info,{name,string})
end procedure

procedure set_string(sequence name, sequence string)
atom can
can=0
for i=1 to length(string_info) do
if compare(string_info[i][1],name) =0 then
string_info[i][2]=string
can=1
end if
end for
if can=0 then
  err({"string dose not exists "&name,"set_string"})
end if
end procedure

procedure plus_string(sequence name1, sequence b)
atom can
sequence a
can=0
for i=1 to length(string_info) do
if compare(string_info[i][1],name1) =0 then
a=string_info[i][2]
a&=b
string_info[i][2]=a
can=1
end if
end for
if can=0 then
  err({"var dose not exists "&name1,"plus_string"})
end if
end procedure

procedure draw_line2(atom x, atom y, atom xx, atom yy, atom color)
draw_line(color,{{x,y},{xx,yy}})
end procedure

function if_var_exsits(sequence name)
for i=1 to length(var_info) do
  if compare(var_info[i][1],name) =0 then
    return 1
  end if
end for
return 0
end function

function if_procedure(sequence name)
for i=1 to length(list_procedure) do
  if compare(list_procedure[i],name) =0 then
    return 1
  end if
end for
return 0
end function

function get_arguments(sequence string)
sequence temp
atom arg,pos
pos=1
temp={}
arg=0
for i=1 to length(string) do
  if string[i]=',' then
    arg+=1
  end if
end for
if arg=0 then
temp=append(temp,string[2..length(string)-1])
else
for i=1 to arg+1 do
   for j=pos to length(string) do
      if string[j]=',' and i=1 then
        temp=append(temp,string[2..j-1])
        pos=j+1
        exit
      end if

      if string[j]=',' then
        temp=append(temp,string[pos..j-1])
        pos=j+1
        exit
      end if

      if i=arg+1 then
        temp=append(temp, string[pos..length(string)-1])
        pos=j+1
        exit
      end if

   end for
end for
end if
return temp
end function

function if_string_exsits(sequence name)
for i=1 to length(string_info) do
  if compare(string_info[i][1],name) =0 then
    return 1
  end if
end for
return 0
end function

run(file_text)

procedure rem3()
sequence temp
temp={}
for i=1 to length(sys) do
   if length(sys[i])=0 then

   else
   temp=append(temp,sys[i])

   end if
end for
sys=temp
end procedure
rem3()

function while_do(sequence mode, atom a, atom b, sequence goto_name,sequence goto_name2)
if mode[1]=1 then
if a=b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
end if
end function

function if_var(sequence mode, atom a, atom b, sequence goto_name,sequence goto_name2)
if mode[1]=1 then
if a=b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
elsif mode[1]=2 then
if a!=b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
elsif mode[1]=3 then
if a>=b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
elsif mode[1]=4 then
if a<=b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
elsif mode[1]=5 then
if a>b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
elsif mode[1]=6 then
if a<b then
goto(goto_name)
return 1
else
goto(goto_name2)
return 0
end if
end if
err("dont no in if_var")
end function

function check_var(sequence name)
sequence info
info={{0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0}}
for i=1 to length(name) do
   for j=1 to length(var_info) do
      if compare(var_info[j][1],name[i])=0 then
        info[i][1]=var_info[j][2]
        info[i][2]=1 
       end if
    end for
   if info[i][2]=0 then
     if length(name[i])=0 then
       info[i][1]=real(name[i])
     else
       if if_string(name[i])=0 then
         info[i][1]=real(name[i])
       else
         err({"var dose not exsits "&name[i],"check_var"})
       end if
     end if
   end if
end for
return info
end function

function check_string(sequence name)
sequence info
atom ok
ok=0
info={{"",0},
      {"",0},
      {"",0},
      {"",0},
      {"",0},
      {"",0}}
for i=1 to length(name) do
   for j=1 to length(string_info) do
      if compare(string_info[j][1],name[i])=0 then
        info[i][1]=string_info[j][2]
        info[i][2]=1 
      end if
   end for
   if info[i][2]=0 then
   --info[i][1]=name[i]
     if length(name[i])=0 then
     else
      for k=1 to length(name[i]) do
         if name[i][k]=34 then
           ok=1
           info[i][1]=name[i][1..k-1]
           exit
         end if
      end for
      if ok=0 then
       if if_string_exsits(name[i])=1 then
         info[i][1]=name[i]
       else
         err({"var not exits "&name[i],"check_string"})
       end if
      end if
      end if
   end if
end for
return info
end function

procedure check_1(atom line)
atom info
--for the = commamd for var
  info=if_var_exsits(commands[line][2])
  if info=1 and compare(commands[line][1],"add_var")=0 then
    commands[line][1]="set_var"
  end if

--for the = commamd for string
  info=if_string_exsits(commands[line][2])
  if info=1 and compare(commands[line][1],"add_string")=0 then
    commands[line][1]="set_string"
 end if
end procedure

procedure command()
sequence info_var, info_string
atom gaz
gaz=0
can=0
for i=line_number to length(commands) do
check_1(i)
err_line=i
if compare(commands[i][1],"add_var")=0 then
info_var=check_var({"",commands[i][3]})
add_var(commands[i][2],info_var[2][1])
end if
if compare(commands[i][1],"set_var")=0 then
info_var=check_var({"",commands[i][3]})
set_var(commands[i][2],info_var[2][1])
end if
if compare(commands[i][1],"plus_var")=0 then
info_var=check_var({"",commands[i][3]})
plus_var(commands[i][2],info_var[2][1])
end if
if compare(commands[i][1],"min_var")=0 then
info_var=check_var({"",commands[i][3]})
min_var(commands[i][2],info_var[2][1])
end if
if compare(commands[i][1],"add_string")=0 then
info_var=check_var({"",""})
info_string=check_string({"",commands[i][3]})
add_string(commands[i][2],info_string[2][1])
end if
if compare(commands[i][1],"set_string")=0 then
info_var=check_var({"",""})
info_string=check_string({"",commands[i][3]})
set_string(commands[i][2],info_string[2][1])
end if
if compare(commands[i][1],"plus_string")=0 then
info_var=check_var({"",""})
info_string=check_string({"",commands[i][3]})
plus_string(commands[i][2],info_string[2][1])
end if
if compare(commands[i][1],"draw_line")=0 then
info_var=check_var({commands[i][2],commands[i][3],commands[i][4],commands[i][5],commands[i][6]})
info_string=check_string({""})
draw_line2(info_var[1][1],info_var[2][1],info_var[3][1],info_var[4][1],info_var[5][1])
end if
if compare(commands[i][1],"if_var")=0 then
info_var=check_var({"",commands[i][3],commands[i][4],"",""})
info_string=check_string({""})
gaz=if_var(commands[i][2],info_var[2][1],info_var[3][1],commands[i][5],commands[i][6])
can=1
exit
end if
if compare(commands[i][1],"while_do")=0 then
info_var=check_var({"",commands[i][3],commands[i][4],"",""})
info_string=check_string({""})
gaz=while_do(commands[i][2],info_var[2][1],info_var[3][1],commands[i][5],commands[i][6])
can=1
exit
end if
if compare(commands[i][1],"goto")=0 then
goto(commands[i][2])
can=1
exit
end if
end for
end procedure

sequence agl, bgl,cgl
cgl="c"
agl="a"
bgl="b"

-- for the if var command gets arg
procedure doo()
sequence temp
atom nest
nest=0
 for i=1 to length(sys) do
   for j=1 to length(sys[i]) do
      if length(sys[i])>5 then
      if compare(sys[i][1..6],"if_var")=0 then
        for x=1 to length(sys[i]) do
           if sys[i][x]=61 then
             sys[i][x]=1
             exit
           end if
        end for
          temp={}
          if sys[i+1][1] = '{' then
          for k=i to length(sys) do
             if length(sys[k])>0 and sys[k][1]='}' then
               for h=1 to length(sys[i]) do
                 if sys[i][h]=')'then
                  temp=sys[i][1..h-1]
                  exit
                end if
               end for
               temp&=","&agl&","&bgl&")"
               sys[i]=temp
               sys[i+1]="^"&agl
               sys[k]="^"&bgl
               agl&="a"
               bgl&="b"
               exit  
             end if
          end for
        end if
      end if
      end if
   end for
end for
end procedure
-- for the while do command

sequence temp_sys,temp_sys2
temp_sys={}
temp_sys2={}
procedure add(atom line)
for i=1 to length(sys) do
   if i=line then
   temp_sys=append(temp_sys,{i})
   else
   end if
end for
end procedure

procedure add4(atom line)
for i=1 to length(sys) do
   if i=line then
   temp_sys2=append(temp_sys2,{i})
   else
   end if
end for
end procedure

procedure add2(atom line)
sequence temp
temp={}
for i=1 to length(sys) do
   if i=line then
   temp=append(temp,{})
   temp=append(temp,sys[i])
   else
   temp=append(temp,sys[i])
   end if
end for
sys=temp
end procedure

procedure add3(atom line)
sequence temp
temp={}
for i=1 to length(sys) do
   if i=line then
   temp=append(temp,sys[i])
   temp=append(temp,{})
   else
   temp=append(temp,sys[i])
   end if
end for
sys=temp
end procedure


for i=1 to length(sys) do
   if length(sys[i])>4 then
     if compare(sys[i][1..5],"while")=0 then
       add(i+1)
     end if
   end if
end for

for i=1 to length(sys) do
   if length(sys[i])>8 then
     if compare(sys[i][1..9],"end_while")=0 then
       add4(i)
     end if
   end if
end for

for i=1 to length(temp_sys) do
   add2(temp_sys[i][1])
end for
for i=1 to length(temp_sys2) do
   add3(temp_sys2[i][1])
end for

procedure doo2()
sequence temp
temp={}
for i=1 to length(sys) do
temp={}
   for j=1 to length(sys[i]) do
      if length(sys[i])>4 then
        if compare(sys[i][1..5],"while")=0 then
          for k=1 to length(sys[i]) do
             if sys[i][k]=61 then
               sys[i][k]=1
               exit
             end if
          end for
          temp={}
          for l=1 to length(sys[i]) do
             if sys[i][l]=')'then
               temp=sys[i][1..l-1]
               exit
             end if
          end for
          for m=i to length(sys) do
           if length(sys[m])>8 then
             if compare(sys[m][1..9],"end_while")=0 then

            temp&=","&agl&","&bgl&")"
            sys[i]=temp
            sys[m]="^"&bgl
            sys[i+1]="^"&agl
            sys[m-1]="~"&agl
            agl&="a"
            bgl&="b"
            cgl&="c"
  --          puts(1,sys[i])
            --abort(0)
            temp={}
            exit
           end if
           end if
          end for
        end if
      end if
   end for
end for
end procedure

doo()
doo2()

sequence side_one, side_two, side_three
side_one={}
side_two={}
side_three={}
-- this bit working with = += -= and all commands
atom need
sequence need_pos, temp
temp={}
need_pos={}
need=0
for i=1 to length(sys) do
need_pos={}
need=0
err_line=i
   for j=1 to length(sys[i]) do
need_pos={}
need=0
temp={}      -- =
      if sys[i][j]=61 and sys[i][j-1]!=43 and sys[i][j-1]!=45 then
        side_one=append(side_one,sys[i][1..j-1])
        if if_string(sys[i][1..j-1])=0 then
          err({"its not a var "&sys[i][1..j-1],"init"})
        end if
        side_two=append(side_two,{61})
        side_three=append(side_three,sys[i][j+1..length(sys[i])])
        if sys[i][j-1]='%'then 
        commands=append(commands,{"add_var",sys[i][1..j-1],sys[i][j+1..length(sys[i])]})
        end if
        if sys[i][j-1]='$' then 
          if if_string(sys[i][j+1..length(sys[i])])=0 then
          err({"its not a var "&sys[i][j+1..length(sys[i])],"init"})
          end if
          for k=j to length(sys[i]) do
             if sys[i][k]=34 then
               need+=1
               need_pos=append(need_pos,k)
             end if
          end for
          if need=2 then
            commands=append(commands,{"add_string",sys[i][1..j-1],sys[i][j+2..need_pos[2]]})---1
          else
            if need=1 then
              err({"mising one string quot "&sys[i][1..j-1],"init"})
            end if
          end if
          if need>2 then
             err({"two meay string quot "&sys[i][1..j-1],"init"})
          end if
          if need=0 then
            commands=append(commands,{"add_string",sys[i][1..j-1],sys[i][j+1..length(sys[i])]})
          end if
        end if
      end if
need_pos={}
need=0
      -- +=
      if sys[i][j]=43 and sys[i][j+1]=61 then
        side_one=append(side_one,sys[i][1..j-1])
        if if_string(sys[i][1..j-1])=0 then
          err({"its not a var "&sys[i][1..j-1],"init"})
        end if
        side_two=append(side_two,{43,61})
        side_three=append(side_three,sys[i][j+2..length(sys[i])])
        if sys[i][j-1]='%' then
        commands=append(commands,{"plus_var",sys[i][1..j-1],sys[i][j+2..length(sys[i])]})
        end if
        if sys[i][j-1]='$' then
          if if_string(sys[i][j+2..length(sys[i])])=0 then
            err({"its not a var "&sys[i][j+2..length(sys[i])],"init2"})
          end if
          for k=j to length(sys[i]) do
             if sys[i][k]=34 then
               need+=1
               need_pos=append(need_pos,k)
             end if
          end for
          if need=2 then
            commands=append(commands,{"plus_string",sys[i][1..j-1],sys[i][j+3..need_pos[2]]})
          else
            if need=1 then
              err({"mising one string quot "&sys[i][1..j-1],"init"})
            end if
          end if
          if need>2 then
             err({"two meay string quot "&sys[i][1..j-1],"init"})
          end if
          if need=0 then
            commands=append(commands,{"plus_string",sys[i][1..j-1],sys[i][j+3..length(sys[i])]})
          end if
        end if
      end if
      -- -=
      if sys[i][j]=45 and sys[i][j+1]=61 then
        side_one=append(side_one,sys[i][1..j-1])
        if if_string(sys[i][1..j-1])=0 then
          err({"its not a var "&sys[i][1..j-1],"init"})
        end if
        side_two=append(side_two,{45,61})
        side_three=append(side_three,sys[i][j+2..length(sys[i])])
        commands=append(commands,{"min_var",sys[i][1..j-1],sys[i][j+2..length(sys[i])]})
      end if
temp={}


           if sys[i][j]='^' then
             var_goto=append(var_goto,{sys[i][j+1..length(sys[i])],i})
--             commands=append(commands,{"lable"})
           end if
           if sys[i][j]='~' then
             commands=append(commands,{"goto",sys[i][j+1..length(sys[i])]})
           end if
         

      -- procedures
      if sys[i][j]='(' then
        if if_procedure(sys[i][1..j-1])=1 then
          for k=j to length(sys[i]) do
             if sys[i][k]=')' then
               temp=get_arguments(sys[i][j..k])
               if compare(sys[i][1..j-1],"draw_line")=0 then
                 commands=append(commands,{"draw_line",temp[1],temp[2],temp[3],temp[4],temp[5]})
               end if
               if compare(sys[i][1..j-1],"if_var")=0 then
                 commands=append(commands,{"if_var",temp[2],temp[1],temp[3],temp[4],temp[5]})
               end if
               if compare(sys[i][1..j-1],"while")=0 then
                 commands=append(commands,{"while_do",temp[2],temp[1],temp[3],temp[4],temp[5]})
               end if
             end if
          end for
        end if
      end if
    end for
end for

while 1 do
key=get_key()
if key != -1 then
 if key=27 then
  exit
 end if
end if
if can=1 then
command()
end if
end while
bk_color(BLACK)
clear_screen()
sequence te
?te
