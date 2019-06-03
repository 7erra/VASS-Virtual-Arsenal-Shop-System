_array = ["0",0,"1",1,"2",2,"3","3","3","4",4,5,"5",5,"6"];
_pairs = [];
for "_i" from 0 to (count _array -1) do {
	_item = _array select _i;
	_count = [_array select _i+1];
	_count = _count param [0,1];
	if !(_count isEqualType 1234) then {
		//--- Next item is not a number, default value
		_count = 1;
	};
	if (_item isEqualType "") then {
		_pairs = [_pairs,_item,_count] call BIS_fnc_addToPairs;
	};
};
_pairs