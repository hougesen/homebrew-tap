class Kdlfmt < Formula
  desc "A code formatter for kdl documents."
  homepage "https://github.com/hougesen/kdlfmt"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.13/kdlfmt-aarch64-apple-darwin.tar.xz"
      sha256 "f9acc5c6612e76cb134e7516adaa8d2208b56f458dbfaf9354b9c9e707e08b41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.13/kdlfmt-x86_64-apple-darwin.tar.xz"
      sha256 "c6e302fbae3d5f0a8f08072bf16048d887006f80155f5ff7bf9ff194f81556b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.13/kdlfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d4e550e485ee962ff12271248a65ca6c30108bdef5fbbd43ffdee5668de9d81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.13/kdlfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cabd6c3886887f1cb0bdc99561c58f6730220c865d8a663159d87879e1e14183"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "kdlfmt" if OS.mac? && Hardware::CPU.arm?
    bin.install "kdlfmt" if OS.mac? && Hardware::CPU.intel?
    bin.install "kdlfmt" if OS.linux? && Hardware::CPU.arm?
    bin.install "kdlfmt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
