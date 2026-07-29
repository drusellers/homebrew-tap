class Dtools < Formula
  desc "Collection of command-line tools for managing personal machines"
  homepage "https://github.com/drusellers/dtools"
  url "https://github.com/drusellers/dtools/releases/download/v2026.07.29.135058-aa28d9b/dtools-v2026.07.29.135058-aa28d9b.tar.gz"
  version "2026.07.29.135058-aa28d9b"
  sha256 "c77703e963186356b8c3e5cf2930946dcb171e84cfea1be8d5f2dbcff10e4b9d"
  head "https://github.com/drusellers/dtools.git", branch: "main"

  def install
    bin.install Dir["bin/*"]
    libexec.install "libexec/dnet"
  end

  test do
    assert_match "dnet (dtools)", shell_output("#{bin}/dnet --version")
    assert_path_exists libexec/"dnet/netcheck"
  end
end
