//the paul irish log function - http://paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log=function(){log.history=log.history||[];log.history.push(arguments);if(this.console){console.log(Array.prototype.slice.call(arguments))}};

/* external js template load with a cache */
function render(path) {
    if ( !render.tmpl_cache ) {
        render.tmpl_cache = {};
    }

    if ( ! render.tmpl_cache[path] ) {
        var tmpl_url = path + '.html';

        var tmpl_string;
        $.ajax({
            url: tmpl_url,
            method: 'GET',
            async: false,
            success: function(data) {
                tmpl_string = data;
            }
        });
        render.tmpl_cache[path] = _.template(tmpl_string);
    }
    return render.tmpl_cache[path];
}