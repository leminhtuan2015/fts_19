$(function() {
  $("#search").keyup(function() {
    $.get($("#search").attr("action"), $("#search").serialize(), null, "script");
    return false;
  });
});