L.ToggleControl = L.Control.extend({
    options: {
        name: 'toggle-control',
        position: 'topright',
        callback: null
    },

    initialize: function(controls, options) {
        $.extend(this.options, options);
        if (!$.isFunction(this.options.callback))
            throw 'callback is required and must be a function';
        this.controls = controls;
    },

    onAdd: function () {
        var self = this;
        var container = L.DomUtil.create('div', 'leaflet-toggle-control');
        var $container = $(container);
        var $labelsContainer;
        $container
            .append(
                $('<a>')
                    .addClass('leaflet-toggle-control-toggle')
            )
            .append(
                $('<form>')
                    .addClass('form form-horizontal')
                    .append(
                        $labelsContainer = $('<div>')
                    )
            );

        $.each(this.controls, function(index, value) {
            $labelsContainer.append(self.createControl(value, index == 0));
        });

        return container;
    },

    onRemove: function() {
        throw 'onRemove function is not overridden';
    },

    createControl: function(label, isChecked) {
        var self = this;
        return $('<label>')
            .addClass('radio')
            .append(
                $('<input>')
                    .addClass('leaflet-toggle-control-selector')
                    .prop({
                        name: this.options.name,
                        type: 'radio',
                        checked: isChecked,
                        value: label
                    })
                    .change(function() {
                        self.options.callback($(this).val());
                    })
            )
            .append(
                $('<span>')
                    .html(label)
            )
    }
});
