class DeepDive < Formula
  desc "A fast, terminal-based explorer for Docker and OCI image layers."
  homepage "https://github.com/dmikusa/deep-dive"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dmikusa/deep-dive/releases/download/v1.0.0/deep-dive-aarch64-apple-darwin.tar.xz"
      sha256 "063e31caeb4c9f3d7808471cac9528d2b0b89b7d6c7fb4c867f6470ba3f7c782"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dmikusa/deep-dive/releases/download/v1.0.0/deep-dive-x86_64-apple-darwin.tar.xz"
      sha256 "8d460be85b171af54ffd3aa060fac00c5474bf8da09904e1a0d4e0b5002d38ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dmikusa/deep-dive/releases/download/v1.0.0/deep-dive-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20e51143048c17219d60de1f041ac82bbad54c6da79bc5283f66ef4f04d9b581"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dmikusa/deep-dive/releases/download/v1.0.0/deep-dive-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c58256006fe67551727fd4ebb725803323d08701a1e03d17014ece970e1a2f8"
    end
  end
  license "Apache-2.0"

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
    bin.install "deep-dive" if OS.mac? && Hardware::CPU.arm?
    bin.install "deep-dive" if OS.mac? && Hardware::CPU.intel?
    bin.install "deep-dive" if OS.linux? && Hardware::CPU.arm?
    bin.install "deep-dive" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
