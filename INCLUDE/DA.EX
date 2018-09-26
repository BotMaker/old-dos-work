without type_check
global atom key
include engine.e

screen2={}
new_screen(-1)

if graphics_mode(18) then
end if

atom button1, temp_button, temp_number, can
sequence buttons
temp_number=1
buttons={}
can=0

button1=create_ex({"button","add button",1,1})

procedure move()
if can=1 then
  set_x({"button",temp_button,mouse_x})
  set_y({"button",temp_button,mouse_y})
  if mouse_button=mb_left then
    can=0
  end if
end if
end procedure

while 1 do
key=get_key()
if key != -1 then
  if key=27 then
    if show_q("do you want to exit","about gaz")=1 then
      exit
    end if
  end if
end if
draw_screen()
move()
--draw_text({1,1},sprint(get_width({"button",button1})),0,7,0,{0,0})
if on_click({"button",button1})=1 then
  temp_button=create_ex({"button","button "&sprint(temp_number),1,1})
  buttons=append(buttons,temp_number)
  can=1
  temp_number+=1
end if
end while
