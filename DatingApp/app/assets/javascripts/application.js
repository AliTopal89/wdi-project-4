// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$(document).ready(function() {
  $('body').append('<div class="time">');

  Number.prototype.map = function(in_min, in_max, out_min, out_max) {
    return (this - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }

  function rotate(element, degrees) {
    element.css({
      'transform': 'rotate(' + degrees + 'deg)'
    });
  }

  function setTime() {
    var date = new Date();
    var sec = date.getSeconds();
    var min = date.getMinutes();
    var hrs = date.getHours();

    var mapSec = sec.map(0, 59, 0, 360);
    var mapMin = min.map(0, 59, 0, 360);
    var mapHrs = hrs.map(0, 12, 0, 360);

    if (sec == 0) {
      $('.seconds-hand').removeClass('smooth');
    } else {
      $('.seconds-hand').addClass('smooth');
    }

    if (min == 0) {
      $('.minute-hand').removeClass('smooth');
    } else {
      $('.minute-hand').addClass('smooth');
    }

    if (hrs == 0) {
      $('.hour-hand').removeClass('smooth');
    } else {
      $('.hour-hand').addClass('smooth');
    }

    rotate($('.seconds-hand'), mapSec);
    rotate($('.minute-hand'), mapMin);
    rotate($('.hour-hand'), mapHrs);
  }

  setInterval(function() {
    setTime()
  }, 1);

  var Clock = (function(){  
  var exports = function(element) {
    this._element = element;
    var html = '';
    for (var i=0;i<6;i++) {
      html += '<span>&nbsp;</span>';
    }
    this._element.innerHTML = html;
    this._slots = this._element.getElementsByTagName('span');
    this._tick();
  };
  exports.prototype = {
    _tick:function() {
      var time = new Date();
      this._update(this._pad(time.getHours()) + this._pad(time.getMinutes()) + this._pad(time.getSeconds()));
      var self = this;
      setTimeout(function(){
        self._tick();
      },1000);
    },
    _pad:function(value) {
      return ('0' + value).slice(-2);
    },
    _update:function(timeString) {
      var i=0,l=this._slots.length,value,slot,now;
      for (;i<l;i++) {
        value = timeString.charAt(i);
        slot = this._slots[i];
        now = slot.dataset.now;
        if (!now) {
          slot.dataset.now = value;
          slot.dataset.old = value;
          continue;
        }
        if (now !== value) {
          this._flip(slot,value);
        }
      }
    },
    _flip:function(slot,value) {
      slot.classList.remove('flip');
      slot.dataset.old = slot.dataset.now;
      slot.dataset.now = value;
      slot.offsetLeft;
      slot.classList.add('flip');
    }
  };
  return exports;
}());
var i=0,clocks = document.querySelectorAll('.clock'),l=clocks.length;
for (;i<l;i++) {
  new Clock(clocks[i]);
}
});


