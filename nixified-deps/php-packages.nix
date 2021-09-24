{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-dff976c2f3487d42c1db75a3b180e2b9f0e72ce0";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/dff976c2f3487d42c1db75a3b180e2b9f0e72ce0";
          sha256 = "11k4h3mvgf9fn2mj0f67jccgkwr1zyjjjx1czmkvxzkkydq3g3nk";
        };
      };
    };
    "codeigniter4/codeigniter4" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "codeigniter4-codeigniter4-995c51f383844bc44a607026ea6ab85b06c7e87e";
        src = fetchurl {
          url = "https://api.github.com/repos/codeigniter4/CodeIgniter4/zipball/995c51f383844bc44a607026ea6ab85b06c7e87e";
          sha256 = "1l56v9vwx1slva5zzvka06np5cdk6p41d6ikmd6b5q1437bfkl8n";
        };
      };
    };
    "composer/ca-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-ca-bundle-9fdb22c2e97a614657716178093cd1da90a64aa8";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/ca-bundle/zipball/9fdb22c2e97a614657716178093cd1da90a64aa8";
          sha256 = "0vaxjp9k7y97a8c96kany2r4n9xylqb48dvqbgmp82rrda6d6z14";
        };
      };
    };
    "essence/dom" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "essence-dom-e5776d2286f4ccbd048d160c28ac77ccc6d68f3a";
        src = fetchurl {
          url = "https://api.github.com/repos/essence/dom/zipball/e5776d2286f4ccbd048d160c28ac77ccc6d68f3a";
          sha256 = "11p0qij746z7hrm3kcp26gigshc1y51qxghmhbsq4iqi93gs9mmf";
        };
      };
    };
    "essence/essence" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "essence-essence-81e889a87603840dadd04b317a51487df1d45933";
        src = fetchurl {
          url = "https://api.github.com/repos/essence/essence/zipball/81e889a87603840dadd04b317a51487df1d45933";
          sha256 = "1m8s68lk0ll5ghp1nirqjq57b49dngb4rf6acfs2qzj3kx89z28r";
        };
      };
    };
    "essence/http" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "essence-http-ce0e52e0c0f2ed894ce2922ab2fd598dcaac91d2";
        src = fetchurl {
          url = "https://api.github.com/repos/essence/http/zipball/ce0e52e0c0f2ed894ce2922ab2fd598dcaac91d2";
          sha256 = "1wsdn0phw8wxdzc4qf3kk39gkhfg9hbark97ib9963kn36y58anl";
        };
      };
    };
    "fg/parkour" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fg-parkour-f837eb640fc4aac81b11fe50d2fa04fb4ec71496";
        src = fetchurl {
          url = "https://api.github.com/repos/felixgirault/parkour/zipball/f837eb640fc4aac81b11fe50d2fa04fb4ec71496";
          sha256 = "03d5cm1jrs4kqigwra7g26z3i4y30asdvhyp5zmfhm96nfig0lg5";
        };
      };
    };
    "geoip2/geoip2" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "geoip2-geoip2-d01be5894a5c1a3381c58c9b1795cd07f96c30f7";
        src = fetchurl {
          url = "https://api.github.com/repos/maxmind/GeoIP2-php/zipball/d01be5894a5c1a3381c58c9b1795cd07f96c30f7";
          sha256 = "041yrdkgqfx3bv2shr24c5zdmwy9j3zgi7395vsd9sfg0ya0pf4g";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-7e279d2cd5d7fbb156ce46daada972355cea27bb";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/7e279d2cd5d7fbb156ce46daada972355cea27bb";
          sha256 = "0hvbv2svljw2hyshbby7wrh29nck98rpbhfl911gyb89i8mzx1zm";
        };
      };
    };
    "james-heinrich/getid3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "james-heinrich-getid3-5515a2d24667c3c0ff49fdcbdadc405c0880c7a2";
        src = fetchurl {
          url = "https://api.github.com/repos/JamesHeinrich/getID3/zipball/5515a2d24667c3c0ff49fdcbdadc405c0880c7a2";
          sha256 = "1lm6nhl1f66ydjijj90a43rkcgfi8pyhfvk3q0akr2akk8q81mks";
        };
      };
    };
    "kint-php/kint" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "kint-php-kint-335ac1bcaf04d87df70d8aa51e8887ba2c6d203b";
        src = fetchurl {
          url = "https://api.github.com/repos/kint-php/kint/zipball/335ac1bcaf04d87df70d8aa51e8887ba2c6d203b";
          sha256 = "0jkxp9p5a41jrz0lczlng3mglcnwkzarkjxgbfynr47fnihrxxps";
        };
      };
    };
    "laminas/laminas-escaper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-escaper-5e04bc5ae5990b17159d79d331055e2c645e5cc5";
        src = fetchurl {
          url = "https://api.github.com/repos/laminas/laminas-escaper/zipball/5e04bc5ae5990b17159d79d331055e2c645e5cc5";
          sha256 = "0ccabdsgy9y7rki36frbx713nwkv52wn2r0p0pxv79krxfvs6zsd";
        };
      };
    };
    "laminas/laminas-zendframework-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-zendframework-bridge-6cccbddfcfc742eb02158d6137ca5687d92cee32";
        src = fetchurl {
          url = "https://api.github.com/repos/laminas/laminas-zendframework-bridge/zipball/6cccbddfcfc742eb02158d6137ca5687d92cee32";
          sha256 = "10i9dk9idj2drcknglw9vzgvnk1mpnayq08yx8899q3k33bsj7vd";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-7d70d2f19c84bcc16275ea47edabee24747352eb";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/7d70d2f19c84bcc16275ea47edabee24747352eb";
          sha256 = "1clfi4k0xp15pzg8c344qj5jk54k9dm9xbg4sd6l6iv66md1xasn";
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-html-to-markdown-0868ae7a552e809e5cd8f93ba022071640408e88";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/0868ae7a552e809e5cd8f93ba022071640408e88";
          sha256 = "1a704if1v2vdn7cpiy563268m36k0hn2d6bkm660bgygbb8xvjaf";
        };
      };
    };
    "maxmind-db/reader" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maxmind-db-reader-569bd44d97d30a4ec12c7793a33004a76d4caf18";
        src = fetchurl {
          url = "https://api.github.com/repos/maxmind/MaxMind-DB-Reader-php/zipball/569bd44d97d30a4ec12c7793a33004a76d4caf18";
          sha256 = "1znsmbd186q6v3p8idcvp5yh2fl5pkfnhnwzis7c7wgsvb3fdx4y";
        };
      };
    };
    "maxmind/web-service-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maxmind-web-service-common-32f274051c543fc865e5a84d3a2c703913641ea8";
        src = fetchurl {
          url = "https://api.github.com/repos/maxmind/web-service-common-php/zipball/32f274051c543fc865e5a84d3a2c703913641ea8";
          sha256 = "0cdwff091s661kdl425df54yjlbppp4b1ddn32cy1xw6wsbl2g1f";
        };
      };
    };
    "michalsn/codeigniter4-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "michalsn-codeigniter4-uuid-b26512ac4f3f0c772fbfa2c3317346d3c17e2d44";
        src = fetchurl {
          url = "https://api.github.com/repos/michalsn/codeigniter4-uuid/zipball/b26512ac4f3f0c772fbfa2c3317346d3c17e2d44";
          sha256 = "04vpid9cmw956xq1g5r83aaqiz46l6ahbr4pdd0kp7kj6831fmnh";
        };
      };
    };
    "myth/auth" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myth-auth-9bba52bd710a0c35a0b2d8cef64a70706224648a";
        src = fetchurl {
          url = "https://api.github.com/repos/lonnieezell/myth-auth/zipball/9bba52bd710a0c35a0b2d8cef64a70706224648a";
          sha256 = "1w84jz7qg5xmk8yv2md8jpyzpski1hkkvmrnvfi0gz2ndgsc440m";
        };
      };
    };
    "opawg/user-agents-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opawg-user-agents-php-e22c7be05f475b44d0e6ecd76acf1617a2efef85";
        src = fetchurl {
          url = "https://api.github.com/repos/opawg/user-agents-php/zipball/e22c7be05f475b44d0e6ecd76acf1617a2efef85";
          sha256 = "0m8n1r2zipn0v6p6cvwch3kalbfjb60s114ay5myqgbi4h6pyyka";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-994ecccd8f3283ecf5ac33254543eb0ac946d525";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/994ecccd8f3283ecf5ac33254543eb0ac946d525";
          sha256 = "1snrnfvqhnr5z9llf8kbqk9l97gfyp8gghmhi1ng8qx5xzv1anr7";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-233a920cb38636a43b18d428f9a8db1f0a1a08f4";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/233a920cb38636a43b18d428f9a8db1f0a1a08f4";
          sha256 = "1z32pr08fmaqf0pqn9772qmiigk9prad4kszwh1mz5f3y1cg5bxr";
        };
      };
    };
    "podlibre/ipcat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "podlibre-ipcat-1adfc821be508ddc8a742f6a5d5e6e42fdf28e86";
        src = fetchurl {
          url = "https://api.github.com/repos/podlibre/ipcat/zipball/1adfc821be508ddc8a742f6a5d5e6e42fdf28e86";
          sha256 = "0hz43mc1gsfnjisab6ym0qc94frcjszphbvbzx4jwq59vr9m4g1s";
        };
      };
    };
    "podlibre/podcast-namespace" = {
      targetDir = "";
      src = fetchgit {
        name = "podlibre-podcast-namespace-4525c06ee9dd95bb745ee875d55b64a053c74cd6";
        url = "https://code.podlibre.org/podlibre/podcastnamespace";
        rev = "4525c06ee9dd95bb745ee875d55b64a053c74cd6";
        sha256 = "12lw1lvmhv5myx7byyywvxkcp6wyabjw7c0xsdl45bikkld3i1xi";
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-d11b50ad223250cf17b86e38383413f5a6764bf8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/d11b50ad223250cf17b86e38383413f5a6764bf8";
          sha256 = "06i2k3dx3b4lgn9a4v1dlgv8l9wcl4kl7vzhh63lbji0q96hv8qz";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-d49695b909c3b7628b6289db5479a1c204601f11";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/d49695b909c3b7628b6289db5479a1c204601f11";
          sha256 = "0sb0mq30dvmzdgsnqvw3xh4fb4bqjncx72kf8n622f94dd48amln";
        };
      };
    };
    "ramsey/collection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-collection-28a5c4ab2f5111db6a60b2b4ec84057e0f43b9c1";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/28a5c4ab2f5111db6a60b2b4ec84057e0f43b9c1";
          sha256 = "18ka3y51a21bf7mv3hxxxnn1dj1mn3vg8y1i3j3ajsfi49xl6r03";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-cd4032040a750077205918c86049aa0f43d22947";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/cd4032040a750077205918c86049aa0f43d22947";
          sha256 = "00hnl12crjs7kh67jhhjg157pma4ka5c5rpz46sdx8m207vhylzq";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce";
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-2df51500adbaebdc4c38dea4c89a2e131c45c8a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/2df51500adbaebdc4c38dea4c89a2e131c45c8a1";
          sha256 = "1fbi13p4a6nn01ix3gcj966kq6z8qx03li4vbjylsr9ac2mgnmnn";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-eca0bf41ed421bed1b57c4958bab16aa86b757d0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/eca0bf41ed421bed1b57c4958bab16aa86b757d0";
          sha256 = "1y5kc4vqh920wyjdlgxp23b958g5i9mw10mhbr30vf8j20vf1gra";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-b3eac5c7ac896e52deab4a99068e3f4ab12d9e56";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/b3eac5c7ac896e52deab4a99068e3f4ab12d9e56";
          sha256 = "1w8gylm0qwgwx2y3na9s2knpvc00yfhwf01p662l1cn9b3h33i11";
        };
      };
    };
    "whichbrowser/parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "whichbrowser-parser-bcf642a1891032de16a5ab976fd352753dd7f9a0";
        src = fetchurl {
          url = "https://api.github.com/repos/WhichBrowser/Parser-PHP/zipball/bcf642a1891032de16a5ab976fd352753dd7f9a0";
          sha256 = "081sv2g34ms1k9cr8cshvvmwnciic8kmy6rqvdiwwmjx3rq8yfc9";
        };
      };
    };
  };
  devPackages = {
    "captainhook/captainhook" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "captainhook-captainhook-03f31d3c6bdec50c831381f27ecad48c73840726";
        src = fetchurl {
          url = "https://api.github.com/repos/captainhookphp/captainhook/zipball/03f31d3c6bdec50c831381f27ecad48c73840726";
          sha256 = "0n5hf462adwlcpgvg4k1c4vdskl6clynmz0apfxzgj7jr5gav242";
        };
      };
    };
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-31f3ea725711245195f62e54ffa402d8ef2fdba9";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/semver/zipball/31f3ea725711245195f62e54ffa402d8ef2fdba9";
          sha256 = "13f1hcrq2bn8b43562p7izq7qkcj8nn2apiiwmwybichm5lgcx70";
        };
      };
    };
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-964adcdd3a28bf9ed5d9ac6450064e0d71ed7496";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/xdebug-handler/zipball/964adcdd3a28bf9ed5d9ac6450064e0d71ed7496";
          sha256 = "1drd6sfah4l1bjikr2m8v2cc82qnm398k48vhlg9b93v5n3k8x32";
        };
      };
    };
    "danielstjules/stringy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "danielstjules-stringy-df24ab62d2d8213bbbe88cc36fc35a4503b4bd7e";
        src = fetchurl {
          url = "https://api.github.com/repos/danielstjules/Stringy/zipball/df24ab62d2d8213bbbe88cc36fc35a4503b4bd7e";
          sha256 = "1iyc7p4aw15m7rls33rmdq2vmnrj2nc7vgv99li5ql0ip1k0z1jh";
        };
      };
    };
    "doctrine/annotations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-annotations-e6e7b7d5b45a2f2abc5460cc6396480b2b1d321f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/annotations/zipball/e6e7b7d5b45a2f2abc5460cc6396480b2b1d321f";
          sha256 = "090vizq3xy9p151cjx5fa2izgvypc756wrnclswiiiac4h6mzpyf";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-d56bf6102915de5702778fe20f2de3b2fe570b5b";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/instantiator/zipball/d56bf6102915de5702778fe20f2de3b2fe570b5b";
          sha256 = "04rihgfjv8alvvb92bnb5qpz8fvqvjwfrawcjw34pfnfx4jflcwh";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-e864bbf5904cb8f5bb334f99209b48018522f042";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/e864bbf5904cb8f5bb334f99209b48018522f042";
          sha256 = "11lg9fcy0crb8inklajhx3kyffdbx7xzdj8kwl21xsgq9nm9iwvv";
        };
      };
    };
    "friendsofphp/php-cs-fixer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "friendsofphp-php-cs-fixer-c15377bdfa8d1ecf186f1deadec39c89984e1167";
        src = fetchurl {
          url = "https://api.github.com/repos/FriendsOfPHP/PHP-CS-Fixer/zipball/c15377bdfa8d1ecf186f1deadec39c89984e1167";
          sha256 = "09ng3qdfcymmnv8481n17ddbcrd9w3d5m6i4lqxx0nlh46jjkqcb";
        };
      };
    };
    "mikey179/vfsstream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mikey179-vfsstream-231c73783ebb7dd9ec77916c10037eff5a2b6efe";
        src = fetchurl {
          url = "https://api.github.com/repos/bovigo/vfsStream/zipball/231c73783ebb7dd9ec77916c10037eff5a2b6efe";
          sha256 = "1ph21g9084lawkp39hxmll7vpj79fvx67q341iy2fwsh4nsdsjy5";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-776f831124e9c62e1a2c601ecc52e776d8bb7220";
        src = fetchurl {
          url = "https://api.github.com/repos/myclabs/DeepCopy/zipball/776f831124e9c62e1a2c601ecc52e776d8bb7220";
          sha256 = "181f3fsxs6s2wyy4y7qfk08qmlbvz1wn3mn3lqy42grsb8g8ym0k";
        };
      };
    };
    "nette/neon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-neon-e4ca6f4669121ca6876b1d048c612480e39a28d5";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/neon/zipball/e4ca6f4669121ca6876b1d048c612480e39a28d5";
          sha256 = "19navgzsh2kalwkg2xlm8nzdsgxnljkf1pwvs5r8f38nd6vbcphx";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-967cfc4f9a1acd5f1058d76715a424c53343c20c";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/967cfc4f9a1acd5f1058d76715a424c53343c20c";
          sha256 = "05p6ffxxnp012y5ffc5pqpjxy3ixg3d19nb9sp0farglb0py1g2k";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-4432ba399e47c66624bc73c8c0f811e5c109576f";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/4432ba399e47c66624bc73c8c0f811e5c109576f";
          sha256 = "0372c09xdgdr9dhd9m7sblxyqxk9xdk2r9s0i13ja3ascsz3zvpd";
        };
      };
    };
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-85265efd3af7ba3ca4b2a2c34dbfc5788dd29133";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/manifest/zipball/85265efd3af7ba3ca4b2a2c34dbfc5788dd29133";
          sha256 = "13cqrx7iikx2aixszhxl55ql6hikblvbalix0kr05pbiccipg6fv";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-bae7c545bef187884426f042434e561ab1ddb182";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/version/zipball/bae7c545bef187884426f042434e561ab1ddb182";
          sha256 = "0hqmrihb4wv53rl3fg93wjldwrz79jyad5bv29ynbdklsirh7b2l";
        };
      };
    };
    "php-cs-fixer/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-cs-fixer-diff-29dc0d507e838c4580d018bd8b5cb412474f7ec3";
        src = fetchurl {
          url = "https://api.github.com/repos/PHP-CS-Fixer/diff/zipball/29dc0d507e838c4580d018bd8b5cb412474f7ec3";
          sha256 = "12b0ga9i0racym4vvql26kjjiqx2940j0345kmy9zjbamm6jzlzl";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-1d01c49d4ed62f25aa84a747ad35d5a16924662b";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/1d01c49d4ed62f25aa84a747ad35d5a16924662b";
          sha256 = "1wx720a17i24471jf8z499dnkijzb4b8xra11kvw9g9hhzfadz1r";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-069a785b2141f5bcf49f3e353548dc1cce6df556";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/069a785b2141f5bcf49f3e353548dc1cce6df556";
          sha256 = "0qid63bsfjmc3ka54f1ijl4a5zqwf7jmackjyjmbw3gxdnbi69il";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-6a467b8989322d92aa1c8bf2bebcc6e5c2ba55c0";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/6a467b8989322d92aa1c8bf2bebcc6e5c2ba55c0";
          sha256 = "01g6mihq5wd1396njjb7ibcdfgk26ix1kmbjb6dlshzav0k3983h";
        };
      };
    };
    "phpspec/prophecy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpspec-prophecy-be1996ed8adc35c3fd795488a653f4b518be70ea";
        src = fetchurl {
          url = "https://api.github.com/repos/phpspec/prophecy/zipball/be1996ed8adc35c3fd795488a653f4b518be70ea";
          sha256 = "167snpasy7499pbxpyx2bj607qa1vrg07xfpa30dlpbwi7f34dji";
        };
      };
    };
    "phpstan/extension-installer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-extension-installer-66c7adc9dfa38b6b5838a9fb728b68a7d8348051";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/extension-installer/zipball/66c7adc9dfa38b6b5838a9fb728b68a7d8348051";
          sha256 = "12i8arlgw11n3x622kdbmx935agjm93gj6lw92illwlvwr37jrgs";
        };
      };
    };
    "phpstan/phpdoc-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpdoc-parser-e352d065af1ae9b41c12d1dfd309e90f7b1f55c9";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpdoc-parser/zipball/e352d065af1ae9b41c12d1dfd309e90f7b1f55c9";
          sha256 = "0dhcg75mdgplilv864qwfhryx36j3v8c30miw4632lj7d5jw6a5c";
        };
      };
    };
    "phpstan/phpstan" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-464d1a81af49409c41074aa6640ed0c4cbd9bb68";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan/zipball/464d1a81af49409c41074aa6640ed0c4cbd9bb68";
          sha256 = "1ai911kvzbik64sshl1bs4dyqly90gml2rnbigs4v5x7vkn2a1ds";
        };
      };
    };
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-f6293e1b30a2354e8428e004689671b83871edde";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/f6293e1b30a2354e8428e004689671b83871edde";
          sha256 = "0q7az9h109jchlsgkzlnvzl90f39ifqp53k9bih85lbkaiz5w329";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-aa4be8575f26070b100fccb67faabb28f21f66f8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/aa4be8575f26070b100fccb67faabb28f21f66f8";
          sha256 = "0vxnrzwb573ddmiw1sd77bdym6jiimwjhcz7yvmsr9wswkxh18l6";
        };
      };
    };
    "phpunit/php-invoker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-invoker-5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-invoker/zipball/5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
          sha256 = "1vqnnjnw94mzm30n9n5p2bfgd3wd5jah92q6cj3gz1nf0qigr4fh";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
          sha256 = "0ff87yzywizi6j2ps3w0nalpx16mfyw3imzn6gj9jjsfwc2bb8lq";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-timer/zipball/5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
          sha256 = "0g1g7yy4zk1bidyh165fsbqx5y8f1c8pxikvcahzlfsr9p2qxk6a";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-89ff45ea9d70e35522fb6654a2ebc221158de276";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/phpunit/zipball/89ff45ea9d70e35522fb6654a2ebc221158de276";
          sha256 = "1vmw75jig4kggpvn117jh7aszfww6k899z5vhq2lq5jap9hqdwkw";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-8622567409010282b7aeebe4bb841fe98b58dcaf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/8622567409010282b7aeebe4bb841fe98b58dcaf";
          sha256 = "0qfvyfp3mli776kb9zda5cpc8cazj3prk0bg0gm254kwxyfkfrwn";
        };
      };
    };
    "psr/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-event-dispatcher-dbefd12671e8a14ec7f180cab83036ed26714bb0";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/event-dispatcher/zipball/dbefd12671e8a14ec7f180cab83036ed26714bb0";
          sha256 = "05nicsd9lwl467bsv4sn44fjnnvqvzj1xqw2mmz9bac9zm66fsjd";
        };
      };
    };
    "rector/rector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "rector-rector-5c030ad7cefa59075e0fe14604cd4982ceaa2bd0";
        src = fetchurl {
          url = "https://api.github.com/repos/rectorphp/rector/zipball/5c030ad7cefa59075e0fe14604cd4982ceaa2bd0";
          sha256 = "10b96i763dzcyrx6731f48gfvpvmsvdl9r5hv1w7ip3rpvrgl1yc";
        };
      };
    };
    "rector/rector-phpstan-rules" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "rector-rector-phpstan-rules-84b2034aab951be7e86dc6cc7e141ee92a3d115b";
        src = fetchurl {
          url = "https://api.github.com/repos/rectorphp/phpstan-rules/zipball/84b2034aab951be7e86dc6cc7e141ee92a3d115b";
          sha256 = "1g8kmbyg2jhxf9cpbh41wi9b9vdwky0rwgh1dxs5kl1s36r7dlw7";
        };
      };
    };
    "sebastian/cli-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-cli-parser-442e7c7e687e42adc03470c7b668bc4b2402c0b2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/cli-parser/zipball/442e7c7e687e42adc03470c7b668bc4b2402c0b2";
          sha256 = "074qzdq19k9x4svhq3nak5h348xska56v1sqnhk1aj0jnrx02h37";
        };
      };
    };
    "sebastian/code-unit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-1fc9f64c0927627ef78ba436c9b17d967e68e120";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit/zipball/1fc9f64c0927627ef78ba436c9b17d967e68e120";
          sha256 = "04vlx050rrd54mxal7d93pz4119pas17w3gg5h532anfxjw8j7pm";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
          sha256 = "1h1jbzz3zak19qi4mab2yd0ddblpz7p000jfyxfwd2ds0gmrnsja";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-55f4261989e546dc112258c7a75935a81a7ce382";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/comparator/zipball/55f4261989e546dc112258c7a75935a81a7ce382";
          sha256 = "1d4bgf4m2x0kn3nw9hbb45asbx22lsp9vxl74rp1yl3sj2vk9sch";
        };
      };
    };
    "sebastian/complexity" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-complexity-739b35e53379900cc9ac327b2147867b8b6efd88";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/complexity/zipball/739b35e53379900cc9ac327b2147867b8b6efd88";
          sha256 = "1y4yz8n8hszbhinf9ipx3pqyvgm7gz0krgyn19z0097yq3bbq8yf";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-3461e3fccc7cfdfc2720be910d3bd73c69be590d";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/3461e3fccc7cfdfc2720be910d3bd73c69be590d";
          sha256 = "0967nl6cdnr0v0z83w4xy59agn60kfv8gb41aw3fpy1n2wpp62dj";
        };
      };
    };
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-388b6ced16caa751030f6a69e588299fa09200ac";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/environment/zipball/388b6ced16caa751030f6a69e588299fa09200ac";
          sha256 = "022vn8zss3sm7hg83kg3y0lmjw2ak6cy64b584nbsgxfhlmf6msd";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-d89cc98761b8cb5a1a235a6b703ae50d34080e65";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/exporter/zipball/d89cc98761b8cb5a1a235a6b703ae50d34080e65";
          sha256 = "1s8v0cbcjdb0wvwyh869y5f8d55mpjkr0f3gg2kvvxk3wh8nvvc7";
        };
      };
    };
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-a90ccbddffa067b51f574dea6eb25d5680839455";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/global-state/zipball/a90ccbddffa067b51f574dea6eb25d5680839455";
          sha256 = "0pad9gz2y38rziywdliylhhgz6762053pm57254xf7hywfpqsa3a";
        };
      };
    };
    "sebastian/lines-of-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-lines-of-code-c1c2e997aa3146983ed888ad08b15470a2e22ecc";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/lines-of-code/zipball/c1c2e997aa3146983ed888ad08b15470a2e22ecc";
          sha256 = "0fay9s5cm16gbwr7qjihwrzxn7sikiwba0gvda16xng903argbk0";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-5c9eeac41b290a3712d88851518825ad78f45c71";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/5c9eeac41b290a3712d88851518825ad78f45c71";
          sha256 = "11853z07w8h1a67wsjy3a6ir5x7khgx6iw5bmrkhjkiyvandqcn1";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
          sha256 = "0g5m1fswy6wlf300x1vcipjdljmd3vh05hjqhqfc91byrjbk4rsg";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-cd9d8cf3c5804de4341c283ed787f099f5506172";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/cd9d8cf3c5804de4341c283ed787f099f5506172";
          sha256 = "1k0ki1krwq6329vsbw3515wsyg8a7n2l83lk19pdc12i2lg9nhpy";
        };
      };
    };
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
          sha256 = "0p5s8rp7mrhw20yz5wx1i4k8ywf0h0ximcqan39n9qnma1dlnbyr";
        };
      };
    };
    "sebastian/type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-type-0d1c587401514d17e8f9258a27e23527cb1b06c1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/type/zipball/0d1c587401514d17e8f9258a27e23527cb1b06c1";
          sha256 = "0j611jjrch6n4ymkkmw48sdnim67ir0r8dzyvnb12gdxn9g7ca79";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-c6c1022351a901512170118436c764e473f6de8c";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/version/zipball/c6c1022351a901512170118436c764e473f6de8c";
          sha256 = "1bs7bwa9m0fin1zdk7vqy5lxzlfa9la90lkl27sn0wr00m745ig1";
        };
      };
    };
    "sebastianfeldmann/camino" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastianfeldmann-camino-3b611368e22e8565c3a6504613136402ed9e6f69";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianfeldmann/camino/zipball/3b611368e22e8565c3a6504613136402ed9e6f69";
          sha256 = "0py333ki5p4vj5ch3fcf8h3lsp5prpy41d7jn6a792i8m6z6h0vf";
        };
      };
    };
    "sebastianfeldmann/cli" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastianfeldmann-cli-c4a677f229976c88cc8f50b1477ab15244a4f6d8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianfeldmann/cli/zipball/c4a677f229976c88cc8f50b1477ab15244a4f6d8";
          sha256 = "1j9h3cxsrn7h1cibjbag7hci6spblyvch2n3b707vdkyhk09wpkf";
        };
      };
    };
    "sebastianfeldmann/git" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastianfeldmann-git-406b98e09c37249ce586be8ed5766bf0ca389490";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianfeldmann/git/zipball/406b98e09c37249ce586be8ed5766bf0ca389490";
          sha256 = "0w77add73lpdd9ri2qjhcp68r6y1scrsy0wsfn8mvgp2lyrc5rp9";
        };
      };
    };
    "symfony/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-config-9f4a448c2d7fd2c90882dfff930b627ddbe16810";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/config/zipball/9f4a448c2d7fd2c90882dfff930b627ddbe16810";
          sha256 = "00hcv50k92lg0ssm6chrssim4x8kw77bphz8h6q5z5n4hnp8vphl";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-058553870f7809087fa80fa734704a21b9bcaeb2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/058553870f7809087fa80fa734704a21b9bcaeb2";
          sha256 = "0cvs8k87kkilv4pp4bbgj97g0j87bw279yx7g34zr8l7wa91gblw";
        };
      };
    };
    "symfony/dependency-injection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-dependency-injection-94d973cb742d8c5c5dcf9534220e6b73b09af1d4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/dependency-injection/zipball/94d973cb742d8c5c5dcf9534220e6b73b09af1d4";
          sha256 = "0bw0nr265kkkb30mx66mg60ln7zhjy23anmm2dnn93nivg4pnijj";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-5f38c8804a9e97d23e0c8d63341088cd8a22d627";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/5f38c8804a9e97d23e0c8d63341088cd8a22d627";
          sha256 = "11k6a8v9b6p0j788fgykq6s55baba29lg37fwvmn4igxxkfwmbp3";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-0e6768b8c0dcef26df087df2bbbaa143867a59b2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/0e6768b8c0dcef26df087df2bbbaa143867a59b2";
          sha256 = "0gs1mz6xzl0h4cc7wllk36dpm37cr8wczwvwn6sgl17pdbvrmncs";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-67a5f354afa8e2f231081b3fa11a5912f933c3ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/67a5f354afa8e2f231081b3fa11a5912f933c3ce";
          sha256 = "0qnaby62l2sw6zg4m258jmhy2llqc1jh8yg6wyx6snjimm008r3q";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-69fee1ad2332a7cbab3aca13591953da9cdb7a11";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/69fee1ad2332a7cbab3aca13591953da9cdb7a11";
          sha256 = "1xajgmj8fnix4q1p93mhhiwvxspm8p4ksgzyyh31sj4xsp1c41x7";
        };
      };
    };
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-348116319d7fb7d1faa781d26a48922428013eb2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/filesystem/zipball/348116319d7fb7d1faa781d26a48922428013eb2";
          sha256 = "0r5gab1zdhgqr9ix0wa2d80nm7a2qvga89gh2awy6sfcb5ndhp5c";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-0ae3f047bed4edff6fd35b26a9a6bfdc92c953c6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/0ae3f047bed4edff6fd35b26a9a6bfdc92c953c6";
          sha256 = "0g7ywxk5qax371g9bc051kvbv7rq2r75ikj9zrxjlnp4gkbinf6m";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-7e82f6084d7cae521a75ef2cb5c9457bbda785f4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client-contracts/zipball/7e82f6084d7cae521a75ef2cb5c9457bbda785f4";
          sha256 = "04mszmb94y0xjs0cwqxzhpf65kfqhhqznldifbxvrrlxb9nn23qc";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-8827b90cf8806e467124ad476acd15216c2fceb6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/8827b90cf8806e467124ad476acd15216c2fceb6";
          sha256 = "0yjkl4skfwr34m17z290g4bbzf2wd4mz8886ydx4hslwh3avvjja";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-74eb022e3bac36b3d3a897951a98759f2b32b864";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/74eb022e3bac36b3d3a897951a98759f2b32b864";
          sha256 = "16pz8s9k7nh3mfk81d0qsk3n0zznwdqdrphiq4fdy9407yj5djqj";
        };
      };
    };
    "symfony/options-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-options-resolver-162e886ca035869866d233a2bfef70cc28f9bbe5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/options-resolver/zipball/162e886ca035869866d233a2bfef70cc28f9bbe5";
          sha256 = "1n6f8kpg451fn99n9msdsm5z9hwzpn764zkxgzkif61i5diyvmj9";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-24b72c6baa32c746a4d0840147c9715e42bb68ab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/24b72c6baa32c746a4d0840147c9715e42bb68ab";
          sha256 = "1ddgvsr2k585mj2vr3z1q56kxdbb5fin7y0ixhb1791x36km77f3";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9a142215a36a3888e30d0a9eeea9766764e96976";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/9a142215a36a3888e30d0a9eeea9766764e96976";
          sha256 = "06ipbcvrxjzgvraf2z9fwgy0bzvzjvs5z1j67grg1gb15x3d428b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010";
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-e66119f3de95efc359483f810c4c3e6436279436";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/e66119f3de95efc359483f810c4c3e6436279436";
          sha256 = "0hg340da7m0yipj2bj5hxhd3mqidz767ivg7w85r8vwz3mr9k1p3";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-53e36cb1c160505cdaf1ef201501669c4c317191";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/53e36cb1c160505cdaf1ef201501669c4c317191";
          sha256 = "1p51fi87pgqsxjwsm0krix3wmgsa8nz8y9p1n7jqc9hfdn08rs0b";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb";
          sha256 = "1i573rmajc33a9nrgwgc4k3svg29yp9xv17gp133rd1i705hwv1y";
        };
      };
    };
    "symfony/stopwatch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-stopwatch-313d02f59d6543311865007e5ff4ace05b35ee65";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/stopwatch/zipball/313d02f59d6543311865007e5ff4ace05b35ee65";
          sha256 = "188wk08rzvaghm2xhmbgvxkb3ymamknm23pcq3a341b8hafypdiq";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-a9a0f8b6aafc5d2d1c116dcccd1573a95153515b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/a9a0f8b6aafc5d2d1c116dcccd1573a95153515b";
          sha256 = "0w0p2afwfnq4xm8wg26wbfdrqd782syn18as79l2yar8bgqqpf48";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-1d3953e627fe4b5f6df503f356b6545ada6351f3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/1d3953e627fe4b5f6df503f356b6545ada6351f3";
          sha256 = "10f1s4ia33jgy858bp11wj6vi2cbrdjfff67dsj0y4xznbgihdkz";
        };
      };
    };
    "symplify/astral" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-astral-2d205265eacad08eb5b620ddfa71b334ce992233";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/astral/zipball/2d205265eacad08eb5b620ddfa71b334ce992233";
          sha256 = "0zyhnbx2rac2s43dnhb3ddfb63brrnh4z0dvizz0sz1va7lf3g6b";
        };
      };
    };
    "symplify/autowire-array-parameter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-autowire-array-parameter-7794f4d1eafa7e32905e8b38d37eae7b597ed1a8";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/autowire-array-parameter/zipball/7794f4d1eafa7e32905e8b38d37eae7b597ed1a8";
          sha256 = "1fysi5l36fbj0s6i1y37d4cpnnbvrsqd463yxzfsrkakb427bdvi";
        };
      };
    };
    "symplify/coding-standard" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-coding-standard-3ce70069790d35e6d6377675778157b573f3a2dd";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/coding-standard/zipball/3ce70069790d35e6d6377675778157b573f3a2dd";
          sha256 = "0ylj6ba14vdw2f2my9g8a792awwgf76s8xj8vpd4arr01pdj492q";
        };
      };
    };
    "symplify/composer-json-manipulator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-composer-json-manipulator-a3d711ec0928cf8ddf3e4c16dad335318d588679";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/composer-json-manipulator/zipball/a3d711ec0928cf8ddf3e4c16dad335318d588679";
          sha256 = "0mx6iq3wjk166bvzybmq8i1vhwwzmwniqw2jg1b3hfabss3x2iyq";
        };
      };
    };
    "symplify/console-package-builder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-console-package-builder-14a0eeaed45b850e579ddd16913a5d74ec856f16";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/console-package-builder/zipball/14a0eeaed45b850e579ddd16913a5d74ec856f16";
          sha256 = "0x0z82xppsi8rc8ri75b3payx8fr31bfh81vp11fd8nk7lhv2wv5";
        };
      };
    };
    "symplify/easy-coding-standard" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-easy-coding-standard-7ada08f221241f513531588585e55f423100705d";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/easy-coding-standard/zipball/7ada08f221241f513531588585e55f423100705d";
          sha256 = "0q48pzq54fxdfs65zwp9pfqk3vl09fppmbkg6vgjmabd4dlay1ss";
        };
      };
    };
    "symplify/easy-testing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-easy-testing-6d5543190c9d578b61d9181d77d7255340743929";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/easy-testing/zipball/6d5543190c9d578b61d9181d77d7255340743929";
          sha256 = "1rm31762z81ypy8aa9z1qy3gmvrfaipbb31bxq4142qqvj318lxr";
        };
      };
    };
    "symplify/package-builder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-package-builder-a86c7bd0307ba0b368510851e86082f773e64138";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/package-builder/zipball/a86c7bd0307ba0b368510851e86082f773e64138";
          sha256 = "12mxhmakgv6q4kxy1np161p0qgpgqsq0dwags0gd2ri7nf0zinb1";
        };
      };
    };
    "symplify/phpstan-extensions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-phpstan-extensions-e9c83ac50fe205f28bece8013d92f5a9130dc3d6";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/phpstan-extensions/zipball/e9c83ac50fe205f28bece8013d92f5a9130dc3d6";
          sha256 = "1mczcx0sk8qin12bh7hdlc60kfg1vj5cisvvas5ja3sgsh2mz6zs";
        };
      };
    };
    "symplify/phpstan-rules" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-phpstan-rules-1fac85aa8621e29af083b49c71d8ce793ca4dd46";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/phpstan-rules/zipball/1fac85aa8621e29af083b49c71d8ce793ca4dd46";
          sha256 = "0kwd5xi5mn8ppdm6as0nkrhmp4kk28rrpgfwqzwhzdilswrkv1lx";
        };
      };
    };
    "symplify/rule-doc-generator-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-rule-doc-generator-contracts-a6f944a49198ed3260bc941533629e917137e476";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/rule-doc-generator-contracts/zipball/a6f944a49198ed3260bc941533629e917137e476";
          sha256 = "08rabbs85h6ji9s0ksqfks2mnba0689inx3hbwm1yn05mpd2p5zn";
        };
      };
    };
    "symplify/simple-php-doc-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-simple-php-doc-parser-5668608067a6ee4f0513348bdb46319617288ce1";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/simple-php-doc-parser/zipball/5668608067a6ee4f0513348bdb46319617288ce1";
          sha256 = "0b22qyccyp76q5jkc1mrbnq0skfab67l591c0fdak6vmn433cxbn";
        };
      };
    };
    "symplify/smart-file-system" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-smart-file-system-a2a8d39fe46b01ead8d2af7368b0b36b68fac979";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/smart-file-system/zipball/a2a8d39fe46b01ead8d2af7368b0b36b68fac979";
          sha256 = "14prm5r5vjz2f2w35n93xfjlhkwdw404qk5vk2j9qnfr7aslqqc4";
        };
      };
    };
    "symplify/symplify-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symplify-symplify-kernel-966602555962ef929214be2459bfeef3d0ceb114";
        src = fetchurl {
          url = "https://api.github.com/repos/symplify/symplify-kernel/zipball/966602555962ef929214be2459bfeef3d0ceb114";
          sha256 = "0kxc6x4jm805jmgz3iigjpijafilq3yzi1pz6gz1c72gnxx9ndsj";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-75a63c33a8577608444246075ea0af0d052e452a";
        src = fetchurl {
          url = "https://api.github.com/repos/theseer/tokenizer/zipball/75a63c33a8577608444246075ea0af0d052e452a";
          sha256 = "1cj1lb99hccsnwkq0i01mlcldmy1kxwcksfvgq6vfx8mgz3iicij";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-6964c76c7804814a842473e0c8fd15bab0f18e25";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/6964c76c7804814a842473e0c8fd15bab0f18e25";
          sha256 = "17xqhb2wkwr7cgbl4xdjf7g1vkal17y79rpp6xjpf1xgl5vypc64";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "podlibre-castopod-host";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = "https://castopod.org";
    license = "AGPL-3.0-or-later";
  };
}
