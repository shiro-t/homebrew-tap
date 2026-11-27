class QemuImg < Formula
  desc "Qemu disk image operator"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-11.1.3.tar.xz"
  sha256 "5a8289c7940dc77d3873c81a6c29ba3afe1446fc9d36e77fa1658cdbecb84b22"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shiro-t/tap"
    rebuild 1
    manifest_sha256 "e86be3016f9bc451398ee290d7ad4f257659f74817b806d3362af8536d51dc77"
    sha256 arm64_tahoe: "4ad56df6a7ec7f6344aae2800a3cc1b7ad61f0d896a7cf36df27b617d5585a92"
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => :build
  depends_on "glib"
  depends_on :macos # >= 3.0 # keep aligned with meson

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  fails_with :clang do
    build 1499
    cause "Requires Xcode Clang 15 or newer"
  end

  deny_network_access!

  def install
    ENV["LIBTOOL"] = "glibtool"

    # Remove wheels unless explicitly permitted. Currently this:
    # * removes `meson` so that brew `meson` is always used
    # * keeps `pycotap` and `qemu_qmp` which are pure-python "none-any" wheels (allowed in homebrew/core)
    rm(Dir["python/wheels/*"] - Dir["python/wheels/{pycotap,qemu_qmp}-*-none-any.whl"])

    # Python 3.15 no longer bundles `wheel` and setuptools builds wheels without it
    inreplace "pythondeps.toml", /^"wheel" = .*\n/, ""

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-user
      --disable-system
      --enable-tools
    ]

    system "./configure", *args
    system "make", "V=1", "qemu-img"
    bin.install "build/qemu-img"
  end

  test do
    archs = %w[
      aarch64
    ]
    archs.each do |_guest_arch|
      assert_match version.to_s, shell_output("#{bin}/qemu-img --version")
    end

    system bin/"qemu-img", "create", "-f", "qcow2", "test.qcow2", "1440k"
    assert_match "file format: qcow2", shell_output("#{bin}/qemu-img info test.qcow2")

    system bin/"qemu-img", "convert", "-O", "raw", "test.qcow2", "test.img"
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info test.img")
  end
end
