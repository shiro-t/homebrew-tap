class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  ## homepage "http://bsddiary.net/jerm/"
  homepage "https://github.com/shiro-t/jerm"
  url "https://github.com/shiro-t/jerm/releases/download/jerm-8096/jerm-8096.tar.gz"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/shiro-t/tap"
    rebuild 1
    manifest_sha256 "4f8b154ee49da24cc7b624af19134cf976862cdfe6c4b6a618ad581b25360eb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0fe1aa220eac1c8aa6cafad3399077275427c2d34c0a4e39b821e34f1de5fff2"
  end

  depends_on :macos

  deny_network_access!

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end

  test do
    assert_path_exists bin/"jerm"
  end
end
