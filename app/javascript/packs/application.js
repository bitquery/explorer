// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import '../stylesheets/application'
// import "@fortawesome/fontawesome-free/js/all";
// require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
// import $ from 'jquery'
require("popper.js")
require("bootstrap")
require("widgets/dist/widgets")
import widgetsGraphiql from 'widgets/dist/widgetsGraphiql'
import widgetsGraph from 'widgets/dist/widgetsGraph'
console.log('9');

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
