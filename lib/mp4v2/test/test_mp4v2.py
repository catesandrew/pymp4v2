import unittest
from nose.tools import raises, assert_equals
from mp4v2.mp4file import *
import os, Image
from datetime import datetime

class TestMP4File(unittest.TestCase):
    def setUp(self):
        data_path = os.path.abspath(os.path.dirname(__file__))
        data_path = os.path.abspath(os.path.join(data_path, "data"))
        test_data = os.path.join(data_path, "Pandora.m4v")
        
        self.mp4 = MP4File(test_data)
        
        # Image contained in the m4v
        self.im = Image.open(os.path.join(data_path, "temp.jpg"))
    def test_info(self):
        expected_info =  'Track\tType\tInfo\n1\tvideo\tH264 High@3.1, 2503.835 secs, 1361 kbps, 960x544 @ 23.976021 fps\n2\taudio\tMPEG-4 AAC LC, 2503.914 secs, 160 kbps, 48000 Hz\n3\taudio\tac-3, 2503.904 secs, 384 kbps, 48000 Hz\n4\ttext\n'
        assert_equals(expected_info, self.mp4.info)
    
    @raises(IOError)
    def test_file_not_found(self):
        MP4File('/path/to/some/fake/data.m4v')

    
    def test_attributes(self):
        
        assert_equals(self.mp4.name, None)
        assert_equals(self.mp4.artist, None)
        assert_equals(self.mp4.albumArtist, None)
        assert_equals(self.mp4.album, None)
        assert_equals(self.mp4.grouping, None)
        assert_equals(self.mp4.composer, 'Andrew Landis,Julia Swift')
        assert_equals(self.mp4.comments, None)
        assert_equals(self.mp4.genre, "Drama")
        assert_equals(self.mp4.genreType, "undefined")
        assert_equals(self.mp4.releaseDate, datetime.strptime("2009-11-20",
                                                              "%Y-%m-%d"))
        assert_equals(self.mp4.track, (None, None))
        assert_equals(self.mp4.disk, (None, None))
        assert_equals(self.mp4.tempo, None)
        assert_equals(self.mp4.compilation, None)
        assert_equals(self.mp4.tvShow, "Smallville")
        assert_equals(self.mp4.tvNetwork, "The CW")
        assert_equals(self.mp4.tvEpisodeID, "909")
        assert_equals(self.mp4.tvSeason, 9)
        assert_equals(self.mp4.tvEpisode, 9)
        assert_equals(self.mp4.description, """Tess kidnaps Lois to find out where Lois went after she disappeared for weeks. Lois's memory of the future depicts a Metropolis under Zod's rule and Clark powerless under the red sun, while Chloe forms a resistance group with Oliver. After learning of these future events, Clark makes an important decision about Zod.""")
        assert_equals(self.mp4.longDescription, """Smallville is a CW drama that follows the trials and tribulations of a young Clark Kent before he became Superman. Smallville is appropriately set in Smallville, Kansas and weaves in tales like Clark Kent\xe2\x80\x99s discovery of power-giving green rocks, his acquaintance with a young Lex Luthor, and his friendship with Chloe Sullivan and Lana Lang.""")
        assert_equals(self.mp4.lyrics, None)
        assert_equals(self.mp4.sortName, None)
        assert_equals(self.mp4.sortArtist, None)
        assert_equals(self.mp4.sortAlbumArtist, None)
        assert_equals(self.mp4.sortAlbum, None)
        assert_equals(self.mp4.sortComposer, None)
        assert_equals(self.mp4.sortTVShow, None)
        # Just tests to make sure we get a PIL image type until I can add
        # out a more accurate test of equivalence. 
        assert_equals(type(self.mp4.artwork[0]), type(self.im))
        assert_equals(self.mp4.artworkCount, 1) # due to bug in 1.9.1 this is always 1
        assert_equals(self.mp4.copyright, None)
        assert_equals(self.mp4.encodingTool, 'HandBrake svn2877 2009101201')
        assert_equals(self.mp4.encodedBy, None)
        assert_equals(self.mp4.purchaseDate, None)
        assert_equals(self.mp4.podcast, None)
        assert_equals(self.mp4.keywords, None)
        assert_equals(self.mp4.category, None)
        assert_equals(self.mp4.hdVideo, None)
        assert_equals(self.mp4.mediaType, "TV Show")
        assert_equals(self.mp4.contentRating, None)
        assert_equals(self.mp4.gapless, None)
        assert_equals(self.mp4.iTunesAccount, None)
        assert_equals(self.mp4.iTunesAccountType, None)
        assert_equals(self.mp4.iTunesCountry, None)
