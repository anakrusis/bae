require "camera"

function love.load()
	success = love.window.setMode( 800, 600, {resizable=true} )

	ANIM_WIDTH  = 200;
	ANIM_HEIGHT = 200;
	imageData = love.image.newImageData( ANIM_WIDTH, ANIM_HEIGHT );
	
	imageData:setPixel(100, 100, 0, 0, 0, 1);
	
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

function love.update()
	
	if love.mouse.isDown( 1 ) then
		SetPixel(love.mouse.getX(), love.mouse.getY(), 0);
		
	elseif love.mouse.isDown( 2 ) then
		SetPixel(love.mouse.getX(), love.mouse.getY(), 1);
	
	end
end

function love.draw()
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
	love.graphics.draw( image, tra_x(0), tra_y(0), 0, cam_zoom, cam_zoom );
end

-- This SetPixel function takes into account that you aren't out of bounds, and is just grayscale!
function SetPixel(x, y, color)
	
	cx = untra_x(x); cy = untra_y(y);
	
	if ( cx < 0 		  or cy < 0 			   or 
		 cx >= ANIM_WIDTH or cy >= ANIM_HEIGHT ) then
		
		return;
		
	else
		imageData:setPixel( cx, cy, color, color, color, 1);
		image = love.graphics.newImage( imageData );
	end

end