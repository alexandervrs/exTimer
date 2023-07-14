#define ex_timer_ds_grid_delete_y
///ex_timer_ds_grid_delete_y(DSGridIndex, y, shift)

/*
 * Removes a row at Y position from a DS grid
 *
 * @param   gridIndex  The DS grid index, real
 * @param   y          The Y position on the DS grid, real
 * @param   shift      (optional) Whether to shift the rest of the grid, boolean
 * 
 * @return  Returns 1 on success, 0 if reached and removed first item, real
 */

var _grid   = argument[0];
var _y      = argument[1];
var _shift  = false;

if (argument_count >= 3) {
    _shift = argument[2];
}

var _grid_width  = ds_grid_width(_grid);
var _grid_height = ds_grid_height(_grid);

if (_grid_height < 2) {

    ds_grid_clear(_grid, "");
    ds_grid_resize(_grid, ds_grid_width(_grid), 1);

    return 0;
}


if (_shift == true) {

    ds_grid_set_grid_region(_grid, _grid, 0, _y+1, _grid_width-1, _y+1, 0, _y);
    for (var _i=_y; _i <= ds_grid_height(_grid); ++_i) {
        ds_grid_set_grid_region(_grid, _grid, 0, _i+1, _grid_width-1, _i+1, 0, _i);    
    }
    
} else {
    
    ds_grid_set_grid_region(_grid, _grid, 0, _y+1, _grid_width-1, _grid_height-_y, 0, _y);
    
}

ds_grid_resize(_grid, _grid_width, _grid_height-1);

return 1;

#define ex_timer_string_split
///ex_timer_string_split(string, delimiter)

/**
 * Splits the input string into an array by a delimiter
 *
 * @param   string     The input string, string
 * @param   delimiter  (optional) The delimiter to split at, string
 * 
 * @return  Returns the string parts, array
 */

var _string = argument[0];
var _delimiter = ",";

if (argument_count >= 2) {
    _delimiter = argument[1];
}

var _position = string_pos(_delimiter, _string);
var _array;

if (_position == 0) {
    _array[0] = _string; 
    return _array;
}

var _delimiter_length = string_length(_delimiter);
var _array_length = 0;

while (true) {

    _array[_array_length++] = string_copy(_string, 1, _position - 1);
    _string = string_copy(_string, _position + _delimiter_length, string_length(_string) - _position - _delimiter_length + 1);
    _position = string_pos(_delimiter, _string);
    
    if (_position == 0) {
        _array[_array_length] = _string;
        return _array;
    }
}

#define tgr_time_get_delta
///tgr_time_get_delta()

/**
 * Returns the delta time step
 *
 * @return  Returns the delta time step, real
 */

gml_pragma("forceinline");
 
return (delta_time / (1000000 / room_speed));

#define ex_timer_class_add_timer
///ex_timer_class_add_timer(timerName, className)

var _name           = argument[0];
var _class_name     = argument[1];
var _list           = obj_ex_timer._ex_timers;
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;
var _resource       = -1;
var _autoincrement  = 0;

// check name column of classes parent grid
_class_list = ex_timer_class_get_index(_class_name);

// get asset resource
_resource = ex_timer_get_asset_index(_name);

// resize class list and set autoincrement
if (ds_grid_height(_class_list) <= 0) {
    ds_grid_resize(_class_list, 4, 1);
    ds_grid_clear(_class_list, "");
} else {
    ds_grid_resize(_class_list, 4, ds_grid_height(_class_list)+1);
    _autoincrement = ds_grid_height(_class_list)-1;
}

// add resource to class list
ds_grid_set(_class_list, 0, _autoincrement, _name);           // name
ds_grid_set(_class_list, 1, _autoincrement, _resource);       // resource id
ds_grid_set(_class_list, 2, _autoincrement, 0);               // has played
ds_grid_set(_class_list, 3, _autoincrement, 0);               // is latter

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Added timer with name "'+string( _name )+'" to timer class "'+_class_name+'" ['+string( _class_list)+ ', ' +string( _autoincrement )+']'+'');
}

// return grid y position
return _autoincrement;




#define ex_timer_class_count
///ex_timer_class_count()

var _classes_list = obj_ex_timer._ex_timer_classes;

if (not ds_exists(_classes_list, ds_type_grid)) {
    return 0;
}

if (ds_grid_height(_classes_list) < 2) {

    if (ds_grid_get(_classes_list, 0, 0) == "") {
        return 0;
    }

}

return ds_grid_height(_classes_list);




#define ex_timer_class_create
///ex_timer_class_create(className)

var _list           = obj_ex_timer._ex_timer_classes;
var _list_max_size  = 2;
var _name           = argument[0];
var _class_list     = -1;
var _autoincrement  = 0;

// create or update the classes list
if (ds_exists(_list, ds_type_grid)) {
    
// workaround
if (ds_grid_get(_list, 0, 0) == "") {

} else {

    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;

}
    
} else {
    obj_ex_timer._ex_timer_classes = ds_grid_create(_list_max_size, 1);
    _list = obj_ex_timer._ex_timer_classes;
}

// create a new class grid
_class_list = ds_grid_create(4, 0);

// add new grid
ds_grid_set(_list, 0, _autoincrement, _name);       // name
ds_grid_set(_list, 1, _autoincrement, _class_list); // class grid

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Created timer class with name "'+string( _name )+'" ['+string( _y )+']');
}




#define ex_timer_class_destroy
///ex_timer_class_destroy(className)

var _class_name     = argument[0];
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;

if (not ex_timer_class_exists(_class_name)) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Trying to destroy class but timer class with name "'+string( _class_name )+'" does not exist');
    }
    return 0;
}

// check name column of classes parent grid
var _y = ds_grid_value_y(_classes_list, 0, 0, 1, ds_grid_height(_classes_list), string( _class_name ));

_class_list = ds_grid_get(_classes_list, 1, _y);

// remove class index
if (ds_grid_height(_classes_list) < 2) {

    ds_grid_clear(_classes_list, "");
    ds_grid_resize(_classes_list, ds_grid_width(_classes_list), 1);

} else {
    ex_timer_ds_grid_delete_y(_classes_list, _y, true);
}

ds_grid_destroy(_class_list);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Destroyed timer class with name "'+string( _class_name )+'" ['+string( _y )+']');
}

return 1;




#define ex_timer_class_exists
///ex_timer_class_exists(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}




#define ex_timer_class_get_index
///ex_timer_class_get_index(className)

var _class_name     = argument[0];
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;

// check if classes exist first
if (ex_timer_class_count() < 1) {
    return -1;
}

// check name column of classes parent grid
var _cy = ds_grid_value_y(_classes_list, 0, 0, 0, ds_grid_height(_classes_list), string( _class_name ));
if (_cy < 0) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer class with name "'+string( _class_name )+'"');
    }
    return -1;
}

// get class list
_class_list = ds_grid_get(_classes_list, 1, _cy);

return _class_list;




#define ex_timer_class_pause
///ex_timer_class_pause(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_pause( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;




#define ex_timer_class_play
///ex_timer_class_play(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_play(ds_grid_get(_list, 0, _i));
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Playing all timers with class "'+string( _name )+'"');
}

return _result;




#define ex_timer_class_resume
///ex_timer_class_resume(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_resume( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;




#define ex_timer_class_set_loop
///ex_timer_class_set_loop(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_loop( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set loop to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;




#define ex_timer_class_set_position
///ex_timer_class_set_position(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_position( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set position to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;




#define ex_timer_class_set_speed
///ex_timer_class_set_speed(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_speed( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set speed to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;




#define ex_timer_class_stop
///ex_timer_class_stop(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_stop( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;



#define ex_timer_count
///ex_timer_count()

var _list = obj_ex_timer._ex_timers;

if (not ds_exists(_list, ds_type_grid)) {
    return 0;
}

if (ds_grid_height(_list) < 2) {

    if (ds_grid_get(_list, 0, 0) == "") {
        return 0;
    }

}

return ds_grid_height(_list);




#define ex_timer_create
///ex_timer_create(name, duration, speed, loop, classes, syncDelta, onComplete, onCompleteArguments)

var _list              = obj_ex_timer._ex_timers;
var _list_max_size     = _ex_timer._length;
var _autoincrement     = 0;
var _timer_name        = argument[0];
var _timer_duration    = argument[1];
var _timer_speed       = 1;
var _timer_loop        = false;
var _timer_sync_delta  = false;
var _timer_script      = -1;
var _timer_script_args = ex_timer_arguments_undefined;
var _timer_classes     = "";

if (argument_count >= 3) {
    _timer_speed = argument[2];
}

if (argument_count >= 4) {
    _timer_loop = argument[3];
}

if (argument_count >= 6) {
    _timer_sync_delta = argument[5];
}

if (argument_count >= 7) {
    _timer_script = argument[6];
}

if (argument_count >= 8) {
    _timer_script_args = argument[7];
}

// create or update the timer list
if (ds_exists(_list, ds_type_grid)) {
    
    // workaround
    if (ds_grid_get(_list, 0, 0) == "") {
    
    } else {
    
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;
    
    }

} else {
    obj_ex_timer._ex_timers = ds_grid_create(_list_max_size, 0);
    _list = obj_ex_timer._ex_timers;
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
}


// check if timer with the same name exists
var _y = ds_grid_value_y(_list, 0, 0, ds_grid_width(_list), ds_grid_height(_list), string( _timer_name ));
if (_y > -1) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, timer name "'+string( _timer_name )+'" already exists, timer names must be unique');
    }
    return -1;
}


// add timer to the list
_list[# _ex_timer._name,       _autoincrement]           = _timer_name;
_list[# _ex_timer._position,   _autoincrement]           = 0;
_list[# _ex_timer._speed,      _autoincrement]           = _timer_speed;
_list[# _ex_timer._is_playing, _autoincrement]           = false;
_list[# _ex_timer._is_paused,  _autoincrement]           = false;
_list[# _ex_timer._sync,       _autoincrement]           = false;
_list[# _ex_timer._oncomplete, _autoincrement]           = _timer_script;
_list[# _ex_timer._oncomplete_arguments, _autoincrement] = _timer_script_args;
_list[# _ex_timer._duration,   _autoincrement]           = _timer_duration;
_list[# _ex_timer._loop,       _autoincrement]           = _timer_loop;
_list[# _ex_timer._sync_delta, _autoincrement]           = _timer_sync_delta;
_list[# _ex_timer._local,      _autoincrement]           = false;

if (ex_timer_get_debug_mode()) {
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _timer_name ));
    show_debug_message('exTimer: Created timer with name "'+string( _timer_name )+'" ['+string( _y )+']');
}


if (argument_count >= 5) {
    
    if (argument[4] != "") {
        
        if (ex_timer_class_count() > 0) {

            _timer_classes = argument[4];

            // add timer to each class
            var _timer_classes_array = ex_timer_string_split(_timer_classes, " ");
            var _timer_classes_array_size = array_length_1d(_timer_classes_array);

            for (var _i=0; _i < _timer_classes_array_size; ++_i) {
                if (ex_timer_class_exists(_timer_classes_array[_i])) {
                    ex_timer_class_add_timer(_timer_name, _timer_classes_array[_i]);
                    if (ex_timer_get_debug_mode()) {
                        show_debug_message('exTimer: Added timer "'+string( _timer_name )+'" under timer class "'+_timer_classes_array[_i]+'"');
                    }
                } else {
                    if (ex_timer_get_debug_mode()) {
                        show_debug_message('exTimer: Cannot add timer "'+string( _timer_name )+'" to non-existent class "'+_timer_classes_array[_i]+'", you need to create that class first before adding the timer');
                    }
                }
            }

        }
        
    }
    
}

// return grid y position
return _autoincrement;



#define ex_timer_destroy
///ex_timer_destroy(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// remove timer
if (ds_grid_height(_list) < 2) {

    ds_grid_clear(_list, "");
    ds_grid_resize(_list, ds_grid_width(_list), 1);

} else {
    ex_timer_ds_grid_delete_y(_list, _y, true);
}


if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Destroyed timer with name "'+string( _name )+'"');
}

return 1;


#define ex_timer_exists
///ex_timer_exists(name)

var _name = argument[0];
var _list = ex_timer_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}



#define ex_timer_get_asset_index
///ex_timer_get_asset_index(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

var _y = ex_timer_get_index(_name);
if (_y < 0) {
    return 0;
}


#define ex_timer_get_debug_mode
///ex_timer_get_debug_mode()

gml_pragma("forceinline");

return obj_ex_timer._ex_timer_debug_mode;




#define ex_timer_get_duration
///ex_timer_get_duration(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get duration
return _list[# _ex_timer._duration, _y];



#define ex_timer_get_index
///ex_timer_get_index(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check if timer exist first
if (ex_timer_count() < 1) {
    return -1;
}

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    _y = -1;
}

return _y;




#define ex_timer_get_loop
///ex_timer_get_loop(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get loop
return _list[# _ex_timer._loop, _y];



#define ex_timer_get_name
///ex_timer_get_name(index)

var _timer_index = argument[0];
var _timer_list = obj_ex_timer._ex_timers;
var _out_name  = "";

if (_timer_list < 0) {
return "";
}

if (_timer_index < 0 or _timer_index > ds_grid_height(_timer_list)) {
    return "";
}

// get timer name
_out_name = _timer_list[# _ex_timer._name, _timer_index];

return _out_name;




#define ex_timer_get_position
///ex_timer_get_position(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get position
return ds_grid_get(_list, 1, _y);





#define ex_timer_get_script
///ex_timer_get_script(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get script
return _list[# _ex_timer._oncomplete, _y];






#define ex_timer_get_script_arguments
///ex_timer_get_script_arguments(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get script
return _list[# _ex_timer._oncomplete_arguments, _y];






#define ex_timer_get_speed
///ex_timer_get_speed(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get speed
return _list[# _ex_timer._speed, _y];







#define ex_timer_initialize
///ex_timer_initialize()

if (instance_exists(obj_ex_timer)) {
	
	if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, exTimer system is already initialized');
    }
	
	return 0;
}

// create exTimer object
instance_create(0, 0, obj_ex_timer);

return 1;





#define ex_timer_is_paused
///ex_timer_is_paused(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// get paused state
return _list[# _ex_timer._is_paused, _y];






#define ex_timer_is_playing
///ex_timer_is_playing(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// get playing state
return _list[# _ex_timer._is_playing, _y];




#define ex_timer_pause
///ex_timer_pause(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// set playing state
_list[# _ex_timer._is_playing, _y] = false;

// set paused state
_list[# _ex_timer._is_paused, _y] = true;

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused timer with name: "'+string( _name )+'"');
}

return 1;





#define ex_timer_pause_all
///ex_timer_pause_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_pause(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused all timers');
}

return 1;




#define ex_timer_play
///ex_timer_play(name, duration, speed, loop, syncDelta, onComplete, onCompleteArguments)

var _name              = argument[0];
var _list              = obj_ex_timer._ex_timers;
var _is_local          = false;

if (not is_string(_name)) {
    _is_local = true;
    _name = string(id)+"_"+string(_name);
}

var _timer_speed       = 1;
var _timer_position    = 0;
var _timer_loop        = false;
var _timer_sync_delta  = false;
var _oncomplete        = -1;
var _oncomplete_args   = ex_timer_arguments_undefined;

var _timer_duration    = 0;

// local timer
if (_is_local == true) {

    if (argument_count >= 2) {
        _timer_duration = argument[1];
    }
    
    if (argument_count >= 3) {
        _timer_speed = argument[2];
    }
    
    if (argument_count >= 4) {
        _timer_loop = argument[3];
    }

    if (argument_count >= 5) {
        _timer_sync_delta = argument[4];
    }
        
    if (argument_count >= 6) {
        _oncomplete = argument[5];
    }
    
    if (argument_count >= 7) {
        _oncomplete_args = argument[6];
    }

    ex_timer_play_local(_name, _timer_duration, _timer_speed, _timer_loop, _oncomplete, _oncomplete_args);

    return 1;
}

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

//defaults
_timer_speed       = _list[# _ex_timer._speed, _y];
_timer_position    = _list[# _ex_timer._duration, _y];
_timer_loop        = _list[# _ex_timer._loop, _y];
_timer_sync_delta  = _list[# _ex_timer._sync_delta, _y];
_oncomplete        = _list[# _ex_timer._oncomplete, _y];
_oncomplete_args   = _list[# _ex_timer._oncomplete_arguments, _y];

if (argument_count >= 2) {
    _timer_duration = argument[1];
}

if (argument_count >= 3) {
    _timer_speed = argument[2];
}

if (argument_count >= 4) {
    _timer_loop = argument[3];
}

if (argument_count >= 5) {
    _timer_sync_delta = argument[4];
}
    
if (argument_count >= 6) {
    _oncomplete = argument[5];
}

if (argument_count >= 7) {
    _oncomplete_args = argument[6];
}


// set playing state
_list[# _ex_timer._is_playing, _y] = true;

// set duration if applicable
if (_timer_duration >= 0) {
    _list[# _ex_timer._duration, _y] = _timer_duration; 
}

// set speed
_list[# _ex_timer._speed, _y] = _timer_speed;

// set position
_list[# _ex_timer._position, _y] = _timer_position;

// set on complete script
_list[# _ex_timer._oncomplete, _y] = _oncomplete;
_list[# _ex_timer._oncomplete_arguments, _y] = _oncomplete_args;

// set loop
_list[# _ex_timer._loop, _y] = _timer_loop;

// set sync delta
_list[# _ex_timer._sync_delta, _y] = _timer_sync_delta;

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Started timer with name: "'+string( _name )+'"');
}

return 1;





#define ex_timer_play_local
///ex_timer_play_local(...)

// for internal use only

var _name              = argument[0];
var _duration          = argument[1];
var _speed             = argument[2];
var _list              = obj_ex_timer._ex_timers;
var _list_max_size     = _ex_timer._length;
var _autoincrement     = 0;

var _loop              = argument[3];
var _oncomplete        = argument[4];
var _oncomplete_args   = argument[5];

//show_debug_message("LOCAL TIMER");
//show_debug_message("args is:"+string(_oncomplete_args));

//check if exists
var _exists = false;
var _timer_index = -1;

if (not ds_exists(_list, ds_type_grid)) {
    obj_ex_timer._ex_timers = ds_grid_create(_list_max_size, 0);
    _list = obj_ex_timer._ex_timers;
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
}


var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _name);
if (_y >= 0) {
    _exists = true;
    _timer_index = _y;
} else {
    _exists = false;
}

if (_exists == true) {
    
    _list[# _ex_timer._is_playing, _timer_index] = true;
    _list[# _ex_timer._position,   _timer_index] = _duration;
    _list[# _ex_timer._duration,   _timer_index] = _duration;
    _list[# _ex_timer._is_paused,  _timer_index] = false;
    _list[# _ex_timer._oncomplete, _timer_index] = _oncomplete;
    _list[# _ex_timer._oncomplete_arguments, _timer_index] = _oncomplete_args;
    _list[# _ex_timer._local,      _timer_index] = true;
    
} else {

    if (_list[# 0, 0] != "") {
        ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
        _autoincrement = ds_grid_height(_list)-1;
    }

    // add timer to the list and play
    _list[# _ex_timer._name,       _autoincrement] = _name;
    _list[# _ex_timer._position,   _autoincrement] = _duration;
    _list[# _ex_timer._speed,      _autoincrement] = 1;
    _list[# _ex_timer._is_playing, _autoincrement] = true;
    _list[# _ex_timer._is_paused,  _autoincrement] = false;
    _list[# _ex_timer._sync,       _autoincrement] = false;
    _list[# _ex_timer._oncomplete, _autoincrement] = _oncomplete;
    _list[# _ex_timer._oncomplete_arguments, _autoincrement] = _oncomplete_args;
    _list[# _ex_timer._duration,   _autoincrement] = _duration;
    _list[# _ex_timer._loop,       _autoincrement] = false;
    _list[# _ex_timer._local,      _autoincrement] = true;

    if (ex_timer_get_debug_mode()) {
        show_debug_message("exTimer: Created "+string(_name)+" at grid Y position: "+string(_autoincrement));
    }
    
    return 1;


}


#define ex_timer_resume
///ex_timer_resume(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

if (ds_grid_get(_list, 5, _y) == false) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Timer with name: "'+string( _name )+'" is not paused, resume aborted');
    }
    
    return 0;
}

// set playing state
_list[# _ex_timer._is_playing, _y] = true;

// set paused state
_list[# _ex_timer._is_paused, _y] = false;


if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed timer with name: "'+string( _name )+'"');
}

return 1;


#define ex_timer_resume_all
///ex_timer_resume_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_resume(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed all timers');
}

return 1;




#define ex_timer_set_debug_mode
///ex_timer_set_debug_mode(enabled)

obj_ex_timer._ex_timer_debug_mode = argument[0];



#define ex_timer_set_loop
///ex_timer_set_loop(name, loop)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// set loop
_list[# _ex_timer._loop, _y] = argument[1];

return 1;


#define ex_timer_set_position
///ex_timer_set_position(name, position)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

var _position = argument[1];
var _max = ex_timer_get_duration(_name);
if (_position > _max) {
    _position = _max;
}
if (_position < 0) {
    _position = -1;
}

// set position
_list[# _ex_timer._position, _y] = _position;

return 1;



#define ex_timer_set_script
///ex_timer_set_script(name, script, arguments)

var _name     = argument[0];
var _script   = argument[1];
var _args     = -1;

if (argument_count >= 3) {
    _args = argument[2];
}

var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

_list[# _ex_timer._oncomplete, _y] = _script;
_list[# _ex_timer._oncomplete_arguments, _y] = _args;

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Added script '+string(_script)+' for timer: "'+string( _name )+'"');
}

return 1;


#define ex_timer_set_speed
///ex_timer_set_speed(name, speed)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

return 0;
}

// set speed
_list[# _ex_timer._speed, _y] = argument[1];

return 1;


#define ex_timer_stop
///ex_timer_stop(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// set speed
_list[# _ex_timer._speed, _y] = 0;

// set position
_list[# _ex_timer._position, _y] = -1;

// set playing state
_list[# _ex_timer._is_playing, _y] = false;

// set paused state
_list[# _ex_timer._is_paused, _y] = false;

// set loop
_list[# _ex_timer._loop, _y] = false;

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped timer with name: "'+string( _name )+'"');
}

return 1;


#define ex_timer_stop_all
///ex_timer_stop_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_stop(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped all timers');
}

return 1;

