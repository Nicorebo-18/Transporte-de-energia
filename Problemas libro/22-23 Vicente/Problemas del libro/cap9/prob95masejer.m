<!DOCTYPE html>
<html lang="" dir="" class="Mrphs-html">
    <head>
        <meta charset="utf-8">
        <title>Identificación obligatoria - MiAulario/NireIkasgelategia</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">        
        <link href="/library/skin/morpheus-default/tool.css" type="text/css" rel="stylesheet" media="all" />
        <script src="/library/skin/morpheus-default/js/lib/modernizr.js"></script>
        </head>
    <body class="portalBody Mrphs-portalBody">
    	<form id="Mrphs-xlogin" method="post" action="https://miaulario.unavarra.es/access/login" >
            <h1>Identificación obligatoria</h1>
            <aside class="logo"></aside>
                            		<fieldset>	
    			<label for="eid">Identificador</label>
    			<input name="eid" id="eid" value="" type="text" autocomplete="username" size="15"/>
    			<label for="pw">Contraseña</label>
    			<input name="pw" id="pw" value="" type="password" autocomplete="current-password" onfocus="this.passwordfocus = true; " size="15"/>
    			    			<p class="buttons">
    			    				<input name="submit" type="submit" id="submit" value="Identificarse"/>
    			    			</p>
    			    				<p>
    					<a href="https://miaulario.unavarra.es/portal/site/!gateway/page/9e737ca2-0e4a-40ea-98c6-69e706bd2fdd">¿Ha olvidado su contraseña?</a>
    				</p>
    			    		</fieldset>
    	</form>
    	    	<script>
    		var portal       = 'body';
    	    var needJQuery   = true;
    	    var secondJQuery = false;
    	    if ( window.jQuery ) {
    	        tver = jQuery.fn.jquery;
    	        if ( tver.indexOf('1.9.') == 0 ) {
    	            needJQuery = false;
    	        } else {
    	            secondJQuery = true;
    	        }
    	    }
    	    if ( needJQuery ) {
    	        document.write('\x3Cscript src="/library/webjars/jquery/1.12.4/jquery.min.js">'+'\x3C/script>')
    	        document.write('\x3Cscript src="/library/webjars/jquery-ui/1.12.1/jquery-ui.min.js">'+'\x3C/script>')
    	        document.write('\x3Cscript src="/library/webjars/jquery-migrate/1.4.1/jquery-migrate.min.js">'+'\x3C/script>')
    	    }
    	</script>
    	<script>
    	    $PBJQ = jQuery; // The Portal's jQuery (also in $ for now)
    	</script>
    	<script src="/library/skin/morpheus-default/js/morpheus.scripts.min.js"></script>
    	<script src="/library/js/caps-lock-checker.js"></script>
    </body>
</html>
