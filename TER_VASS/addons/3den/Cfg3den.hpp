/*
	Header: Cfg3den.hpp

	Description:
		Main config for Eden.
		https://community.bohemia.net/wiki/Eden_Editor:_Configuring_Attributes

	Authors:
		Terra

	Includes:
		- 3den\AttributeCategories\VASS.hpp
		- 3den\Attributes\Base.hpp
		- 3den\Attributes\addAction.hpp
		- 3den\Attributes\AmmoBox2.hpp

	Included by:
		- 3den\config.cpp
*/
class Cfg3den
{
	class Object
	{
		class AttributeCategories
		{
			#include "AttributeCategories\VASS.hpp"
		};
	};
	class Attributes
	{
		#include "Attributes\Base.hpp"
		#include "Attributes\addAction.hpp"
		#include "Attributes\AmmoBox2.hpp"
	};
};
