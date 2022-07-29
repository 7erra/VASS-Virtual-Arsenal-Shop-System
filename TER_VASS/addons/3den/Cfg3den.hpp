/*
Description:
	Main config for Eden.
	https://community.bohemia.net/wiki/Eden_Editor:_Configuring_Attributes
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
