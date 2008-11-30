jQuery(document).ready(function()
{
	slide("#sliding-navigation", 25, 15, 150, .8);
});

function slide(navigation_id, pad_out, pad_in, time, multiplier)
{
	// creates the target paths
	var list_elements = navigation_id + " li.sliding-element";
	var link_elements = list_elements + " a";
	
	// initiates the timer used for the sliding animation
	var timer = 0;
	
	// creates the slide animation for all list elements 
	jQuery(list_elements).each(function(i)
	{
		// margin left = - ([width of element] + [total vertical padding of element])
		jQuery(this).css("margin-left","-180px");
		// updates timer
		timer = (timer*multiplier + time);
		jQuery(this).animate({ marginLeft: "0" }, timer);
		jQuery(this).animate({ marginLeft: "15px" }, timer);
		jQuery(this).animate({ marginLeft: "0" }, timer);
	});

	// creates the hover-slide effect for all link elements 		
	jQuery(link_elements).each(function(i)
	{
		jQuery(this).hover(
		function()
		{
			jQuery(this).animate({ paddingLeft: pad_out }, 150);
		},		
		function()
		{
			jQuery(this).animate({ paddingLeft: pad_in }, 150);
		});
	});
}
