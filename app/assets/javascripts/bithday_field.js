$(function() {
  $('#user_birthday').datepicker({  changeYear: true, 
                                    changeMonth: true, 
                                    duration: "slow",
                                    dateFormat: "dd-mm-yy", 
                                    firstDay: 1, 
                                    showAnim: "fold",
                                    showButtonPanel: true,
                                    showMonthAfterYear: true,
                                    yearRange: "c-70:c" });
});
