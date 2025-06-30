var toArray = function( args )
{
	return Array.prototype.slice.call( args );
};
 
Function.prototype.curry = function()
{
	if ( arguments.length < 1 )
    {
    	// nothing to curry with -> return function
    	return this;
    }
	var __method = this;
	var args = toArray( arguments );
	return function()
    {
    	return __method.apply( this, args.concat( toArray( arguments ) ) );
    };
};

Number.prototype.clamp = function(min, max)
{
	return Math.min(Math.max(this, min), max);
};

var parseIntEx = function(val, esc)
{
	val = parseInt(val);
	if (isNaN(val))
	{
		return esc;
	}
	else
	{
		return val;
	}
}

var normalizeInt = function(val)
{
	if (val < 0)
	{
		return -1;
	}
	else if (val > 0)
	{
		return 1;
	}
	return 0;
}


var isFunction = function(obj)
{
	var getType = {};
	return obj && getType.toString.call(obj) === '[object Function]';
};

function isEmpty(str)
{
    return (!str || 0 === str.length);
}