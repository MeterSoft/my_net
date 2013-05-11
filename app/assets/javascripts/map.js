$(document).ready(
    function() {
        $(".map").on("click", ".action", function() {
            var action, img, zoom, latitude, longitude;
            console.log('te');
            zoom = parseInt($(".map").data("zoom"));
            action = $(this).data("action");
            latitude = $(".map").data("latitude");
            longitude = $(".map").data("longitude");
            if (action === "up") {
                if (zoom < 30) {
                    zoom = zoom + 1;
                }
            } else {
                if (zoom > 1) {
                    zoom = zoom - 1;
                }
            }
            $(".map").data("zoom", zoom);
            img = "http://maps.googleapis.com/maps/api/staticmap?zoom=" + zoom + ("&size=600x300&maptype=roadmap&markers=color:red%7Ccolor:red%7Clabel:C%7C" + latitude + "," + longitude + "&sensor=false");
            $(".map_section").html("<img src=" + img + ">");
        });
    });