var language = 'de'
var version = '1.0.15'
window.onload = () => {
  "use strict";
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("./service-worker.js");
  }
};
document.onreadystatechange = function () {
  if (document.readyState === "interactive") {
    language = getLanguage()
    document.getElementById('language').value = language
    document.getElementById('version').innerHTML = version
    createMixedVerb()
    setStrings()
  }
};
function changeLanguage () {
  language = document.getElementById('language').value
  document.documentElement.setAttribute("lang", language);
  // TODO: set language in manifest.json
  // TODO: set language in meta tags
  localStorage.setItem('lang', language)
  createMixedVerb()
  setStrings()
}
function setStrings() {
  document.getElementById('button').innerHTML = strings[language].button
  document.getElementById('donate').innerHTML = strings[language].donate
  document.getElementById('language_de').innerHTML = strings[language].language_de
  document.getElementById('language_en').innerHTML = strings[language].language_en
  document.getElementById('language_fr').innerHTML = strings[language].language_fr
  //document.getElementById('language_it').innerHTML = strings[language].language_it
  document.getElementById('language_es').innerHTML = strings[language].language_es
  document.getElementById('impressum').innerHTML = strings[language].impressum
  document.getElementById('privacy').innerHTML = strings[language].privacy
}
function createMixedVerb () {
  var front = verbs[language][Math.floor(Math.random()*verbs[language].length)][0]
  var back = verbs[language][Math.floor(Math.random()*verbs[language].length)][1]
  document.getElementById('verb').innerHTML = front + ' ' + back
}
function getLanguage () {
  // QueryString > localStorage > browser language
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.has('lang')) {
    return urlParams.get('lang')
  }
  if (localStorage.getItem('lang')) {
    return localStorage.getItem('lang')
  }
  return navigator.language.substring(0,2)
}