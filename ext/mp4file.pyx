from mp4v2 cimport *
import StringIO, os
from datetime import datetime

MP4_DETAILS_NONE    = 0
MP4_DETAILS_ALL     = 0xFFFFFFFF
MP4_DETAILS_ERROR   = 0x00000001
MP4_DETAILS_WARNING = 0x00000002
MP4_DETAILS_READ    = 0x00000004
MP4_DETAILS_WRITE   = 0x00000008
MP4_DETAILS_FIND    = 0x00000010
MP4_DETAILS_TABLE   = 0x00000020
MP4_DETAILS_SAMPLE  = 0x00000040
MP4_DETAILS_HINT    = 0x00000080
MP4_DETAILS_ISMA    = 0x00000100
MP4_DETAILS_EDIT    = 0x00000200
          
cdef class MP4File:
    """
    MP4File provides a python interface to the mp4v2 library.
    """
    cdef char*             _filepath
    cdef MP4FileHandle     _handle
    cdef public   uint32_t verbosity
    cdef readonly char*    info
    cdef MP4Tags*          _tags
    cdef public object     artwork
    
    cdef object            _itmf_str_to_key
    cdef object            _itmf_key_to_str
    cdef object            _media_key_to_str
    cdef object            _media_str_to_key
    cdef object            country_code_str_to_key
    cdef object            country_code_key_to_str
    
    def __cinit__(self, filepath, uint32_t verbosity=0):
        if not os.path.exists(filepath):
            raise IOError("File Not Found")
            
        self._tags = NULL
        self._handle = NULL
        self.verbosity = verbosity
        
        
        self._filepath = filepath
        self._tags = MP4TagsAlloc()
        self._handle = MP4Modify(self._filepath, 0)
        self.info     = MP4Info(self._handle, MP4_INVALID_TRACK_ID)
        MP4TagsFetch(self._tags, self._handle)
        
    def __init__(self, filepath, uint32_t verbosity=0):
        # Initialize the artwork array
        cdef char* cdata
        cdef int size
        cdef int im_type
        
        self.artwork = []
        
        # Maps to tag values
        self._itmf_str_to_key = {
            "blues":                      1,
            "classic_rock":               2,
            "country":                    3,
            "dance":                      4,
            "disco":                      5,
            "funk":                       6,
            "grunge":                     7,
            "hip_hop":                    8,
            "jazz":                       9,
            "metal":                     10,
            "new_age":                   11,
            "oldies":                    12,
            "other":                     13,
            "pop":                       14,
            "r_and_b":                   15,
            "rap":                       16,
            "reggae":                    17,
            "rock":                      18,
            "techno":                    19,
            "industrial":                20,
            "alternative":               21,
            "ska":                       22,
            "death_metal":               23,
            "pranks":                    24,
            "soundtrack":                25,
            "euro_techno":               26,
            "ambient":                   27,
            "trip_hop":                  28,
            "vocal":                     29,
            "jazz_funk":                 30,
            "fusion":                    31,
            "trance":                    32,
            "classical":                 33,
            "instrumental":              34,
            "acid":                      35,
            "house":                     36,
            "game":                      37,
            "sound_clip":                38,
            "gospel":                    39,
            "noise":                     40,
            "alternrock":                41,
            "bass":                      42,
            "soul":                      43,
            "punk":                      44,
            "space":                     45,
            "meditative":                46,
            "instrumental_pop":          47,
            "instrumental_rock":         48,
            "ethnic":                    49,
            "gothic":                    50,
            "darkwave":                  51,
            "techno_industrial":         52,
            "electronic":                53,
            "pop_folk":                  54,
            "eurodance":                 55,
            "dream":                     56,
            "southern_rock":             57,
            "comedy":                    58,
            "cult":                      59,
            "gangsta":                   60,
            "top_40":                    61,
            "christian_rap":             62,
            "pop_funk":                  63,
            "jungle":                    64,
            "native_american":           65,
            "cabaret":                   66,
            "new_wave":                  67,
            "psychedelic":               68,
            "rave":                      69,
            "showtunes":                 70,
            "trailer":                   71,
            "lo_fi":                     72,
            "tribal":                    73,
            "acid_punk":                 74,
            "acid_jazz":                 75,
            "polka":                     76,
            "retro":                     77,
            "musical":                   78,
            "rock_and_roll":             79,
            "hard_rock":                 80,
            "folk":                      81,
            "folk_rock":                 82,
            "national_folk":             83,
            "swing":                     84,
            "fast_fusion":               85,
            "bebob":                     86,
            "latin":                     87,
            "revival":                   88,
            "celtic":                    89,
            "bluegrass":                 90,
            "avantgarde":                91,
            "gothic_rock":               92,
            "progressive_rock":          93,
            "psychedelic_rock":          94,
            "symphonic_rock":            95,
            "slow_rock":                 96,
            "big_band":                  97,
            "chorus":                    98,
            "easy_listening":            99,
            "acoustic":                 100,
            "humour":                   101,
            "speech":                   102,
            "chanson":                  103,
            "opera":                    104,
            "chamber_music":            105,
            "sonata":                   106,
            "symphony":                 107,
            "booty_bass":               108,
            "primus":                   109,
            "porn_groove":              110,
            "satire":                   111,
            "slow_jam":                 112,
            "club":                     113,
            "tango":                    114,
            "samba":                    115,
            "folklore":                 116,
            "ballad":                   117,
            "power_ballad":             118,
            "rhythmic_soul":            119,
            "freestyle":                120,
            "duet":                     121,
            "punk_rock":                122,
            "drum_solo":                123,
            "a_capella":                124,
            "euro_house":               125,
            "dance_hall":               126,
            "none":                     255,}
        self._itmf_key_to_str = {
              0:              "undefined",
              1:              "blues",                   
              2:              "classic_rock",            
              3:              "country",                 
              4:              "dance",                   
              5:              "disco",                   
              6:              "funk",                    
              7:              "grunge",                  
              8:              "hip_hop",                 
              9:              "jazz",                    
             10:              "metal",                   
             11:              "new_age",                 
             12:              "oldies",                  
             13:              "other",                   
             14:              "pop",                     
             15:              "r_and_b",                 
             16:              "rap",                     
             17:              "reggae",                  
             18:              "rock",                    
             19:              "techno",                  
             20:              "industrial",              
             21:              "alternative",             
             22:              "ska",                     
             23:              "death_metal",             
             24:              "pranks",                  
             25:              "soundtrack",              
             26:              "euro_techno",             
             27:              "ambient",                 
             28:              "trip_hop",                
             29:              "vocal",                   
             30:              "jazz_funk",               
             31:              "fusion",                  
             32:              "trance",                  
             33:              "classical",               
             34:              "instrumental",            
             35:              "acid",                    
             36:              "house",                   
             37:              "game",                    
             38:              "sound_clip",              
             39:              "gospel",                  
             40:              "noise",                   
             41:              "alternrock",              
             42:              "bass",                    
             43:              "soul",                    
             44:              "punk",                    
             45:              "space",                   
             46:              "meditative",              
             47:              "instrumental_pop",        
             48:              "instrumental_rock",       
             49:              "ethnic",                  
             50:              "gothic",                  
             51:              "darkwave",                
             52:              "techno_industrial",       
             53:              "electronic",              
             54:              "pop_folk",                
             55:              "eurodance",               
             56:              "dream",                   
             57:              "southern_rock",           
             58:              "comedy",                  
             59:              "cult",                    
             60:              "gangsta",                 
             61:              "top_40",                  
             62:              "christian_rap",           
             63:              "pop_funk",                
             64:              "jungle",                  
             65:              "native_american",         
             66:              "cabaret",                 
             67:              "new_wave",                
             68:              "psychedelic",             
             69:              "rave",                    
             70:              "showtunes",               
             71:              "trailer",                 
             72:              "lo_fi",                   
             73:              "tribal",                  
             74:              "acid_punk",               
             75:              "acid_jazz",               
             76:              "polka",                   
             77:              "retro",                   
             78:              "musical",                 
             79:              "rock_and_roll",           
             80:              "hard_rock",               
             81:              "folk",                    
             82:              "folk_rock",               
             83:              "national_folk",           
             84:              "swing",                   
             85:              "fast_fusion",             
             86:              "bebob",                   
             87:              "latin",                   
             88:              "revival",                 
             89:              "celtic",                  
             90:              "bluegrass",               
             91:              "avantgarde",              
             92:              "gothic_rock",             
             93:              "progressive_rock",        
             94:              "psychedelic_rock",        
             95:              "symphonic_rock",          
             96:              "slow_rock",               
             97:              "big_band",                
             98:              "chorus",                  
             99:              "easy_listening",          
            100:              "acoustic",                
            101:              "humour",                  
            102:              "speech",                  
            103:              "chanson",                 
            104:              "opera",                   
            105:              "chamber_music",           
            106:              "sonata",                  
            107:              "symphony",                
            108:              "booty_bass",              
            109:              "primus",                  
            110:              "porn_groove",             
            111:              "satire",                  
            112:              "slow_jam",                
            113:              "club",                    
            114:              "tango",                   
            115:              "samba",                   
            116:              "folklore",                
            117:              "ballad",                  
            118:              "power_ballad",            
            119:              "rhythmic_soul",           
            120:              "freestyle",               
            121:              "duet",                    
            122:              "punk_rock",               
            123:              "drum_solo",               
            124:              "a_capella",               
            125:              "euro_house",              
            126:              "dance_hall",              
            255:              "none",                    
        }
        self._media_key_to_str = {
            0: 'Movie', # now deprecated, should use 9
            1: 'Music',
            2: 'Audiobook',
            6: 'Music Video',
            9: 'Movie',
            10: 'TV Show',
            11: 'Booklet',
            14: 'Ringtone'
        }
        self._media_str_to_key = {
            "music": 1,
            "audiobook": 2,
            "musicvideo": 6,
            "movie": 9,
            "tvshow": 10,
            "booklet": 11,
            "ringtone": 14,
        }
        self.country_code_str_to_key = {
        "Australia"         : 143460,
        "Austria"           : 143445,
        "Belgium"           : 143446,
        "Canada"            : 143455,
        "Denmark"           : 143458,
        "Finland"           : 143447,
        "France"            : 143442,
        "Germany"           : 143443,
        "Greece"            : 143448,
        "Ireland"           : 143449,
        "Italy"             : 143450,
        "Japan"             : 143462,
        "Luxembourg"        : 143451,
        "Netherlands"       : 143452,
        "New Zealand"       : 143461,
        "Norway"            : 143457,
        "Portugal"          : 143453,
        "Spain"             : 143454,
        "Sweden"            : 143456,
        "Switzerland"       : 143459,
        "United Kingdom"    : 143444,
        "United States"     : 143441,
        }
        
        self.country_code_key_to_str = {
         143460   : "australia"     ,
         143445   : "austria"       ,
         143446   : "belgium"       ,           
         143455   : "canada"        ,           
         143458   : "denmark"       ,           
         143447   : "finland"       ,           
         143442   : "france"        ,           
         143443   : "germany"       ,           
         143448   : "greece"        ,           
         143449   : "ireland"       ,           
         143450   : "italy"         ,           
         143462   : "japan"         ,           
         143451   : "luxembourg"    ,           
         143452   : "netherlands"   ,           
         143461   : "newzealand"   ,           
         143457   : "norway"        ,           
         143453   : "portugal"      ,           
         143454   : "spain"         ,           
         143456   : "sweden"        ,           
         143459   : "switzerland"   ,           
         143444   : "unitedkingdom",           
         143441   : "unitedstates" ,           
         }                      
        
        if self._tags.artwork != NULL:
            for i in range(self.artworkCount):
                cdata = <char*>self._tags.artwork[i].data
                size = self._tags.artwork[i].size
                im_type = self._tags.artwork[i].type
                #im = Image.open(StringIO.StringIO(cdata[:size]))
                #self.artwork.append(im)
    
    def __dealloc__(self):
        if self._tags is not NULL:
            MP4TagsStore(self._tags, self._handle)
            MP4TagsFree(self._tags)
        if self._handle is not NULL:
            MP4Close(self._handle)
            
        # MP4Optimize(self._filepath, NULL, self.verbosity)
    
    def save(self):
        if self._tags is not NULL:
            MP4TagsStore(self._tags, self._handle)
            
    def has_atom(self, char* atomName):
        return MP4HaveAtom(self._handle, atomName)
        
    property name: 
        
        def __get__(self):
            attribute = None
            
            if self._tags.name != NULL:
                attribute = self._tags.name
            return attribute
            
        def __set__(self, char* value):
            MP4TagsSetName(self._tags, value)
        
    property artist: 
        
        def __get__(self):
            attribute = None
            if self._tags.artist != NULL:
                attribute = self._tags.artist
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetArtist(self._tags, value)
            
    property albumArtist: 
        
        def __get__(self):
            attribute = None
            if self._tags.albumArtist != NULL:
                attribute = self._tags.albumArtist
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetAlbumArtist(self._tags, value)
    
    property album: 
        
        def __get__(self):
            attribute = None
            if self._tags.album != NULL:
                attribute = self._tags.album
                
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetAlbum(self._tags, value)
    
    property grouping: 
        
        def __get__(self):
            attributre = None
            if self._tags.grouping != NULL:
                attribute = self._tags.grouping
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetGrouping(self._tags, value)
    
    property composer: 
        
        def __get__(self):
            attribute = None
            if self._tags.composer != NULL:
                attribute = self._tags.composer
                
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetComposer(self._tags, value)
    
    property comments: 
        
        def __get__(self):
            attribute = None
            if self._tags.comments != NULL:
                attribute = self._tags.comments
                
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetComments(self._tags, value)
    
    property genre: 
        
        def __get__(self):
            if self._tags.genre != NULL:
                attribute = self._tags.genre
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetGenre(self._tags, value)
            
    
    property genreType: 
        
        def __get__(self):
            genre_key = 0 # default is undefined
            
            if self._tags.genreType != NULL:
                genre_key = PyInt_FromLong(self._tags.genreType[0])
            return self._itmf_key_to_str[genre_key]
            
        def __set__(self, object value):
            cdef uint16_t code
            
            try:
                code = self._itmf_str_to_key[value]
            except KeyError:
                # undefined genre type
                code = 0
            MP4TagsSetGenreType(self._tags, &code)
            
    property releaseDate: 
        
        def __get__(self):
            date = None
            if self._tags.releaseDate != NULL:
                date = datetime.strptime(self._tags.releaseDate, "%Y-%m-%dT%H:%M:%SZ")
            
            return date
        
        def __set__(self, object date):
            cdef char* str_date
            str_date[0] = date.strftime("%Y-%m-%d")
            MP4TagsSetReleaseDate(self._tags, str_date)
            
    property track: 
        
        def __get__(self):
            index = None
            total = None
            if self._tags.track != NULL:
                index = self._tags.track.index
                total = self._tags.track.total
                
            return (index, total)
        
        def __set__(self, value):
            cdef MP4TagTrack dtrack
            
            dtrack.index, dtrack.total = value
            
            MP4TagsSetTrack(self._tags, &dtrack)
            
            
    property disk: 
          
          def __get__(self):
              index = None
              total = None
              if self._tags.disk != NULL:
                  index = self._tags.disk.index
                  total = self._tags.disk.total
            
              return (index,total)   
                 
          def __set__(self, value):
              cdef MP4TagDisk ddisk
              
              ddisk.index, ddisk.total = value
              
              MP4TagsSetDisk(self._tags, &ddisk)
    
    property tempo: 
        
        def __get__(self):
            attribute = None
            if self._tags.tempo != NULL:
                attribute = PyInt_FromLong(self._tags.tempo[0])                  
            return attribute
        
        def __set__(self, uint16_t value):
            MP4TagsSetTempo(self._tags, &value)
            
        
    property compilation: 
        
        def __get__(self):
            attribute = None
            if self._tags.compilation != NULL:
                attribute = PyInt_FromLong(self._tags.compilation[0])
            return attribute
        
        def __set__(self, value):
            cdef uint8_t comp
            comp = 0 # not compilation
            if value:
                comp = 1 # compilation
            MP4TagsSetCompilation(self._tags, &comp)
            
    
    property tvShow: 
        
        def __get__(self):
            attribute = self._tags.tvShow
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetTVShow(self._tags, value)
            
    
    property tvNetwork: 
        
        def __get__(self):
            attribute = None
            if self._tags.tvNetwork != NULL:
                attribute = self._tags.tvNetwork
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetTVNetwork(self._tags, value)
    
    property tvEpisodeID: 
        
        def __get__(self):
            attribute = None
            if self._tags.tvEpisodeID != NULL:
                attribute = self._tags.tvEpisodeID
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetTVEpisodeID(self._tags, value)
    
    property tvSeason: 
        
        def __get__(self):
            attribute = None
            if self._tags.tvSeason != NULL:
                attribute = PyInt_FromLong(self._tags.tvSeason[0])
            return attribute
        
        def __set__(self, uint32_t value):
            MP4TagsSetTVSeason(self._tags, &value)
    
    property tvEpisode: 
        
        def __get__(self):
            attribute = None
            if self._tags.tvEpisode != NULL:
                attribute = PyInt_FromLong(self._tags.tvEpisode[0])
            return attribute
        
        def __set__(self, uint32_t value):
            MP4TagsSetTVEpisode(self._tags, &value)
    
    property description: 
        
        def __get__(self):
            attribute = None
            if self._tags.description != NULL:
                attribute = self._tags.description
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetDescription(self._tags, value)
            
    property longDescription: 
        
        def __get__(self):
            attribute = None
            if self._tags.longDescription != NULL:
                attribute = self._tags.longDescription
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetLongDescription(self._tags, value)
            
    property lyrics: 
        
        def __get__(self):
            attribute = None
            if self._tags.lyrics != NULL:
                attribute = self._tags.lyrics
            return attribute        
        
        def __set__(self, char* value):
            MP4TagsSetLyrics(self._tags, value)
            
    property sortName: 
        
        def __get__(self):
            attribute = None
            if self._tags.sortName != NULL:
                attribute = self._tags.sortName
            return attribute        
        
        def __set__(self, char* value):
            MP4TagsSetSortName(self._tags, value)
    
    property sortArtist: 
        
        def __get__(self):
            attribute = None
            if self._tags.sortArtist != NULL:
                attribute = self._tags.sortArtist
            return attribute        
        
        def __set__(self, char* value):
            MP4TagsSetSortArtist(self._tags, value)
            
            
    property sortAlbumArtist: 
        
        def __get__(self):
            
            attribute = None
            if self._tags.sortAlbumArtist != NULL:
                attribute = self._tags.sortAlbumArtist
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetSortAlbumArtist(self._tags, value)
    
    property sortAlbum: 
        
        def __get__(self):
            attribute = None
            if self._tags.sortAlbum != NULL:
                attribute = self._tags.sortAlbum
            return attribute        
            
        def __set__(self, char* value):
            MP4TagsSetSortAlbum(self._tags, value)
    
    property sortComposer: 
        
        def __get__(self):
            attribute = None
            if self._tags.sortComposer != NULL:
                attribute = self._tags.sortComposer
            return attribute        
        
        def __set__(self, char* value):
            MP4TagsSetSortComposer(self._tags, value)
            
    property sortTVShow: 
        
        def __get__(self):
            attribute = None
            if self._tags.sortTVShow != NULL:
                attribute = self._tags.sortTVShow
            return attribute        
        
        def __set__(self, char* value):
            MP4TagsSetSortTVShow(self._tags, value)
            
    property artworkCount: 
        
        def __get__(self):
            count = self._tags.artworkCount
            return count
    
    property copyright: 
        
        def __get__(self):
            attribute = None        
            if self._tags.copyright != NULL:
                attribute = self._tags.copyright
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetCopyright(self._tags, value)
    
    property encodingTool: 
        
        def __get__(self):
            attribute = None        
            if self._tags.encodingTool != NULL:
                attribute = self._tags.encodingTool
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetEncodingTool(self._tags, value)
                
    property encodedBy: 
        
        def __get__(self):
            attribute = None        
            if self._tags.encodedBy != NULL:
                attribute = self._tags.encodedBy
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetEncodedBy(self._tags, value)
            
    property purchaseDate: 
        def __get__(self):
            date = None
            if self._tags.purchaseDate != NULL:
                date = datetime.strptime(self._tags.purchaseDate, "%Y-%m-%d")
            
            return date
        
        def __set__(self, date):
            cdef char* str_date
            str_date[0] = date.strftime("%Y-%m-%d")
            MP4TagsSetPurchaseDate(self._tags, str_date)
        
    property podcast: 
        def __get__(self):
            attribute = None        
            if self._tags.podcast != NULL:
                attribute = PyInt_FromLong(self._tags.podcast[0])
            return attribute
        
        def __set__(self, value):
            cdef uint8_t is_podcast
            is_podcast = 0 # false by default
            if value:
                is_podcast = 1 # true
                
            MP4TagsSetPodcast(self._tags, &is_podcast)
                
                
    property keywords: 
        
        def __get__(self):
            attribute = None        
            if self._tags.keywords != NULL:
                attribute = self._tags.keywords
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetKeywords(self._tags, value)
    
    property category: 
        
        def __get__(self):
            attribute = None        
            if self._tags.category != NULL:
                attribute = self._tags.category
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetCategory(self._tags, value)
            
    property hdVideo: 
        
        def __get__(self):
            attribute = None        
            if self._tags.hdVideo != NULL:
                attribute = PyInt_FromLong(self._tags.hdVideo[0])
            return attribute
        
        def __set__(self, value):
            cdef uint8_t is_hd
            is_podcast = 0 # false by default
            if value:
                is_hd = 1 # true
                
            MP4TagsSetHDVideo(self._tags, &is_hd)
            
    property mediaType: 
        
        def __get__(self):
            if self._tags.mediaType != NULL:
                code = PyInt_FromLong(self._tags.mediaType[0])
                
            attribute = self._media_key_to_str.get(code, "Unknown")

            return attribute
        
        def __set__(self, value):
            cdef uint8_t key
            st = value.replace(" ", "").lower()
            key = self._media_str_to_key.get(st, 9)
            
            MP4TagsSetMediaType(self._tags, &key)
            
    property contentRating: 
        
        def __get__(self):
            attribute = None        
            if self._tags.contentRating != NULL:
                attribute = PyInt_FromLong(self._tags.contentRating[0])
            return attribute
        
        def __set__(self, value):
            pass
    
    property gapless: 
        
        def __get__(self):
            attribute = None        
            if self._tags.gapless != NULL:
                attribute = PyInt_FromLong(self._tags.gapless[0])
            return attribute
        
        #
        def __set__(self, value):
            cdef uint8_t is_gapless
            is_podcast = 0 # false by default
            if value:
                is_gapless = 1 # true
                
            MP4TagsSetGapless(self._tags, &is_gapless)
    
    
    property iTunesAccount: 
        
        def __get__(self):
            attribute = None        
            if self._tags.iTunesAccount != NULL:
                attribute = self._tags.iTunesAccount
            return attribute
        
        def __set__(self, char* value):
            MP4TagsSetITunesAccount(self._tags, value)
        
    property iTunesAccountType: 
        
        def __get__(self):
            account_type = None        
            if self._tags.iTunesAccountType != NULL:
                account_type_code = \
                        PyInt_FromLong(self._tags.iTunesAccountType[0])
                if account_type_code == 0:
                    account_type = "iTunes"
                elif account_type_code == 1:
                    account_type = "AOL"

            return account_type
        
        #
        def __set__(self, value):
            cdef uint8_t code
            acct_str = value.lower()
            acct_map = {
                "itunes": 0,
                "aol": 1,
            }
            try:
                code = acct_map[acct_str]
            except KeyError:
                raise Exception("Invalid account type!")
                
            MP4TagsSetITunesAccountType(self._tags, &code)
    
    property iTunesCountry: 
        
        def __get__(self):
            country = None
            if self._tags.iTunesCountry != NULL:
                code = PyInt_FromLong(self._tags.iTunesCountry[0])
                country = self._country_code_key_to_str.get(code, "Unknown")
                                
            return country
        
        def __set__(self, value):
            cdef uint32_t code
            country = value.replace(" ", "").lower()
            
            try:
                code = self._country_code_str_to_key[country]
            except KeyError:
                raise Exception("Unknown Country!")
            
            MP4TagsSetITunesCountry(self._tags, &code)
