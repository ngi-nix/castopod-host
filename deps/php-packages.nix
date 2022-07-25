{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false, packageOverrides}:

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
        name = "james-heinrich-getid3-ee238d552571c6029898b087d5fc95df826418d6";
        src = fetchurl {
          url = "https://api.github.com/repos/JamesHeinrich/getID3/zipball/ee238d552571c6029898b087d5fc95df826418d6";
          sha256 = "1yq26vhgk4j4vn2j4idz0477lkd766963m9vvkk1g1cckxhf1flv";
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
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages packageOverrides noDev;
  name = "podlibre-castopod-host";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = "https://castopod.org";
    license = "AGPL-3.0-or-later";
  };
}
