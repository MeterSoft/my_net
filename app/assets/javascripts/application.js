// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-fileupload
//= require_tree .

$(document).ready(function() {
    var count_msg = 0;
    var count_invite = 0;

    update_date();
    setInterval(update_date, 10000);

    function update_date() {
        $.ajax({
            url: "/messages_counts",
            success: function (data, textStatus) {
                if (data.count != null) {
                    $('#msg_count').text(' (' + data.count + ')');
                    if (count_msg < data.count) {
                        $('#mes_sound').html('<embed src="/audios/tik.mp3" hidden="true" autostart="true" loop="false" />');
                        count_msg = data.count;
                    }
                } else {
                    $('#msg_count').text('');
                }
                if (data.invite != null) {
                    $('#invite_count').text(' (' + data.invite + ')');
                    if (count_invite < data.count) {
                        $('#mes_sound').html('<embed src="/audios/tik.mp3" hidden="true" autostart="true" loop="false" />');
                        count_invite = data.count;
                    }
                } else {
                    $('#invite_count').text('');
                }
            }
        });
    }
});
