$(document).on('turbolinks:load', function() {
  var days = $("#disabled_days").val();
  var slot_range = $("#slot_range").val();
  var start_time = $("#start_time").val();
  var end_time = $("#end_time").val();
  var doctor_id = $("#doctor_id").val();
  var time = $("#timepicker").val();

  $('.datepicker').datepicker({
      format: "dd-mm-yyyy",
      autoclose: true,
      startDate: '-d',
      endDate: '+30d',
      daysOfWeekDisabled: days
  });

  $(".datepicker").change(function() {
      var date = $("#datepicker").val();
      while (time.firstChild) time.removeChild(time.firstChild);
      $.ajax({
          url: "/appointments/find_appointment?date=" + date + "&doctor_id=" + doctor_id,
          type: "GET",
          success: function(data) {

              $('.timepicker').timepicker({
                  scrollDefault: 'now',
                  step: slot_range,
                  minTime: start_time,
                  maxTime: end_time,
                  disableTimeRanges: data
              });
          }
      });
  });


});
