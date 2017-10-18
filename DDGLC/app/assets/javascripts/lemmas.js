$( document ).on('turbolinks:load', function() {
    $("#button-semantic-field-area").click(function(e){
        e.preventDefault();
        $("#semantic-field-area").slideToggle();
    });
});