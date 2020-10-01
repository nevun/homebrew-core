class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://github.com/Yubico/yubikey-personalization", :using => :git, :revison => 'b16b84ffeec1ea8a9ba369c91d19119f5e802682'
  license "BSD-2-Clause"
  version '1.21rc'

  livecheck do
    url "https://developers.yubico.com/yubikey-personalization/Releases/"
    regex(/href=.*?ykpers[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
#    sha256 "f5615ed1ad958e10d5908c16feb53bc706fd42f7721d0e8cfd3ea8dd4658a221" => :catalina
#    sha256 "1cd502d61459515ab043d2cd8d2d8df3d97f605578766934312fa53343a619ec" => :mojave
#    sha256 "215538176c67853276fe86e6894d6a19be95323d236175c5e4a84b4ce73b39d6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libyubikey"
  depends_on "automake"
  depends_on "libtool"
  depends_on "asciidoc"
  depends_on "docbook-xsl"

  on_linux do
    depends_on "libusb"
  end

  def install
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "autoreconf", "--install"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make", "check", "XML_CATALOG_FILES=#{HOMEBREW_PREFIX}/etc/xml/catalog"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
