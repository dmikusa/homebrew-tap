class BindingTool < Formula
  desc "Generate Kubernetes service bindings for use with Cloud Native Buildpacks"
  homepage "https://github.com/dmikusa/binding-tool"
  version "1.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dmikusa/binding-tool/releases/download/v1.23.0/binding_tool-aarch64-apple-darwin.tar.xz"
      sha256 "cb766a2feba0a6caf2f6949619758825ae4873d66109e66da2f778bebb407c06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dmikusa/binding-tool/releases/download/v1.23.0/binding_tool-x86_64-apple-darwin.tar.xz"
      sha256 "33c6872cc78e3b8e68953568ae9692d91b33384a6a91ad867d94423aee413399"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dmikusa/binding-tool/releases/download/v1.23.0/binding_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "12cbb870fd4d086b92e81a47a31aeb5f42ca1df80c01ab79cec75023ab95674f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dmikusa/binding-tool/releases/download/v1.23.0/binding_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "39e7b61859c46589244b880e737fa86d520d79ac631105d29a81789b559bb5ad"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "bt" if OS.mac? && Hardware::CPU.arm?
    bin.install "bt" if OS.mac? && Hardware::CPU.intel?
    bin.install "bt" if OS.linux? && Hardware::CPU.arm?
    bin.install "bt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
