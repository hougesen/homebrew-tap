class Kdlfmt < Formula
  desc "A code formatter for kdl documents."
  homepage "https://github.com/hougesen/kdlfmt?tab=readme-ov-file"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.1/kdlfmt-aarch64-apple-darwin.tar.xz"
      sha256 "35762c2817e69eee7060ceefcb11c3674c4de16defb98d31656c941f41ac06ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.1/kdlfmt-x86_64-apple-darwin.tar.xz"
      sha256 "2f65e51320ebed084e0a3186d4c500aee13332e544bf5aaeafbd826aa1cce3ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.1/kdlfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "333f7acc261ea3dcaca3594f7a899289b16c1ae75e736e1ded3190c342fc7286"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.1/kdlfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b913288e1bd7cc873aefa513031cf7da9daef95595533af85ca111a45361dd07"
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
