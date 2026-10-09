class Dtools < Formula
  desc "Collection of command-line tools for managing personal machines"
  homepage "https://github.com/drusellers/dtools"
  url "https://github.com/drusellers/dtools/releases/download/v2026.10.09.004054-32eef05/dtools-v2026.10.09.004054-32eef05.tar.gz"
  version "2026.10.09.004054-32eef05"
  sha256 "c33ae87eec5a84be3303e77bbe1069eeb6b2fad176f8a38e16fcd1bb74727513"
  license "Apache-2.0"
  head "https://github.com/drusellers/dtools.git", branch: "main"

  depends_on "node"

  def install
    bin.install "bin/dnet"
    libexec.install "libexec/dnet", "libexec/dask", "libexec/dmail"
    doc.install "README.md", "AGENTS.md", "LICENSE"
    pkgshare.install "examples"

    # Use the declared dependency even when another Node comes first on PATH.
    (bin/"dask").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dask/ask.mjs" "$@"
    SH
    (bin/"dask").chmod 0755

    (bin/"dmail").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dmail/mail.mjs" "$@"
    SH
    (bin/"dmail").chmod 0755
  end

  test do
    assert_match "dnet (dtools)", shell_output("#{bin}/dnet --version")
    assert_path_exists libexec/"dnet/netcheck"
    assert_match "dask", shell_output("#{bin}/dask --help")
    assert_path_exists libexec/"dask/index.html"
    assert_path_exists libexec/"dask/app.js"
    assert_path_exists libexec/"dask/style.css"
    assert_match "dmail login", shell_output("#{bin}/dmail --help")
    assert_path_exists libexec/"dmail/mail.mjs"

    (testpath/"questions.json").write <<~JSON
      {
        "questions": [{
          "id": "test",
          "prompt": "Does the installed server start?",
          "options": [{ "id": "yes", "label": "Yes" }]
        }]
      }
    JSON
    output = shell_output("#{bin}/dask ask #{testpath}/questions.json --no-open --timeout 1")
    assert_equal({ "status" => "cancelled", "reason" => "timeout" }, JSON.parse(output))
  end
end
