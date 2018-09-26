include machine.e
include graphics.e
include file.e
include get.e

sequence code, men_info, var_info,temp, buffer
temp={}
men_info={{0}}
var_info={{0}}
atom key, number1, number2, test, number11, number22, test2, number111
atom number222, test3, number1111, number2222, help_can
sequence line, d, drive, line2, d2, line3, d3, line4, help_text
integer com
help_can=1
line={}
line2={}
line3={}
line4={}
drive="a:\\"

clear_screen()
if graphics_mode(258) then
 temp= "need VGA graphics"
end if

help_text = {{"dir exsample dir a:dir"},
             {"del exsample del a:file"},
             {"make_path exsample make_path a:dir"},
             {"del_path exsample del_path a:dir"},
             {"edit exsample edit a:file"},
             {"write_men exsmaple write_men id a:file"},
             {"read_men exsample read_men id a:file"},
             {"del_men exsample del id"},
             {"copy exsample copy a:file a:file"},
             {"load_file exsample load_file a:file"},
             {"help exsample help"},
             {"exit exsample exit"}}

 function merge_sort(sequence x)
 -- put x into ascending order using a recursive merge sort
     integer n, mid
     sequence merged, a, b
          n = length(x)
     if n = 0 or n = 1 then
         return x  -- trivial case
     end if
          mid = floor(n/2)
     a = merge_sort(x[1..mid])       -- sort first half of x
     b = merge_sort(x[mid+1..n])     -- sort second half of x
          -- merge the two sorted halves into one
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

procedure quit()
bk_color(BLACK)
clear_screen()
if graphics_mode(3) then
 temp="need VGA graphics"
end if
-- clears info men
for i=2 to length(var_info) do
 free(var_info[i][2])
end for
for i=2 to length(men_info) do
 free(men_info[i][1])
end for
?buffer
abort(1)
end procedure

procedure write_file_men(sequence string, sequence file_name)
atom addres
sequence info, string2
integer size
info={}
string2=""
size=0
for i=1 to length(string) do
size += length(string[i])
if i=1 then 
 string2&=string[i]  
elsif i>1 then
 string2&=string[i] 
end if
end for
addres = allocate(size)
poke(addres,string2)
men_info= append(men_info,{addres,size,file_name})
end procedure

procedure del(sequence string)
sequence var
var={}
for i=2 to length(men_info) do
  if compare(men_info[i][3], string) = 0 then
    free(men_info[i][1])
  else
  var =append(var, men_info[i])
  end if
end for
men_info={}
men_info=var
end procedure

function read_file_men(sequence string)
sequence var
for i=2 to length(men_info) do
  if compare(men_info[i][3], string) = 0 then
   var=peek({men_info[i][1],men_info[i][2]})
  end if
end for
return var
end function

procedure var_set(sequence string, sequence string2)
atom addres, size
size=length(string2)
addres=allocate(size)
poke(addres,string2)
var_info = append(var_info,{string,addres,size})
end procedure

function var_get(sequence string)
sequence var
for i=2 to length(var_info) do
  if compare(var_info[i][1],string)=0 then
   var=peek({var_info[i][2],var_info[i][3]})
  end if
end for
return var
end function

procedure gaz()
bk_color(BLUE)
clear_screen()
position(1,3)
puts(1,"Command line")
position(2,3)
puts(1,"=========================")
position(4,3)
puts(1,"=========================")
position(6,3)
puts(1,"window one")
position(6,20)
puts(1,"window two")
position(6,40)
puts(1,"window three")
position(7,3)
puts(1,"drive "&drive)
if help_can=1 then
for i=number1111 to length(help_text)-number2222 do
 position(20+i-number1111,3)
 puts(1,help_text[i][1])
end for
end if
for i=number111 to length(line3)-number222 do
 position(9+i-number111,40)
 puts(1,line3[i])
end for
for i=number11 to length(line2)-number22 do
 position(9+i-number11,20)
 puts(1,line2[i])
end for
for i=number1 to length(line)-number2 do
 position(9+i-number1,3)
 puts(1,line[i])
end for
 position(5,3)
 puts(1,temp)
end procedure

function read_file(sequence string)
sequence buffer
object line
integer fn
fn = open(string, "rb")
 if fn = -1 then
 temp= "could not open file "&string
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

procedure write_file(sequence string, sequence string1)
integer fn
fn = open(string, "wb")
 if fn = -1 then
  temp="Couldn't open file "&string
  end if
for i=1 to length(string1) do
puts(fn,string1[i])
end for
close(fn)
end procedure

function code_input(sequence string)
sequence line, temp
integer pos
line={}
temp={}
pos=1
for i=1 to length(string) do
  if string[i]= 32 then
   for j=pos to i-1 do
    temp &=string[j]
   end for
  pos =i+1
  line= append(line,temp)
  temp={}
  end if
 end for
 return line
end function

procedure init()
line={}
line2={}
line3={}
line4={}
for i=2 to length(men_info) do
  line3 = append(line3, men_info[i][3])
end for
d2 = dir(drive)
for i=1 to length(d2) do
  test2= compare(d2[i][2],"d") 
  if test2 = 0 then
   line2= append(line2,d2[i][1])
  end if
end for
d = dir(drive)
for i=1 to length(d) do
  test= compare(d[i][2],"d") 
  if test != 0 then
   line= append(line,d[i][1])
  end if
end for
line=merge_sort(line)
line2=merge_sort(line2)
number1111=1
number2222=0
if length(help_text)>16 then
 number2222=length(help_text)-16
end if
number111=1
number222=0
if length(line3)>8 then
 number222=length(line3)-8
end if
number11=1
number22=0
if length(line2)>8 then
 number22=length(line2)-8
end if
number1=1
number2=0
if length(line)>8 then
 number2=length(line)-8
end if
end procedure

function line_number(sequence string)
object line
integer fn, number
number=0
fn = open(string, "rb")
 if fn = -1 then
 temp= "could not open file "&string
 end if
while 1 do
 line = gets(fn)
 if atom(line) then
  exit   
 end if
 number+=1
end while
return number
end function

buffer={}
procedure load_file(sequence string)
sequence string2, string3, string4, string5
integer number, pos
string3={}
string4={}
string5={}
number=line_number(string)
string2=read_file(string)

for i=1 to length(string2) do
  string3= append(string3,string2[i][1..length(string2[i])-2])
end for

for i=1 to length(string3) do
  pos=1
  for j=1 to length(string3[i]) do
    if string3[i][j]= 32 then
      string4= append(string4, string3[i][pos..j-1])
      pos=j+1
    end if
    if j=length(string3[i]) then
      string4= append(string4, string3[i][pos..j])
    end if
  end for
string5=append(string5,{string4[i]})
end for
buffer=string5
for i=1 to length(string5) do
call_proc(com,{string5[i]})
end for
gaz()
end procedure

procedure all_write()
sequence men_file
for i=1 to length(line) do
men_file={}
men_file=read_file(line[i])
write_file_men(men_file,"file")
end for
init()
end procedure

procedure commands(sequence string)
atom exit1, copy1, drive1, help1, write_men,set,get,read_men,del1,dos1,dos2,dos3
atom dos4, load,all
sequence copy2, men_file
exit1 = compare(string[1],"exit")
copy1 = compare(string[1],"copy")
drive1= compare(string[1],"dir")
help1= compare(string[1],"help")
write_men = compare(string[1],"write_men")
read_men = compare(string[1],"read_men")
set=compare(string[1],"var_set")
get=compare(string[1],"var_get")
del1=compare(string[1],"del_men")
dos1=compare(string[1],"del")
dos2=compare(string[1],"make_path")
dos3=compare(string[1],"del_path")
dos4=compare(string[1],"edit")
load=compare(string[1],"load_file")
all=compare(string[1],"write_all")

if load=0 then
load_file(string[2])
init()
end if

if all=0 then
all_write()
end if

if dos1=0 then
system("del "&string[2],0)
init()
end if

if dos2=0 then
system("mkdir "&string[2],0)
init()
end if

if dos3=0 then
system("rmdir "&string[2],0)
init()
end if

if dos4=0 then
system("call c:\\edit.com "&string[2],0)
init()
end if

if help1=0 then
 if help_can=1 then
  help_can=0
 else
  help_can=1
 end if
end if

if del1=0 then
 del(string[2])
 init()
end if

if write_men=0 then
 men_file=read_file(string[3])
 write_file_men(men_file,string[2])
 init()
end if

if read_men=0 then
 copy2=read_file_men(string[2])
 write_file(string[3],copy2)
end if

if set=0 then
 var_set(string[2],string[3])
end if

if get=0 then
 temp=var_get(string[2])
end if

if exit1=0 then
 quit()
end if

if drive1=0 then
 drive=string[2]
 init()
end if

if copy1=0 then
 copy2=read_file(string[2])
 write_file(string[3],copy2)
end if
end procedure

com = routine_id("commands")
bk_color(BLUE)
init()
gaz()

procedure main()
    while 1 do
     key=get_key()
     if key != -1 then
      if key = 27 then
        quit()
      end if
      if key = 328 then
        if number1>1 then
         number1-=1
         number2+=1
         gaz()
        end if
        if number11>1 then
         number11-=1
         number22+=1
         gaz()
        end if
        if number11>1 then
         number111-=1
         number222+=1
         gaz()
        end if
        if number1111>1 then
         number1111-=1
         number2222+=1
         gaz()
        end if
       end if
      if key = 336 then
        if number2>0 then 
        number1+=1
        number2-=1
        gaz()
        end if
        if number22>0 then 
        number11+=1
        number22-=1
        gaz()
        end if
        if number222>0 then 
        number111+=1
        number222-=1
        gaz()
        end if
        if number2222>0 then 
        number1111+=1
        number2222-=1
        gaz()
       end if
      end if
      if key = 99 then
       position(3,3)
       code=prompt_string("enter code ")
       code&=" "
       code=code_input(code)
       commands(code)
       clear_screen()
       gaz()
      end if
     end if
    end while
end procedure

main()
bk_color(BLACK)
clear_screen()
