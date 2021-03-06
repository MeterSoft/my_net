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
  var _l = _L['groups'];


  Paloma.callbacks['groups']['show'] = function(params){
      Post.popover();
      Search.start();

      $('body').on('click', 'a.delete-post', function() {
          var url = $(this).data('url');
          Post.remove(url);
      });

      $('body').on('click', 'a.comment', function() {
          $('.comment').removeClass('active');
          $(this).addClass('active');
          $(this).popover();
          $(this).parents().find('#post_message').focus();
          $('.comment:not(".active")').popover('hide');
      });

      $('body').on('input', '.area_link_preview', function(){
          Link.detected(this);
      });
  };
})();