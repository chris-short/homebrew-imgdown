class Imgdown < Formula
  desc "Download images from URLs found in markdown files"
  homepage "https://github.com/chris-short/imgdown"
  version "0.20260629.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.5/imgdown-aarch64-apple-darwin.tar.xz"
      sha256 "75726cb6c5f376bf839c8660518cd095e4cb07edcd2341a39b2b0d16aa037103"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.5/imgdown-x86_64-apple-darwin.tar.xz"
      sha256 "c840549c6b600635b7b670bb6a48e973d813502634a38f3a619c94c949712265"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.5/imgdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2fb79f8004f355134867dc4475c8ba2f5adc12c3cee429dbb7f0befa6fee1a8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chris-short/imgdown/releases/download/v0.20260629.5/imgdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "443f1d7b6c64b0adae50fad66b9f85ed8c3b2e217fc856021a0173ee65d0522c"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
