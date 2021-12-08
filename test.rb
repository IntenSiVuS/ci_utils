describe file('/usr/local/bin/terraform') do
  it { should be_executable }
end

describe file('/usr/local/bin/aws') do
  it { should be_executable }
end

pip_packages = [
  'pyhcl',
  'ansible',
  'boto3',
]

pip_packages.each do | pkg|
  describe pip(pkg) do
    it { should be_installed }
  end
end
