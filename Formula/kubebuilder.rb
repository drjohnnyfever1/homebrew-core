class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v2.3.2",
      revision: "5da27b892ae310e875c8719d94a5a04302c597d0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c34a138dbc1aaba1d5d311d536380e6a68773d126fb06e034a9f4a89f811aa2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "454a6e3ea94ed342b13768292a465b80d6b39450cd9bcf71a1d5576aec493f14"
    sha256 cellar: :any_skip_relocation, catalina:      "34b4cc95b3a1506ab217000a44373b4615849658cdbbf21d8cc4392f747a7806"
    sha256 cellar: :any_skip_relocation, mojave:        "ef1e51ec7876df398dcac8b1c11abc17e83f030e3fe10efa30458f94bdb2c469"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.buildDate=#{Time.now.iso8601}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "./cmd"
    prefix.install_metafiles
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "#{bin}/kubebuilder", "init",
        "--repo=github.com/example/example-repo", "--domain=example.com",
        "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
    end
  end
end
