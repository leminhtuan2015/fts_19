var $countdown;
incrementTime = 70;
currentTime = 20*6000;
 
function updateTimer(){
  $countdown.html(formatTime(currentTime));
  document.getElementById("time").value = currentTime;
  if(currentTime == 0){
    Timer.stop();
    timerComplete();
    resetCountdown();
    return;
  }
  currentTime -= incrementTime / 10;
  if(currentTime < 0) currentTime = 0;
}

function timerComplete(){
  alert('Oops. time is up.!');
  $('#exam_form').submit();
}

function init(){
  $countdown = $('#countdown');
  Timer = $.timer(updateTimer, incrementTime, true);
}

function resetCountdown(){
  var newTime = 400;
  if(newTime > 0){currentTime = newTime;}
  this.Timer.stop();
}

function pad(number, length){
  var str = '' + number;
  while(str.length < length){str = '0' + str;}
  return str;
}

function formatTime(time){
  var min = parseInt(time / 6000),
    sec = parseInt(time / 100) - (min * 60),
    hundredths = pad(time - (sec * 100) - (min * 6000), 2);
  return (min > 0 ? pad(min, 2) : "00") + ":" + pad(sec, 2) + ":" + hundredths;
}