var language = 'de' // TODO: load from localStorage or QueryString
document.onreadystatechange = function () {
  if (document.readyState === "interactive") {
    createMixedVerb(language)
  }
};
function createMixedVerb (language) {
  var front = verbs[language][Math.floor(Math.random()*verbs[language].length)][0]
  var back = verbs[language][Math.floor(Math.random()*verbs[language].length)][1]
  document.getElementById('verb').innerHTML = front + ' ' + back
}
var verbs = {
  "de": [
    ["Der frühe Vogel", "fängt den Wurm"],
    ["Die Axt im Haus", "erspart den Zimmermann"]
  ]
}
// TODO: add verbs to verbs array and languages from database

// TODO: pwa https://www.loginradius.com/blog/engineering/build-pwa-using-vanilla-javascript/

// TODO: add versioning