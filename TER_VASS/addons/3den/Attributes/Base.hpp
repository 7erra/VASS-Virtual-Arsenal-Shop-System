/*
	Header: Base.hpp

	Description:
		Common 3den controls used as base classes for 3den attributes.

	Authors:
		Terra

	Includes:
		None

	Included by:
		- 3den\Cfg3den.hpp
*/
class Default;
class Title: Default
{
	class Controls
	{
		class Title: ctrlStatic
		{
			style = 1;
			x = 0;
			w = ATTRIBUTE_TITLE_W * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
			colorBackground[] = {0,0,0,0};
		};
	};
};
class TitleWide: Default
{
	class Controls
	{
		class Title: ctrlStatic
		{
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
			colorBackground[] = {0,0,0,0};
		};
	};
};
