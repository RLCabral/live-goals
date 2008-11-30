/*
* Scroll it! v0.01 - jQuery menu widget
* Copyright (c) 2008 Andres Pi
*
* andres(at)dreamsiteweb.com
*
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*/

(function($) {
		  
jQuery.fn.scrollIt = function(settings){
	return this.each(function(i) {
			$this = $(this);
			settings = jQuery.extend({
						   //altura del contenedor del ul
						   menuHeight : 100,
						   //altura de cada item de la lista
						   lineHeight : 20,
						   //duration de la animacion
						   scrollDuration : 500,
						   //class del contenedor
						   scrollItwrapper : 'scrollItwrapper'
					   }, settings);
									 
			
			//seteo el tiempo del intervalo segun el tiempo de la animacion
			var scrollInterval = settings.scrollDuration + 1;
		   
			/*le agrego la clase al menu para que tome los demas 
			estilos css y para que tome la altura deseada para el menu*/
			$this.addClass('scroll-menu').css('height',settings.menuHeight);
			
			//agrego un padre para que despues contenga las flechas
			$this.wrap('<div class=' + settings.scrollItwrapper + '></div>');
	
			//agrego las flechas
			$this.parent().prepend('<div class="scroll-it-up scroll-menu-up-' + i + '"></div>');
			$this.parent().append('<div class="scroll-it-down scroll-menu-down-' + i + '"></div>');
			
			//capturo el elemento a mover
			var menuList = $($this.children());
			//obtengo su margin-top y lo guardo en una variable
			//var menuListMargin = parseInt(menuList.css('margin-top'));
			//lo seteo en 0 porque deberia ser el valor inicial y no lo es en webkit
			var menuListMargin = 0;
	
			/*saco la diferencia entre la altura de la lista
			y su contenedor para saber el limite del scroll*/
			var menuListHeight = menuList.height() - $this.height();	
				
			//funciones para subir y bajar
			function scrollMenuUp(){
				if(menuListMargin < 0){
					//seteo el nuevo margen y lo guardo
					menuListMargin += settings.lineHeight;
					//muevo la lista
					menuList.animate({ 
						marginTop: menuListMargin
					}, settings.scrollDuration );				
				}else{
					//borro el intervalo si ya no es mas necesario
					clearInterval(intervalo);
				}
			}//fin funcion scrollMenuUp
			
			function scrollMenudown(){
				//chequeo que margen no sea superior a lo que se puede
				if(Math.abs(menuListMargin) < menuListHeight){
					//seteo el nuevo margen y lo guardo
					menuListMargin -= settings.lineHeight;
					//muevo la lista
					menuList.animate({ 
						marginTop: menuListMargin
					}, settings.scrollDuration );
				}else{
					//borro el intervalo si ya no es mas necesario
					clearInterval(intervalo);
				}
			}//fin funcion scrollMenudown
		
			//acciones en el mouse
			$("." + settings.scrollItwrapper + " .scroll-menu-down-" + i ).hover(
				function () {
					//seteo el intervalo en que se llama a la funcion
					intervalo = setInterval(scrollMenudown, scrollInterval);
					//agrego clase para cambia la imgen del boton
					$(this).addClass('arrow-hover');
				},
				function(){
					//agrego clase para cambia la imgen del boton y borro el intervalo
					$(this).removeClass('arrow-hover');
					clearInterval(intervalo);
		
				}
			);
					
			$("." + settings.scrollItwrapper + " .scroll-menu-up-" + i ).hover(
				function () {
					//seteo el intervalo en que se llama a la funcion
					intervalo = setInterval(scrollMenuUp, scrollInterval);
					//agrego clase para cambia la imgen del boton
					$(this).addClass('arrow-hover');
				},
				function(){
					//agrego clase para cambia la imgen del boton y borro el intervalo
					$(this).removeClass('arrow-hover');
					clearInterval(intervalo);
				}
			);	
	});
};
	

})(jQuery);