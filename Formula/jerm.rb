class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  # homepage "http://bsddiary.net/jerm/"
  homepage "https://github.com/shiro-t/jerm"
  url "https://github.com/shiro-t/jerm/releases/download/jerm-8096/jerm-8096.tar.gz"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/shiro-t/tmp"
    rebuild 1
    manifest_sha256 "b1f73d849a3eea683e1da6878010dfddfd5a0844d40e7cf1f9ab6d56afe54782"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3f45774b97f4cd7815ebe8d4f265b5e420f57e49338c19619aa510cbdf4b5850"
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
