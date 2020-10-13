require "camera"
require "action"
local bresenham = require 'bresenham'

function love.load()
	love.window.setTitle( "bae 0.0.1 pre-alpha" )
	success = love.window.setMode( 800, 600, {resizable=true} )
	
	-- used for undoing and redoing
	ACTIONS_LOG = {};
	actionsLogPointer = 0;

	ANIM_WIDTH  = 200;
	ANIM_HEIGHT = 200;
	imageData = love.image.newImageData( ANIM_WIDTH, ANIM_HEIGHT );
	
	--imageData:setPixel(100, 100, 0, 0, 0, 1);
	
	image = love.graphics.newImage( imageData );
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

function love.mousepressed( x, y, button, istouch, presses )

	-- A new action is created when left/right clicking in the editor, regardless of in bounds or not
	-- (you could move the cursor in bounds and start modifying pixels, so the Action is already set up and ready in case)
	
	if button == 1 or button == 2 then
		actionsLogPointer = actionsLogPointer + 1;

		ca = Action:new{ pixelChanges = {} }; -- current action, with a newly created empty set of PixelChanges
		
		ACTIONS_LOG[actionsLogPointer] = ca;
	end 
end

function love.keypressed( key, scancode, isrepeat )

	if key == "z" then
	
		if love.keyboard.isDown( "lctrl" ) then
			
			print("undo");
			
			a = ACTIONS_LOG[actionsLogPointer];
			if a then
				for i = 1, #a.pixelChanges do
				
					pc = a.pixelChanges[i]
					SetPixel( pc.xPos, pc.yPos, pc.startColor );
					print( pc.xPos .. " , " .. pc.startColor .. " | " );
				
				end
				
				actionsLogPointer = actionsLogPointer - 1;
			end
		end
	
	end
end

function love.update()
	-- pixel on image that mouse is hovering over
	px = math.floor( untra_x ( love.mouse.getX() ) );
	py = math.floor( untra_y ( love.mouse.getY() ) );
	
	if love.mouse.isDown( 1 ) then
		
		DrawLine( prev_px, prev_py, px, py, 1/8 );
		
	elseif love.mouse.isDown( 2 ) then

		DrawLine( prev_px, prev_py, px, py, 1 );
	
	end
	
	prev_px = math.floor( untra_x ( love.mouse.getX() ) );
	prev_py = math.floor( untra_y ( love.mouse.getY() ) );
end

function love.draw()
	love.graphics.setColor(0.5, 0.5, 0.5);
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
	love.graphics.setColor(0, 0, 0);
	love.graphics.rectangle("line", tra_x(0), tra_y(0), ANIM_WIDTH * cam_zoom, ANIM_HEIGHT * cam_zoom);
	
	-- just writes an "e" for every PixelChange in the current Action
	a = ACTIONS_LOG[actionsLogPointer]
	if a then
		love.graphics.print(#ACTIONS_LOG[actionsLogPointer].pixelChanges)
	
		for i = 1, #a.pixelChanges do
			love.graphics.print("e", 0, 8*i)
		end
	end
	
	love.graphics.setColor(1, 1, 1);
	love.graphics.draw( image, tra_x(0), tra_y(0), 0, cam_zoom, cam_zoom );
end

-- This SetPixel function takes into account that you aren't out of bounds, and is just grayscale!
function SetPixel(cx, cy, color)
	
	if ( cx < 0 		  or cy < 0 			   or 
		 cx >= ANIM_WIDTH or cy >= ANIM_HEIGHT ) then
		
		return;
		
	else
		-- The color 0 is treated as transparency.
		if color == 0 then opacity = 0 else opacity = 1 end
		
		imageData:setPixel( cx, cy, color, color, color, opacity);
		image = love.graphics.newImage( imageData );
	end

end

function DrawLine(x1, y1, x2, y2, color)
	bresenham.los(x1, y1, x2, y2, function(x,y)
		
		-- first checking that each pixel in the line is in bounds
		if ( x < 0 	     or y < 0 			   or 
		 x >= ANIM_WIDTH or y >= ANIM_HEIGHT ) then return true end
		
		-- getting the pixel's color
		-- if it matches then it doesn't register as being a pixel change!
		r, g, b, a = imageData:getPixel(x, y);
		if math.abs(r - color) < 0.01 and a == 1 then return true end
		
		SetPixel(x, y, color)
		
		-- creating a new PixelChange object and adding it to the current action in the ACTIONS_LOG
		cpc = PixelChange:new{ startColor = r, endColor = color, xPos = x, yPos = y };
		table.insert(ACTIONS_LOG[actionsLogPointer].pixelChanges, cpc);
		
		return true;
		
	end)
end

function slope(x1, y1, x2, y2)
	return (y2 - y1) / (x2 - x1);
end