class @StaticContactsMap extends @ContactsMap
  initMap: (containerId) ->
    @map = $("[id=#{containerId}]");
    @pois = []

  addContact: (contact) ->
    @pois.push "BC,#{contact.latitude},#{contact.longitude}"

  getMapUrl: () ->
    mapUrlSufix = ''
    mapUrlSufix += "&#{key}=#{value}"  for key, value of this.getMapAttributes()
    BS.BASE_MAP_URL + mapUrlSufix


  getMapAttributes: () ->
    result = {
      size: this.getMapSize(),
      scalebar: 'false'
    }
    if @pois.length > 0
      result['xis'] = this.getPois()
    else
      result['center'] = '50.505,-100.09'
      result['zoom'] = 1
    result

  getMapSize: () ->
    "#{@map.outerWidth()},#{@map.outerHeight()}"

  getPois: () ->
    "http://cdn.leafletjs.com/leaflet-0.5/images/marker-icon.png,#{@pois.length},#{@pois.join(',')}"

  updateMapUrl: () ->
    @map.css({
      backgroundImage: "url('#{this.getMapUrl()}')"
    })


  afterCreate: () ->
    this.updateMapUrl()
    $(window).resize this.updateMapUrl.bind(this)
