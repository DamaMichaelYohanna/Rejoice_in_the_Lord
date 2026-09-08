import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hymn.dart';

class HymnsData {
  static List<Hymn>? _cachedExtractedHymns;

  static Future<List<Hymn>> getExtractedHymns() async {
    if (_cachedExtractedHymns != null) return _cachedExtractedHymns!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/extracted_hymns.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedExtractedHymns = jsonList.map((item) => Hymn.fromJson(item)).toList();
      return _cachedExtractedHymns!;
    } catch (e) {
      return [];
    }
  }

  static final List<String> categories = [
    "All",
    "Entrance",
    "Offertory",
    "Communion",
    "Recessional",
    "Marian",
    "Adoration & Eucharist",
    "Mass Parts",
    "Lent & Passion",
    "Easter & Resurrection",
    "Advent & Christmas",
    "Praise & Worship",
  ];

  static List<Hymn> getAllHymns() {
    return [
      Hymn(
        id: 1,

        number: "1",
        title: "Abba, Father, Send Your Spirit",
        category: "Praise & Worship",
        stanzas: [
          "1. Abba, Father, send Your Spirit,\nGlory Jesus Christ!\nGlory Jesus, Lord of all things,\nGlory be to God!",
          "2. Glory to the Father, glory to the Son,\nGlory to the Holy Spirit,\nGlory be to God!",
          "3. I will give You glory, I will give You praise,\nI will bless Your Holy Name,\nForever and ever.",
        ],
        refrain: "Abba, Father, send Your Spirit,\nGlory Jesus Christ!\nGlory Jesus, Lord of all things,\nGlory be to God!",
      ),
      Hymn(
        id: 2,
        number: "2",
        title: "All People That On Earth Do Dwell",
        category: "Entrance",
        tune: "Old 100th",
        keySignature: "G Major",
        stanzas: [
          "1. All people that on earth do dwell,\nSing to the Lord with cheerful voice;\nHim serve with fear, His praise forth tell,\nCome ye before Him and rejoice.",
          "2. The Lord, ye know, is God indeed;\nWithout our aid He did us make;\nWe are His flock, He doth us feed,\nAnd for His sheep He doth us take.",
          "3. O enter then His gates with praise,\nApproach with joy His courts unto;\nPraise, laud, and bless His name always,\nFor it is seemly so to do.",
          "4. For why? the Lord our God is good;\nHis mercy is for ever sure;\nHis truth at all times firmly stood,\nAnd shall from age to age endure.",
        ],
        refrain: "Praise God from whom all blessings flow,\nPraise Him all creatures here below!",
      ),
      Hymn(
        id: 3,
        number: "3",
        title: "Abide With Me",
        category: "Recessional",
        tune: "Eventide",
        keySignature: "Eb Major",
        stanzas: [
          "1. Abide with me: fast falls the eventide;\nThe darkness deepens; Lord, with me abide.\nWhen other helpers fail and comforts flee,\nHelp of the helpless, O abide with me.",
          "2. Swift to its close ebbs out life's little day;\nEarth's joys grow dim, its glories pass away;\nChange and decay in all around I see;\nO Thou Who changest not, abide with me.",
          "3. I need Thy presence every passing hour;\nWhat but Thy grace can foil the tempter's power?\nWho, like Thyself, my guide and stay can be?\nThrough cloud and sunshine, Lord, abide with me.",
          "4. I fear no foe, with Thee at hand to bless;\nIlls have no weight, and tears no bitterness.\nWhere is death's sting? Where, grave, thy victory?\nI triumph still, if Thou abide with me.",
          "5. Hold Thou Thy cross before my closing eyes.\nShine through the gloom -\nAnd point me to the skies:\nHeaven's morning breaks and earth's vain shadows flee.\nIn life, in death,\nO Lord, abide with me.",
        ],
      ),
      Hymn(
        id: 4,
        number: "4",
        title: "Accept Almighty Father",
        category: "Offertory",
        refrain: "Accept Almighty Father,\nthese gifts of wine and bread,\nnow offered at the altar\nto you through Christ our head,",
        stanzas: [
          "1. In humble reparation\nfor sins and fallings dread\nto gain life everlasting\nfor living and for dead.",
          "2. O God, by this co-mingling\nof water and of wine\nmay He who took our nature\ngive us His life divine.",
          "3. Come, then, and make us holy;\nreceive this sacrifice\ninto Your favour take us.\nIn Christ may we arise.",
        ],
      ),
      Hymn(
        id: 5,
        number: "5",
        title: "Accept O Lord",
        category: "Offertory",
        refrain: "God is infinite in His Goodness\nHe will hear us. He will bless us",
        stanzas: [
          "1. Accept O Lord,\nthe gifts that we bring\nto offer in Your Name.\nChange the bread and wine,\nO Lord,",
          "2. Into the Body and Blood of Christ.\nIf you have some gifts to offer to the Lord,\nand you know you are not in terms with your brethren,\nset the gifts aside,\ngo back and make peace.\nMake peace with him;\nreturn with your gifts and make your offering.",
        ],
      ),
      Hymn(
        id: 6,
        number: "6",
        title: "Adoremus in Aeternum",
        category: "Adoration & Eucharist",
        refrain: "ANT. Adoremus in aeternum sanctissimum Sacramentum.",
        stanzas: [
          "PSALM:\nLaudate Dominum, omnes gentes;\nLaudate eum omnes populi.\nQuoniam confirmata est super nos misericordia ejus;\net veritas Domini manet in aeternum.",
          "Gloria Patri, et Filio, et Spiritui Sancto.\nSicut erat in principio, et nunc, et semper,\net in secula saeculorum, Amen.",
        ],
      ),
      Hymn(
        id: 7,
        number: "7",
        title: "A Great and Mighty Wonder",
        category: "Advent & Christmas",
        stanzas: [
          "1. A great and mighty wonder\nA full and holy cure\nThe virgin bears the infant\nWith virgin honour pure\nRepeat the hymn again To God on high be glory\nAnd peace on earth to men.",
          "2. The word becomes incarnate,\nAnd yet remains on high\nAnd cherubim sings anthems\nTo shepherds from the sky;\nWhile thus they sing your monarch\nThose bright angelic bands,\nRejoice, ye vales and mountains,\nYe oceans, clap your hands;\nRepeat the hymn again etc.",
          "3. Since all he comes to ransom\nBy all be he adored,\nThe infant born in Bethlehem\nThe Saviour and the Lord;\nRepeat the hymn again etc.",
        ],
      ),
      Hymn(
        id: 8,
        number: "8",
        title: "Alleluia, Alleluia",
        category: "Easter & Resurrection",
        refrain: "Alleluia (2)\nGive thanks to the risen Lord.\nAlleluia (2)\nGive praise to His Name.",
        stanzas: [
          "1. Jesus is Lord of all the earth;\nHe is the King of creation.",
          "2. Spread the good news o'er all the earth.\nJesus has died and has risen.",
          "3. We have been crucified with Christ,\nNow we shall live forever.",
          "4. God has ordained the just reward:\nlife for all men, alleluia.",
          "5. Come let us praise the living God,\nJoyfully sing to our Saviour.",
        ],
      ),
      Hymn(
        id: 9,
        number: "9",
        title: "Alleluia, Alleluia, Alleluia",
        category: "Easter & Resurrection",
        refrain: "Alleluia, Alleluia, Alleluia.",
        stanzas: [
          "1. Young men and maids, rejoice and sing.\nThe King of heaven, the glorious King,\nThis day from death rose triumphing.",
          "2. On Sunday morn by break of day,\nHis dear disciples haste away\nunto the tomb wherein He lay. Alleluia.",
          "3. Nor Magdalen, nor Salome,\nNor James' mother now delay\nto embalm the precious corpse straight away. Alleluia.",
          "4. An angel clothed in white they see.\nThen thither come and thus spoke he,\n\"The Lord is gone to Galilee\". Alleluia.",
          "5. The dear beloved apostle, John,\nmuch swifter than St. Peter ran.\nAnd first arrived at the tomb Alleluia.",
          "6. While in a room the apostles were\nin midst of them did Christ appear\nand said, \"Peace be upon you all\". Alleluia.",
        ],
      ),
      Hymn(
        id: 10,
        number: "10",
        title: "Alleluia by Your Glory",
        category: "Praise & Worship",
        refrain: "Alleluia by your glory,\nAlleluia Amen.\nAlleluia by your glory\nRevive us O Lord.",
        stanzas: [
          "1. We praise you, O God,\nfor the sign of Your Love,\nLord Jesus Christ\nWho died for all.",
          "2. We thank you, O God\nfor your patience.\nYou call us every moment\nto taste Your Love.",
          "3. For glory and praise\nbelongs to You, God.\nYour goodness endures\nForever more.",
          "4. Make clear to me, Lord\nYour Loving Will.\nFor I can do all things,\nin You Who are my strength.",
        ],
      ),
      Hymn(
        id: 11,
        number: "11",
        title: "Alleluia! He Arose!",
        category: "Easter & Resurrection",
        stanzas: [
          "1. Jesus Christ the son of God, O yes, O yes.\nAlleluia He arose, O yes, O yes.\nAlleluia He arose the Prince of Peace arose\nAlleluia He arose O yes, O yes.",
          "2. As He promised He arose, O yes, O yes.\nOn the third day He arose, O yes, O yes.",
          "3. He conquer'd death He arose, O yes, O yes\nNo more to die He arose, O yes, O yes.",
        ],
      ),
      Hymn(
        id: 12,
        number: "12",
        title: "Alleluia, Sing to Jesus",
        category: "Adoration & Eucharist",
        stanzas: [
          "1. Alleluia sing to Jesus!\nHis the scepter, his the throne;\nAlleluia! His the triumph\nHis the victory alone;\nHark! The songs of Holy Zion\nThunder like a mighty flood;\nJesus out of every nation\nHas redeemed us by his blood.",
          "2. Alleluia! Bread of heaven,\nHere on earth our food and stay! Alleluia!\nHere the sinful\nTurn to you from day to day:\nIntercessor, friend of sinners,\nEarth's redeemer, plead for us\nWhere the voices of the blessed Join the chant victorious.",
          "3. Alleluia! King eternal,\nYou are Lord of lords alone\nAlleluia! Born of Mary,\nEarth's your footstool, heaven your throne:\nYou within the veil have entered,\nRobed in flesh, our great high priest;\nYou on earth are priest and victim In the Eucharistic feast.",
        ],
      ),
      Hymn(
        id: 13,
        number: "13",
        title: "All Glory, Laud and Honor",
        category: "Lent & Passion",
        refrain: "All glory, laud, and honor\nto thee, Redeemer, King!\nTo whom the lips of children\nMade sweet hosannas ring",
        stanzas: [
          "1. Thou art the King of Israel,\nThou David's royal Son,\nwho in the Lord's name - comest,\nThe King and blessed one.",
          "2. The company of angels\nAre prasing thee on high;\nAnd mortal men, and all things Created, make reply.",
          "3. The people of the Hebrews\nWith palms before thee went:\nOur praise and prayer and anthems Before thee we present.",
          "4. To thee before thy passion\nThey sang their hymns of praise\nTo thee, now high exalted,\nOur melody we praise",
          "5. Thou didst accept their praises:\nAccept the prayers we bring,\nWho in all good delightest,\nThou good and gracious King.",
        ],
      ),
      Hymn(
        id: 14,
        number: "14",
        title: "All Good Things",
        category: "Offertory",
        refrain: "All good things around us\nare sent from heaven above\nThen thank the Lord.\nO thank the Lord for all his Love",
        stanzas: [
          "1. We plough the fields and scatter the good seed on the earth.\nBut it is fed and watered by God's Almighty Hand.\nHe sends the snow in winter the warmth to swell the grain, the breeze and the sunshine, and soft refreshing rain.",
          "2. He only is the Maker of all things near and far.\nHe paints the wayside flower. He lights the evening star.\nThe winds and waves obey Him.\nBy Him the birds arefed.\nMuch more to us His children, He gives our daily bread.",
          "3. We thank You then dear Father for all things bright and good, the seed time and the harvest, our life our health, our food.\nAnd all that we can offer Your boundless love imparts, the gifts to You, most pleasing are humble, thankful hearts.",
        ],
      ),
      Hymn(
        id: 15,
        number: "15",
        title: "All Hail the Power",
        category: "Praise & Worship",
        stanzas: [
          "1. All hail the power of Jesus' name, let angels prostrate fall.\nLet angels prostrate fall.\nBring forth the royal diadem to crown Him, crown Him. crown Him, crown Him, crown Him. crown Him, crown Him, to crown Him Lord of all.",
          "2. Crown Him ye martyrs of your God who from His altar call.\nPraise Him whose way of pain you trod And crown him Lord of all.",
          "3. Ye prophets who our freedom won, Ye searchers great and small, by Whom the work of truth is done.\nNow crown Him Lord of all.",
          "4. Sinners, whose love can ne'er forget the wormwood and the gall, go spread your trophies at His Feet and crown Him Lord of all.",
          "5. Bless Him each poor; oppressed race that Christ did upward; call.; His Hand in each achievement trace.\nAnd crown Him Lord of all.",
        ],
      ),
    ];
  }
}
