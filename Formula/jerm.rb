# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jerm < Formula
  #desc "シリアル通信プログラム"
  desc "Communication terminal through serial and TCP/IP interfaces"
  # homepage "http://bsddiary.net/jerm/"
  homepage "https://github.com/shiro-t/jerm"
  url "https://github.com/shiro-t/jerm/releases/download/jerm-8096/jerm-8096.tar.gz"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"
  version "8096"
  license "BSD-2-Clause"

  deny_network_access!

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end
end
