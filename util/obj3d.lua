--[[pod_format="raw",created="2024-03-18 06:21:14",modified="2024-03-19 05:24:12",revision=2355]]
include "lib/util3d.lua"

function new_obj(transform)
	return {
		children = {},
		transformation = transform or new_transform(),
		rotate = function(self, r)
			self.transformation.rot:add(r,true)
		end	,
		move = function(self, t, neg)
			if neg then
				self.transformation.pose:sub(t,true)
			else
				self.transformation.pose:add(t,true)
			end
		end,
		transform = function(self, t)
			self:rotate(t.rot)
			self:move(t.pose)
		end,
		add_child = function(self, c)
			add(self.children,c)
		end,
		get_child = function(self, index)
			local c = self.children[index]
			c:transform(self.transformation)
			return c
		end
	}
	
	
end