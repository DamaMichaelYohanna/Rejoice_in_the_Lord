import '../models/hymn.dart';

class HymnsData {
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
    List<Hymn> hymns = [];

    // Map of specific curated famous Catholic hymns for known numbers
    final Map<int, Hymn> curated = {
      1: Hymn(
        id: 1,
        number: "1",
        title: "All People That On Earth Do Dwell",
        category: "Entrance",
        keySignature: "G Major",
        tune: "Old 100th",
        stanzas: [
          "1. All people that on earth do dwell,\nSing to the Lord with cheerful voice;\nHim serve with fear, His praise forth tell,\nCome ye before Him and rejoice.",
          "2. The Lord, ye know, is God indeed;\nWithout our aid He did us make;\nWe are His flock, He doth us feed,\nAnd for His sheep He doth us take.",
          "3. O enter then His gates with praise,\nApproach with joy His courts unto;\nPraise, laud, and bless His name always,\nFor it is seemly so to do.",
          "4. For why? the Lord our God is good;\nHis mercy is for ever sure;\nHis truth at all times firmly stood,\nAnd shall from age to age endure.",
        ],
        refrain: "Praise God from whom all blessings flow,\nPraise Him all creatures here below!",
      ),
      2: Hymn(
        id: 2,
        number: "2",
        title: "Holy God, We Praise Thy Name",
        category: "Praise & Worship",
        keySignature: "F Major",
        tune: "Te Deum",
        stanzas: [
          "1. Holy God, we praise Thy name;\nLord of all, we bow before Thee!\nAll on earth Thy scepter claim,\nAll in heav'n above adore Thee;\nInfinite Thy vast domain,\nEverlasting is Thy reign.",
          "2. Hark! the loud celestial hymn\nAngel choirs above are raising;\nCherubim and seraphim,\nIn unceasing chorus praising;\nFill the heav'ns with sweet accord:\nHoly, holy, holy Lord.",
          "3. Lo! the apostolic train\nJoins the sacred name to hallow;\nProphets swell the loud refrain,\nAnd the white-robed martyrs follow;\nAnd from morn to set of sun,\nThrough the Church the song goes on.",
        ],
        refrain: "Infinite Thy vast domain, Everlasting is Thy reign!",
      ),
      10: Hymn(
        id: 10,
        number: "10",
        title: "Praise to the Lord, the Almighty",
        category: "Praise & Worship",
        keySignature: "F Major",
        tune: "Lobe Den Herren",
        stanzas: [
          "1. Praise to the Lord, the Almighty, the King of creation!\nO my soul, praise Him, for He is thy health and salvation!\nAll ye who hear, now to His temple draw near;\nPraise Him in glad adoration.",
          "2. Praise to the Lord, who o'er all things so wondrously reigneth,\nShelters thee under His wings, yea, so gently sustaineth!\nHast thou not seen how thy desires e'er have been\nGranted in what He ordaineth?",
          "3. Praise to the Lord, who doth prosper thy work and defend thee;\nSurely His goodness and mercy here daily attend thee.\nPonder anew what the Almighty can do,\nIf with His love He befriend thee.",
        ],
      ),
      25: Hymn(
        id: 25,
        number: "25",
        title: "O Come, All Ye Faithful",
        category: "Advent & Christmas",
        keySignature: "G Major",
        tune: "Adeste Fideles",
        stanzas: [
          "1. O come, all ye faithful, joyful and triumphant!\nO come ye, O come ye to Bethlehem;\nCome and behold Him Born the King of Angels:",
          "2. God of God, Light of Light,\nLo, He abhors not the Virgin's womb;\nVery God, Begotten, not created:",
          "3. Sing, choirs of angels, sing in exultation,\nSing, all ye citizens of heav'n above!\nGlory to God, all glory in the highest:",
        ],
        refrain: "O come, let us adore Him,\nO come, let us adore Him,\nO come, let us adore Him,\nChrist the Lord!",
      ),
      50: Hymn(
        id: 50,
        number: "50",
        title: "Lord, Accept the Gifts We Offer",
        category: "Offertory",
        keySignature: "F Major",
        tune: "Gott Vater Sei Gepriesen",
        stanzas: [
          "1. Lord, accept the gifts we offer\nAt this solemn offertory;\nTake ourselves, our hearts, our labors,\nFor Thy greater praise and glory.",
          "2. Bread and wine will soon be changed\nBy the priest's converting word;\nBody, Blood of Christ our Master,\nJesus, our redeeming Lord.",
          "3. With our gifts we lay before Thee\nAll our trials, griefs, and cares;\nUnite them with Thy Sacrifice,\nHear, O Lord, Thy people's prayers.",
        ],
        refrain: "Take our hearts and take our lives, Lord accept our sacrifice.",
      ),
      75: Hymn(
        id: 75,
        number: "75",
        title: "All That I Am, All That I Do",
        category: "Offertory",
        keySignature: "C Major",
        stanzas: [
          "1. All that I am, all that I do,\nAll that I'll ever have I offer now to You.\nTake and receive, Lord, all my liberty,\nMy memory, my understanding, my entire will.",
          "2. All that I have You have given to me;\nTo You, Lord, I return it.\nEverything is Yours, dispose of it wholly\nAccording to Your divine will.",
        ],
        refrain: "Give me only Your love and Your grace,\nThat is enough for me.",
      ),
      100: Hymn(
        id: 100,
        number: "100",
        title: "Soul of My Saviour (Anima Christi)",
        category: "Communion",
        keySignature: "F Major",
        tune: "Anima Christi",
        stanzas: [
          "1. Soul of my Saviour, sanctify my breast,\nBody of Christ, be Thou my saving guest,\nBlood of my Saviour, bathe me in Thy tide,\nWash me with water flowing from His side.",
          "2. Strength and protection may Thy Passion be,\nO blessed Jesus, hear and answer me;\nDeep in Thy wounds, Lord, hide and shelter me,\nSo that I never, never part from Thee.",
          "3. Guard me and defend me from the foe malign,\nIn death's dread moments make me only Thine;\nCall me and bid me come to Thee above,\nWhere I may praise Thee with Thy saints in love.",
        ],
      ),
      120: Hymn(
        id: 120,
        number: "120",
        title: "Sweet Sacrament Divine",
        category: "Adoration & Eucharist",
        keySignature: "D Major",
        stanzas: [
          "1. Sweet Sacrament divine, hid in Thy earthly home,\nLo! round Thy lowly shrine, on bended knee we come;\nJesus, to Thee we pray, for tired hearts to-day,\nComfort us in our need, sweet Sacrament divine.",
          "2. Sweet Sacrament of peace, dear home of every heart,\nWhere restless yearnings cease, and sorrows all depart;\nThere in Thine ear all day with childlike trust we pray,\nFor help who are distressed, sweet Sacrament of peace.",
        ],
        refrain: "Comfort us in our need, Sweet Sacrament divine!",
      ),
      150: Hymn(
        id: 150,
        number: "150",
        title: "O Bread of Heaven",
        category: "Communion",
        keySignature: "G Major",
        stanzas: [
          "1. O Bread of heaven, beneath this veil\nThou dost my very God conceal;\nMy Jesus, dearest treasure, hail!\nI love Thee and, to make me shall,\nIncrease my faith and love for Thee.",
          "2. O food of life, Thou Who dost give\nThe pledge of immortality;\nGrant me by Thy pure grace to live,\nAnd in Thy sacred heart to be.",
        ],
        refrain: "Sweetest Jesus, O Bread of Heaven, be my life forever.",
      ),
      200: Hymn(
        id: 200,
        number: "200",
        title: "Immaculate Mary (Ave Maria)",
        category: "Marian",
        keySignature: "F Major",
        tune: "Lourdes Hymn",
        stanzas: [
          "1. Immaculate Mary, your praises we sing;\nYou reign now in splendor with Jesus our King.",
          "2. In heaven the blessed your glory proclaim;\nOn earth we your children invoke your fair name.",
          "3. We pray for our Mother, the Church upon earth,\nAnd bless, Holy Mary, the land of our birth.",
        ],
        refrain: "Ave, Ave, Ave, Maria!\nAve, Ave, Maria!",
      ),
      210: Hymn(
        id: 210,
        number: "210",
        title: "Hail Queen of Heaven, the Ocean Star",
        category: "Marian",
        keySignature: "Bb Major",
        tune: "Stella",
        stanzas: [
          "1. Hail, Queen of heav'n, the ocean star,\nGuide of the wanderer here below,\nThrown on life's surge, we claim thy care,\nSave us from peril and from woe.",
          "2. O gentle, chaste, and spotless Maid,\nWe sinners make our prayers through thee;\nRemind thy Son that He has paid\nThe price of our iniquity.",
        ],
        refrain: "Mother of Christ, Star of the sea, pray for the wanderer, pray for me.",
      ),
      225: Hymn(
        id: 225,
        number: "225",
        title: "Daily, Daily Sing to Mary",
        category: "Marian",
        keySignature: "G Major",
        stanzas: [
          "1. Daily, daily sing to Mary, sing, my soul, her praises due;\nAll her feasts, her actions worship, with the heart's devotion true.\nLost in wond'ring contemplation, be her majesty confessed;\nCall her Mother, call her Virgin, happy Mother, Virgin blest.",
          "2. She is mighty to deliver; call upon her, brother dear;\nWhen the tempest rages round thee, she will lead thee, free from fear.",
        ],
      ),
      250: Hymn(
        id: 250,
        number: "250",
        title: "As the Deer Pants for the Water",
        category: "Praise & Worship",
        keySignature: "C Major",
        stanzas: [
          "1. As the deer pants for the water, so my soul longs after You.\nYou alone are my heart's desire and I long to worship You.",
          "2. You're my friend and You are my brother even though You are a King.\nI love You more than any other, so much more than anything.",
        ],
        refrain: "You alone are my strength, my shield;\nTo You alone may my spirit yield.\nYou alone are my heart's desire\nAnd I long to worship You.",
      ),
      300: Hymn(
        id: 300,
        number: "300",
        title: "To Jesus Christ, Our Sovereign King",
        category: "Recessional",
        keySignature: "F Major",
        tune: "Ich Glaub An Gott",
        stanzas: [
          "1. To Jesus Christ, our Sovereign King, Who is the world's salvation,\nAll praise and homage do we bring and thanks and adoration.",
          "2. Thy reign extend, O King benign, to every land and nation;\nFor in Thy Kingdom, Lord divine, alone we find salvation.",
        ],
        refrain: "Christ Jesus, Victor! Christ Jesus, Ruler!\nChrist Jesus, Lord and Redeemer!",
      ),
      350: Hymn(
        id: 350,
        number: "350",
        title: "Forty Days and Forty Nights",
        category: "Lent & Passion",
        keySignature: "G Minor",
        stanzas: [
          "1. Forty days and forty nights Thou wast fasting in the wild;\nForty days and forty nights tempted, still unbeguiled.",
          "2. Shall not we Thy sorrow share and from earthly joys abstain,\nFasting with unceasing prayer, strong with Thee to suffer pain?",
        ],
      ),
      400: Hymn(
        id: 400,
        number: "400",
        title: "Jesus Christ Is Risen Today",
        category: "Easter & Resurrection",
        keySignature: "C Major",
        tune: "Easter Hymn",
        stanzas: [
          "1. Jesus Christ is risen today, Alleluia!\nOur triumphant holy day, Alleluia!\nWho did once upon the cross, Alleluia!\nSuffer to redeem our loss, Alleluia!",
          "2. Hymns of praise then let us sing, Alleluia!\nUnto Christ, our heavenly King, Alleluia!\nWho endured the cross and grave, Alleluia!\nSinners to redeem and save, Alleluia!",
        ],
        refrain: "Alleluia! Alleluia! Alleluia!",
      ),
      450: Hymn(
        id: 450,
        number: "450",
        title: "Glory to God in the Highest",
        category: "Mass Parts",
        keySignature: "G Major",
        stanzas: [
          "Glory to God in the highest,\nand on earth peace to people of good will.\nWe praise You, we bless You, we adore You,\nwe glorify You, we give You thanks for Your great glory,\nLord God, heavenly King, O God, almighty Father.",
          "Lord Jesus Christ, Only Begotten Son,\nLord God, Lamb of God, Son of the Father,\nYou take away the sins of the world, have mercy on us;\nYou take away the sins of the world, receive our prayer;\nYou are seated at the right hand of the Father, have mercy on us.",
          "For You alone are the Holy One, You alone are the Lord,\nYou alone are the Most High, Jesus Christ,\nwith the Holy Spirit, in the glory of God the Father. Amen.",
        ],
      ),
      500: Hymn(
        id: 500,
        number: "500",
        title: "Amazing Grace! How Sweet the Sound",
        category: "Praise & Worship",
        keySignature: "G Major",
        tune: "New Britain",
        stanzas: [
          "1. Amazing grace! how sweet the sound\nThat saved a wretch like me!\nI once was lost, but now am found,\nWas blind, but now I see.",
          "2. 'Twas grace that taught my heart to fear,\nAnd grace my fears relieved;\nHow precious did that grace appear\nThe hour I first believed!",
          "3. Through many dangers, toils, and snares\nI have already come;\n'Twas grace hath brought me safe thus far,\nAnd grace will lead me home.",
        ],
      ),
      550: Hymn(
        id: 550,
        number: "550",
        title: "What a Friend We Have in Jesus",
        category: "Praise & Worship",
        keySignature: "F Major",
        tune: "Converse",
        stanzas: [
          "1. What a friend we have in Jesus, all our sins and griefs to bear!\nWhat a privilege to carry everything to God in prayer!\nO what peace we often forfeit, O what needless pain we bear,\nAll because we do not carry everything to God in prayer.",
          "2. Have we trials and temptations? Is there trouble anywhere?\nWe should never be discouraged; take it to the Lord in prayer.\nCan we find a friend so faithful who will all our sorrows share?\nJesus knows our every weakness; take it to the Lord in prayer.",
        ],
      ),
      600: Hymn(
        id: 600,
        number: "600",
        title: "Guide Me, O Thou Great Redeemer",
        category: "Entrance",
        keySignature: "G Major",
        tune: "Cwm Rhondda",
        stanzas: [
          "1. Guide me, O Thou great Redeemer, pilgrim through this barren land;\nI am weak, but Thou art mighty; hold me with Thy powerful hand:\nBread of heaven, Bread of heaven, feed me now and evermore.",
          "2. Open now the crystal fountain, whence the healing stream doth flow;\nLet the fiery cloudy pillar lead me all my journey through:\nStrong Deliverer, strong Deliverer, be Thou still my strength and shield.",
        ],
      ),
      700: Hymn(
        id: 700,
        number: "700",
        title: "Abide With Me, Fast Falls the Eventide",
        category: "Recessional",
        keySignature: "Eb Major",
        tune: "Eventide",
        stanzas: [
          "1. Abide with me: fast falls the eventide;\nThe darkness deepens; Lord, with me abide.\nWhen other helpers fail and comforts flee,\nHelp of the helpless, O abide with me.",
          "2. Swift to its close ebbs out life's little day;\nEarth's joys grow dim, its glories pass away;\nChange and decay in all around I see;\nO Thou Who changest not, abide with me.",
          "3. Hold Thou Thy cross before my closing eyes;\nShine through the gloom and point me to the skies.\nHeaven's morning breaks, and earth's vain shadows flee;\nIn life, in death, O Lord, abide with me.",
        ],
      ),
    };

    // Category distribution helper for auto-generating hymns 1..700
    final List<String> catCycle = [
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

    final List<String> keyCycle = [
      "C Major",
      "G Major",
      "F Major",
      "D Major",
      "Bb Major",
      "Eb Major",
      "A Minor",
      "E Minor",
    ];

    final List<String> sampleThemes = [
      "Rejoice in the Lord",
      "O Lord My God, How Great Thou Art",
      "Come Holy Ghost, Creator Blest",
      "Sing Praise to God Who Reigns Above",
      "Take My Life and Let It Be",
      "Crown Him With Many Crowns",
      "Lord of All Hopefulness",
      "Hail Redeemer, King Divine",
      "Christ Be Our Light",
      "Gift of Finest Wheat",
      "One Bread, One Body",
      "Gather Us In",
      "Sing to the Mountains",
      "Morning Has Broken",
      "The King of Love My Shepherd Is",
      "On This Day, O Beautiful Mother",
      "Maiden Mother, Meek and Mild",
      "Sing of Mary, Pure and Lowly",
      "Holy, Holy, Holy! Lord God Almighty",
      "Be Thou My Vision",
    ];

    for (int i = 1; i <= 700; i++) {
      if (curated.containsKey(i)) {
        hymns.add(curated[i]!);
      } else {
        String category = catCycle[i % catCycle.length];
        String keySig = keyCycle[i % keyCycle.length];
        String themeTitle = sampleThemes[(i - 1) % sampleThemes.length];
        String title = "Hymn #$i - $themeTitle";

        hymns.add(
          Hymn(
            id: i,
            number: "$i",
            title: title,
            category: category,
            keySignature: keySig,
            stanzas: [
              "1. Rejoice in the Lord, O ye righteous!\nCome into His presence with singing;\nFor the Lord is gracious and His mercy endures forever.\nLet all nations bring praise unto His Holy Name.",
              "2. In times of joy and trial, we lift our eyes to the hills,\nWhere our help comes from the Lord Who made heaven and earth.\nHe will not suffer thy foot to be moved;\nHe that keepeth thee will neither slumber nor sleep.",
              "3. Glory be to the Father, and to the Son, and to the Holy Spirit,\nAs it was in the beginning, is now, and ever shall be,\nWorld without end. Amen.",
            ],
            refrain: "Rejoice, rejoice! Give thanks and sing\nUnto Christ our Savior and King!",
          ),
        );
      }
    }

    return hymns;
  }
}
