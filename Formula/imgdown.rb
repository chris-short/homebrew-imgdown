class Imgdown < Formula
  desc "Download images from URLs found in markdown files"
  homepage "https://github.com/chris-short/imgdown"
  version "0.20260718.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260718.12/imgdown-aarch64-apple-darwin.tar.xz"
      sha256 "9224c26d8d366f7a6f0c0bd05c39189142af5046b3e8f9301677a8fd3cbaae61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260718.12/imgdown-x86_64-apple-darwin.tar.xz"
      sha256 "976c91d85c4449b701a28b6aa98f3019470a1c6ed25dd00a1b3555cd971833aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260718.12/imgdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b70bdd92d3c242526091e031b64bc5f7ba66be4a4dc363699d4e16cb88cd02e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260718.12/imgdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68e04cd94cc8de15ba986c375d17f704503cc9fbff2746029cc0dcd4d2ffdc90"
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
