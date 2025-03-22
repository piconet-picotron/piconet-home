--[[pod_format="raw",created="2024-12-17 23:09:26",modified="2025-03-22 20:48:36",revision=9339]]

title = "Browse the 'Net!"

local gui
_init = function()
	card_holder:load_site_cards()
end
_update = function()
	w,h = page_size()
	center_x = w/2
	center_y = h/2
	mx,my = mouse()
	gui:update_all()
end
_draw = function()
	cls(2)
	gui:draw_all()
	print(debug,0,0,6)
end

--==========
--	GUI
--==========

pinkbtn_gfx = 
--[[pod_type="gfx"]]unpod("b64:bHo0ACgAAAA1AAAA-gtweHUAQyAEDQQQHxUADhIOEg8YDgIdDgINCAQAkB0OEg0ADhIQHg==")
function create_pink_button(props)
	props.label = props.label or "[no label]"
	local temp_gui = create_gui({width = 500})
	local btn_for_width = temp_gui:attach_button({label = props.label})
	props.width = props.width or btn_for_width.width
	props.height = 13
	
	local btn = create_gui(props)
	
	btn.ghost = false
	
--	btn.tap = action
	
	function btn:update()
	end
	
	function btn:draw(msg)
		local clrs = {21,2,24,8,23}
--		camera(-self.x,-self.y)
		if msg.has_pointer then
			pal(clrs[4],clrs[5])
			pal(self.fgcol,clrs[4])
			if msg.mb > 0 then
				pal()
				pal(self.fgcol,1)
				pal(clrs[2],clrs[1])
				pal(clrs[3],clrs[2])
				pal(clrs[4],clrs[2])
			end
		end	
		
		if self.ghost then
			pal(self.fgcol,clrs[2])
			pal(clrs[1],1)
			pal(clrs[2],clrs[1])
			pal(clrs[3],clrs[1])
			pal(clrs[4],clrs[1])
		end
		
		rect(4,0,self.width-5,self.height-1,clrs[1])
		rect(4,1,self.width-5,self.height-2,clrs[2])
		rect(4,2,self.width-5,self.height-3,clrs[3])
		rectfill(4,3,self.width-5,self.height-4,clrs[4])
		print(self.label, 5,3, self.fgcol)
		spr(pinkbtn_gfx,self.width-4,0,true)
		spr(pinkbtn_gfx)
		
		pal()
	end
	btn.cursor = "pointer"
	return btn
end

gui = create_gui{x=0,y=28,width=200,height=300,
	update = function(self)
		self.width, self.height = w,h
	end
}

card_holder = gui:attach{x=0,y=0,width=200,height=2100,
	current_start=0,
	range=5,
	cards = {},
	update = function(self)
		self.width = gui.width
		self.nextpage.x = (self.width/2 + 50) - (self.nextpage.width/2)
		self.lastpage.x = (self.width/2 - 50) - (self.lastpage.width/2)
		self.nextpage.y = self.height - 19
		self.lastpage.y = self.height - 19
		self.lastpage.ghost = false
		if self.current_start <= 0  then
			self.lastpage.ghost = true
		end
		self.nextpage.ghost = false
		if #self.cards < self.range then
			self.nextpage.ghost = true
		end
	end,
	draw = function(self)
		print("This browse page is temporary!", 1,1, 7)
	end,
	load_site_cards = function(self)
		for c in all(self.cards) do
			self:detach(c)
		end
		self.cards = {}
		local result = send_piconet_request("B+"..self.current_start.."*"..self.current_start+self.range-1 .."*".."T-")
		
		local allsitesinfo = split(result,"\n")
		local ypos = 2
		for i in all(allsitesinfo) do
			ypos+=8
			local siteinfo = split(i,"`")
			local domain = siteinfo[1]
			local label = unpod(siteinfo[2]) or ""
			local description = unpod(siteinfo[3]) or ""
			local tags = send_piconet_request("T+"..domain)
			local card = create_card(ypos, domain, label, description, tags)
			self:attach(card)
			add(self.cards, card)
			ypos+=card.height
		end
		self.height = ypos + 8 + 8 + 13
		
		
	end,
	load_next_sites = function(self)
		self.current_start += self.range
		self:load_site_cards()
	end,
	load_last_sites = function(self)
		self.current_start -= self.range
		self:load_site_cards()
	end
}
card_holder.lastpage = card_holder:attach(create_pink_button{
	x=0,y=0,label = "previous",fgcol=2,
	tap = function()
		card_holder:load_last_sites()
		card_holder.y = 0
	end
})
card_holder.nextpage = card_holder:attach(create_pink_button{
	x=0,y=0,label = "next",fgcol=2,
	tap = function()
		card_holder:load_next_sites()
		card_holder.y = 0
	end
})
gui:attach_scrollbars()

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
--	if request[1] == "B" then
--		debug = request.."\n"..result
--	end
	return result
end

function create_card(ypos, domain, label, description, tags)
	local card = create_gui{x = 15, y = ypos, width = gui.width-40, height = 50,
		update = function(self)
			self.width = gui.width-40
		end,
		draw = function(self)
			rectfill(0,0,self.width,self.height,30)
			print("pntp://"..domain, self.visitbtn.x, self.visitbtn.y+self.visitbtn.height+2, 14)
			rect(0,0,self.width-1,self.height-1,24)
		end
	}
	card.visitbtn = card:attach(create_pink_button{label=label, x=8, y=8,
		tap=function()
			web_visit("pntp://"..domain)
		end,fgcol=2
	})
	card.descholder = card:attach{x=8,y=card.visitbtn.y+card.visitbtn.height+4+9,
		width = 125, height = 11,
		draw = function(self)
			rectfill(0,0,self.width,self.height,21)
		end}
	card.descriptiontxt = card.descholder:attach{text = description,
		x=0, y=0, width = card.descholder.width, height=40,
		draw=function(self)
			print(description, 2,2, 14)
		end
	}
	local num_lines = #split(description,"\n")
	card.descriptiontxt.height = num_lines*11 + 4
	card.descholder.height = mid(35,card.descriptiontxt.height,70)
	card.height = card.descholder.height + 33 + 9
	if card.descholder.height < card.descriptiontxt.height then
		card.descholder:attach_scrollbars()
	end
	
	card.tagsection = card:attach{x = 144, y = card.descholder.y,
		width = card.width - 152, height = card.descholder.height,
		draw = function(self)
			rectfill(0,0,self.width,self.height,21)
		end,
		update=function(self)
			self.width = min(card.width - 152,card.widest_tag+10)
		end
	}
	card.tagsholder = card.tagsection:attach{x=0,y=0,
		width=card.tagsection.width, height = 100,
		update = function(self)
			self.width=card.tagsection.width
		end
	}
	card.tagbtns = {}
	card.widest_tag = -10
	if #tags>0 then
		local tagy = 1
		for t in all(split(tags,"\n")) do
			local tagbtn = card.tagsholder:attach(create_pink_button{
				label = t,
				x = 1, y = tagy,
				fgcol=2,
				tap=function()
					web_visit("pntag:"..t)
				end
			})
			if tagbtn.width > card.widest_tag then
				card.widest_tag = tagbtn.width
			end
			add(card.tagbtns, tagbtn)
			tagy += 14
		end
	end
	card.tagsholder.height = 1+#card.tagbtns*14
	if card.tagsholder.height > card.tagsection.height then
		card.tagsection:attach_scrollbars()
	end
	
	card:attach{
		x=144,y=card.descholder.y-10,width=card.tagsection.width,height=10,
		update = function(self)
			self.width=card.tagsection.width
		end,
		draw = function(self)
			rectfill(0,0,self.width,self.height,24)
			print("tags",1,1,20)
		end
	}
	return card
end