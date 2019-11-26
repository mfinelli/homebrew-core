class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-3.10.1.tar.bz2"
    sha256 "8366e840bb3c9448c2cf0cf9a0800155b0bd7cc212a28ba44990c3d2289c6b93"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-3.10.1.tar.bz2"
      sha256 "eec3177631f99729bf0e94223b627406cc648c70e6646e35613c7b55040a2642"
    end
  end

  bottle do
    rebuild 1
    sha256 "9dbef45b266c5978d4b5ef08eaf5ab48d91b927cf6e25976ff67de031b0b76aa" => :catalina
    sha256 "a3cc36beec2b0456f1cc2e5640bf127867820ae574a7a4b3a417bbc8cd5ce1d8" => :mojave
    sha256 "4cc10fd5a8a28cf497c637a90ee4af7f835aa7d8e46cab02de1073a49d143699" => :high_sierra
    sha256 "effe340c0314c54baf2aab58ce010e16e720f75fe199bac6acbf895ceb4fc28e" => :sierra
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libnotify"
  depends_on "libsamplerate"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "python@2"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-coreaudio
      --disable-gtk
      --disable-mpris2
      --enable-mac-media-keys
      --enable-qt
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("plugins").stage do
      ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./autogen.sh" if build.head?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    audtool does not work due to a broken dbus implementation on macOS, so is not built
    coreaudio output has been disabled as it does not work (Fails to set audio unit input property.)
    GTK+ gui is not built by default as the QT gui has better integration with macOS, and when built, the gtk gui takes precedence
  EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
