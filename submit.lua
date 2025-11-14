--[[pod_format="raw",created="2024-12-28 01:40:48",modified="2025-11-14 04:20:52",revision=9393]]
webinclude"https://raw.githubusercontent.com/piconet-picotron/piconet-home/refs/heads/main/lib3d.lua"
rotation_order = {"z", "x", "y", "t"}

cube_model = unpod("b64:bHo0AMoBAADMBQAAgCJ2IC0wLjUwAQAPCgABKFxuIQAPIAAND0EAItBmIDMvMyAxLzEgNC80DwAACwAyMi8yDwAfdjQAAAUTAAkfAA4eAA89ACvQZiA3LzcgNS81IDgvOA8AAAsAMjYvNg8AD-cAAw-2AAwOHwAPPwAk8AJmIDExLzExIDkvOSAxMi8xMhMAAQ0ARDAvMTATAA--AAIfLQABAg8fAAwfLT8AIPEEZiAxNS8xNSAxMy8xMyAxNi8xNhUAAg8ARDQvMTQVAA-tAAwvdiAeAAcPPQBBHy3jAAwPPwA28gNmIDE5LzE5IDE3LzE3IDIwLzIVAAEPAFYxOC8xOBUA8QEyMy8yMyAyMS8yMSAyNC8yKgMDDwBHMi8yMhUAADMABD8AMjIvMnYBAg8ARjQvMjUVAAA-ABE4WgASN4oAARUAAg8AAoQAAhUACOcADvEACecADh8ADz8ARB8tQAAMHy1BADjxA2YgMjcvMzEgMjUvMjkgMjgvM3ADAw8ARjYvMzAVAPIBMzEvMzUgMjkvMzMgMzIvM2kBAg8ARzAvMzQVAAAzAAM-AAAbAAFkBAMPAEcyLzM3FQBBOS80MFoAEjmKAARpABQ5hABQNy8zMSI=")
star_model = unpod("b64:bHo0AE8BAABJAwAAviJ2IDAuMDkwOTgyCQAnXG4eAB8tHwACHy0gABYPXgALDkcACR8AHy0gAAMfLSEAFw9hAAYBAQAICQARNQkADx4AAx8tHwACBRYABSkACz4ADx4AAA40AAs9AA8eAAfQZiAxLzEgNC80IDkvOQ8AAAsANDMvMw8AAAsANDIvMg8AAAsAADEAAw8A0TgvMTUgNS81IDEwLzFOAAANADY2LzYRAAANADc3LzESAAEOAAE6AAU2AABmAJU3LzcgMTEvMTEkAAFIAAQSAAANAAF_AAQRAAANAAA4AAURAACYAAGMAEQyLzEyjAACaAAEEgAxOC844QAFEQABDQAmLzERAABSAAEVAEQzLzEzIgAANwAFEQAADQABrAAEEQAADQABiQAEEQAAmgABvABENC8xNLwAAZoABBEAAQ0AAHcABBEAAA0AoDIvMiAxNC8xNCI=")
tanbtn_gfx = 
--[[pod_type="gfx"]]unpod("b64:bHo0AC0AAAA2AAAA_hBweHUAQyAEDQQQHxUADhUOFQ8WDgUdDgUNDw8OBQ0MBACQHQ4VDQAOFRAe")
local registering
local domain = ""
local password = ""
local newdomain
local new_password
local btitle
local description
local urlroot
local homepage
local tags
local deleted
local report
local submit_successful
local domain_len = 16 --max lengths also enforced on piconet server
local title_len = 32
local desc_len = 128
local tag_len = 16
local max_tags = 8
local allowed_domain_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_."


title = "Manage Domain"
_init = function()
	wireframe:init()
	interface:init()
end
_update = function()
	w,h = page_size()
	center_x = w/2
	center_y = h/2
	mx,my = mouse()
	cmx,cmy = mx-center_x,my-center_y
	if mx>0 and mx<w and my>0 and my<h then
		wireframe:set_rot_offset(cmy/1000,cmx/1000)
	else
		wireframe:set_rot_offset(0,0)
	end
	wireframe:update()
	interface.gui:update_all()
	interface:update()
end
_draw = function()
	cls(1)
	wireframe:draw()
	interface.gui:draw_all()
	color(7)
	print(debug, 0,0,7)
end

interface = {
	gui = create_gui({
		x=0,y=28,width=300,height=172,
		update = function(self)
			self.width = w
			self.height = h
		end
	}),
	current_menu = 1,
	next_menu = 1,
	init = function(self)
		self.gui:attach(self.menus[self.current_menu])
		self.menus[self.current_menu]:post_switch()
	end,
	update = function(self)
		if self.current_menu!=self.next_menu then
			local curr_menu = self.menus[self.current_menu]
			local nxt_menu = self.menus[self.next_menu]
			if curr_menu.z < 10 then
				self.gui:detach(curr_menu)
			end
			nxt_menu:update()
			if nxt_menu.z > 10 and count(self.gui.child,nxt_menu) == 0 then
				self.gui:attach(nxt_menu)
			end
			if nxt_menu.z > 10 and curr_menu.z < 10 then
				self.current_menu = self.next_menu
				if nxt_menu.post_switch then
					nxt_menu:post_switch()
				end
			end
		end
	end,
	switch_menu = function(self,index)
		self.menus[self.current_menu].ghost = true
		self.next_menu = index
		self.menus[self.next_menu].ghost = false
		if self.menus[index].pre_switch then
			self.menus[index]:pre_switch()
		end
		wireframe:set_goal(self.menus[index].norm_rx, self.menus[index].norm_ry)
	end
}

--interface.gui:attach_button{label="rotate y", y=20, release=function(self)
--	wireframe:set_goal(wireframe.gx, wireframe.gy+math.pi/2)
--end}
--
--interface.gui:attach_button{label="rotate x", y=40, release=function(self)
--	wireframe:set_goal(wireframe.gx+math.pi/2, wireframe.gy)
--end}

function create_gui3d(props)
	function props:set_rot(rx,ry,rz,rx2,ry2,rz2)
		local pos = self.og_pos
		local trans_pos = pos:matmul3d(mat_transformation(vec(center_x-(self.width*0.5)+1,center_y-(self.height*0.5)+1,0), vec(rx+rx2,ry+ry2,rz+rz2)))
		self.width = self.og_width * abs(math.cos(ry+self.norm_ry))
		self.height = self.og_height * abs(math.cos(rx+self.norm_rx))
		self.x = trans_pos.x+self.width*0.5-center_x
		self.y = trans_pos.y+self.height*0.5-center_y
		self.z = trans_pos.z
	end
	props.norm_rx = props.norm_rx or 0
	props.norm_ry = props.norm_ry or 0
	local custom_update = props.update
	function props:update()
		custom_update(self)
		for c in all(self.child) do
			c.x = (c.x_frac or 0) * self.width
			c.y = (c.y_frac or 0) * self.height
			c.width = (c.width_frac or 1) * self.width
			c.height = (c.height_frac or 1) * self.height
		end
		self:set_rot(wireframe.rx,wireframe.ry,0,wireframe.rxoff,wireframe.ryoff,wireframe.rzoff)
	end
	props.og_width = props.width
	props.og_height = props.height
	props.og_pos = vec(props.x or 0, props.y or 0, props.z or 0)
	return create_gui(props)
end

function bind_editor_enter_to_button_tap(editor,button)
	editor.key_callback = {
		enter = function()
			if not button.ghost then
				button.tap()
			end
		end
	}
end

function set_frac_anchors(gui, parent)
	local parent = parent or gui.parent
	gui.x_frac = gui.x/parent.width
	gui.y_frac = gui.y/parent.height
	gui.width_frac = gui.width/parent.width
	gui.height_frac = gui.height/parent.height
end

function create_tan_button(props,action)
	props.label = props.label or "[no label]"
	local temp_gui = create_gui({width = 500}) -- silly ik lmao
	local btn_for_width = temp_gui:attach_button({label = props.label})
	props.width = props.width or btn_for_width.width
	props.height = 13
	
	local btn = create_gui(props)
	
	btn.ghost = false
	
	btn.tap = action
	
	function btn:update()
	end
	
	function btn:draw(msg)
--		camera(-self.x,-self.y)
		if msg.has_pointer then
			pal(15,7)
			pal(16,12)
			if msg.mb > 0 then
				pal()
				pal(self.fgcol,1)
				pal(5,21)
				pal(22,5)
				pal(15,5)
			end
		end	
		
		if self.ghost then
			pal(self.fgcol,5)
			pal(21,1)
			pal(5,21)
			pal(22,21)
			pal(15,21)
		end
		
		rect(4,0,self.width-5,self.height-1,21)
		rect(4,1,self.width-5,self.height-2,5)
		rect(4,2,self.width-5,self.height-3,22)
		rectfill(4,3,self.width-5,self.height-4,15)
		print(self.label, 5,3, self.fgcol)
		spr(tanbtn_gfx,self.width-4,0,true)
		spr(tanbtn_gfx)
		
		pal()
	end
	btn.cursor = "pointer"
	return btn
end

function create_gradient_textbox(props)
	local gui = create_gui(props)
	gui.custom_update = props.update
	
	function gui:draw(msg)
		rectfill(3,3,self.width-4,self.height-4,26)
		print(self.labelprint,6,5,self.fgcol or 0)
		rect(0,0,self.width-1,self.height-1,19)
		rect(1,1,self.width-2,self.height-2,3)
		rect(2,2,self.width-3,self.height-3,27)
	end
	
	gui.label = props.label or "[no label text]"
	
	function gui:update()
		if self.custom_update then
			self:custom_update()
		end
		local words = split(self.label," ")
		self.labelprint = ""
		for w in all(words) do
			local append = w.." "
			local wx = print(self.labelprint..append,4,-5000)
			if wx > self.width-5 then
				self.labelprint = self.labelprint.."\n"..append
			else
				self.labelprint = self.labelprint..append
			end
		end
	end
	
	
	return gui
end

function attach_letter_input(el)
	return el:attach{x=0,y=1,z=0,
		width = 8,
		height = 13,
		width_frac=1/12, height_frac=1/12, x_frac=10/12, y_frac=7/12,
		letter = "p",
		click = function(self)
			self:set_keyboard_focus(true)
		end,
		draw = function(self)
			if self:has_keyboard_focus() then
				color(bgcol or 14)
			else
				color(bgcol2 or 3)
			end
			rectfill(0,0,self.width,self.height)
			print(self.letter,4,2,self.fgcol or 6)
		end,
		update = function(self)
			if (self:has_keyboard_focus()) then
				while (peektext()) do
					local next = readtext()
					if is_letter(next) then
						self.letter = next
					end
				end
			end
		end,
		get_letter = function(self)
			return self.letter
		end,
		set_letter = function(self,letter)
			self.letter = letter[1]
		end,
		cursor = "pointer"
	}
end


--=============
--  GUI
--=============



--==== First menu: submit domain name
domain_submit = create_gui3d({
	x=0,y=0,z=75,width=150,height=150,norm_ry=0,norm_rx=0,
	typed_domain = "",
	post_switch=function(self)
		self.name_ed:set_keyboard_focus(true)
		password = ""
		newdomain = nil
		new_password = nil
		btitle = nil
		description = nil
		urlroot = nil
		homepage = nil
		tags = nil
		deleted = nil
		report = nil
		submit_successful = nil
	end,
	update=function(self)
		local edtxt = string.lower(table.concat(self.name_ed:get_text(),""))
		local topdom = self.letter_in:get_letter()
		if edtxt..topdom != self.typed_domain then
			if #edtxt > domain_len-2 then
				edtxt = sub(edtxt,0,domain_len-2)
				self.name_ed:set_text(edtxt)
			end
			self.typed_domain = edtxt..topdom
			domain_submit.name_info.errmsg = ""
			local invalid = domain_name_is_invalid(edtxt)
			if not invalid then
				dotsgood = true
				local sects = split(edtxt,".")
				for c in all(sects) do
					if #(c.."") < 1 then
						dotsgood = false
					end
				end
				if dotsgood or #edtxt == 0 then
					domain = edtxt.."."..topdom
				else
					domain_submit.name_info.errmsg="Invalid use of dots! They may not be next to other dots."
					domain = ""
				end
			else
				domain_submit.name_info.errmsg="Invalid chars: \""..table.concat(invalid,"\", \"").."\""
				domain = ""
			end
		end
		if domain == nil or #domain <= 2 then
			self.nextbtn.ghost = true
		else
			self.nextbtn.ghost = false
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*7/12)-1,(self.width/12)+(self.width*5/6),(self.height*7/12)+(self.height/12)-1,0)
	end
})
-- info text
domain_submit:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,
	label = "Please enter the name of the domain you wish to create/edit.\n(16 chars max)"
}))
-- next page button
domain_submit.nextbtn = domain_submit:attach(create_tan_button({
	label = next, x = 119, y = 68,fgcol=1,label="next"
},
function()
	interface:switch_menu(2)
end
))
set_frac_anchors(domain_submit.nextbtn)
-- domain text container
domain_submit.name_info = domain_submit:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.27,x_frac=1/12,y_frac = 8/12,fgcol=1,
	label = "",
	errmsg = "",
	update = function(self)
		if self.errmsg == "" and #domain > 2 then
			self.fgcol = 1
			self.label = "Your domain will appear like this:\n".."\""..domain.."\""
		else
			self.fgcol = 8
			self.label = self.errmsg
		end
	end
}))
-- domain name text field
domain_submit.name_ed = domain_submit:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=5/6, height_frac = 1/12, x_frac = 1/12, y_frac = 7/12,
	bgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		domain_submit.name_ed:set_keyboard_focus(true)
	end	
}
domain_submit.name_ed:set_keyboard_focus(true)
domain_submit.letter_in = attach_letter_input(domain_submit)
bind_editor_enter_to_button_tap(domain_submit.name_ed,domain_submit.nextbtn)



--==== Second menu: confirm and submit password
password_submit = create_gui3d({
	x=75,y=0,z=0,width=150,height=150,norm_ry=math.pi/2,norm_rx=0,
	pre_switch = function(self)
		self.info.label = ""
		self.nextbtn.ghost = false
--		assert(false, send_picosnet_request("C+"..domain))
		local registered = send_piconet_request("C+"..domain)
		if registered == "1" then
			registering = false
			self.info.label = "Please enter the password to edit \""..domain.."\""
		elseif registered == "0" then
			registering = true
			self.info.label = "Creating domain. Please enter the desired password for \""..domain.."\""
			self:attach(self.warning)
		else
			self.info.label = "There was an issue connecting to PicoNet services!"
			self.nextbtn.ghost = true
		end
	end,
	post_switch=function(self)
		self.password_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local pwtext = table.concat(self.password_ed:get_text(),"")
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*7/12)-1,(self.width/12)+(self.width*5/6),(self.height*7/12)+(self.height/12)-1,0)
	end
})
--info text
password_submit.info = password_submit:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--password set warning
password_submit.warning = create_gradient_textbox({width=100,height=25,
	width_frac=1.06,height_frac=0.34,x_frac=-0.03,y_frac = 0.69,fgcol=8,label = "VERY IMPORTANT!!! Please DO NOT use a password you use elsewhere; PicoNet services cannot guarantee security."
})
--back button
password_submit.backbtn = password_submit:attach(create_tan_button({
	label = next, x = 0, y = 68,fgcol=1,label="back"
},
function()
	password_submit:detach(password_submit.warning)
	interface:switch_menu(1)
	password = ""
	password_submit.password_ed:set_text("")
	registering = nil
end
))
set_frac_anchors(password_submit.backbtn)
--submit password button
password_submit.nextbtn = password_submit:attach(create_tan_button({
	label = next, x = 109, y = 68,fgcol=1,label="submit"
},
function()
	password = table.concat(password_submit.password_ed:get_text(),"")
	password_submit.password_ed:set_text("")
	if not registering then
		local attempt_login = send_piconet_request("C+"..domain.."*"..pod(password,0x7))
		if attempt_login == "1" then
			interface:switch_menu(3)
		elseif attempt_login == "0" then
			password_submit.info.label = "Incorrect password to edit \""..domain.."\" please try again in 60 seconds"
		else
			password_submit.info.label = "Please wait 60 seconds between password attempts or logins."
			password_submit.password_ed:set_text(password)
		end
	else
		local response = send_piconet_request("P+"..domain.."*"..pod(password,0x7).."*N+"..pod(domain,0x7))
		if response == "REPORT:+N" then
			password_submit:detach(password_submit.warning)
			interface:switch_menu(3)
		else
			password_submit.info.label = "Oops! Couldn't create that domain, the name may have been taken."
		end
	end
end
))
set_frac_anchors(password_submit.nextbtn)
-- password text field
password_submit.password_ed = password_submit:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=5/6, height_frac = 1/12, x_frac = 1/12, y_frac = 7/12,
	bgcol=19,
	fgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		password_submit.password_ed:set_keyboard_focus(true)
	end
}
bind_editor_enter_to_button_tap(password_submit.password_ed,password_submit.nextbtn)

--==== Third menu: domain properties and options
properties_menu = create_gui3d({
	x=0,y=0,z=-75,width=150,height=150,norm_ry=math.pi,norm_rx=0,
	pre_switch = function(self)
		self.info.label = "Select which property you'd like to change for your \""..domain.."\" domain. Do not enter personal information."
	end,
	post_switch=function(self)
	end,
	update=function(self)
	end,
	draw=function(self)
	end
})
--info text
properties_menu.info = properties_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.49,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
properties_menu.backbtn = properties_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="quit"
},
function()
	interface:switch_menu(1)
end
))
set_frac_anchors(properties_menu.backbtn)
--submit button
properties_menu.submitbtn = properties_menu:attach(create_tan_button({
	label = next, x = 68, y = 136,fgcol=1,label="submit changes"
},
function()
	interface:switch_menu(12)
end
))
set_frac_anchors(properties_menu.submitbtn)
btns_l_col = 12
btns_r_col = 137
--domain page button
properties_menu.domainbtn = properties_menu:attach(create_tan_button({
	label = next, x = 0, y = 0,fgcol=1,label="change domain"
},
function()
	interface:switch_menu(4)
end
))
set_frac_anchors(properties_menu.domainbtn)
--default page button
properties_menu.defaultbtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_l_col, y = 85,fgcol=1,label="default page"
},
function()
	interface:switch_menu(10)
end
))
set_frac_anchors(properties_menu.defaultbtn)
--url page button
properties_menu.urlbtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_r_col, y = 85,fgcol=1,label="HTTP root"
},
function()
	interface:switch_menu(5)
end
))
properties_menu.urlbtn.x = btns_r_col - properties_menu.urlbtn.width
set_frac_anchors(properties_menu.urlbtn)
--password page button
properties_menu.passwdbtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_l_col, y = 99,fgcol=1,label="password"
},
function()
	interface:switch_menu(6)
end
))
set_frac_anchors(properties_menu.passwdbtn)
--title page button
properties_menu.titlebtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_r_col, y = 99,fgcol=1,label="title"
},
function()
	interface:switch_menu(7)
end
))
properties_menu.titlebtn.x = btns_r_col - properties_menu.titlebtn.width
set_frac_anchors(properties_menu.titlebtn)
--description page button
properties_menu.descbtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_l_col, y = 113,fgcol=1,label="description"
},
function()
	interface:switch_menu(8)
end
))
set_frac_anchors(properties_menu.descbtn)
--tags page button
properties_menu.tagsbtn = properties_menu:attach(create_tan_button({
	label = next, x = btns_r_col, y = 113,fgcol=1,label="tags"
},
function()
	interface:switch_menu(9)
end
))
properties_menu.tagsbtn.x = btns_r_col - properties_menu.tagsbtn.width
set_frac_anchors(properties_menu.tagsbtn)
--deletion page button
properties_menu.delbtn = properties_menu:attach(create_tan_button({
	label = next, x = 1, y = 0,fgcol=8,label="delete domain"
},
function()
	interface:switch_menu(11)
end
))
properties_menu.delbtn.x = 149 - properties_menu.delbtn.width
set_frac_anchors(properties_menu.delbtn)

--==== Fourth menu: rename domain
ed_domain_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	typed_domain = "",
	pre_switch=function(self)
		self.info.label = "Type a new domain name to switch to. Beware users' cached data will remain under the old domain."
		if not newdomain then
			self.name_ed:set_text("")
			newdomain = ""
		end
	end,
	post_switch=function(self)
		self.name_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local edtxt = string.lower(table.concat(self.name_ed:get_text(),""))
		local topdom = self.letter_in:get_letter()
		if newdomain and edtxt..topdom != self.typed_domain then
			if #edtxt > domain_len-2 then
				edtxt = sub(edtxt,0,domain_len-2)
				self.name_ed:set_text(edtxt)
			end
			self.typed_domain = edtxt..topdom
			ed_domain_menu.name_info.errmsg = ""
			local invalid = domain_name_is_invalid(edtxt)
			if not invalid then
				dotsgood = true
				local sects = split(edtxt,".")
				for c in all(sects) do
					if #c < 1 then
						dotsgood = false
					end
				end
				if dotsgood or #edtxt == 0 then
					newdomain = edtxt.."."..topdom
				else
					ed_domain_menu.name_info.errmsg="Invalid use of dots! They may not be next to other dots."
					newdomain = ""
				end
			else
				ed_domain_menu.name_info.errmsg="Invalid chars: \""..table.concat(invalid,"\", \"").."\""
				newdomain = ""
			end
		end
		if newdomain == nil or #newdomain <= 2 then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*7/12)-1,(self.width/12)+(self.width*5/6),(self.height*7/12)+(self.height/12)-1,0)
	end
})
-- info text
ed_domain_menu.info = ed_domain_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.41,x_frac=1/12,y_frac = 1/12,fgcol=1,
	label = ""
}))
--back button
ed_domain_menu.backbtn = ed_domain_menu:attach(create_tan_button({
	label = next, x = 1, y = 73,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	newdomain = nil
	ed_domain_menu.name_ed:set_text("")
end
))
set_frac_anchors(ed_domain_menu.backbtn)
--confirm button
ed_domain_menu.yesbtn = ed_domain_menu:attach(create_tan_button({
	label = next, x = 1, y = 73,fgcol=1,label="confirm"
},
function()
	local taken = send_piconet_request("C+"..newdomain)
	if taken == "1" then
		ed_domain_menu.name_info.errmsg = "\""..newdomain.."\" has already been taken!"
	elseif taken == "0" then
		interface:switch_menu(3)
	else
		ed_domain_menu.name_info.errmsg = "There was an issue connecting to PicoNet services!"
	end
end
))
ed_domain_menu.yesbtn.x = 148 - ed_domain_menu.yesbtn.width
set_frac_anchors(ed_domain_menu.yesbtn)
-- domain text container
ed_domain_menu.name_info = ed_domain_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.27,x_frac=1/12,y_frac = 8/12,fgcol=1,
	label = "",
	errmsg = "",
	update = function(self)
		if self.errmsg == "" and newdomain and #newdomain > 2 then
			self.fgcol = 1
			self.label = "Your domain will appear like this:\n".."\""..newdomain.."\""
		else
			self.fgcol = 8
			self.label = self.errmsg
		end
	end
}))
-- domain name text field
ed_domain_menu.name_ed = ed_domain_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=5/6, height_frac = 1/12, x_frac = 1/12, y_frac = 7/12,
	bgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		ed_domain_menu.name_ed:set_keyboard_focus(true)
	end	
}
ed_domain_menu.letter_in = attach_letter_input(ed_domain_menu)
bind_editor_enter_to_button_tap(ed_domain_menu.name_ed,ed_domain_menu.yesbtn)


--==== Fifth menu: set root web directory
ed_url_menu = create_gui3d({
	x=-75,y=0,z=0,width=200,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	pre_switch = function(self)
		oldurlroot = ""
		if not urlroot then
			--get url from server
			local url = unpod(send_piconet_request("G+"..domain)) or ""
			self.url_ed:set_text(url)
			oldurlroot = url
		end
		self.info.label = "Enter the web directory root where all of your site files are stored. This may be something like a github repository, but be sure that you're linking to the raw files. Here's an example:"
		self.example.label = "https://raw.githubusercontent.com/ May0san/my-repo/refs/heads/main"
	end,
	post_switch=function(self)
		self.url_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local edtxt = table.concat(self.url_ed:get_text(),"")
		if edtxt != self.typed_url then
			self.typed_url = edtxt
			urlroot = edtxt
		end
		if edtxt == "" then
			urlroot = nil
		end
		if urlroot == nil or urlroot == oldurlroot then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
		rect(0,(self.height*0.81)-1,self.width-1,(self.height*0.81)+(self.height/12)-1,0)
	end
})
--info text
ed_url_menu.info = ed_url_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=3/4,height_frac=0.62,x_frac=1/8,y_frac = 0.01,fgcol=1,label = ""
}))
--example text
ed_url_menu.example = ed_url_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=0.92,height_frac=0.18,x_frac=0.04,y_frac = 0.62,fgcol=1,label = ""
}))
--back button
ed_url_menu.backbtn = ed_url_menu:attach(create_tan_button({
	label = next, x = 26, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	urlroot = nil
	ed_url_menu.url_ed:set_text("")
end
))
set_frac_anchors(ed_url_menu.backbtn)
--confirm button
ed_url_menu.yesbtn = ed_url_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="confirm"
},
function()
	interface:switch_menu(3)
end
))
ed_url_menu.yesbtn.x = 173 - ed_url_menu.yesbtn.width
set_frac_anchors(ed_url_menu.yesbtn)
-- root url text field
ed_url_menu.url_ed = ed_url_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=0.99, height_frac = 1/12, x_frac = 0.005, y_frac = 0.81,
	bgcol=19,
	block_scrolling = false,max_lines = 1,
	release = function()
		ed_url_menu.url_ed:set_keyboard_focus(true)
	end	
}
bind_editor_enter_to_button_tap(ed_url_menu.url_ed,ed_url_menu.yesbtn)


--==== Sixth menu: change password
ed_passwd_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	pre_switch = function(self)
		self.info.label = ""
		self.nextbtn.ghost = false
		self.info.label = "Please enter your new desired password for \""..domain.."\""
		self:attach(password_submit.warning)
		if not new_password then
			self.password_ed:set_text("")
		end
	end,
	post_switch=function(self)
		self.password_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local pwtext = table.concat(self.password_ed:get_text(),"")
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*7/12)-1,(self.width/12)+(self.width*5/6),(self.height*7/12)+(self.height/12)-1,0)
	end
})
--info text
ed_passwd_menu.info = ed_passwd_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--password set warning
ed_passwd_menu.warning = create_gradient_textbox({width=100,height=25,
	width_frac=1.06,height_frac=0.34,x_frac=-0.03,y_frac = 0.69,fgcol=8,label = "VERY IMPORTANT!!! Please DO NOT use a password you use elsewhere; PicoNet services cannot guarantee security."
})
--back button
ed_passwd_menu.backbtn = ed_passwd_menu:attach(create_tan_button({
	label = next, x = 0, y = 68,fgcol=1,label="cancel"
},
function()
	ed_passwd_menu:detach(password_submit.warning)
	interface:switch_menu(3)
	new_password = nil
	ed_passwd_menu.password_ed:set_text("")
end
))
set_frac_anchors(ed_passwd_menu.backbtn)
--submit password button
ed_passwd_menu.nextbtn = ed_passwd_menu:attach(create_tan_button({
	label = next, x = 105, y = 68,fgcol=1,label="confirm"
},
function()
	new_password = table.concat(ed_passwd_menu.password_ed:get_text(),"")
	interface:switch_menu(3)
end
))
set_frac_anchors(ed_passwd_menu.nextbtn)
-- password text field
ed_passwd_menu.password_ed = ed_passwd_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=5/6, height_frac = 1/12, x_frac = 1/12, y_frac = 7/12,
	bgcol=19,
	fgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		ed_passwd_menu.password_ed:set_keyboard_focus(true)
	end
}
bind_editor_enter_to_button_tap(ed_passwd_menu.password_ed,ed_passwd_menu.nextbtn)


--==== Seventh menu: set domain title
ed_title_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	pre_switch = function(self)
		--oldtitle = ""
		if not btitle then
			--get title from server
			local details = split(send_piconet_request("D+"..domain), "\n")
			local current_title = unpod(details[1]) or ""
			self.title_ed:set_text(current_title)
			oldtitle = current_title
		end
		self.info.label = "This is the title your domain will display when users browse the PicoNet."
	end,
	post_switch=function(self)
		self.title_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local edtxt = table.concat(self.title_ed:get_text(),"")
		if edtxt != self.typed_title then
			if #edtxt > title_len then
				edtxt = sub(edtxt,0,title_len)
				self.title_ed:set_text(edtxt)
			end
			self.typed_title = edtxt
			btitle = edtxt
		end
		if edtxt == "" then
			btitle = nil
		end
		if btitle == nil or btitle == oldtitle then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*9/12)-1,(self.width*11/12),(self.height*10/12)-1,0)
	end
})
--info text
ed_title_menu.info = ed_title_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=10/12,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
ed_title_menu.backbtn = ed_title_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	btitle = nil
	ed_title_menu.title_ed:set_text("")
end
))
set_frac_anchors(ed_title_menu.backbtn)
--confirm button
ed_title_menu.yesbtn = ed_title_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="confirm"
},
function()
	interface:switch_menu(3)
end
))
ed_title_menu.yesbtn.x = 148 - ed_title_menu.yesbtn.width
set_frac_anchors(ed_title_menu.yesbtn)
--title text field
ed_title_menu.title_ed = ed_title_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=10/12, height_frac = 1/12, x_frac = 1/12, y_frac = 9/12,
	bgcol=19,
	block_scrolling = false,max_lines = 1,
	release = function()
		ed_title_menu.title_ed:set_keyboard_focus(true)
	end	
}
bind_editor_enter_to_button_tap(ed_title_menu.title_ed,ed_title_menu.yesbtn)


--==== Eighth menu: set description
ed_desc_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	pre_switch = function(self)
		--oldtitle = ""
		if not description then
			--get description from server
			local got = send_piconet_request("D+"..domain) or ""
			local details = split(got, "\n")
			deli(details,1)
			local current_desc = unpod(table.concat(details,"\n")) or ""
			self.desc_ed:set_text(current_desc)
			olddesc = current_desc
		end
	end,
	post_switch=function(self)
		self.desc_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local edtxt = table.concat(self.desc_ed:get_text(),"\n")
		if edtxt != self.typed_desc then
			if #edtxt > desc_len then
				edtxt = sub(edtxt,0,desc_len)
				self.desc_ed:set_text(edtxt)
				self.desc_ed:set_keyboard_focus(false)
			end
			self.typed_desc = edtxt
			description = edtxt
			self.info.label = "This is a description that may be shown when browsing.\n"..#edtxt.."/"..desc_len
		end
		if self.clear then
			description = nil
		end
		self.clear = false
		if description == nil or description == olddesc then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*5.15/12)-1,(self.width*11/12),(self.height*10.15/12),0)
	end
})
--info text
ed_desc_menu.info = ed_desc_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=10/12,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
ed_desc_menu.backbtn = ed_desc_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	description = nil
	ed_desc_menu.clear = true
	ed_desc_menu.desc_ed:set_text("")
end
))
set_frac_anchors(ed_desc_menu.backbtn)
--confirm button
ed_desc_menu.yesbtn = ed_desc_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="confirm"
},
function()
	interface:switch_menu(3)
end
))
ed_desc_menu.yesbtn.x = 148 - ed_desc_menu.yesbtn.width
set_frac_anchors(ed_desc_menu.yesbtn)
--description text field
ed_desc_menu.desc_ed = ed_desc_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=10/12, height_frac = 5/12, x_frac = 1/12, y_frac = 5.15/12,
	bgcol=19,
	block_scrolling = false,max_lines = 8,
	release = function()
		ed_desc_menu.desc_ed:set_keyboard_focus(true)
	end
}
ed_desc_menu.desc_ed:attach_scrollbars()


--==== Ninth menu: set tags
ed_tags_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,invalid_tags = {},
	pre_switch = function(self)
		--oldtitle = ""
		if not tags then
			--get tags from server
			local current_tags = send_piconet_request("T+"..domain) or ""
			self.tags_ed:set_text(current_tags)
			oldtags = current_tags
			tags = oldtags
		end
		
	end,
	post_switch=function(self)
		self.tags_ed:set_keyboard_focus(true)
	end,
	badchar = false,
	update=function(self)
		local txtcontent = self.tags_ed:get_text()
		local edtxt = string.lower(table.concat(txtcontent,"\n"))
		if edtxt != self.typed_tags and tags then
			local changed = false
			while #txtcontent > max_tags do
				deli(txtcontent,max_tags+1)
				changed = true
			end
			self.invalid_tags = {}
			self.badchar = false
			for i=1,#txtcontent do
				local s = txtcontent[i]
				if #s > tag_len then
					txtcontent[i] = sub(s,1,tag_len)
					changed = true
				end
				local invalid = domain_name_is_invalid(s)
				if invalid and type(invalid) != "number" then
					self.invalid_tags[i] = invalid
					self.badchar = true
				end
--				debug = invalid
			end
			if changed then
				self.tags_ed:set_text(txtcontent)
				self.tags_ed:set_keyboard_focus(false)
			end
			local edtxt = string.lower(table.concat(txtcontent,"\n"))
			self.typed_tags = edtxt
			tags = edtxt
			self.info.label = #txtcontent.."/"..max_tags.." tags"
		end
		if self.clear then
			tags = nil
		end
		self.clear = false
		if tags == nil or tags == oldtags or self.badchar then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
--		rectfill((self.width/12)-1,(self.height*2.5/12)-1,(self.width*11/12),(self.height*10/12)-1,0)
--		rect((self.width/12)-1,(self.height*2.5/12)-1,(self.width*11/12),(self.height*10/12)-1,0)
	end
})
--info text
ed_tags_menu.info = ed_tags_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=10/12,height_frac=1.5/12,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
ed_tags_menu.backbtn = ed_tags_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	tags = nil
	ed_tags_menu.clear = true
	ed_tags_menu.tags_ed:set_text("")
end
))
set_frac_anchors(ed_tags_menu.backbtn)
--confirm button
ed_tags_menu.yesbtn = ed_tags_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="confirm"
},
function()
	interface:switch_menu(3)
	local tagslist = split(tags,"\n")
	local i = 1
	while i <= #tagslist do
		if tagslist[i] == "" or ed_tags_menu.invalid_tags[i] then
			deli(tagslist,i)
		else
			i+=1
		end
	end
	tags = table.concat(tagslist,"\n")
	ed_tags_menu.tags_ed:set_text(tagslist)
end
))
ed_tags_menu.yesbtn.x = 148 - ed_tags_menu.yesbtn.width
set_frac_anchors(ed_tags_menu.yesbtn)
--tags text field
ed_tags_menu.errs = ed_tags_menu:attach(create_gui{x=14,y=1,z=0,width=110,height=13,
	width_frac=1.15/12, height_frac = 7.5/12, x_frac = 1/12, y_frac = 2.5/12,
	bgcol=19,
	draw = function(self)
		rectfill(0,0,self.width,self.height,0)
		if tags then
			local tagslist = split(tags,"\n")
			for i=0,#tagslist-1 do
				local invalid_chars = ed_tags_menu.invalid_tags[i+1]
				if invalid_chars then
					rectfill(0,i*11,15,(i+1)*11,8)
					print(table.concat(invalid_chars,""),1,(i*11)+2,1)
	--				rectfill(self.width/12,(self.height*2.5/12)+(i*self.height*0.55/12),15,(self.height*2.5/12)+(i*self.height*0.5/12),8)
	--				print(self.width/12,(self.height*2.5/12)+(i*self.height*0.55/12),1)
				end
			end
		end
	end
})
ed_tags_menu.text_container = ed_tags_menu:attach(create_gui{x=14,y=1,z=0,width=110,height=13,
	width_frac=10/12, height_frac = 7.5/12, x_frac = 2.15/12, y_frac = 2.5/12,
	bgcol=19
})
ed_tags_menu.tags_ed = ed_tags_menu.text_container:attach_text_editor{x=-14,y=0,z=0,
	width=125,
	height=125,
	max_lines = 8,show_line_numbers=true,block_scrolling = true,
	bgcol=19,
	release = function()
		ed_tags_menu.tags_ed:set_keyboard_focus(true)
	end
}


--==== Tenth menu: set domain homepage
ed_home_menu = create_gui3d({
	x=-75,y=0,z=0,width=150,height=150,norm_ry=3*math.pi/2,norm_rx=0,
	pre_switch = function(self)
		--oldtitle = ""
		if not homepage then
			--get title from server
			local current_home = unpod(send_piconet_request("H+"..domain)) or ""
			self.home_ed:set_text(current_home)
			oldhome = current_home
		end
		self.info.label = "When a user visits \"pntp:"..domain.."\", this is the page that will open."
	end,
	post_switch=function(self)
		self.home_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local edtxt = table.concat(self.home_ed:get_text(),"")
		if edtxt != self.typed_home then
			self.typed_home = edtxt
			homepage = edtxt
		end
		if edtxt == "" then
			homepage = nil
		end
		if homepage == nil or homepage == oldhome then
			self.yesbtn.ghost = true
		else
			self.yesbtn.ghost = false
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*9/12)-1,(self.width*11/12),(self.height*10/12)-1,0)
	end
})
--info text
ed_home_menu.info = ed_home_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=10/12,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
ed_home_menu.backbtn = ed_home_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
	homepage = nil
	ed_home_menu.home_ed:set_text("")
end
))
set_frac_anchors(ed_home_menu.backbtn)
--confirm button
ed_home_menu.yesbtn = ed_home_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="confirm"
},
function()
	interface:switch_menu(3)
end
))
ed_home_menu.yesbtn.x = 148 - ed_home_menu.yesbtn.width
set_frac_anchors(ed_home_menu.yesbtn)
--homepage text field
ed_home_menu.home_ed = ed_home_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=10/12, height_frac = 1/12, x_frac = 1/12, y_frac = 9/12,
	bgcol=19,
	block_scrolling = false,max_lines = 1,
	release = function()
		ed_home_menu.home_ed:set_keyboard_focus(true)
	end	
}
bind_editor_enter_to_button_tap(ed_home_menu.home_ed,ed_home_menu.yesbtn)


--==== Eleventh menu: delete domain
delete_menu = create_gui3d({
	x=0,y=75,z=0,width=150,height=150,norm_ry=math.pi,norm_rx=-math.pi/2,
	pre_switch = function(self)
		self.info.label = "Type in your domain name and password once again below to confirm deletion."
		delete_menu.passwd_ed:set_text("")
		delete_menu.domain_ed:set_text("")
	end,
	post_switch=function(self)
		self.domain_ed:set_keyboard_focus(true)
	end,
	update=function(self)
		local domaintxt = table.concat(self.domain_ed:get_text(),"")
		local passwdtxt = table.concat(self.passwd_ed:get_text(),"")
		
		if passwdtxt == password and domaintxt == domain then
			self.deletebtn.ghost = false
		else
			self.deletebtn.ghost = true
		end
	end,
	draw=function(self)
		rect((self.width/12)-1,(self.height*7/12)-1,(self.width*11/12),(self.height*8/12)-1,0)
		rect((self.width/12)-1,(self.height*9.6/12)-1,(self.width*11/12),(self.height*10.6/12),0)
	end
})
--info text
delete_menu.info = delete_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=0.34,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--domain text
delete_menu.domtxt = delete_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=1.5/12,x_frac=1/12,y_frac = 5.5/12,fgcol=1,label = "Domain"
}))
--passwd text
delete_menu.pswdtxt = delete_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=1.5/12,x_frac=1/12,y_frac = 8.1/12,fgcol=1,label = "Password"
}))
--back button
delete_menu.backbtn = delete_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
end
))
set_frac_anchors(delete_menu.backbtn)
--delete button
delete_menu.deletebtn = delete_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=8,label="delete"
},
function()
	deleted = (send_piconet_request("P+"..domain.."*"..pod(password,0x7).."*".."X+") == "REPORT:X")
	interface:switch_menu(13)
end
))
delete_menu.deletebtn.x = 148 - delete_menu.deletebtn.width
set_frac_anchors(delete_menu.deletebtn)
--domain name text field
delete_menu.domain_ed = delete_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=10/12, height_frac = 1/12, x_frac = 1/12, y_frac = 7/12,
	bgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		delete_menu.domain_ed:set_keyboard_focus(true)
	end	
}
--password text field
delete_menu.passwd_ed = delete_menu:attach_text_editor{x=0,y=1,z=0,
	width=110,
	height=13,
	width_frac=10/12, height_frac = 1/12, x_frac = 1/12, y_frac = 9.6/12,
	bgcol=19,
	fgcol=19,
	block_scrolling = true,max_lines = 1,
	release = function()
		delete_menu.passwd_ed:set_keyboard_focus(true)
	end	
}


--==== Twelfth menu: submit changes
submit_menu = create_gui3d({
	x=0,y=-75,z=0,width=150,height=150,norm_ry=math.pi,norm_rx=math.pi/2,changes = "",
	pre_switch = function(self)
		local text = "Submitting:\n"
		self.changes = ""
		local changelist = {}
		if newdomain then
			text = text..">edit domain\n"
			add(changelist,"K+"..newdomain)
		end
		if new_password then
			text = text..">edit password\n"
			add(changelist,"P+"..pod(new_password,0x7))
		end
		if btitle then
			text = text..">edit title\n"
			add(changelist,"N+"..pod(btitle,0x7))
		end
		if description then
			text = text..">edit description\n"
			add(changelist,"D+"..pod(description,0x7))
		end
		if urlroot then
			text = text..">edit HTTP root\n"
			add(changelist,"L+"..pod(urlroot,0x7))
		end
		if homepage then
			text = text..">edit home page\n"
			add(changelist,"H+"..pod(homepage,0x7))
		end
		if tags then
			text = text..">edit tags\n"
			local reformat = table.concat(split(tags,"\n"),",")
			add(changelist,"T+"..reformat)
		end
		self.changes = table.concat(changelist,"|")
		self.info.label = text
	end,
	post_switch=function(self)
	end,
	update=function(self)
		if self.changes == "" then
			self.submitbtn.ghost = true
		else
			self.submitbtn.ghost = false
		end
	end,
	draw=function(self)
	end
})
--info text
submit_menu.info = submit_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=5/6,height_frac=5/6,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--back button
submit_menu.backbtn = submit_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="cancel"
},
function()
	interface:switch_menu(3)
end
))
set_frac_anchors(submit_menu.backbtn)
--delete button
submit_menu.submitbtn = submit_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=3,label="submit changes"
},
function()
	local request = "P+"..domain.."*"..pod(password,0x7).."*"..submit_menu.changes
	local result = send_piconet_request(request)
	if sub(result,1,7) == "REPORT:" then
		submit_successful = true
		report = sub(result,8)
	else
		submit_successful = false
	end
	
	interface:switch_menu(13)
end
))
submit_menu.submitbtn.x = 148 - submit_menu.submitbtn.width
set_frac_anchors(submit_menu.submitbtn)


--==== Thirteenth menu: action performed, report
finished_menu = create_gui3d({
	x=0,y=0,z=-75,width=150,height=150,norm_ry=math.pi,norm_rx=0,
	pre_switch = function(self)
		self.info.label = ""
		if deleted then
			self.info.label = "Your domain was deleted!"
		elseif deleted == false then
			self.info.label = "Something went wrong while attempting to delete your domain! it may have failed to delete."
		elseif submit_successful then
			--report on change submission
			local report_text = "Changes report\n"
			for i = 1,#report do
				local r = report[i]
				local r_upper = string.upper(r)
				if r_upper == r then
					report_text = report_text..">Success: edit "
				else
					report_text = report_text..">Fail: edit "
				end
				if r_upper == "K" then
					report_text = report_text.."domain name."
				elseif r_upper == "P" then
					report_text = report_text.."password."
				elseif r_upper == "L" then
					report_text = report_text.."HTTP root."
				elseif r_upper == "H" then
					report_text = report_text.."default page."
				elseif r_upper == "N" then
					report_text = report_text.."title."
				elseif r_upper == "D" then
					report_text = report_text.."description."
				elseif r_upper == "T" then
					report_text = report_text.."tags."
				end
				report_text = report_text.."\n"
			end
			self.info.label = report_text
		else
			self.info.label = "Oops! Something went wrong while trying to submit :("
		end
		deleted = nil
		submit_successful = nil
	end,
	post_switch=function(self)
	end,
	update=function(self)
	end,
	draw=function(self)
	end
})
--info text
finished_menu.info = finished_menu:attach(create_gradient_textbox({width=100,height=25,
	width_frac=10/12,height_frac=10/12,x_frac=1/12,y_frac = 1/12,fgcol=1,label = ""
}))
--home button
finished_menu.homebtn = finished_menu:attach(create_tan_button({
	label = next, x = 1, y = 136,fgcol=1,label="go to login"
},
function()
	interface:switch_menu(1)
end
))
finished_menu.homebtn.x = 75 - finished_menu.homebtn.width/2
set_frac_anchors(finished_menu.homebtn)


interface.menus = {
	domain_submit,
	password_submit,
	properties_menu,
	ed_domain_menu,
	ed_url_menu,
	ed_passwd_menu,
	ed_title_menu,
	ed_desc_menu,
	ed_tags_menu,
	ed_home_menu,
	delete_menu,
	submit_menu,
	finished_menu
}

wireframe = {
	rx = 0, ry = 0, rvx = 0, rvy = 0, rx_goal = 0, ry_goal = 0, rxoff = 0, ryoff = 0, rzoff = 0, gx=0,gy=0, v_rxoff=0,v_ryoff=0, rxoff_goal=0,ryoff_goal=0, untransformed_rxoff=0,
	init = function(self)
		self.star_mesh = new_mesh(parse_obj_file(star_model,150),100,100)
		self.cube_mesh = new_mesh(parse_obj_file(cube_model,150),100,100)
	end,
	set_rot_offset = function(self,rx,ry)
		self.rxoff_goal = rx
		self.ryoff_goal = ry
	end,
	set_goal = function(self,gx,gy)
		self.gx=gx
		self.gy=gy
	end,
	lerp_to_goal = function(self)
		local dx = (self.gx)-self.rx
		local dy = (self.gy)-self.ry
		local t = atan2(dx,dy)
		
		local cap = 0.1
		local gain = 0.1
		if (abs(self.rvx) < 0.07 and abs(self.rvy) < 0.07) and (abs(dx) < 0.02 and abs(dy) < 0.02) then
			self.rvx = 0
			self.rvy = 0
			self.rx = self.gx
			self.ry = self.gy
		else
			self.rvx += mid(-cap,(cos(t)*gain),cap)
			self.rvy += mid(-cap,(sin(t)*gain),cap)
		end
			
		local drag = 0.5
		self.rvx *= drag
		self.rvy *= drag
	end,
	update = function(self)
		self:lerp_to_goal()
		self.rx += self.rvx--(((self.rx + self.rvx)+math.pi)%(math.pi*2))-math.pi
		self.ry += self.rvy--(((self.ry + self.rvy)+math.pi)%(math.pi*2))-math.pi
		
		
		local dx = (self.rxoff_goal-self.untransformed_rxoff)
		local dy = (self.ryoff_goal-self.ryoff)
		local t = atan2(dx,dy)
		
		local cap = 0.2
		local gain = 0.03
		if (abs(self.v_rxoff) < gain and abs(self.v_ryoff) < gain) and (abs(dx) < 0.008 and abs(dy) < 0.008) then
			self.v_rxoff = 0
			self.v_ryoff = 0
			self.untransformed_rxoff = self.rxoff_goal
			self.ryoff = self.ryoff_goal
			
		else
			self.v_rxoff += mid(-cap,(cos(t)*gain),cap)
			self.v_ryoff += mid(-cap,(sin(t)*gain),cap)
		end
			
		local drag = 0.7
		self.v_rxoff *= drag
		self.v_ryoff *= drag
		
		
		self.untransformed_rxoff+=self.v_rxoff
		self.ryoff+=self.v_ryoff
		self.rxoff = self.untransformed_rxoff * SOUTH:matmul3d(mat_rot_y(self.ry)):dot(SOUTH)
		self.rzoff = -self.untransformed_rxoff * SOUTH:matmul3d(mat_rot_y(self.ry)):dot(EAST)
	end,
	draw = function(self)
		local rxoff = self.rxoff
		local rzoff = self.rzoff
		local ryoff = self.ryoff
		draw_mesh(self.star_mesh,center_x,center_y,
			(self.rx+(self.ry*4))%math.pi/2+rxoff,
			self.ry+ryoff,
			rzoff,
		{19,3,3,27,26,26}, 15, 0, true)
		draw_mesh(self.cube_mesh,center_x,center_y,
			self.rx+rxoff,
			self.ry+ryoff,
			rzoff,
		{1,19,3,3,27,26}, 16, 1, true)
	end
}

local max_link_len = 100
function send_piconet_request(request)
	local weblink = "https://the-piconet.vercel.app/"
	local result
	if #request + 1 + #weblink > max_link_len then
		--multi-request
		local r_id = fetch_web_only(weblink.."X")
		if tonum(r_id) == nil then
			return nil
		end
		local prefix = weblink..r_id.."+"
		local request_so_far = ""
		local packet_size = max_link_len-#prefix
		
		for i = 1,#request,packet_size do
			local sending = sub(request,i,min(i+packet_size-1,#request))
			request_so_far = request_so_far..sending
			local webresponse = fetch_web_only(prefix..sending)
			if webresponse != request_so_far then
				--message failed at some point
				return nil
			end
		end
		
		result = fetch_web_only(weblink..r_id.."-")
	else
		result = fetch_web_only(weblink.."Q"..request)
	end
--	debug = result
	return result
end

function domain_name_is_invalid(name)
	if #name > domain_len then
		return #name
	end
	local allowed = split(allowed_domain_chars,"")
	local chars = split(name,"")
	local illegal = {}
	for c in all(chars) do
		if count(allowed,c) < 1 and count(illegal,c) < 1 then
			add(illegal,c)
		end
	end
	if #illegal>0 then return illegal end
	return false
end

function is_letter(char)
	return ord(char)>=97 and ord(char)<=122
end
