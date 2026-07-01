class Imgdown < Formula
  desc "Download images from URLs found in markdown files"
  homepage "https://github.com/chris-short/imgdown"
  version "0.20260701.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260701.9/imgdown-aarch64-apple-darwin.tar.xz"
      sha256 "ab0ccc82ca1aeb7a837c65b159502104ace007229979bd00354c0e561829a135"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260701.9/imgdown-x86_64-apple-darwin.tar.xz"
      sha256 "692cc0c145ab21d37dfab0ffc95716082c2c604659bb99112478228126f74ee7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260701.9/imgdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b92c7be03f6887459cef12d4c48d2cafb905d7b4a97ddc4c93e74954cea143ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260701.9/imgdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81345f772f2d5f7c00dfe228affced6e7a396cb0f64e3efaf0ceb92daf3b5ae3"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "imgdown" if OS.mac? && Hardware::CPU.arm?
    bin.install "imgdown" if OS.mac? && Hardware::CPU.intel?
    bin.install "imgdown" if OS.linux? && Hardware::CPU.arm?
    bin.install "imgdown" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
