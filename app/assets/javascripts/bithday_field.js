$(function() {
  $('#user_birthday').datepicker({ appendText: "(dd-mm-yyyy)", 
                                     changeYear: true, 
                                     changeMonth: true, 
                                     dateFormat: "dd-mm-yy", 
                                     duration: "slow", 
                                     firstDay: 1, 
                                     showAnim: "fold",
                                     showButtonPanel: true,
                                     showMonthAfterYear: true,
                                     yearRange: "c-70:c" });
});
