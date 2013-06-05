(function(){
  // You access variables from before/around filters from _x object.
  // You can also share variables to after/around filters through _x object.
  var _x = Paloma.variableContainer;

  // We are using _L as an alias for the locals container.
  // Use either of the two to access locals from other scopes.
  //
  // Example:
  // _L.otherController.localVariable = 100;
  var _L = Paloma.locals;

  // Access locals for the current scope through the _l object.
  //
  // Example:
  // _l.localMethod(); 
  var _l = _L['messages'];


  Paloma.callbacks['messages']['show'] = function(params){
      $('#show-scrolling')[0].scrollTop = $('#show-scrolling')[0].scrollHeight;

      $('.conversation_area').on('keypress', function(e) {
          var code = (e.keyCode ? e.keyCode : e.which);
          if(code == 13) {
              e.preventDefault();
              $('.conversation_form').submit();
              $('.conversation_area').val('');
          }
      });

      $('.conversation_button').on('click', function() {
          $('.conversation_form').submit();
          $('.conversation_area').val('');
      });
  };
})();