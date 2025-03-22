--[[pod_format="raw",created="2024-03-20 06:16:57",modified="2025-03-22 22:08:32",revision=16288]]
webinclude"https://raw.githubusercontent.com/piconet-picotron/piconet-home/refs/heads/main/lib3d.lua"
rotation_order = {"z", "y", "x", "t"}

webpath = "https://raw.githubusercontent.com/piconet-picotron/piconet-home/main/"
fade = {21,5,22,7}
logo_icon = 
--[[pod_type="gfx"]]unpod("b64:bHo0AH0AAAAMAQAA8hZweHUAQyBAEATwMXcQZxBXIGcQJyAnAGcAZxCHAGcAdwCHAEcAEAAiJyACACAXACIAYocAJ2AnMBIAICdQEgA_JwBHFABfICcAR0AUABMAPAAdhxIALHcwEgAvJ4ASABQDqgAFFAASYNAAABAAIWcgEAAF8ABQZyAn8DM=")
sphere_obj = unpod("b64:bHo0AD0DAAByCAAAYSJ2IDAuMAEAoCAtMC4zNTY4MjIKAJ85MzQxNzJcbnYXAAEFNAADIAALFgAGSgADIABvNTc3MzUwCgABDyEABQggAA_hAAAPoAADD58AFQ_eAAMPnQAND5wACw88AQMOFgAJnAAPOgEMDpIACpwADiAAD5wADA_bAAIPmgAUD5kAAg_YAAwPlwANYTg1MDY1MT0AUjI1NzMxHwADFgAEFQALmAAMPQAIPAAfLT0AFB8tewAFDSAACh8AC1QABigABCoCAiAAHy0hAAYMdgAJnwAOFgAYID8ADz4ADAUVAB8tPgAA8QJmIDcvMzMgMTcvMTcgMjEvMhQAAg8AVzE5LzE5FQABDwBXMTEvMTEVAAEPAEY5LzM0FAABDgABVwAGJwDgOC8xOCAxMy8xMyAyMi8tAhNmDwADZgAFFQACZgACkAAFFQACDwBGMC8yMBUAAg8AAloABioARDYvMTYqAEczLzIzKgACRQAEFQACVAAnNy8TAAANAEcxMC8xOwACDwADVgAEFQDQMy8zIDgvOCAyNC8yNBEAAA0AAzkABBMAAjkAAV8ABBMAAA0ANjkvOREAAA0AAEwABREA8AExMi8xMiAyLzM1IDI1LzI1FAABDgBGNC8zNhMAAQ4ANjEvMRIAAA0AVzE0LzE0EwABDwADUgAGTQAUMhMAQTYvMjYoAAEPAFcxNS8xNRUAAQ8ANjYvNhMAAA0AJzUvJAABDQAYL0oAAnIAAJgARTcvMjeYAAIyAgUTAAEyAgP2AQUVAAL2AQIgAgUVAAIgAgFWAAlSAAIOAUI4LzM3DgESNEYBRDgvMjifAQFoAQQRAAGRAgOHAAQ2AAOHABcvEwAAzQAB1QBEOS8yOeIAAegBBBEAAA0AAWsABBEAAA0AAIAABREAAQ0AABUBCEQAADsBVDMwLzMwSAECUAIFEwACDwACMgIGFQABDwABcgAEEwAADQAAUAAGJAACvAEBIgEwMzEvjgQUZocBAT0BBhUAAkwBAS0DBhUAAQ8AAuwBBhUAAQ8AAloABRUAAbUAAigARzIvMzIoAAJSAAUVAAKOAwFwAwUVAAOpAwL0AAUqAAGpAwBYAIAzMi8zMlxuIg==")
btn_browse = 
--[[pod_type="gfx"]]unpod("b64:bHo0ALYAAAAgAQAA-ixweHUAQyA2GARA-xUccB71HB5ADhX-FhwVDiAOBS3-DxotBQ4QDgUN-B4NBQ4ADgUd-B4dBR4FDfwgDQcA8gGMLxAcKywbHAssCxwrHCuMFQBFCxwLDAQAcywLDAs8C7waAAQYAAAGAAECAE87DCucNgAAEQw2AD8MC7wcAA8QK04AnxwbLCscKywrjKUAAAIHAAHIACQOANoAUBAOBS387ADwASAOFf0cFQ5AHvUcHnD_HEA=")
btn_submit = 
--[[pod_type="gfx"]]unpod("b64:bHo0ANIAAACCAQAA8TpweHUAQyA2GARA-xUccB71HB5ADhX-FhwVDiAOBS3-DxotBQ4QDgUN-B4NBQ4ADgUdfC8QLBscOywbHCsMK5wdBR4FDYwLHAsMBAACAgATHAIAL5wNHgAAHzscAAMRLAgADxwAFkMrLBscGAA1DCsMGAAo-CAHANOcKwwrHCsMSxwbHCusVAARPEYAMTwLLFoABlAAGRwYAC8MCzAADA8YAAMhHYxyAEAsCzwbHgAhjB0zAQI8AVAQDgUt-E4B8AEgDhX9HBUOQB71HB5w-hxA")
btn_info = 
--[[pod_type="gfx"]]unpod("b64:bHo0AJkAAADwAAAA-ixweHUAQyAqGARA-xUQcB71EB5ADhX-FhAVDiAOBS3-Dw4tBQ4QDgUN-BINBQ4ADgUd-BIdBR4FDfwUDQcAoYwvEAwrLCscG5wPANicCxwLHAsMCzwLHAuMEgAsKxwSAC8LPBIACDGMKwwSAD9MG5x1AAACBwABmAAkDgCqAFAQDgUt-LwA8AEgDhX9EBUOQB71EB5w-hBA")

title = "Home"
w = 300
h = 200
function _init()
	sphere3d = new_mesh(parse_obj_file(sphere_obj, 100), 300, 300)
	gui = create_gui({x=0,y=28,width=w,height=h,
		update = function(self)
			width,height = page_size()
			for b in all(buttons) do
				local rx,ry = sphere_mesh.rx, sphere_mesh.ry
				pos = b.pos
				pos = pos:matmul3d(mat_transformation(vec(0,0,0), vec(rx,ry,0)))
				b.z = pos.z
				b:setpos(center_x+pos.x,center_y+pos.y)
			end
		end
	})
	buttons = {
		attach_3d_button(gui,vec(100,0,0),btn_browse,
			function()
				web_visit("pntp://piconet.p/browse.lua")
			end
		),
		attach_3d_button(gui,vec(-100,0,0),btn_submit,
			function()
				web_visit("pntp://piconet.p/submit.lua")
			end
		),
		attach_3d_button(gui,vec(0,-100,0),btn_info,
			function()
				--visit
			end
		)
	}
	buttons[3].ghost = true
	sphere_mesh:init()
end

function _draw()
	cls(0)
	for b in all(buttons) do
		b:backdraw()
	end
	sphere_mesh:draw(2)
	logo:draw()
	sphere_mesh:draw(1)
	gui:draw_all()
end

function _update()
	w,h = page_size()
	center_x = w/2
	center_y = h/2
	mx,my = mouse()
	cmx,cmy = mx-center_x,my-center_y
	
	if mx>0 and my>0 and mx<w and my<h then
		logo.x_goal,logo.y_goal = cmx,cmy
		sphere_mesh:set_goal(cmy/100, cmx/100)
	else
		logo.x_goal,logo.y_goal = 0,0
		sphere_mesh:glide()
	end
	gui.width = w
	gui.height = h
	sphere_mesh:update()
	logo:update()
	gui:update_all()
end

logo = {
	x = 0, y = 0, vx = 0, vy = 0, x_goal = 0, y_goal = 0, icon = logo_icon,
	update = function(self)
		local dx = (self.x_goal-self.x)
		local dy = (self.y_goal-self.y)
		local t = atan2(dx,dy)
		
		local cap = 30
		local gain = 15
		if (abs(self.vx) < 15 and abs(self.vy) < 15) and (abs(dx) < 12 and abs(dy) < 12) then
			self.vx = 0
			self.vy = 0
			self.x = self.x_goal
			self.y = self.y_goal
			
		else
			self.vx += mid(-cap,(cos(t)*gain),cap)
			self.vy += mid(-cap,(sin(t)*gain),cap)
		end
			
		local drag = 0.7
		self.vx *= drag
		self.vy *= drag
		
		
		self.x+=self.vx
		self.y+=self.vy
	end,
	draw = function(self)
		local anchor_x,anchor_y = center_x-(self.x/10),center_y-(self.y/10)
		for i = 1,#fade do
			pal(7,fade[i])
			spr(self.icon, (anchor_x-32)+(mid(-48,-self.x,48)*(i/20)), (anchor_y-8)+(mid(-32,-self.y,32)*(i/20)))
			pal()
		end
	end
}

function attach_3d_button(gui,pos,gfx,action)
	local btn = gui:attach_button({gfx=gfx,x=0,y=0,z=0,width=gfx:width()+1,height=gfx:height()+1,
		release = action,
		setpos = function(self,x,y)
			self.x = x-(self.gfx:width()/2)
			self.y = y-(self.gfx:height()/2)
		end,
		pos = pos,
		backdraw = function(self)
			camera(-self.x,-self.y)
			pal(21,0)
			pal(16,1)
			pal(5,21)
			pal(22,21)
			pal(15,21)
			sspr(self.gfx, 0, 0)
			pal()
		end
	})
	function btn:draw(msg)
		camera(-self.x,-self.y)
		if msg.has_pointer then
			pal(15,7)
			pal(16,12)
		end	
		if (msg.has_pointer and msg.mb > 0) or self.ghost then
			pal()
			pal(16,1)
			pal(5,21)
			pal(22,5)
			pal(15,5)
		end

		if self.z>=-15 then
			spr(self.gfx)
		end
		pal()
	end
	return btn
end

sphere_mesh = {
	rx = 0, ry = 0, rvx = 0, rvy = 0, rx_goal = 0, ry_goal = 0,
	last_rvx = 0, last_rvy = 0, last_rx = 0, last_ry = 0,
	init = function(self)
		self.mesh = sphere3d
	end,
	glide = function(self)
		self.rvx = self.last_rvx
		self.rvy = self.last_rvy
	end,
	set_goal = function(self,gx,gy)
		
		local dx = (gx)-self.rx
		local dy = (gy)-self.ry
		local t = atan2(dx,dy)
		
		local cap = 0.07
		local gain = 0.4
		if (abs(self.rvx) < 0.15 and abs(self.rvy) < 0.15) and (abs(dx) < 0.12 and abs(dy) < 0.12) then
--			self.rvx = 0
--			self.rvy = 0
			self.last_rvx = self.rx-self.last_rx
			self.last_rvy = self.ry-self.last_ry
			self.rx = gx
			self.ry = gy
			
		else
			self.rvx += mid(-cap,(cos(t)*gain),cap)
			self.rvy += mid(-cap,(sin(t)*gain),cap)
			self.last_rvx = self.rvx
			self.last_rvy = self.rvy
		end
			
		local drag = 0.7
		self.rvx *= drag
		self.rvy *= drag
	end,
	update = function(self)
		self.last_rx = self.rx
		self.last_ry = self.ry
		self.rx = (((self.rx + self.rvx)+math.pi)%(math.pi*2))-math.pi
		self.ry = (((self.ry + self.rvy)+math.pi)%(math.pi*2))-math.pi
	end,
	draw = function(self, split_half)
		draw_mesh(self.mesh, center_x, center_y, self.rx, self.ry, 0, {1,16,16,16,12,28}, 10, split_half, false)
	end
}
