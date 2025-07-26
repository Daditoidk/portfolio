'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "daae069476a6ad30817a040d18dfe308",
"version.json": "b90b07ff45a853692a4aa3076296c822",
"index.html": "639d01b3cc40cab06b5111e078b0b037",
"/": "639d01b3cc40cab06b5111e078b0b037",
"main.dart.js": "a66810345150e890a7d0d1a9185fd07a",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "afbad595473125d9919e55440bb9d114",
"assets/AssetManifest.json": "3edf30482565ccacc3cea8954bd62557",
"assets/NOTICES": "f3ca4c86d39e1abf1b00d219e7ddb6a6",
"assets/FontManifest.json": "a07851e17ef72c0f3bf86685f5668000",
"assets/AssetManifest.bin.json": "74d0dfb68a322582d5254c0941db2408",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "1ad85dac6c8ef21b05d8477e1378826e",
"assets/fonts/MaterialIcons-Regular.otf": "dcf208a1cfa5c4bfc3cbcac7abb8dffd",
"assets/assets/Camilo%2520Santacruz%2520Abadiano%2520resume.pdf": "a46c2936093c2b0e89896002fe54bc8b",
"assets/assets/blueprints/chip.png": "05e1b8f2c8fbbe7b56f56303e1684c3b",
"assets/assets/blueprints/small%2520device.png": "9a1d15019030b7cf154447804d7fcf6a",
"assets/assets/blueprints/rare%2520device.png": "e967dfd1905b65bac89e5981bd4cbdcb",
"assets/assets/blueprints/plano.png": "3be4cc2e453e853a49a5ae2691e5bbfa",
"assets/assets/blueprints/celular%2520plano.png": "0fec5c4c6dae7839d1b8259f26b5186d",
"assets/assets/bgs/lab_bg.jpg": "be0e55751ccefc64887f9948c6c14c1f",
"assets/assets/bgs/avatar.jpg": "beb20c0f8cda4a2b437a91ddb75f8cde",
"assets/assets/bgs/stable_lab_bg.jpg": "68d953eba979a03ddb534da9e819d9c4",
"assets/assets/bgs/futuristic_dialog.png": "8eda5a1b70568434a56d02c21bf0d896",
"assets/assets/device_frames/phone_frame.png": "4fe8679bbe9f591c587708303cb89d0d",
"assets/assets/device_frames/laptop_frame.png": "aeb7301bd476f71ae06dfeba97b78db2",
"assets/assets/icons/github.png": "0b5a08329908daddeca171aa8d85a084",
"assets/assets/icons/linkedin.png": "682ec8b2207b3069e62ba93558a35a9d",
"assets/assets/fonts/OpenDyslexic-Bold.otf": "e3c427f3b9acc67a60085cdbcf4cc087",
"assets/assets/fonts/OpenDyslexic-Regular.otf": "57618c912a50080a2dd15770753b535a",
"assets/assets/demos/b4s/in_line_appbar.png": "de7ca29ba930e59512042d40e47d4f22",
"assets/assets/demos/b4s/red_flag.png": "3886cb8ff3337d1bd9d0dec6e308ac9a",
"assets/assets/demos/b4s/ball_lock.png": "964b44103227c7df96a0cfd56b2519dd",
"assets/assets/demos/b4s/gray_flag.png": "82fe739542f17fa33595448372c67b80",
"assets/assets/demos/b4s/green_flag.png": "5c0ce8737ecbfa55fc65be2fe49eafae",
"assets/assets/demos/b4s/out_line.png": "0f55c1cfd6e3cedb2fb20b00aa592ba2",
"assets/assets/demos/b4s/fire.svg": "0cfce176247f9b28a289d08c5e082d48",
"assets/assets/demos/b4s/bell.svg": "85803e16322effed0acd4b2f7046b86a",
"assets/assets/demos/b4s/field.png": "65c05c736b5c47a0670d152641a1cf49",
"assets/assets/demos/b4s/shieldStar.svg": "022418f8a339f0cf4ddc33c18464fa41",
"assets/assets/demos/b4s/logo_clean.svg": "83bf5935f2f9d759aa060c4665f2227b",
"assets/assets/demos/b4s/ball_unlock.png": "6e18f12353228556b0da8772bfc49b24",
"assets/assets/demos/b4s/yellow_flag.png": "838d4854aab01fbd777eeffe1223c534",
"assets/assets/demos/b4s/in_line.png": "67db4f4f3f08c858570cc7437977b920",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
