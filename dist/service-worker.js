let cacheName="verbshaker",filesToCache=["/","/index.html","/css/index.css","/js/index.js","/js/verbs.js","/js/strings.js"];self.addEventListener("install",e=>{e.waitUntil(caches.open(cacheName).then(function(e){return e.addAll(filesToCache)}))}),self.addEventListener("fetch",s=>{s.respondWith(caches.match(s.request).then(e=>e||fetch(s.request)))});