class Kdlfmt < Formula
  desc "A code formatter for kdl documents."
  homepage "https://github.com/hougesen/kdlfmt"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.14/kdlfmt-aarch64-apple-darwin.tar.xz"
      sha256 "3d1cdad4df90e16be3f1ac7d886927a6721a9b7b2f955039736fe8ea14733c1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.14/kdlfmt-x86_64-apple-darwin.tar.xz"
      sha256 "9d6c13e1f8ab0bfc867e12ef92b9c9a3675a18cc8c15e26beb6a2b51634b00d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.14/kdlfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3698672dbdc4e67f00b3760e94d06da57c9664549ad337073fe4dbbec84bbe2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.0.14/kdlfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11affce7c928607dd9a6102cabe0cb6c1c324dd6d037e33c9801c76346832a26"
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
