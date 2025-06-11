class Hitt < Formula
  desc "Command line HTTP testing tool focused on speed and simplicity"
  homepage "https://hitt.mhouge.dk"
  version "0.0.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.20/hitt-aarch64-apple-darwin.tar.gz"
      sha256 "6dad182398bc6a7c29306edca6446a4ce8238eb34d7ccf4784e435a729bec4b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.20/hitt-x86_64-apple-darwin.tar.gz"
      sha256 "f02a7fca1d75cbabaa9c414b54a1ef3e1d6d7144b62517731dff533e4e04d232"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/hitt/releases/download/v0.0.20/hitt-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b1250781502297d8e73fbc242745b543def8c789d1ce8dc0023eb0f7a6ff477e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "hitt" if OS.mac? && Hardware::CPU.arm?
    bin.install "hitt" if OS.mac? && Hardware::CPU.intel?
    bin.install "hitt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
