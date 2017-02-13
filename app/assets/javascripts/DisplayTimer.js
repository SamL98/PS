$(document).ready(function() {
  var start = Date.now();
  var id = gon.subjId;
  var rand_index = gon.randIndex;
  var index = gon.index;
  console.log('showing article ' + index + ' at index ' + rand_index + ' for ' + id);
  function logVisit() {
    console.log('logging visit');
    
    $.post('/log', {subj_id: id, article: {index: index, rand_index: rand_index, time_spent: Date.now()-start,
    code: gon.code, lure: gon.isLure, cand: gon.cand, cond: gon.cond}},
      function(response) {
    });
    document.removeEventListener('turbolinks:before-cache', logVisit);
  }
  document.addEventListener('turbolinks:before-cache', logVisit);

  if (gon.title) {
    document.getElementById('title').innerHTML = gon.title;
  }
  if (gon.text) {
  document.getElementById('content').innerHTML = gon.text;
  }
});