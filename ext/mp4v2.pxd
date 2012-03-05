cdef extern from "Python.h":
    object PyInt_FromLong(long ival)

cdef extern from "stdint.h":
    ctypedef int uint16_t
    ctypedef int uint32_t
    ctypedef int uint64_t
    ctypedef int uint8_t
    
cdef extern from "stdio.h":
    ctypedef struct FILE:
        pass
      
cdef extern from "mp4v2/mp4v2.h":
    # Classes
    ctypedef struct MP4Tags_s
    ctypedef struct MP4TagDisk_s
    
    cdef enum MP4TagArtworkType_e:
        MP4_ART_UNDEFINED = 0
        MP4_ART_BMP = 1
        MP4_ART_GIF = 2
        MP4_ART_JPEG = 3
        MP4_ART_PNG = 4
    #                            
    ctypedef struct              MP4Chapter_s
    ctypedef struct              MP4FileProvider_s
    ctypedef struct              MP4TagArtwork_s
    ctypedef struct              MP4TagTrack_s
    
    ctypedef MP4TagArtworkType_e MP4TagArtworkType
    ctypedef MP4TagArtwork_s     MP4TagArtwork
    ctypedef MP4TagTrack_s       MP4TagTrack
    ctypedef MP4TagDisk_s        MP4TagDisk
    ctypedef MP4Tags_s           MP4Tags
    
    ctypedef struct              MP4TagTrack_s:
        uint16_t index
        uint16_t total
    
    ctypedef struct              MP4TagDisk_s:
        uint16_t index
        uint16_t total
    
    ctypedef struct             MP4TagArtwork_s:
        void*             data
        uint32_t          size
        MP4TagArtworkType type
        
    ctypedef struct MP4Tags_s:
        char * 	        name
        char * 	        artist
        char * 	        albumArtist
        char * 	        album
        char * 	        grouping
        char * 	        composer
        char * 	        comments
        char * 	        genre
        uint16_t * 	    genreType
        char * 	        releaseDate
        MP4TagTrack *   track
        MP4TagDisk *    disk
        uint16_t * 	    tempo
        uint8_t * 	    compilation
        char * 	        tvShow
        char * 	        tvNetwork
        char * 	        tvEpisodeID
        uint32_t * 	    tvSeason
        uint32_t * 	    tvEpisode
        char * 	        description
        char * 	        longDescription
        char * 	        lyrics
        char * 	        sortName
        char * 	        sortArtist
        char * 	        sortAlbumArtist
        char * 	        sortAlbum
        char * 	        sortComposer
        char * 	        sortTVShow
        MP4TagArtwork * artwork
        uint32_t 	    artworkCount
        char * 	        copyright
        char * 	        encodingTool
        char * 	        encodedBy
        char * 	        purchaseDate
        uint8_t *   	podcast
        char * 	        keywords
        char * 	        category
        uint8_t * 	    hdVideo
        uint8_t * 	    mediaType
        uint8_t * 	    contentRating
        uint8_t * 	    gapless
        char * 	        iTunesAccount
        uint8_t * 	    iTunesAccountType
        uint32_t * 	    iTunesCountry

    
    # Defines
    int   MP4V2_CHAPTER_TITLE_MAX
    int   MP4_INVALID_TRACK_ID
    char* MP4_OD_TRACK_TYPE      
    char* MP4_SCENE_TRACK_TYPE   
    char* MP4_AUDIO_TRACK_TYPE   
    char* MP4_VIDEO_TRACK_TYPE   
    char* MP4_HINT_TRACK_TYPE    
    char* MP4_CNTL_TRACK_TYPE    
    char* MP4_TEXT_TRACK_TYPE    
    char* MP4_SUBTITLE_TRACK_TYPE
    
    
   
    # Enumerations
    cdef enum MP4ChapterType:
        MP4ChapterTypeNone  = 0
        MP4ChapterTypeAny   = 1 
        MP4ChapterTypeQt    = 2 
        MP4ChapterTypeNero  = 4
        
    cdef enum MP4_CREATE_EXTENSIBLE_FORMAT:
         FILEMODE_UNDEFINED
         FILEMODE_READ 
         FILEMODE_MODIFY
         FILEMODE_CREATE
    
    cdef enum MP4FileMode_e:
        FILEMODE_UNDEFINED
        FILEMODE_READ
        FILEMODE_MODIFY
        FILEMODE_CREATE
        
        
    # Typedefs
    ctypedef MP4Chapter_s MP4Chapter_t
    ctypedef void*               MP4FileHandle
    ctypedef int                 MP4TrackId
    ctypedef int                 MP4SampleId
    ctypedef int                 MP4Timestamp
    ctypedef int                 MP4Duration
    ctypedef int                 MP4EditId
    ctypedef int                 MP4TrackId
    ctypedef MP4FileMode_e       MP4FileMode
    ctypedef MP4FileProvider_s   MP4FileProvider

    
    

        
    # Functions
    void 	        MP4AddChapter (MP4FileHandle hFile, 
                                   MP4TrackId chapterTrackId, 
                                   MP4Duration chapterDuration, 
                                   char *chapterTitle)
    
    MP4TrackId 	    MP4AddChapterTextTrack (MP4FileHandle hFile, 
                                            MP4TrackId refTrackId, 
                                            uint32_t timescale)
    
    void 	        MP4AddNeroChapter (MP4FileHandle hFile, 
                                       MP4Timestamp chapterStart, 
                                       char *chapterTitle)
    
    MP4ChapterType 	MP4ConvertChapters (MP4FileHandle hFile, 
                                        MP4ChapterType toChapterType)
    
    MP4ChapterType 	MP4DeleteChapters (MP4FileHandle hFile, 
                                       MP4ChapterType chapterType, 
                                       MP4TrackId chapterTrackId)
    
    MP4ChapterType 	MP4GetChapters (MP4FileHandle hFile, 
                                    MP4Chapter_t **chapterList, 
                                    uint32_t *chapterCount, 
                                    MP4ChapterType chapterType)
    
    MP4ChapterType 	MP4SetChapters (MP4FileHandle hFile, 
                                    MP4Chapter_t *chapterList, 
                                    uint32_t chapterCount, 
                                    MP4ChapterType chapterType)
    uint32_t 	    MP4GetVerbosity (MP4FileHandle hFile)
    void 	        MP4SetVerbosity (MP4FileHandle hFile, uint32_t verbosity)
    void 	        MP4Close (MP4FileHandle hFile)
    MP4FileHandle 	MP4Create (char *fileName, uint32_t verbosity, 
                               uint32_t flags)
    MP4FileHandle 	MP4CreateEx (char *fileName, uint32_t verbosity,          
                                 uint32_t flags, int add_ftyp, int add_iods, 
                                 char *majorBrand, uint32_t minorVersion, 
                                 char **compatibleBrands, 
                                 uint32_t compatibleBrandsCount)
    bint 	        MP4Dump (MP4FileHandle hFile, FILE *pDumpFile, 
                             bint dumpImplicits)
    char * 	        MP4FileInfo (char *fileName, MP4TrackId trackId)
    char * 	        MP4Info (MP4FileHandle hFile, MP4TrackId trackId)
    MP4FileHandle 	MP4Modify (char *fileName, uint32_t flags)
    bint 	        MP4Optimize (char *fileName, char *newFileName, 
                                 uint32_t verbosity)
    MP4FileHandle 	MP4Read (char *fileName, uint32_t verbosity)
    MP4FileHandle 	MP4ReadProvider (char *fileName, uint32_t verbosity, 
                                     MP4FileProvider *fileProvider)
    
    uint32_t        MP4GetNumberOfTracks(MP4FileHandle hFile, char* type,
                                         uint8_t subType)
    bint 	        MP4HaveAtom (MP4FileHandle hFile, char *atomName)
    bint 	        MP4GetIntegerProperty (MP4FileHandle hFile, 
                                           char *propName, uint64_t *retval)
    bint 	        MP4GetFloatProperty (MP4FileHandle hFile, char *propName, 
                                         float *retvalue)
    bint 	        MP4GetStringProperty (MP4FileHandle hFile, char *propName, 
                                          char **retvalue)
    bint 	        MP4GetBytesProperty (MP4FileHandle hFile, char *propName, 
                                         uint8_t **ppValue, 
                                         uint32_t *pValueSize)
    bint 	        MP4SetIntegerProperty (MP4FileHandle hFile, 
                                           char *propName, 
                                           uint64_t value)
    bint 	        MP4SetFloatProperty (MP4FileHandle hFile, char *propName, 
                                         float value)
    bint 	        MP4SetStringProperty (MP4FileHandle hFile, char *propName, 
                                          char *value)
    bint 	        MP4SetBytesProperty (MP4FileHandle hFile, char *propName, 
                                         uint8_t *pValue, uint32_t valueSize)
    MP4Duration 	MP4GetDuration (MP4FileHandle hFile)
    uint32_t        MP4GetTimeScale (MP4FileHandle hFile)
    bint 	        MP4SetTimeScale (MP4FileHandle hFile, uint32_t value)
    void 	        MP4ChangeMovieTimeScale (MP4FileHandle hFile, 
                                             uint32_t value)
    uint8_t         MP4GetODProfileLevel (MP4FileHandle hFile)
    bint 	        MP4SetODProfileLevel (MP4FileHandle hFile, uint8_t value)
    uint8_t         MP4GetSceneProfileLevel (MP4FileHandle hFile)
    bint 	        MP4SetSceneProfileLevel (MP4FileHandle hFile, 
                                             uint8_t value)
    uint8_t         MP4GetVideoProfileLevel (MP4FileHandle hFile, 
                                                 MP4TrackId trackId)
    void 	        MP4SetVideoProfileLevel (MP4FileHandle hFile, 
                                             uint8_t value)
    uint8_t         MP4GetAudioProfileLevel (MP4FileHandle hFile)
    void 	        MP4SetAudioProfileLevel (MP4FileHandle hFile, 
                                             uint8_t value)
    uint8_t         MP4GetGraphicsProfileLevel (MP4FileHandle hFile)
    bint 	        MP4SetGraphicsProfileLevel (MP4FileHandle hFile, 
                                                uint8_t value)
    MP4TrackId 	    MP4AddTrack (MP4FileHandle hFile, char *type)
    MP4TrackId 	    MP4AddSystemsTrack (MP4FileHandle hFile, char *type)
    MP4TrackId 	    MP4AddODTrack (MP4FileHandle hFile)
    MP4TrackId 	    MP4AddSceneTrack (MP4FileHandle hFile)
    MP4TrackId 	    MP4AddAudioTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                      MP4Duration sampleDuration, 
                                      uint8_t audioType)
    MP4TrackId 	MP4AddAC3AudioTrack (MP4FileHandle hFile, 
                                     uint32_t samplingRate, 
                                     uint8_t fscod, 
                                     uint8_t bsid, 
                                     uint8_t bsmod, 
                                     uint8_t acmod, 
                                     uint8_t lfeon, 
                                     uint8_t bit_rate_code)
    MP4TrackId 	MP4AddAmrAudioTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                     uint16_t modeSet, 
                                     uint8_t modeChangePeriod, 
                                     uint8_t framesPerSample, 
                                     bint isAmrWB)
    void 	MP4SetAmrVendor (MP4FileHandle hFile, MP4TrackId trackId, 
                             uint32_t vendor)
    void 	MP4SetAmrDecoderVersion (MP4FileHandle hFile, MP4TrackId trackId,   
                                     uint8_t decoderVersion)
    void 	MP4SetAmrModeSet (MP4FileHandle hFile, MP4TrackId trakId, 
                              uint16_t modeSet)
    uint16_t 	MP4GetAmrModeSet (MP4FileHandle hFile, MP4TrackId trackId)
    MP4TrackId 	MP4AddHrefTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                 MP4Duration sampleDuration, char *base_url)
    char * 	MP4GetHrefTrackBaseUrl (MP4FileHandle hFile, MP4TrackId trackId)
    MP4TrackId 	MP4AddVideoTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                  MP4Duration sampleDuration, uint16_t width, 
                                  uint16_t height, 
                                  uint8_t videoType)
    MP4TrackId 	MP4AddH264VideoTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                      MP4Duration sampleDuration, 
                                      uint16_t width, uint16_t height, 
                                      uint8_t AVCProfileIndication, 
                                      uint8_t profile_compat, 
                                      uint8_t AVCLevelIndication, 
                                      uint8_t sampleLenFieldSizeMinusOne)
    void 	MP4AddH264SequenceParameterSet (MP4FileHandle hFile, 
                                            MP4TrackId trackId, 
                                            uint8_t *pSequence, 
                                            uint16_t sequenceLen)
    void 	MP4AddH264PictureParameterSet (MP4FileHandle hFile, 
                                           MP4TrackId trackId, 
                                           uint8_t *pPict, uint16_t pictLen)
    void 	MP4SetH263Vendor (MP4FileHandle hFile, MP4TrackId trackId, 
                              uint32_t vendor)
    void 	MP4SetH263DecoderVersion (MP4FileHandle hFile, MP4TrackId trackId, 
                                      uint8_t decoderVersion)
    void 	MP4SetH263Bitrates (MP4FileHandle hFile, MP4TrackId trackId, 
                                uint32_t avgBitrate, uint32_t maxBitrate)
    MP4TrackId 	MP4AddH263VideoTrack (MP4FileHandle hFile, uint32_t timeScale, 
                                      MP4Duration sampleDuration, 
                                      uint16_t width, uint16_t height, 
                                      uint8_t h263Level, uint8_t h263Profile, 
                                      uint32_t avgBitrate, 
                                      uint32_t maxBitrate)
    MP4TrackId 	MP4AddHintTrack (MP4FileHandle hFile, MP4TrackId refTrackId)
    MP4TrackId 	MP4AddTextTrack (MP4FileHandle hFile, MP4TrackId refTrackId)
    MP4TrackId 	MP4AddSubtitleTrack (MP4FileHandle hFile, uint32_t timescale, 
                                     uint16_t width, uint16_t height)
    MP4TrackId 	MP4AddPixelAspectRatio (MP4FileHandle hFile, 
                                        MP4TrackId refTrackId, 
                                        uint32_t hSpacing, 
                                        uint32_t vSpacing)
    MP4TrackId 	MP4AddColr (MP4FileHandle hFile, MP4TrackId refTrackId,     
                            uint16_t primary, uint16_t transfer, 
                            uint16_t matrix)
    MP4TrackId 	MP4CloneTrack (MP4FileHandle srcFile, MP4TrackId srcTrackId, 
                               MP4FileHandle dstFile, 
                               MP4TrackId dstHintTrackReferenceTrack)
    MP4TrackId 	MP4CopyTrack (MP4FileHandle srcFile, MP4TrackId srcTrackId, 
                              MP4FileHandle dstFile, bint applyEdits, 
                              MP4TrackId dstHintTrackReferenceTrack)
    void 	    MP4DeleteTrack (MP4FileHandle hFile, MP4TrackId trackId)
    uint32_t 	MP4GetNumberOfTracks (MP4FileHandle hFile, char *type, 
                                      uint8_t subType)
    MP4TrackId 	MP4FindTrackId (MP4FileHandle hFile, uint16_t index, 
                                char *type, uint8_t subType)
    uint16_t 	MP4FindTrackIndex (MP4FileHandle hFile, MP4TrackId trackId)
    bint 	    MP4GetTrackDurationPerChunk (MP4FileHandle hFile, 
                                             MP4TrackId trackId, 
                                             MP4Duration *duration)
    bint 	    MP4SetTrackDurationPerChunk (MP4FileHandle hFile, 
                                             MP4TrackId trackId, 
                                             MP4Duration duration)
    void 	    MP4AddIPodUUID (MP4FileHandle hFile, MP4TrackId trackId)
                
    bint 	    MP4HaveTrackAtom (MP4FileHandle hFile, MP4TrackId trackId, 
                                  char *atomname)
    char * 	    MP4GetTrackType (MP4FileHandle hFile, MP4TrackId trackId)
    char * 	    MP4GetTrackMediaDataName (MP4FileHandle hFile, MP4TrackId trackId)
    bint 	    MP4GetTrackMediaDataOriginalFormat (MP4FileHandle hFile, MP4TrackId trackId, char *originalFormat, uint32_t buflen)
    MP4Duration MP4GetTrackDuration (MP4FileHandle hFile, MP4TrackId trackId)
    uint32_t 	MP4GetTrackTimeScale (MP4FileHandle hFile, MP4TrackId trackId)
    void 	    MP4SetTrackTimeScale (MP4FileHandle hFile, MP4TrackId trackId,  
                                      uint32_t value)
    bint 	    MP4GetTrackLanguage (MP4FileHandle hFile, MP4TrackId trackId, char *code)
    bint    	MP4SetTrackLanguage (MP4FileHandle hFile, MP4TrackId trackId, 
                                     char *code)
    bint 	    MP4GetTrackName (MP4FileHandle hFile, MP4TrackId trackId, 
                                 char **name)
    bint     	MP4SetTrackName (MP4FileHandle hFile, MP4TrackId trackId, 
                             char *name)
    uint8_t 	MP4GetTrackAudioMpeg4Type (MP4FileHandle hFile, 
                                           MP4TrackId trackId)
    uint8_t 	MP4GetTrackEsdsObjectTypeId (MP4FileHandle hFile, 
                                             MP4TrackId trackId)
    MP4Duration MP4GetTrackFixedSampleDuration (MP4FileHandle hFile, 
                                                MP4TrackId trackId)
    uint32_t 	MP4GetTrackBitRate (MP4FileHandle hFile, MP4TrackId trackId)
    bint 	    MP4GetTrackVideoMetadata (MP4FileHandle hFile, 
                                          MP4TrackId trackId, 
                                          uint8_t **ppConfig, 
                                          uint32_t *pConfigSize)
    bint 	    MP4GetTrackESConfiguration (MP4FileHandle hFile, 
                                            MP4TrackId trackId, 
                                            uint8_t **ppConfig, 
                                            uint32_t *pConfigSize)
    bint 	    MP4SetTrackESConfiguration (MP4FileHandle hFile, 
                                            MP4TrackId trackId, 
                                            uint8_t *pConfig, 
                                            uint32_t configSize)
    bint 	    MP4GetTrackH264ProfileLevel (MP4FileHandle hFile, 
                                             MP4TrackId trackId, 
                                             uint8_t *pProfile, 
                                             uint8_t *pLevel)
    void 	    MP4GetTrackH264SeqPictHeaders (MP4FileHandle hFile, 
                                               MP4TrackId trackId, 
                                               uint8_t ***pSeqHeaders, 
                                               uint32_t **pSeqHeaderSize, 
                                               uint8_t ***pPictHeader, 
                                               uint32_t **pPictHeaderSize)
    bint 	    MP4GetTrackH264LengthSize (MP4FileHandle hFile, 
                                           MP4TrackId trackId, 
                                           uint32_t *pLength)
    MP4SampleId MP4GetTrackNumberOfSamples (MP4FileHandle hFile, 
                                            MP4TrackId trackId)
    uint16_t 	MP4GetTrackVideoWidth (MP4FileHandle hFile, 
                                       MP4TrackId trackId)
    uint16_t 	MP4GetTrackVideoHeight (MP4FileHandle hFile, 
                                        MP4TrackId trackId)
    double 	    MP4GetTrackVideoFrameRate (MP4FileHandle hFile, 
                                           MP4TrackId trackId)
    int 	    MP4GetTrackAudioChannels (MP4FileHandle hFile, 
                                          MP4TrackId trackId)
    bint 	    MP4IsIsmaCrypMediaTrack (MP4FileHandle hFile, 
                                         MP4TrackId trackId)
    bint 	    MP4GetTrackIntegerProperty (MP4FileHandle hFile, 
                                            MP4TrackId trackId, 
                                            char *propName, 
                                            uint64_t *retvalue)
    bint 	    MP4GetTrackFloatProperty (MP4FileHandle hFile, 
                                          MP4TrackId trackId, 
                                          char *propName, 
                                          float *ret_value)
    bint 	    MP4GetTrackStringProperty (MP4FileHandle hFile, 
                                           MP4TrackId trackId, 
                                           char *propName, 
                                           char **retvalue)
    bint 	    MP4GetTrackBytesProperty (MP4FileHandle hFile, 
                                          MP4TrackId trackId, 
                                          char *propName, 
                                          uint8_t **ppValue, 
                                          uint32_t *pValueSize)
    bint 	    MP4SetTrackIntegerProperty (MP4FileHandle hFile, 
                                            MP4TrackId trackId, 
                                            char *propName, uint64_t value)
    bint 	    MP4SetTrackFloatProperty (MP4FileHandle hFile, 
                                          MP4TrackId trackId, char *propName, 
                                          float value)
    bint 	    MP4SetTrackStringProperty (MP4FileHandle hFile, 
                                           MP4TrackId trackId, 
                                           char *propName, 
                                           char *value)
    bint 	    MP4SetTrackBytesProperty (MP4FileHandle hFile, 
                                          MP4TrackId trackId, 
                                          char *propName, 
                                          uint8_t *pValue, 
                                        uint32_t valueSize)
    MP4Tags * 	MP4TagsAlloc ()
    void 	    MP4TagsFetch (MP4Tags *tags, MP4FileHandle hFile)
    void 	    MP4TagsStore (MP4Tags *tags, MP4FileHandle hFile)
    void 	    MP4TagsFree (MP4Tags *tags)
    void 	    MP4TagsSetName (MP4Tags *, char *)
    void 	    MP4TagsSetArtist (MP4Tags *, char *)
    void 	    MP4TagsSetAlbumArtist (MP4Tags *, char *)
    void 	    MP4TagsSetAlbum (MP4Tags *, char *)
    void 	    MP4TagsSetGrouping (MP4Tags *, char *)
    void 	    MP4TagsSetComposer (MP4Tags *, char *)
    void 	    MP4TagsSetComments (MP4Tags *, char *)
    void 	    MP4TagsSetGenre (MP4Tags *, char *)
    void 	    MP4TagsSetGenreType (MP4Tags *, uint16_t *)
    void 	    MP4TagsSetReleaseDate (MP4Tags *, char *)
    void 	    MP4TagsSetTrack (MP4Tags *, MP4TagTrack *)
    void 	    MP4TagsSetDisk (MP4Tags *, MP4TagDisk *)
    void 	    MP4TagsSetTempo (MP4Tags *, uint16_t *)
    void 	    MP4TagsSetCompilation (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetTVShow (MP4Tags *, char *)
    void 	    MP4TagsSetTVNetwork (MP4Tags *, char *)
    void 	    MP4TagsSetTVEpisodeID (MP4Tags *, char *)
    void 	    MP4TagsSetTVSeason (MP4Tags *, uint32_t *)
    void 	    MP4TagsSetTVEpisode (MP4Tags *, uint32_t *)
    void 	    MP4TagsSetDescription (MP4Tags *, char *)
    void 	    MP4TagsSetLongDescription (MP4Tags *, char *)
    void 	    MP4TagsSetLyrics (MP4Tags *, char *)
    void 	    MP4TagsSetSortName (MP4Tags *, char *)
    void 	    MP4TagsSetSortArtist (MP4Tags *, char *)
    void 	    MP4TagsSetSortAlbumArtist (MP4Tags *, char *)
    void 	    MP4TagsSetSortAlbum (MP4Tags *, char *)
    void 	    MP4TagsSetSortComposer (MP4Tags *, char *)
    void 	    MP4TagsSetSortTVShow (MP4Tags *, char *)
    void 	    MP4TagsAddArtwork (MP4Tags *, MP4TagArtwork *)
    void 	    MP4TagsSetArtwork (MP4Tags *, uint32_t, MP4TagArtwork *)
    void 	    MP4TagsRemoveArtwork (MP4Tags *, uint32_t)
    void 	    MP4TagsSetCopyright (MP4Tags *, char *)
    void 	    MP4TagsSetEncodingTool (MP4Tags *, char *)
    void 	    MP4TagsSetEncodedBy (MP4Tags *, char *)
    void 	    MP4TagsSetPurchaseDate (MP4Tags *, char *)
    void 	    MP4TagsSetPodcast (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetKeywords (MP4Tags *, char *)
    void 	    MP4TagsSetCategory (MP4Tags *, char *)
    void 	    MP4TagsSetHDVideo (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetMediaType (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetContentRating (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetGapless (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetITunesAccount (MP4Tags *, char *)
    void 	    MP4TagsSetITunesAccountType (MP4Tags *, uint8_t *)
    void 	    MP4TagsSetITunesCountry (MP4Tags *, uint32_t *)
    void 	    MP4TagsSetCNID (MP4Tags *, uint32_t *)
    void 	    MP4TagsSetATID (MP4Tags *, uint32_t *)
    void 	    MP4TagsSetPLID (MP4Tags *, uint64_t *)
    void 	    MP4TagsSetGEID (MP4Tags *, uint32_t *)
    
                
                                    
