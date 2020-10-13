require "camera"
local bresenham = require 'bresenham'

function love.load()
	success = love.window.setMode( 800, 600, {resizable=true} )

	ANIM_WIDTH  = 200;
	ANIM_HEIGHT = 200;
	imageData = love.image.newImageData( ANIM_WIDTH, ANIM_HEIGHT );
	
	imageData:setPixel(100, 100, 0, 0, 0, 1);
	
	image = love.graphics.newImage( imageData );
	
	DrawLine(0, 0, 10, 10, 0)
end

function love.wheelmoved( x, y )

	cam_zoom = cam_zoom + y;
	
end

function love.mousemoved( x, y, dx, dy, istouch )

	if love.mouse.isDown( 3 ) then
	
		cam_x = cam_x - (dx / cam_zoom);
		cam_y = cam_y - (dy / cam_zoom);
	
	end
	
end

function love.update()
	-- pixel on image that mouse is hovering over
	px = math.floor( untra_x ( love.mouse.getX() ) );
	py = math.floor( untra_y ( love.mouse.getY() ) );
	
	if love.mouse.isDown( 1 ) then
		
		DrawLine( prev_px, prev_py, px, py, 0 );
		
	elseif love.mouse.isDown( 2 ) then

		DrawLine( prev_px, prev_py, px, py, 1 );
	
	end
	
	prev_px = math.floor( untra_x ( love.mouse.getX() ) );
	prev_py = math.floor( untra_y ( love.mouse.getY() ) );
end

function love.draw()
	love.graphics.setColor(1, 1, 1);
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
	love.graphics.setColor(0, 0, 0);
	love.graphics.rectangle("line", tra_x(0), tra_y(0), ANIM_WIDTH * cam_zoom, ANIM_HEIGHT * cam_zoom);
	
	love.graphics.setColor(1, 1, 1);
	love.graphics.draw( image, tra_x(0), tra_y(0), 0, cam_zoom, cam_zoom );
end

-- This SetPixel function takes into account that you aren't out of bounds, and is just grayscale!
function SetPixel(cx, cy, color)
	
	if ( cx < 0 		  or cy < 0 			   or 
		 cx >= ANIM_WIDTH or cy >= ANIM_HEIGHT ) then
		
		return;
		
	else
		imageData:setPixel( cx, cy, color, color, color, 1);
		image = love.graphics.newImage( imageData );
	end

end

function DrawLine(x1, y1, x2, y2, color)
	bresenham.los(x1, y1, x2, y2, function(x,y)
		
		SetPixel(x, y, color)
		return true
		
	end)
	-- cx = x1; cy = y1;
	-- mainSlope = slope(x1, y1, x2, y2);
	
	-- while cx ~= x2 and cy ~= y2 do 
	
		

		-- -- slopes = {};
		-- -- x1offsets = {cx,   cx,   cx-1, cx+1};
		-- -- y1offsets = {cy-1, cy+1, cy,   cy};
		
		-- -- for i = 1, 4 do
			-- -- slopes[i] = slope( x1offsets[i], y1offsets[i], x2, y2 )
		-- -- end
		
		-- -- nearestIndex = -1;
		-- -- nearestSlopeDiff = 100000;
		
		-- -- for i = 1, #slopes do
		
			-- -- currentSlopeDiff = math.abs(mainSlope - slopes[i])
		
			-- -- if currentSlopeDiff <= nearestSlopeDiff then
			
				-- -- nearestSlopeDiff = currentSlopeDiff;
				-- -- nearestIndex = i;
			
			-- -- end
		-- -- end
		
		-- -- cx = x1offsets[nearestIndex];
		-- -- cy = y1offsets[nearestIndex];
		
		-- -- print(nearestIndex)
		-- -- --print(cx .. ", " .. cy); 
		
		-- SetPixel(cx, cy, color);
		
	-- end
end

function slope(x1, y1, x2, y2)
	return (y2 - y1) / (x2 - x1);
end