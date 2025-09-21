'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "8eecd11f23a0f628ee26debdfef14271",
"version.json": "b90b07ff45a853692a4aa3076296c822",
"index.html": "639d01b3cc40cab06b5111e078b0b037",
"/": "639d01b3cc40cab06b5111e078b0b037",
"main.dart.js": "462ad8274ab510cab68e260362eda167",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "58716193b23d9ea6134318679ca59ab9",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "afbad595473125d9919e55440bb9d114",
"assets/AssetManifest.json": "f2ca4d8b9a5c417dd480c296e6def502",
"assets/NOTICES": "64d2ae8e58ccb1de53db63397165d76e",
"assets/FontManifest.json": "9857c1de1f7ef355a9888c0c5c22f12f",
"assets/AssetManifest.bin.json": "097edb7649e9d55accfab8c6e5d5e38a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "bb05bf86cd211937060e06cf948e21c3",
"assets/fonts/MaterialIcons-Regular.otf": "c6bc35a8600c512d67c5d913adfb6033",
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
"assets/assets/icons/csa.png": "58716193b23d9ea6134318679ca59ab9",
"assets/assets/portfolio/projects/kinpos/secondary_media.png": "c3ee65a0f82b33c82fd7627903b79e95",
"assets/assets/portfolio/projects/kinpos/logomark.png": "e6cc024e6661c6ada5a614222d506168",
"assets/assets/portfolio/projects/kinpos/main_media.mp4": "35457a83d5decb6f7693bad857a695b0",
"assets/assets/portfolio/projects/kinpos/detail_media2.png": "eb61a8f7a3b6e53b446cced88f4ad63d",
"assets/assets/portfolio/projects/kinpos/detail_media1.png": "662fba5a45d8608359b497bcc6414943",
"assets/assets/portfolio/projects/kinpos/secondary_media2.png": "0ba0678ebd58237ca2ab415e93fbe2f0",
"assets/assets/portfolio/projects/b4s/logomark.png": "c1d0839a6e0c4c5ac4baea78f6567d1f",
"assets/assets/portfolio/projects/b4s/secondary_media.mov": "353eec100270dd0c28d8ea6c6885764e",
"assets/assets/portfolio/about/resume.pdf": "35f16bcdfa6b9c14cd76970eec322c40",
"assets/assets/portfolio/skills/icons/cursor.png": "38fbd1d4124180f057593012b0f4d9e8",
"assets/assets/portfolio/skills/icons/scrum.png": "d0968c612e311f97a418aca31abda26c",
"assets/assets/portfolio/skills/icons/kotlin-multiplatform.png": "c49b566ec705ccce4c94879360557507",
"assets/assets/portfolio/skills/icons/davinci2.png": "498d3ad98c04a1db821d190e669e695f",
"assets/assets/portfolio/skills/icons/kanban.png": "fdbdbbf1168c466255a594e70333e8ed",
"assets/assets/portfolio/skills/icons/figma-white.png": "853681b1cee9c3384acdffecaaafcc56",
"assets/assets/portfolio/skills/icons/rive2.png": "7e5fbb5fd194765ca616c8542d84b79b",
"assets/assets/portfolio/skills/icons/agile.png": "cb96601fec0dceb823dc9428a16aefb8",
"assets/assets/portfolio/skills/icons/flutter.png": "4262c71228b7aa391e995fe5f1d57795",
"assets/assets/portfolio/skills/icons/github-white.png": "e613372679ab303563431324b23f96f6",
"assets/assets/portfolio/skills/icons/scrum2.png": "8c10ebf8f97dd2c9d47f38d94467e0de",
"assets/assets/portfolio/skills/icons/scrum3.png": "0c71eb47d6ca52d262a6ef9e74877d05",
"assets/assets/portfolio/skills/icons/github.png": "728ff5a8e44d74cd0f2359ef0a9ec88a",
"assets/assets/portfolio/skills/icons/kanban2.png": "c2aedf9944885600e6d0b832425bc055",
"assets/assets/portfolio/skills/icons/figma.png": "1e34544d27c9dfbc6cfb67d878e094c6",
"assets/assets/portfolio/skills/icons/vscode.png": "3919e5b2f737f142a45921320e666382",
"assets/assets/portfolio/skills/icons/code-magic.png": "8bd5fb29dfde84af45d1eec694f2b2ab",
"assets/assets/portfolio/skills/icons/android-studio.png": "c23a36c2968c930a045d8e3bb274d170",
"assets/assets/portfolio/skills/icons/davinci.png": "93843f4892539e8acb211d071d261d77",
"assets/assets/portfolio/skills/icons/swift.png": "5b9db0873f885f7cd0a08ccd5e798cde",
"assets/assets/portfolio/skills/icons/rive.png": "3af12b988bc9fe1f55983c370e45640b",
"assets/assets/portfolio/skills/icons/code-magic-white.png": "f79aff9d617d0cb6b805d95622f085fb",
"assets/assets/portfolio/skills/icons/github-actions.png": "9be43c05d9f4a41cc8628d096cc9c100",
"assets/assets/portfolio/skills/icons/kotlin.png": "2c7f25b1f3ce2a9bef8cb0ce20148d28",
"assets/assets/portfolio/skills/icons/agile3.png": "742d96c3138306d7cd5163c5927ac271",
"assets/assets/fonts/OpenDyslexic-Bold.otf": "e3c427f3b9acc67a60085cdbcf4cc087",
"assets/assets/fonts/BIZUDGothic-Bold.ttf": "b2c7040d94f05685ae677be71b35f7e1",
"assets/assets/fonts/BIZUDGothic-Regular.ttf": "5cc6da3a6359b49bddfdcd7feba2e267",
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
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
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
