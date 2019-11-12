----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:59:01 04/08/2015 
-- Design Name: 
-- Module Name:    graphics_controller - rtl 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library bounce_graphics_v1_00_a;
--use bounce_graphics_v1_00_a.dvi_ctrl;

entity graphics_controller is
   port (
      -- General System Signals
      ClkxCI         : in     std_logic;
      RstxRBI        : in     std_logic;
      
      -- Component Input
		ScorexDI        : in     std_logic_vector(10-1 downto 0);
		HighScorexDI    : in     std_logic_vector(10-1 downto 0);
	   XPlatexDI       : in     std_logic_vector(10-1 downto 0);
      YPlatexDI       : in     std_logic_vector(10-1 downto 0);
		XSubplatexDI    : in     std_logic_vector(10-1 downto 0);
      YSubplatexDI    : in     std_logic_vector(10-1 downto 0);
		
      XBall1xDI       : in     std_logic_vector(10-1 downto 0);
      YBall1xDI       : in     std_logic_vector(10-1 downto 0);
		XBall2xDI       : in     std_logic_vector(10-1 downto 0);
      YBall2xDI       : in     std_logic_vector(10-1 downto 0);
		XBall3xDI       : in     std_logic_vector(10-1 downto 0);
      YBall3xDI       : in     std_logic_vector(10-1 downto 0);
		XBall4xDI       : in     std_logic_vector(10-1 downto 0);
      YBall4xDI       : in     std_logic_vector(10-1 downto 0);
		YBoost1xDI		 : in     std_logic_vector(10-1 downto 0);
		YBlock1xDI		 : in     std_logic_vector(10-1 downto 0);
		YBoost2xDI		 : in     std_logic_vector(10-1 downto 0);
		YBlock2xDI		 : in     std_logic_vector(10-1 downto 0);
		
      -- CH7301C DVI Signals
      DVI_ResetxRBO  : out    std_logic;      
      DVI_XCLKxCO    : out    std_logic;      
      DVI_XCLKxCBO   : out    std_logic;

      DVI_DExSO      : out    std_logic;
      DVI_VSyncxSO   : out    std_logic;
      DVI_HSyncxSO   : out    std_logic;
      DVI_DataxDO    : out    std_logic_vector(12-1 downto 0)
   );
end graphics_controller;

architecture rtl of graphics_controller is
	constant SCREEN_WIDTH             : unsigned(10-1 downto 0) := to_unsigned(640, 10);
	constant SCREEN_HEIGHT             : unsigned(10-1 downto 0) := to_unsigned(480, 10);
	constant SCORE_WIDTH             : unsigned(10-1 downto 0) := to_unsigned(15, 10);
	
	constant PLATE_HEIGHT            : unsigned(10-1 downto 0) := to_unsigned(10, 10);
   constant PLATE_WIDTH             : unsigned(10-1 downto 0) := to_unsigned(90, 10);
	constant SUBPLATE_HEIGHT            : unsigned(10-1 downto 0) := to_unsigned(6, 10);
   constant SUBPLATE_WIDTH             : unsigned(10-1 downto 0) := to_unsigned(45, 10);
	
	constant PLATEZONE_HEIGHT         : unsigned(10-1 downto 0) := to_unsigned(80, 10);
	constant SIDE_SIZE             : unsigned(10-1 downto 0) := to_unsigned(25, 10);
	
   constant BALL_HEIGHT             : unsigned(10-1 downto 0) := to_unsigned(20, 10);
   constant BALL_WIDTH              : unsigned(10-1 downto 0) := to_unsigned(20, 10);
   

	constant BLOCK_WIDTH            : unsigned(10-1 downto 0) := to_unsigned(150, 10);
	constant XBLOCK1 						: unsigned(10-1 downto 0) := to_unsigned(85, 10);
	constant XBLOCK2 						: unsigned(10-1 downto 0) := to_unsigned(405, 10);
	constant BOOST_WIDTH            : unsigned(10-1 downto 0) := to_unsigned(10, 10);
	constant XBOOST1 						: unsigned(10-1 downto 0) := to_unsigned(155, 10);
	constant XBOOST2 						: unsigned(10-1 downto 0) := to_unsigned(475, 10);
	
	
   constant SCORE_RGB		    		: std_logic_vector(23 downto 0) := x"0000DD";	
	constant HIGHSCORE_RGB		    	: std_logic_vector(23 downto 0) := x"227799";
   constant BG_RGB		    			: std_logic_vector(23 downto 0) := x"11CC88";	
   constant PLATE_RGB               : std_logic_vector(23 downto 0) := x"994422";   
	constant PLATE_LINE_RGB				: std_logic_vector(23 downto 0) := x"FF00FF";	
	constant SUBPLATE_RGB            : std_logic_vector(23 downto 0) := x"AA0000";
	constant SIDE_RGB						: std_logic_vector(23 downto 0) := x"000000";	
	constant PLATEZONE_RGB				: std_logic_vector(23 downto 0) := x"00BB55";		
   constant BALL1_RGB                : std_logic_vector(23 downto 0) := x"FF0033";
	constant BALL2_RGB                : std_logic_vector(23 downto 0) := x"FF0066";
	constant BALL3_RGB                : std_logic_vector(23 downto 0) := x"FF0099";
   constant BALL4_RGB                : std_logic_vector(23 downto 0) := x"FF00CC";
	constant BLOCK_RGB					: std_logic_vector(23 downto 0) := x"004411";
	constant BOOST_RGB					: std_logic_vector(23 downto 0) := x"2277FF";
	--constant BOOST_RGB					: std_logic_vector(23 downto 0) := x"00FF00";

	
	
	
   signal RGBxD                     : std_logic_vector(23 downto 0);
   signal XPixelxD, YPixelxD        : unsigned(10-1 downto 0);
begin
   
   GPU: process(XPixelxD, XPlatexDI, YPlatexDI, YPixelxD, XBall1xDI, YBall1xDI, XBall2xDI, YBall2xDI,
				XBall3xDI, YBall3xDI, XBall4xDI, YBall4xDI, YBoost1xDI, YBlock1xDI, YBoost2xDI, YBlock2xDI,
				XSubplatexDI, YSubplatexDI, ScorexDI, HighScorexDI)
   begin
      ------------------------------
		-- TO BE IMPLEMENTED BY YOU
		--
		-- Given XBallxDI, YBallxDI and YPlatexDI you need
	   -- to calculte the color of the pixel given by
		-- XPixelxD and YPixelxD.	
		if (YPixelxD <= unsigned(YPlatexDI) + PLATE_HEIGHT) 
			and (YPixelxD >= unsigned(YPlatexDI))
			and (XPixelxD <= (unsigned(XPlatexDI)+ PLATE_WIDTH/4 +1))	
			and (XPixelxD >= unsigned(XPlatexDI) + PLATE_WIDTH/4 -1)
					then RGBxD <= PLATE_LINE_RGB;	
					
		elsif (YPixelxD <= unsigned(YPlatexDI) + PLATE_HEIGHT) 
		   and (YPixelxD >= unsigned(YPlatexDI))
			and (XPixelxD <= (unsigned(XPlatexDI)+ 3*PLATE_WIDTH/4 +1))	
			and (XPixelxD >= unsigned(XPlatexDI) + 3*PLATE_WIDTH/4 -1)
					then RGBxD <= PLATE_LINE_RGB;

		elsif (YPixelxD <= unsigned(YPlatexDI) + PLATE_HEIGHT) 
			and (YPixelxD >= unsigned(YPlatexDI))
			and (XPixelxD <= (unsigned(XPlatexDI)+PLATE_WIDTH))	
			and (XPixelxD >= unsigned(XPlatexDI))
					then RGBxD <= PLATE_RGB;
					
		elsif (YPixelxD >= SCREEN_HEIGHT-unsigned(ScorexDI)*5)
			and (XPixelxD <= unsigned(SCORE_WIDTH))	
					then RGBxD <= SCORE_RGB;

		elsif (YPixelxD >= SCREEN_HEIGHT-unsigned(ScorexDI)*5)
			and (XPixelxD >= unsigned(SCREEN_WIDTH)-unsigned(SCORE_WIDTH))	
					then RGBxD <= SCORE_RGB;
				
		elsif (YPixelxD >= SCREEN_HEIGHT-unsigned(HighScorexDI)*5)
			and (XPixelxD <= unsigned(SCORE_WIDTH))	
					then RGBxD <= HIGHSCORE_RGB;
					
		elsif (YPixelxD >= SCREEN_HEIGHT-unsigned(HighScorexDI)*5)
			and (XPixelxD >= unsigned(SCREEN_WIDTH)-unsigned(SCORE_WIDTH))		
					then RGBxD <= HIGHSCORE_RGB;
					
		elsif(XPixelxD <= (SIDE_SIZE))	
					then RGBxD <= SIDE_RGB;
					
		elsif(XPixelxD >= (SCREEN_WIDTH-SIDE_SIZE))	
					then RGBxD <= SIDE_RGB;
					
		elsif(YPixelxD <= (SIDE_SIZE))	
					then RGBxD <= SIDE_RGB;
					
					
		elsif (YPixelxD<=(unsigned(YBoost1xDI))+BOOST_WIDTH)
				and (YPixelxD >=(unsigned(YBoost1xDI)))
				and (XPixelxD <= (unsigned(XBOOST1)+BOOST_WIDTH)) 
				and (XPixelxD >= unsigned(XBOOST1))
					then RGBxD <= BOOST_RGB;	

		elsif (YPixelxD<=(unsigned(YBoost2xDI))+BOOST_WIDTH)
				and (YPixelxD>=(unsigned(YBoost2xDI)))
				and (XPixelxD <= (unsigned(XBOOST2)+BOOST_WIDTH)) 
				and (XPixelxD >= unsigned(XBOOST2))
					then RGBxD <= BOOST_RGB;	
					
		elsif (YPixelxD<=(unsigned(YBlock1xDI)))
				and (XPixelxD <= (unsigned(XBLOCK1)+BLOCK_WIDTH)) 
				and (XPixelxD >= unsigned(XBLOCK1))
					then RGBxD <= BLOCK_RGB;					
					
		elsif (YPixelxD<=(unsigned(YBlock2xDI)))
				and (XPixelxD <= (unsigned(XBLOCK2)+BLOCK_WIDTH)) 
				and (XPixelxD >= unsigned(XBLOCK2))
					then RGBxD <= BLOCK_RGB;
					
		elsif (YPixelxD<=(unsigned(YsubplatexDI))+SUBPLATE_HEIGHT)
				and (YPixelxD >= (unsigned(YsubplatexDI))) 
				and (XPixelxD <= (unsigned(XsubplatexDI)+SUBPLATE_WIDTH)) 
				and (XPixelxD >= unsigned(XsubplatexDI))
					then RGBxD <= SUBPLATE_RGB;
					
					
		elsif (YPixelxD<=(unsigned(YBall1xDI)+BALL_HEIGHT))
				and (YPixelxD >= unsigned(YBall1xDI)) 
				and (XPixelxD <= (unsigned(XBall1xDI)+BALL_WIDTH)) 
				and (XPixelxD >= unsigned(XBall1xDI))
					then RGBxD <= BALL1_RGB;
		
		elsif (YPixelxD<=(unsigned(YBall2xDI)+BALL_HEIGHT))
				and (YPixelxD >= unsigned(YBall2xDI)) 
				and (XPixelxD <= (unsigned(XBall2xDI)+BALL_WIDTH)) 
				and (XPixelxD >= unsigned(XBall2xDI))
					then RGBxD <= BALL2_RGB;
			
		elsif (YPixelxD<=(unsigned(YBall3xDI)+BALL_HEIGHT))
				and (YPixelxD >= unsigned(YBall3xDI)) 
				and (XPixelxD <= (unsigned(XBall3xDI)+BALL_WIDTH)) 
				and (XPixelxD >= unsigned(XBall3xDI))
					then RGBxD <= BALL3_RGB;
					
		elsif (YPixelxD<=(unsigned(YBall4xDI)+BALL_HEIGHT))
				and (YPixelxD >= unsigned(YBall4xDI)) 
				and (XPixelxD <= (unsigned(XBall4xDI)+BALL_WIDTH)) 
				and (XPixelxD >= unsigned(XBall4xDI))
					then RGBxD <= BALL4_RGB;
			
		elsif (YPixelxD>=(SCREEN_HEIGHT-PLATEZONE_HEIGHT))
					then RGBxD <= PLATEZONE_RGB;
		
					
		else RGBxD <= BG_RGB;
		
		end if;
		

		-- Remeber that this can be done by a fully 
		-- combinatorial circuit as we only draw rectangles.
		------------------------------
		
   end process;

   DVI: entity bounce_graphics_v1_00_a.dvi_ctrl(rtl)
      port map(
         -- General System Signals
         ClkxCI         => ClkxCI,
         RstxRBI        => RstxRBI,
         RGBxDI         => RGBxD,
         XPixelxDO      => XPixelxD,
         YPixelxDO      => YPixelxD,
         DVI_ResetxRBO  => DVI_ResetxRBO,
         DVI_XCLKxCO    => DVI_XCLKxCO,    
         DVI_XCLKxCBO   => DVI_XCLKxCBO,
         DVI_DExSO      => DVI_DExSO,
         DVI_VSyncxSO   => DVI_VSyncxSO,
         DVI_HSyncxSO   => DVI_HSyncxSO,
         DVI_DataxDO    => DVI_DataxDO
      );

end rtl;

