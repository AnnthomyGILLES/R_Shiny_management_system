var socket_timeout_interval
var n = 0
$(document).on('shiny:connected', function(event) {
    socket_timeout_interval = setInterval(function() {
        Shiny.onInputChange('count', n++)
        console.log(n)
    }, 15000)
});
$(document).on('shiny:disconnected', function(event) {
    clearInterval(socket_timeout_interval)
});