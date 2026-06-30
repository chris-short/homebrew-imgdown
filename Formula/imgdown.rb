class Imgdown < Formula
  desc "Download images from URLs found in markdown files"
  homepage "https://github.com/chris-short/imgdown"
  version "0.20260630.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260630.8/imgdown-aarch64-apple-darwin.tar.xz"
      sha256 "35fd3cfc91da95e575108d11b2d672d54525f38c6f57ca09eea3c006864a217e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260630.8/imgdown-x86_64-apple-darwin.tar.xz"
      sha256 "bcd68b6fedbdf03e6c621cd3631b0e12305d6b1685cbfc25f7a78fe6c65bf01e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260630.8/imgdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c814e31023475acd1c3644f50febbf5d1fe77b60480577f9cc25810e6765aca5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260630.8/imgdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f3eb15f4fe13d7f6932baadd39ee7dac03ef95ef1f457366b78e3e7d249a7be"
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
