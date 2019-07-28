// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require materialize-sprockets
//= require_tree .


document.addEventListener('turbolinks:load', function() {
  console.log('turboload');
  initModals();
});

document.addEventListener('DOMContentLoaded', function() {
  console.log('domready');
  initModals();
});

function initModals(){
  var elems = document.querySelectorAll('.modal');
  var options = {
    dismissible: true
  }
  var instances = M.Modal.init(elems, options);
}

// document.addEventListener('DOMContentLoaded', function() {
//   var elems = document.querySelectorAll('.autocomplete');
//   var options = {
//     data: {
//       'ABC': null,
//       'DEF': null
//     }
//   }
//   var instances = M.Autocomplete.init(elems, options);
// });


function dismissModal(modalId){
  var modalEl = document.getElementById(modalId);
  var modalInstance = M.Modal.getInstance(modalEl);

  modalInstance.close();
}

function initFolderAutocomplete(folders){
  var elems = document.querySelectorAll('.autocomplete');
  var folderData = {};
  for (i = 0; i < folders.length; ++i) folderData[folders[i]] = null;

  var options = {
    data: folderData,
    onAutocomplete: (val) => {
      window.location.href = '/folder/search/'+val;
    }
  }
  M.Autocomplete.init(elems, options); 
}
