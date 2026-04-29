import 'package:flutter/material.dart';

// ТҮЗЕТІЛДІ: final сөзі алынды, осылайша сатушы жаңа тауар қоса алады
List<Map<String, dynamic>> phoneProducts = [
  // APPLE
  {
    'name': 'iPhone 15 Pro', 
    'brand': 'Apple',
    'rating': 4.9,
    'images': [
      'https://ir.ozone.ru/s3/multimedia-1-o/7129349196.jpg',
      'https://openshop.ua/images/detailed/189/apple-iphone-15-pro-128gb-black-titanium-1.jpg'
    ],
    'description': 'Титан корпусы, A17 Pro чипі және кәсіби деңгейдегі 48 Мп камера жүйесі.',
    'specs': {'screen': '6.1" OLED 120Hz', 'cpu': 'A17 Pro', 'battery': '3274 mAh', 'camera': '48+12+12 MP'},
    'variants': [{'ram': '128GB', 'price': 580000}, {'ram': '256GB', 'price': 650000}],
  },
  {
    'name': 'iPhone 14 Pro', 
    'brand': 'Apple',
    'rating': 4.7,
    'images': [
      'https://tse1.explicit.bing.net/th/id/OIP.m5ACWxos50nDdUJHa4cdwgHaJP?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://openshop.ua/images/detailed/151/apple-iphone-14-pro-128gb-deep-purple-1.jpg'
    ],
    'description': 'Үлкен экран және ең ұзақ батарея қуаты.',
    'specs': {'screen': '6.1" OLED 120Hz', 'cpu': 'A16 Bionic', 'battery': '3200 mAh', 'camera': '48+12+12 MP'},
    'variants': [{'ram': '128GB', 'price': 390000}],
  },
  {
    'name': 'iPhone 13', 
    'brand': 'Apple',
    'rating': 4.6,
    'images': [
      'https://tse1.explicit.bing.net/th/id/OIP.Yp_MIzSqRvZYdCbH8QPHvgHaJ2?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://openshop.ua/images/detailed/121/apple-iphone-13-128gb-blue-1.jpg'
    ],
    'description': 'Күнделікті қолданысқа арналған сенімді әрі жылдам смартфон.',
    'specs': {'screen': '6.1" OLED', 'cpu': 'A15 Bionic', 'battery': '3240 mAh', 'camera': '12+12 MP'},
    'variants': [{'ram': '128GB', 'price': 285000}],
  },
  {
    'name': 'Apple AirPods Pro 2', 
    'brand': 'Apple',
    'rating': 4.9,
    'images': [
      'https://mir-s3-cdn-cf.behance.net/project_modules/fs/378f3e141582491.625697a7e8108.jpg',
      'https://mir-s3-cdn-cf.behance.net/project_modules/fs/378f3e141582491.625697a7e8108.jpg'
    ],
    'description': 'Шуды белсенді басу және кеңістіктік дыбыс мүмкіндігі.',
    'specs': {'screen': 'N/A', 'cpu': 'H2 Chip', 'battery': '6h (30h total)', 'camera': 'N/A'},
    'variants': [{'ram': 'White', 'price': 66700}],
  },
  {
    'name': 'Apple Watch Ultra 3', 
    'brand': 'Apple',
    'rating': 5.0,
    'images': [
      'https://cdn.mos.cms.futurecdn.net/WfBTbmRcEPA3cuWUWe5z9N.jpg',
      'https://cdn.mos.cms.futurecdn.net/WfBTbmRcEPA3cuWUWe5z9N.jpg'
    ],
    'description': 'Экстремалды спорт пен белсенді өмір салтына арналған ең мықты сағат.',
    'specs': {'screen': '1.92" LTPO OLED', 'cpu': 'S10 SiP', 'battery': '36-72h', 'camera': 'N/A'},
    'variants': [{'ram': 'Titanium', 'price': 450000}],
  },

  // SAMSUNG
  {
    'name': 'Samsung Galaxy S24 Ultra', 
    'brand': 'Samsung',
    'rating': 4.8,
    'images': [
      'https://ir.ozone.ru/s3/multimedia-f/w1200/6896605947.jpg',
      'https://images.samsung.com/is/image/samsung/p6pim/kz_ru/2401/gallery/kz-ru-galaxy-s24-s928-sm-s928bztqskz-539305574'
    ],
    'description': 'Galaxy AI мүмкіндіктері, 200 Мп камера және S Pen.',
    'specs': {'screen': '6.8" Dynamic AMOLED 2X', 'cpu': 'Snapdragon 8 Gen 3', 'battery': '5000 mAh', 'camera': '200+50+12+10 MP'},
    'variants': [{'ram': '256GB', 'price': 540000}],
  },
  {
    'name': 'Samsung Galaxy A54', 
    'brand': 'Samsung',
    'rating': 4.5,
    'images': [
      'https://tse2.mm.bing.net/th/id/OIP.MeNXr1SeJDACRNYZ9s5RgAHaHa?w=1024&h=1024&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://images.samsung.com/is/image/samsung/p6pim/kz_ru/sm-a546ezkdskz/gallery/kz-ru-galaxy-a54-5g-sm-a546-sm-a546ezkdskz-535787612'
    ],
    'description': 'Жарқын экран және тамаша автономиялылық.',
    'specs': {'screen': '6.4" Super AMOLED 120Hz', 'cpu': 'Exynos 1380', 'battery': '5000 mAh', 'camera': '50+12+5 MP'},
    'variants': [{'ram': '128GB', 'price': 185000}],
  },
  {
    'name': 'Samsung Galaxy Z Fold 5', 
    'brand': 'Samsung',
    'rating': 4.7,
    'images': [
      'https://tse3.mm.bing.net/th/id/OIP.Mc86JWoMF3n5DPwRN_MrgAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://images.samsung.com/is/image/samsung/p6pim/kz_ru/2307/gallery/kz-ru-galaxy-z-fold5-f946-sm-f946bzksskz-537449234'
    ],
    'description': 'Жиналмалы экран, мультитаскинг үшін таптырмас құрал.',
    'specs': {'screen': '7.6" AMOLED', 'cpu': 'Snapdragon 8 Gen 2', 'battery': '4400 mAh', 'camera': '50+12+10 MP'},
    'variants': [{'ram': '512GB', 'price': 720000}],
  },

  // XIAOMI
  {
    'name': 'Xiaomi 14 Ultra', 
    'brand': 'Xiaomi',
    'rating': 4.9,
    'images': [
      'https://avatars.mds.yandex.net/get-mpic/15106342/2a00000196b4e64d596c1649841cc2ccd54b/orig',
      'https://miot.kz/uploads/products/1269/963884.jpg'
    ],
    'description': 'Leica оптикасымен жабдықталған кәсіби фото-флагман.',
    'specs': {'screen': '6.73" LTPO AMOLED', 'cpu': 'Snapdragon 8 Gen 3', 'battery': '5000 mAh', 'camera': '50+50+50+50 MP'},
    'variants': [{'ram': '256GB', 'price': 499990}],
  },
  {
    'name': 'Redmi Note 13 Pro', 
    'brand': 'Xiaomi',
    'rating': 4.6,
    'images': [
      'https://tse2.mm.bing.net/th/id/OIP.fy4KmYTB0bLL-uvmZe3UcwHaGu?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://miot.kz/uploads/products/1231/912837.jpg'
    ],
    'description': '200 Мп камера және 120 Вт жылдам қуаттау.',
    'specs': {'screen': '6.67" AMOLED 120Hz', 'cpu': 'Helio G99-Ultra', 'battery': '5000 mAh', 'camera': '200+8+2 MP'},
    'variants': [{'ram': '256GB', 'price': 145000}],
  },
  {
    'name': 'Redmi Note 12 Pro', 
    'brand': 'Xiaomi',
    'rating': 4.4,
    'images': [
      'https://tse4.mm.bing.net/th/id/OIP.tRcvdw8ZvY61IBen4yResgHaHZ?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://tse4.mm.bing.net/th/id/OIP.tRcvdw8ZvY61IBen4yResgHaHZ?rs=1&pid=ImgDetMain&o=7&rm=3'
    ],
    'description': 'Керемет OLED экран және 67 Вт жылдам қуаттау.',
    'specs': {'screen': '6.67" OLED 120Hz', 'cpu': 'Dimensity 1080', 'battery': '5000 mAh', 'camera': '50+8+2 MP'},
    'variants': [{'ram': '128GB', 'price': 115000}, {'ram': '256GB', 'price': 130000}],
  },
  {
    'name': 'Poco F6 Pro', 
    'brand': 'Xiaomi',
    'rating': 4.5,
    'images': [
      'https://cdn1.ozone.ru/s3/multimedia-1-v/c600/6960403579.jpg',
      'https://miot.kz/uploads/products/1301/poco-f6-pro-black-2.jpg'
    ],
    'description': 'Ойындарға арналған қуатты процессор мен жарқын экран.',
    'specs': {'screen': '6.67" OLED 120Hz', 'cpu': 'Snapdragon 8 Gen 2', 'battery': '5000 mAh', 'camera': '50+8+2 MP'},
    'variants': [{'ram': '256GB', 'price': 230000}],
  },

  // OPPO / HUAWEI
  {
    'name': 'HUAWEI Pura 70 Ultra', 
    'brand': 'HUAWEI', 
    'rating': 4.7,
    'images': [
      'https://i.ebayimg.com/images/g/3T0AAOSw3otoS-O9/s-l500.jpg',
      'https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/phones/pura70-ultra/images/design/design-colors-green.png'
    ],
    'description': 'XMAGE камера жүйесі және жылжымалы объектив.',
    'specs': {'screen': '6.8" LTPO OLED', 'cpu': 'Kirin 9010', 'battery': '5200 mAh', 'camera': '50+40+50 MP'},
    'variants': [{'ram': '256GB', 'price': 549990}],
  },
  {
    'name': 'OPPO Reno 12 Pro', 
    'brand': 'OPPO',
    'rating': 4.8,
    'images': [
      'https://object.pscloud.io/cms/cms/Photo/img_0_77_6054_0_1_bEHzP1.jpg',
      'https://object.pscloud.io/cms/cms/Photo/img_0_77_6054_0_1_bEHzP1.jpg'
    ],
    'description': 'AI мүмкіндіктері бар футуристік дизайн және мықты экран.',
    'specs': {'screen': '6.7" AMOLED 120Hz', 'cpu': 'Dimensity 7300-Energy', 'battery': '5000 mAh', 'camera': '50+50+8 MP'},
    'variants': [{'ram': '512GB', 'price': 295000}],
  },
  {
    'name': 'OPPO Find N3', 
    'brand': 'OPPO',
    'rating': 4.9,
    'images': [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzW5Ht3T5e0iGj3t_lBgI2d8Z56W9QsEBidQ&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzW5Ht3T5e0iGj3t_lBgI2d8Z56W9QsEBidQ&s'
    ],
    'description': 'Үздік жиналмалы смартфон және Hasselblad камерасы.',
    'specs': {'screen': '7.82" Foldable OLED', 'cpu': 'Snapdragon 8 Gen 2', 'battery': '4805 mAh', 'camera': '48+64+48 MP'},
    'variants': [{'ram': '512GB', 'price': 850000}],
  },
  {
    'name': 'OPPO A53', 
    'brand': 'OPPO',
    'rating': 4.3,
    'images': [
      'https://m.media-amazon.com/images/I/71wP8S8L8GL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71wP8S8L8GL._AC_SL1500_.jpg'
    ],
    'description': '90 Гц экраны бар сенімді бюджеттік смартфон.',
    'specs': {'screen': '6.5" IPS LCD 90Hz', 'cpu': 'Snapdragon 460', 'battery': '5000 mAh', 'camera': '13+2+2 MP'},
    'variants': [{'ram': '64GB', 'price': 75000}],
  },
  {
    'name': 'OPPO Reno 11 Pro', 
    'brand': 'OPPO',
    'rating': 4.4,
    'images': [
      'https://th.bing.com/th/id/OIP.YlZRlLLaHRW1cf7uEjuvDQHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://oppo.kz/images/reno11-pro/white-back.png'
    ],
    'description': 'Портреттік фотосуреттерге арналған стильді смартфон.',
    'specs': {'screen': '6.7" AMOLED', 'cpu': 'Dimensity 8200', 'battery': '4600 mAh', 'camera': '50+32+8 MP'},
    'variants': [{'ram': '256GB', 'price': 210000}],
  },

  // NOUTBOOKTAR
  {
    'name': 'Lenovo Legion 5 Pro', 
    'brand': 'Lenovo', 
    'rating': 4.9,
    'images': [
      'https://slickdeals.net/attachment/2/6/8/0/6/1/2/1/450x450/14479837.thumb',
      'https://slickdeals.net/attachment/2/6/8/0/6/1/2/1/450x450/14479837.thumb'
    ],
    'description': 'Геймерлерге арналған жоғары өнімділіктегі ноутбук.',
    'specs': {'screen': '16" QHD 165Hz', 'cpu': 'Ryzen 7 / RTX 4060', 'battery': '80Wh', 'camera': '720p HD'},
    'variants': [{'ram': '16GB/512GB', 'price': 680000}],
  },
  {
    'name': 'Asus TUF Gaming F15',
    'brand': 'Asus',
    'rating': 4.8,
    'images': [
      'https://tse4.mm.bing.net/th/id/OIP.IiloKn7kKxlop-IyYCHFIwHaFy?w=590&h=461&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://tse4.mm.bing.net/th/id/OIP.IiloKn7kKxlop-IyYCHFIwHaFy?w=590&h=461&rs=1&pid=ImgDetMain&o=7&rm=3'
    ],
    'description': 'Әскери деңгейдегі төзімділік пен қуатты ойын мүмкіндіктері.',
    'specs': {'screen': '15.6" FHD 144Hz', 'cpu': 'Intel Core i7-12700H', 'battery': '90Wh', 'camera': '720p HD'},
    'variants': [{'ram': '16GB/1TB', 'price': 520000}],
  },
  {
    'name': 'Asus Vivobook 16', 
    'brand': 'Asus', 
    'rating': 4.6,
    'images': [
      'https://tse4.mm.bing.net/th/id/OIP.AFf7CWG_FrgNtJ18m2pFRwHaFD?w=742&h=507&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://tse4.mm.bing.net/th/id/OIP.AFf7CWG_FrgNtJ18m2pFRwHaFD?w=742&h=507&rs=1&pid=ImgDetMain&o=7&rm=3'
    ],
    'description': 'Оқу мен жұмысқа арналған ыңғайлы әрі жеңіл ноутбук.',
    'specs': {'screen': '16" WUXGA', 'cpu': 'Intel Core i5', 'battery': '42Wh', 'camera': '720p with Shutter'},
    'variants': [{'ram': '8GB/256GB', 'price': 295000}],
  },
  {
    'name': 'Acer Aspire 5', 
    'brand': 'Acer', 
    'rating': 4.5,
    'images': [
      'https://s13emagst.akamaized.net/products/64675/64674652/images/res_897176d9c3997f61f49b3dde41118e04.jpg',
      'https://s13emagst.akamaized.net/products/64675/64674652/images/res_897176d9c3997f61f49b3dde41118e04.jpg'
    ],
    'description': 'Күнделікті тапсырмаларға арналған сенімді таңдау.',
    'specs': {'screen': '15.6" Full HD', 'cpu': 'Intel Core i3 / i5', 'battery': '50Wh', 'camera': '1080p F-HD'},
    'variants': [{'ram': '8GB/512GB', 'price': 245000}],
  },

  // БАСҚАЛАР ЖӘНЕ АКСЕССУАРЛАР
  {
    'name': 'JBL Tune 520BT', 
    'brand': 'JBL', 
    'rating': 4.8,
    'images': [
      'https://m.media-amazon.com/images/I/512LuQyL3BL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/512LuQyL3BL._AC_SL1500_.jpg'
    ],
    'description': 'JBL Pure Bass дыбысы және 57 сағатқа дейін жұмыс істейтін батарея.',
    'specs': {'screen': 'N/A', 'cpu': 'Bluetooth 5.3', 'battery': '57h Playback', 'camera': 'N/A'},
    'variants': [{'ram': 'Blue', 'price': 22000}],
  },
  {
    'name': 'GERLAX GH-34', 
    'brand': 'Gerlax', 
    'rating': 4.2,
    'images': [
      'https://tse2.mm.bing.net/th/id/OIP.V9qTqL_RVDGghMl-ugRYOQHaHa?w=1020&h=1020&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://tse2.mm.bing.net/th/id/OIP.V9qTqL_RVDGghMl-ugRYOQHaHa?w=1020&h=1020&rs=1&pid=ImgDetMain&o=7&rm=3'
    ],
    'description': 'Күнделікті қолданысқа арналған қолжетімді әрі ыңғайлы құлаққап.',
    'specs': {'screen': 'N/A', 'cpu': 'Standard Driver', 'battery': 'Up to 10h', 'camera': 'N/A'},
    'variants': [{'ram': 'Black', 'price': 55000}],
  },
  {
    'name': 'HyperX Cloud 3', 
    'brand': 'HyperX', 
    'rating': 4.9,
    'images': [
      'https://m.media-amazon.com/images/I/71++S+DNJ+L._AC_UY545_QL65_.jpg',
      'https://m.media-amazon.com/images/I/71++S+DNJ+L._AC_UY545_QL65_.jpg'
    ],
    'description': 'Геймерлерге арналған аңызға айналған жайлылық пен көлемді дыбыс.',
    'specs': {'screen': 'N/A', 'cpu': '53mm Drivers', 'battery': 'Wired', 'camera': 'N/A'},
    'variants': [{'ram': 'Red/Black', 'price': 58000}],
  },
  {
    'name': 'Google Pixel 8 Pro', 
    'brand': 'Google', 
    'rating': 4.8,
    'images': [
      'https://avatars.mds.yandex.net/get-mpic/8382397/2a0000019059a4c75a09fa81eb207bb1a146/orig',
      'https://shop.google.com/images/pixel-8-pro-blue.jpg'
    ],
    'description': 'Жасанды интеллект көмегімен суреттерді өңдеу.',
    'specs': {'screen': '6.7" LTPO OLED', 'cpu': 'Tensor G3', 'battery': '5050 mAh', 'camera': '50+48+48 MP'},
    'variants': [{'ram': '128GB', 'price': 350000}],
  },
  {
    'name': 'Nothing Phone (2)', 
    'brand': 'Nothing', 
    'rating': 4.6,
    'images': [
      'https://avatars.mds.yandex.net/get-mpic/1526692/2a0000018e743c24e02eaeff0eaff8ef9cf1/orig',
      'https://nothing.tech/images/phone-2-white.png'
    ],
    'description': 'Ерекше Glyph интерфейсі және мөлдір корпус.',
    'specs': {'screen': '6.7" LTPO OLED', 'cpu': 'Snapdragon 8+ Gen 1', 'battery': '4700 mAh', 'camera': '50+50 MP'},
    'variants': [{'ram': '256GB', 'price': 295000}],
  },
  {
    'name': 'OnePlus 12', 
    'brand': 'OnePlus', 
    'rating': 4.8,
    'images': [
      'https://s13emagst.akamaized.net/products/65876/65875215/images/res_44a3b51b26fcfd01622ef48d8b59d0f3.jpg?width=720&height=720&hash=EA722B2E37039DBA051228386E39DBAD',
      'https://m.media-amazon.com/images/I/71X8kS8S-+L._AC_SL1500_.jpg'
    ],
    'description': 'Жоғары жылдамдық және Hasselblad камерасы.',
    'specs': {'screen': '6.82" LTPO AMOLED', 'cpu': 'Snapdragon 8 Gen 3', 'battery': '5400 mAh', 'camera': '50+64+48 MP'},
    'variants': [{'ram': '256GB', 'price': 380000}],
  },
  {
    'name': 'Realme GT 5', 
    'brand': 'Realme', 
    'rating': 4.5,
    'images': [
      'https://ir.ozone.ru/s3/multimedia-h/c1000/6856689005.jpg',
      'https://image01.realme.net/global/nav-product/20230828112345.png'
    ],
    'description': '240 Вт жылдам қуаттау рекорды.',
    'specs': {'screen': '6.74" OLED 144Hz', 'cpu': 'Snapdragon 8 Gen 2', 'battery': '5240 mAh', 'camera': '50+8+2 MP'},
    'variants': [{'ram': '512GB', 'price': 260000}],
  },
  {
    'name': 'Asus ROG Phone 8', 
    'brand': 'Asus', 
    'rating': 4.9,
    'images': [
      'https://tse3.mm.bing.net/th/id/OIP.bXqoO2si0m_jJvf50DT7ZAHaIx?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://dlcdnwebimgs.asus.com/gain/3D7C5E9C-1F5A-4B6A-8A1C-C048037C5E9C'
    ],
    'description': 'Нағыз геймерлерге арналған ең қуатты темір.',
    'specs': {'screen': '6.78" AMOLED 165Hz', 'cpu': 'Snapdragon 8 Gen 3', 'battery': '5500 mAh', 'camera': '50+32+13 MP'},
    'variants': [{'ram': '12 GB', 'price': 480000}],
  },
  {
    'name': 'Honor Magic 6 Pro', 
    'brand': 'Honor', 
    'rating': 4.8,
    'images': [
      'https://tse2.mm.bing.net/th/id/OIP.yX04gzY1AXSPjxMHDess4QHaHa?w=800&h=800&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://www.hihonor.com/content/dam/honor/kz/product/honor-magic6-pro/honor-magic6-pro-green.png'
    ],
    'description': 'Керемет перископтық камера және мықты экран.',
    'specs': {'screen': '6.8" LTPO OLED', 'cpu': 'Snapdragon 8 Gen 3', 'battery': '5600 mAh', 'camera': '50+180+50 MP'},
    'variants': [{'ram': '6 GB', 'price': 410000}],
  },
  {
    'name': 'Sony Xperia 1 V', 
    'brand': 'Sony', 
    'rating': 4.6,
    'images': [
      'https://tse4.mm.bing.net/th/id/OIP.KVHa_MHBtaUzGeYfYkuWWwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://www.sony.kz/image/5d02da5df55283665393c575c4091fe2?fmt=pjpeg&wid=660&bgcolor=F1F5F9&bgc=F1F5F9'
    ],
    'description': 'Кино түсірушілерге арналған 4K OLED экран.',
    'specs': {'screen': '6.5" 4K OLED', 'cpu': 'Snapdragon 8 Gen 2', 'battery': '5000 mAh', 'camera': '48+12+12 MP'},
    'variants': [{'ram': '4 GB', 'price': 450000}],
  },
  {
    'name': 'Marshall Major 5', 
    'brand': 'Marshall', 
    'rating': 4.9,
    'images': [
      'https://http2.mlstatic.com/D_Q_NP_2X_767493-MLA44436715428_122020-V.webp',
      'https://http2.mlstatic.com/D_Q_NP_2X_767493-MLA44436715428_122020-V.webp'
    ],
    'description': 'Аңызға айналған дыбыс және 100 сағаттан астам сымсыз жұмыс уақыты.',
    'specs': {'screen': 'N/A', 'cpu': 'Custom Driver', 'battery': '100h+ Wireless', 'camera': 'N/A'},
    'variants': [{'ram': 'Black', 'price': 85000}],
  },
  {
    'name': 'Hoco W25', 
    'brand': 'Hoco', 
    'rating': 4.3,
    'images': [
      'https://cdn.27.ua/sc--media--prod/default/0e/49/f6/0e49f63f-59f7-45b3-ba99-b3d8b70e05aa.jpg',
      'https://cdn.27.ua/sc--media--prod/default/0e/49/f6/0e49f63f-59f7-45b3-ba99-b3d8b70e05aa.jpg'
    ],
    'description': 'Ыңғайлы дизайн және қолжетімді бағадағы сапалы дыбыс.',
    'specs': {'screen': 'N/A', 'cpu': 'JL Chip', 'battery': '12h Playback', 'camera': 'N/A'},
    'variants': [{'ram': 'Black', 'price': 7500}],
  },
];

List<Map<String, dynamic>> cartItems = [];
List<Map<String, dynamic>> favoriteItems = [];