class @ContactsMap
  getDefaultOptions: () ->
    {}

  constructor: (containerId, options) ->
    @options = $.extend(this.getDefaultOptions(), options)
    @container = $("##{containerId}")
    this.preInitContainer()
    this.setPreloader()
    this.getContacts()

  preInitContainer: () ->
    @container.css({
      height: @options.height
    }) if @options.height

  setPreloader: () ->
    @container.css({
      backgroundImage: "url('#{BS.PRELOADER_URL}')",
      backgroundPosition: 'center center',
      backgroundColor: 'white'
      backgroundRepeat: 'no-repeat'
    })

  getContacts: () ->
    throw "data-url required" unless url = @container.data('url')
    $.get url, this.onContactsLoaded.bind(this)

  onContactsLoaded: (contacts) ->
    this.initMap(@container.attr('id'));
    this.addContacts(this.filterContacts(contacts));
    this.afterCreate();


  filterContacts: (contacts) ->
    result = []
    for contact in contacts
      result.push(contact) if contact && contact.latitude && contact.longitude
    result

  addContacts: (contacts) ->
    this.addContact contact for contact in contacts

  # Abstract
  initMap: (containerId) ->

  # Abstract
  addContact: (contact) ->

  # Abstract
  afterCreate: () ->
