function fn(d) = max(50, round(d) * ($preview?1:3)); 
function steps(d) = max(80,4*round(d)); //# used for threading - odd numbers will cause error: PolySet has nonplanar faces. 


//echo("$fn(50)", fn(50));

