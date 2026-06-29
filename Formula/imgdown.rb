class Imgdown < Formula
  desc "Download images from URLs found in markdown files"
  homepage "https://github.com/chris-short/imgdown"
  version "0.20260629.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.7/imgdown-aarch64-apple-darwin.tar.xz"
      sha256 "f4b86707dc2002dc5d49de2ae93cd6f3666869958ffbd44cfcfa1f80708f8bbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.7/imgdown-x86_64-apple-darwin.tar.xz"
      sha256 "a962f86bd796bf03c70878635042a6552d36bd5f468b6f0f5aefb43fa9de9afa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.7/imgdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efdbf03ecba5d9f276718eea4b074b7937d314a0c96c205facf8b8cec4d33a2d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.7/imgdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "efb9583ad544025650fe901ef4a6682c073a1bcba1bc9f5abed9bafdba8ad9fb"
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
