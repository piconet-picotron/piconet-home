--[[pod_format="raw",created="2024-03-20 06:16:57",modified="2024-12-22 05:12:53",revision=3630]]

title = "home"
_init = function(self, explrorer)
	clr = 2
end
_draw = function(self, explorer)
	cls(clr or 9)
	color(7)
	print("hello! this is a test page")
end
_update = function(self, explorer)

end
